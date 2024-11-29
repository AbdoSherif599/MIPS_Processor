module tb();
reg [4:0] r_reg1,r_reg2,w_reg;
reg [31:0]w_data,input1,input2,Address,write_data;
wire [31:0]pc,r_data1,r_data2,out,instruction,read_data;
reg ctrl_w;
wire [31:0] pc_new;
reg clk,rst,ctrl_mem_read,ctrl_mem_write;
wire z;

PC_clked pp(clk,rst,pc_new,pc);
//PC_add_4 p4(pc,pc_new);
instruction_fetch_memory fe(pc,instruction);
Data_mem mm(Address,write_data,ctrl_mem_read,ctrl_mem_write,read_data);



reg [3:0] ctrl_lines;

initial begin
    $dumpfile("test.fst");
    $dumpvars(0, tb);
   
       clk = 0; rst = 1;ctrl_mem_read=1;ctrl_mem_write=0;Address=0;

        // Reset the PC
        #10;
        rst = 0; // Assert reset
        #10;
        rst = 1; // Deassert reset
        #10;

    input1=2;
    input2=1;
    ctrl_lines=0;
    
    #200


        $finish;   
end




always #5 clk=~clk;

endmodule