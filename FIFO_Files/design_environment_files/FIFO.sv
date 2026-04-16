////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_if.DUT FIFO_vif);

localparam max_fifo_addr = $clog2(FIFO_vif.FIFO_DEPTH);

reg [FIFO_vif.FIFO_WIDTH-1:0] mem [FIFO_vif.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge FIFO_vif.clk or negedge FIFO_vif.rst_n) begin
	if (!FIFO_vif.rst_n) begin
		wr_ptr <= 0;
		FIFO_vif.wr_ack<=0;   //wr_ack not set to zero when reset
		FIFO_vif.overflow<=0; //overflow not set to zero when reset
		foreach (mem[i]) begin
			mem[i]<=0;        //fifo  was not empty when reset;
		end
	end
	else if (FIFO_vif.wr_en && count < FIFO_vif.FIFO_DEPTH) begin
		mem[wr_ptr] <= FIFO_vif.data_in;
		FIFO_vif.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		FIFO_vif.overflow <= 0;   //to avoid stack when asserted 
	end
	else begin 
		FIFO_vif.wr_ack <= 0;
		if (FIFO_vif.full && FIFO_vif.wr_en)
			FIFO_vif.overflow <= 1;
		else
			FIFO_vif.overflow <= 0;
	end
end
//rst is not done for data_out 
always @(posedge FIFO_vif.clk or negedge FIFO_vif.rst_n) begin
	if (!FIFO_vif.rst_n) begin
		rd_ptr <= 0;
		FIFO_vif.data_out<=0;
		FIFO_vif.underflow<=0;
	end
	else if (FIFO_vif.rd_en && count != 0) begin
		FIFO_vif.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		FIFO_vif.underflow<=0;
	end
	else begin   //sequntial output
		if(FIFO_vif.empty&&FIFO_vif.rd_en)
			FIFO_vif.underflow<=1;
		else
			FIFO_vif.underflow<=0;
end
end


always @(posedge FIFO_vif.clk or negedge FIFO_vif.rst_n) begin
	if (!FIFO_vif.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({FIFO_vif.wr_en, FIFO_vif.rd_en} == 2'b10) && !FIFO_vif.full) 
			count <= count + 1;
		else if ( ({FIFO_vif.wr_en, FIFO_vif.rd_en} == 2'b01) && !FIFO_vif.empty)
			count <= count - 1;
		else if ( ({FIFO_vif.wr_en, FIFO_vif.rd_en} == 2'b11)) begin        //no handle for this
			if(FIFO_vif.full)
            	count <= count - 1;
			else if(FIFO_vif.empty)
				count <= count + 1;
		end
	end
end

assign FIFO_vif.full = (count == FIFO_vif.FIFO_DEPTH)? 1 : 0;
assign FIFO_vif.empty = (count == 0)? 1 : 0;
assign FIFO_vif.almostfull = (count == FIFO_vif.FIFO_DEPTH-1)? 1 : 0; // fifo depth -1 not -2
assign FIFO_vif.almostempty = (count == 1)? 1 : 0;

//assertions 
always_comb begin 
      if(!FIFO_vif.rst_n) 
        wr_ptr_a : assert final(wr_ptr == 0);
        wr_ptr_c : cover  final(wr_ptr == 0);  
    end
always_comb begin 
      if(!FIFO_vif.rst_n) 
        rd_ptr_a : assert final(rd_ptr == 0);  
        rd_ptr_c : cover  final(rd_ptr == 0);  
    end
always_comb begin 
      if(!FIFO_vif.rst_n) 
        count_a  : assert final(count == 0);  
        count_c  : cover  final(count == 0);  
    end


property asser1;
    @(posedge FIFO_vif.clk) disable iff(!FIFO_vif.rst_n) (count==4'd8) |->  FIFO_vif.full;
endproperty

property asser2;
    @(posedge FIFO_vif.clk)disable iff(!FIFO_vif.rst_n) (count==0) |->  FIFO_vif.empty;
endproperty

property asser3;
    @(posedge FIFO_vif.clk)disable iff(!FIFO_vif.rst_n) (count==1) |->  FIFO_vif.almostempty;
endproperty

property asser4;
    @(posedge FIFO_vif.clk)disable iff(!FIFO_vif.rst_n) (count==7) |->  FIFO_vif.almostfull;
endproperty

property asser5;
    @(posedge FIFO_vif.clk)disable iff(!FIFO_vif.rst_n) (!FIFO_vif.full&&FIFO_vif.wr_en) |=>  FIFO_vif.wr_ack;
endproperty


property asser6;
    @(posedge FIFO_vif.clk)disable iff(!FIFO_vif.rst_n) (FIFO_vif.full && FIFO_vif.wr_en) |=>  (FIFO_vif.overflow);
endproperty


property asser7;
    @(posedge FIFO_vif.clk)disable iff(!FIFO_vif.rst_n) (FIFO_vif.empty && FIFO_vif.rd_en) |=>  (FIFO_vif.underflow);
endproperty

property asser8;
    @(posedge FIFO_vif.clk) disable iff(!FIFO_vif.rst_n)
    (wr_ptr == FIFO_vif.FIFO_DEPTH-1 && FIFO_vif.wr_en && count < FIFO_vif.FIFO_DEPTH)  |=> (wr_ptr == 0);
endproperty

property asser9;
    @(posedge FIFO_vif.clk) disable iff(!FIFO_vif.rst_n)
    (rd_ptr == FIFO_vif.FIFO_DEPTH-1 && FIFO_vif.rd_en && count > 0)  |=> (rd_ptr == 0);
endproperty

property asser10;
    @(posedge FIFO_vif.clk) disable iff(!FIFO_vif.rst_n)
    (wr_ptr == FIFO_vif.FIFO_DEPTH-1 && FIFO_vif.wr_en && count < FIFO_vif.FIFO_DEPTH)  |=> (wr_ptr == 0);
endproperty

property wr_ptr_threshold;
    @(posedge FIFO_vif.clk) disable iff(!FIFO_vif.rst_n)
    wr_ptr < FIFO_vif.FIFO_DEPTH;
endproperty

property rd_ptr_threshold;
    @(posedge FIFO_vif.clk) disable iff(!FIFO_vif.rst_n)
    rd_ptr < FIFO_vif.FIFO_DEPTH;
endproperty

property count_threshold;
    @(posedge FIFO_vif.clk) disable iff(!FIFO_vif.rst_n)
    count <= FIFO_vif.FIFO_DEPTH;
endproperty

l1 : assert property (asser1);
l2 : assert property (asser2);
l3 : assert property (asser3);
l4 : assert property (asser4);
l5 : assert property (asser5);
l6 : assert property (asser6);
l7 : assert property (asser7);
l8 : assert property (asser8);
l9 : assert property (asser9);
l10 : assert property (asser10);
l101 : assert property (wr_ptr_threshold);
l102 : assert property (rd_ptr_threshold);
l103 : assert property (count_threshold);

l11 : cover property (asser1);
l22 : cover property (asser2);
l33 : cover property (asser3);
l44 : cover property (asser4);
l55 : cover property (asser5);
l66 : cover property (asser6);
l77 : cover property (asser7);
l88 : cover property (asser8);
l99 : cover property (asser9);
l1_0 : cover property (asser10);
l201 : cover property (wr_ptr_threshold);
l202 : cover property (rd_ptr_threshold);
l203 : cover property (count_threshold);

endmodule