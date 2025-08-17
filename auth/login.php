<?php
define('SECURE_ACCESS', true);
require_once $_SERVER['DOCUMENT_ROOT'] . '/includes/config.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/includes/db_connect.php';

// Обработка AJAX авторизации
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'login') {
    $response = ['success' => false, 'message' => '', 'errors' => []];
    
    try {
        // CSRF защита
        $csrf_token = $_POST['csrf_token'] ?? '';
        if (!validateCSRFToken($csrf_token)) {
            throw new Exception('Невірний токен безпеки');
        }
        
        // Получение данных
        $email = filter_var(trim($_POST['email'] ?? ''), FILTER_VALIDATE_EMAIL);
        $password = $_POST['password'] ?? '';
        $remember_me = !empty($_POST['remember_me']);
        
        // Валидация
        if (!$email) {
            $response['errors']['email'] = 'Введіть коректну email адресу';
        }
        
        if (empty($password)) {
            $response['errors']['password'] = 'Введіть пароль';
        }
        
        // Проверка rate limiting
        $client_ip = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
        $login_attempts = DatabaseConnection::fetchOne(
            "SELECT attempts, locked_until FROM login_attempts WHERE ip_address = ? OR email = ?",
            [$client_ip, $email]
        );
        
        if ($login_attempts && $login_attempts['locked_until'] && strtotime($login_attempts['locked_until']) > time()) {
            $lockout_minutes = ceil((strtotime($login_attempts['locked_until']) - time()) / 60);
            throw new Exception("Забагато невдалих спроб входу. Спробуйте через {$lockout_minutes} хвилин.");
        }
        
        // Если есть ошибки валидации, возвращаем их
        if (!empty($response['errors'])) {
            $response['message'] = 'Будь ласка, виправте помилки у формі';
            header('Content-Type: application/json');
            echo json_encode($response);
            exit;
        }
        
        // Проверяем пользователя в БД
        $user = DatabaseConnection::fetchOne(
            "SELECT id, email, password, full_name, language, is_active, fossbilling_client_id FROM users WHERE email = ?",
            [$email]
        );
        
        if (!$user || !password_verify($password, $user['password'])) {
            // Записываем неудачную попытку
            recordLoginAttempt($client_ip, $email, false);
            throw new Exception('Невірний email або пароль');
        }
        
        if (!$user['is_active']) {
            throw new Exception('Ваш обліковий запис деактивовано. Зверніться до підтримки.');
        }
        
        // Успешная авторизация
        recordLoginAttempt($client_ip, $email, true);
        
        // Обновляем время последнего входа
        DatabaseConnection::execute(
            "UPDATE users SET last_login = NOW() WHERE id = ?",
            [$user['id']]
        );
        
        // Устанавливаем сессию
        $_SESSION['user_id'] = $user['id'];
        $_SESSION['user_email'] = $user['email'];
        $_SESSION['user_name'] = $user['full_name'];
        $_SESSION['user_language'] = $user['language'];
        $_SESSION['is_logged_in'] = true;
        $_SESSION['fossbilling_client_id'] = $user['fossbilling_client_id'];
        
        // Если выбрано "Запомнить меня"
        if ($remember_me) {
            $token = bin2hex(random_bytes(32));
            setcookie('remember_token', $token, time() + (30 * 24 * 60 * 60), '/', '', true, true); // 30 дней
            
            // Сохраняем токен в БД
            try {
                DatabaseConnection::insert(
                    "INSERT INTO remember_tokens (user_id, token, expires_at) VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 30 DAY))",
                    [$user['id'], hash('sha256', $token)]
                );
            } catch (Exception $e) {
                // Игнорируем ошибку с remember token, не критично
                error_log('Remember token error: ' . $e->getMessage());
            }
        }
        
        // Логируем успешный вход
        DatabaseConnection::insert(
            "INSERT INTO security_logs (ip_address, user_id, action, details, severity) VALUES (?, ?, ?, ?, ?)",
            [
                $client_ip,
                $user['id'],
                'user_login',
                'Успішний вхід в систему',
                'low'
            ]
        );
        
        $response['success'] = true;
        $response['message'] = 'Авторизація успішна!';
        $response['redirect'] = '/client/dashboard.php';
        
    } catch (Exception $e) {
        $response['message'] = $e->getMessage();
        
        // Логируем ошибку
        error_log('Login error: ' . $e->getMessage());
    }
    
    header('Content-Type: application/json');
    echo json_encode($response);
    exit;
}

// Функция записи попыток входа
function recordLoginAttempt($ip, $email, $success) {
    try {
        if ($success) {
            // Удаляем записи о неудачных попытках
            DatabaseConnection::execute(
                "DELETE FROM login_attempts WHERE ip_address = ? OR email = ?",
                [$ip, $email]
            );
        } else {
            // Увеличиваем счетчик попыток
            $existing = DatabaseConnection::fetchOne(
                "SELECT id, attempts FROM login_attempts WHERE ip_address = ? OR email = ?",
                [$ip, $email]
            );
            
            if ($existing) {
                $new_attempts = $existing['attempts'] + 1;
                $locked_until = null;
                
                // Блокировка после 5 попыток на 15 минут
                if ($new_attempts >= 5) {
                    $locked_until = date('Y-m-d H:i:s', time() + 900); // 15 минут
                }
                
                DatabaseConnection::execute(
                    "UPDATE login_attempts SET attempts = ?, last_attempt = NOW(), locked_until = ? WHERE id = ?",
                    [$new_attempts, $locked_until, $existing['id']]
                );
            } else {
                DatabaseConnection::insert(
                    "INSERT INTO login_attempts (ip_address, email, attempts, last_attempt) VALUES (?, ?, 1, NOW())",
                    [$ip, $email]
                );
            }
        }
    } catch (Exception $e) {
        error_log('Login attempt recording error: ' . $e->getMessage());
    }
}

// Генерируем CSRF токен для формы
$csrf_token = generateCSRFToken();

include $_SERVER['DOCUMENT_ROOT'] . '/includes/header.php';
?>

<!DOCTYPE html>
<html lang="ua">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Вхід - StormHosting UA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="/assets/css/pages/auth-login.css" rel="stylesheet">
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h1><i class="bi bi-box-arrow-in-right me-2"></i>Вхід</h1>
            <p>Увійдіть в ваш обліковий запис</p>
        </div>
        
        <div id="alertContainer"></div>
        
        <form id="loginForm" novalidate>
            <input type="hidden" name="csrf_token" value="<?php echo escapeOutput($csrf_token); ?>">
            <input type="hidden" name="action" value="login">
            
            <div class="form-group">
                <label for="email" class="form-label">
                    <i class="bi bi-envelope me-1"></i>Email адреса
                </label>
                <div class="input-group">
                    <span class="input-group-text">
                        <i class="bi bi-envelope"></i>
                    </span>
                    <input type="email" 
                           id="email" 
                           name="email" 
                           class="form-control" 
                           placeholder="Введіть ваш email"
                           required
                           autocomplete="email">
                </div>
                <div class="invalid-feedback"></div>
            </div>
            
            <div class="form-group">
                <label for="password" class="form-label">
                    <i class="bi bi-lock me-1"></i>Пароль
                </label>
                <div class="input-group">
                    <span class="input-group-text">
                        <i class="bi bi-lock"></i>
                    </span>
                    <input type="password" 
                           id="password" 
                           name="password" 
                           class="form-control" 
                           placeholder="Введіть ваш пароль"
                           required
                           autocomplete="current-password">
                    <button type="button" class="btn btn-outline-secondary" id="togglePassword">
                        <i class="bi bi-eye"></i>
                    </button>
                </div>
                <div class="invalid-feedback"></div>
            </div>
            
            <div class="form-check">
                <input type="checkbox" id="remember_me" name="remember_me" class="form-check-input">
                <label for="remember_me" class="form-check-label">
                    Запам'ятати мене
                </label>
            </div>
            
            <button type="submit" class="btn btn-login" id="submitBtn">
                <div class="spinner-border spinner-border-sm loading-spinner" role="status">
                    <span class="visually-hidden">Завантаження...</span>
                </div>
                <span class="btn-text">Увійти</span>
            </button>
        </form>
        
        <div class="forgot-password">
            <a href="/auth/forgot-password.php">Забули пароль?</a>
        </div>
        
        <div class="register-link">
            <p>Немає облікового запису? <a href="/auth/register.php">Зареєструйтеся тут</a></p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/assets/js/auth-login.js"></script>
</body>
</html>

<?php include $_SERVER['DOCUMENT_ROOT'] . '/includes/footer.php'; ?>