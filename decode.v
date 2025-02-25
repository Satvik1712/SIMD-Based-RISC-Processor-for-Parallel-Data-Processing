module instruction_decode (
    input [31:0] instruction,
    output reg [3:0] opcode,      // 4-bit opcode (supports 16 operations)
    output reg [4:0] src1,        // Source register 1
    output reg [4:0] src2,        // Source register 2
    output reg [4:0] dest         // Destination register
);

    always @(*) begin
        opcode <= instruction[31:28];  // Extract opcode (bits 31 to 28)
        src1   <= instruction[27:23];  // Source register 1 (bits 27 to 23)
        src2   <= instruction[22:18];  // Source register 2 (bits 22 to 18)
        dest   <= instruction[17:13];  // Destination register (bits 17 to 13)
    end
endmodule

