module traffic_light_fsm(
	input logic clk,
	input logic reset,
	input logic TAORB,
	output logic [2:0] LA, // 2-red, 1-yellow, 0-green
	output logic [2:0] LB //2-red, 1-yellow, 0-green
);

	typedef enum logic [1:0] {S0,S1,S2,S3} state_t;
	state_t current_state, next_state;
	
	//timer defs
	logic [2:0] timer;
	logic timer_reset;
	logic timer_en;
	
	always_ff @(posedge clk or posedge reset) begin
		if(reset) begin
			timer <= 3'd0;
		end else if (timer_reset) begin
			timer <= 3'd0;
		end else if (timer_en) begin
			timer <= timer + 3'd1;
		end
	end
	
	always_ff @(posedge clk or posedge reset) begin
		if (reset) begin
			current_state <= S0;
		end else begin
			current_state <= next_state;
		end
	end
	
	always_comb begin
		next_state=current_state;
		timer_reset= 1'b0;
		timer_en= 1'b0;
		
		case (current_state)
			S0: begin
				if (~TAORB) begin
					next_state= S1;
					timer_reset = 1'b1;
				end
			end
			
			S1: begin
				timer_en = 1'b1;
				if (timer >= 3'd5) begin
					next_state = S2;
				end
			end
			
			S2: begin
				if (TAORB) begin
               next_state = S3;
               timer_reset = 1'b1; 
            end
			end
			
			S3: begin
				timer_en= 1'b1;
				if (timer >= 3'd5) begin
					next_state=S0;
				end
			end	
			
			default: next_state = S0;
		endcase
	end
	
	always_comb begin
		LA=3'b100;
		LB=3'b100;
		
		case (current_state)
			S0: begin
				LA = 3'b001; 
            LB = 3'b100; 
         end
         S1: begin
            LA = 3'b010;
            LB = 3'b100; 
         end
         S2: begin
            LA = 3'b100; 
            LB = 3'b001; 
         end
         S3: begin
            LA = 3'b100;
            LB = 3'b010; 
         end
     endcase
   end
endmodule