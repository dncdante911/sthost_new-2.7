/**
 * ============================================
 * Модальные окна авторизации - StormHosting UA
 * ============================================
 */

class AuthModal {
    constructor() {
        this.currentModal = null;
        this.init();
    }

    init() {
        this.createModals();
        this.bindEvents();
        console.log('AuthModal initialized');
    }

    /**
     * Создание HTML модальных окон
     */
    createModals() {
        // Создаем контейнер для модальных окон
        const modalContainer = document.createElement('div');
        modalContainer.id = 'authModals';
        modalContainer.innerHTML = this.getModalsHTML();
        document.body.appendChild(modalContainer);
    }

    /**
     * HTML модальных окон
     */
    getModalsHTML() {
        return `
            <!-- Модальное окно регистрации -->
            <div id="registerModal" class="auth-modal">
                <div class="auth-modal-content">
                    <button type="button" class="auth-modal-close" data-close="registerModal">
                        <i class="bi bi-x-lg"></i>
                    </button>
                    
                    <div class="auth-modal-header">
                        <h2><i class="bi bi-person-plus me-2"></i>Реєстрація</h2>
                        <p>Створіть обліковий запис у StormHosting UA</p>
                    </div>
                    
                    <div id="registerAlertContainer"></div>
                    
                    <form id="registerForm" class="auth-form" novalidate>
                        <input type="hidden" name="csrf_token" value="">
                        <input type="hidden" name="action" value="register">
                        
                        <div class="form-group">
                            <label for="reg_full_name" class="form-label">
                                <i class="bi bi-person"></i>Повне ім'я
                            </label>
                            <input type="text" 
                                   id="reg_full_name" 
                                   name="full_name" 
                                   class="form-control" 
                                   placeholder="Введіть ваше повне ім'я"
                                   required>
                            <div class="invalid-feedback"></div>
                        </div>
                        
                        <div class="form-group">
                            <label for="reg_email" class="form-label">
                                <i class="bi bi-envelope"></i>Email адреса
                            </label>
                            <input type="email" 
                                   id="reg_email" 
                                   name="email" 
                                   class="form-control" 
                                   placeholder="Введіть ваш email"
                                   required>
                            <div class="invalid-feedback"></div>
                        </div>
                        
                        <div class="form-group">
                            <label for="reg_phone" class="form-label">
                                <i class="bi bi-telephone"></i>Номер телефону (опціонально)
                            </label>
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="bi bi-telephone"></i>
                                </span>
                                <input type="tel" 
                                       id="reg_phone" 
                                       name="phone" 
                                       class="form-control" 
                                       placeholder="+380xxxxxxxxx">
                            </div>
                            <div class="invalid-feedback"></div>
                        </div>
                        
                        <div class="form-group">
                            <label for="reg_password" class="form-label">
                                <i class="bi bi-lock"></i>Пароль
                            </label>
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="bi bi-lock"></i>
                                </span>
                                <input type="password" 
                                       id="reg_password" 
                                       name="password" 
                                       class="form-control" 
                                       placeholder="Створіть надійний пароль"
                                       required>
                                <button type="button" class="btn btn-outline-secondary" data-toggle-password="reg_password">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                            <div class="password-strength">
                                <div class="strength-bar">
                                    <div class="strength-fill"></div>
                                </div>
                                <div class="strength-text">Пароль повинен містити мінімум 8 символів, великі і малі літери, цифри</div>
                            </div>
                            <div class="invalid-feedback"></div>
                        </div>
                        
                        <div class="form-group">
                            <label for="reg_password_confirm" class="form-label">
                                <i class="bi bi-lock-fill"></i>Підтвердження паролю
                            </label>
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="bi bi-lock-fill"></i>
                                </span>
                                <input type="password" 
                                       id="reg_password_confirm" 
                                       name="password_confirm" 
                                       class="form-control" 
                                       placeholder="Повторіть пароль"
                                       required>
                            </div>
                            <div class="invalid-feedback"></div>
                        </div>
                        
                        <div class="form-group">
                            <label for="reg_language" class="form-label">
                                <i class="bi bi-globe"></i>Мова інтерфейсу
                            </label>
                            <select id="reg_language" name="language" class="form-control">
                                <option value="ua" selected>Українська</option>
                                <option value="en">English</option>
                                <option value="ru">Русский</option>
                            </select>
                        </div>
                        
                        <div class="form-check">
                            <input type="checkbox" id="reg_accept_terms" name="accept_terms" class="form-check-input" required>
                            <label for="reg_accept_terms" class="form-check-label">
                                Я приймаю <a href="/pages/info/rules.php" target="_blank">умови використання</a> та 
                                <a href="/pages/info/legal.php" target="_blank">політику конфіденційності</a>
                            </label>
                            <div class="invalid-feedback"></div>
                        </div>
                        
                        <div class="form-check">
                            <input type="checkbox" id="reg_marketing_emails" name="marketing_emails" class="form-check-input">
                            <label for="reg_marketing_emails" class="form-check-label">
                                Я хочу отримувати новини та спеціальні пропозиції на email
                            </label>
                        </div>
                        
                        <button type="submit" class="btn btn-auth" id="registerSubmitBtn">
                            <div class="spinner-border spinner-border-sm loading-spinner" role="status"></div>
                            <span class="btn-text">Зареєструватися</span>
                        </button>
                    </form>
                    
                    <div class="auth-switch">
                        <p>Вже маєте обліковий запис? <a href="#" data-switch-to="loginModal">Увійдіть тут</a></p>
                    </div>
                </div>
            </div>

            <!-- Модальное окно входа -->
            <div id="loginModal" class="auth-modal">
                <div class="auth-modal-content">
                    <button type="button" class="auth-modal-close" data-close="loginModal">
                        <i class="bi bi-x-lg"></i>
                    </button>
                    
                    <div class="auth-modal-header">
                        <h2><i class="bi bi-box-arrow-in-right me-2"></i>Вхід</h2>
                        <p>Увійдіть в ваш обліковий запис</p>
                    </div>
                    
                    <div id="loginAlertContainer"></div>
                    
                    <form id="loginForm" class="auth-form" novalidate>
                        <input type="hidden" name="csrf_token" value="">
                        <input type="hidden" name="action" value="login">
                        
                        <div class="form-group">
                            <label for="login_email" class="form-label">
                                <i class="bi bi-envelope"></i>Email адреса
                            </label>
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="bi bi-envelope"></i>
                                </span>
                                <input type="email" 
                                       id="login_email" 
                                       name="email" 
                                       class="form-control" 
                                       placeholder="Введіть ваш email"
                                       required
                                       autocomplete="email">
                            </div>
                            <div class="invalid-feedback"></div>
                        </div>
                        
                        <div class="form-group">
                            <label for="login_password" class="form-label">
                                <i class="bi bi-lock"></i>Пароль
                            </label>
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="bi bi-lock"></i>
                                </span>
                                <input type="password" 
                                       id="login_password" 
                                       name="password" 
                                       class="form-control" 
                                       placeholder="Введіть ваш пароль"
                                       required
                                       autocomplete="current-password">
                                <button type="button" class="btn btn-outline-secondary" data-toggle-password="login_password">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                            <div class="invalid-feedback"></div>
                        </div>
                        
                        <div class="form-check">
                            <input type="checkbox" id="login_remember_me" name="remember_me" class="form-check-input">
                            <label for="login_remember_me" class="form-check-label">
                                Запам'ятати мене
                            </label>
                        </div>
                        
                        <button type="submit" class="btn btn-auth" id="loginSubmitBtn">
                            <div class="spinner-border spinner-border-sm loading-spinner" role="status"></div>
                            <span class="btn-text">Увійти</span>
                        </button>
                    </form>
                    
                    <div class="forgot-password">
                        <a href="#" data-forgot-password>Забули пароль?</a>
                    </div>
                    
                    <div class="auth-switch">
                        <p>Немає облікового запису? <a href="#" data-switch-to="registerModal">Зареєструйтеся тут</a></p>
                    </div>
                </div>
            </div>
        `;
    }

    /**
     * Привязка событий
     */
    bindEvents() {
        // Клик по кнопкам открытия модальных окон
        document.addEventListener('click', (e) => {
            if (e.target.matches('[data-open-register]')) {
                e.preventDefault();
                this.openModal('registerModal');
            }
            
            if (e.target.matches('[data-open-login]')) {
                e.preventDefault();
                this.openModal('loginModal');
            }
            
            // Переключение между модальными окнами
            if (e.target.matches('[data-switch-to]')) {
                e.preventDefault();
                const targetModal = e.target.getAttribute('data-switch-to');
                this.switchModal(targetModal);
            }
            
            // Закрытие модальных окон
            if (e.target.matches('[data-close]') || e.target.closest('[data-close]')) {
                e.preventDefault();
                const closeBtn = e.target.matches('[data-close]') ? e.target : e.target.closest('[data-close]');
                const modalId = closeBtn.getAttribute('data-close');
                this.closeModal(modalId);
            }
            
            // Показать/скрыть пароль
            if (e.target.matches('[data-toggle-password]') || e.target.closest('[data-toggle-password]')) {
                e.preventDefault();
                const btn = e.target.matches('[data-toggle-password]') ? e.target : e.target.closest('[data-toggle-password]');
                const inputId = btn.getAttribute('data-toggle-password');
                this.togglePassword(inputId);
            }
        });

        // Закрытие по клику вне модального окна
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('auth-modal')) {
                this.closeModal(e.target.id);
            }
        });

        // Закрытие по Escape
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && this.currentModal) {
                this.closeModal(this.currentModal);
            }
        });

        // Обработка форм
        this.bindFormEvents();
    }

    /**
     * Привязка событий форм
     */
    bindFormEvents() {
        // Форма регистрации
        const registerForm = document.getElementById('registerForm');
        if (registerForm) {
            registerForm.addEventListener('submit', (e) => this.handleRegisterSubmit(e));
            
            // Проверка силы пароля
            const passwordInput = document.getElementById('reg_password');
            if (passwordInput) {
                passwordInput.addEventListener('input', (e) => this.checkPasswordStrength(e.target));
            }
            
            // Проверка совпадения паролей
            const passwordConfirm = document.getElementById('reg_password_confirm');
            if (passwordConfirm) {
                passwordConfirm.addEventListener('input', () => this.validatePasswordMatch('register'));
            }
        }

        // Форма входа
        const loginForm = document.getElementById('loginForm');
        if (loginForm) {
            loginForm.addEventListener('submit', (e) => this.handleLoginSubmit(e));
        }

        // Получаем CSRF токен
        this.updateCSRFTokens();
    }

    /**
     * Обновление CSRF токенов
     */
    async updateCSRFTokens() {
        try {
            const response = await fetch('/api/get-csrf-token.php');
            const data = await response.json();
            
            if (data.success && data.token) {
                document.querySelector('#registerForm input[name="csrf_token"]').value = data.token;
                document.querySelector('#loginForm input[name="csrf_token"]').value = data.token;
            }
        } catch (error) {
            console.warn('Could not get CSRF token:', error);
            // Генерируем простой токен
            const token = this.generateSimpleToken();
            document.querySelector('#registerForm input[name="csrf_token"]').value = token;
            document.querySelector('#loginForm input[name="csrf_token"]').value = token;
        }
    }

    /**
     * Генерация простого токена
     */
    generateSimpleToken() {
        return Math.random().toString(36).substring(2) + Date.now().toString(36);
    }

    /**
     * Открытие модального окна
     */
    openModal(modalId) {
        this.closeAllModals();
        
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.classList.add('show');
            this.currentModal = modalId;
            document.body.style.overflow = 'hidden';
            
            // Фокус на первое поле
            setTimeout(() => {
                const firstInput = modal.querySelector('input[type="text"], input[type="email"]');
                if (firstInput) {
                    firstInput.focus();
                }
            }, 300);
        }
    }

    /**
     * Закрытие модального окна
     */
    closeModal(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.classList.remove('show');
            this.currentModal = null;
            document.body.style.overflow = '';
            
            // Очищаем форму и ошибки
            setTimeout(() => {
                this.clearForm(modalId);
            }, 300);
        }
    }

    /**
     * Закрытие всех модальных окон
     */
    closeAllModals() {
        const modals = document.querySelectorAll('.auth-modal');
        modals.forEach(modal => {
            modal.classList.remove('show');
        });
        this.currentModal = null;
        document.body.style.overflow = '';
    }

    /**
     * Переключение между модальными окнами
     */
    switchModal(targetModalId) {
        this.closeAllModals();
        setTimeout(() => {
            this.openModal(targetModalId);
        }, 150);
    }

    /**
     * Показать/скрыть пароль
     */
    togglePassword(inputId) {
        const input = document.getElementById(inputId);
        const btn = document.querySelector(`[data-toggle-password="${inputId}"]`);
        
        if (input && btn) {
            const type = input.getAttribute('type') === 'password' ? 'text' : 'password';
            input.setAttribute('type', type);
            
            const icon = btn.querySelector('i');
            if (icon) {
                icon.className = type === 'password' ? 'bi bi-eye' : 'bi bi-eye-slash';
            }
        }
    }

    /**
     * Проверка силы пароля
     */
    checkPasswordStrength(passwordInput) {
        const password = passwordInput.value;
        const strengthBar = document.querySelector('#registerModal .password-strength');
        const strengthFill = document.querySelector('#registerModal .strength-fill');
        
        if (strengthBar) {
            strengthBar.style.display = password.length > 0 ? 'block' : 'none';
        }
        
        if (password.length === 0) return;
        
        let strength = 0;
        
        // Критерии силы пароля
        if (password.length >= 8) strength++;
        if (/[a-z]/.test(password)) strength++;
        if (/[A-Z]/.test(password)) strength++;
        if (/\d/.test(password)) strength++;
        if (/[^a-zA-Z\d]/.test(password)) strength++;
        
        // Установка класса силы
        if (strengthFill) {
            strengthFill.className = 'strength-fill';
            if (strength === 1) strengthFill.classList.add('strength-weak');
            else if (strength === 2) strengthFill.classList.add('strength-fair');
            else if (strength === 3) strengthFill.classList.add('strength-good');
            else if (strength >= 4) strengthFill.classList.add('strength-strong');
        }
    }

    /**
     * Проверка совпадения паролей
     */
    validatePasswordMatch(formType) {
        const passwordInput = document.getElementById(`${formType === 'register' ? 'reg' : 'login'}_password`);
        const confirmInput = document.getElementById('reg_password_confirm');
        
        if (passwordInput && confirmInput && confirmInput.value) {
            if (confirmInput.value !== passwordInput.value) {
                this.showFieldError('password_confirm', 'Паролі не співпадають', 'registerModal');
            } else {
                this.clearFieldError('password_confirm', 'registerModal');
            }
        }
    }

    /**
     * Обработка отправки формы регистрации
     */
    async handleRegisterSubmit(e) {
        e.preventDefault();
        
        const form = e.target;
        const submitBtn = document.getElementById('registerSubmitBtn');
        
        // Валидация
        if (!this.validateRegisterForm(form)) {
            return;
        }
        
        // Показываем загрузку
        this.setLoadingState(submitBtn, true, 'Реєстрація...');
        this.clearErrors('registerModal');
        
        try {
            const formData = new FormData(form);
            
            const response = await fetch('/api/auth/register.php', {
                method: 'POST',
                body: formData,
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            });
            
            const data = await response.json();
            
            if (data.success) {
                this.showAlert('success', data.message, 'registerModal');
                
                // Перенаправляем или закрываем модальное окно
                setTimeout(() => {
                    if (data.redirect) {
                        window.location.href = data.redirect;
                    } else {
                        this.closeModal('registerModal');
                        // Показываем успешное уведомление на главной странице
                        this.showPageNotification('success', 'Реєстрація успішна! Ласкаво просимо!');
                    }
                }, 1500);
            } else {
                if (data.errors) {
                    this.showFieldErrors(data.errors, 'registerModal');
                }
                if (data.message) {
                    this.showAlert('danger', data.message, 'registerModal');
                }
            }
        } catch (error) {
            console.error('Registration error:', error);
            this.showAlert('danger', 'Виникла помилка під час реєстрації. Спробуйте ще раз.', 'registerModal');
        } finally {
            this.setLoadingState(submitBtn, false, 'Зареєструватися');
        }
    }

    /**
     * Обработка отправки формы входа
     */
    async handleLoginSubmit(e) {
        e.preventDefault();
        
        const form = e.target;
        const submitBtn = document.getElementById('loginSubmitBtn');
        
        // Валидация
        if (!this.validateLoginForm(form)) {
            return;
        }
        
        // Показываем загрузку
        this.setLoadingState(submitBtn, true, 'Вхід...');
        this.clearErrors('loginModal');
        
        try {
            const formData = new FormData(form);
            
            const response = await fetch('/api/auth/login.php', {
                method: 'POST',
                body: formData,
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            });
            
            const data = await response.json();
            
            if (data.success) {
                this.showAlert('success', data.message, 'loginModal');
                
                // Перенаправляем или обновляем страницу
                setTimeout(() => {
                    if (data.redirect) {
                        window.location.href = data.redirect;
                    } else {
                        window.location.reload();
                    }
                }, 1000);
            } else {
                if (data.errors) {
                    this.showFieldErrors(data.errors, 'loginModal');
                }
                if (data.message) {
                    this.showAlert('danger', data.message, 'loginModal');
                }
            }
        } catch (error) {
            console.error('Login error:', error);
            this.showAlert('danger', 'Виникла помилка під час входу. Спробуйте ще раз.', 'loginModal');
        } finally {
            this.setLoadingState(submitBtn, false, 'Увійти');
        }
    }

    /**
     * Валидация формы регистрации
     */
    validateRegisterForm(form) {
        let isValid = true;
        
        // Очищаем предыдущие ошибки
        this.clearErrors('registerModal');
        
        const email = form.email.value.trim();
        const password = form.password.value;
        const passwordConfirm = form.password_confirm.value;
        const fullName = form.full_name.value.trim();
        const acceptTerms = form.accept_terms.checked;
        
        // Валидация email
        if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            this.showFieldError('email', 'Введіть коректну email адресу', 'registerModal');
            isValid = false;
        }
        
        // Валидация пароля
        if (password.length < 8) {
            this.showFieldError('password', 'Пароль повинен містити мінімум 8 символів', 'registerModal');
            isValid = false;
        } else if (!/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$/.test(password)) {
            this.showFieldError('password', 'Пароль повинен містити великі і малі літери та цифри', 'registerModal');
            isValid = false;
        }
        
        // Валидация подтверждения пароля
        if (password !== passwordConfirm) {
            this.showFieldError('password_confirm', 'Паролі не співпадають', 'registerModal');
            isValid = false;
        }
        
        // Валидация имени
        if (!fullName || fullName.length < 2) {
            this.showFieldError('full_name', 'Введіть повне ім\'я (мінімум 2 символи)', 'registerModal');
            isValid = false;
        }
        
        // Валидация согласия с условиями
        if (!acceptTerms) {
            this.showFieldError('accept_terms', 'Необхідно прийняти умови використання', 'registerModal');
            isValid = false;
        }
        
        return isValid;
    }

    /**
     * Валидация формы входа
     */
    validateLoginForm(form) {
        let isValid = true;
        
        // Очищаем предыдущие ошибки
        this.clearErrors('loginModal');
        
        const email = form.email.value.trim();
        const password = form.password.value;
        
        // Валидация email
        if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            this.showFieldError('email', 'Введіть коректну email адресу', 'loginModal');
            isValid = false;
        }
        
        // Валидация пароля
        if (!password) {
            this.showFieldError('password', 'Введіть пароль', 'loginModal');
            isValid = false;
        }
        
        return isValid;
    }

    /**
     * Установка состояния загрузки
     */
    setLoadingState(button, loading, text) {
        if (!button) return;
        
        button.disabled = loading;
        
        const spinner = button.querySelector('.loading-spinner');
        const btnText = button.querySelector('.btn-text');
        
        if (spinner) {
            spinner.style.display = loading ? 'inline-block' : 'none';
        }
        
        if (btnText) {
            btnText.textContent = text;
        }
    }

    /**
     * Показать уведомление
     */
    showAlert(type, message, modalId) {
        const container = document.getElementById(`${modalId.replace('Modal', '')}AlertContainer`);
        if (!container) return;
        
        const alert = document.createElement('div');
        alert.className = `alert alert-${type} alert-dismissible fade show`;
        alert.innerHTML = `
            <div class="d-flex align-items-center">
                <i class="bi bi-${this.getAlertIcon(type)} me-2"></i>
                <div>${message}</div>
            </div>
            <button type="button" class="btn-close" onclick="this.parentElement.remove()"></button>
        `;
        
        container.appendChild(alert);
        
        // Автоматически скрыть через 5 секунд
        setTimeout(() => {
            if (alert.parentNode) {
                alert.remove();
            }
        }, 5000);
    }

    /**
     * Показать уведомление на главной странице
     */
    showPageNotification(type, message) {
        // Создаем уведомление в верхней части страницы
        let container = document.getElementById('pageNotifications');
        if (!container) {
            container = document.createElement('div');
            container.id = 'pageNotifications';
            container.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 10000;
                max-width: 400px;
            `;
            document.body.appendChild(container);
        }
        
        const notification = document.createElement('div');
        notification.className = `alert alert-${type} alert-dismissible fade show`;
        notification.style.cssText = `
            margin-bottom: 10px;
            backdrop-filter: blur(10px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        `;
        notification.innerHTML = `
            <div class="d-flex align-items-center">
                <i class="bi bi-${this.getAlertIcon(type)} me-2"></i>
                <div>${message}</div>
            </div>
            <button type="button" class="btn-close" onclick="this.parentElement.remove()"></button>
        `;
        
        container.appendChild(notification);
        
        // Автоматически скрыть через 5 секунд
        setTimeout(() => {
            if (notification.parentNode) {
                notification.remove();
            }
        }, 5000);
    }

    /**
     * Получить иконку для уведомления
     */
    getAlertIcon(type) {
        const icons = {
            'success': 'check-circle-fill',
            'danger': 'exclamation-triangle-fill',
            'warning': 'exclamation-circle-fill',
            'info': 'info-circle-fill'
        };
        return icons[type] || 'info-circle-fill';
    }

    /**
     * Показать ошибки полей
     */
    showFieldErrors(errors, modalId) {
        Object.keys(errors).forEach(field => {
            this.showFieldError(field, errors[field], modalId);
        });
    }

    /**
     * Показать ошибку поля
     */
    showFieldError(fieldName, message, modalId) {
        const modal = document.getElementById(modalId);
        if (!modal) return;
        
        const input = modal.querySelector(`[name="${fieldName}"]`);
        if (input) {
            input.classList.add('is-invalid');
            
            let feedback = input.parentNode.querySelector('.invalid-feedback');
            if (!feedback) {
                feedback = input.nextElementSibling;
                if (!feedback || !feedback.classList.contains('invalid-feedback')) {
                    feedback = document.createElement('div');
                    feedback.className = 'invalid-feedback';
                    input.parentNode.appendChild(feedback);
                }
            }
            
            if (feedback) {
                feedback.textContent = message;
            }
        }
    }

    /**
     * Очистить ошибку поля
     */
    clearFieldError(fieldName, modalId) {
        const modal = document.getElementById(modalId);
        if (!modal) return;
        
        const input = modal.querySelector(`[name="${fieldName}"]`);
        if (input) {
            input.classList.remove('is-invalid');
            
            const feedback = input.parentNode.querySelector('.invalid-feedback');
            if (feedback) {
                feedback.textContent = '';
            }
        }
    }

    /**
     * Очистить все ошибки
     */
    clearErrors(modalId) {
        const modal = document.getElementById(modalId);
        if (!modal) return;
        
        // Очищаем ошибки полей
        modal.querySelectorAll('.is-invalid').forEach(input => {
            input.classList.remove('is-invalid');
        });
        
        modal.querySelectorAll('.invalid-feedback').forEach(feedback => {
            feedback.textContent = '';
        });
        
        // Очищаем уведомления
        const alertContainer = modal.querySelector('[id$="AlertContainer"]');
        if (alertContainer) {
            alertContainer.innerHTML = '';
        }
    }

    /**
     * Очистить форму
     */
    clearForm(modalId) {
        const modal = document.getElementById(modalId);
        if (!modal) return;
        
        const form = modal.querySelector('form');
        if (form) {
            form.reset();
            this.clearErrors(modalId);
            
            // Скрываем индикатор силы пароля
            const strengthBar = modal.querySelector('.password-strength');
            if (strengthBar) {
                strengthBar.style.display = 'none';
            }
        }
    }
}

// Инициализация при загрузке DOM
document.addEventListener('DOMContentLoaded', function() {
    window.authModal = new AuthModal();
    console.log('AuthModal ready');
});