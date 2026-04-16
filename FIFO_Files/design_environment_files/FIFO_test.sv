import shared_pkg::*;
import FIFO_transaction_pkg::*;

module test(FIFO_if.tb FIFO_vif);
FIFO_transaction trans_tb;
initial begin 
    trans_tb=new;
    test_finshed=0;
    FIFO_vif.rst_n=0;
    ->trigger;
    @(negedge FIFO_vif.clk);
    FIFO_vif.rst_n=1;
    repeat(20000)begin
        assert(trans_tb.randomize());
        FIFO_vif.rst_n=trans_tb.rst_n;
        FIFO_vif.wr_en=trans_tb.wr_en;
        FIFO_vif.rd_en=trans_tb.rd_en;
        FIFO_vif.data_in=trans_tb.data_in;
        ->trigger;
        @(negedge FIFO_vif.clk);

    end
    test_finshed=1;
    ->trigger;
end


endmodule