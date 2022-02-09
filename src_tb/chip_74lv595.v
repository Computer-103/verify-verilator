module chip_74lv595 (
    input  OEn,         // output enable, negtive valid
    input  RCLK,        // storage register clock
    input  SRCLK,       // shift register clock
    input  SRCLRn,      // shift register clear
    input  SER,         // serial input
    output [7:0] Q,     // parallel output
    output QH           // serial output
);

reg  [7:0] storage_reg;
reg  [7:0] shift_reg;

always @(posedge RCLK) begin
    storage_reg <= shift_reg;
end

always @(posedge SRCLK) begin
    if (!SRCLRn) begin
        shift_reg <= 8'h00;
    end else begin
        shift_reg <= {shift_reg[6:0], SER};
    end
end

assign Q = OEn ? 8'h0 : storage_reg;
assign QH = shift_reg[7];

endmodule
