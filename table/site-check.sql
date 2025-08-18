-- SQL для создания таблицы логов проверки сайтов
-- Файл: database/site_check_logs.sql

CREATE TABLE IF NOT EXISTS site_check_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    url VARCHAR(512) NOT NULL COMMENT 'URL проверяемого сайта',
    ip_address VARCHAR(45) NOT NULL COMMENT 'IP адрес пользователя',
    user_agent TEXT COMMENT 'User Agent браузера',
    results_json JSON COMMENT 'Результаты проверки в JSON формате',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания записи',
    
    -- Индексы для оптимизации
    INDEX idx_ip_time (ip_address, created_at) COMMENT 'Индекс для rate limiting',
    INDEX idx_url (url(100)) COMMENT 'Индекс для поиска по URL',
    INDEX idx_created (created_at) COMMENT 'Индекс для сортировки по времени'
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci 
  COMMENT='Логи проверки доступности сайтов';

-- Дополнительные таблицы для расширенного функционала

-- Таблица для хранения настроек мониторинга
CREATE TABLE IF NOT EXISTS site_monitors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL COMMENT 'ID пользователя (NULL для анонимных)',
    url VARCHAR(512) NOT NULL COMMENT 'URL для мониторинга',
    check_interval INT DEFAULT 300 COMMENT 'Интервал проверки в секундах',
    locations JSON COMMENT 'Массив локаций для проверки',
    email_notifications BOOLEAN DEFAULT FALSE COMMENT 'Включены ли email уведомления',
    webhook_url VARCHAR(512) NULL COMMENT 'URL для webhook уведомлений',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Активен ли мониторинг',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_user (user_id),
    INDEX idx_active (is_active),
    INDEX idx_next_check (created_at, check_interval)
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci 
  COMMENT='Настройки мониторинга сайтов';

-- Таблица для хранения результатов мониторинга
CREATE TABLE IF NOT EXISTS site_monitor_results (
    id INT AUTO_INCREMENT PRIMARY KEY,
    monitor_id INT NOT NULL COMMENT 'ID записи мониторинга',
    location VARCHAR(50) NOT NULL COMMENT 'Локация проверки',
    status_code INT NULL COMMENT 'HTTP статус код',
    response_time INT NULL COMMENT 'Время ответа в миллисекундах',
    error_message TEXT NULL COMMENT 'Сообщение об ошибке если есть',
    is_up BOOLEAN NOT NULL COMMENT 'Доступен ли сайт',
    checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Время проверки',
    
    FOREIGN KEY (monitor_id) REFERENCES site_monitors(id) ON DELETE CASCADE,
    INDEX idx_monitor_time (monitor_id, checked_at),
    INDEX idx_location (location),
    INDEX idx_status (is_up, checked_at)
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci 
  COMMENT='Результаты мониторинга сайтов';

-- Таблица для алертов и уведомлений
CREATE TABLE IF NOT EXISTS site_alerts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    monitor_id INT NOT NULL COMMENT 'ID записи мониторинга',
    alert_type ENUM('down', 'slow', 'ssl_expiring', 'ssl_expired') NOT NULL COMMENT 'Тип алерта',
    message TEXT NOT NULL COMMENT 'Сообщение алерта',
    is_resolved BOOLEAN DEFAULT FALSE COMMENT 'Решен ли алерт',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL COMMENT 'Время решения алерта',
    
    FOREIGN KEY (monitor_id) REFERENCES site_monitors(id) ON DELETE CASCADE,
    INDEX idx_monitor_type (monitor_id, alert_type),
    INDEX idx_unresolved (is_resolved, created_at)
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci 
  COMMENT='Алерты и уведомления';

-- Настройки для автоматической очистки старых логов
-- Удаление логов старше 30 дней (запускать в cron)
-- DELETE FROM site_check_logs WHERE created_at < DATE_SUB(NOW(), INTERVAL 30 DAY);

-- Удаление результатов мониторинга старше 90 дней
-- DELETE FROM site_monitor_results WHERE checked_at < DATE_SUB(NOW(), INTERVAL 90 DAY);

-- Представления для удобства работы с данными

-- Статистика по популярным сайтам
CREATE OR REPLACE VIEW popular_checked_sites AS
SELECT 
    SUBSTRING_INDEX(SUBSTRING_INDEX(url, '/', 3), '//', -1) as domain,
    COUNT(*) as check_count,
    AVG(JSON_EXTRACT(results_json, '$.locations[0].response_time')) as avg_response_time,
    MAX(created_at) as last_checked
FROM site_check_logs 
WHERE created_at > DATE_SUB(NOW(), INTERVAL 7 DAY)
  AND JSON_VALID(results_json)
GROUP BY domain
ORDER BY check_count DESC
LIMIT 100;

-- Статистика по локациям
CREATE OR REPLACE VIEW location_stats AS
SELECT 
    JSON_UNQUOTE(JSON_EXTRACT(location_data.value, '$.location')) as location,
    COUNT(*) as checks_count,
    AVG(JSON_EXTRACT(location_data.value, '$.response_time')) as avg_response_time,
    SUM(CASE WHEN JSON_EXTRACT(location_data.value, '$.status_code') BETWEEN 200 AND 299 THEN 1 ELSE 0 END) as success_count
FROM site_check_logs
CROSS JOIN JSON_TABLE(
    JSON_EXTRACT(results_json, '$.locations'),
    '$[*]' COLUMNS (
        row_id FOR ORDINALITY,
        value JSON PATH '$'
    )
) as location_data
WHERE created_at > DATE_SUB(NOW(), INTERVAL 24 HOUR)
  AND JSON_VALID(results_json)
GROUP BY location;

-- Индексы для JSON полей (MySQL 8.0+)
-- ALTER TABLE site_check_logs ADD INDEX idx_response_time ((CAST(JSON_EXTRACT(results_json, '$.locations[0].response_time') AS SIGNED)));
-- ALTER TABLE site_check_logs ADD INDEX idx_status_code ((CAST(JSON_EXTRACT(results_json, '$.locations[0].status_code') AS SIGNED)));

-- Процедура для очистки старых данных
DELIMITER //
CREATE PROCEDURE CleanOldSiteCheckData()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Удаляем логи старше 30 дней
    DELETE FROM site_check_logs 
    WHERE created_at < DATE_SUB(NOW(), INTERVAL 30 DAY);
    
    -- Удаляем результаты мониторинга старше 90 дней
    DELETE FROM site_monitor_results 
    WHERE checked_at < DATE_SUB(NOW(), INTERVAL 90 DAY);
    
    -- Удаляем решенные алерты старше 7 дней
    DELETE FROM site_alerts 
    WHERE is_resolved = TRUE 
      AND resolved_at < DATE_SUB(NOW(), INTERVAL 7 DAY);
    
    COMMIT;
    
    SELECT 'Data cleanup completed successfully' as result;
END //
DELIMITER ;

-- Функция для получения статистики сайта
DELIMITER //
CREATE FUNCTION GetSiteStats(site_url VARCHAR(512))
RETURNS JSON
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE result JSON;
    
    SELECT JSON_OBJECT(
        'total_checks', COUNT(*),
        'avg_response_time', ROUND(AVG(JSON_EXTRACT(results_json, '$.locations[0].response_time')), 2),
        'success_rate', ROUND(
            SUM(CASE WHEN JSON_EXTRACT(results_json, '$.locations[0].status_code') BETWEEN 200 AND 299 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
            2
        ),
        'last_check', MAX(created_at)
    ) INTO result
    FROM site_check_logs 
    WHERE url = site_url 
      AND created_at > DATE_SUB(NOW(), INTERVAL 30 DAY)
      AND JSON_VALID(results_json);
    
    RETURN COALESCE(result, JSON_OBJECT('error', 'No data found'));
END //
DELIMITER ;