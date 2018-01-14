module rps2(
	input		 [1:0] req,
	input		  	   en,
	input			   sel,
	output logic [1:0] gnt,
	output logic	   req_up
);

endmodule

module rps4(
	input			   clock,
	input			   reset,
	input        [3:0] req,
	input			   en,
	output logic [3:0] gnt,
	output logic [1:0] count
);

// use count as sel bits
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