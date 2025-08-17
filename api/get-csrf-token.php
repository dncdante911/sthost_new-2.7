<?php
define('SECURE_ACCESS', true);
require_once $_SERVER['DOCUMENT_ROOT'] . '/includes/config.php';

header('Content-Type: application/json');
header('X-Content-Type-Options: nosniff');

// Генерируем или получаем существующий CSRF токен
$csrf_token = generateCSRFToken();

echo json_encode([
    'success' => true,
    'token' => $csrf_token
]);
?>