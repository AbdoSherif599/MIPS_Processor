module Register_File(r_reg1,r_reg2,w_reg,w_data,ctrl_w,r_data1,r_data2);
input wire [4:0]r_reg1,r_reg2,w_reg;
input  wire [31:0] w_data;
input   ctrl_w; 
output wire [31:0]r_data1,r_data2;
reg [31:0] registers [31:0];
assign r_data1 = registers[r_reg1];
assign r_data2 = registers[r_reg2];
integer i;
always @(posedge ctrl_w) begin
     if (ctrl_w) begin
            registers[w_reg] <= w_data; 
        end
end
initial begin
     for ( i=0 ;i<32 ;i=i+1 ) begin
        registers[i]=i;
    end
end
endmodule



module ALU(ctrl_lines,input1,input2,out,z);
input wire [3:0] ctrl_lines;
input wire [31:0] input1,input2;
output reg [31:0] out;
assign z=(input1-input2)==0?1:0;

always @(*) begin
    case (ctrl_lines)
    'b0000: out= input1 & input2;
    'b0001: out= input1 | input2;
    'b0010: out= input1 + input2;
    'b0110: out= input1 - input2;
    'b0111: out= input1 << (input2[4:0]);
    'b1100: out= ~(input1 | input2);
    default : out=0;
        
    
    
    
    endcase
end

endmodule