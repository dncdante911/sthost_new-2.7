CREATE TABLE hosting_plans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(64) NOT NULL,
    price INT NOT NULL,
    currency VARCHAR(8) DEFAULT '₴',
    disk VARCHAR(32),
    sites INT,
    email INT,
    db INT,
    description TEXT,
    features TEXT,
    is_active TINYINT(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


INSERT INTO hosting_plans (title, price, disk, sites, email, db, description, features)
VALUES
('START', 29, '5 ГБ SSD', 1, 5, 2, 'Початковий тариф', 'DirectAdmin; SSL; PHP 8.x; Backups'),
('BIZ', 59, '20 ГБ SSD', 10, 20, 10, 'Оптимальний для бізнесу', 'DirectAdmin; SSL; PHP 8.x; Backups; Git; SSH'),
('PRO', 109, '50 ГБ SSD', 50, 50, 50, 'Максимум можливостей', 'DirectAdmin; SSL; PHP 8.x; Backups; Git; SSH; Cron');
