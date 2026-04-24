module tb_impartire();

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
        $monitor("Timp=%0t | FSM=%b | SEL=%b | M=%d | Q=%d | A=%d | OUTBUS=%d", 
                 $time, uut.w_stare, uut.uut2.SEL, uut.uut2.M, uut.uut2.Q[7:0], uut.uut2.A, OUTBUS);

        // initializare
        clk = 0; 
        rst = 0;
        INBUS = 8'd0;
        
        repeat(3) @(negedge clk);

        // ==================================================
        // TESTUL: IMPARTIRE (SEL = 11)
        // Operatie: 200 / 3. Asteptam Catul = 66 (in Q) si Restul = 2 (in A).
        // ==================================================
        $display("\n--- INCEPE TESTUL DE IMPARTIRE: 200 / 3 ---");
        
        // scoatem resetul. FSM-ul intra in S0
        rst = 1; 
        
        // FSM e in S0 -> incarcam deimpartitul in Q
        INBUS = 8'd200;                 
        
        // asteptam un ceas. FSM trece in S1 -> incarcam impartitorul in M
        @(negedge clk); 
        INBUS = 8'd3;  
        
        // asteptam un ceas. FSM trece in S2 -> incarcam comanda SEL = 11 (IMPARTIRE)
        @(negedge clk); 
        INBUS = 8'd3;  
        
        // asteptam starea finala S20.
        wait(uut.w_stare[20] == 1'b1);
        
       // mai lasam un ticait ca sa ajunga valoarea fizic din Q in OUTBUS
        @(negedge clk);
        @(negedge clk);
        
        $display("-------------------------------------------------");
        $display("--- REZULTAT FINAL IMPARTIRE ---");
        $display("CATUL (in Q) este : %d (Asteptam 66)", uut.uut2.Q[7:0]);
        $display("RESTUL (in A) este: %d (Asteptam 2)", uut.uut2.A);
        $display("-------------------------------------------------");

        $finish;
    end

endmodule