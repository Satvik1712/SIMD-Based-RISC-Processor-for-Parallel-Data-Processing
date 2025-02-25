module control_unit (
    input clk,
    input reset,
    output reg [31:0] result
);

    wire [31:0] instruction;
    wire [3:0] opcode;
    wire [4:0] src1, src2, dest;
    wire [31:0] read_data1, read_data2;
    wire [31:0] alu_result;

    // Instantiate the instruction fetch, decode, register file, and ALU
    instruction_fetch fetch_unit (.clk(clk), .reset(reset), .instruction(instruction));
    instruction_decode decode_unit (.instruction(instruction), .opcode(opcode), .src1(src1), .src2(src2), .dest(dest));
    register_file reg_file (.clk(clk), .reset(reset), .read_addr1(src1), .read_addr2(src2), 
                            .write_addr(dest), .write_data(alu_result), .write_enable(1'b1), 
                            .read_data1(read_data1), .read_data2(read_data2));
    simd_alu alu (.opcode(opcode), .operand1(read_data1), .operand2(read_data2), .result(alu_result));

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            result <= 0;
        end else begin
            result <= alu_result;  // Capture the result of the SIMD ALU
        end
    end
endmodule

