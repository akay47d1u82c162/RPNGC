// recruitment/static/recruitment/js/admin_overrides.js
// Quick Actions collapsible sidebar for Django Admin (works with vanilla admin and Jazzmin)

// --- small helper so we don't depend on Font Awesome being present
function iconHTML(fa, fallback) {
    const hasFA = !!document.querySelector('link[href*="fontawesome"], link[href*="font-awesome"], link[href*="fontawesome.min.css"], link[href*="font-awesome.min.css"]');
    return hasFA ? `<i class="${fa}"></i>` : `<span class="ico-fallback" aria-hidden="true">${fallback || "•"}</span>`;
}

// Initialize collapsible action menu
document.addEventListener('DOMContentLoaded', function () {
    // Avoid double init
    if (document.getElementById('actionMenuSidebar')) return;
    initActionMenu();
});

function initActionMenu() {
    // Create toggle button
    const toggleBtn = document.createElement('button');
    toggleBtn.className = 'action-menu-toggle';
    toggleBtn.innerHTML = iconHTML('fas fa-tools', '🔧');
    toggleBtn.setAttribute('aria-label', 'Toggle Actions Menu');
    toggleBtn.setAttribute('title', 'Actions Menu');

    // Create sidebar
    const sidebar = document.createElement('div');
    sidebar.className = 'action-menu-sidebar';
    sidebar.id = 'actionMenuSidebar';

    // Add heading
    const heading = document.createElement('h4');
    heading.innerHTML = `${iconHTML('fas fa-cog', '⚙️')} Quick Actions`;
    sidebar.appendChild(heading);

    // Find and move action buttons
    const objectTools = document.querySelector('.object-tools');     // change page tools
    const changeformActions = document.querySelector('.submit-row'); // change form submit row

    // Collect add/change buttons from object-tools
    if (objectTools) {
        const links = objectTools.querySelectorAll('a');
        links.forEach(link => {
            const btn = createActionButton(link);
            sidebar.appendChild(btn);
        });
    }

    // Collect form action buttons
    if (changeformActions) {
        const formButtons = changeformActions.querySelectorAll('input[type="submit"], button');
        formButtons.forEach(btn => {
            const actionBtn = createFormActionButton(btn);
            if (actionBtn) {
                sidebar.appendChild(actionBtn);
            }
        });
    }

    // Add list page actions
    addListPageActions(sidebar);

    // Only add menu if there are actions
    if (sidebar.children.length > 1) {
        document.body.appendChild(toggleBtn);
        document.body.appendChild(sidebar);

        // Toggle functionality
        toggleBtn.addEventListener('click', function () {
            const isOpen = sidebar.classList.toggle('open');

            // Jazzmin has .content-wrapper; vanilla admin has .container or .content
            const contentWrapper =
                document.querySelector('.content-wrapper') ||
                document.querySelector('#content') ||
                document.querySelector('.container, .content');

            if (contentWrapper) {
                contentWrapper.classList.toggle('menu-open', isOpen);
            }

            // Update button icon
            toggleBtn.innerHTML = isOpen
                ? iconHTML('fas fa-times', '✖️')
                : iconHTML('fas fa-tools', '🔧');
        });

        // Close on outside click
        document.addEventListener('click', function (e) {
            if (!sidebar.contains(e.target) && !toggleBtn.contains(e.target)) {
                sidebar.classList.remove('open');
                toggleBtn.innerHTML = iconHTML('fas fa-tools', '🔧');
                const contentWrapper =
                    document.querySelector('.content-wrapper') ||
                    document.querySelector('#content') ||
                    document.querySelector('.container, .content');
                if (contentWrapper) {
                    contentWrapper.classList.remove('menu-open');
                }
            }
        });
    }
}

function createActionButton(link) {
    const btn = document.createElement('a');
    btn.href = link.href;
    btn.className = 'action-button';
    const text = (link.textContent || link.innerText || '').trim();

    // Determine icon based on text
    let icon = iconHTML('fas fa-plus', '➕');
    if (/Add/i.test(text)) icon = iconHTML('fas fa-plus', '➕');
    else if (/Change|Edit/i.test(text)) icon = iconHTML('fas fa-edit', '✏️');
    else if (/Delete/i.test(text)) icon = iconHTML('fas fa-trash', '🗑️');
    else if (/History/i.test(text)) icon = iconHTML('fas fa-history', '🕘');
    else if (/View/i.test(text)) icon = iconHTML('fas fa-eye', '👁️');

    btn.innerHTML = `${icon} ${text}`;
    return btn;
}

function createFormActionButton(button) {
    const btn = document.createElement('button');
    btn.className = 'action-button';
    btn.type = button.type || 'submit';
    btn.name = button.name;
    btn.value = button.value;

    const text = (button.value || button.textContent || '').trim();

    // Determine icon
    let icon = iconHTML('fas fa-save', '💾');
    if (/Save/i.test(text)) icon = iconHTML('fas fa-save', '💾');
    else if (/Delete/i.test(text)) icon = iconHTML('fas fa-trash', '🗑️');
    else if (/Continue/i.test(text)) icon = iconHTML('fas fa-arrow-right', '➡️');

    btn.innerHTML = `${icon} ${text}`;

    // Copy form reference
    const form = button.closest('form');
    if (form) {
        btn.addEventListener('click', function (e) {
            e.preventDefault();
            // Create hidden input to preserve original button name/value
            if (button.name) {
                const hiddenInput = document.createElement('input');
                hiddenInput.type = 'hidden';
                hiddenInput.name = button.name;
                hiddenInput.value = button.value;
                form.appendChild(hiddenInput);
            }
            form.submit();
        });
        return btn;
    }

    return null;
}

function addListPageActions(sidebar) {
    // Check if we're on a changelist page
    const changelist = document.querySelector('#changelist');
    if (!changelist) return;

    // Add "Add New" button if there's an add permission
    const addLink = document.querySelector('.object-tools .addlink, .addlink');
    if (addLink && addLink.href) {
        const addBtn = document.createElement('a');
        addBtn.href = addLink.href;
        addBtn.className = 'action-button';
        addBtn.innerHTML = `${iconHTML('fas fa-plus-circle', '🆕')} Add New`;
        sidebar.appendChild(addBtn);
    }

    // Add "Export" actions if available
    const exportLinks = document.querySelectorAll('a[href*="export"]');
    exportLinks.forEach(link => {
        const exportBtn = document.createElement('a');
        exportBtn.href = link.href;
        exportBtn.className = 'action-button';
        exportBtn.innerHTML = `${iconHTML('fas fa-download', '⬇️')} ${link.textContent.trim()}`;
        sidebar.appendChild(exportBtn);
    });

    // Add "Filter" toggle
    const filterSidebar = document.querySelector('#changelist-filter');
    if (filterSidebar) {
        const filterBtn = document.createElement('button');
        filterBtn.className = 'action-button';
        filterBtn.innerHTML = `${iconHTML('fas fa-filter', '🧰')} Toggle Filters`;
        filterBtn.addEventListener('click', function (e) {
            e.preventDefault();
            filterSidebar.style.display = filterSidebar.style.display === 'none' ? 'block' : 'none';
        });
        sidebar.appendChild(filterBtn);
    }
}

// Keyboard shortcut: Alt+A to toggle menu
document.addEventListener('keydown', function (e) {
    if (e.altKey && (e.key === 'a' || e.key === 'A')) {
        e.preventDefault();
        const toggleBtn = document.querySelector('.action-menu-toggle');
        if (toggleBtn) toggleBtn.click();
    }
});
