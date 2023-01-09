`timescale 1ns/1ns

module fp_adder_test();
    wire [31:0]a;
    wire [31:0]b;
    wire [31:0]s;
    assign a=32'b0100_0000_0000_0001_1011_1010_1011_1010;
    assign b=32'b1100_1010_1111_1110_1101_1110_1010_1101;
    
fp_adder uut ( 
    .a(a),
    .b(b),
    .s(s)
);



endmodule