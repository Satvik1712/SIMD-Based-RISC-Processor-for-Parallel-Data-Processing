module instruction_fetch (
    input clk,
    input reset,
    output reg [31:0] instruction
);

    reg [31:0] pc;  // Program counter
    reg [31:0] instruction_memory [0:255];  // Memory for storing instructions

    // Initialize instruction memory (could be replaced with a file load)
    initial begin
        $readmemb("instructions.mem", instruction_memory);  // Load instructions from file
        pc = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 0;
        else
            instruction <= instruction_memory[pc];
        pc <= pc + 1;  // Increment program counter
    end
endmodule

