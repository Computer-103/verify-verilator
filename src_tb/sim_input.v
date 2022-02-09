module sim_input (
    input  clk,
    input  resetn,
    input  input_rdy,
    output input_val,
    output [ 4:0] input_data
);

`define IDLE 0
`define READ 1
`define VAL 2

reg  [ 2:0] status;
reg  [ 2:0] status_next;

reg  [ 7:0] tape_data;

always @(posedge clk) begin
    if (~resetn) begin
        status <= 0;
        status[`IDLE] <= 1;
    end else begin
        status <= status_next;
    end
end

always @(*) begin
    status_next = 0;
    case (1'b1)
        status[`IDLE]: begin
            if (input_rdy) begin
                status_next[`READ] = 1;
            end else begin
                status_next[`IDLE] = 1;
            end
        end
        status[`READ]: begin
            status_next[`VAL] = 1;
        end
        status[`VAL]: begin
            if (!input_rdy) begin
                status_next[`IDLE] = 1;
            end else begin
                status_next[`VAL] = 1;
            end
        end
        default: begin
            status_next[`IDLE] = 1;
        end
    endcase
end

integer fp_read;
initial begin
    fp_read = $fopen("test/input.bin", "rb");
end

always @(negedge clk) begin
    if (status_next[`READ]) begin
        $fread(tape_data, fp_read);
        // $display("READING TAPE %b\n", tape_data);
    end
end

assign input_val = status[`VAL];
assign input_data = tape_data[4:0];

endmodule
