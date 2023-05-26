`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: nidhinchandran
// 
// Create Date: 23.04.2023 15:10:12
// Design Name: 
// Module Name: mips_tb_1
// Project Name:mips32 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created (21.4.23)
//             2 - Included branching operations and perfomance improvements(27.4.23)
//
//
//
//
// Additional Comments:
// ™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™™
//////////////////////////////////////////////////////////////////////////////////


module mips_tb_1();
    
    reg clk1,clk2;                                       // 
    integer k;
    
    mips32 inst (.clk1(clk1),.clk2(clk2));              // portmaping processor to testbench
    
    initial
        begin
            clk1 = 0;                                    //generating two-phase clock
            clk2 = 0;                                    // of duty cycle 25%
            repeat (20)                                  //  clk1  _/¯\_____/¯\____
                begin                                    //  clk2  _____/¯\______/¯\_
                    #5 clk1 = 1;                         //                         
                    #5 clk1 = 0;
                    #5 clk2 = 1;
                    #5 clk2 = 0;                    
                end
        end
    
    initial
    begin
    $monitor("%g alu out = %h",$time,mips32.EX_MEM_ALUout);
    $monitor("%g program counter = %h",$time,mips32.PC);
    $monitor("%g program TYPE = %h",$time,mips32.ID_EX_type);
    $monitor("%g program TYPE = %h",$time,mips32.EX_MEM_type);   
    $monitor("%g reg B = %h",$time,mips32.ID_EX_B);
    $monitor("%g reg A = %h",$time,mips32.ID_EX_A);
    $monitor("%g imm data = %h",$time,mips32.ID_EX_Imm);
    $monitor("%g alu out2 = %h",$time,mips32.MEM_WB_ALUout);
    $monitor("%g reg loc = %h",$time,mips32.MEM_WB_IR[25:21]);
    $monitor("%g ir1 = %h",$time,mips32.IF_ID_IR);
    $monitor("%g ir2 = %h",$time,mips32.ID_EX_IR);
    $monitor("%g ir3 = %h",$time,mips32.EX_MEM_IR);
    $monitor("%g ir4 = %h",$time,mips32.MEM_WB_IR);
    
    end
    
    initial
        begin                                            // assigning values to R registers
            for(k = 0; k < 31; k = k+1)                  // rn -> n
                mips32.Reg[k] = k; 
            

//--------------------* program *------------------------------------------------------------------
            
            mips32.Mem[0] = 32'h4820000a;           // ADI R1 R0 10
            mips32.Mem[1] = 32'h48400014;           // ADI R2 R0 20
            mips32.Mem[2] = 32'h48600019;           // ADI R3 R0 25
            mips32.Mem[3] = 32'h0ce73800;           // OR  R7 R7 R7  --dummy code to avoid hazard
            mips32.Mem[4] = 32'h00222000;           // ADD R1 R2 R4
            mips32.Mem[5] = 32'h0ce73800;           // OR  R7 R7 R7  --dummy code to avoid hazard
            mips32.Mem[6] = 32'h0ce73800;           // OR  R7 R7 R7  --dummy code to avoid hazard
            mips32.Mem[7] = 32'h00832800;           // ADD R4 R3 R5
            mips32.Mem[8] = 32'hfc000000;           // HLT
            
//-------------------------------------------------------------------------------------------------            
            mips32.HALTED = 0;                           //setting halt register 0
            mips32.PC = 0;                               //setting program pointer to 0 
            #300;
            for(k = 0; k < 31; k = k+1)                        
                $display ("R%1d -> %2d",k,mips32.Reg[k]);       // printing the values of R registers
            
            #50;
            $finish;                                            //stoping the simulation
        end
    
endmodule
