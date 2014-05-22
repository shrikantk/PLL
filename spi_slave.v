module spi_slave(
    input 	 clk,
    input 	 rst_n, 
    input 	 ss,
    input 	 mosi,
    output reg 	 miso,
    input 	 sck,
    output 	 rw, 			//read/write strobe: 1 if write
    output 	 valid, 		//valid signal for reg block	
    input  [7:0] data_in_reg,
    output [7:0] data_to_reg,
    output [3:0] addr_to_reg
    );

// Input signals

// Output signals
reg [7:0] dout_q;

// Internal flip-flop signals
reg [15:0] data_q;
reg [2:0] cnt;

reg ss_sync1, ss_sync2, ss_sync_d, rd_sync1, rd_sync2, rd_sync_d;

// // ------------------------------------------
// Hard code config for CPOL = 0 and CPHA = 0
// Data clocked out on falling edge of SCK for both master(MOSI) and
// slave(MISO). Data clocked in on rising edge for both master and slave.

// This module runs on posedge of serial SPI clock.  
// This just clocks in serial data to a shift register.
// Afer the 8 bits are set, the done flag is set. If this
// flag is set, then the serial register is copied into
// the register-handling block which runs on a separate
// internal clock.
// Make sure that all the flip-flops are correctly reset
// at system init.


//sampling the incoming data
always @(posedge sck or negedge rst_n)
begin
//reset here
if(!rst_n)
     data_q <= 16'd0; // input

else if(!ss)
     data_q <= {data_q[14:0], mosi};	

end

//driving the data out
always @(negedge sck or negedge rst_n)
begin
//reset here
if(!rst_n)
begin
     miso <= 1'd0; // input
     dout_q <= 8'd0;
     cnt  <= 3'd0;	
end	

else if(!ss)
begin
     cnt <= cnt + 1'b1;     
     if (cnt == 3'b0)
     begin 
        dout_q <= {data_in_reg[6:0], data_in_reg[7]};
        miso <= data_in_reg[7];
     end	
     else
     begin		
        dout_q <= {dout_q[6:0], dout_q[7]};
        miso <= dout_q[7];
     end
end

//else if(rd_valid_sync) //synchronized read valid from reg block
//begin
//    dout_q <= data_in_reg;
//end	     			

end

//synchronize ss to sys clk domain
always @ (posedge clk or negedge rst_n)
begin
   if(!rst_n)
   begin
	ss_sync1  <= 1'b0;
	ss_sync2  <= 1'b0;
	ss_sync_d <= 1'b0;
   end

   else
   begin
	ss_sync1  <= ss;
	ss_sync2  <= ss_sync1;
	ss_sync_d <= ss_sync2;
   end

end

//synchronize rd_valid to sck domain
//always @ (posedge sck or negedge rst_n)
//begin
//   if(!rst_n)
//   begin
//	rd_sync1 <= 1'b0;
//	rd_sync2 <= 1'b0;
//	rd_sync_d <= 1'b0;
//   end
//
//   else
//   begin
//	rd_sync1 <=  rd_valid;
//	rd_sync2 <=  rd_sync1;
//	rd_sync_d <= rd_sync2;
//   end
//
//end

//assign rd_valid_sync = rd_sync2 & !rd_sync_d;

assign valid = ss_sync2 & !ss_sync_d;
assign data_to_reg = data_q[7:0];
assign addr_to_reg = data_q[11:8];
assign rw = data_q[15];

endmodule
