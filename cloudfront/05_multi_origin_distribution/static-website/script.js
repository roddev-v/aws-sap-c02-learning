// Initialize map centered on world view
const map = L.map('map').setView([0, 0], 2);

// Add OpenStreetMap tiles
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '© OpenStreetMap contributors',
    maxZoom: 19,
}).addTo(map);

// Create custom ISS icon
const issIcon = L.icon({
    iconUrl: 'data:image/svg+xml;base64,' + btoa(`
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="50" height="50">
            <circle cx="50" cy="50" r="45" fill="#4CAF50" opacity="0.3"/>
            <circle cx="50" cy="50" r="20" fill="#4CAF50"/>
            <text x="50" y="58" font-size="24" text-anchor="middle" fill="white">🛰️</text>
        </svg>
    `),
    iconSize: [50, 50],
    iconAnchor: [25, 25],
});

// Initialize marker and path
let issMarker = null;
let issPath = [];
let pathPolyline = null;

// DOM elements
const latElement = document.getElementById('latitude');
const lonElement = document.getElementById('longitude');
const statusElement = document.getElementById('status');

// Fetch ISS position
async function getISSPosition() {
    try {
        const response = await fetch('https://api.wheretheiss.at/v1/satellites/25544');
        
        if (!response.ok) {
            throw new Error('Failed to fetch ISS position');
        }
        
        const data = await response.json();
        updateISSPosition(data.latitude, data.longitude);
        statusElement.textContent = `Last updated: ${new Date().toLocaleTimeString()}`;
        statusElement.classList.remove('error');
        
    } catch (error) {
        console.error('Error fetching ISS position:', error);
        statusElement.textContent = 'Error fetching ISS position';
        statusElement.classList.add('error');
    }
}

// Update ISS position on map
function updateISSPosition(lat, lon) {
    // Update info cards
    latElement.textContent = lat.toFixed(4) + '°';
    lonElement.textContent = lon.toFixed(4) + '°';
    
    // Add to path
    issPath.push([lat, lon]);
    
    // Keep only last 50 positions
    if (issPath.length > 50) {
        issPath.shift();
    }
    
    // Update or create marker
    if (issMarker) {
        issMarker.setLatLng([lat, lon]);
    } else {
        issMarker = L.marker([lat, lon], { icon: issIcon })
            .addTo(map)
            .bindPopup('International Space Station')
            .openPopup();
    }
    
    // Update path
    if (pathPolyline) {
        pathPolyline.setLatLngs(issPath);
    } else {
        pathPolyline = L.polyline(issPath, {
            color: '#4CAF50',
            weight: 3,
            opacity: 0.7,
            dashArray: '10, 5'
        }).addTo(map);
    }
    
    // Center map on ISS (only on first load)
    if (issPath.length === 1) {
        map.setView([lat, lon], 4);
    }
}

// Initial fetch
getISSPosition();

// Update every 5 seconds
setInterval(getISSPosition, 5000);