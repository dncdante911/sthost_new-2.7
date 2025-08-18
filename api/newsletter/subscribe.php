<?php
/**
 * StormHosting UA - API для подписки на новости
 * Файл: /api/newsletter/subscribe.php
 */

// Защита от прямого доступа
if (!defined('SECURE_ACCESS')) {
    define('SECURE_ACCESS', true);
}

// Устанавливаем заголовки для JSON API
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type, X-Requested-With');

// Обработка preflight запросов
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Проверяем метод запроса
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode([
        'success' => false,
        'message' => 'Дозволений тільки POST метод'
    ]);
    exit;
}

// Подключение к базе данных
try {
    if (file_exists(__DIR__ . '/../../includes/config.php')) {
        require_once __DIR__ . '/../../includes/config.php';
    }
    if (file_exists(__DIR__ . '/../../includes/db_connect.php')) {
        require_once __DIR__ . '/../../includes/db_connect.php';
    }
} catch (Exception $e) {
    error_log('Newsletter API DB connection error: ' . $e->getMessage());
}

/**
 * Функция для валидации email
 */
function validateEmail($email) {
    return filter_var($email, FILTER_VALIDATE_EMAIL) !== false;
}

/**
 * Функция для проверки существования email в базе
 */
function emailExists($email, $pdo = null) {
    if (!$pdo) return false;
    
    try {
        $stmt = $pdo->prepare("SELECT id FROM newsletter_subscribers WHERE email = ? AND status = 'active'");
        $stmt->execute([$email]);
        return $stmt->rowCount() > 0;
    } catch (PDOException $e) {
        error_log('Newsletter email check error: ' . $e->getMessage());
        return false;
    }
}

/**
 * Функция для добавления email в базу подписчиков
 */
function addSubscriber($email, $pdo = null) {
    if (!$pdo) {
        // Fallback: логируем подписку в файл
        $logFile = __DIR__ . '/../../logs/newsletter_subscribers.log';
        $logDir = dirname($logFile);
        
        if (!is_dir($logDir)) {
            mkdir($logDir, 0755, true);
        }
        
        $logEntry = date('Y-m-d H:i:s') . " - New subscriber: " . $email . " (IP: " . $_SERVER['REMOTE_ADDR'] . ")\n";
        file_put_contents($logFile, $logEntry, FILE_APPEND | LOCK_EX);
        
        return true;
    }
    
    try {
        $token = bin2hex(random_bytes(32));
        $stmt = $pdo->prepare("
            INSERT INTO newsletter_subscribers (email, token, ip_address, user_agent, created_at) 
            VALUES (?, ?, ?, ?, NOW())
            ON DUPLICATE KEY UPDATE 
                updated_at = NOW(),
                status = 'pending',
                token = VALUES(token)
        ");
        
        $result = $stmt->execute([
            $email,
            $token,
            $_SERVER['REMOTE_ADDR'] ?? 'unknown',
            $_SERVER['HTTP_USER_AGENT'] ?? 'unknown'
        ]);
        
        if ($result) {
            // Здесь можно добавить отправку email подтверждения
            sendConfirmationEmail($email, $token);
            return true;
        }
        
        return false;
    } catch (PDOException $e) {
        error_log('Newsletter subscription error: ' . $e->getMessage());
        return false;
    }
}

/**
 * Функция для отправки email подтверждения
 */
function sendConfirmationEmail($email, $token) {
    // Базовая реализация отправки email
    // В продакшене заменить на реальную отправку через SMTP
    
    $subject = 'Підтвердження підписки - StormHosting UA';
    $confirmUrl = (isset($_SERVER['HTTPS']) ? 'https' : 'http') . '://' . $_SERVER['HTTP_HOST'] . 
                  '/api/newsletter/confirm.php?token=' . $token;
    
    $message = "
    <html>
    <head>
        <meta charset='UTF-8'>
        <title>Підтвердження підписки</title>
    </head>
    <body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333;'>
        <div style='max-width: 600px; margin: 0 auto; padding: 20px;'>
            <h2 style='color: #667eea;'>Підтвердження підписки</h2>
            <p>Дякуємо за підписку на новини StormHosting UA!</p>
            <p>Для підтвердження підписки натисніть на кнопку нижче:</p>
            <p style='text-align: center; margin: 30px 0;'>
                <a href='{$confirmUrl}' style='
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                    padding: 12px 30px;
                    text-decoration: none;
                    border-radius: 25px;
                    display: inline-block;
                    font-weight: 600;
                '>Підтвердити підписку</a>
            </p>
            <p style='font-size: 12px; color: #666;'>
                Якщо кнопка не працює, скопіюйте це посилання в браузер:<br>
                <a href='{$confirmUrl}'>{$confirmUrl}</a>
            </p>
            <hr style='margin: 30px 0; border: none; border-top: 1px solid #eee;'>
            <p style='font-size: 12px; color: #666;'>
                StormHosting UA - Надійний хостинг для вашого бізнесу<br>
                Якщо ви не підписувалися на наші новини, просто ігноруйте цей лист.
            </p>
        </div>
    </body>
    </html>
    ";
    
    $headers = [
        'MIME-Version: 1.0',
        'Content-type: text/html; charset=UTF-8',
        'From: StormHosting UA <noreply@stormhosting.ua>',
        'Reply-To: support@stormhosting.ua',
        'X-Mailer: PHP/' . phpversion()
    ];
    
    // В продакшене заменить на PHPMailer или другую библиотеку
    $sent = mail($email, $subject, $message, implode("\r\n", $headers));
    
    if (!$sent) {
        error_log("Failed to send confirmation email to: $email");
    }
    
    return $sent;
}

/**
 * Rate limiting - простая защита от спама
 */
function checkRateLimit($ip) {
    $cacheFile = __DIR__ . '/../../cache/newsletter_rate_' . md5($ip) . '.tmp';
    $cacheDir = dirname($cacheFile);
    
    if (!is_dir($cacheDir)) {
        mkdir($cacheDir, 0755, true);
    }
    
    if (file_exists($cacheFile)) {
        $lastRequest = filemtime($cacheFile);
        if (time() - $lastRequest < 60) { // 1 минута между запросами
            return false;
        }
    }
    
    touch($cacheFile);
    return true;
}

// ============================================================================
// ОСНОВНАЯ ЛОГИКА API
// ============================================================================

try {
    // Получение данных из запроса
    $input = file_get_contents('php://input');
    $data = json_decode($input, true);
    
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception('Невірний JSON формат');
    }
    
    // Проверка наличия email
    if (!isset($data['email']) || empty(trim($data['email']))) {
        throw new Exception('Email адрес обов\'язковий');
    }
    
    $email = trim(strtolower($data['email']));
    
    // Валидация email
    if (!validateEmail($email)) {
        throw new Exception('Невірний формат email адреси');
    }
    
    // Rate limiting
    $clientIP = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
    if (!checkRateLimit($clientIP)) {
        throw new Exception('Забагато запитів. Спробуйте через хвилину.');
    }
    
    // Проверка на существование подписки
    $pdo = isset($pdo) ? $pdo : null;
    if (emailExists($email, $pdo)) {
        // Отправляем успешный ответ даже если email уже существует
        // для предотвращения определения существующих email адресов
        echo json_encode([
            'success' => true,
            'message' => 'Підписка оформлена! Перевірте ваш email для підтвердження.'
        ]);
        exit;
    }
    
    // Добавление подписчика
    $result = addSubscriber($email, $pdo);
    
    if ($result) {
        echo json_encode([
            'success' => true,
            'message' => 'Підписка оформлена! Перевірте ваш email для підтвердження.'
        ]);
    } else {
        throw new Exception('Помилка при збереженні підписки');
    }
    
} catch (Exception $e) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage()
    ]);
    
    // Логирование ошибки
    error_log('Newsletter API Error: ' . $e->getMessage() . ' | IP: ' . ($_SERVER['REMOTE_ADDR'] ?? 'unknown'));
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Внутрішня помилка сервера'
    ]);
    
    // Логирование критической ошибки
    error_log('Newsletter API Critical Error: ' . $e->getMessage() . ' | File: ' . $e->getFile() . ' | Line: ' . $e->getLine());
}
?>