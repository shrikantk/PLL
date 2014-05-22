module divider (clk_in, control_word,enable_in,enable_out,reset,clk_out_gated);

input clk_in;
input reset;
input enable_in,enable_out;
input [7:0] control_word;
output clk_out_gated;

//* Control word index*///
// 0 & 1 ---- ref_clk
// 2 -------- div by 2
// 3 -------- div by 4
// 4 -------- div by 8
// 5 -------- div by 3
// 6 -------- div by 6
// 7 -------- div by 5

wire clk_in1,clk_in2,clk_in3,clk_in4;
wire q_2,q_4,q_8,q_3,q_6,q_5;
wire clk_in_gated,clk_out;
reg d_latch,out_latch;

always@(~clk_in) begin
  if(~clk_in)
    d_latch <= enable_in;
  end
  
assign clk_in_gated = d_latch && clk_in;

assign clk_in1 = (control_word==8'b000 || control_word==8'b001) ? clk_in_gated : 1'b0;
assign clk_in2 = (control_word==8'b010 || control_word==8'b011 || control_word==8'b100) ? clk_in_gated : 1'b0;
assign clk_in3 = (control_word==8'b101 || control_word==8'b110) ? clk_in_gated : 1'b0;
assign clk_in4 = (control_word==8'b111) ? clk_in_gated : 1'b0;

div_2_4_8 div_2_4_80(clk_in2,reset,q_2,q_4,q_8);
div_3_6 div_3_60(clk_in3,reset,q_3,q_6);
div5 div50(clk_in4,reset,q_5);

assign clk_out = (control_word==8'b000 || control_word==8'b001) ? clk_in1 : (control_word==8'b010) ? q_2 : (control_word==8'b011) ? q_4 : (control_word==8'b100) ? q_8 : (control_word==8'b101) ? q_3 : (control_word==8'b110) ? q_6 : (control_word==8'b111) ? q_5 : 1'b0;

always@(~clk_out) begin
  if(~clk_out)
    out_latch <= enable_out;
  end
  
assign clk_out_gated = out_latch && clk_out;

endmodule

module div_2_4_8 (clk_in, reset, clk_out_2, clk_out_4, clk_out_8) ;

input clk_in;
input reset;
output clk_out_2;
output clk_out_4;
output clk_out_8;
wire q_2,q_4,q_8;


div2 div20(clk_in,reset,q_2);
div2 div21(q_2,reset,q_4);
div2 div22(q_4,reset,q_8);

assign clk_out_2 = q_2;
assign clk_out_4 = q_4;
assign clk_out_8 = q_8;

endmodule

module div2 (clk_in,reset, clk_out);
    // --------------Port Declaration----------------------- 
   input               clk_in                   ;
   input               reset                    ;
   output              clk_out                  ;
   //--------------Port data type declaration-------------
   wire                 clk_in                  ;
   
  //--------------Internal Registers----------------------
  reg                   clk_out                 ;
  //--------------Code Starts Here----------------------- 
  always @ (posedge clk_in or negedge reset) //neg
  if (!reset) begin 
    clk_out <= 1'b0;
  end else begin
    clk_out <=  ! clk_out ; 
  end
  
  endmodule
  
module div_3_6 (clk_in, reset, clk_out_3, clk_out_6) ;

input clk_in;
input reset;
output clk_out_3;
output clk_out_6;
wire q_3,q_6;



divide_by_3 divide_by_30(clk_in,reset,q_3);
div2 div20(q_3,reset,q_6);


assign clk_out_3 = q_3;
assign clk_out_6 = q_6;

endmodule


module divide_by_3 (
  clk_in       , //Input Clock
 reset        , // Reset Input
  clk_out        // Output Clock
  );
  //-----------Input Ports---------------
  input clk_in;
  input  reset;
  //-----------Output Ports---------------
  output clk_out;
  //------------Internal Variables--------
  reg [1:0] pos_cnt;
  reg [1:0] neg_cnt;
  //-------------Code Start-----------------
  // Posedge counter
  always @ (posedge clk_in or negedge reset)
  if (!reset) begin
    pos_cnt <= 0;
  end else begin
    pos_cnt <= (pos_cnt == 2) ? 0 : pos_cnt + 1;
  end
  // Neg edge counter
  always @ (negedge clk_in or negedge reset)
  if (!reset) begin
    neg_cnt <= 0;
  end else begin
    neg_cnt <= (neg_cnt == 2) ? 0 : neg_cnt + 1;
  end
  
  assign clk_out = ((pos_cnt  != 2) && (neg_cnt  != 2));
  
  endmodule
  
module div5 (clk,reset,clk_out_5);
   
input clk;
input reset;
output clk_out_5;
wire q0, q1, q2, q_n0, q_n1, q_n2;
wire t0 = q_n2; 
wire t1 = q0;
wire t2 = (q0 & q1)| q2;

   assign clk_out_5 = q1;
   t_ff t_ff0(clk, reset, t0, q0, q_n0);
   t_ff t_ff1(clk, reset, t1, q1, q_n1);
   t_ff t_ff2(clk, reset, t2, q2, q_n2);
   
endmodule

module t_ff(clk, reset, t, q, q_n);
   input clk, reset, t;
   output q, q_n;
   reg    q, q_n;
   
   always @(posedge clk or negedge reset) begin
      if (!reset) begin
         q <= 0;
         q_n <= 1;
      end else begin
         if (t) begin
            q <= ~q;
            q_n <= ~q_n;
         end		
      end
   end	
endmodule

