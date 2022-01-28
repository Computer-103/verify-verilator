module soc_top (
    input clk, 
    input resetn,

    output dev_input_rdy,               // handshake
    input  dev_input_val,               // handshake

    output dev_output_rdy,              // handshake
    input  dev_output_ack,              // handshake

    input  [ 4:0] dev_input_data,       // level
    output [ 4:0] dev_output_data,      // level

    input  btn_start_pulse,             // btn
    input  btn_clear_pu,                // btn

    input  btn_start_input,             // btn
    input  btn_stop_input,              // btn
    input  btn_start_output,            // btn
    input  btn_stop_output,             // btn

    input  sw_input_dec,                // level
    input  sw_output_dec,               // level

    input  sw_continuous_input,         // level
    input  sw_stop_after_output,        // level
    input  sw_automatic,                // level

    input  btn_do_arr_c,                // btn
    input  btn_do_arr_strt,             // btn
    input  btn_do_arr_sel,              // btn

    output [ 5:0] pnl_op_code,          // level
    output [ 2:0] pnl_pu_state,         // level

    output pnl_input_active,            // level
    output pnl_output_active            // level
    
);

// pnl pulse
wire pnl_start_pulse;
wire pnl_clear_pu;
wire pnl_start_input;
wire pnl_stop_input; 
wire pnl_start_output;
wire pnl_stop_output;
wire pnl_do_arr_c;
wire pnl_do_arr_strt;
wire pnl_do_arr_sel;

// pnl level
wire pnl_input_dec;
wire pnl_output_dec;
wire pnl_continuous_input;
wire pnl_stop_after_output;
wire pnl_automatic;

// pnl serial
wire [30:0] pnl_arr_reg_c_value = 31'o0;
wire [11:0] pnl_arr_strt_value = 12'o0;
wire [11:0] pnl_arr_sel_value = 12'o0;

wire [30:0] pnl_reg_c_value;
wire [11:0] pnl_strt_value;
wire [11:0] pnl_sel_value;


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
    .pnl_input_active        ( pnl_input_active         ),
    .pnl_output_active       ( pnl_output_active        ),
    .pnl_op_code             ( pnl_op_code              ),
    .pnl_strt_value          ( pnl_strt_value           ),
    .pnl_sel_value           ( pnl_sel_value            ),
    .pnl_reg_c_value         ( pnl_reg_c_value          ),
    .pnl_pu_state            ( pnl_pu_state             )
);

button_pulse  start_pulse_button_pulse (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .btn    ( btn_start_pulse                   ),
    .pulse  ( pnl_start_pulse                   )
);
button_pulse  clear_pu_button_pulse (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .btn    ( btn_clear_pu                      ),
    .pulse  ( pnl_clear_pu                      )
);
button_pulse  start_input_button_pulse (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .btn    ( btn_start_input                   ),
    .pulse  ( pnl_start_input                   )
);
button_pulse  stop_input_button_pulse (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .btn    ( btn_stop_input                    ),
    .pulse  ( pnl_stop_input                    )
);
button_pulse  start_output_button_pulse (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .btn    ( btn_start_output                  ),
    .pulse  ( pnl_start_output                  )
);
button_pulse  stop_output_button_pulse (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .btn    ( btn_stop_output                   ),
    .pulse  ( pnl_stop_output                   )
);
button_pulse  do_arr_c_button_pulse (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .btn    ( btn_do_arr_c                      ),
    .pulse  ( pnl_do_arr_c                      )
);
button_pulse  do_arr_strt_button_pulse (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .btn    ( btn_do_arr_strt                   ),
    .pulse  ( pnl_do_arr_strt                   )
);
button_pulse  do_arr_sel_button_pulse (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .btn    ( btn_do_arr_sel                    ),
    .pulse  ( pnl_do_arr_sel                    )
);

switch_level  input_dec_switch_level (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .sw     ( sw_input_dec                      ),
    .level  ( pnl_input_dec                     )
);
switch_level  output_dec_switch_level (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .sw     ( sw_output_dec                     ),
    .level  ( pnl_output_dec                    )
);
switch_level  continuous_input_switch_level (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .sw     ( sw_continuous_input               ),
    .level  ( pnl_continuous_input              )
);
switch_level  stop_after_output_switch_level (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .sw     ( sw_stop_after_output              ),
    .level  ( pnl_stop_after_output             )
);
switch_level  automatic_switch_level (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .sw     ( sw_automatic                      ),
    .level  ( pnl_automatic                     )
);

endmodule
