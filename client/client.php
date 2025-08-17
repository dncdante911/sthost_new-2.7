<?php
/**
 * Страница профиля пользователя
 * Файл: /client/profile.php
 */

// Защита от прямого доступа
define('SECURE_ACCESS', true);

// Начинаем сессию
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Проверяем авторизацию
if (!isset($_SESSION['user_id']) || empty($_SESSION['user_id'])) {
    header('Location: /?login_required=1');
    exit;
}

// Основные переменные страницы
$page_title = 'Налаштування профілю - StormHosting UA';
$meta_description = 'Налаштування профілю користувача в панелі управління StormHosting UA';
$additional_css = [
    '/assets/css/pages/client-profile.css'
];
$additional_js = [
    '/assets/js/pages/client-profile.js'
];

// Подключение к БД
try {
    if (file_exists($_SERVER['DOCUMENT_ROOT'] . '/includes/config.php')) {
        require_once $_SERVER['DOCUMENT_ROOT'] . '/includes/config.php';
    }
    
    if (file_exists($_SERVER['DOCUMENT_ROOT'] . '/includes/db_connect.php')) {
        require_once $_SERVER['DOCUMENT_ROOT'] . '/includes/db_connect.php';
        $pdo = DatabaseConnection::getSiteConnection();
    } else {
        // Прямое подключение к БД
        $host = 'localhost';
        $dbname = 'sthostsitedb';
        $username = 'sthostdb';
        $password = '3344Frz@q0607Dm$157';
        
        $pdo = new PDO(
            "mysql:host={$host};dbname={$dbname};charset=utf8mb4",
            $username,
            $password,
            [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
            ]
        );
    }
} catch (Exception $e) {
    error_log('Database connection failed: ' . $e->getMessage());
    die('Помилка підключення до бази даних');
}

// Получаем данные пользователя
$user_id = $_SESSION['user_id'];
$success_message = '';
$error_message = '';

try {
    $stmt = $pdo->prepare("
        SELECT id, full_name, email, phone, email_verified, created_at, updated_at 
        FROM users 
        WHERE id = ?
    ");
    $stmt->execute([$user_id]);
    $user = $stmt->fetch();
    
    if (!$user) {
        session_destroy();
        header('Location: /?session_expired=1');
        exit;
    }
} catch (Exception $e) {
    error_log('Failed to fetch user data: ' . $e->getMessage());
    $error_message = 'Помилка завантаження даних профілю';
}

// Обработка формы обновления профиля
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action'])) {
    
    if ($_POST['action'] === 'update_profile') {
        $full_name = trim($_POST['full_name'] ?? '');
        $phone = trim($_POST['phone'] ?? '');
        
        $errors = [];
        
        // Валидация
        if (empty($full_name)) {
            $errors['full_name'] = 'Вкажіть повне ім\'я';
        } elseif (strlen($full_name) < 2) {
            $errors['full_name'] = 'Ім\'я повинно містити мінімум 2 символи';
        }
        
        if (!empty($phone)) {
            $phone = preg_replace('/[^0-9+\-\(\)\s]/', '', $phone);
            if (strlen($phone) < 10 || strlen($phone) > 20) {
                $errors['phone'] = 'Невірний формат телефону';
            }
        }
        
        if (empty($errors)) {
            try {
                $stmt = $pdo->prepare("
                    UPDATE users 
                    SET full_name = ?, phone = ?, updated_at = NOW() 
                    WHERE id = ?
                ");
                $stmt->execute([$full_name, $phone, $user_id]);
                
                // Обновляем данные в сессии
                $_SESSION['user_name'] = $full_name;
                $user['full_name'] = $full_name;
                $user['phone'] = $phone;
                
                $success_message = 'Дані профілю успішно оновлені!';
                
            } catch (Exception $e) {
                error_log('Failed to update profile: ' . $e->getMessage());
                $error_message = 'Помилка оновлення профілю. Спробуйте ще раз.';
            }
        }
    }
    
    elseif ($_POST['action'] === 'change_password') {
        $current_password = $_POST['current_password'] ?? '';
        $new_password = $_POST['new_password'] ?? '';
        $confirm_password = $_POST['confirm_password'] ?? '';
        
        $errors = [];
        
        // Валидация
        if (empty($current_password)) {
            $errors['current_password'] = 'Вкажіть поточний пароль';
        }
        
        if (empty($new_password)) {
            $errors['new_password'] = 'Вкажіть новий пароль';
        } elseif (strlen($new_password) < 8) {
            $errors['new_password'] = 'Новий пароль повинен містити мінімум 8 символів';
        } elseif (!preg_match('/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/', $new_password)) {
            $errors['new_password'] = 'Пароль повинен містити великі та малі літери, цифри';
        }
        
        if ($new_password !== $confirm_password) {
            $errors['confirm_password'] = 'Паролі не співпадають';
        }
        
        if (empty($errors)) {
            try {
                // Проверяем текущий пароль
                $stmt = $pdo->prepare("SELECT password_hash FROM users WHERE id = ?");
                $stmt->execute([$user_id]);
                $user_data = $stmt->fetch();
                
                if (!password_verify($current_password, $user_data['password_hash'])) {
                    $errors['current_password'] = 'Невірний поточний пароль';
                } else {
                    // Обновляем пароль
                    $new_password_hash = password_hash($new_password, PASSWORD_DEFAULT);
                    
                    $stmt = $pdo->prepare("
                        UPDATE users 
                        SET password_hash = ?, updated_at = NOW() 
                        WHERE id = ?
                    ");
                    $stmt->execute([$new_password_hash, $user_id]);
                    
                    // Удаляем все remember tokens
                    $stmt = $pdo->prepare("DELETE FROM remember_tokens WHERE user_id = ?");
                    $stmt->execute([$user_id]);
                    
                    $success_message = 'Пароль успішно змінений!';
                }
                
            } catch (Exception $e) {
                error_log('Failed to change password: ' . $e->getMessage());
                $error_message = 'Помилка зміни пароля. Спробуйте ще раз.';
            }
        }
    }
}

// Подключаем header
include $_SERVER['DOCUMENT_ROOT'] . '/includes/header.php';
?>

<!-- Breadcrumbs -->
<div class="breadcrumbs">
    <div class="container">
        <a href="/" class="breadcrumb-link">Головна</a>
        <span class="breadcrumb-separator">/</span>
        <a href="/client/" class="breadcrumb-link">Кабінет</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current">Налаштування профілю</span>
    </div>
</div>

<!-- Main Content -->
<main class="main-content client-profile">
    <div class="container">
        <!-- Page Header -->
        <div class="page-header">
            <div class="page-header-content">
                <div class="page-icon">
                    <i class="bi bi-person-gear"></i>
                </div>
                <div>
                    <h1 class="page-title">Налаштування профілю</h1>
                    <p class="page-subtitle">Управління особистими даними та налаштуваннями аккаунту</p>
                </div>
            </div>
            <div class="page-actions">
                <a href="/client/" class="btn btn-outline">
                    <i class="bi bi-arrow-left"></i>
                    Повернутися до кабінету
                </a>
            </div>
        </div>

        <!-- Alerts -->
        <?php if ($success_message): ?>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle me-2"></i>
                <?php echo htmlspecialchars($success_message); ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <?php endif; ?>

        <?php if ($error_message): ?>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle me-2"></i>
                <?php echo htmlspecialchars($error_message); ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <?php endif; ?>

        <div class="row">
            <!-- Profile Info Card -->
            <div class="col-lg-4">
                <div class="profile-card">
                    <div class="profile-avatar">
                        <div class="avatar-circle">
                            <?php echo strtoupper(substr($user['full_name'], 0, 1)); ?>
                        </div>
                        <button class="avatar-edit-btn" type="button" title="Змінити аватар">
                            <i class="bi bi-camera"></i>
                        </button>
                    </div>
                    
                    <div class="profile-info">