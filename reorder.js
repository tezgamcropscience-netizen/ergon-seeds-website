const fs = require('fs');

const html = fs.readFileSync('index.html', 'utf8');

// The grid starts here
const gridStartMarker = '<div class="product-grid">';
const sectionEndMarker = '</section>';

const gridStartIndex = html.indexOf(gridStartMarker);
const sectionEndIndex = html.indexOf(sectionEndMarker, gridStartIndex);

if (gridStartIndex === -1 || sectionEndIndex === -1) {
    console.error("Could not find grid boundaries.");
    process.exit(1);
}

const gridHtml = html.substring(gridStartIndex + gridStartMarker.length, sectionEndIndex).trim();

// Split by <div class="product-card">
const cardSplits = gridHtml.split('<div class="product-card">').filter(c => c.trim().length > 0);

const categories = {
    chillies: [],
    tomatoes: [],
    okra: [],
    bitterGourd: [],
    others: []
};

// Also keep track of seen titles to avoid duplicates (just in case)
const seenTitles = new Set();

cardSplits.forEach(split => {
    // Re-attach the split string
    const cardHtml = '<div class="product-card">' + split;

    // Extract title to determine category
    const titleMatch = cardHtml.match(/<h3>(.*?)<\/h3>/i);
    if (!titleMatch) {
        categories.others.push(cardHtml);
        return;
    }

    let title = titleMatch[1].trim().toUpperCase();

    if (seenTitles.has(title)) {
        console.log("Skipping duplicate:", title);
        return;
    }
    seenTitles.add(title);

    // Categorize
    const isChilli = /(CHILLI|PEPPER|CAPSICUM|^SUPER STAR|^GOLDEN STAR|^JAWALA|^HOT KING|^GERMAN INHAIM|^SKY SUPER)/i.test(cardHtml);
    const isTomato = /(TOMATO|^TIGER F-1$|^ASIAN STAR)/i.test(cardHtml);
    const isOkra = /OKRA/i.test(cardHtml);
    // Be careful with TIGER F-1 vs TIGER F-1 HYBRID, one is tomato one is bitter gourd.
    const isBitterGourd = /(BITTER GOURD|KARELA|^AJMAL)/i.test(cardHtml);

    if (isTomato) {
        categories.tomatoes.push(cardHtml);
    } else if (isBitterGourd) {
        categories.bitterGourd.push(cardHtml);
    } else if (isOkra) {
        categories.okra.push(cardHtml);
    } else if (isChilli && !/SHAMLI STAR|BLACK DAIMOND/.test(title)) { // ensure brinjals don't slip in
        categories.chillies.push(cardHtml);
    } else {
        categories.others.push(cardHtml);
    }
});

// Build the new grid
let newGridHtml = gridStartMarker + '\n';
newGridHtml += categories.chillies.join('\n') + '\n';
newGridHtml += categories.tomatoes.join('\n') + '\n';
newGridHtml += categories.okra.join('\n') + '\n';
newGridHtml += categories.bitterGourd.join('\n') + '\n';
newGridHtml += categories.others.join('\n') + '\n';

// There might be a closing </div> for the grid we need to preserve, followed by the end of section.
// Actually, in the chunk we extracted, the closing </div> is sometimes included or we removed it.
// Let's just append '</div>\n    '
newGridHtml += '</div>\n\n    ';

const newHtml = html.substring(0, gridStartIndex) + newGridHtml + html.substring(sectionEndIndex);
fs.writeFileSync('index.html', newHtml, 'utf8');

console.log("Successfully reordered. Found", seenTitles.size, "unique products.");
