// Cursor tracking with glow effect
const cursorGlow = document.querySelector('.cursor-glow');
const cards = document.querySelectorAll('.card');

let mouseX = 0;
let mouseY = 0;
let glowX = 0;
let glowY = 0;

// Track mouse position
document.addEventListener('mousemove', (e) => {
    mouseX = e.clientX;
    mouseY = e.clientY;
});

// Smooth animation for cursor glow
function animateGlow() {
    // Smooth follow effect
    glowX += (mouseX - glowX) * 0.15;
    glowY += (mouseY - glowY) * 0.15;
    
    cursorGlow.style.left = glowX + 'px';
    cursorGlow.style.top = glowY + 'px';
    
    requestAnimationFrame(animateGlow);
}

animateGlow();

// Add interactive effect to cards
cards.forEach(card => {
    card.addEventListener('mouseenter', () => {
        cursorGlow.style.width = '800px';
        cursorGlow.style.height = '800px';
    });
    
    card.addEventListener('mouseleave', () => {
        cursorGlow.style.width = '600px';
        cursorGlow.style.height = '600px';
    });
    
    // Card tilt effect based on cursor position
    card.addEventListener('mousemove', (e) => {
        const rect = card.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        
        const centerX = rect.width / 2;
        const centerY = rect.height / 2;
        
        const rotateX = (y - centerY) / 10;
        const rotateY = (centerX - x) / 10;
        
        card.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) translateY(-10px)`;
    });
    
    card.addEventListener('mouseleave', () => {
        card.style.transform = 'perspective(1000px) rotateX(0) rotateY(0) translateY(0)';
    });
});