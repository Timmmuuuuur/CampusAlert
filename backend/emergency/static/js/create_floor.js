// your_custom.js

// Initialize the map
var map = L.map('map').setView([51.505, -0.09], 13);

// Add a base tile layer (you can customize the tile layer)
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
}).addTo(map);

var clickCount = 0;
var coordinates = [];

// Create an icon for the clicked points
var icon = L.divIcon({ className: 'custom-icon', html: '📍' });

// Add a click event listener to the map
map.on('click', function (e) {
    if (clickCount === 0) {
        // First click, display an icon
        L.marker(e.latlng, { icon: icon }).addTo(map);
        coordinates.push(e.latlng);
        clickCount++;
    } else if (clickCount === 1) {
        // Second click, display the image overlay
        coordinates.push(e.latlng);

        // Calculate the bounds for the image overlay
        var topLeft = coordinates[0];
        var bottomRight = coordinates[1];

        // Load and display the uploaded image
        var imageUrl = "{% static 'your_uploaded_image.jpg' %}";  // Replace with your image URL
        var imageBounds = [topLeft, bottomRight];
        var imageOverlay = L.imageOverlay(imageUrl, imageBounds).addTo(map);

        // Calculate the rotation and scaling
        var rotation = 0; // Add your logic to calculate the rotation angle
        var scaling = 1; // Add your logic to calculate the scaling factor

        // Apply rotation and scaling to the image
        imageOverlay.setRotation(rotation);
        imageOverlay.setLatLngs(imageBounds); // Adjust the bounds after rotation
        imageOverlay.setOpacity(1); // Adjust the opacity as needed

        // Reset the clickCount and coordinates array
        clickCount = 0;
        coordinates = [];
    }
});
