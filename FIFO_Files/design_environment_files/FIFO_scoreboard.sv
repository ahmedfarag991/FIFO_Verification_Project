package FIFO_scoreboard_pkg;
import FIFO_transaction_pkg::*;
import shared_pkg::*;
class FIFO_scoreboard;
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
logic  wr_ack_ref, overflow_ref;
logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
logic  [FIFO_WIDTH-1:0] data_out_ref,data_pre;
logic  [FIFO_WIDTH-1:0] fifo[$];
logic[3:0] size;

task check_data(FIFO_transaction tr);
ref_model(tr);
if(tr.data_out!=data_out_ref || tr.wr_ack!=wr_ack_ref || tr.overflow!=overflow_ref || tr.full!=full_ref || tr.empty!=empty_ref ||
tr.almostempty!=almostempty_ref || tr.almostfull!=almostfull_ref||tr.underflow!=underflow_ref)begin
        $display("%t sComparison failed:",$time);
        $display("%t Inputs:",$time);
        $display("rst_n       = %0b", tr.rst_n);
        $display("wr_en       = %0b", tr.wr_en);
        $display("rd_en       = %0b", tr.rd_en);
        $display("data_in     = %0h", tr.data_in);
        $display("Outputs:");
        $display("data_out    = %0h, ref = %0h", tr.data_out, data_out_ref);
        $display("wr_ack      = %0b, ref = %0b", tr.wr_ack, wr_ack_ref);
        $display("overflow    = %0b, ref = %0b", tr.overflow, overflow_ref);
        $display("full        = %0b, ref = %0b", tr.full, full_ref);
        $display("empty       = %0b, ref = %0b", tr.empty, empty_ref);
        $display("almostempty = %0b, ref = %0b", tr.almostempty, almostempty_ref);
        $display("almostfull  = %0b, ref = %0b", tr.almostfull, almostfull_ref);
        $display("underflow   = %0b, ref = %0b", tr.underflow, underflow_ref);
        error_count++;
end
    else 
    correct_count++;
endtask

task ref_model(FIFO_transaction tr);
 size=fifo.size();
 //rst
if(!tr.rst_n)begin
    full_ref=0; empty_ref=1; almostfull_ref=0; almostempty_ref=0; underflow_ref=0;wr_ack_ref=0;overflow_ref=0;underflow_ref=0;data_out_ref=0;
    fifo.delete();
end

else begin
    size=fifo.size();
    //write
    if (tr.wr_en && ~tr.rd_en) begin
        if(size<FIFO_DEPTH)begin
            fifo.push_back(tr.data_in);
            data_out_ref=data_pre;
    end
end
//read
    else if(~tr.wr_en && tr.rd_en)begin
        if(size>0)begin
            data_out_ref=fifo.pop_front();
        end
    end
    //both
    else if(tr.wr_en && tr.rd_en)begin
        if(size<FIFO_DEPTH && size>0)begin
            data_out_ref=fifo.pop_front();
            fifo.push_back(tr.data_in);
        end
        else if (size==FIFO_DEPTH && size!=0) begin
            data_out_ref=fifo.pop_front();

         end
        else if (size ==0 && size<FIFO_DEPTH) begin
            fifo.push_back(tr.data_in);
            data_out_ref=data_pre;
        end
    end
    //none
    else if(~tr.wr_en && ~tr.rd_en)begin
        data_out_ref=data_pre;
    end
    if(full_ref&&tr.wr_en) overflow_ref=1; else overflow_ref=0;
    if(empty_ref&&tr.rd_en) underflow_ref=1; else underflow_ref=0;
    if(!full_ref && tr.wr_en) wr_ack_ref=1; else wr_ack_ref=0;
end
data_pre=data_out_ref;
size=fifo.size();
full_ref=(size==FIFO_DEPTH)?1:0;
empty_ref=(size==0)?1:0;
almostempty_ref=(size==1)?1:0;
almostfull_ref=(size==FIFO_DEPTH-1)?1:0;
endtask
endclass
endpackage
