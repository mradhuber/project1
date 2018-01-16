// 2-bit module
module ps2(
	input		 [1:0] req,
	input		  	   en,
	output logic [1:0] gnt,
	output logic	   req_up
);

parameter two = 2'b10; // highest priority
parameter one = 2'b01; // lowest
parameter zero = 2'b00; // none reqested

always_comb begin
	// grant highest priority
	if (req[1] && en) begin
		gnt = two;
		req_up = 1;
	end
	// grant lower priority
	else if (req[0] && ~req[1] && en) begin
		req_up = 1;
		gnt = one;
	end
	// grant neither
	else begin
		gnt = zero;
		req_up = 0;
	end
end

endmodule

// 4-bit module
module ps4(	
	input		 [3:0] req,
	input		  	   en,
	output logic [3:0] gnt,
	output logic 	   req_up
);

logic [1:0] lower_gnt;
logic [1:0] tmp_req_up;

ps2 lower(.req(req[1:0]), .en(en), .gnt(lower_gnt), .req_up(tmp_req_up[0])); // store lower bit ps result
ps2 upper(.req(req[3:2]), .en(en), .gnt(gnt[3:2]), .req_up(tmp_req_up[1])); // store upper bit ps result

assign req_up = tmp_req_up[1] & tmp_req_up[0];

always_comb begin
	// if you get a request from the "right" side
	if (tmp_req_up[0] && ~tmp_req_up[1]) begin
		// set the rest of the grant bits
		gnt[1:0] = lower_gnt;
	end
	else begin
		gnt[1:0] = 2'b00;
	end
end

endmodule
