//----------------------------------------------------------------------------------------------
// FILE NAME       frame_anaylsis.v
// DEPARTMENT
// AUTHOR          XU Lu
// AUTHOR'S EMAIL  xu.lu@tnc.ltd
//----------------------------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION      DATE            AUTHOR       DESCRIPTION
// 1.0          2016-05-20      ZHONG Shan  Initial
//----------------------------------------------------------------------------------------------
// KEYWORDS      pre process, sync word
//----------------------------------------------------------------------------------------------
// PURPOSE       use for match sync word and output frame data with defined length
//----------------------------------------------------------------------------------------------
// PARAMETERS
//         PARAM  NAME      RANGE        :DESCRIPTION         :DEFAULT    :UNITS
// e.g     DATA_WIDTH      [32,16]       :width of the data   :64         :
//----------------------------------------------------------------------------------------------
// REUSE ISSUES      :
// Reset Strategy    :  Asynchronous Reset
// Clock  Domains    :  250MHz, use fifo for clock cross
// Critical Timing   :  data byte shift
// Test   Features   :
// Asynchronous I/F  :
// Scan Methodology  :
// Instaniations     :
// Synthesizable     :  YES
// Other             :
//
//END_HEADER------------------------------------------------------------------------------------

//*********************************************************************************************
//MODULE DEFINITION
//*********************************************************************************************
`timescale  1ns / 1ps
/*
  1. 每个文件尽量只包含一个模块；
  2. 文件名与模块明保持一致；
  3. 模块名能够表达模块功能；
  4. 模块名不宜超过10各字母；
*/
module coding_style #(
    parameter TIMEOUT_TRG      = 12  , // time out threshold value
    parameter DUMP_VAL         = 8     // temp value
  )
  (
    //RESET & CLOCK
    input  wire         rst_b        ,  //async reset
    input               sys_clk      ,  //output data's clock
    input  wire         rx_clk       ,  //input data's clock
    //AXI INTERFACE
    input  wire [63:0]  rxd          ,  //input data
    input  wire         valid        ,  //input valid indicator
    output wire         ready        ,  //ready of axi-st
    //CFG INTERFACE
    input       [63:0]  sync_head    ,  //sync word going to be matched
    input       [15:0]  frame_len    ,  //length of input frames with quad byte
    input       [15:0]  ipg_cfg      ,  //idle cycles between output frames
    //OUTPUT INTERFACE
    output reg  [63:0]  data_out_d   ,  //output frame data
    output reg          data_out_dv  ,  //output frame data valid
    output reg          data_out_last   //output frame data's last cycle
  );

  ////////////////////////////////////////
  // PARAMETER SEGMENT
  ////////////////////////////////////////
  /*
    1. 参数全部使用大写
    2. 前后行尽量保持对齐
  */
  parameter IDLE             = 4'b0001;
  parameter SYNC             = 4'b0010;
  parameter RX_DATA          = 4'b0100;
  parameter IPG              = 4'b1000;
  parameter CLR_CNT          = 4'b1001;
  parameter RD_IDLE          = 4'b0000;
  parameter PACKET_RD_PRE1   = 4'b0001;
  parameter PACKET_RD_PRE2   = 4'b0010;
  parameter PACKET_RD_PRE3   = 4'b0011;
  parameter PACKET_RD        = 4'b0100;
  parameter PACKET_IPG_PRE1  = 4'b0101;
  parameter PACKET_IPG_PRE2  = 4'b0110;
  parameter PACKET_IPG       = 4'b0111;

  ////////////////////////////////////////
  // WIRE SEGMENT
  ////////////////////////////////////////
  wire        en          ;
  wire [63:0] shift0      ;
  wire [63:0] shift1      ;
  wire [63:0] shift2      ;
  wire [63:0] shift3      ;
  wire [63:0] shift4      ;
  wire [63:0] shift5      ;
  wire [63:0] shift6      ;
  wire [63:0] shift7      ;
  wire        first_match ;
  wire        shift1_match;
  wire        shift2_match;
  wire        shift3_match;
  wire        shift4_match;
  wire        shift5_match;
  wire        shift6_match;
  wire        shift7_match;
  wire        fifo_full   ;
  wire        fifo_empty  ;
  wire [63:0] ram_b_data  ;
  wire [35:0] fifo_b_data ;

  ////////////////////////////////////////
  //REGISTER SEGMENT
  ////////////////////////////////////////
  /*
    1. 信号命名不超过10个字符；
    2. 单词尽量使用缩写      ；
      address      adr
      asynchronous asyn
      begin        bgn
      carry        cry
      channel      chn
      clear        clr
      clock        clk
      combination  comb
      configure    cfg
      control      ctl
      count        cnt
      data         dat
      empty        emp
      enable       en
      error        err
      flow control fc
      frame        frm
      full         ful
      input        i
      latch        lat
      length       len
      load         lad
      managment    mng
      message      msg
      number       num
      output       o
      packet       pkt
      pointer      ptr
      process      proc
      read         rd
      ready        rdy
      receive      rx
      register     reg
      reset        rst
      select       sel
      shift        sft
      speed        spd
      start        str
      statistic    stat
      synchronous  sync
      transmit     tx
      valid        vld
      width        wid
      wirite       wr
    3. 表示延迟的使用 _d1     ;
    4. 表示提前的使用 _p1     ;
    5. 低电平有效使用 _b      ;
    6. 三态使用      _z      ;
  */

  reg  [63:0]    rxd_d1           ;
  reg  [63:0]    rxd_reg          ;
  reg  [15:0]    len_cnt          ;
  reg  [02:0]    ch               ;
  reg            fifo_a_we        ;
  reg            ram_a_we         ;
  reg  [15:0]    ram_a_addr       ;
  reg  [15:0]    ram_a_addr_d1    ;
  reg  [63:0]    ram_b_data_d1    ;
  reg  [63:0]    ram_b_data_d2    ;
  reg  [15:0]    start_addr       ;
  reg  [35:0]    fifo_a_data      ;
  reg            data_rd_d1       ;
  reg            data_rd_d2       ;
  reg            data_rd_d3       ;
  reg            data_rd_d4       ;
  reg  [15:0]    packet_start_addr;
  reg  [15:0]    packet_len_latch ;
  reg            fifo_rd          ;
  reg  [03:0]    rd_state         ;
  reg            data_rd          ;
  reg  [02:0]    packet_ch        ;
  reg            data_out_dv_d1   ;
  reg            data_out_dv_d2   ;
  reg            data_out_dv_d3   ;
  reg  [15:0]    read_cnt_sync    ;
  reg  [15:0]    read_cnt         ;
  reg  [15:0]    write_cnt        ;
  reg            full             ;
  reg  [15:0]    ipg_cfg_r        ;
  reg  [15:0]    ipg_cnt          ;

  ////////////////////////////////////////
  //INSTANCE SEGMENT
  ////////////////////////////////////////
  /*
    例化名称，使用大写  模块名称+Ux
  */
  xilinx_ram_reg #(14,8) XILINX_RAM_REG_U0(.clka(rx_clk),.addra(ram_a_addr_d1),.dia(rxd_reg[07:00]),.wea(ram_a_we),.ena(1'b1),.doa(),.clkb(sys_clk),.addrb(packet_start_addr),.dib(9'd0),.web(1'b0),.enb(1'b1),.dob(ram_b_data[07:00]));
  xilinx_ram_reg #(14,8) XILINX_RAM_REG_U1(.clka(rx_clk),.addra(ram_a_addr_d1),.dia(rxd_reg[15:08]),.wea(ram_a_we),.ena(1'b1),.doa(),.clkb(sys_clk),.addrb(packet_start_addr),.dib(9'd0),.web(1'b0),.enb(1'b1),.dob(ram_b_data[15:08]));
  xilinx_ram_reg #(14,8) XILINX_RAM_REG_U2(.clka(rx_clk),.addra(ram_a_addr_d1),.dia(rxd_reg[23:16]),.wea(ram_a_we),.ena(1'b1),.doa(),.clkb(sys_clk),.addrb(packet_start_addr),.dib(9'd0),.web(1'b0),.enb(1'b1),.dob(ram_b_data[23:16]));
  xilinx_ram_reg #(14,8) XILINX_RAM_REG_U3(.clka(rx_clk),.addra(ram_a_addr_d1),.dia(rxd_reg[31:24]),.wea(ram_a_we),.ena(1'b1),.doa(),.clkb(sys_clk),.addrb(packet_start_addr),.dib(9'd0),.web(1'b0),.enb(1'b1),.dob(ram_b_data[31:24]));
  xilinx_ram_reg #(14,8) XILINX_RAM_REG_U4(.clka(rx_clk),.addra(ram_a_addr_d1),.dia(rxd_reg[39:32]),.wea(ram_a_we),.ena(1'b1),.doa(),.clkb(sys_clk),.addrb(packet_start_addr),.dib(9'd0),.web(1'b0),.enb(1'b1),.dob(ram_b_data[39:32]));
  xilinx_ram_reg #(14,8) XILINX_RAM_REG_U5(.clka(rx_clk),.addra(ram_a_addr_d1),.dia(rxd_reg[47:40]),.wea(ram_a_we),.ena(1'b1),.doa(),.clkb(sys_clk),.addrb(packet_start_addr),.dib(9'd0),.web(1'b0),.enb(1'b1),.dob(ram_b_data[47:40]));
  xilinx_ram_reg #(14,8) XILINX_RAM_REG_U6(.clka(rx_clk),.addra(ram_a_addr_d1),.dia(rxd_reg[55:48]),.wea(ram_a_we),.ena(1'b1),.doa(),.clkb(sys_clk),.addrb(packet_start_addr),.dib(9'd0),.web(1'b0),.enb(1'b1),.dob(ram_b_data[55:48]));
  xilinx_ram_reg #(14,8) XILINX_RAM_REG_U7(.clka(rx_clk),.addra(ram_a_addr_d1),.dia(rxd_reg[63:56]),.wea(ram_a_we),.ena(1'b1),.doa(),.clkb(sys_clk),.addrb(packet_start_addr),.dib(9'd0),.web(1'b0),.enb(1'b1),.dob(ram_b_data[63:56]));

  fifo_512x36b FIFO_512X36B_U0(
    .rst          (!rst_b     ),
    .wr_clk       (rx_clk     ),
    .rd_clk       (sys_clk    ),
    .din          (fifo_a_data),
    .wr_en        (fifo_a_we  ),
    .rd_en        (fifo_rd    ),
    .dout         (fifo_b_data),
    .full         (fifo_full  ),
    .empty        (fifo_empty )
  );

  ////////////////////////////////////////
  //ASSIGN SEGMENT
  ////////////////////////////////////////
  assign ready        = (ipg_cnt == 16'd0) ;
  assign en           = valid ;
  assign first_match  = (en)  ;
  assign shift1_match = (en)  ;
  assign shift2_match = (en)  ;
  assign shift3_match = (en)  ;
  assign shift4_match = (en)  ;
  assign shift5_match = (en)  ;
  assign shift6_match = (en)  ;
  assign shift7_match = (en)  ;

  ////////////////////////////////////////
  //ALWAYS SEGMENT
  ////////////////////////////////////////
  /*
    1. 表示嵌套缩两个空格；
    2. begin 和 end 不需要缩两格；
    3. if后面直接跟左括号，不要空格；
  */
  always @(posedge rx_clk or negedge rst_b)
    if(!rst_b)
    begin
      ch          <= 3'b0;
    end
    else
    begin
      if (first_match )
        ch <= 3'd0;
      if (shift1_match)
        ch <= 3'd1;
      if (shift2_match)
        ch <= 3'd2;
      if (shift3_match)
        ch <= 3'd3;
      if (shift4_match)
        ch <= 3'd4;
      if (shift5_match)
        ch <= 3'd5;
      if (shift6_match)
        ch <= 3'd6;
      if (shift7_match)
        ch <= 3'd7;
    end

endmodule

