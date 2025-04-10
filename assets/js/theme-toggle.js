const savedTheme = localStorage.getItem('theme');
if (savedTheme) {
    document.documentElement.setAttribute('data-theme', savedTheme);
} else if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
    document.documentElement.setAttribute('data-theme', 'dark');
}

function toggleTheme() {
    alert('toggleTheme function called!'); // Debug alert
    const currentTheme = document.documentElement.getAttribute('data-theme');
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', newTheme);
    localStorage.setItem('theme', newTheme);
}

// Attach the event listener to the button
const themeToggleButton = document.getElementById('theme-toggle');
if (themeToggleButton) {
    themeToggleButton.addEventListener('click', toggleTheme);
} else {
    console.error("Theme toggle button not found in the DOM!");
}