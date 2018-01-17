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
	if (req[1]) begin
		req_up = 1;
		gnt = two;
	end
	// grant lower priority
	else if (req[0] && ~req[1]) begin
		req_up = 1;
		gnt = one;
	end
	// grant neither
	else begin
		req_up = 0;
		gnt = zero;
	end

	if (~en) begin
		gnt = zero;
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

logic [1:0] tmp_req_up;
logic [1:0] winner;

ps2 lower(.req(req[1:0]), .en(en & ~winner[1] & winner[0]), .gnt(gnt[1:0]), .req_up(tmp_req_up[0])); // store lower bit ps result
ps2 upper(.req(req[3:2]), .en(en & winner[1]), .gnt(gnt[3:2]), .req_up(tmp_req_up[1])); // store upper bit ps result
ps2 top(.req(tmp_req_up), .en(en), .gnt(winner), .req_up(req_up));

endmodule

// 4-bit module
module ps8(	
	input		 [7:0] req,
	input		  	   en,
	output logic [7:0] gnt,
	output logic 	   req_up
);

logic [1:0] tmp_req_up;
logic [1:0] winner;

ps4 lower(.req(req[3:0]), .en(en & ~winner[1] & winner[0]), .gnt(gnt[3:0]), .req_up(tmp_req_up[0])); // store lower bit ps result
ps4 upper(.req(req[7:4]), .en(en & winner[1]), .gnt(gnt[7:4]), .req_up(tmp_req_up[1])); // store upper bit ps result
ps2 top(.req(tmp_req_up), .en(en), .gnt(winner), .req_up(req_up));

endmodule
