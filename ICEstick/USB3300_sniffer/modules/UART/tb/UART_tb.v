/*
 *
 * Test bench for the UART module
 * Execute "make gtk" to view the results
 * 
 */

`default_nettype none
`timescale 100ns/10ns

module UART_tb ();

    /// Regs and wires
    wire clk_Tx;
    wire Tx;
    wire TiP;
    wire NrD;
    wire [7:0]DATA_out;

    reg rst = 1'b1;
    reg Rx  = 1'b0;
    reg [7:0]DATA_in = 8'b0;
    reg send_data = 1'b0;
    /// End of Regs and wires

    /// Module under test init
    UART     #(.BAUDS(104))
    UART_mut  (
               .rst(rst),
               .clk(clk),
               .Rx(Rx),
               .Tx(Tx),
               .I_DATA(DATA_in),
               .O_DATA(DATA_out),
               .send_data(send_data),
               .TiP(TiP),
               .NrD(NrD)
              );
    /// End of Module under test init

    /// Clock gen
    reg clk = 1'b0;
    always #0.5 clk = ~clk;
    /// End of Clock gen

    /// Simulation
    initial begin
        $dumpfile("./sim/UART_tb.vcd");
        $dumpvars();
        Rx  = 1'b1;

        #1 send_data = 1;
        #1 send_data = 0;
        #104 Rx = 0; // START
        #104 Rx = 1; // Bit 0
        #104 Rx = 1; // Bit 1
        #104 Rx = 1; // Bit 2
        #104 Rx = 1; // Bit 3
        #104 Rx = 1; // Bit 4
        #104 Rx = 1; // Bit 5
        #104 Rx = 1; // Bit 6
        #104 Rx = 1; // Bit 7
        #104 Rx = 1; // STOP
        #104

        #1 send_data = 1; DATA_in = 8'hAA;
        #1 send_data = 0;
        #104 Rx = 0; // START
        #104 Rx = 1; // Bit 0
        #104 Rx = 0; // Bit 1
        #104 Rx = 0; // Bit 2
        #104 Rx = 1; // Bit 3
        #104 Rx = 0; // Bit 4
        #104 Rx = 1; // Bit 5
        #104 Rx = 1; // Bit 6
        #104 Rx = 0; // Bit 7
        #104 Rx = 1; // STOP
        #104

        #1 send_data = 1; DATA_in = 8'hAA;
        #1 send_data = 0;
        #104 Rx = 0; // START
        #104 Rx = 1; // Bit 0
        #104 Rx = 0; // Bit 1
        #104 Rx = 0; // Bit 2
        #104 Rx = 1; // Bit 3
        rst = 0;
        #104 Rx = 0; // Bit 4
        #104 Rx = 1; // Bit 5
        #104 Rx = 1; // Bit 6
        #104 Rx = 0; // Bit 7
        #104 Rx = 1; // STOP
        #104
        rst = 1;
        #200

        #1 $finish;
    end
    /// End of Simulation

endmodule