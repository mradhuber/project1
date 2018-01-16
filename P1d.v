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
		if (req[1] && en) begin
			if (en) begin
				gnt = two;
				req_up = 1;
			end
		end
		else if (req[0] && ~req[1] && en) begin
			if (en) begin
				gnt = one;
				req_up = 1;
			end
		end
		else begin
			gnt = zero;
			req_up = 0;
		end
	end
	else begin
		// req[0] has higher priority
		if (req[0] && en) begin
			if (en) begin
				gnt = one;
				req_up = 1;
			end
		end
		else if (req[1] && ~req[0] && en) begin
			if (en) begin
				gnt = two;
				req_up = 1;
			end
		end
		else begin
			gnt = zero;
			req_up = 0;
		end
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

logic [1:0] lower_gnt;
logic [1:0] upper_gnt;
logic [1:0] tmp_req_up;
logic [1:0] winner;
logic throw_away_req_up;

rps2 lower(.req(req[1:0]), .en(en), .sel(count[0]), .gnt(lower_gnt), .req_up(tmp_req_up[0]));
rps2 upper(.req(req[3:2]), .en(en), .sel(count[0]), .gnt(upper_gnt), .req_up(tmp_req_up[1]));
rps2 top(.req(tmp_req_up), .en(en), .sel(count[1]), .gnt(winner), .req_up(throw_away_req_up));

always_comb begin
	// if sel[1], left has higher priority
	if (winner[1]) begin
		gnt[3:2] = upper_gnt;
		gnt[1:0] = 2'b00;
	end
	// else, right has higher priority
	else begin
		gnt[1:0] = lower_gnt;
		gnt[3:2] = 2'b00;
	end
end

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