module chip_74lv165 (
    input  SH_LDn,      // high for shift, low for load
    input  CLK,         // clock
    input  CLK_INH,     // clock inhibit
    input  SER,         // serial input
    input  [7:0] D,     // parallel input, A-H for 0-7
    output QH           // serial output
);

reg  [7:0] shift_reg;
wire c1 = CLK | CLK_INH;

always @(posedge c1 or negedge SH_LDn) begin
    if (SH_LDn) begin
        shift_reg <= {shift_reg[6:0], SER};
    end else begin
        shift_reg <= D[7:0];
    end
end

assign QH = shift_reg[7];

endmodule
