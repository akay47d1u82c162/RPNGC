/* -------------------------------------------------------
   RPNGC · Admin Dashboard JavaScript Enhancements
   File: static/recruitment/js/admin_overrides.js
   ------------------------------------------------------- */

(function () {
    'use strict';

    // Wait for DOM to be ready
    document.addEventListener('DOMContentLoaded', function () {

        // ==================== Glass Particle Effect ====================
        function createParticleBackground() {
            const body = document.body;
            const existingCanvas = document.getElementById('particle-canvas');
            if (existingCanvas) return; // Already exists

            const canvas = document.createElement('canvas');
            canvas.id = 'particle-canvas';
            canvas.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        pointer-events: none;
        z-index: 1;
        opacity: 0.3;
      `;
            body.insertBefore(canvas, body.firstChild);

            const ctx = canvas.getContext('2d');
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;

            const particles = [];
            const particleCount = 50;

            class Particle {
                constructor() {
                    this.x = Math.random() * canvas.width;
                    this.y = Math.random() * canvas.height;
                    this.size = Math.random() * 2 + 1;
                    this.speedX = Math.random() * 0.5 - 0.25;
                    this.speedY = Math.random() * 0.5 - 0.25;
                    this.opacity = Math.random() * 0.5 + 0.2;
                }

                update() {
                    this.x += this.speedX;
                    this.y += this.speedY;

                    if (this.x > canvas.width) this.x = 0;
                    if (this.x < 0) this.x = canvas.width;
                    if (this.y > canvas.height) this.y = 0;
                    if (this.y < 0) this.y = canvas.height;
                }

                draw() {
                    ctx.fillStyle = `rgba(59, 130, 246, ${this.opacity})`;
                    ctx.beginPath();
                    ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
                    ctx.fill();
                }
            }

            function init() {
                for (let i = 0; i < particleCount; i++) {
                    particles.push(new Particle());
                }
            }

            function animate() {
                ctx.clearRect(0, 0, canvas.width, canvas.height);

                for (let i = 0; i < particles.length; i++) {
                    particles[i].update();
                    particles[i].draw();

                    // Draw connections
                    for (let j = i + 1; j < particles.length; j++) {
                        const dx = particles[i].x - particles[j].x;
                        const dy = particles[i].y - particles[j].y;
                        const distance = Math.sqrt(dx * dx + dy * dy);

                        if (distance < 120) {
                            ctx.strokeStyle = `rgba(59, 130, 246, ${0.15 * (1 - distance / 120)})`;
                            ctx.lineWidth = 0.5;
                            ctx.beginPath();
                            ctx.moveTo(particles[i].x, particles[i].y);
                            ctx.lineTo(particles[j].x, particles[j].y);
                            ctx.stroke();
                        }
                    }
                }

                requestAnimationFrame(animate);
            }

            // Handle window resize
            window.addEventListener('resize', function () {
                canvas.width = window.innerWidth;
                canvas.height = window.innerHeight;
            });

            init();
            animate();
        }

        // ==================== Enhanced Table Interactions ====================
        function enhanceTables() {
            const tables = document.querySelectorAll('table');

            tables.forEach(table => {
                // Wrap table if not already wrapped
                if (!table.parentElement.classList.contains('table-wrapper')) {
                    const wrapper = document.createElement('div');
                    wrapper.className = 'table-wrapper';
                    table.parentNode.insertBefore(wrapper, table);
                    wrapper.appendChild(table);
                }

                // Add row selection highlight
                const rows = table.querySelectorAll('tbody tr');
                rows.forEach(row => {
                    row.style.cursor = 'pointer';

                    row.addEventListener('click', function (e) {
                        // Don't highlight if clicking on a link or button
                        if (e.target.tagName === 'A' || e.target.tagName === 'BUTTON' ||
                            e.target.closest('a') || e.target.closest('button')) {
                            return;
                        }

                        rows.forEach(r => r.classList.remove('row-selected'));
                        this.classList.add('row-selected');
                    });
                });
            });

            // Add CSS for selected row
            const style = document.createElement('style');
            style.textContent = `
        .row-selected {
          background: rgba(59, 130, 246, 0.15) !important;
          box-shadow: inset 0 0 0 2px rgba(59, 130, 246, 0.3);
        }
      `;
            document.head.appendChild(style);
        }

        // ==================== Smooth Scroll ====================
        function enableSmoothScroll() {
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    const href = this.getAttribute('href');
                    if (href === '#') return;

                    e.preventDefault();
                    const target = document.querySelector(href);
                    if (target) {
                        target.scrollIntoView({
                            behavior: 'smooth',
                            block: 'start'
                        });
                    }
                });
            });
        }

        // ==================== Card Animations ====================
        function animateCards() {
            const cards = document.querySelectorAll('.card, .small-box, .info-box');

            const observer = new IntersectionObserver((entries) => {
                entries.forEach((entry, index) => {
                    if (entry.isIntersecting) {
                        setTimeout(() => {
                            entry.target.style.opacity = '1';
                            entry.target.style.transform = 'translateY(0)';
                        }, index * 50);
                        observer.unobserve(entry.target);
                    }
                });
            }, {
                threshold: 0.1
            });

            cards.forEach(card => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                card.style.transition = 'opacity 0.4s ease, transform 0.4s ease';
                observer.observe(card);
            });
        }

        // ==================== Form Enhancements ====================
        function enhanceForms() {
            // Add floating label effect
            const formGroups = document.querySelectorAll('.form-group');

            formGroups.forEach(group => {
                const input = group.querySelector('input, textarea, select');
                const label = group.querySelector('label');

                if (input && label) {
                    input.addEventListener('focus', () => {
                        label.style.color = 'rgba(59, 130, 246, 1)';
                        label.style.transform = 'scale(0.95)';
                        label.style.transition = 'all 0.2s ease';
                    });

                    input.addEventListener('blur', () => {
                        label.style.color = 'rgba(255, 255, 255, 0.9)';
                        label.style.transform = 'scale(1)';
                    });
                }
            });

            // Add ripple effect to buttons
            document.querySelectorAll('.btn').forEach(button => {
                button.addEventListener('click', function (e) {
                    const ripple = document.createElement('span');
                    const rect = this.getBoundingClientRect();
                    const size = Math.max(rect.width, rect.height);
                    const x = e.clientX - rect.left - size / 2;
                    const y = e.clientY - rect.top - size / 2;

                    ripple.style.cssText = `
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.5);
            width: ${size}px;
            height: ${size}px;
            left: ${x}px;
            top: ${y}px;
            pointer-events: none;
            animation: ripple 0.6s ease-out;
          `;

                    this.style.position = 'relative';
                    this.style.overflow = 'hidden';
                    this.appendChild(ripple);

                    setTimeout(() => ripple.remove(), 600);
                });
            });

            // Add ripple animation
            const style = document.createElement('style');
            style.textContent = `
        @keyframes ripple {
          from {
            transform: scale(0);
            opacity: 1;
          }
          to {
            transform: scale(2);
            opacity: 0;
          }
        }
      `;
            document.head.appendChild(style);
        }

        // ==================== Toast Notifications Enhancement ====================
        function enhanceNotifications() {
            const alerts = document.querySelectorAll('.alert');

            alerts.forEach(alert => {
                // Add slide-in animation
                alert.style.opacity = '0';
                alert.style.transform = 'translateX(100%)';
                alert.style.transition = 'all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55)';

                setTimeout(() => {
                    alert.style.opacity = '1';
                    alert.style.transform = 'translateX(0)';
                }, 100);

                // Auto-dismiss after 5 seconds (except errors)
                if (!alert.classList.contains('alert-danger')) {
                    setTimeout(() => {
                        alert.style.opacity = '0';
                        alert.style.transform = 'translateX(100%)';
                        setTimeout(() => alert.remove(), 400);
                    }, 5000);
                }

                // Add close button if not present
                if (!alert.querySelector('.close')) {
                    const closeBtn = document.createElement('button');
                    closeBtn.type = 'button';
                    closeBtn.className = 'close';
                    closeBtn.innerHTML = '&times;';
                    closeBtn.style.cssText = `
            float: right;
            font-size: 1.5rem;
            font-weight: 700;
            line-height: 1;
            color: rgba(255, 255, 255, 0.8);
            text-shadow: 0 1px 0 rgba(0, 0, 0, 0.3);
            opacity: 0.8;
            background: none;
            border: none;
            cursor: pointer;
            padding: 0;
            margin: -8px -4px 0 0;
          `;

                    closeBtn.addEventListener('click', () => {
                        alert.style.opacity = '0';
                        alert.style.transform = 'translateX(100%)';
                        setTimeout(() => alert.remove(), 400);
                    });

                    alert.insertBefore(closeBtn, alert.firstChild);
                }
            });
        }

        // ==================== Search Enhancement ====================
        function enhanceSearch() {
            const searchInputs = document.querySelectorAll('input[type="search"], input[name="q"]');

            searchInputs.forEach(input => {
                // Add search icon
                const wrapper = document.createElement('div');
                wrapper.style.position = 'relative';
                input.parentNode.insertBefore(wrapper, input);
                wrapper.appendChild(input);

                const icon = document.createElement('span');
                icon.innerHTML = '🔍';
                icon.style.cssText = `
          position: absolute;
          right: 12px;
          top: 50%;
          transform: translateY(-50%);
          pointer-events: none;
          opacity: 0.5;
        `;
                wrapper.appendChild(icon);

                input.style.paddingRight = '35px';

                // Add real-time feedback
                input.addEventListener('input', function () {
                    if (this.value.length > 0) {
                        icon.style.opacity = '1';
                        icon.style.transform = 'translateY(-50%) scale(1.1)';
                    } else {
                        icon.style.opacity = '0.5';
                        icon.style.transform = 'translateY(-50%) scale(1)';
                    }
                });
            });
        }

        // ==================== Sidebar State Persistence ====================
        function persistSidebarState() {
            const sidebar = document.querySelector('.main-sidebar');
            const body = document.body;

            if (!sidebar) return;

            // Restore sidebar state
            const sidebarCollapsed = localStorage.getItem('rpngc_sidebar_collapsed');
            if (sidebarCollapsed === 'true') {
                body.classList.add('sidebar-collapse');
            }

            // Listen for sidebar toggle
            const sidebarToggle = document.querySelector('[data-widget="pushmenu"]');
            if (sidebarToggle) {
                sidebarToggle.addEventListener('click', function () {
                    setTimeout(() => {
                        const isCollapsed = body.classList.contains('sidebar-collapse');
                        localStorage.setItem('rpngc_sidebar_collapsed', isCollapsed);
                    }, 100);
                });
            }
        }

        // ==================== Badge Pulse Animation ====================
        function animateBadges() {
            const badges = document.querySelectorAll('.badge');

            badges.forEach(badge => {
                // Add pulse to notification badges
                if (badge.textContent.match(/^\d+$/)) {
                    const value = parseInt(badge.textContent);
                    if (value > 0) {
                        badge.style.animation = 'badge-pulse 2s ease-in-out infinite';
                    }
                }
            });

            const style = document.createElement('style');
            style.textContent = `
        @keyframes badge-pulse {
          0%, 100% {
            transform: scale(1);
            box-shadow: 0 0 0 0 rgba(59, 130, 246, 0.7);
          }
          50% {
            transform: scale(1.05);
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0);
          }
        }
      `;
            document.head.appendChild(style);
        }

        // ==================== Loading States ====================
        function addLoadingStates() {
            const forms = document.querySelectorAll('form');

            forms.forEach(form => {
                form.addEventListener('submit', function (e) {
                    const submitBtn = this.querySelector('button[type="submit"], input[type="submit"]');

                    if (submitBtn && !submitBtn.disabled) {
                        submitBtn.disabled = true;
                        submitBtn.style.position = 'relative';
                        submitBtn.style.pointerEvents = 'none';

                        const originalText = submitBtn.textContent;
                        const spinner = document.createElement('span');
                        spinner.innerHTML = ' ⏳';
                        spinner.style.animation = 'spin 1s linear infinite';
                        submitBtn.appendChild(spinner);

                        // Re-enable after 3 seconds as fallback
                        setTimeout(() => {
                            submitBtn.disabled = false;
                            submitBtn.style.pointerEvents = 'auto';
                            submitBtn.textContent = originalText;
                        }, 3000);
                    }
                });
            });

            const style = document.createElement('style');
            style.textContent = `
        @keyframes spin {
          from { transform: rotate(0deg); }
          to { transform: rotate(360deg); }
        }
      `;
            document.head.appendChild(style);
        }

        // ==================== Keyboard Shortcuts ====================
        function setupKeyboardShortcuts() {
            document.addEventListener('keydown', function (e) {
                // Ctrl/Cmd + K: Focus search
                if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
                    e.preventDefault();
                    const searchInput = document.querySelector('input[type="search"], input[name="q"]');
                    if (searchInput) {
                        searchInput.focus();
                        searchInput.select();
                    }
                }

                // Ctrl/Cmd + B: Toggle sidebar
                if ((e.ctrlKey || e.metaKey) && e.key === 'b') {
                    e.preventDefault();
                    const sidebarToggle = document.querySelector('[data-widget="pushmenu"]');
                    if (sidebarToggle) {
                        sidebarToggle.click();
                    }
                }

                // ESC: Close modals and clear focus
                if (e.key === 'Escape') {
                    const modals = document.querySelectorAll('.modal.show');
                    if (modals.length > 0) {
                        modals.forEach(modal => {
                            const closeBtn = modal.querySelector('[data-dismiss="modal"]');
                            if (closeBtn) closeBtn.click();
                        });
                    } else {
                        document.activeElement.blur();
                    }
                }
            });
        }

        // ==================== Welcome Message Enhancement ====================
        function enhanceWelcomeMessage() {
            const contentHeader = document.querySelector('.content-header h1');

            if (contentHeader && contentHeader.textContent.includes('Welcome')) {
                const hour = new Date().getHours();
                let greeting = 'Welcome';

                if (hour < 12) greeting = 'Good Morning';
                else if (hour < 18) greeting = 'Good Afternoon';
                else greeting = 'Good Evening';

                const userSpan = contentHeader.querySelector('.text-muted');
                if (userSpan) {
                    contentHeader.childNodes[0].textContent = greeting + ' ';
                }

                // Add badge with current date
                const dateBadge = document.createElement('span');
                dateBadge.className = 'badge badge-primary ml-2';
                dateBadge.textContent = new Date().toLocaleDateString('en-US', {
                    weekday: 'short',
                    month: 'short',
                    day: 'numeric'
                });
                dateBadge.style.cssText = `
          font-size: 0.7em;
          vertical-align: middle;
          margin-left: 12px;
        `;
                contentHeader.appendChild(dateBadge);
            }
        }

        // ==================== Initialize All Enhancements ====================
        function init() {
            console.log('🚔 RPNGC Admin Portal - Initializing enhancements...');

            try {
                createParticleBackground();
                enhanceTables();
                enableSmoothScroll();
                animateCards();
                enhanceForms();
                enhanceNotifications();
                enhanceSearch();
                persistSidebarState();
                animateBadges();
                addLoadingStates();
                setupKeyboardShortcuts();
                enhanceWelcomeMessage();

                console.log('✅ All enhancements loaded successfully');
            } catch (error) {
                console.error('❌ Error loading enhancements:', error);
            }
        }

        // Run initialization
        init();

        // Re-run certain functions on dynamic content load
        const observer = new MutationObserver(function (mutations) {
            mutations.forEach(function (mutation) {
                if (mutation.addedNodes.length) {
                    enhanceNotifications();
                    animateBadges();
                }
            });
        });

        observer.observe(document.body, {
            childList: true,
            subtree: true
        });

    });

})();