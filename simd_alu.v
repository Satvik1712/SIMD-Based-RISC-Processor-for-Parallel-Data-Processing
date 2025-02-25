module simd_alu (
    input clk,                  // Clock signal
    input reset,                // Reset signal
    input [3:0] opcode,         // Operation code (ADD, SUB, etc.)
    input [127:0] operand1,     // Operand 1 (128-bit vector)
    input [127:0] operand2,     // Operand 2 (128-bit vector)
    output reg [127:0] result   // Result of the operation
);

    reg [31:0] op1[3:0];  // Four 32-bit elements from operand1
    reg [31:0] op2[3:0];  // Four 32-bit elements from operand2
    reg [31:0] res[3:0];  // Result for each 32-bit element
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            result <= 128'b0;  // Reset result to 0
        end else begin
            // Split the 128-bit inputs into four 32-bit parts
            for (i = 0; i < 4; i = i + 1) begin
                op1[i] = operand1[32*i +: 32];  // Extract bits [31:0], [63:32], etc.
                op2[i] = operand2[32*i +: 32];
            end

            // Perform the operation on all elements in parallel
            case (opcode)
                4'b0000: for (i = 0; i < 4; i = i + 1) res[i] = op1[i] + op2[i];  // ADD
                4'b0001: for (i = 0; i < 4; i = i + 1) res[i] = op1[i] - op2[i];  // SUB
                4'b0010: for (i = 0; i < 4; i = i + 1) res[i] = op1[i] * op2[i];  // MUL
                4'b0011: for (i = 0; i < 4; i = i + 1) res[i] = op1[i] & op2[i];  // AND
                4'b0100: for (i = 0; i < 4; i = i + 1) res[i] = op1[i] | op2[i];  // OR
                4'b0101: for (i = 0; i < 4; i = i + 1) res[i] = op1[i] ^ op2[i];  // XOR
                4'b0110: for (i = 0; i < 4; i = i + 1) res[i] = ~(op1[i] & op2[i]); // NAND
                4'b0111: for (i = 0; i < 4; i = i + 1) res[i] = ~(op1[i] | op2[i]); // NOR
                4'b1000: for (i = 0; i < 4; i = i + 1) res[i] = ~(op1[i] ^ op2[i]); // XNOR
                4'b1001: for (i = 0; i < 4; i = i + 1) res[i] = (op2[i] != 0) ? op1[i] / op2[i] : 32'b0; // DIV (with zero check)
                4'b1010: for (i = 0; i < 4; i = i + 1) res[i] = (op1[i] == op2[i]) ? 32'hFFFFFFFF : 32'b0; // EQ (returns all 1s if equal)
                4'b1011: for (i = 0; i < 4; i = i + 1) res[i] = (op1[i] > op2[i]) ? 32'hFFFFFFFF : 32'b0; // GT (greater than)
                4'b1100: for (i = 0; i < 4; i = i + 1) res[i] = (op1[i] < op2[i]) ? 32'hFFFFFFFF : 32'b0; // LT (less than)
                default: for (i = 0; i < 4; i = i + 1) res[i] = 32'b0;  // Default case
            endcase

            // Combine the four 32-bit results back into a 128-bit result
            for (i = 0; i < 4; i = i + 1) begin
                result[32*i +: 32] = res[i];
            end
        end
    end
endmodule


