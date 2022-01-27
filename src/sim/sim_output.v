module sim_output (
    input  clk,
    input  resetn,
    input  output_rdy,
    output output_ack,
    input [ 4:0] output_data
);

`define IDLE 0
`define WRITE 1
`define ACK 2

reg  [ 2:0] status;
reg  [ 2:0] status_next;

wire [ 7:0] tape_data;

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
            if (output_rdy) begin
                status_next[`WRITE] = 1;
            end else begin
                status_next[`IDLE] = 1;
            end
        end
        status[`WRITE]: begin
            status_next[`ACK] = 1;
        end
        status[`ACK]: begin
            if (!output_rdy) begin
                status_next[`IDLE] = 1;
            end else begin
                status_next[`ACK] = 1;
            end
        end
        default: begin
            status_next[`IDLE] = 1;
        end
    endcase
end

integer fp_write;
initial begin
    fp_write = $fopen("test/output.bin", "wb");
end

always @(negedge clk) begin
    if (status_next[`WRITE]) begin
        $fwrite(fp_write, "%c", tape_data);
        $display("WRTING TAPE %b\n", tape_data);
    end
end

assign output_ack = status[`ACK];
assign tape_data = {3'b0, output_data};

endmodule
