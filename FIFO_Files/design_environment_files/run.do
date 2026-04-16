vlib work
vlog *v +cover -covercells
vsim -voptargs=+acc work.FIFO_TOP -classdebug -uvmcontrol=all  -cover
add wave -position insertpoint  \
sim:/FIFO_TOP/FIFO_vif/FIFO_WIDTH \
sim:/FIFO_TOP/FIFO_vif/FIFO_DEPTH \
sim:/FIFO_TOP/FIFO_vif/clk \
sim:/FIFO_TOP/FIFO_vif/data_in \
sim:/FIFO_TOP/FIFO_vif/rst_n \
sim:/FIFO_TOP/FIFO_vif/wr_en \
sim:/FIFO_TOP/FIFO_vif/rd_en \
sim:/FIFO_TOP/FIFO_vif/data_out \
sim:/FIFO_TOP/FIFO_vif/wr_ack \
sim:/FIFO_TOP/FIFO_vif/overflow \
sim:/FIFO_TOP/FIFO_vif/full \
sim:/FIFO_TOP/FIFO_vif/empty \
sim:/FIFO_TOP/FIFO_vif/almostfull \
sim:/FIFO_TOP/FIFO_vif/almostempty \
sim:/FIFO_TOP/FIFO_vif/underflow
add wave -position insertpoint  \
sim:/FIFO_TOP/DUT/mem \
sim:/FIFO_TOP/DUT/wr_ptr \
sim:/FIFO_TOP/DUT/rd_ptr \
sim:/FIFO_TOP/DUT/count
coverage save FIFO_TOP.ucdb -onexit 
run -all