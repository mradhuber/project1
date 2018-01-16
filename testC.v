module testbench;
    logic [7:0] req;
    logic  en;
    logic [7:0] gnt;
    logic [7:0] tb_gnt;
    logic correct;

    ps8 pe8(req, en, gnt);
	
	integer i;
    assign tb_gnt[7]=en&req[7];
    assign tb_gnt[6]=en&req[6]&~req[7];
    assign tb_gnt[5]=en&req[5]&~req[6]&~req[7];
    assign tb_gnt[4]=en&req[4]&~req[5]&~req[6]&~req[7];
    assign tb_gnt[3]=en&req[3]&~req[4]&~req[5]&~req[6]&~req[7];
    assign tb_gnt[2]=en&req[2]&~req[3]&~req[4]&~req[5]&~req[6]&~req[7];
    assign tb_gnt[1]=en&req[1]&~req[2]&~req[3]&~req[4]&~req[5]&~req[6]&~req[7];
    assign tb_gnt[0]=en&req[0]&~req[1]&~req[2]&~req[3]&~req[4]&~req[5]&~req[6]&~req[7];
    assign correct=(tb_gnt==gnt);
	
    always @(correct)
    begin
        #2
        if(!correct)
        begin
            $display("@@@ Incorrect at time %4.0f", $time);
            $display("@@@ gnt=%b, en=%b, req=%b",gnt,en,req);
            $display("@@@ expected result=%b", tb_gnt);
            $finish;
        end
    end

    initial 
    begin
        $monitor("Time:%4.0f req:%b en:%b gnt:%b", $time, req, en, gnt);
		en = 1'b1;
		for (i = 0; i < 8'b11111111; i = i + 1) begin
			#5;
			req = i;
		end
        #5
        en = 0;
        #5
        req = 8'b00011000;
        #5
        req = 8'b11111111;
        #5
        $finish;
     end // initial
endmodule
