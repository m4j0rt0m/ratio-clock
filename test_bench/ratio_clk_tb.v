/*
 *  File:         ratio_clk_tb.v
 *  Description:  Project Testbench
 *  Project:      Ratio-driven Clock
 *  Author:       Abraham J. Ruiz R. (https://github.com/m4j0rt0m)
 *  Revision:     0.1 - First Version
 */
module ratio_clk_tb ();

  /* local parameters */
  localparam  RATIO_GRADE = 5;                      //..ratio grade limit
  localparam  RUN_CYCLES  = 200000;               //..number of cycles per simulation
  localparam  FREQ_CLK    = 50;                     //..MHz
  localparam  CLK_F       = (1000 / FREQ_CLK) / 2;  //..ns

  /* defines */
  `define CYCLES(cycles)  (CLK_F*2*cycles)

  /* dut regs and wires */
  reg                     clk_i;
  reg                     arst_n_i;
  reg                     en_i;
  reg   [RATIO_GRADE-1:0] ratio_i;
  wire                    ratio_clk_o;

  /* dut */
  ratio_clk
    # (
        .RATIO_GRADE  (RATIO_GRADE)
      )
    dut (
        .clk_i        (clk_i),
        .arst_n_i     (arst_n_i),
        .en_i         (en_i),
        .ratio_i      (ratio_i),
        .ratio_clk_o  (ratio_clk_o)
      );

  /* initialization */
  initial begin
    clk_i = 0;
    arst_n_i = 0;
    en_i = 0;
    ratio_i = 0;
    $dumpfile("ratio_clk.vcd");
    $dumpvars();
    #`CYCLES(RUN_CYCLES);
    $finish;
  end

  /* clock signal */
  always  begin
    #CLK_F  clk_i = ~clk_i;
  end

  /* asynchronous reset signal */
  always  begin
    #`CYCLES(4)             arst_n_i  = 1;
    #`CYCLES(RUN_CYCLES/2)  arst_n_i  = 0;
  end

  /* enable simulation */
  always begin
    #`CYCLES(10)    en_i  = 1;
//    #`CYCLES(10000) en_i  = 0;
  end

  /* ratio simulation */
  reg [1:0] ratio_clk_cnt = 0;
  always @ (posedge ratio_clk_o, negedge arst_n_i) begin
    if(~arst_n_i) begin
      ratio_clk_cnt <=  0;
      ratio_i       <=  0;
    end
    else begin
      if(&ratio_clk_cnt)
        ratio_i <=  ratio_i + 1;
      ratio_clk_cnt <=  ratio_clk_cnt + 1;
    end
  end

endmodule // ratio_clk_tb
