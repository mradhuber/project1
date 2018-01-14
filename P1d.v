module rps2(
	input		 [1:0] req,
	input		  	   en,
	input			   sel,
	output logic [1:0] gnt,
	output logic	   req_up
);

parameter two = 2'b10; // grant on line 1
parameter one = 2'b01; // grant on line 0
parameter zero = 2'b00; // none reqested

always_comb begin
	// req[1] has higher priority
	if (sel) begin
		if (req[1]) begin
			req_up = 1;
			if (en)
				gnt = two;
		end
		else if (req[0] && ~req[1]) begin
			req_up = 1;
			if (en)
				gnt = one;
		end
		else begin
			gnt = zero;
			req_up = 0;
		end
	end
	else begin
		// req[0] has higher priority
		if (req[0]) begin
			req_up = 1;
			if (en)
				gnt = one;
		end
		else if (req[1] && ~req[0]) begin
			req_up = 1;
			if (en)
				gnt = two;
		end
		else begin
			gnt = zero;
			req_up = 0;
		end
	end
end

endmodule

module rps4(
	input			   clock,
	input			   reset,
	input        [3:0] req,
	input			   en,
	output logic [3:0] gnt,
	output logic [1:0] count
);

// use count as sel[1:0] bus
always_ff begin
	if (reset)
		count <= 2'b00;
	else begin
		if (count == 2'b11)
			count <= 2'b00;
		else
			count <= count + 1;
	end
end

endmodule