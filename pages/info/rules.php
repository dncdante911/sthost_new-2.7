<?php
// Захист від прямого доступу
define('SECURE_ACCESS', true);

// Конфігурація сторінки
$page = 'rules';
$page_title = 'Правила надання послуг - StormHosting UA | Умови використання хостингу';
$meta_description = 'Правила надання послуг StormHosting UA: умови використання хостингу, VPS, доменів. Повний текст угоди та умов обслуговування.';
$meta_keywords = 'правила хостингу, умови користування, договір оферти, правила vps, правила доменів';

// Додаткові CSS та JS файли для цієї сторінки
$additional_css = [
    '/assets/css/pages/info-rules.css'
];

$additional_js = [
    '/assets/js/info-rules.js'
];

// Підключення конфігурації та БД
require_once $_SERVER['DOCUMENT_ROOT'] . '/includes/config.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/includes/db_connect.php';

// Підключення header
include $_SERVER['DOCUMENT_ROOT'] . '/includes/header.php';

// Категорії документів
$document_categories = [
    'general' => [
        'title' => 'Загальні положення',
        'icon' => 'bi-file-text',
        'description' => 'Основні правила та умови надання послуг StormHosting UA',
        'documents' => [
            [
                'name' => 'Договір публічної оферти',
                'file' => '/documents/rules/contract-offer.pdf',
                'size' => '2.4 MB',
                'updated' => '2024-01-15'
            ],
            [
                'name' => 'Загальні умови обслуговування',
                'file' => '/documents/rules/general-terms.pdf',
                'size' => '1.8 MB',
                'updated' => '2024-01-10'
            ],
            [
                'name' => 'Політика конфіденційності',
                'file' => '/documents/rules/privacy-policy.pdf',
                'size' => '1.2 MB',
                'updated' => '2024-01-05'
            ]
        ]
    ],
    'hosting' => [
        'title' => 'Правила хостингу',
        'icon' => 'bi-server',
        'description' => 'Умови використання віртуального хостингу та хмарних послуг',
        'documents' => [
            [
                'name' => 'Правила використання хостингу',
                'file' => '/documents/rules/hosting-rules.pdf',
                'size' => '2.1 MB',
                'updated' => '2024-01-12'
            ],
            [
                'name' => 'Технічні вимоги та обмеження',
                'file' => '/documents/rules/hosting-limits.pdf',
                'size' => '1.5 MB',
                'updated' => '2024-01-08'
            ],
            [
                'name' => 'Політика використання ресурсів',
                'file' => '/documents/rules/resource-policy.pdf',
                'size' => '1.3 MB',
                'updated' => '2024-01-03'
            ]
        ]
    ],
    'vps' => [
        'title' => 'Правила VPS/VDS',
        'icon' => 'bi-hdd-stack',
        'description' => 'Умови використання віртуальних та виділених серверів',
        'documents' => [
            [
                'name' => 'Правила користування VPS',
                'file' => '/documents/rules/vps-rules.pdf',
                'size' => '2.3 MB',
                'updated' => '2024-01-14'
            ],
            [
                'name' => 'Технічні характеристики VDS',
                'file' => '/documents/rules/vds-specs.pdf',
                'size' => '1.7 MB',
                'updated' => '2024-01-09'
            ],
            [
                'name' => 'Політика безпеки серверів',
                'file' => '/documents/rules/server-security.pdf',
                'size' => '1.9 MB',
                'updated' => '2024-01-06'
            ]
        ]
    ],
    'domains' => [
        'title' => 'Правила доменів',
        'icon' => 'bi-globe',
        'description' => 'Умови реєстрації та використання доменних імен',
        'documents' => [
            [
                'name' => 'Правила реєстрації доменів',
                'file' => '/documents/rules/domain-registration.pdf',
                'size' => '1.6 MB',
                'updated' => '2024-01-11'
            ],
            [
                'name' => 'Політика трансферу доменів',
                'file' => '/documents/rules/domain-transfer.pdf',
                'size' => '1.4 MB',
                'updated' => '2024-01-07'
            ],
            [
                'name' => 'Правила використання DNS',
                'file' => '/documents/rules/dns-rules.pdf',
                'size' => '1.1 MB',
                'updated' => '2024-01-02'
            ]
        ]
    ]
];
?>

<!-- Додаткові стилі для цієї сторінки -->
<?php if (isset($additional_css)): ?>
    <?php foreach ($additional_css as $css_file): ?>
        <link rel="stylesheet" href="<?php echo $css_file; ?>">
    <?php endforeach; ?>
<?php endif; ?>

<!-- Rules Hero Section -->
<section class="rules-hero">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6">
                <div class="hero-content">
                    <div class="rules-badge mb-3">
                        <i class="bi bi-shield-check"></i>
                        <span>Прозорі умови обслуговування</span>
                    </div>
                    <h1 class="display-4 fw-bold text-white mb-4">
                        Правила надання послуг
                    </h1>
                    <p class="lead text-white-50 mb-4">
                        Ознайомтеся з повними правилами та умовами використання послуг StormHosting UA. 
                        Всі документи доступні для завантаження у форматі PDF.
                    </p>
                    
                    <!-- Швидкі посилання -->
                    <div class="quick-links">
                        <a href="#general" class="quick-link">
                            <i class="bi bi-file-text"></i>
                            <span>Загальні положення</span>
                        </a>
                        <a href="#hosting" class="quick-link">
                            <i class="bi bi-server"></i>
                            <span>Правила хостингу</span>
                        </a>
                        <a href="#vps" class="quick-link">
                            <i class="bi bi-hdd-stack"></i>
                            <span>VPS/VDS</span>
                        </a>
                        <a href="#domains" class="quick-link">
                            <i class="bi bi-globe"></i>
                            <span>Домени</span>
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-6">
                <div class="hero-visual">
                    <div class="documents-preview">
                        <div class="preview-header">
                            <h6>Документообіг</h6>
                            <div class="doc-status">
                                <span class="status-dot"></span>
                                Актуальна версія
                            </div>
                        </div>
                        
                        <div class="doc-stats">
                            <div class="stat-item">
                                <div class="stat-number">12</div>
                                <div class="stat-label">Документів</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-number">4</div>
                                <div class="stat-label">Категорій</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-number">2024</div>
                                <div class="stat-label">Останнє оновлення</div>
                            </div>
                        </div>
                        
                        <div class="recent-updates">
                            <div class="update-title">Останні оновлення</div>
                            <div class="update-item">
                                <span class="update-date">15.01.2024</span>
                                <span class="update-text">Оновлено договір публічної оферти</span>
                                <span class="update-type">PDF</span>
                            </div>
                            <div class="update-item">
                                <span class="update-date">12.01.2024</span>
                                <span class="update-text">Нові правила хостингу</span>
                                <span class="update-type">PDF</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Document Categories Section -->
<section class="categories-section py-5">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="display-5 fw-bold">Категорії документів</h2>
            <p class="lead text-muted">Оберіть категорію для перегляду відповідних правил та умов</p>
        </div>
        
        <!-- Category Navigation -->
        <div class="category-nav mb-4">
            <?php foreach ($document_categories as $key => $category): ?>
                <button class="category-btn <?php echo $key === 'general' ? 'active' : ''; ?>" 
                        data-category="<?php echo $key; ?>">
                    <i class="<?php echo $category['icon']; ?>"></i>
                    <span><?php echo $category['title']; ?></span>
                </button>
            <?php endforeach; ?>
        </div>
        
        <!-- Document Sections -->
        <?php foreach ($document_categories as $key => $category): ?>
            <div class="category-section" id="<?php echo $key; ?>" 
                 style="<?php echo $key !== 'general' ? 'display: none;' : ''; ?>">
                <div class="category-header">
                    <div class="category-info">
                        <h3>
                            <i class="<?php echo $category['icon']; ?>"></i>
                            <?php echo $category['title']; ?>
                        </h3>
                        <p><?php echo $category['description']; ?></p>
                    </div>
                    <div class="category-actions">
                        <button class="btn btn-outline-primary" onclick="downloadAllCategory('<?php echo $key; ?>')">
                            <i class="bi bi-download"></i>
                            Завантажити всі
                        </button>
                    </div>
                </div>
                
                <div class="documents-grid">
                    <?php foreach ($category['documents'] as $document): ?>
                        <div class="document-card">
                            <div class="doc-icon">
                                <i class="bi bi-file-earmark-pdf"></i>
                            </div>
                            <div class="doc-info">
                                <h5><?php echo $document['name']; ?></h5>
                                <div class="doc-meta">
                                    <span class="doc-size">
                                        <i class="bi bi-hdd"></i>
                                        <?php echo $document['size']; ?>
                                    </span>
                                    <span class="doc-date">
                                        <i class="bi bi-calendar"></i>
                                        <?php echo date('d.m.Y', strtotime($document['updated'])); ?>
                                    </span>
                                </div>
                            </div>
                            <div class="doc-actions">
                                <button class="btn btn-primary btn-sm" onclick="viewDocument('<?php echo $document['file']; ?>')">
                                    <i class="bi bi-eye"></i>
                                    Переглянути
                                </button>
                                <button class="btn btn-outline-secondary btn-sm" onclick="downloadDocument('<?php echo $document['file']; ?>')">
                                    <i class="bi bi-download"></i>
                                    Завантажити
                                </button>
                            </div>
                        </div>
                    <?php endforeach; ?>
                </div>
            </div>
        <?php endforeach; ?>
    </div>
</section>

<!-- PDF Viewer Modal -->
<div class="modal fade" id="pdfViewerModal" tabindex="-1" aria-labelledby="pdfViewerModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="pdfViewerModalLabel">
                    <i class="bi bi-file-earmark-pdf me-2"></i>
                    Перегляд документа
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-0">
                <div class="pdf-viewer-container">
                    <div class="pdf-toolbar">
                        <div class="pdf-controls">
                            <button class="btn btn-sm btn-outline-secondary" id="pdfZoomOut">
                                <i class="bi bi-zoom-out"></i>
                            </button>
                            <span class="zoom-level">100%</span>
                            <button class="btn btn-sm btn-outline-secondary" id="pdfZoomIn">
                                <i class="bi bi-zoom-in"></i>
                            </button>
                        </div>
                        <div class="pdf-info">
                            <span id="pdfFileName">document.pdf</span>
                        </div>
                        <div class="pdf-actions">
                            <button class="btn btn-sm btn-outline-primary" id="pdfFullscreen">
                                <i class="bi bi-fullscreen"></i>
                            </button>
                            <button class="btn btn-sm btn-primary" id="pdfDownload">
                                <i class="bi bi-download"></i>
                                Завантажити
                            </button>
                        </div>
                    </div>
                    <iframe id="pdfViewer" src="" frameborder="0"></iframe>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Document Management Section (Admin) -->
<section class="management-section py-5 bg-light" style="display: none;" id="adminSection">
    <div class="container">
        <div class="row">
            <div class="col-lg-8">
                <h3>Управління документами</h3>
                <p class="text-muted">Завантажте нові документи або оновіть існуючі</p>
            </div>
            <div class="col-lg-4 text-end">
                <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#uploadModal">
                    <i class="bi bi-upload"></i>
                    Завантажити документ
                </button>
            </div>
        </div>
        
        <div class="admin-documents-table mt-4">
            <div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>Документ</th>
                            <th>Категорія</th>
                            <th>Розмір</th>
                            <th>Останнє оновлення</th>
                            <th>Дії</th>
                        </tr>
                    </thead>
                    <tbody id="adminDocumentsTable">
                        <!-- Динамічно заповнюється JavaScript -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</section>

<!-- Upload Modal -->
<div class="modal fade" id="uploadModal" tabindex="-1" aria-labelledby="uploadModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="uploadModalLabel">
                    <i class="bi bi-upload me-2"></i>
                    Завантажити документ
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="uploadForm" enctype="multipart/form-data">
                    <div class="mb-3">
                        <label for="documentName" class="form-label">Назва документа</label>
                        <input type="text" class="form-control" id="documentName" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="documentCategory" class="form-label">Категорія</label>
                        <select class="form-select" id="documentCategory" required>
                            <option value="">Оберіть категорію</option>
                            <option value="general">Загальні положення</option>
                            <option value="hosting">Правила хостингу</option>
                            <option value="vps">Правила VPS/VDS</option>
                            <option value="domains">Правила доменів</option>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label for="documentFile" class="form-label">Файл документа</label>
                        <input type="file" class="form-control" id="documentFile" accept=".pdf" required>
                        <div class="form-text">Підтримуються лише PDF файли (макс. 10 МБ)</div>
                    </div>
                    
                    <div class="upload-progress" style="display: none;">
                        <div class="progress">
                            <div class="progress-bar" role="progressbar" style="width: 0%"></div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Скасувати</button>
                <button type="button" class="btn btn-primary" id="uploadDocument">
                    <i class="bi bi-upload"></i>
                    Завантажити
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Contact CTA Section -->
<section class="contact-cta py-5 bg-primary">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <h3 class="text-white mb-3">Маєте питання щодо правил?</h3>
                <p class="text-white-50 mb-0">
                    Наша юридична служба готова надати роз'яснення щодо будь-яких аспектів 
                    наших правил та умов обслуговування.
                </p>
            </div>
            <div class="col-lg-4 text-lg-end">
                <a href="/pages/contacts.php" class="btn btn-light btn-lg">
                    <i class="bi bi-chat-dots me-2"></i>
                    Зв'язатися з юристом
                </a>
            </div>
        </div>
    </div>
</section>

<!-- Додаткові скрипти для цієї сторінки -->
<?php if (isset($additional_js)): ?>
    <?php foreach ($additional_js as $js_file): ?>
        <script src="<?php echo $js_file; ?>"></script>
    <?php endforeach; ?>
<?php endif; ?>

<?php include $_SERVER['DOCUMENT_ROOT'] . '/includes/footer.php'; ?>