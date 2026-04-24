module fsm_one_hot_20 (
    input  wire clk,
    input  wire rst_n,       // Reset activ în zero (negedge)
    input  wire CNT7,
  	input  wire CNT0,
  input  wire [1:0]SEL,
  input  wire [2:0]X1,
  input  wire [1:0]X2,
  input  wire M7,
  output reg  [20:0]stare
);

    // =========================================================================
    // 1. Definirea stărilor (Codificare One-Hot: un singur bit este '1' pe rând)
    // =========================================================================
  localparam [20:0]
        S0  = 21'h000001,
        S1  = 21'h000002,
        S2  = 21'h000004,
        S3  = 21'h000008,
        S4  = 21'h000010,
        S5  = 21'h000020,
        S6  = 21'h000040,
        S7  = 21'h000080,
        S8  = 21'h000100,
        S9  = 21'h000200,
        S10 = 21'h000400,
        S11 = 21'h000800,
        S12 = 21'h001000,
        S13 = 21'h002000,
        S14 = 21'h004000,
        S15 = 21'h008000,
        S16 = 21'h010000,
        S17 = 21'h020000,
        S18 = 21'h040000,
        S19 = 21'h080000,
		  S20 = 21'h100000;

    // Registre pentru starea curentă și starea următoare
  reg [20:0] current_state, next_state;

    // =========================================================================
    // 2. Blocul Secvențial: Actualizarea stării la fiecare front de ceas
    // =========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= S0; // Starea inițială sigură la reset
        end else begin
            current_state <= next_state;
        end
    end

    // =========================================================================
    // 3. Blocul Combinațional: Logica de tranziție (Starea următoare)
    // =========================================================================
    always @(*) begin
        // Valoare implicită pentru a evita inferarea de latch-uri
        next_state = current_state;

        case (current_state)
            S0:  next_state = S1;
            S1:  next_state = S2;  
            S2:
            begin
                if(SEL == 2'b00) next_state = S3;
                if(SEL == 2'b01) next_state = S4;
                if(SEL == 2'b10)
					if(CNT7) next_state = S18;
                    else if(X2 == 2'b01) next_state = S5;
                    else if(X2 == 2'b10) next_state = S6;
                    else if(!CNT7) next_state = S7;
                    else next_state = S18;
                if(SEL == 2'b11) 
                begin
                    if(!M7) next_state = S8;
                    else if(CNT7)
                    begin
                        if(X1[2]) next_state = S15;
                        else if(!CNT0) next_state = S16;
                        else next_state = S17;
                    end
                    else if(X1 == 3'b001 || X1 == 3'b010 || X1 == 3'b011) next_state = S9; 
                    else if(X1 == 3'b100 || X1 == 3'b101 || X1 == 3'b110) next_state = S11;
                    else next_state = S13;
                end
            end
            S3:  next_state = S18;
            S4:  next_state = S18;
            S5:
            begin
                if(!CNT7) next_state = S7;
				else next_state = S18;
            end
            S6:
            begin
                if(!CNT7) next_state = S7;
				else next_state = S18;
            end
            S7:  next_state = S2;
            S8:  next_state = S2;
            S9:  next_state = S10;
            S10:
            begin
                if(!CNT7) next_state = S14;
                else if(X1[2]) next_state = S15;
                else if(!CNT0) next_state = S16;
                else next_state = S17;
            end
            S11: next_state = S12;
            S12: 
            begin
                if(!CNT7) next_state = S14;
                else if(X1[2]) next_state = S15;
                else if(!CNT0) next_state = S16;
                else next_state = S17;
            end
            S13: 
            begin
                if(!CNT7) next_state = S14;
                else if(X1[2]) next_state = S15;
                else if(!CNT0) next_state = S16;
                else next_state = S17;
            end
            S14: next_state = S2;
            S15: 
            begin
                if(!CNT0) next_state = S16;
                else next_state = S17;
            end
            S16: 
            begin
                if(!CNT0) next_state = S16;
                else next_state = S17;
            end
            S17: next_state = S18;
            S18: next_state = S19;
            S19: next_state = S20; 
            S20: next_state = S0;

            // GOOD PRACTICE: Pentru One-Hot, `default` te salvează dacă FSM-ul 
            // ajunge accidental într-o stare invalidă (ex: din cauza unor glitch-uri).
            default: next_state = S0;
        endcase
    end

    // =========================================================================
    // 4. Logica de Ieșire (Exemplu: FSM de tip Moore)
    // =========================================================================
    assign stare=current_state;

endmodule