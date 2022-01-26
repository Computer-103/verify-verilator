module soc_top (
    input clk, 
    input resetn,

    output dev_input_rdy,               // handshake
    input  dev_input_val,               // handshake

    output dev_output_rdy,              // handshake
    input  dev_output_ack,              // handshake

    input  [ 4:0] dev_input_data,       // level
    output [ 4:0] dev_output_data,      // level

    input  pnl_start_pulse,             // pulse
    input  pnl_clear_pu,                // pulse
    input  pnl_automatic,               // level
    // TODO

    input  pnl_start_input,             // pulse
    input  pnl_stop_input,              // pulse
    input  pnl_start_output,            // pulse
    input  pnl_stop_output,             // pulse

    input  pnl_input_dec,               // level
    input  pnl_output_dec,              // level

    input  pnl_continuous_input,        // level
    input  pnl_stop_after_output,       // level

    input  pnl_do_arr_c,                // pulse
    input  [30:0] pnl_arr_reg_c_value,  // level

    input  pnl_do_arr_strt,             // pulse
    input  [11:0] pnl_arr_strt_value,   // level

    input  pnl_do_arr_sel,              // pulse
    input  [11:0] pnl_arr_sel_value,    // level

    output [ 5:0] pnl_op_code,          // level
    output [11:0] pnl_strt_value,       // level
    output [11:0] pnl_sel_value,        // level
    output [30:0] pnl_reg_c_value,      // level
    output [ 2:0] pnl_pu_state          // level
);

core_top  u_core_top (
    .clk                     ( clk                      ),
    .resetn                  ( resetn                   ),
    .dev_input_val           ( dev_input_val            ),
    .dev_output_ack          ( dev_output_ack           ),
    .dev_input_data          ( dev_input_data           ),
    .pnl_start_pulse         ( pnl_start_pulse          ),
    .pnl_clear_pu            ( pnl_clear_pu             ),
    .pnl_automatic           ( pnl_automatic            ),
    .pnl_start_input         ( pnl_start_input          ),
    .pnl_stop_input          ( pnl_stop_input           ),
    .pnl_start_output        ( pnl_start_output         ),
    .pnl_stop_output         ( pnl_stop_output          ),
    .pnl_input_dec           ( pnl_input_dec            ),
    .pnl_output_dec          ( pnl_output_dec           ),
    .pnl_continuous_input    ( pnl_continuous_input     ),
    .pnl_stop_after_output   ( pnl_stop_after_output    ),
    .pnl_do_arr_c            ( pnl_do_arr_c             ),
    .pnl_arr_reg_c_value     ( pnl_arr_reg_c_value      ),
    .pnl_do_arr_strt         ( pnl_do_arr_strt          ),
    .pnl_arr_strt_value      ( pnl_arr_strt_value       ),
    .pnl_do_arr_sel          ( pnl_do_arr_sel           ),
    .pnl_arr_sel_value       ( pnl_arr_sel_value        ),

    .dev_input_rdy           ( dev_input_rdy            ),
    .dev_output_rdy          ( dev_output_rdy           ),
    .dev_output_data         ( dev_output_data          ),
    .pnl_op_code             ( pnl_op_code              ),
    .pnl_strt_value          ( pnl_strt_value           ),
    .pnl_sel_value           ( pnl_sel_value            ),
    .pnl_reg_c_value         ( pnl_reg_c_value          ),
    .pnl_pu_state            ( pnl_pu_state             )
);

endmodule
