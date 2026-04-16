interface FIFO_if(input bit clk);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
logic [FIFO_WIDTH-1:0] data_in;
logic rst_n, wr_en, rd_en;
logic  [FIFO_WIDTH-1:0] data_out;
logic  wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;
 
modport monitor (input clk,rst_n, wr_en, rd_en,data_in,data_out,wr_ack,overflow,full, empty, almostfull, almostempty, underflow);
modport DUT (input clk,rst_n, wr_en, rd_en,data_in,
             output data_out,wr_ack,overflow,full, empty, almostfull, almostempty, underflow);

modport tb (output rst_n, wr_en, rd_en,data_in,
             input clk, data_out,wr_ack,overflow,full, empty, almostfull, almostempty, underflow);

endinterface

        