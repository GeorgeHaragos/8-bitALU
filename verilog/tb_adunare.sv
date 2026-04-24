module tb_adunare();

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

        
		  // INITIALIZARE
        clk = 0; 
        rst = 0;
        INBUS = 8'd0;
        
		  // asteptam 3 fronturi ca sa se stabilizeze semnalele
        repeat(3) @(negedge clk);

        // ==================================================
        // TESTUL: ADUNARE (SEL = 00)
        // Operatie: Q = 42, M = 15. Asteptam fix 57.
        // ==================================================
        $display("\n--- INCEPE TESTUL DE ADUNARE: 42 + 15 ---");
        
        // scoatem resetul. FSM-ul intra in S0
        rst = 1; 
        
        // FSM e in S0 -> incarcam Q = 42 pe INBUS
        INBUS = 8'd42;                 
        
        // asteptam un ceas. FSM trece in S1 -> incarcam M = 15 pe INBUS
        @(negedge clk); 
        INBUS = 8'd15;  
        
        // asteptam un ceas. FSM trece in S2 -> incarcam SEL = 00 (ADUNARE)
        @(negedge clk); 
        INBUS = 8'd0;  
         
        
        // asteptam starea finala S20.
        wait(uut.w_stare[20] == 1'b1);
        
        // mai lasam un ticait ca sa ajunga valoarea fizic din Q in OUTBUS
        @(negedge clk);
        
        $display("-------------------------------------------------");
        $display("--- REZULTAT ADUNARE: 57 ---");
        $display("-------------------------------------------------");
        
        $finish;
    end

endmodule
