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
 *     Initial:        2018/07/12        Mario Rubio
 */

/*
 This module has the instructions set that let read data from the PHY registers

 States:
    1. READ_IDLE. This module is doing nothing until the READ_DATA input is activated.
    2. READ_TXCMD. Once the READ signal is asserted, the LINK has the ownership of the bus and send the TXCMD 8bit data ('11'cmd+{6bit Address}).
                   The PHY will respond activating the NXT signal indicating that TXCMD has been successfully latched.
    3. READ_WAIT. The PHY takes control over the ULPI bus (making the DIR input HIGH).
                  Because of that, we hace to wait 1 clk pulse for the "TURN AROUND" to finish.
    4. READ_SAVE_DATA. After that, we just need to read the value sent over the bus and wait for the PHY to return the ownership to the LINK (DIR goes back to a low value).

 */

module ULPI_REG_READ (
                      // System signals
                      input  wire clk, // Clock input signal
                      input  wire rst, // Master reset signal
                      // ULPI controller signals
                      input  wire READ_DATA, // Signal to initiate a register READ
                      input  wire [5:0]ADDR, // Input that transmit the 6 bit address where we want to READ the DATA
                      output wire [7:0]DATA, // Output 
                      output wire BUSY,      // Output signal activated whenever is a READ operationn in progress
                      // ULPI pins
                      input  wire DIR,
                      input  wire NXT,
                      inout  wire ULPI_DATA
                     );

    // CMD used to perform a register read 11xxxxxx
    parameter [1:0]REG_READ_CMD = 2'b11;

    /// ULPI_REG_READ Regs and wires
    // Outputs
    reg [7:0]DATA_r = 8'b0; assign DATA = DATA_r;

    // Inputs
    // #NONE

    // Buffers

    // Control registers
    reg [1:0]READ_state_r = 3'b0; // Register to store the current state of the ULPI_REG_READ module

    // Flags
    wire READ_s_IDLE;      // 1 if READ_state_r == READ_IDLE, else 0
    wire READ_s_TXCMD;     // 1 if READ_state_r == READ_TXCMD, else 0
    wire READ_s_WAIT;      // 1 if READ_state_r == READ_WAIT1, else 0
    wire READ_s_SAVE_DATA; // 1 if READ_state_r == READ_SAVE_DATA, else 0

    // Assigns
    assign READ_s_IDLE      = (READ_state_r == READ_IDLE)      ? 1'b1 : 1'b0; // #FLAG
    assign READ_s_TXCMD     = (READ_state_r == READ_TXCMD)     ? 1'b1 : 1'b0; // #FLAG
    assign READ_s_WAIT      = (READ_state_r == READ_WAIT)      ? 1'b1 : 1'b0; // #FLAG
    assign READ_s_SAVE_DATA = (READ_state_r == READ_SAVE_DATA) ? 1'b1 : 1'b0; // #FLAG
    assign DATA             = DATA_r;       // #OUTPUT
    assign BUSY             = !READ_s_IDLE; // #OUTPUT

    /// End of ULPI_REG_READ Regs and wires

    /// ULPI_REG_READ States (See module description at the beginning to get more info)
    localparam READ_IDLE      = 2'b00;
    localparam READ_TXCMD     = 2'b01;
    localparam READ_WAIT      = 2'b10;
    localparam READ_SAVE_DATA = 2'b11;
    /// End of ULPI_REG_READ States

    /// ULPI_REG_READ controller
    // States and actions
    // #FIGURE_NUMBER READ_state_machine
    always @(posedge clk) begin
        if(rst == 1'b1) begin
            READ_state_r <= READ_IDLE;
        end
        else begin
            case(READ_state_r)
                READ_IDLE: begin
                    if(READ_DATA == 1'b1) begin
                        // The READ process start whenever the READ_DATA signal is activated, otherwise, we do nothing
                        READ_state_r <= READ_TXCMD;
                    end
                    else begin
                        READ_state_r <= READ_IDLE;
                    end
                end
                READ_TXCMD: begin
                    if(NXT == 1'b1) begin
                        READ_state_r <= READ_WAIT;
                    end
                    else begin
                        READ_state_r <= READ_TXCMD;
                    end
                end
                READ_WAIT: begin
                    // We wait 1 clock pulse for the "Turn around" to occur
                    READ_state_r <= READ_SAVE_DATA;
                end
                READ_SAVE_DATA:
                    if(DIR == 1'b0) begin
                        // We wait until the PHY free the bus to go back to the IDLE state (DIR goes from HIGH to LOW)
                        READ_state_r <= READ_IDLE;
                    end
                    else begin
                        READ_state_r <= READ_SAVE_DATA;
                    end
                end
                default: begin
                    READ_state_r <= READ_IDLE;
                end
            endcase
        end
    end
    /// End of ULPI_REG_READ controller

endmodule