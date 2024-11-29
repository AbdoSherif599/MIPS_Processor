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

/////////////////////////////////////////////////



module Sign_Extend(in,out);
input [15:0] in;
output [31:0] out;
assign out={{16{in[15]}},in};

endmodule

///////////////////////////////////////////////

module instruction_fetch_memory(PC,instruction);
input [31:0] PC;
output [31:0] instruction;
reg [7:0] mem [0:4095];//4 kb
assign instruction={mem[PC],mem[PC+1],mem[PC+2],mem[PC+3]};


initial begin
    $readmemh("Instruction_mem.txt",mem);
end

endmodule


////////////////////////////////////////////
module PC_add_4(PC_in,PC_out);
input wire [31:0] PC_in;
output  wire [31:0] PC_out;

assign PC_out = PC_in + 4;

endmodule

///////////////////////////////////////////
module PC_clked(clk,rst,pc_new,pc);
input clk,rst;
input [31:0] pc_new;
output reg [31:0] pc;
PC_add_4 ppp(pc,pc_new);

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        pc=0;
    end
    else begin
      pc<=pc_new;
    end
end
endmodule

////////////////////////////////////////////
module Data_mem(Address,write_data,ctrl_mem_read,ctrl_mem_write,read_data);
input [31:0]  Address,write_data;
input ctrl_mem_read,ctrl_mem_write,clk;
output reg [31:0]  read_data;
reg [7:0] data_mem[0:16383];// 16 kb

always @(ctrl_mem_read or ctrl_mem_write ) begin
    if (ctrl_mem_read) begin
        read_data<={data_mem[Address],data_mem[Address+1],data_mem[Address+2],data_mem[Address+3]};
    end
    else if (ctrl_mem_write) begin
        {data_mem[Address],data_mem[Address+1],data_mem[Address+2],data_mem[Address+3]}<=write_data;
    end
end

initial begin
    $readmemh("data_mem.txt",data_mem);
end

endmodule

///////////////////////////////////////////
module Control_Unit(opcode,Reg_dest,branch,mem_read,mem_to_register,ALU_op,mem_write,ALU_src,Reg_write);

output reg Reg_dest,Reg_write,mem_write,mem_read,mem_to_register,ALU_src,branch;
output reg [1:0] ALU_op;
input [5:0] opcode;
always @(*) begin
    case (opcode)
        6'b000000:begin    //R format
            Reg_dest=1;
            ALU_src=0;
            mem_to_register=0;
            Reg_write=1;
            mem_read=0;
            mem_write=0;
            branch=0;
            ALU_op=2'b10;         
        end
        6'b100011:begin     // lw 0x23     0010  0011
            Reg_dest=0;
            ALU_src=1;
            mem_to_register=1;
            Reg_write=1;
            mem_read=1;
            mem_write=0;
            branch=0;
            ALU_op=2'b00;         
        end
        6'b101011:begin   // sw 0x2B     0010 1011 
            Reg_dest=1'bx;
            ALU_src=1;
            mem_to_register=1'bx;
            Reg_write=0;
            mem_read=0;
            mem_write=1;
            branch=0;
            ALU_op=2'b00;         
        end
        6'b000100:begin  // beq  0x04 0000 0100
            Reg_dest=1'bx;
            ALU_src=0;
            mem_to_register=1'bx;
            Reg_write=0;
            mem_read=0;
            mem_write=0;
            branch=1;
            ALU_op=2'b01;         
        end
        default:begin
            Reg_dest=1'bx;
            ALU_src=1'bx;
            mem_to_register=1'bx;
            Reg_write=1'bx;
            mem_read=1'bx;
            mem_write=1'bx;
            branch=1'bx;
            ALU_op=2'bx;         
        end
    endcase
end

endmodule

//////////////////////////////////////////////
module ALU(ctrl_lines,input1,input2,out,z);
input wire [3:0] ctrl_lines;
input wire [31:0] input1,input2;
output reg [31:0] out;
output wire z;
assign z= (out ==0);

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

//////////////////////////////////////////////
module ALU_ctrl_unit(Alu_op,Alu_ctrl_lines,func);
input [1:0] Alu_op;
output reg [3:0] Alu_ctrl_lines;
input [5:0] func;
always @(*) begin
    case (Alu_op)
    2'b00:Alu_ctrl_lines=4'b0010;
    2'b01:Alu_ctrl_lines=4'b0110;
    2'b10:begin
      case (func)
      6'h20:  Alu_ctrl_lines=4'b0010      ;//add
      6'h22:  Alu_ctrl_lines=4'b0110      ;//sub
      6'h27:  Alu_ctrl_lines=4'b1100      ;//nor
      6'h24:  Alu_ctrl_lines=4'b0000      ;//and
      6'h25:  Alu_ctrl_lines=4'b0001      ;//or
      6'h00:  Alu_ctrl_lines=4'b0111      ;//shift left
      default:Alu_ctrl_lines=4'b1111        ;//add
        
      endcase
    end
    default:Alu_ctrl_lines=1111;
        
    endcase
end



endmodule