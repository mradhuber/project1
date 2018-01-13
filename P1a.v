module ps4(	
	input		 [3:0] req,
	input		  	   en,
	output logic [3:0] gnt
);

// only one grant line asserted at once (hot one encoded)
// using only assign statements

assign gnt[3] = 1 ? req[3] && en : 0; // highest priority
assign gnt[2] = 1 ? req[2] && en : 0;
assign gnt[1] = 1 ? req[1] && en : 0;
assign gnt[0] = 1 ? req[1] && en : 0; // lowest

endmodule