module sim_top (
    input  clk,             // clk
    input  resetn,          // resetn
    input  btn_start_pulse,
    input  btn_clear_pu,
    input  btn_mem_read,
    input  btn_mem_write,
    input  btn_start_input, // start_input
    input  btn_stop_input,
    input  btn_start_output,
    input  btn_stop_output,
    input  sw_input_dec,
    input  sw_output_dec,
    input  sw_continuous_input,
    input  sw_stop_after_output,
    input  sw_automatic,
    input  sw_stop_at_cmp,
    input  sw_cmp_with_strt,
    input  sw_allow_arr,
    input  btn_do_arr_c,
    input  btn_do_arr_strt,
    input  btn_do_arr_sel,

    input  [30:0] sw_arr_reg_c_value,
    input  [11:0] sw_arr_strt_value,
    input  [11:0] sw_arr_sel_value,
    input  [11:0] sw_arr_cmp_value,

    output machine_is_stop  // machine is stop
);

// hardware_top Inputs
wire dev_input_val;
wire dev_output_ack;
wire [ 4:0]  dev_input_data;

// hardware_top Outputs
wire dev_input_rdy;
wire dev_output_rdy;
wire [ 4:0]  dev_output_data;
wire pnl_input_active;
wire pnl_output_active;
wire [ 5:0]  pnl_op_code = u_hardware_top.pnl_op_code;
wire [11:0]  pnl_strt_value = u_hardware_top.pnl_strt_value;
wire [11:0]  pnl_sel_value = u_hardware_top.pnl_sel_value;
wire [30:0]  pnl_reg_c_value = u_hardware_top.pnl_reg_c_value;
wire [ 2:0]  pnl_pu_state;

wire serial_out_rclk;
wire serial_out_srclk;
wire serial_out_ser_0;
wire serial_out_ser_1;
wire serial_out_ser_2;
wire serial_out_ser_3;

wire [ 5:0]  serial_op_code;
wire [11:0]  serial_strt_value;
wire [11:0]  serial_sel_value;
wire [30:0]  serial_reg_c_value;

wire [ 7:0] serial_out_0_0;
wire [ 7:0] serial_out_0_1;
wire [ 7:0] serial_out_0_2;
wire [ 7:0] serial_out_0_3;
wire [ 7:0] serial_out_1_0;
wire [ 7:0] serial_out_1_1;
wire [ 7:0] serial_out_1_2;
wire [ 7:0] serial_out_1_3;

wire serial_out_cascade_0;
wire serial_out_cascade_1;
wire serial_out_cascade_2;
wire serial_out_cascade_3;

wire serial_in_rclk;
wire serial_in_shldn;
wire serial_in_ser_0;
wire serial_in_ser_1;
wire serial_in_ser_2;
wire serial_in_ser_3;
wire serial_in_ser_4;
wire [15:0] serial_in_0;
wire [15:0] serial_in_1;
wire [15:0] serial_in_2;
wire [15:0] serial_in_3;
wire [15:0] serial_in_4;
wire serial_in_cascade_0;
wire serial_in_cascade_1;
wire serial_in_cascade_2;
wire serial_in_cascade_3;
wire serial_in_cascade_4;

wire serial_no_0;
wire serial_no_1;
wire serial_no_2;
wire serial_no_3;

hardware_top  u_hardware_top (
    .clk                         ( clk                          ),
    .resetn                      ( resetn                       ),
    .dev_input_val               ( dev_input_val                ),
    .dev_output_ack              ( dev_output_ack               ),
    .dev_input_data              ( dev_input_data               ),
    .btn_start_pulse             ( btn_start_pulse              ),
    .btn_clear_pu                ( btn_clear_pu                 ),
    .btn_mem_read                ( btn_mem_read                 ),
    .btn_mem_write               ( btn_mem_write                ),
    .btn_start_input             ( btn_start_input              ),
    .btn_stop_input              ( btn_stop_input               ),
    .btn_start_output            ( btn_start_output             ),
    .btn_stop_output             ( btn_stop_output              ),
    .sw_input_dec                ( sw_input_dec                 ),
    .sw_output_dec               ( sw_output_dec                ),
    .sw_continuous_input         ( sw_continuous_input          ),
    .sw_stop_after_output        ( sw_stop_after_output         ),
    .sw_automatic                ( sw_automatic                 ),
    .sw_stop_at_cmp              ( sw_stop_at_cmp               ),
    .sw_cmp_with_strt            ( sw_cmp_with_strt             ),
    .sw_allow_arr                ( sw_allow_arr                 ),
    .btn_do_arr_c                ( btn_do_arr_c                 ),
    .btn_do_arr_strt             ( btn_do_arr_strt              ),
    .btn_do_arr_sel              ( btn_do_arr_sel               ),

    .dev_input_rdy               ( dev_input_rdy                ),
    .dev_output_rdy              ( dev_output_rdy               ),
    .dev_output_data             ( dev_output_data              ),
    .pnl_input_active            ( pnl_input_active             ),
    .pnl_output_active           ( pnl_output_active            ),
    .pnl_pu_state                ( pnl_pu_state                 ),
    .serial_out_rclk             ( serial_out_rclk              ),
    .serial_out_srclk            ( serial_out_srclk             ),
    .serial_out_ser_0            ( serial_out_ser_0             ),
    .serial_out_ser_1            ( serial_out_ser_1             ),
    .serial_out_ser_2            ( serial_out_ser_2             ),
    .serial_out_ser_3            ( serial_out_ser_3             ),
    .serial_in_rclk              ( serial_in_rclk               ),
    .serial_in_shldn             ( serial_in_shldn              ),
    .serial_in_ser_0             ( serial_in_ser_0              ),
    .serial_in_ser_1             ( serial_in_ser_1              ),
    .serial_in_ser_2             ( serial_in_ser_2              ),
    .serial_in_ser_3             ( serial_in_ser_3              ),
    .serial_in_ser_4             ( serial_in_ser_4              )
);

sim_input  u_sim_input (
    .clk                     ( clk              ),
    .resetn                  ( resetn           ),
    .input_rdy               ( dev_input_rdy    ),

    .input_val               ( dev_input_val    ),
    .input_data              ( dev_input_data   )
);

sim_output  u_sim_output (
    .clk                     ( clk              ),
    .resetn                  ( resetn           ),
    .output_rdy              ( dev_output_rdy   ),
    .output_data             ( dev_output_data  ),

    .output_ack              ( dev_output_ack   )
);

chip_74lv595  u_chip_74lv595_0_0 (
    .OEn                     ( 1'b0                 ),
    .RCLK                    ( serial_out_rclk      ),
    .SRCLK                   ( serial_out_srclk     ),
    .SRCLRn                  ( 1'b1                 ),
    .SER                     ( serial_out_ser_0     ),

    .Q                       ( serial_out_0_0  ),
    .QH                      ( serial_out_cascade_0     )
);

chip_74lv595  u_chip_74lv595_0_1 (
    .OEn                     ( 1'b0                 ),
    .RCLK                    ( serial_out_rclk      ),
    .SRCLK                   ( serial_out_srclk     ),
    .SRCLRn                  ( 1'b1                 ),
    .SER                     ( serial_out_cascade_0     ),

    .Q                       ( serial_out_0_1      ),
    .QH                      ( serial_no_0          )
);

chip_74lv595  u_chip_74lv595_1_0 (
    .OEn                     ( 1'b0                 ),
    .RCLK                    ( serial_out_rclk      ),
    .SRCLK                   ( serial_out_srclk     ),
    .SRCLRn                  ( 1'b1                 ),
    .SER                     ( serial_out_ser_1     ),

    .Q                       ( serial_out_0_2      ),
    .QH                      ( serial_out_cascade_1     )
);
chip_74lv595  u_chip_74lv595_1_1 (
    .OEn                     ( 1'b0                 ),
    .RCLK                    ( serial_out_rclk      ),
    .SRCLK                   ( serial_out_srclk     ),
    .SRCLRn                  ( 1'b1                 ),
    .SER                     ( serial_out_cascade_1     ),

    .Q                       ( serial_out_0_3      ),
    .QH                      ( serial_no_1          )
);

chip_74lv595  u_chip_74lv595_2_0 (
    .OEn                     ( 1'b0                 ),
    .RCLK                    ( serial_out_rclk      ),
    .SRCLK                   ( serial_out_srclk     ),
    .SRCLRn                  ( 1'b1                 ),
    .SER                     ( serial_out_ser_2     ),

    .Q                       ( serial_out_1_0      ),
    .QH                      ( serial_out_cascade_2     )
);
chip_74lv595  u_chip_74lv595_2_1 (
    .OEn                     ( 1'b0                 ),
    .RCLK                    ( serial_out_rclk      ),
    .SRCLK                   ( serial_out_srclk     ),
    .SRCLRn                  ( 1'b1                 ),
    .SER                     ( serial_out_cascade_2     ),

    .Q                       ( serial_out_1_1      ),
    .QH                      ( serial_no_2          )
);

chip_74lv595  u_chip_74lv595_3_0 (
    .OEn                     ( 1'b0                 ),
    .RCLK                    ( serial_out_rclk      ),
    .SRCLK                   ( serial_out_srclk     ),
    .SRCLRn                  ( 1'b1                 ),
    .SER                     ( serial_out_ser_3     ),

    .Q                       ( serial_out_1_2      ),
    .QH                      ( serial_out_cascade_3     )
);
chip_74lv595  u_chip_74lv595_3_1 (
    .OEn                     ( 1'b0                 ),
    .RCLK                    ( serial_out_rclk      ),
    .SRCLK                   ( serial_out_srclk     ),
    .SRCLRn                  ( 1'b1                 ),
    .SER                     ( serial_out_cascade_3     ),

    .Q                       ( serial_out_1_3      ),
    .QH                      ( serial_no_3          )
);

assign serial_reg_c_value[30:0] = 
    {serial_out_0_3[6:0], serial_out_0_2, serial_out_0_1, serial_out_0_0};
assign {serial_op_code[5:0], serial_strt_value[11:0], serial_sel_value[11:0]} = 
    {serial_out_1_3[5:0], serial_out_1_2, serial_out_1_1, serial_out_1_0};

chip_74lv165 u_chip_74lv165_0_0 (
    .CLK                     ( serial_in_rclk       ),
    .CLK_INH                 ( 1'b0                 ),
    .SH_LDn                  ( serial_in_shldn      ),
    .SER                     ( 1'b0                 ),

    .D                       ( serial_in_0[7:0]     ),
    .QH                      ( serial_in_cascade_0  )
);
chip_74lv165 u_chip_74lv165_0_1 (
    .CLK                     ( serial_in_rclk       ),
    .CLK_INH                 ( 1'b0                 ),
    .SH_LDn                  ( serial_in_shldn      ),
    .SER                     ( serial_in_cascade_0  ),

    .D                       ( serial_in_0[15:8]    ),
    .QH                      ( serial_in_ser_0      )
);

chip_74lv165 u_chip_74lv165_1_0 (
    .CLK                     ( serial_in_rclk       ),
    .CLK_INH                 ( 1'b0                 ),
    .SH_LDn                  ( serial_in_shldn      ),
    .SER                     ( 1'b0                 ),

    .D                       ( serial_in_1[7:0]     ),
    .QH                      ( serial_in_cascade_1  )
);
chip_74lv165 u_chip_74lv165_1_1 (
    .CLK                     ( serial_in_rclk       ),
    .CLK_INH                 ( 1'b0                 ),
    .SH_LDn                  ( serial_in_shldn      ),
    .SER                     ( serial_in_cascade_1  ),

    .D                       ( serial_in_1[15:8]    ),
    .QH                      ( serial_in_ser_1      )
);

chip_74lv165 u_chip_74lv165_2_0 (
    .CLK                     ( serial_in_rclk       ),
    .CLK_INH                 ( 1'b0                 ),
    .SH_LDn                  ( serial_in_shldn      ),
    .SER                     ( 1'b0                 ),

    .D                       ( serial_in_2[7:0]     ),
    .QH                      ( serial_in_cascade_2  )
);
chip_74lv165 u_chip_74lv165_2_1 (
    .CLK                     ( serial_in_rclk       ),
    .CLK_INH                 ( 1'b0                 ),
    .SH_LDn                  ( serial_in_shldn      ),
    .SER                     ( serial_in_cascade_2  ),

    .D                       ( serial_in_2[15:8]    ),
    .QH                      ( serial_in_ser_2      )
);

chip_74lv165 u_chip_74lv165_3_0 (
    .CLK                     ( serial_in_rclk       ),
    .CLK_INH                 ( 1'b0                 ),
    .SH_LDn                  ( serial_in_shldn      ),
    .SER                     ( 1'b0                 ),

    .D                       ( serial_in_3[7:0]     ),
    .QH                      ( serial_in_cascade_3  )
);
chip_74lv165 u_chip_74lv165_3_1 (
    .CLK                     ( serial_in_rclk       ),
    .CLK_INH                 ( 1'b0                 ),
    .SH_LDn                  ( serial_in_shldn      ),
    .SER                     ( serial_in_cascade_3  ),

    .D                       ( serial_in_3[15:8]    ),
    .QH                      ( serial_in_ser_3      )
);

chip_74lv165 u_chip_74lv165_4_0 (
    .CLK                     ( serial_in_rclk       ),
    .CLK_INH                 ( 1'b0                 ),
    .SH_LDn                  ( serial_in_shldn      ),
    .SER                     ( 1'b0                 ),

    .D                       ( serial_in_4[7:0]     ),
    .QH                      ( serial_in_cascade_4  )
);
chip_74lv165 u_chip_74lv165_4_1 (
    .CLK                     ( serial_in_rclk       ),
    .CLK_INH                 ( 1'b0                 ),
    .SH_LDn                  ( serial_in_shldn      ),
    .SER                     ( serial_in_cascade_4  ),

    .D                       ( serial_in_4[15:8]    ),
    .QH                      ( serial_in_ser_4      )
);

assign {serial_in_1, serial_in_0} =
    {1'b0, sw_arr_reg_c_value};
assign {serial_in_3, serial_in_2} =
    {8'b0, sw_arr_strt_value, sw_arr_sel_value};
assign {serial_in_4} =
    {4'b0, sw_arr_cmp_value};

reg  [7:0] stop_counter;
reg  [2:0] last_pu_state;
always @(posedge clk) begin
    last_pu_state <= pnl_pu_state;
end
always @(posedge clk) begin
    if (~resetn) begin
        stop_counter <= 8'h00;
    end else if (pnl_pu_state == last_pu_state) begin
        if (stop_counter != 8'hff) begin
            stop_counter <= stop_counter + 8'h01;
        end
    end else begin
        stop_counter <= 8'h00;
    end
end

assign machine_is_stop = 
    stop_counter == 8'hff &&
    !pnl_input_active &&
    !pnl_output_active;

endmodule
