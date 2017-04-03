package com.dub.site.convexHull;

import java.util.List;

/** This class represents a Graham Scan step result as a JSON object.
 * It is used in response to Ajax requests 
 * It encapsulates only the convexHull content as an int[] */

public class JSONSnapshot {
	
	/** An array of indices */
	private int[] indices;// points indices only
	private int N;
	
	
	
	public JSONSnapshot(int N) {
		indices = new int[N];
		this.N = N;
	}
	
	public JSONSnapshot(List<Point> points) {
		this.N = points.size();
		this.indices = new int[N];
		for (int i = 0; i < N; i++) {
			this.indices[i] = points.get(i).getIndex();
		}
	}
	

	
	public int[] getIndices() {
		return indices;
	}

	public void setIndices(int[] indices) {
		this.indices = indices;
	}

	public int getN() {
		return N;
	}

	public void setN(int n) {
		N = n;
	}


	// for debugging only
	public void display() {
		System.out.println("\nsnapshot: indices");
		for (int i = 0; i < N; i++) {
			System.out.println(indices[i]);
		}
	}
	
}
