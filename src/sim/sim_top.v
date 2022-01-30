module sim_top (
    input  clk,             // clk
    input  resetn,          // resetn
    input  btn_start_pulse,
    input  btn_clear_pu,
    input  btn_start_input, // start_input
    input  btn_stop_input,
    input  btn_start_output,
    input  btn_stop_output,
    input  sw_input_dec,
    input  sw_output_dec,
    input  sw_continuous_input,
    input  sw_stop_after_output,
    input  sw_automatic,
    input  btn_do_arr_c,
    input  btn_do_arr_strt,
    input  btn_do_arr_sel,

    output machine_is_stop  // machine is stop
);

// soc_top Inputs
wire dev_input_val;
wire dev_output_ack;
wire [ 4:0]  dev_input_data;

// soc_top Outputs
wire dev_input_rdy;
wire dev_output_rdy;
wire [ 4:0]  dev_output_data;
wire pnl_input_active;
wire pnl_output_active;
wire [ 5:0]  pnl_op_code;
wire [11:0]  pnl_strt_value = u_soc_top.pnl_strt_value;
wire [11:0]  pnl_sel_value = u_soc_top.pnl_sel_value;
wire [30:0]  pnl_reg_c_value = u_soc_top.pnl_reg_c_value;
wire [ 2:0]  pnl_pu_state;

soc_top  u_soc_top (
    .clk                                    ( clk                                     ),
    .resetn                                 ( resetn                                  ),
    .dev_input_val                          ( dev_input_val                           ),
    .dev_output_ack                         ( dev_output_ack                          ),
    .dev_input_data                         ( dev_input_data                          ),
    .btn_start_pulse                        ( btn_start_pulse                         ),
    .btn_clear_pu                           ( btn_clear_pu                            ),
    .btn_start_input                        ( btn_start_input                         ),
    .btn_stop_input                         ( btn_stop_input                          ),
    .btn_start_output                       ( btn_start_output                        ),
    .btn_stop_output                        ( btn_stop_output                         ),
    .sw_input_dec                           ( sw_input_dec                            ),
    .sw_output_dec                          ( sw_output_dec                           ),
    .sw_continuous_input                    ( sw_continuous_input                     ),
    .sw_stop_after_output                   ( sw_stop_after_output                    ),
    .sw_automatic                           ( sw_automatic                            ),
    .btn_do_arr_c                           ( btn_do_arr_c                            ),
    .btn_do_arr_strt                        ( btn_do_arr_strt                         ),
    .btn_do_arr_sel                         ( btn_do_arr_sel                          ),

    .dev_input_rdy                          ( dev_input_rdy                           ),
    .dev_output_rdy                         ( dev_output_rdy                          ),
    .dev_output_data                        ( dev_output_data                         ),
    .pnl_input_active                       ( pnl_input_active                        ),
    .pnl_output_active                      ( pnl_output_active                       ),
    .pnl_op_code                            ( pnl_op_code                             ),
    .pnl_pu_state                           ( pnl_pu_state                            )
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
