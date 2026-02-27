const fs = require('fs');
const html = fs.readFileSync('index.html', 'utf8');

const gridStartMarker = '<div class="product-grid">';
const sectionEndMarker = '</section>';

const gridStartIndex = html.indexOf(gridStartMarker);
const sectionEndIndex = html.indexOf(sectionEndMarker, gridStartIndex);

if (gridStartIndex === -1 || sectionEndIndex === -1) {
    console.error("Could not find grid boundaries.");
    process.exit(1);
}

const gridHtml = html.substring(gridStartIndex + gridStartMarker.length, sectionEndIndex).trim();
const cardSplits = gridHtml.split('<div class="product-card">').filter(c => c.trim().length > 0);

let cards = cardSplits.map(c => '<div class="product-card">' + c);

// Find and pluck out the 4 specific cards
let tigerTomato, umangOkra, tigerGourd, spinach;
let remainingCards = [];

cards.forEach(card => {
    // Specifically target the Tomato, not the Bitter gourd
    if (card.includes('TIGER F-1') && card.includes('Hybrid Tomato')) {
        tigerTomato = card;
    } else if (card.includes('OKRA UMANG F-1')) {
        umangOkra = card;
    } else if (card.includes('TIGER F-1 HYBRID') && card.includes('Hybrid Bitter Gourd')) {
        tigerGourd = card;
    } else if (card.includes('SPINACH ALL GREEN')) {
        spinach = card;
    } else {
        remainingCards.push(card);
    }
});

if (!tigerTomato) console.log("Missing Tiger Tomato");
if (!umangOkra) console.log("Missing Umang Okra");
if (!tigerGourd) console.log("Missing Tiger Bitter Gourd");
if (!spinach) console.log("Missing Spinach");


// Construct the new order.
// Line 1: indices 0 to 3
let newCards = remainingCards.splice(0, 4);

// Line 2: Tiger Tomato, Umang Okra, plus 2 remaining
newCards.push(tigerTomato);
newCards.push(umangOkra);
if (remainingCards.length > 0) newCards.push(remainingCards.shift());
if (remainingCards.length > 0) newCards.push(remainingCards.shift());

// Line 3: Tiger Bitter Gourd, Spinach All Green, plus 2 remaining
newCards.push(tigerGourd);
newCards.push(spinach);
if (remainingCards.length > 0) newCards.push(remainingCards.shift());
if (remainingCards.length > 0) newCards.push(remainingCards.shift());

// Rest
newCards = newCards.concat(remainingCards);

let newGridHtml = gridStartMarker + '\n' + newCards.join('\n') + '\n    </div>\n    ';

const newHtml = html.substring(0, gridStartIndex) + newGridHtml + html.substring(sectionEndIndex);
fs.writeFileSync('index.html', newHtml, 'utf8');

console.log("Custom reordering complete!");
