module tb();
reg [4:0] r_reg1,r_reg2,w_reg;
reg [31:0]w_data,input1,input2;
wire [31:0]r_data1,r_data2,out;
reg ctrl_w;
reg clk;
integer i;
Register_File rf(r_reg1,r_reg2,w_reg,w_data,ctrl_w,r_data1,r_data2);

reg [3:0] ctrl_lines;
ALU al(ctrl_lines,input1,input2,out);

initial begin
    $dumpfile("test.fst");
    $dumpvars(0, tb);
   
    clk = 0;
    input1=2;
    input2=1;
    ctrl_lines=0;
    #200


        $finish;   
end




always #5 clk=~clk;

endmodule