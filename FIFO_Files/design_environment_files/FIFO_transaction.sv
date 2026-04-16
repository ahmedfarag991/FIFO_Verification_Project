package FIFO_transaction_pkg;
parameter FIFO_WIDTH = 16;
class FIFO_transaction;
rand logic [FIFO_WIDTH-1:0] data_in;
rand logic rst_n, wr_en, rd_en;
rand logic  [FIFO_WIDTH-1:0] data_out;
rand logic  wr_ack, overflow;
rand logic full, empty, almostfull, almostempty, underflow;

int RD_EN_ON_DIST, WR_EN_ON_DIST;

function new(int RD_EN_ON_DIST=30,WR_EN_ON_DIST=70);
this.RD_EN_ON_DIST=RD_EN_ON_DIST;
this.WR_EN_ON_DIST=WR_EN_ON_DIST;
endfunction


constraint reset{
    rst_n dist{0:=5,1:=95};
}
constraint wr{
    wr_en dist{1:=WR_EN_ON_DIST,0:=100-WR_EN_ON_DIST};

}

constraint rd{
    rd_en dist{1:=RD_EN_ON_DIST,0:=100-RD_EN_ON_DIST};
}
endclass
endpackage
