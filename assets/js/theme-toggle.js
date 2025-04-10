const savedTheme = localStorage.getItem('theme');
if (savedTheme) {
    document.documentElement.setAttribute('data-theme', savedTheme);
    console.log(`Loaded saved theme: ${savedTheme}`);
} else if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
    document.documentElement.setAttribute('data-theme', 'dark');
    console.log('System prefers dark theme. Setting theme to dark.');
} else {
    document.documentElement.setAttribute('data-theme', 'light');
    console.log('System prefers light theme. Setting theme to light.');
}

function toggleTheme() {
    const currentTheme = document.documentElement.getAttribute('data-theme');
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
    console.log(`Switching theme from ${currentTheme} to ${newTheme}`);
    document.documentElement.setAttribute('data-theme', newTheme);
    localStorage.setItem('theme', newTheme);
    console.log(`Theme set to ${newTheme} and saved to localStorage.`);
}

const themeToggleButton = document.getElementById('theme-toggle');
if (themeToggleButton) {
    themeToggleButton.addEventListener('click', toggleTheme);
} else {
    console.error("Theme toggle button not found in the DOM!");
}