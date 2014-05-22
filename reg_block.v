//Reg block for SPI registers

module reg_block (
  input        	   clk,
  input        	   rst_n,
  input       	   rw, 	     
  input       	   valid,      
  output reg [7:0] data_in_reg,
  input      [7:0] data_to_reg,
  input      [3:0] addr_to_reg,
  
  output reg [7:0] dco_tst_reg1,//DCO test regs
 // output reg [7:0] dco_tst_reg2,
 // output reg [7:0] dco_tst_reg3,
 // output reg [7:0] dco_tst_reg4,

  output reg [7:0] div_reg1, //Divider values
//  output reg [7:0] div_reg2,
//  output reg [7:0] div_reg3,
//  output reg [7:0] div_reg4,

  output 	   div_en11, //divider enables
  output 	   div_en12
//  output 	   div_en21,
//  output 	   div_en22,
//  output 	   div_en31,
//  output 	   div_en32,
//  output 	   div_en41,
//  output 	   div_en42,

   //DCO value update signals (assuming synchronous: CHECK!)
//  input 	   dco_upd1,
//  input 	   dco_upd2,
//  input 	   dco_upd3,
//  input 	   dco_upd4,
//
//  input      [7:0] dco_sts1, //DCO status registers
//  input      [7:0] dco_sts2,
//  input      [7:0] dco_sts3,
//  input      [7:0] dco_sts4

  );

reg [7:0] enable_reg1 ;

reg [7:0] rd_data;

wire [3:0] addr_to_reg_qu;

//write into registers
always @ (posedge clk or negedge rst_n)
begin

  if(!rst_n)
  begin  
    dco_tst_reg1       <= 8'd0;
//    dco_tst_reg2       <= 8'd0;
//    dco_tst_reg3       <= 8'd0;
//    dco_tst_reg4       <= 8'd0;
    div_reg1	   <= 8'd0;        //reset values
//    div_reg2	   <= 8'd0;
//    div_reg3	   <= 8'd0;
//    div_reg4	   <= 8'd0;
    enable_reg1    <= 8'd3;    
//    enable_reg2    <= 8'd3;
//    enable_reg3    <= 8'd3;
//    enable_reg4    <= 8'd3;
  end

  else if (rw && valid)
  begin
  //address decoding
    dco_tst_reg1    <= (addr_to_reg == 4'd0) ? data_to_reg :  dco_tst_reg1;
    div_reg1    <= (addr_to_reg == 4'd1) ? data_to_reg :  div_reg1;
    enable_reg1 <= (addr_to_reg == 4'd2) ? data_to_reg :  enable_reg1;

 //   dco_tst_reg2    <= (addr_to_reg == 4'd4) ? data_to_reg :  dco_tst_reg2;
 //   div_reg2    <= (addr_to_reg == 4'd5) ? data_to_reg :  div_reg2;
 //   enable_reg2 <= (addr_to_reg == 4'd6) ? data_to_reg :  enable_reg2;

 //   dco_tst_reg3    <= (addr_to_reg == 4'd8) ? data_to_reg :  dco_tst_reg3;
 //   div_reg3    <= (addr_to_reg == 4'd9) ? data_to_reg :  div_reg3;
 //   enable_reg3 <= (addr_to_reg == 4'd10) ? data_to_reg :  enable_reg3;

 //   dco_tst_reg4    <= (addr_to_reg == 4'd12) ? data_to_reg :  dco_tst_reg4;
 //   div_reg4    <= (addr_to_reg == 4'd13) ? data_to_reg :  div_reg4;
 //   enable_reg4 <= (addr_to_reg == 4'd14) ? data_to_reg :  enable_reg4;
  end
end


//read only registers
//always @ (posedge clk or negedge rst_n)
//begin
//
//  if (!rst_n)
//	dco_sts_reg1 <= 8'd0;
//
//  else if (dco_upd1)
//	dco_sts_reg1 <= dco_sts1;
//end
//
//always @ (posedge clk or negedge rst_n)
//begin
//
//  if (!rst_n)
//	dco_sts_reg2 <= 8'd0;
//
//  else if (dco_upd2)
//	dco_sts_reg2 <= dco_sts2;
//end
//
//always @ (posedge clk or negedge rst_n)
//begin
//
//  if (!rst_n)
//	dco_sts_reg3 <= 8'd0;
//
//  else if (dco_upd3)
//	dco_sts_reg3 <= dco_sts3;
//end
//
//always @ (posedge clk or negedge rst_n)
//begin
//
//  if (!rst_n)
//	dco_sts_reg4 <= 8'd0;
//
//  else if (dco_upd4)
//	dco_sts_reg4 <= dco_sts4;
//end



assign addr_to_reg_qu = addr_to_reg & {4{!rw & valid}};

//read address decoding
always @ (*)
begin
   case (addr_to_reg_qu)
     4'd0 : rd_data = dco_tst_reg1;
     4'd1 : rd_data = div_reg1;
     4'd2 : rd_data = enable_reg1;
//     4'd3 : rd_data = dco_sts_reg1;
//     4'd4 : rd_data = dco_tst_reg2;
//     4'd5 : rd_data = div_reg2;
//     4'd6 : rd_data = enable_reg2;
//     4'd7 : rd_data = dco_sts_reg2;
//     4'd8 : rd_data = dco_tst_reg3;
//     4'd9 : rd_data = div_reg3;
//     4'd10 : rd_data = enable_reg3;
//     4'd11 : rd_data = dco_sts_reg3;
//     4'd12 : rd_data = dco_tst_reg4;
//     4'd13 : rd_data = div_reg4;
//     4'd14 : rd_data = enable_reg4;
//     4'd15 : rd_data = dco_sts_reg4;
     default : rd_data = 8'd0;
   endcase
end


//read address launch

always @ (posedge clk or negedge rst_n)
begin
  if (!rst_n)
  begin
    data_in_reg <= 8'd0;
  end

  else if (!rw && valid)
  begin
    data_in_reg <= rd_data;
  end

//  else
//  begin
//    data_in_reg <= 8'd0;
//    rd_valid <= 1'b0;
//  end
end


assign  div_en11 = enable_reg1[0]; 
assign  div_en12 = enable_reg1[1];
//assign  div_en21 = enable_reg2[0];
//assign  div_en22 = enable_reg2[1];
//assign  div_en31 = enable_reg3[0];
//assign  div_en32 = enable_reg3[1];
//assign  div_en41 = enable_reg4[0];
//assign  div_en42 = enable_reg4[1];







endmodule
      
