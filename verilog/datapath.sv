module datapath(input clk,input [7:0]INBUS,input [20:0]stare,output reg [7:0]OUTBUS,output [1:0]sel_out,output cnt1_7_out,cnt2_0_out, M7, output [0:-1]q_out, output [2:0]a_out);
reg [8:0]A;
reg [7:-1]Q;
reg [7:0]M;
reg [7:0]Q2;
reg [1:0]SEL;
reg [3:0]CNT1;
reg [2:0]CNT2;
assign sel_out=SEL;
assign q_out=Q[0:-1];
assign cnt1_7_out=CNT1[3];
assign cnt2_0_out=~(CNT2[0] | CNT2[1] | CNT2[2]);
assign a_out=A[8:6];
assign M7=M[7];

always @(posedge clk)
begin
	if(stare[0]==1)
	begin
		A<=0;
		CNT1<=0;
		Q[7:0]<=INBUS[7:0];
		Q[-1]<=0;
		Q2<=0;
		CNT2<=0;
	end
	
	else if(stare[1]==1)
	begin
		M<=INBUS[7:0];
	end
	
	else if(stare[2]==1)
	begin
		SEL<=INBUS[1:0];
	end

	else if(stare[3]==1)
	begin
		Q[7:0]<=Q[7:0]+M; //sum
	end


	else if(stare[4]==1)
	begin
		Q[7:0]<=Q[7:0]-M; //sum
	end


	else if(stare[5]==1)
	begin
		A[7:0]<=A[7:0]+M; //sum
	end


	else if(stare[6]==1)
	begin
		A[7:0]<=A[7:0]-M; //sum
	end


	else if(stare[7]==1)
	begin
		A[7]<=A[7];
		{A[6:0],Q}<={A[7:0],Q[7:0]};
		CNT1<=CNT1+4'd1;
	end


	else if(stare[8]==1)
	begin
		{A[8:0],Q[7:0],M[7:1]}<={A[7:0],Q[7:0],M[7:0]};
		M[0]<=0;
		CNT2<=CNT2+3'd1;
	end


	else if(stare[9]==1)
	begin
		{A[8:0],Q[7:1]}<={A[7:0],Q[7:0]};
		Q2[7:1]<=Q2[6:0];
		Q[0]<=1;
		Q2[0]<=0;
	end

	else if(stare[10]==1)
	begin
		A<=A-M; //sum
	end

	else if(stare[11]==1)
	begin
		{A[8:0],Q[7:1]}<={A[7:0],Q[7:0]};
		Q2[7:1]<=Q2[6:0];
		Q[0]<=0;
		Q2[0]<=1;
	end
	
	else if(stare[12]==1)
	begin
		A<=A+M; //sum
	end

	
	else if(stare[13]==1)
	begin
		{A[8:0],Q[7:1]}<={A[7:0],Q[7:0]};
		Q2[7:1]<=Q2[6:0];
		Q[0]<=0;
		Q2[0]<=0;
	end
	
	
	else if(stare[14]==1)
	begin
		CNT1<=CNT1+3'd1;
	end

	else if(stare[15]==1)
	begin
		A<=A+M; //sum
		Q2<=Q2+8'd1;
	end

	else if(stare[16]==1 && cnt2_0_out == 0)
	begin
		A[7:0]<=A[8:1];
		A[8]<=0;
		CNT2<=CNT2-3'd1;
	end

	else if(stare[17]==1)
	begin
		Q[7:0]<=Q[7:0]-Q2;
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
	


endmodule 