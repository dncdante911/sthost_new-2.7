<?php
// header.php - Спрощена версія з slide-меню
if (!defined('SECURE_ACCESS')) die('Direct access not permitted');

// Базові змінні
$page = $page ?? '';
$current_lang = $current_lang ?? 'uk';
$page_title = $page_title ?? 'StormHosting UA';
$meta_description = $meta_description ?? 'Надійний хостинг, домени, VDS/VPS, сертифікати, підтримка 24/7 в Україні';
$meta_keywords = $meta_keywords ?? '';
$site_email = 'info@sthost.pro';

// Активні розділи
$domain_pages = ['domains', 'register', 'whois', 'dns', 'transfer'];
$hosting_pages = ['hosting', 'shared', 'cloud', 'reseller'];
$vds_pages = ['vds', 'virtual', 'dedicated', 'vds-calc'];
$tools_pages = ['tools', 'site-check', 'http-headers', 'ip-check', 'site-info'];
$info_pages = ['info', 'about', 'quality', 'rules', 'legal', 'faq', 'ssl', 'complaints'];

$is_domains_active = in_array($page, $domain_pages, true);
$is_hosting_active = in_array($page, $hosting_pages, true);
$is_vds_active = in_array($page, $vds_pages, true);
$is_tools_active = in_array($page, $tools_pages, true);
$is_info_active = in_array($page, $info_pages, true);
?>
<!DOCTYPE html>
<html lang="<?php echo htmlspecialchars($current_lang); ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($page_title); ?></title>
    <meta name="description" content="<?php echo htmlspecialchars($meta_description); ?>">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link href="/assets/css/main.css" rel="stylesheet">

    <!-- Additional CSS -->
    <?php if (isset($additional_css) && is_array($additional_css)): ?>
        <?php foreach ($additional_css as $css_file): ?>
            <link rel="stylesheet" href="<?php echo htmlspecialchars($css_file); ?>">
        <?php endforeach; ?>
    <?php endif; ?>
    
    <style>
        /* Inline critical CSS for menu */
        .menu-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1060;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
            backdrop-filter: blur(2px);
        }
        
        .menu-overlay.active {
            opacity: 1;
            visibility: visible;
        }
        
        .slide-menu {
            position: fixed;
            top: 0;
            right: -100%;
            width: 400px;
            max-width: 90vw;
            height: 100vh;
            background: white;
            z-index: 1070;
            transition: right 0.3s ease;
            display: flex;
            flex-direction: column;
            box-shadow: -5px 0 15px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .slide-menu.active {
            right: 0;
        }
        
        .slide-menu-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1.5rem;
            border-bottom: 1px solid #e5e7eb;
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
        }
        
        .slide-menu-body {
            flex: 1;
            overflow-y: auto;
            padding: 1rem 0;
        }
        
        .menu-item {
            border-bottom: 1px solid #f3f4f6;
        }
        
        .menu-item-toggle {
            display: flex;
            align-items: center;
            gap: 1rem;
            width: 100%;
            padding: 1rem 1.5rem;
            background: transparent;
            border: none;
            text-align: left;
            color: #374151;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .menu-item-toggle:hover {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            transform: translateX(5px);
        }
        
        .menu-item-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 48px;
            height: 48px;
            background: #f3f4f6;
            border-radius: 12px;
            color: #667eea;
            font-size: 1.25rem;
            flex-shrink: 0;
        }
        
        .menu-item-toggle:hover .menu-item-icon {
            background: rgba(255, 255, 255, 0.2);
            color: white;
        }
        
        .submenu {
            position: absolute;
            top: 0;
            right: -100%;
            width: 100%;
            height: 100%;
            background: white;
            transition: right 0.3s ease;
            display: flex;
            flex-direction: column;
            z-index: 10;
        }
        
        .submenu.active {
            right: 0;
        }
        
        .submenu-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1.5rem;
            border-bottom: 1px solid #e5e7eb;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .submenu-back {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: rgba(255, 255, 255, 0.2);
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            color: white;
            font-size: 0.875rem;
            transition: all 0.3s ease;
        }
        
        .submenu-back:hover {
            background: rgba(255, 255, 255, 0.3);
        }
        
        .submenu-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem 1.5rem;
            color: #374151;
            text-decoration: none;
            transition: all 0.3s ease;
            border-bottom: 1px solid #f9fafb;
        }
        
        .submenu-item:hover {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            transform: translateX(5px);
        }
        
        .submenu-item i {
            font-size: 1.125rem;
            color: #667eea;
            width: 20px;
            text-align: center;
        }
        
        .submenu-item:hover i {
            color: white;
        }
        
        .menu-toggle {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            background: transparent;
            border: none;
            padding: 0.75rem;
            color: #374151;
            font-weight: 500;
            font-size: 0.875rem;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        
        .menu-toggle:hover {
            background: rgba(102, 126, 234, 0.1);
            color: #667eea;
        }
        
        .menu-toggle.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .menu-toggle-inner {
            display: flex;
            flex-direction: column;
            gap: 3px;
            width: 24px;
            height: 18px;
        }
        
        .menu-toggle-line {
            width: 100%;
            height: 2px;
            background: currentColor;
            border-radius: 1px;
            transition: all 0.3s ease;
        }
        
        .menu-toggle.active .menu-toggle-line:nth-child(1) {
            transform: translateY(8px) rotate(45deg);
        }
        
        .menu-toggle.active .menu-toggle-line:nth-child(2) {
            opacity: 0;
        }
        
        .menu-toggle.active .menu-toggle-line:nth-child(3) {
            transform: translateY(-8px) rotate(-45deg);
        }
        
        .quick-nav {
            display: flex;
            gap: 1rem;
            align-items: center;
        }
        
        .quick-nav-link {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1rem;
            color: #374151;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 500;
            font-size: 0.875rem;
            transition: all 0.3s ease;
        }
        
        .quick-nav-link:hover,
        .quick-nav-link.active {
            color: #667eea;
            background: rgba(102, 126, 234, 0.1);
            text-decoration: none;
        }
        
        @media (max-width: 991.98px) {
            .quick-nav {
                display: none;
            }
            .slide-menu {
                width: 100%;
                right: -100%;
            }
        }
    </style>
</head>
<body>
    <!-- Menu Overlay -->
    <div class="menu-overlay" id="menuOverlay"></div>
    
    <!-- Header -->
    <header class="header">
        <!-- Top Bar -->
        <div style="background: linear-gradient(135deg, #2c3e50 0%, #1f2937 100%); color: white; padding: 0.75rem 0; font-size: 0.875rem;">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <div class="d-flex gap-3 align-items-center flex-wrap">
                            <div class="d-flex align-items-center gap-2">
                                <i class="bi bi-telephone text-primary"></i>
                                <a href="tel:+380-XX-XXX-XX-XX" class="text-white-50 text-decoration-none">+380 XX XXX XX XX</a>
                            </div>
                            <div class="d-flex align-items-center gap-2">
                                <i class="bi bi-envelope text-primary"></i>
                                <a href="mailto:<?php echo $site_email; ?>" class="text-white-50 text-decoration-none"><?php echo $site_email; ?></a>
                            </div>
                            <div class="d-flex align-items-center gap-2">
                                <i class="bi bi-clock text-primary"></i>
                                <span class="text-white-50">Підтримка 24/7</span>
                            </div>
                        </div>
                    </div>
                     <div class="col-md-4">
                        <div class="d-flex align-items-center justify-content-md-end gap-2 flex-wrap">
                            <a href="/auth/login.php" class="btn btn-outline-light btn-sm">
                                <i class="bi bi-box-arrow-in-right"></i> Вхід
                            </a>
                            <a href="/auth/register.php" class="btn btn-primary btn-sm">
                                <i class="bi bi-person-plus"></i> Реєстрація
                            </a>
                        </div> 
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Main Navbar -->
        <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm sticky-top">
            <div class="container">
                <!-- Brand -->
                <a class="navbar-brand d-flex align-items-center gap-3" href="/">
                    <img src="/assets/images/logos/logo.svg" alt="StormHosting UA" style="height: 40px;">
                    <span style="font-size: 1.25rem; font-weight: 700; color: #2c3e50;">
                        Storm<span style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Hosting</span> 
                        <small class="text-muted" style="font-size: 0.75rem;">UA</small>
                    </span>
                </a>
                
                <!-- Quick Navigation for Desktop -->
                <div class="quick-nav d-none d-lg-flex">
                    <a href="/" class="quick-nav-link<?php echo ($page === 'home') ? ' active' : ''; ?>">
                        <i class="bi bi-house"></i>
                        <span>Головна</span>
                    </a>
                    <a href="/pages/contacts.php" class="quick-nav-link<?php echo ($page === 'contacts') ? ' active' : ''; ?>">
                        <i class="bi bi-telephone"></i>
                        <span>Контакти</span>
                    </a>
                </div>
                
                <!-- Menu Toggle Button -->
                <button class="menu-toggle" id="menuToggle" type="button">
                    <div class="menu-toggle-inner">
                        <span class="menu-toggle-line"></span>
                        <span class="menu-toggle-line"></span>
                        <span class="menu-toggle-line"></span>
                    </div>
                    <span>Меню</span>
                </button>
            </div>
        </nav>
    </header>
    
    <!-- Slide Menu -->
    <div class="slide-menu" id="slideMenu">
        <div class="slide-menu-header">
            <div class="d-flex align-items-center gap-3">
                <img src="/assets/images/logos/logo.svg" alt="StormHosting UA" style="height: 32px;">
                <span style="font-size: 1.125rem; font-weight: 700; color: #2c3e50;">StormHosting UA</span>
            </div>
            <button class="btn-close" id="slideMenuClose"></button>
        </div>
        
        <div class="slide-menu-body">
            <!-- Домени -->
            <div class="menu-item">
                <button class="menu-item-toggle<?php echo $is_domains_active ? ' active' : ''; ?>" data-submenu="domains">
                    <div class="menu-item-icon">
                        <i class="bi bi-globe"></i>
                    </div>
                    <div class="flex-grow-1">
                        <div style="font-weight: 600; margin-bottom: 0.25rem;">Домени</div>
                        <div style="font-size: 0.875rem; color: #6b7280;">Реєстрація та управління</div>
                    </div>
                    <i class="bi bi-chevron-right"></i>
                </button>
                
                <div class="submenu" id="submenu-domains">
                    <div class="submenu-header">
                        <button class="submenu-back" data-submenu="domains">
                            <i class="bi bi-chevron-left"></i>
                            <span>Назад</span>
                        </button>
                        <h4 class="mb-0">Домени</h4>
                    </div>
                    <div style="flex: 1; overflow-y: auto;">
                        <a href="/pages/domains/register.php" class="submenu-item<?php echo ($page === 'register') ? ' active' : ''; ?>">
                            <i class="bi bi-plus-circle"></i>
                            <div>
                                <div style="font-weight: 600;">Зареєструвати домен</div>
                                <div style="font-size: 0.875rem; color: #6b7280;">Знайдіть та зареєструйте домен</div>
                            </div>
                        </a>
                        <a href="/pages/domains/whois.php" class="submenu-item<?php echo ($page === 'whois') ? ' active' : ''; ?>">
                            <i class="bi bi-search"></i>
                            <div>
                                <div style="font-weight: 600;">WHOIS перевірка</div>
                                <div style="font-size: 0.875rem; color: #6b7280;">Інформація про домен</div>
                            </div>
                        </a>
                        <a href="/pages/domains/dns.php" class="submenu-item<?php echo ($page === 'dns') ? ' active' : ''; ?>">
                            <i class="bi bi-dns"></i>
                            <div>
                                <div style="font-weight: 600;">DNS перевірка</div>
                                <div style="font-size: 0.875rem; color: #6b7280;">Перевірити DNS записи</div>
                            </div>
                        </a>
                        <a href="/pages/domains/transfer.php" class="submenu-item<?php echo ($page === 'transfer') ? ' active' : ''; ?>">
                            <i class="bi bi-arrow-left-right"></i>
                            <div>
                                <div style="font-weight: 600;">Трансфер домену</div>
                                <div style="font-size: 0.875rem; color: #6b7280;">Перенести до нас</div>
                            </div>
                        </a>
                        <a href="/pages/domains/domains.php" class="submenu-item<?php echo ($page === 'domains') ? ' active' : ''; ?>">
                            <i class="bi bi-collection"></i>
                            <div>
                                <div style="font-weight: 600;">Всі послуги доменів</div>
                                <div style="font-size: 0.875rem; color: #6b7280;">Повний список послуг</div>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Хостинг -->
            <div class="menu-item">
                <button class="menu-item-toggle<?php echo $is_hosting_active ? ' active' : ''; ?>" data-submenu="hosting">
                    <div class="menu-item-icon">
                        <i class="bi bi-server"></i>
                    </div>
                    <div class="flex-grow-1">
                        <div style="font-weight: 600; margin-bottom: 0.25rem;">Хостинг</div>
                        <div style="font-size: 0.875rem; color: #6b7280;">Надійний веб-хостинг</div>
                    </div>
                    <i class="bi bi-chevron-right"></i>
                </button>
                
                <div class="submenu" id="submenu-hosting">
                    <div class="submenu-header">
                        <button class="submenu-back" data-submenu="hosting">
                            <i class="bi bi-chevron-left"></i>
                            <span>Назад</span>
                        </button>
                        <h4 class="mb-0">Хостинг</h4>
                    </div>
                    <div style="flex: 1; overflow-y: auto;">
                        <a href="/pages/hosting/shared.php" class="submenu-item<?php echo ($page === 'shared') ? ' active' : ''; ?>">
                            <i class="bi bi-share"></i>
                            <div>
                                <div style="font-weight: 600;">Віртуальний хостинг</div>
                                <div style="font-size: 0.875rem; color: #6b7280;">Ідеально для сайтів</div>
                            </div>
                        </a>
                        <a href="/pages/hosting/cloud.php" class="submenu-item<?php echo ($page === 'cloud') ? ' active' : ''; ?>">
                            <i class="bi bi-cloud"></i>
                            <div>
                                <div style="font-weight: 600;">Хмарний хостинг</div>
                                <div style="font-size: 0.875rem; color: #6b7280;">Масштабована архітектура</div>
                            </div>
                        </a>
                        <a href="/pages/hosting/reseller.php" class="submenu-item<?php echo ($page === 'reseller') ? ' active' : ''; ?>">
                            <i class="bi bi-shop"></i>
                            <div>
                                <div style="font-weight: 600;">Реселерський хостинг</div>
                                <div style="font-size: 0.875rem; color: #6b7280;">Для веб-студій</div>
                            </div>
                        </a>
                        <a href="/pages/hosting/hosting.php" class="submenu-item<?php echo ($page === 'hosting') ? ' active' : ''; ?>">
                            <i class="bi bi-collection"></i>
                            <div>
                                <div style="font-weight: 600;">Всі рішення хостингу</div>
                                <div style="font-size: 0.875rem; color: #6b7280;">Порівняння тарифів</div>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- VDS/VPS -->
            <div class="menu-item">
                <button class="menu-item-toggle<?php echo $is_vds_active ? ' active' : ''; ?>" data-submenu="vds">
                    <div class="menu-item-icon">
                        <i class="bi bi-hdd-stack"></i>
                    </div>
                    <div class="flex-grow-1">
                        <div style="font-weight: 600; margin-bottom: 0.25rem;">VDS/VPS</div>
                        <div style="font-size: 0.875rem; color: #6b7280;">Віртуальні сервери</div>
                    </div>
                    <i class="bi bi-chevron-right"></i>
                </button>
                
                <div class="submenu" id="submenu-vds">
                    <div class="submenu-header">
                        <button class="submenu-back" data-submenu="vds">
                            <i class="bi bi-chevron-left"></i>
                            <span>Назад</span>
                        </button>
                        <h4 class="mb-0">VDS/VPS</h4>
                    </div>
                    <div style="flex: 1; overflow-y: auto;">
                        <a href="/pages/vds/virtual.php" class="submenu-item<?php echo ($page === 'virtual') ? ' active' : ''; ?>">
                            <i class="bi bi-cloud-arrow-up"></i>
                            <div>
                                <div style="font-weight: 600;">Віртуальні сервери</div>
                                <div style="font-size: 0.875rem; color: #6b7280;">VPS для проектів</div>
                            </div>
                        </a>
                        <a href="/pages/vds/dedicated.php" class="submenu-item<?php echo ($page === 'dedicated') ? ' active' : ''; ?>">
                            <i class="bi bi-pc-display"></i>
                            <div>
                                <div style="font-weight: 600;">Виділені сервери</div>
                                <div style="font-size: 0.875rem; color: #6b7280;">Максимальна потужність</div>
                            </div>
                        </a>
                        <a href="/pages/vds/vds-calc.php" class="submenu-item<?php echo ($page === 'vds-calc') ? ' active' : ''; ?>">
                            <i class="bi bi-calculator"></i>
                            <div>
                                <div style="font-weight: 600;">Калькулятор VDS</div>
                                <div style="font-size: 0.875rem; color: #6b7280;">Розрахуйте вартість</div>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Інструменти -->
            <div class="menu-item">
                <button class="menu-item-toggle<?php echo $is_tools_active ? ' active' : ''; ?>" data-submenu="tools">
                    <div class="menu-item-icon">
                        <i class="bi bi-tools"></i>
                    </div>
                    <div class="flex-grow-1">
                        <div style="font-weight: 600; margin-bottom: 0.25rem;">Інструменти</div>
                        <div style="font-size: 0.875rem; color: #6b7280;">Корисні утиліти</div>
                    </div>
                    <i class="bi bi-chevron-right"></i>
                </button>
                
                <div class="submenu" id="submenu-tools">
                    <div class="submenu-header">
                        <button class="submenu-back" data-submenu="tools">
                            <i class="bi bi-chevron-left"></i>
                            <span>Назад</span>
                        </button>
                        <h4 class="mb-0">Інструменти</h4>
                    </div>
                    <div style="flex: 1; overflow-y: auto;">
                        <a href="/pages/tools/site-check.php" class="submenu-item<?php echo ($page === 'site-check') ? ' active' : ''; ?>">
                            <i class="bi bi-check-circle"></i>
                            <div>
                                <div style="font-weight: 600;">Перевірка сайту</div>
                                <div style="font-size: 0.875rem; color: #6b7280;">Доступність та швидкість</div>
                            </div>
                        </a>
                            <a href="/pages/tools/ip-check.php" class="submenu-item<?php echo ($page === 'ip-check') ? ' active' : ''; ?>">
                            <i class="bi bi-geo-alt"></i>
                            <div>
                                <div style="font-weight: 600;">Перевірка IP</div>
                                <div style="font-size: 0.875rem; color: #6b7280;">Геолокація та інформація</div>
                            </div>
                        </a>
                        
                    </div>
                </div>
            </div>
            
            <!-- Інформація -->
            <div class="menu-item">
                <button class="menu-item-toggle<?php echo $is_info_active ? ' active' : ''; ?>" data-submenu="info">
                    <div class="menu-item-icon">
                        <i class="bi bi-info-circle"></i>
                    </div>
                    <div class="flex-grow-1">
                        <div style="font-weight: 600; margin-bottom: 0.25rem;">Інформація</div>
                        <div style="font-size: 0.875rem; color: #6b7280;">Про компанію</div>
                    </div>
                    <i class="bi bi-chevron-right"></i>
                </button>
                
                <div class="submenu" id="submenu-info">
                    <div class="submenu-header">
                        <button class="submenu-back" data-submenu="info">
                            <i class="bi bi-chevron-left"></i>
                            <span>Назад</span>
                        </button>
                        <h4 class="mb-0">Інформація</h4>
                    </div>
                    <div style="flex: 1; overflow-y: auto;">
                        <a href="/pages/info/about.php" class="submenu-item<?php echo ($page === 'about') ? ' active' : ''; ?>">
                            <i class="bi bi-building"></i>
                            <div>
                                <div style="font-weight: 600;">Про компанію</div>
                                <div style="font-size: 0.875rem; color: #6b7280;">Наша історія та місія</div>
                            </div>
                        </a>
                        <a href="/pages/info/quality.php" class="submenu-item<?php echo ($page === 'quality') ? ' active' : ''; ?>">
                            <i class="bi bi-shield-check"></i>
                            <div>
                                <div style="font-weight: 600;">Гарантія якості</div>
                                <div style="font-size: 0.875rem; color: #6b7280;">SLA та стандарти</div>
                            </div>
                        </a>
                        <a href="/pages/info/rules.php" class="submenu-item<?php echo ($page === 'rules') ? ' active' : ''; ?>">
                            <i class="bi bi-file-text"></i>
                            <div>
                                <div style="font-weight: 600;">Правила надання послуг</div>
                                <div style="font-size: 0.875rem; color: #6b7280;">Умови використання</div>
                            </div>
                        </a>
                        <a href="/pages/info/legal.php" class="submenu-item<?php echo ($page === 'legal') ? ' active' : ''; ?>">
                            <i class="bi bi-briefcase"></i>
                            <div>
                                <div style="font-weight: 600;">Юридична інформація</div>
                                <div style="font-size: 0.875rem; color: #6b7280;">Реквізити компанії</div>
                            </div>
                        </a>
                        <a href="/pages/info/faq.php" class="submenu-item<?php echo ($page === 'faq') ? ' active' : ''; ?>">
                            <i class="bi bi-question-circle"></i>
                            <div>
                                <div style="font-weight: 600;">Часті питання</div>
                                <div style="font-size: 0.875rem; color: #6b7280;">Відповіді на питання</div>
                            </div>
                        </a>
                        <a href="/pages/info/ssl.php" class="submenu-item<?php echo ($page === 'ssl') ? ' active' : ''; ?>">
                            <i class="bi bi-shield-lock"></i>
                            <div>
                                <div style="font-weight: 600;">SSL сертифікати</div>
                                <div style="font-size: 0.875rem; color: #6b7280;">Захист та довіра</div>
                            </div>
                        </a>
                        <a href="/pages/info/complaints.php" class="submenu-item<?php echo ($page === 'complaints') ? ' active' : ''; ?>">
                            <i class="bi bi-journal-text"></i>
                            <div>
                                <div style="font-weight: 600;">Книга скарг</div>
                                <div style="font-size: 0.875rem; color: #6b7280;">Зворотний зв'язок</div>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Швидкі дії -->
            <div style="padding: 1.5rem; border-top: 1px solid #e5e7eb; background: #f9fafb;">
                <h5 style="font-size: 0.875rem; font-weight: 700; color: #6b7280; text-transform: uppercase; margin-bottom: 1rem;">Швидкі дії</h5>
                <div class="d-flex flex-column gap-2">
                    <a href="/pages/hosting/shared.php" class="btn btn-primary">
                        <i class="bi bi-rocket-takeoff"></i>
                        Замовити хостинг
                    </a>
                    <a href="/pages/domains/register.php" class="btn btn-outline-primary">
                        <i class="bi bi-globe"></i>
                        Купити домен
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Main Content -->
    <main id="main-content" class="main-content">
        
        <!-- Breadcrumbs -->
        <?php if ($page !== 'home' && $page !== ''): ?>
        <nav aria-label="breadcrumb" class="bg-light">
            <div class="container">
                <ol class="breadcrumb py-3 mb-0">
                    <li class="breadcrumb-item">
                        <a href="/" class="text-decoration-none">
                            <i class="bi bi-house"></i> Головна
                        </a>
                    </li>
                    <?php
                    if ($is_domains_active) {
                        echo '<li class="breadcrumb-item"><a href="/pages/domains/domains.php" class="text-decoration-none">Домени</a></li>';
                        if ($page !== 'domains') {
                            $titles = [
                                'register' => 'Реєстрація домену',
                                'whois' => 'WHOIS перевірка',
                                'dns' => 'DNS перевірка',
                                'transfer' => 'Трансфер домену'
                            ];
                            if (isset($titles[$page])) {
                                echo '<li class="breadcrumb-item active">' . $titles[$page] . '</li>';
                            }
                        }
                    } elseif ($is_hosting_active) {
                        echo '<li class="breadcrumb-item"><a href="/pages/hosting/hosting.php" class="text-decoration-none">Хостинг</a></li>';
                        if ($page !== 'hosting') {
                            $titles = [
                                'shared' => 'Віртуальний хостинг',
                                'cloud' => 'Хмарний хостинг',
                                'reseller' => 'Реселерський хостинг'
                            ];
                            if (isset($titles[$page])) {
                                echo '<li class="breadcrumb-item active">' . $titles[$page] . '</li>';
                            }
                        }
                    } elseif ($is_vds_active) {
                        echo '<li class="breadcrumb-item"><a href="/pages/vds/" class="text-decoration-none">VDS/VPS</a></li>';
                        $titles = [
                            'virtual' => 'Віртуальні сервери',
                            'dedicated' => 'Виділені сервери',
                            'vds-calc' => 'Калькулятор VDS'
                        ];
                        if (isset($titles[$page])) {
                            echo '<li class="breadcrumb-item active">' . $titles[$page] . '</li>';
                        }
                    } elseif ($is_tools_active) {
                        echo '<li class="breadcrumb-item"><a href="/pages/tools/" class="text-decoration-none">Інструменти</a></li>';
                        $titles = [
                            'site-check' => 'Перевірка сайту',
                            'http-headers' => 'HTTP заголовки',
                            'ip-check' => 'Перевірка IP',
                            'site-info' => 'Інформація про сайт'
                        ];
                        if (isset($titles[$page])) {
                            echo '<li class="breadcrumb-item active">' . $titles[$page] . '</li>';
                        }
                    } elseif ($is_info_active) {
                        echo '<li class="breadcrumb-item"><a href="/pages/info/" class="text-decoration-none">Інформація</a></li>';
                        $titles = [
                            'about' => 'Про компанію',
                            'quality' => 'Гарантія якості',
                            'rules' => 'Правила надання послуг',
                            'legal' => 'Юридична інформація',
                            'faq' => 'Часті питання',
                            'ssl' => 'SSL сертифікати',
                            'complaints' => 'Книга скарг'
                        ];
                        if (isset($titles[$page])) {
                            echo '<li class="breadcrumb-item active">' . $titles[$page] . '</li>';
                        }
                    } elseif ($page === 'contacts') {
                        echo '<li class="breadcrumb-item active">Контакти</li>';
                    } else {
                        echo '<li class="breadcrumb-item active">' . htmlspecialchars($page_title) . '</li>';
                    }
                    ?>
                </ol>
            </div>
        </nav>
        <?php endif; ?>

    <!-- JavaScript -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
    
    <!-- Additional JS -->
    <?php if (isset($additional_js) && is_array($additional_js)): ?>
        <?php foreach ($additional_js as $js_file): ?>
            <script src="<?php echo htmlspecialchars($js_file); ?>"></script>
        <?php endforeach; ?>
    <?php endif; ?>
    
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        // Elements
        const menuToggle = document.getElementById('menuToggle');
        const slideMenu = document.getElementById('slideMenu');
        const slideMenuClose = document.getElementById('slideMenuClose');
        const menuOverlay = document.getElementById('menuOverlay');
        const submenuTriggers = document.querySelectorAll('.menu-item-toggle');
        const submenuBacks = document.querySelectorAll('.submenu-back');
        
        // Open menu
        if (menuToggle) {
            menuToggle.addEventListener('click', function() {
                slideMenu.classList.add('active');
                menuOverlay.classList.add('active');
                document.body.style.overflow = 'hidden';
                menuToggle.classList.add('active');
            });
        }
        
        // Close menu function
        function closeMenu() {
            slideMenu.classList.remove('active');
            menuOverlay.classList.remove('active');
            document.body.style.overflow = '';
            menuToggle.classList.remove('active');
            
            // Close all submenus
            document.querySelectorAll('.submenu.active').forEach(submenu => {
                submenu.classList.remove('active');
            });
        }
        
        // Close menu events
        if (slideMenuClose) {
            slideMenuClose.addEventListener('click', closeMenu);
        }
        if (menuOverlay) {
            menuOverlay.addEventListener('click', closeMenu);
        }
        
        // Submenu navigation
        submenuTriggers.forEach(trigger => {
            trigger.addEventListener('click', function() {
                const submenuId = this.getAttribute('data-submenu');
                const submenu = document.getElementById('submenu-' + submenuId);
                if (submenu) {
                    submenu.classList.add('active');
                }
            });
        });
        
        submenuBacks.forEach(back => {
            back.addEventListener('click', function() {
                const submenuId = this.getAttribute('data-submenu');
                const submenu = document.getElementById('submenu-' + submenuId);
                if (submenu) {
                    submenu.classList.remove('active');
                }
            });
        });
        
        // Close menu on link click
        document.querySelectorAll('.slide-menu a').forEach(link => {
            link.addEventListener('click', function() {
                if (!this.closest('.submenu-back') && !this.classList.contains('menu-item-toggle')) {
                    setTimeout(closeMenu, 150);
                }
            });
        });
        
        // Keyboard navigation
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' && slideMenu.classList.contains('active')) {
                closeMenu();
            }
        });
        
        // Navbar scroll effect
        const navbar = document.querySelector('.navbar');
        if (navbar) {
            window.addEventListener('scroll', function() {
                if (window.scrollY > 50) {
                    navbar.style.background = 'rgba(255, 255, 255, 0.95)';
                    navbar.style.backdropFilter = 'blur(10px)';
                } else {
                    navbar.style.background = '';
                    navbar.style.backdropFilter = '';
                }
            });
        }
    });
    </script>