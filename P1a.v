module ps4(	
	input		 [3:0] req,
	input		  	   en,
	output logic [3:0] gnt
);

// only one grant line asserted at once (hot one encoded)
// using only assign statements

assign gnt[3] = req[3] & en; // highest priority
assign gnt[2] = ~req[3] & req[2] & en;
assign gnt[1] = ~req[3] & ~req[2] & req[1] & en;
assign gnt[0] = ~req[3] & ~req[2] & ~req[1] & req[0] & en; // lowest

endmodule
