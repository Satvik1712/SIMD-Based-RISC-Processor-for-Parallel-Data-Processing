module register_file (
    input clk,
    input reset,
    input [4:0] read_addr1,  // Address of register 1
    input [4:0] read_addr2,  // Address of register 2
    input [4:0] write_addr,  // Address of register to write to
    input [31:0] write_data, // Data to write
    input write_enable,      // Enable writing
    output reg [31:0] read_data1,  // Data from register 1
    output reg [31:0] read_data2   // Data from register 2
);

    reg [31:0] registers [0:31];  // 32 registers of 32 bits each

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Optionally initialize registers here
        end else if (write_enable) begin
            registers[write_addr] <= write_data;
        end
    end

    always @(*) begin
        read_data1 = registers[read_addr1];
        read_data2 = registers[read_addr2];
    end
endmodule

