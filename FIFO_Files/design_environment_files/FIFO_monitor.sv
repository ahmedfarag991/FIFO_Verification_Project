import FIFO_coverage_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_transaction_pkg::*;
import shared_pkg::*;
module monitor(FIFO_if.monitor FIFO_vif);
FIFO_scoreboard sb;
FIFO_coverage cov;
FIFO_transaction trans;

initial begin
    sb=new;
    cov=new;
    trans=new;
    forever begin
        wait(trigger.triggered);
        @(negedge FIFO_vif.clk);
        trans.data_in=FIFO_vif.data_in;
        trans.wr_en=FIFO_vif.wr_en;
        trans.rd_en=FIFO_vif.rd_en;
        trans.rst_n=FIFO_vif.rst_n;
        trans.full=FIFO_vif.full;
        trans.empty=FIFO_vif.empty;
        trans.almostfull=FIFO_vif.almostfull;
        trans.almostempty=FIFO_vif.almostempty;
        trans.data_out=FIFO_vif.data_out;
        trans.wr_ack=FIFO_vif.wr_ack;
        trans.overflow=FIFO_vif.overflow;
        trans.underflow=FIFO_vif.underflow;
        fork
            begin
                cov.sample_data(trans);
            end
            begin
                sb.check_data(trans);
            end
        join
        if(test_finshed)begin
            $display("correct= %0d, failed= %0d",correct_count,error_count);
            $stop;
        end
    end
end
endmodule
