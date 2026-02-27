const fs = require('fs');
let data = fs.readFileSync('index.html', 'utf8');
data = data.replace(/https:\/\/images\.unsplash\.com\/[^"']+/g, 'ergon logo.png');
fs.writeFileSync('index.html', data);
