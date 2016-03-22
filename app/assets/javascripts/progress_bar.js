// add progress-bar div to the DOM
var drawProgressBar = function() {
  
  var svg = d3.select("#progress-bar")
    .append("div")
    .attr("id", "progress-bar-graph");
};


// update progress-bar width
var updateProgressBar = function() {

  // retrieve the width of the #progress-bar div
  var progressBarWidth = document.getElementById("progress-bar").offsetWidth;

  // retrieve the current search number from the url
  var currentUrl = window.location.href
  var currentSearchNumber = currentUrl.split("&search_number=")[1]

  // if the user is on search number 0, don't draw any progress
  if (currentSearchNumber == 0) {
    return
  }

  // identify the total number of searches an individual must complete
  var totalSeachNumber = 34;
  var percentCompleted = currentSearchNumber / totalSeachNumber;

  d3.select("#progress-bar-graph")
    .style("width", function(d) { return (progressBarWidth * percentCompleted) + "px"; })
      .style("height", "10px")
      .style("background-color", "#74AFC2");
};


// draw progress bar only after page has loaded
// because a number of css properties affect the width
// of the #progress-bar width
$(window).bind("load", function() {
  drawProgressBar();
  updateProgressBar();
});

// on window resize, redraw the progress bar
$(window).on('resize', function(){
  updateProgressBar();
});