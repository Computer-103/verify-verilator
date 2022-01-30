module driver_74lv165 (
    input  clk,
    input  resetn,
    
    output [15:0] data_0,
    output [15:0] data_1,
    output [15:0] data_2,
    output [15:0] data_3,

    output SH_LDn,          // high for shift, low for load
    output RCLK,            // clock

    input  QH_0,            // serial output
    input  QH_1,            // serial output
    input  QH_2,            // serial output
    input  QH_3             // serial output
);

reg shift_clk;
reg shiftn_load;

reg [ 3:0] cnt;

reg [15:0] data_0_r;
reg [15:0] data_1_r;
reg [15:0] data_2_r;
reg [15:0] data_3_r;

reg [15:0] data_0_s;
reg [15:0] data_1_s;
reg [15:0] data_2_s;
reg [15:0] data_3_s;

always @(posedge clk) begin
    if (~resetn) begin
        shift_clk <= 1'b0;
    end else begin
        shift_clk <= ~shift_clk;
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        cnt <= 4'd0;
    end else if (!shift_clk) begin
        if (cnt == 4'd15) begin
            cnt <= 4'd0;
        end else begin
            cnt <= cnt + 4'd1;
        end
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        shiftn_load <= 1'b0;
    end else if (shift_clk) begin
        shiftn_load <= 1'b0;
    end else if (!shift_clk) begin
        if (cnt == 4'd15) begin
            shiftn_load <= 1'b1;
        end else begin
            shiftn_load <= 1'b0;
        end
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        data_0_r <= 16'd0;
        data_1_r <= 16'd0;
        data_2_r <= 16'd0;
        data_3_r <= 16'd0;
    end else if (!shift_clk) begin
        if (cnt == 4'd0) begin
            data_0_r <= data_0_s;
            data_1_r <= data_1_s;
            data_2_r <= data_2_s;
            data_3_r <= data_3_s;
        end
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        data_0_s <= 16'd0;
        data_1_s <= 16'd0;
        data_2_s <= 16'd0;
        data_3_s <= 16'd0;
    end else if (!shift_clk) begin
        data_0_s <= {data_0_s[14:0], QH_0};
        data_1_s <= {data_1_s[14:0], QH_1};
        data_2_s <= {data_2_s[14:0], QH_2};
        data_3_s <= {data_3_s[14:0], QH_3};
    end
end

assign SH_LDn = !shiftn_load;
assign RCLK = shift_clk;
assign data_0 = data_0_r;
assign data_1 = data_1_r;
assign data_2 = data_2_r;
assign data_3 = data_3_r;

endmodule
