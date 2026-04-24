module tb_inmultire();

    reg clk;
    reg rst;
    reg [7:0] INBUS;
    wire [7:0] OUTBUS;

    // instantiem
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
        // TESTUL: INMULTIRE BOOTH (SEL = 10)
        // Operatie: Q = 100, M = 57. Asteptam sa scoata 5700 (A=22, Q=68).
        // ==================================================
        $display("\n--- INCEPE TESTUL BOOTH: 100 x 57 ---");
        
        // scoatem resetul. FSM-ul intra in S0
        rst = 1; 
        
        // FSM e in S0 -> incarcam multiplicatorul (Q) pe INBUS
        INBUS = 8'd100;                 
        
        // asteptam un ceas. FSM trece in S1 -> incarcam multiplicandul (M) pe INBUS
        @(negedge clk); 
        INBUS = 8'd57;  
        
        // asteptam un ceas. FSM trece in S2 -> incarcam comanda SEL = 10 (INMULTIRE)
        @(negedge clk); 
        INBUS = 8'd2;  
        
        // asteptam starea finala S20.
        wait(uut.w_stare[20] == 1'b1);
        
       // mai lasam un ticait ca sa ajunga valoarea fizic din Q in OUTBUS
        @(negedge clk);
        
        $display("-------------------------------------------------");
        $display("--- REZULTAT INMULTIRE: 22*256+68 ---");
        $display("-------------------------------------------------");

        $finish;
    end

endmodule