/*
 * MIT License
 *
 * Copyright (c) 2018 Mario Rubio
 *
 MIT License

Copyright (c) 2015-present, Facebook, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
 
 */

/*
 * Revision History:
 *     Initial:        2018/06/15        Mario Rubio
 */

/*
 * This module enables the communication between the FPGA and the USB3300 module using the ULPI protocol.
 * 
 * Submodules:
 *  - ULPI detect
 *  - 
 *
 */

`default_nettype none

`include "ULPI_REG_READ.v"
`include "ULPI_REG_WRITE.v"

module ULPI (
             // System signals
             input  wire clk, // Clock input signal
             input  wire rst, // Master reset signal
             // ULPI pins
             input  wire NXT,
             input  wire DIR,
             output wire STP,
             inout  wire [7:0]DATA
            );

    /// ULPI submodules load
    ULPI_REG_READ  UReg_R (clk, rst, , , , , DIR, NXT, );
    ULPI_REG_WRITE UReg_W (clk, rst, , , , ,);
    /// End of ULPI submodules load

    /// ULPI Regs and wires
    // Outputs

    // Inputs

    // Buffers

    // Control registers
    reg [2:0]ULPI_state_r = 3'b0;

    // Flags
    
    // Assigns

    /// End of ULPI Regs and wires


    /// ULPI States (See module description at the beginning to get more info)
    
    /// End of ULPI States


    /// ULPI controller
    
    /// End of ULPI controller

endmodule