<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    												pageEncoding="UTF-8" %>
    												    												
<!doctype html>

<html lang="en">
<head>
<meta charset="utf-8">
<title>Convex Hull using Graham scan</title>
<link rel="stylesheet"
              href="<c:url value="/resources/stylesheet/chDemo.css" />" />
              
              
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>

<script>
"use strict";

/*
This script creates a random points distribution on Canvas and uses the Graham scan algorithm to build its convex hull
*/


var Debugger = function() { };// create  object
  	Debugger.log = function(message) {
  	try {
    	console.log(message);
  	} catch(exception) {
    	return;
  	}
}


function canvasSupport() {
  	return !!document.createElement('canvas').getContext;
} 

function canvasApp() {

	function PointMsg(index, xpos, ypos) {
		this.index = index;
	    this.xpos = xpos; 
	    this.ypos = ypos;
	}
	
  	function Point(name) {
    	this.mName = name;
    	this.mIndex = 0;
    	this.xPos = 0; 
    	this.yPos = 0;
  	}// Point

  	function drawPoint(point) {
    	var xa = point.xPos - 5;
    	var xb = point.xPos + 5;
    	var ya = point.yPos - 5;
    	var yb = point.yPos + 5;

    	context.lineWidth = 2;
    	context.strokeStyle = "black";     
    	context.beginPath();
    	context.moveTo(xa, point.yPos);
    	context.lineTo(xb, point.yPos);
    	context.stroke();
    	context.closePath();
   	 	context.beginPath();
    	context.moveTo(point.xPos, ya);
    	context.lineTo(point.xPos, yb);
    	context.stroke();
    	context.closePath();  

    	var roff = 5;

  		setTextStyle();

    	context.fillText(point.mName, point.xPos + roff, point.yPos - roff);    
  
  	}// drawPoint
 
  	// get canvas context
  	if (!canvasSupport) {
    	alert("canvas not supported");
    	return;
  	} else {
    	var theCanvas = document.getElementById("canvas");
    	var context = theCanvas.getContext("2d");
  	}// if

  	var xMin = 0;
  	var yMin = 0;
  	var xMax = theCanvas.width;
  	var yMax = theCanvas.height; 
 
  	var Npoints = 30;
  	
  	var animIndex = 0;
  	
  	var delay = 1000;
  
  	var index;
  
  	var S = [];
  	
  	var results;

  	var points;
  
  	var pointDist;

  	function setTextStyle() {
    	context.fillStyle    = '#000000';
    	context.font         = '12px _sans';
  	}

  	function fillBackground() {
    	// draw background
    	context.fillStyle = '#ffffff';
    	context.fillRect(xMin, yMin, xMax, yMax);    
  	}// fillBackground

  	function redraw(points, S) {
    	// draw all points, connect only points in S according to S sequence
    	fillBackground();
    	for (var i = 0; i < points.length; i++) {
      		drawPoint(points[i]);
    	}
    	for (var i = 0; i < S.length-1; i++) {
      		drawSegment(S[i], S[i+1]);
    	}

  	}// redraw


	function randomize(Npoints) {
    	var count = 0;
    	points = [];
    	var x, y;
    	var dmin = 20;
    	
    	var ind = 0;
    	
    	while (points.length < Npoints) {
      		// generate random point
      		x = Math.floor(Math.random() * 600) + 50;// range
      		y = Math.floor(Math.random() * 500) + 50;// range
      		var point = new Point("p" + count);
      		point.xPos = x;
      		point.yPos = y;
      		var i = 0;
      		// check minimal distance to all existing points
      		for (i = 0; i < points.length; i++) {
        		if (distance(point, points[i]) < dmin) { 
          			break; 
        		} 
      		}// for
      		if (i == points.length) {
      			point.mIndex = ind++;
        		points.push(point);// accept point
      		} else { 
        		continue;// reject point 
      		}// if
      		count++;
    	}// while
	
    	for (var i = 0; i < points.length; i++) {
      		drawPoint(points[i]);
    	}
       	
    	var S = [];
    	redraw(points, S);
    	
    	$('#CHBuild').find(':submit')[0].disabled = false;
    	$('#status').text('Ready to compute the convex hull'); 
    	return points;
  	}// randomize 


  	function drawSegment(p1, p2) {
    	context.lineWidth = 2;
    	context.strokeStyle = "black";     
    	context.beginPath();
    	context.moveTo(p1.xPos, p1.yPos);
    	context.lineTo(p2.xPos, p2.yPos);
    	context.stroke();
    	context.closePath();
  	}// drawSegment

  	function distance(p1, p2) {
    	var dist = Math.sqrt(Math.pow(p1.xPos-p2.xPos, 2) + Math.pow(p1.yPos-p2.yPos, 2));
    	return dist;
    }

  	
  	function grahamScan() {
  	
  		$('#CHBuild').find(':submit')[0].disabled = true;
  		
	  	var message = {"type":"COLLECTION"};
	  
	  	$.ajax({
			type : "POST",
			contentType : "application/json",
			url : '<c:url value="/grahamScan" />',
			data : JSON.stringify(message),
			dataType : 'json',
			timeout : 100000,
			success : function(data) {
				console.log("SCAN SUCCESSFUL");
				
				if (data["status"] == "OK") {
					
					results = data["snapshots"]
					
					$('#Anim').find(':submit')[0].disabled = false;
										
				}// if
			},
				
			error : function(e) {
				console.log("ERROR: ", e);
			},
			done : function(e) {
				console.log("DONE");
			}
		});
  		
  	}// grahamScan
  	
  	function anim() {
  		
  		$('#CHBuild').find(':submit')[0].disabled = true;
  		$('#Anim').find(':submit')[0].disabled = true;
  		
  	  	animIndex = 0;
	  	animStep();// start actual animation
  			
  	}// anim
  	
  	function animSpeedChanged(e) {
	  	console.log("animSpeedChanged");
    	delay = 1e4 / e.target.value;
  	}
   
  	function animStep() {
	  	if (animIndex < results.length) {
	  		
			var convexHull = results[animIndex]["indices"];
			
			S = [];
			for (var k = 0; k < convexHull.length; k++) {
				S.push(points[convexHull[k]]);
			}
			
		    redraw(points, S);
	  		
	  		if (animIndex < results.length - 1) {// one more step	  	 	
	  	 		$('#status').text('Animating...');
				animIndex++;
		 		setTimeout(function() { animStep(); }, delay);
			} else {// last step
		    	// close the convex hull
		        drawSegment(S[S.length-1], S[0]);
				$('#status').text('Animation completed');
			}
	  	}
	  	
 	}// animstep
 
	function init() {

		points = randomize(Npoints);
	  		
	  	var data = [];
	  
	  	for (var i = 0; i < points.length; i++) {
	  		data.push(new PointMsg(points[i].mIndex, points[i].xPos, points[i].yPos))
	  	}
	  	
	  	
	  	var message = {"points":data};
	  
	  $.ajax({
			type : "POST",
			contentType : "application/json",
			url : '<c:url value="/initPoints" />',
			data : JSON.stringify(message),
			dataType : 'json',
			timeout : 100000,
			success : function(data) {
				console.log("INIT SUCCESSFUL");
			},
				
			error : function(e) {
				console.log("ERROR: ", e);
			},
			done : function(e) {
				console.log("DONE");
			}
		});
	  
  	}// init
 
  
  	init();
  
  	$("#Anim").submit(function(event) { anim(); return false; });
  	$("#CHBuild").submit(function(event) { grahamScan(); return false; });
 	$("#initelem").submit(function(event) { points = randomize(Npoints); init(); return false; });
	$('#initelem').find(':submit')[0].disabled = false;

	$('#Anim').find(':submit')[0].disabled = true;
	
  	$("#animspeed").change(function(event) { animSpeedChanged(event); return false; });
	
}// canvasApp

$(document).ready(canvasApp);

</script>
</head>

<body>

<nav>
<br>
<a href="/ALGORITHMS/ConvexHull/ConvexHull.html">To convex hull main page</a><br>
<a href="/ALGORITHMS/ConvexHull/JarvisDemo.html">To Jarvis march web demonstration</a>
<br><br>
</nav>

<header id="intro">
<h1>Convex Hull of a set of points using Graham scan algorithm</h1>
<p>I present here a Java based demonstration of the Graham scan that finds the convex hull of a given set of points.<br>
The algorithm itself is implemented in Java. Javascript is used for initialization and display only.<br/> 
</p>
<h2>Explanations</h2>
<p>The points are randomly generated (Javascript). The points collection is sent to the server as a JSON object.<br>
A reference point is selected, then the remaining points are sorted by angle counterclockwise, using the cross product (Java).<br/> 
Then the Graham Scan main loop is executed on server side (Java).<br/>
All intermediate results are saved as a collection that is sent back to the browser as a JSON object.<br>
The collection is used for animation (Javascript).<br/>
The algorithm test each point successively and keeps only those that are actually the convex hull vertices (extremal points).
</p>
</header>

<div id="display">
  <canvas id="canvas" width="700" height="600">
    Your browser does not support HTML 5 Canvas
  </canvas>
<footer>
<p>Dominique Ubersfeld, Cachan</p>
</footer> 
 
</div>

<div id="controls">
  <div id="ConvexHull">
      <p>Click here to start building the convex hull</p>
      <form name="CHBuild" id="CHBuild">
        <input type="submit" name="CH-btn" value="Build convex hull">
      </form>
      <form name="Anim" id="Anim">
        <input type="submit" name="CH-btn" value="Start animation">
      </form>
  </div>
  <div id="randomize">
    <p>Click here to randomize the points distribution</p>
    <form name="initialize" id="initelem">
      <input type="submit" name="randomize-btn" value="Randomize">
    </form>
  </div>
  <div id="animspeed">
    <label for="animSpeed">Animation speed</label>
    <input type="range" id="animSpeed" min="5" max="100" step="5" value="20">
  </div>
  <div id="msg">
    <p id="status"></p>
  </div> 
</div>

</body>

</html>