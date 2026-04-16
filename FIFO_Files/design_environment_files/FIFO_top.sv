module FIFO_TOP();
bit clk;
initial begin
    clk=0;
    forever
    #1 clk=~clk;
end

FIFO_if FIFO_vif(clk);
FIFO DUT (FIFO_vif);
monitor mon(FIFO_vif);
test tb(FIFO_vif);

always_comb begin 
      if(!FIFO_vif.rst_n) 
        reset : assert final(FIFO_vif.data_out==0 && FIFO_vif.empty==1&&FIFO_vif.full==0&&FIFO_vif.almostempty==0&&FIFO_vif.almostfull==0
        &&FIFO_vif.underflow==0&&FIFO_vif.overflow==0&&FIFO_vif.wr_ack==0);
        rst : cover final(FIFO_vif.data_out==0 && FIFO_vif.empty==1&&FIFO_vif.full==0&&FIFO_vif.almostempty==0&&FIFO_vif.almostfull==0
        &&FIFO_vif.underflow==0&&FIFO_vif.overflow==0&&FIFO_vif.wr_ack==0);
    end
endmodule 