package com.dub.spring.convexHull;


import org.springframework.stereotype.Service;

@Service
public class ConvexHullServices {

	
	public JSONSnapshot PointsToJSON(PointDist pointDist) {
	
		JSONSnapshot snapshot = new JSONSnapshot(pointDist.getConvexHull());
		
		return snapshot;
	}
	
}
