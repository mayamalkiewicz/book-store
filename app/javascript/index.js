// home page

//section 2

let loremIpsums = [
  "Cursus euismod quis viverra nibh. Faucibus pulvinar elementum integer enim neque volutpat.",
  "Duis eu nulla lacinia, pharetra metus non, bibendum libero.",
  "Cras eu sem facilisis, feugiat ante auctor, pellentesque ligula.",
  "Fusce sed lacinia elit, a condimentum odio.",
  "Vestibulum vitae dui fringilla, condimentum velit in, placerat odio.",
  "Suspendisse pellentesque feugiat blandit.",
];

let quoteField = document.getElementById("quotes-container");
let quote = document.getElementById("quote-view");

function quoteSelector() {
  let randomQuote = Math.floor(Math.random() * loremIpsums.length);
  return loremIpsums[randomQuote];
}

function showQuote() {
  quote.innerHTML = quoteSelector();
  quote.style.fontStyle = "italic";
  quote.style.fontWeight = "200";
}

quoteField.addEventListener("click", showQuote);

// section 3

// This variable stores the "Go to do-to list" button
let colorButton = document.getElementById("next-button");

// This random number function will create color codes for the randomColor variable
function colorValue() {
  return Math.floor(Math.random() * 256);
}

function colorChange() {
  let randomColor =
    "rgb(" + colorValue() + "," + colorValue() + "," + colorValue() + ")";
  colorButton.style.backgroundColor = randomColor;
}

colorButton.addEventListener("wheel", colorChange);
