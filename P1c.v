module ps2(
	input		 [1:0] req,
	input		  	   en,
	output logic [1:0] gnt,
	output logic	   req_up
);

parameter two = 2'b10; // highest priority
parameter one = 2'b01; // lowest
parameter zero = 2'b00; // none reqested but en is 1

always_comb begin
	if (en) begin
		if (req[1]) begin
			gnt = two;
			req_up = 1;
		end
		else if (req[0]) begin
			gnt = one;
			req_up = 1;
		end
		else begin
			gnt = zero;
			req_up = 0;
		end
	end
	else begin
		gnt = zero;
		req_up = 2'b00;
	end
end

endmodule

module ps4(	
	input		 [3:0] req,
	input		  	   en,
	output logic [3:0] gnt,
	output logic 	   req_up
);

parameter four = 4'b1000;
parameter three = 4'b0100;
parameter two = 4'b0010;
parameter one = 4'b0001;
parameter zero = 4'b0000;
parameter error = 4'b1111;

logic [1:0] lower_gnt;
logic [1:0] upper_gnt;
logic [1:0] tmp_req_up;

ps2 lower(.req(req[1:0]), .en(en), .gnt(lower_gnt), .req_up(tmp_req_up[0])); // store lower bit ps result
ps2 upper(.req(req[3:2]), .en(en), .gnt(upper_gnt), .req_up(tmp_req_up[1])); // store upper bit ps result

always_comb begin
	if (en) begin
		// if you get a request from the "left" side
		if (tmp_req_up[1]) begin
			if (upper_gnt[1]) begin
				gnt = four;
				req_up = 1;
			end
			else if (upper_gnt[0]) begin
				gnt = three;
				req_up = 1;
			end
			else begin
				// this case should never happen
				// what's the best way to handle this in Verilog?
				gnt = error;
				req_up = 0;
			end
		end
		// if you get a request from the "right" side
		else if (tmp_req_up[0]) begin
			if (lower_gnt[1]) begin
				gnt = two;
				req_up = 1;
			end
			else if (lower_gnt[0]) begin
				gnt = one;
				req_up = 1;
			end
			else begin
				// this case should never happen
				// what's the best way to handle this in Verilog?
				gnt = error;
				req_up = 0;
			end
		end
		else begin
			gnt = zero;
			req_up = 0;
		end
	end
	else begin
		gnt = zero;
		req_up = 0;
	end
end

endmodule