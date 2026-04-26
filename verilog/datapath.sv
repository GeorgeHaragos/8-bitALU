module datapath(input clk,input [7:0]INBUS,input [21:0]stare,output reg [7:0]OUTBUS,output [1:0]sel_out,output cnt1_7_out,cnt2_0_out, M7, output [0:-1]q_out, output [2:0]a_out);

wire [8:0]A;

wire [7:-1]Q;
reg Q_minus_1;
assign Q[-1]=Q_minus_1;


wire [7:0]M;
wire [7:0]Q2;
reg [1:0]SEL;

assign sel_out=SEL;
assign q_out=Q[0:-1];
assign a_out=A[8:6];
assign M7=M[7];


//logica de la sumator
wire c4 = stare[4] | stare[6] | stare[10] | stare[17];
wire c5 = stare[3] | stare[4] | stare[17];
wire c12 = stare[21]; //decoamdata
wire c14 = stare[17]; //deocamdata

wire [8:0]w_sum;

wire [8:0] w_mux1st,w_mux2st;
mux mux1(.A(A),.B({1'b0,Q[7:0]}),.sel(c5),.X(w_mux1st));
mux mux2(.A(w_mux1st),.B(8'd1),.sel(c12),.X(w_mux2st));

wire [8:0] w_mux1dr;
mux mux3(.A({1'b0,M}),.B({1'b0,Q2}),.sel(c12|c14),.X(w_mux1dr));

rcas_9b sum(.X(w_mux2st),.Y(w_mux1dr),.Op(c4),.Z(w_sum),.Cout());

//logica de la contor
wire [3:0] CNT1_out;
wire [2:0] CNT2_out;

wire en_cnt1 = stare[7] | stare[14];
wire en_cnt2 = stare[8] | (stare[16] & (cnt2_0_out==0));

wire dir_cnt2 = ~stare[16]; //0 inseamnca ca scade

wire rst_contoare = ~stare[0]; //activ la 0

up_down_counter4b CNT1 (.clk(clk),.rst(rst_contoare),.M(1'b1),.en(en_cnt1),.Q(CNT1_out)); //cnt1 doar urca
up_down_counter3b CNT2 (.clk(clk),.rst(rst_contoare),.M(dir_cnt2),.en(en_cnt2),.Q(CNT2_out));
assign cnt1_7_out = CNT1_out[3];
assign cnt2_0_out = ~(CNT2_out[0] | CNT2_out[1] | CNT2_out[2]);

//logica shift+ registre
//A
wire A_shift_right = stare[7] | (stare[16] & ~cnt2_0_out);
wire A_shift_left  = stare[8] | stare[9] | stare[11] | stare[13];
wire A_shift = A_shift_right | A_shift_left;
    
wire [8:0] A_in = stare[0] ? 9'd0 : ((stare[5]|stare[6]|stare[10]|stare[12]|stare[15]) ? w_sum : A);
wire A_lser = stare[7] ? A[8] : 1'b0;
wire A_rser = Q[7];

// DIR = 1 inseamna Left Shift in modulul tau!
shift_register_9b reg_A(.A(A_in), .LD_SH(~A_shift), .DIR(A_shift_left),.LSER(A_lser), .RSER(A_rser), .clk(clk), .rst(1'b1), .Q(A));

//Q
wire Q_shift_right = stare[7];
wire Q_shift_left  = stare[8] | stare[9] | stare[11] | stare[13];
wire Q_shift = Q_shift_right | Q_shift_left;

wire [7:0] Q_in = stare[0] ? INBUS[7:0] : ((stare[3]|stare[4]|stare[17]) ? w_sum[7:0] : Q[7:0]);
wire Q_lser = A[0];
wire Q_rser = stare[8] ? M[7] : (stare[9] ? 1'b1 : 1'b0);

shift_register_8b reg_Q(.A(Q_in), .LD_SH(~Q_shift), .DIR(Q_shift_left),.LSER(Q_lser), .RSER(Q_rser), .clk(clk), .rst(1'b1), .Q(Q[7:0]));

//M
wire M_shift = stare[8];
wire [7:0] M_in = stare[1] ? INBUS : M;
    
shift_register_8b reg_M(.A(M_in), .LD_SH(~M_shift), .DIR(1'b1),.LSER(1'b0), .RSER(1'b0), .clk(clk), .rst(1'b1), .Q(M));

//Q2
wire Q2_shift = stare[9] | stare[11] | stare[13];
wire [7:0] Q2_in = stare[0] ? 8'd0 : (stare[21] ? w_sum[7:0] : Q2);
wire Q2_rser = stare[11] ? 1'b1 : 1'b0;

shift_register_8b reg_Q2(.A(Q2_in), .LD_SH(~Q2_shift), .DIR(1'b1),.LSER(1'b0), .RSER(Q2_rser), .clk(clk), .rst(1'b1), .Q(Q2));


always @(posedge clk)
begin
	if(stare[0]==1)
	begin
		Q_minus_1<=0;	
	end
	
	else if(stare[2]==1)
	begin
		SEL<=INBUS[1:0];
	end

	else if(stare[7]==1)//SHIFTAM DREAPTA AQ, A[7]=A[7], Q[7]=A[0]
	begin
		Q_minus_1<=Q[0];
	end

	else if(stare[18]==1)
	begin
		OUTBUS<=A[7:0];
	end
	
	else if(stare[19]==1)
	begin
		OUTBUS<=Q[7:0];
	end
	
end

endmodule

/* //codul scris efectiv dupa algoritm. cu ajutorul lui am reusit sa fac toate assignurile
always @(posedge clk)
begin
	if(stare[0]==1)//dam load A,Q,Q2
	begin
		//A<=0;
		//Q[7:0]<=INBUS[7:0];
		Q_minus_1<=0;
		//Q2<=0;
		
	end
	
	else if(stare[1]==1)//dam load M
	begin
		//M<=INBUS[7:0];
	end
	
	else if(stare[2]==1)//dam load SEL
	begin
		SEL<=INBUS[1:0];
	end

	else if(stare[3]==1)//dam load Q
	begin
		//Q[7:0]<=w_sum[7:0];
		////Q[7:0]<=Q[7:0]+M; //sum
	end


	else if(stare[4]==1)//dam load Q
	begin
		
		//Q[7:0]<=w_sum[7:0];
		////Q[7:0]<=Q[7:0]-M; //sum
	end


	else if(stare[5]==1)//dam load A
	begin
		
		//A<=w_sum;
		////A[7:0]<=A[7:0]+M; //sum
	end


	else if(stare[6]==1)//dam load A
	begin
		
		//A<=w_sum;
		////A[7:0]<=A[7:0]-M; //sum
	end


	else if(stare[7]==1)//SHIFTAM DREAPTA AQ, A[7]=A[7], Q[7]=A[0]
	begin
		//A[7]<=A[7];
		//{A[6:0],Q}<={A[7:0],Q[7:0]};
		Q_minus_1<=Q[0];
		//CNT1<=CNT1+4'd1;
	end


	else if(stare[8]==1)//SHIFTAM STANGA AQM, A[0]=Q[7],Q[0]=M[7], M[0]=0
	begin
		//{A[8:0],Q[7:0],M[7:1]}<={A[7:0],Q[7:0],M[7:0]};
		//M[0]<=0;
		//CNT2<=CNT2+3'd1;
	end


	else if(stare[9]==1)//SHIFTAM STANGA AQ, A[0]=Q[7], Q[0]=1  + SHIFTAM STANGA Q2, Q2[0]=0
	begin
		//{A[8:0],Q[7:1]}<={A[7:0],Q[7:0]};
		//Q2[7:1]<=Q2[6:0];
		//Q[0]<=1;
		//Q2[0]<=0;
	end

	else if(stare[10]==1)//dam load A
	begin
		
		//A<=w_sum;
		////A<=A-M; //sum
	end

	else if(stare[11]==1)//SHIFTAM STANGA AQ, A[0]=Q[7], Q[0]=0  + SHIFTAM STANGA Q2, Q2[0]=1
	begin
		//{A[8:0],Q[7:1]}<={A[7:0],Q[7:0]};
		//Q2[7:1]<=Q2[6:0];
		//Q[0]<=0;
		//Q2[0]<=1;
	end
	
	else if(stare[12]==1)//dam load A
	begin
		
		//A<=w_sum;
		////A<=A+M; //sum
	end

	
	else if(stare[13]==1)//SHIFTAM STANGA AQ, A[0]=Q[7], Q[0]=0  + SHIFTAM STANGA Q2, Q2[0]=0
	begin
		//{A[8:0],Q[7:1]}<={A[7:0],Q[7:0]};
		//Q2[7:1]<=Q2[6:0];
		//Q[0]<=0;
		//Q2[0]<=0;
	end
	
	
	else if(stare[14]==1)
	begin
		//CNT1<=CNT1+3'd1;
	end

	else if(stare[15]==1)//dam load A
	begin
		
		
		//A<=w_sum;
		////A<=A+M; //sum
		//Q2<=Q2+8'd1; l am mutat mai jos
	end
	
	else if(stare[21]==1) // nu pot sa folosesc modulul de sumator in aceeasi stare deci a mai trebuit sa adaug starea asta + dam load Q2
	begin
		//Q2<=w_sum[7:0];
		//Q2<=Q2+8'd1;
	end

	else if(stare[16]==1 && cnt2_0_out == 0) //SHIFTAM DREAPTA A, A[8]=0
	begin
		//A[7:0]<=A[8:1];
		//A[8]<=0;
		//CNT2<=CNT2-3'd1;
	end

	else if(stare[17]==1)//dam load Q
	begin
		//Q[7:0]<=w_sum[7:0];
		//Q[7:0]<=Q[7:0]-Q2;
	end
	
	else if(stare[18]==1)
	begin
		OUTBUS<=A[7:0];
	end
	
	else if(stare[19]==1)
	begin
		OUTBUS<=Q[7:0];
	end
	else if(stare[20]==1)
	begin
		//END
	end
	
	
end
	
*/
