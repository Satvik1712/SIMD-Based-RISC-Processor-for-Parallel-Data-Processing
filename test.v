module simd_risc_testbench;

    reg clk;
    reg reset;
    wire [127:0] result;

    // Declare individual 32-bit registers instead of 128-bit registers
    reg [31:0] registers1 [0:3];  // Four 32-bit registers for operand1
    reg [31:0] registers2 [0:3];  // Four 32-bit registers for operand2
    reg [31:0] destination_registers [0:3]; // Four 32-bit registers for storing results

    // 128-bit combined operands for the ALU
    reg [127:0] operand1, operand2;

    // Instruction memory and control logic
    reg [31:0] instruction_memory [0:31]; // Instruction memory for 32 instructions
    integer pc; // Program Counter
    reg [3:0] opcode;
    reg [4:0] src1, src2, dest;

    // Instantiate the SIMD ALU with clk and reset signals
    simd_alu alu (
        .clk(clk),
        .reset(reset),
        .opcode(opcode),
        .operand1(operand1),
        .operand2(operand2),
        .result(result)
    );

    // Initialize the registers and instructions
    initial begin
        // Initialize the clock and reset signals
        clk = 0;
        reset = 1;
        pc = 0; // Initialize program counter
        #5 reset = 0;  // Release reset after 5 time units

        // Initialize individual 32-bit registers for operand1
        registers1[0] = 32'd20;
        registers1[1] = 32'd15;
        registers1[2] = 32'd10;
        registers1[3] = 32'd5;

        // Initialize individual 32-bit registers for operand2
        registers2[0] = 32'd12;
        registers2[1] = 32'd9;
        registers2[2] = 32'd6;
        registers2[3] = 32'd3;

        // Combine four 32-bit registers to form 128-bit operands
        operand1 = {registers1[0], registers1[1], registers1[2], registers1[3]};
        operand2 = {registers2[0], registers2[1], registers2[2], registers2[3]};

        // Initialize instruction memory with instructions for vector operations
        instruction_memory[0] = 32'b0000_00001_00010_00011;  // ADD R1, R2 -> R3
        instruction_memory[1] = 32'b0001_00001_00010_00100;  // SUB R1, R2 -> R4
        instruction_memory[2] = 32'b0010_00001_00010_00101;  // MUL R1, R2 -> R5
        instruction_memory[3] = 32'b0011_00001_00010_00110;  // AND R1, R2 -> R6
        instruction_memory[4] = 32'b0100_00001_00010_00111;  // OR R1, R2 -> R7
        instruction_memory[5] = 32'b0101_00001_00010_01000;  // XOR R1, R2 -> R8
        instruction_memory[6] = 32'b0110_00001_00010_01001;  // NAND R1, R2 -> R9
        instruction_memory[7] = 32'b0111_00001_00010_01010;  // NOR R1, R2 -> R10
        instruction_memory[8] = 32'b1000_00001_00010_01011;  // XNOR R1, R2 -> R11
        instruction_memory[9] = 32'b1001_00001_00010_01100;  // DIV R1, R2 -> R12
        instruction_memory[10] = 32'b1010_00001_00010_01101; // EQ R1, R2 -> R13
        instruction_memory[11] = 32'b1011_00001_00010_01110; // GT R1, R2 -> R14
        instruction_memory[12] = 32'b1100_00001_00010_01111; // LT R1, R2 -> R15

        // Run the simulation for a sufficient number of clock cycles
        #200 $finish;
    end

    // Clock generation (50% duty cycle, period = 10 time units)
    always #5 clk = ~clk;

    // Instruction fetch and execution logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 0;  // Reset program counter
        end else begin
            // Fetch instruction
            {opcode, src1, src2, dest} = instruction_memory[pc];  // Decode instruction

            // Perform ALU operation (assuming operand1 and operand2 are set as needed)
            // Store each 32-bit segment of the result in four destination registers
            #1 begin
                destination_registers[0] <= result[127:96]; // Store the upper 32 bits of the result
                destination_registers[1] <= result[95:64];  // Next 32 bits
                destination_registers[2] <= result[63:32];  // Next 32 bits
                destination_registers[3] <= result[31:0];   // Lower 32 bits
            end

            // Increment program counter to next instruction
            #1 pc <= pc + 1;
        end
    end

    // Conditional monitor to print results at specific intervals (5, 15, 25, ...)
    always @(posedge clk) begin
        if ($time % 10 == 5) begin  // Print only at times 5, 15, 25, ...
            $display("Time=%0t || Result=%h, %h, %h, %h", 
                     $time, destination_registers[0], destination_registers[1], 
                     destination_registers[2], destination_registers[3]);
        end
    end

endmodule

