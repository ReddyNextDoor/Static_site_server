// Update timestamp on page load
document.addEventListener('DOMContentLoaded', function() {
    const timestampElement = document.getElementById('timestamp');
    if (timestampElement) {
        const now = new Date();
        timestampElement.textContent = now.toLocaleString();
    }
    
    // Smooth scrolling for navigation links
    const navLinks = document.querySelectorAll('.nav-links a');
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href').substring(1);
            const targetElement = document.getElementById(targetId);
            
            if (targetElement) {
                const offsetTop = targetElement.offsetTop - 80; // Account for fixed header
                window.scrollTo({
                    top: offsetTop,
                    behavior: 'smooth'
                });
            }
        });
    });
    
    // Add deployment status indicator
    const deploymentStatus = document.createElement('div');
    deploymentStatus.innerHTML = `
        <div style="position: fixed; bottom: 20px; right: 20px; background: #28a745; color: white; padding: 10px 15px; border-radius: 5px; font-size: 0.9rem; box-shadow: 0 2px 10px rgba(0,0,0,0.2);">
            ✓ Deployed via rsync
        </div>
    `;
    document.body.appendChild(deploymentStatus);
});