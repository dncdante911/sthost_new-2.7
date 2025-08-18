<?php
/**
 * StormHosting UA - Главная страница
 * Файл: /pages/home.php
 */

// Защита от прямого доступа
if (!defined('SECURE_ACCESS')) {
    http_response_code(403);
    die('Доступ запрещен');
}

// Функции-заглушки если не определены
if (!function_exists('escapeOutput')) {
    function escapeOutput($text) {
        return htmlspecialchars($text, ENT_QUOTES, 'UTF-8');
    }
}

if (!function_exists('formatPrice')) {
    function formatPrice($price, $currency = 'грн') {
        return number_format($price, 0, '.', ' ') . ' ' . $currency;
    }
}

if (!function_exists('t')) {
    function t($key) {
        $translations = [
            'hero_title' => 'Професійний хостинг з підтримкою 24/7',
            'hero_subtitle' => 'Швидкі SSD сервери, безкоштовний SSL, миттєва активація. Найкращий хостинг для вашого бізнесу в Україні!'
        ];
        return $translations[$key] ?? $key;
    }
}

// Текущий язык
$current_lang = $current_lang ?? 'ua';
?>
<!DOCTYPE html>
<html lang="<?php echo $current_lang; ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo escapeOutput($page_title ?? 'StormHosting UA - Надійний хостинг-провайдер України'); ?></title>
    <meta name="description" content="<?php echo escapeOutput($meta_description ?? 'StormHosting UA - професійний хостинг, VDS/VPS сервери, реєстрація доменів'); ?>">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <?php if (file_exists('assets/css/home.css')): ?>
    <link href="/assets/css/home.css" rel="stylesheet">
    <?php endif; ?>
    
   
</head>
<body>

<!-- Hero Section -->
<section class="hero-section">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <h1 class="hero-title"><?php echo t('hero_title'); ?></h1>
                <p class="hero-subtitle"><?php echo t('hero_subtitle'); ?></p>
                
                <div class="hero-buttons">
                    <a href="/pages/hosting/shared.php" class="btn-hero-primary">
                        <i class="bi bi-rocket-takeoff"></i>
                        Обрати хостинг
                    </a>
                    <a href="/pages/domains/register.php" class="btn-hero-outline">
                        <i class="bi bi-globe"></i>
                        Зареєструвати домен
                    </a>
                    <a href="/pages/vds/virtual.php" class="btn-hero-outline">
                        <i class="bi bi-server"></i>
                        VDS сервери
                    </a>
                </div>
            </div>
            <div class="col-lg-4 text-center d-none d-lg-block">
                <i class="bi bi-server" style="font-size: 180px; opacity: 0.3;"></i>
            </div>
        </div>
    </div>
</section>

<!-- Statistics -->
<section class="stats-section">
    <div class="container">
        <div class="row text-center">
            <div class="col-6 col-md-3">
                <div class="stat-item">
                    <div class="stat-number" data-target="15000">0</div>
                    <div class="stat-label">Активних сайтів</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-item">
                    <div class="stat-number" data-target="99.9">0</div>
                    <div class="stat-label">% Аптайм</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-item">
                    <div class="stat-number" data-target="8">0</div>
                    <div class="stat-label">Років досвіду</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-item">
                    <div class="stat-number" data-target="24">0</div>
                    <div class="stat-label">Години підтримки</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Features Section -->
<section class="py-5 bg-light">
    <div class="container">
        <div class="row text-center mb-5">
            <div class="col-12">
                <h2 class="display-5 fw-bold">Чому обирають StormHosting UA?</h2>
                <p class="lead text-muted">Ми надаємо найкращі послуги хостингу в Україні</p>
            </div>
        </div>
        
        <div class="row g-4">
            <div class="col-lg-3 col-md-6">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="bi bi-speedometer2"></i>
                    </div>
                    <h4>99.9% Аптайм</h4>
                    <p>Гарантована стабільність роботи ваших сайтів</p>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="bi bi-headset"></i>
                    </div>
                    <h4>Підтримка 24/7</h4>
                    <p>Швидка технічна підтримка в будь-який час</p>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="bi bi-shield-check"></i>
                    </div>
                    <h4>Безкоштовний SSL</h4>
                    <p>Let's Encrypt сертифікати для всіх сайтів</p>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="bi bi-cloud-upload"></i>
                    </div>
                    <h4>Автобекапи</h4>
                    <p>Щоденне резервне копіювання даних</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Popular Domains -->
<section class="py-5">
    <div class="container">
        <div class="row text-center mb-5">
            <div class="col-12">
                <h2 class="display-6 fw-bold">Популярні домени</h2>
                <p class="lead text-muted">Зареєструйте домен за найкращою ціною</p>
            </div>
        </div>
        
        <div class="row g-3 justify-content-center">
            <?php foreach (array_slice($popular_domains, 0, 5) as $domain): ?>
            <div class="col-lg-2 col-md-4 col-6">
                <div class="domain-card">
                    <div class="domain-zone"><?php echo escapeOutput($domain['zone']); ?></div>
                    <div class="text-muted small">від</div>
                    <div class="domain-price fw-bold"><?php echo formatPrice($domain['price_registration']); ?></div>
                    <div class="text-muted small">грн/рік</div>
                    <a href="/pages/domains/register.php" class="btn btn-primary btn-sm mt-2 w-100">Зареєструвати</a>
                </div>
            </div>
            <?php endforeach; ?>
        </div>
    </div>
</section>

<!-- Hosting Plans -->
<section class="py-5 bg-light">
    <div class="container">
        <div class="row text-center mb-5">
            <div class="col-12">
                <h2 class="display-6 fw-bold">Тарифні плани хостингу</h2>
                <p class="lead text-muted">Оберіть ідеальний план для вашого проекту</p>
            </div>
        </div>
        
        <div class="row g-4 justify-content-center">
            <?php foreach ($popular_hosting as $plan): ?>
            <div class="col-lg-4 col-md-6">
                <div class="hosting-plan-card <?php echo $plan['is_popular'] ? 'popular' : ''; ?>">
                    <?php if ($plan['is_popular']): ?>
                    <div class="popular-badge">Популярний</div>
                    <?php endif; ?>
                    
                    <div class="text-center mb-4">
                        <h3 class="fw-bold"><?php echo escapeOutput($plan['name_' . $current_lang] ?? $plan['name_ua']); ?></h3>
                        <div class="hosting-price"><?php echo formatPrice($plan['price_monthly']); ?></div>
                        <div class="text-muted">грн/міс</div>
                    </div>
                    
                    <ul class="hosting-features">
                        <li><?php echo $plan['disk_space'] / 1024; ?> ГБ дискового простору</li>
                        <li><?php echo $plan['bandwidth']; ?> ГБ трафіку</li>
                        <li><?php echo $plan['databases']; ?> бази даних</li>
                        <li><?php echo $plan['email_accounts']; ?> поштових скриньок</li>
                        <li>Безкоштовний SSL</li>
                        <li>Щоденні бекапи</li>
                    </ul>
                    
                    <div class="text-center mt-4">
                        <a href="/pages/hosting/shared.php" class="btn btn-primary w-100">Замовити зараз</a>
                    </div>
                </div>
            </div>
            <?php endforeach; ?>
        </div>
    </div>
</section>

<!-- Tools Section -->
<section class="py-5">
    <div class="container">
        <div class="row text-center mb-5">
            <div class="col-12">
                <h2 class="display-6 fw-bold">Корисні інструменти</h2>
                <p class="lead text-muted">Безкоштовні інструменти для вебмастерів</p>
            </div>
        </div>
        
        <div class="row g-4">
            <div class="col-lg-3 col-md-6">
                <div class="tool-card">
                    <div class="tool-icon">
                        <i class="bi bi-search"></i>
                    </div>
                    <h5>WHOIS перевірка</h5>
                    <p>Дізнайтеся інформацію про власника домену</p>
                    <a href="/pages/domains/whois.php" class="btn btn-outline-primary btn-sm">Перевірити</a>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6">
                <div class="tool-card">
                    <div class="tool-icon">
                        <i class="bi bi-speedometer2"></i>
                    </div>
                    <h5>Перевірка сайту</h5>
                    <p>Протестуйте доступність вашого сайту</p>
                    <a href="/pages/tools/site-check.php" class="btn btn-outline-primary btn-sm">Перевірити</a>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6">
                <div class="tool-card">
                    <div class="tool-icon">
                        <i class="bi bi-geo-alt"></i>
                    </div>
                    <h5>Перевірка IP</h5>
                    <p>Визначте геолокацію та інформацію про IP</p>
                    <a href="/pages/tools/ip-check.php" class="btn btn-outline-primary btn-sm">Перевірити</a>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6">
                <div class="tool-card">
                    <div class="tool-icon">
                        <i class="bi bi-calculator"></i>
                    </div>
                    <h5>Калькулятор VDS</h5>
                    <p>Розрахуйте вартість VDS сервера</p>
                    <a href="/pages/vds/vds-calc.php" class="btn btn-outline-primary btn-sm">Розрахувати</a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Bootstrap JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

<script>
// Анимация счетчиков
document.addEventListener('DOMContentLoaded', function() {
    function animateCounters() {
        const counters = document.querySelectorAll('.stat-number');
        
        counters.forEach(counter => {
            const target = parseFloat(counter.getAttribute('data-target'));
            const duration = 2000;
            const increment = target / (duration / 16);
            let current = 0;
            
            const updateCounter = () => {
                if (current < target) {
                    current += increment;
                    if (current > target) current = target;
                    
                    if (target === 99.9) {
                        counter.textContent = current.toFixed(1);
                    } else {
                        counter.textContent = Math.floor(current);
                    }
                    
                    requestAnimationFrame(updateCounter);
                } else {
                    if (target === 99.9) {
                        counter.textContent = target.toFixed(1);
                    } else {
                        counter.textContent = target;
                    }
                }
            };
            
            updateCounter();
        });
    }

    // Observer для счетчиков
    const statsObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
                animateCounters();
                statsObserver.unobserve(entry.target);
            }
        });
    }, { threshold: 0.5 });

    const statsSection = document.querySelector('.stats-section');
    if (statsSection) {
        statsObserver.observe(statsSection);
    }

    // Анимация появления карточек
    const cardObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
                cardObserver.unobserve(entry.target);
            }
        });
    }, { threshold: 0.1 });

    // Применяем анимацию к карточкам
    const cards = document.querySelectorAll('.feature-card, .domain-card, .hosting-plan-card, .tool-card');
    cards.forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        card.style.transition = `opacity 0.6s ease ${index * 0.1}s, transform 0.6s ease ${index * 0.1}s`;
        cardObserver.observe(card);
    });

    // Плавная прокрутка для якорных ссылок
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth'
                });
            }
        });
    });

    console.log('🏠 StormHosting Home Page loaded successfully');
});
</script>
<script src="/assets/js/home.js"></script>
<?php include $_SERVER['DOCUMENT_ROOT'] . '/includes/footer.php'; ?>
</body>
</html>