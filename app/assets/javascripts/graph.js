$.ajax({
  type: "GET",
  contentType: "application/json; charset=utf-8",
  url: 'data',
  dataType: 'json',
  success: function (data) {
    draw(data);
  },
  error: function (result) {
    error();
  }
});

 
function draw(data) {
  /***
  * data is of the following form:
  *
  * data = {search_id: {
  *            result_0: n,
  *            result_1: p,
  *           },
  *         another_search_id: {}, ...
  *        }
  *
  * iterate over the keys of data, and for each, 
  * create a plot using D3.js
  *
  ***/

  // iterate over the keys of object data
  $.each(data, function(i, j){
    
    // i == the search phrase of interest. Create the plot for this search
    var searchPhrase = i;

    // remove periods and whitespace from the search phrase
    var idToSelect = "#search" + searchPhrase.replace(".","").split(" ").join("_");

    // take only the data for the current search 
    var plotData = data[searchPhrase];

    var margin = {top: 0, right: 70, left: 70, bottom: 50};   
    var w = 700 - margin.left - margin.right;
    var h = 400 - margin.top - margin.bottom;

    var color = d3.scale.category20();

    var svg = d3.select(idToSelect).append("svg")
      .attr("width", w + margin.left + margin.right)
      .attr("height", h + margin.top + margin.bottom);
 
    // add rectangle in which plot will be created 
    svg.append("rect")
      .attr("id", "plotBox")
      .attr("x", margin.left)
      .attr("y", margin.top)
      .attr("height", h)
      .attr("width", w)
      .attr("stroke", "#c4c4c4")
      .attr("stroke-width", 1)
      .attr("fill", "#ffffff");

    /***
     * X-Axis
     ***/

    var x = d3.scale.linear()
      .range([15, w-15])
      // to keep things simple for viewers, use 1 based indexing
      .domain([1, 10]);

    var xAxis = d3.svg.axis()
      .scale(x);

    var xAxisGroup = svg.append("g")
      .attr("class","x axis")
      .attr("transform", "translate(" + margin.left + 
        "," + (h+margin.top) + ")");

    // add a label to the x axis
    svg.append("text")
      .attr("class", "x label")
      .attr("text-anchor", "end")
      .attr("x", (w+margin.left+margin.right)/2 + 45)
      .attr("y", h + margin.top + margin.bottom - 3)
      .style("font-size", "12.5")
      .style("font-weight", "normal")
      .text("Search Result");

    /***
     * Y-Axis
     ***/

    var y = d3.scale.linear()
      .range([15, h-15])
      .domain([1,0]);

    var yAxis = d3.svg.axis()
      .scale(y)
      .orient("left");

    var yAxisGroup = svg.append("g")
      .attr("class", "y axis")
      .attr("transform", "translate(" + margin.left +
         "," + margin.top + ")");

    // draw x and y axes
    svg.select(".y.axis")
      .transition()
      .duration(1000)
      .call(yAxis);

    svg.select(".x.axis")
      .call(xAxis);

    // add a label to the y axis
    svg.append("text")
      .attr("class", "y label")
      .attr("text-anchor", "end")
      .attr("y", 3)
      .attr("x", -((h+margin.top+margin.bottom)/2) + 100)
      .attr("dy", ".75em")
      .style("font-size", "12.5")
      .style("font-weight", "normal")
      .attr("transform", "rotate(-90)")
      .text("Relevancy Percentage");

    // style axes
    svg.selectAll('.axis line, .axis path')
     .style({'stroke': 'Black', 'fill': 'none', 'stroke-width': '1px'});

    /***
     * Plot
     ***/

    var circles = svg.selectAll("circle").data(plotData).enter()
      .append("circle")
        .attr("r", 4)
        .attr("style", "cursor: pointer;")
        // to keep things simple for viewers, use 1-based indexing
        // (result index is already 1-based)
        .attr("cx", function(d, i) {return x(d.result_index) + margin.left})
        .attr("cy", function(d, i) {return y(d.percent_relevant) + margin.top})
        .attr("stroke", function(d, i) {return color(d.platform_id)})
        .attr("stroke-width", 2)
        .attr("fill", "#ffffff");
  });
};
 
function error() {
  console.log("error")
}