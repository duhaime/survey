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

  // create a counter to keep track of passes through loop
  // set the counter to -1 so that on the first pass we'll
  // establish 0-based indexing
  var counter = -1;

  // iterate over the search results data 
  $.each(data["search_results"], function(i, j){
    
    // increment the counter to achieve 0-based indexing counting
    counter += 1;

    // i == the search phrase of interest. Create the plot for this search
    var search_phrase = i;

    // remove periods and whitespace from the search phrase
    var id_to_select = "#search_" + search_phrase.replace(".","").split(" ").join("_");

    // take only the data for the current search 
    var plot_data = data["search_results"][search_phrase];

    var margin = {top: 0, right: 270, left: 70, bottom: 50};   
    var w = 900 - margin.left - margin.right;
    var h = 400 - margin.top - margin.bottom;

    var color = d3.scale.category20()
      // set a definite domain to ensure colors are mapped to 
      // platform ids consistently
      .domain(d3.range(data["platform_id_and_name_array"].length));

    var svg = d3.select(id_to_select).append("svg")
      .attr("width", w + margin.left + margin.right)
      .attr("height", h + margin.top + margin.bottom);
 
    // add rectangle in which plot will be created 
    svg.append("rect")
      .attr("class", "plotBox")
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
      .attr("x", (w+margin.left+margin.right)/2 - 45)
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

    var circles = svg.selectAll("circle").data(plot_data).enter()
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

    /***
     * Legend 
     ***/

    // retrieve platform_id_and_name array served by graph controller
    var platform_id_and_name = data["platform_id_and_name_array"];

    // add svg on which to build the legend
    var legend = d3.select(id_to_select).select("svg").append("svg:svg")
      // id_to_select is prefaced with "#",
      // but the .attr("id",'') method will append a #, 
      // so remove the # from the id_to_select string
      .attr("id", id_to_select.replace("#","") + "_legend")
      .attr("height", 200)
      .attr("width", 200)

      // SET X DYNAMICALLY AND FIGURE OUT COLOR INCONSISTENCY
      .attr("x", 660)
      .attr("y", 0);

    legend.selectAll(".legendDiv").data(platform_id_and_name).enter()
      .append('g') 
      .attr("class", "legend")
      .each(function(d, i) {

        // select the g div just appended to the plot
        var g = d3.select(this);
        g.append("svg:circle")
          .attr("cx", 5)
          .attr("cy", 20*i+15)
          .attr("r", 4)
          .style("stroke", function(d) {return color(d.platform_id);})
          .style("fill", "#ffffff")
          .attr("stroke-width", 2)
          .attr("class","legendCircle");
          
        g.append("text")
          .attr("x", 12)
          .attr("y", 20*i + 20)
          .attr("height",20)
          .attr("width",60)
          .style("fill", "#000000")
          .style("font-size", "12")
          .text(function(d) {return d.platform_name;});
      });


  });
};
 
function error() {
  console.log("error")
}