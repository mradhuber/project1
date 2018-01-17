// 2-bit rotating
module rps2(
	input		 [1:0] req,
	input		  	   en,
	input			   sel,
	output logic [1:0] gnt,
	output logic req_up
);

parameter two = 2'b10; // grant on line 1
parameter one = 2'b01; // grant on line 0
parameter zero = 2'b00; // none reqested

always_comb begin
	// req[1] has higher priority
	if (sel) begin
		if (req[1]) begin
			gnt = two;
			req_up = 1;
		end
		else if (req[0] && ~req[1]) begin
			gnt = one;
			req_up = 1;
		end
		else begin
			gnt = zero;
			req_up = 0;
		end
	end
	else begin
		// req[0] has higher priority
		if (req[0]) begin
			gnt = one;
			req_up = 1;
		end
		else if (req[1] && ~req[0]) begin
			gnt = two;
			req_up = 1;
		end
		else begin
			gnt = zero;
			req_up = 0;
		end
	end

	if (~en) begin
		gnt = zero;
	end
end

endmodule

// 4-bit rotating
module rps4(
	input			   clock,
	input			   reset,
	input        [3:0] req,
	input			   en,
	output logic [3:0] gnt,
	output logic [1:0] count
);

logic [1:0] tmp_req_up;
logic [1:0] winner;
logic throw_away_req_up;

rps2 lower(.req(req[1:0]), .en(en & ~winner[1] & winner[0]), .sel(count[0]), .gnt(gnt[1:0]), .req_up(tmp_req_up[0]));
rps2 upper(.req(req[3:2]), .en(en & winner[1]), .sel(count[0]), .gnt(gnt[3:2]), .req_up(tmp_req_up[1]));
rps2 top(.req(tmp_req_up), .en(en), .sel(count[1]), .gnt(winner), .req_up(throw_away_req_up));

// use count as sel[1:0] bus
always_ff @(posedge clock) begin
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