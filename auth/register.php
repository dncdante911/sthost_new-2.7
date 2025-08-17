<?php
define('SECURE_ACCESS', true);
require_once $_SERVER['DOCUMENT_ROOT'] . '/includes/config.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/includes/db_connect.php';

// Обработка AJAX регистрации
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'register') {
    $response = ['success' => false, 'message' => '', 'errors' => []];
    
    try {
        // CSRF защита
        $csrf_token = $_POST['csrf_token'] ?? '';
        if (!validateCSRFToken($csrf_token)) {
            throw new Exception('Невірний токен безпеки');
        }
        
        // Получение и валидация данных
        $email = filter_var(trim($_POST['email'] ?? ''), FILTER_VALIDATE_EMAIL);
        $password = $_POST['password'] ?? '';
        $password_confirm = $_POST['password_confirm'] ?? '';
        $full_name = sanitizeInput($_POST['full_name'] ?? '');
        $phone = sanitizeInput($_POST['phone'] ?? '');
        $language = in_array($_POST['language'] ?? 'ua', ['ua', 'en', 'ru']) ? $_POST['language'] : 'ua';
        $accept_terms = !empty($_POST['accept_terms']);
        $marketing_emails = !empty($_POST['marketing_emails']);
        
        // Валидация
        if (!$email) {
            $response['errors']['email'] = 'Введіть коректну email адресу';
        }
        
        if (strlen($password) < 8) {
            $response['errors']['password'] = 'Пароль повинен містити мінімум 8 символів';
        }
        
        if (!preg_match('/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$/', $password)) {
            $response['errors']['password'] = 'Пароль повинен містити великі і малі літери та цифри';
        }
        
        if ($password !== $password_confirm) {
            $response['errors']['password_confirm'] = 'Паролі не співпадають';
        }
        
        if (empty($full_name) || strlen($full_name) < 2) {
            $response['errors']['full_name'] = 'Введіть повне ім\'я (мінімум 2 символи)';
        }
        
        if (!empty($phone) && !preg_match('/^\+?[0-9\s\-\(\)]{10,15}$/', $phone)) {
            $response['errors']['phone'] = 'Введіть коректний номер телефону';
        }
        
        if (!$accept_terms) {
            $response['errors']['accept_terms'] = 'Необхідно прийняти умови використання';
        }
        
        // Проверка существования пользователя
        if (empty($response['errors'])) {
            $existing_user = DatabaseConnection::fetchOne(
                "SELECT id FROM users WHERE email = ?",
                [$email]
            );
            
            if ($existing_user) {
                $response['errors']['email'] = 'Користувач з таким email вже існує';
            }
        }
        
        // Если есть ошибки валидации, возвращаем их
        if (!empty($response['errors'])) {
            $response['message'] = 'Будь ласка, виправте помилки у формі';
            header('Content-Type: application/json');
            echo json_encode($response);
            exit;
        }
        
        // Хешируем пароль
        $password_hash = password_hash($password, PASSWORD_DEFAULT);
        
        // Начинаем транзакцию
        $pdo = DatabaseConnection::getSiteConnection();
        $pdo->beginTransaction();
        
        try {
            // Создаем пользователя в основной БД
            $user_id = DatabaseConnection::insert(
                "INSERT INTO users (email, password, full_name, phone, language, registration_date, is_active, marketing_emails) VALUES (?, ?, ?, ?, ?, NOW(), 1, ?)",
                [$email, $password_hash, $full_name, $phone, $language, $marketing_emails ? 1 : 0]
            );
            
            // Создаем клиента в FOSSBilling (заглушка)
            $fossbilling_client_id = createFOSSBillingClient($email, $password, $full_name, $phone);
            
            // Обновляем запись пользователя с ID клиента FOSSBilling
            if ($fossbilling_client_id) {
                DatabaseConnection::execute(
                    "UPDATE users SET fossbilling_client_id = ? WHERE id = ?",
                    [$fossbilling_client_id, $user_id]
                );
            }
            
            // Создаем аккаунт в ispmanager (заглушка)
            $ispmanager_created = createISPManagerAccount($email, $password, $full_name);
            
            // Логируем успешную регистрацию
            DatabaseConnection::insert(
                "INSERT INTO security_logs (ip_address, user_id, action, details, severity) VALUES (?, ?, ?, ?, ?)",
                [
                    $_SERVER['REMOTE_ADDR'] ?? 'unknown',
                    $user_id,
                    'user_registration',
                    "Успішна реєстрація користувача. FOSSBilling ID: $fossbilling_client_id, ISPManager: " . ($ispmanager_created ? 'створено' : 'помилка'),
                    'low'
                ]
            );
            
            // Подтверждаем транзакцию
            $pdo->commit();
            
            // Автоматически авторизуем пользователя
            $_SESSION['user_id'] = $user_id;
            $_SESSION['user_email'] = $email;
            $_SESSION['user_name'] = $full_name;
            $_SESSION['user_language'] = $language;
            $_SESSION['is_logged_in'] = true;
            $_SESSION['fossbilling_client_id'] = $fossbilling_client_id;
            
            // Отправляем welcome email (заглушка)
            sendWelcomeEmail($email, $full_name);
            
            $response['success'] = true;
            $response['message'] = 'Реєстрація успішна! Ви автоматично авторизовані.';
            $response['redirect'] = '/client/dashboard.php';
            
        } catch (Exception $e) {
            $pdo->rollback();
            throw $e;
        }
        
    } catch (Exception $e) {
        $response['message'] = $e->getMessage();
        
        // Логируем ошибку
        error_log('Registration error: ' . $e->getMessage());
    }
    
    header('Content-Type: application/json');
    echo json_encode($response);
    exit;
}

// Функция создания клиента в FOSSBilling (заглушка)
function createFOSSBillingClient($email, $password, $full_name, $phone) {
    // Заглушка - в реальности здесь будет API запрос к FOSSBilling
    return null;
}

// Функция создания аккаунта в ispmanager (заглушка)
function createISPManagerAccount($email, $password, $full_name) {
    // Заглушка - в реальности здесь будет API запрос к ispmanager
    return false;
}

// Функция отправки welcome email (заглушка)
function sendWelcomeEmail($email, $full_name) {
    return true;
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
    <title>Реєстрація - StormHosting UA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="/assets/css/pages/auth-register.css" rel="stylesheet">
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <h1><i class="bi bi-person-plus me-2"></i>Реєстрація</h1>
            <p>Створіть обліковий запис у StormHosting UA</p>
        </div>
        
        <div id="alertContainer"></div>
        
        <form id="registerForm" novalidate>
            <input type="hidden" name="csrf_token" value="<?php echo escapeOutput($csrf_token); ?>">
            <input type="hidden" name="action" value="register">
            
            <div class="form-group">
                <label for="full_name" class="form-label">
                    <i class="bi bi-person me-1"></i>Повне ім'я
                </label>
                <input type="text" 
                       id="full_name" 
                       name="full_name" 
                       class="form-control" 
                       placeholder="Введіть ваше повне ім'я"
                       required>
                <div class="invalid-feedback"></div>
            </div>
            
            <div class="form-group">
                <label for="email" class="form-label">
                    <i class="bi bi-envelope me-1"></i>Email адреса
                </label>
                <input type="email" 
                       id="email" 
                       name="email" 
                       class="form-control" 
                       placeholder="Введіть ваш email"
                       required>
                <div class="invalid-feedback"></div>
            </div>
            
            <div class="form-group">
                <label for="phone" class="form-label">
                    <i class="bi bi-telephone me-1"></i>Номер телефону (опціонально)
                </label>
                <div class="input-group">
                    <span class="input-group-text">
                        <i class="bi bi-telephone"></i>
                    </span>
                    <input type="tel" 
                           id="phone" 
                           name="phone" 
                           class="form-control" 
                           placeholder="+380xxxxxxxxx">
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
                           placeholder="Створіть надійний пароль"
                           required>
                    <button type="button" class="btn btn-outline-secondary" id="togglePassword">
                        <i class="bi bi-eye"></i>
                    </button>
                </div>
                <div class="password-strength">
                    <div class="strength-bar">
                        <div class="strength-fill"></div>
                    </div>
                    <small class="text-muted">Пароль повинен містити мінімум 8 символів, великі і малі літери, цифри</small>
                </div>
                <div class="invalid-feedback"></div>
            </div>
            
            <div class="form-group">
                <label for="password_confirm" class="form-label">
                    <i class="bi bi-lock-fill me-1"></i>Підтвердження паролю
                </label>
                <div class="input-group">
                    <span class="input-group-text">
                        <i class="bi bi-lock-fill"></i>
                    </span>
                    <input type="password" 
                           id="password_confirm" 
                           name="password_confirm" 
                           class="form-control" 
                           placeholder="Повторіть пароль"
                           required>
                </div>
                <div class="invalid-feedback"></div>
            </div>
            
            <div class="form-group">
                <label for="language" class="form-label">
                    <i class="bi bi-globe me-1"></i>Мова інтерфейсу
                </label>
                <select id="language" name="language" class="form-control">
                    <option value="ua" selected>Українська</option>
                    <option value="en">English</option>
                    <option value="ru">Русский</option>
                </select>
            </div>
            
            <div class="form-check">
                <input type="checkbox" id="accept_terms" name="accept_terms" class="form-check-input" required>
                <label for="accept_terms" class="form-check-label">
                    Я приймаю <a href="/pages/info/rules.php" target="_blank">умови використання</a> та 
                    <a href="/pages/info/legal.php" target="_blank">політику конфіденційності</a>
                </label>
                <div class="invalid-feedback"></div>
            </div>
            
            <div class="form-check">
                <input type="checkbox" id="marketing_emails" name="marketing_emails" class="form-check-input">
                <label for="marketing_emails" class="form-check-label">
                    Я хочу отримувати новини та спеціальні пропозиції на email
                </label>
            </div>
            
            <button type="submit" class="btn btn-register" id="submitBtn">
                <div class="spinner-border spinner-border-sm loading-spinner" role="status">
                    <span class="visually-hidden">Завантаження...</span>
                </div>
                <span class="btn-text">Зареєструватися</span>
            </button>
        </form>
        
        <div class="login-link">
            <p>Вже маєте обліковий запис? <a href="/auth/login.php">Увійдіть тут</a></p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/assets/js/auth-register.js"></script>
</body>
</html>

<?php include $_SERVER['DOCUMENT_ROOT'] . '/includes/footer.php'; ?>