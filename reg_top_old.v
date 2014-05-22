module reg_top (
    input 	 clk,
    input 	 rst_n, 
    input 	 ss,
    input 	 mosi,
    output  	 miso,
    input 	 sck,
  
    output  [7:0] dco_tst_reg1 ,  
    output  [7:0] dco_tst_reg2 ,
    output  [7:0] dco_tst_reg3 ,
    output  [7:0] dco_tst_reg4 ,
    
    output  [7:0] div_reg1    ,    
    output  [7:0] div_reg2    ,
    output  [7:0] div_reg3    ,
    output  [7:0] div_reg4    ,
    
    output        div_en11    ,
    output        div_en12    ,
    output        div_en21    ,
    output        div_en22    ,
    output        div_en31    ,
    output        div_en32    ,
    output        div_en41    ,
    output        div_en42    ,
    
    input         dco_upd1    ,
    input         dco_upd2    ,
    input         dco_upd3    ,
    input         dco_upd4    ,
    
    input   [7:0] dco_sts1    ,
    input   [7:0] dco_sts2    ,
    input   [7:0] dco_sts3    ,
    input   [7:0] dco_sts4    
    );

wire [7:0] data_in_reg, data_to_reg;
wire [3:0] addr_to_reg;

spi_slave SPI (
  .clk   ( clk ),    
  .rst_n ( rst_n ), 
  .ss    ( ss ),
  .mosi  ( mosi ),
  .miso  ( miso ),
  .sck   ( sck ),
  .rw 	       ( rw 	    ),
  .valid       ( valid      ),
  .data_in_reg ( data_in_reg),
  .data_to_reg ( data_to_reg),
  .addr_to_reg ( addr_to_reg)
 );

reg_block REG (
  .clk         ( clk         ), 
  .rst_n       ( rst_n	     ),
  .rw 	       ( rw 	     ), 
  .valid       ( valid       ),
  .data_in_reg ( data_in_reg ),
  .data_to_reg ( data_to_reg ),
  .addr_to_reg ( addr_to_reg ),

  .dco_tst_reg1 ( dco_tst_reg1 ),  
  .dco_tst_reg2 ( dco_tst_reg2 ),
  .dco_tst_reg3 ( dco_tst_reg3 ),
  .dco_tst_reg4 ( dco_tst_reg4 ),
                         
  .div_reg1    ( div_reg1    ),    
  .div_reg2    ( div_reg2    ),
  .div_reg3    ( div_reg3    ),
  .div_reg4    ( div_reg4    ),
                             
  .div_en11    ( div_en11    ),
  .div_en12    ( div_en12    ),
  .div_en21    ( div_en21    ),
  .div_en22    ( div_en22    ),
  .div_en31    ( div_en31    ),
  .div_en32    ( div_en32    ),
  .div_en41    ( div_en41    ),
  .div_en42    ( div_en42    ),
                             
  .dco_upd1    ( dco_upd1    ),
  .dco_upd2    ( dco_upd2    ),
  .dco_upd3    ( dco_upd3    ),
  .dco_upd4    ( dco_upd4    ),
                             
  .dco_sts1    ( dco_sts1    ),
  .dco_sts2    ( dco_sts2    ),
  .dco_sts3    ( dco_sts3    ),
  .dco_sts4    ( dco_sts4    )

);


endmodule
