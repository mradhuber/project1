module ps4(	
	input		 [3:0] req,
	input		  	   en,
	output logic [3:0] gnt
);

// using always block and if/else statements

parameter four = 4'b1000; // highest priority
parameter three = 4'b0100;
parameter two = 4'b0010;
parameter one = 4'b0001; // lowest
parameter zero = 4'b0000; // none reqested but en is 1

always_comb begin
	if (en) begin
		if (req[3])
			gnt = four;
		else if (req[2] && ~req[3])
			gnt = three;
		else if (req[1] && ~req[3] && ~req[2])
			gnt = two;
		else if (req[0] && ~req[3] && ~req[2] && ~req[1])
			gnt = one;
		else
			gnt = zero;
	end
	else
		gnt = 4'b0000;
end

endmodule