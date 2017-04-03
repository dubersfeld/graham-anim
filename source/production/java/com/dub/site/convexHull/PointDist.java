package com.dub.site.convexHull;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

public class PointDist implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Point[] points;
	private int N;
	
	private Integer[] pointList;
	
	private List<Point> convexHull;
	
	private int index;
	private Point top, nextTop;
	
	private boolean finished;
	
	public PointDist() {
	}
	
	public PointDist(Point[] points) {
		this.N = points.length;
		this.points = points;
		this.pointList = new Integer[N];
		this.convexHull = new ArrayList<>();
		this.finished = false;
	}
	
	
	
	

	public List<Point> getConvexHull() {
		return convexHull;
	}

	public void setConvexHull(List<Point> convexHull) {
		this.convexHull = convexHull;
	}

	public int getN() {
		return N;
	}

	public void setN(int n) {
		N = n;
	}

	
	
	public boolean isFinished() {
		return finished;
	}

	public void setFinished(boolean finished) {
		this.finished = finished;
	}

	public Point[] getPoints() {
		return points;
	}

	public void setPoints(Point[] points) {
		this.points = points;
	}
	
	public Integer[] getPointList() {
		return pointList;
	}

	public void setPointList(Integer[] pointList) {
		this.pointList = pointList;
	}
	
	public void init() {
		
		sortByAngle();
		      
		convexHull.add(points[pointList[0]]);
		convexHull.add(points[pointList[1]]);
		convexHull.add(points[pointList[2]]);
			
		index = 3;
		finished = false;
		
	}// init
	
	public void scanStep() {
		
		index++;
				 
		while (true) {
		      
			// find if rotate left
		      
			top = convexHull.get(convexHull.size()-1);
			nextTop = convexHull.get(convexHull.size()-2);
				      
			int cp = cross(top, points[pointList[index]], nextTop, top);
		      
			if (cp > 0) {
		    	  break; 
		      
			} else {
		    	  convexHull.remove(convexHull.size()-1);
			}// if  
		 
		}// while
		  
		convexHull.add(points[pointList[index]]);
	 	 
		if (index == points.length-1) {
			 finished = true; 
		}
	}

	public void sortByAngle() {   
		// sort points array by increasing angle referred to points[0]
		 
		// find the point with maximal y in Canvas coordinates
	    int ymax = 0;
	    List<Integer> cand = new ArrayList<>();// list of candidates
	    
	    for (int i = 0; i < N; i++) {
	    	if (ymax < points[i].getYpos()) {
	    		ymax = points[i].getYpos();
	    	}
	    }// for
	    
	    for (int i = 0; i < N; i++) {
	    	if (ymax == points[i].getYpos()) {
	    		cand.add(i);
	    	} 
	    }// for
	    
	    // select the leftmost point
	    int index = 0; 
	    for (int k = 0; k < cand.size(); k++) {
	      if (points[cand.get(k)].getXpos() < points[cand.get(index)].getXpos()) {
	        index = k;
	      }
	    } 
	    int first = cand.get(index);
	    
	    // begin with points[first]
		   
		Integer[] lList = new Integer[N-1];
		int k = 0;
	    for (int i = 0; i < N; i++) {
	    	if (i != first) {
	    		lList[k++] = i;
	    	}
	    }// for
	
	    Point pref = points[first];
	     
	    reorder(lList, pref);
	  
	    // finalize list
	    pointList[0] = first;
	    for (int i = 1; i < N; i++) {
	    	pointList[i] = lList[i-1];
	    }
	      
	}// sortByAngle
	
	  
    private void reorder(Integer[] lList, Point pref) {
		
		/** reordering indices */
		Arrays.sort(lList, new Comparator<Integer>() {

			@Override
			public int compare(Integer o1, Integer o2) {
					 
				return -cross(points[o1], points[o2], pref, pref);
			}
		});
	}// reorder
	
	 
    // helper geometric function
    private int cross(Point p1, Point p2, Point pref1, Point pref2) {
        //return the cross product of vectors p1-pref1, p2-pref2
        int x1 = p1.getXpos() - pref1.getXpos();
        int x2 = p2.getXpos() - pref2.getXpos();
        int y1 = p1.getYpos() - pref1.getYpos();
        int y2 = p2.getYpos() - pref2.getYpos();
        return -(x1*y2-x2*y1);// left-handed frame
      
    }
    
    public void displayCH() {
    	System.out.println("\ndisplayCH");
    	for (int k = 0; k < convexHull.size(); k++) {
    		System.out.println(convexHull.get(k).getIndex());
    	}
    }
    
}
