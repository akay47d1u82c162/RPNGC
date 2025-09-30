// Quick Actions collapsible sidebar for Django Admin (with FA fallback)
function iconHTML(fa, fallback) {
    const hasFA = !!document.querySelector('link[href*="fontawesome"], link[href*="font-awesome"]');
    return hasFA ? `<i class="${fa}"></i>` : `<span class="ico-fallback" aria-hidden="true">${fallback || "•"}</span>`;
}
document.addEventListener('DOMContentLoaded', function () {
    if (document.getElementById('actionMenuSidebar')) return;
    initActionMenu();
});
function initActionMenu() {
    const toggleBtn = document.createElement('button');
    toggleBtn.className = 'action-menu-toggle';
    toggleBtn.innerHTML = iconHTML('fas fa-tools', '🔧');
    toggleBtn.setAttribute('aria-label', 'Toggle Actions Menu');
    toggleBtn.setAttribute('title', 'Actions Menu');

    const sidebar = document.createElement('div');
    sidebar.className = 'action-menu-sidebar';
    sidebar.id = 'actionMenuSidebar';

    const heading = document.createElement('h4');
    heading.innerHTML = `${iconHTML('fas fa-cog', '⚙️')} Quick Actions`;
    sidebar.appendChild(heading);

    const objectTools = document.querySelector('.object-tools');
    const changeformActions = document.querySelector('.submit-row');

    if (objectTools) {
        objectTools.querySelectorAll('a').forEach(link => sidebar.appendChild(createActionButton(link)));
    }
    if (changeformActions) {
        changeformActions.querySelectorAll('input[type="submit"], button').forEach(btn => {
            const b = createFormActionButton(btn);
            if (b) sidebar.appendChild(b);
        });
    }
    addListPageActions(sidebar);

    if (sidebar.children.length > 1) {
        document.body.appendChild(toggleBtn);
        document.body.appendChild(sidebar);
        toggleBtn.addEventListener('click', function () {
            const isOpen = sidebar.classList.toggle('open');
            const contentWrapper =
                document.querySelector('.content-wrapper') ||
                document.querySelector('#content') ||
                document.querySelector('.container, .content');
            if (contentWrapper) contentWrapper.classList.toggle('menu-open', isOpen);
            toggleBtn.innerHTML = isOpen ? iconHTML('fas fa-times', '✖️') : iconHTML('fas fa-tools', '🔧');
        });
        document.addEventListener('click', function (e) {
            if (!sidebar.contains(e.target) && !toggleBtn.contains(e.target)) {
                sidebar.classList.remove('open');
                toggleBtn.innerHTML = iconHTML('fas fa-tools', '🔧');
                const contentWrapper =
                    document.querySelector('.content-wrapper') ||
                    document.querySelector('#content') ||
                    document.querySelector('.container, .content');
                if (contentWrapper) contentWrapper.classList.remove('menu-open');
            }
        });
    }
}
function createActionButton(link) {
    const btn = document.createElement('a');
    btn.href = link.href;
    btn.className = 'action-button';
    const text = (link.textContent || link.innerText || '').trim();
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
    let icon = iconHTML('fas fa-save', '💾');
    if (/Save/i.test(text)) icon = iconHTML('fas fa-save', '💾');
    else if (/Delete/i.test(text)) icon = iconHTML('fas fa-trash', '🗑️');
    else if (/Continue/i.test(text)) icon = iconHTML('fas fa-arrow-right', '➡️');
    btn.innerHTML = `${icon} ${text}`;
    const form = button.closest('form');
    if (form) {
        btn.addEventListener('click', function (e) {
            e.preventDefault();
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
    const changelist = document.querySelector('#changelist');
    if (!changelist) return;
    const addLink = document.querySelector('.object-tools .addlink, .addlink');
    if (addLink && addLink.href) {
        const addBtn = document.createElement('a');
        addBtn.href = addLink.href;
        addBtn.className = 'action-button';
        addBtn.innerHTML = `${iconHTML('fas fa-plus-circle', '🆕')} Add New`;
        sidebar.appendChild(addBtn);
    }
    document.querySelectorAll('a[href*="export"]').forEach(link => {
        const exportBtn = document.createElement('a');
        exportBtn.href = link.href;
        exportBtn.className = 'action-button';
        exportBtn.innerHTML = `${iconHTML('fas fa-download', '⬇️')} ${link.textContent.trim()}`;
        sidebar.appendChild(exportBtn);
    });
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
document.addEventListener('keydown', function (e) {
    if (e.altKey && (e.key === 'a' || e.key === 'A')) {
        e.preventDefault();
        const toggleBtn = document.querySelector('.action-menu-toggle');
        if (toggleBtn) toggleBtn.click();
    }
});
