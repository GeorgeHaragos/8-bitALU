module tb_scadere();

    reg clk;
    reg rst;
    reg [7:0] INBUS;
    wire [7:0] OUTBUS;

    // instatiem
    top uut (
        .clk(clk),
        .rst(rst),
        .INBUS(INBUS),
        .OUTBUS(OUTBUS)
    );

    // clockul
    initial begin
    clk=1'b0;
    forever #5 clk = ~clk;
    end
    
    initial begin
        // punem monitorul pe el sa vedem fiecare miscare
        $monitor("Timp=%0t | FSM=%b | SEL=%b | INBUS=%d | M=%d | Q=%d | A=%d | OUTBUS=%d", 
                 $time, uut.w_stare, uut.uut2.SEL, INBUS, uut.uut2.M, uut.uut2.Q[7:0], uut.uut2.A, OUTBUS);

        // initializare
        clk = 0; 
        rst = 0;
        INBUS = 8'd0;
        
        // asteptam 3 fronturi ca sa se stabilizeze semnalele
        repeat(3) @(negedge clk);

        // ==================================================
        // TESTUL: SCADERE (SEL = 01)
        // Operatie: Q = 50, M = 15. Asteptam fix 35.
        // ==================================================
        $display("\n--- INCEPE TESTUL DE SCADERE: 50 - 15 ---");
        
        // scoatem resetul. FSM-ul intra in S0
        rst = 1; 
        
        // FSM e in S0 -> incarcam Q = 50 pe INBUS
        INBUS = 8'd50;                 
        
        // asteptam un ceas. FSM trece in S1 -> incarcam M = 15 pe INBUS
        @(negedge clk); 
        INBUS = 8'd15;  
        
        // asteptam un ceas. FSM trece in S2 -> incarcam SEL = 01 (SCADERE)
        @(negedge clk); 
        INBUS = 8'd1;  
        
        // asteptam starea finala S20.
        wait(uut.w_stare[20] == 1'b1);
        
        // mai lasam un ticait ca sa ajunga valoarea fizic din Q in OUTBUS
        @(negedge clk);
        
        $display("-------------------------------------------------");
        $display("--- REZULTAT SCADERE: 35 ---");
        $display("-------------------------------------------------");
        
        $finish;
    end

endmodule