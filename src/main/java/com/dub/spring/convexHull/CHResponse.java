package com.dub.spring.convexHull;

import java.util.List;

/** container object for AJAX response 
 * on initGraph request should return a component in a suitable form 
 **/
public class CHResponse {
	private Status status;
	private List<JSONSnapshot> snapshots;
	

	public CHResponse() {
	}
	
	
	public Status getStatus() {
		return status;
	}

	public void setStatus(Status status) {
		this.status = status;
	}


	public List<JSONSnapshot> getSnapshots() {
		return snapshots;
	}


	public void setSnapshots(List<JSONSnapshot> snapshots) {
		this.snapshots = snapshots;
	}





	public static enum Status {
		OK, ERROR, INIT
	}
}
