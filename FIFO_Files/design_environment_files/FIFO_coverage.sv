package FIFO_coverage_pkg;
import  FIFO_transaction_pkg::*;
class FIFO_coverage;
FIFO_transaction F_cvg_txn;
covergroup g1;
wr_en_cp: coverpoint F_cvg_txn.wr_en{
    option.weight=0;
}
rd_en_cp: coverpoint F_cvg_txn.rd_en{
    option.weight=0;
}

wr_ack_cp: coverpoint F_cvg_txn.wr_ack{
    option.weight=0;
}
overflow_cp: coverpoint F_cvg_txn.overflow{
    option.weight=0;
}
full_cp: coverpoint F_cvg_txn.full{
    option.weight=0;
}

empty_cp: coverpoint F_cvg_txn.empty{
    option.weight=0;
}
almostempty_cp: coverpoint F_cvg_txn.almostempty{
    option.weight=0;
}
almostfull_cp: coverpoint F_cvg_txn.almostfull{
    option.weight=0;
}
underflow_cp: coverpoint F_cvg_txn.underflow{
    option.weight=0;
}

cross_wr_ack: cross wr_en_cp,rd_en_cp,wr_ack_cp{
    ignore_bins never_occurs1=binsof(wr_ack_cp) intersect{1} && binsof(wr_en_cp) intersect{0};
} 
cross_overflow: cross wr_en_cp,rd_en_cp,overflow_cp{
    ignore_bins never_occurs1=binsof(overflow_cp) intersect{1} && binsof(wr_en_cp) intersect{0};
}  
cross_full: cross wr_en_cp,rd_en_cp,full_cp{
    ignore_bins never_occurs1=binsof(full_cp) intersect{1} && binsof(rd_en_cp) intersect{1};
}  
cross_empty: cross wr_en_cp,rd_en_cp,empty_cp; 
cross_almostfull: cross wr_en_cp,rd_en_cp,almostfull_cp; 
cross_almostempty: cross wr_en_cp,rd_en_cp,almostempty_cp; 
cross_underflow: cross wr_en_cp,rd_en_cp,underflow_cp{
    ignore_bins never_occurs1=binsof(underflow_cp) intersect{1} && binsof(rd_en_cp) intersect{0};
}  
endgroup


function new();
g1=new;
endfunction

function void sample_data(FIFO_transaction F_txn);
F_cvg_txn=F_txn;
g1.sample();
endfunction
endclass
endpackage

