module fsmachine(
					reset_n,
					clock, 
					direction, 
					clicked, 
					out_x, 
					out_y, 
					out_color
					);
	input reset_n, clock, clicked;
	input [2:0]direction; 
	output reg out_x;
	output reg out_y;
	output reg out_color;

	reg[2:0] current_state, next_state;
	
	localparam DRAW_UP = 4'b0000,
					DRAW_DOWN = 4'b0001,
					DRAW_RIGHT = 4'b0010,
					DRAW_LEFT = 4'b0011,
					CHANGE_UP = 4'b0100,
					CHANGE_DOWN = 4'b0101,
					CHANGE_RIGHT = 4'b0110,
					CHANGE_LEFT = 4'b0111,
					READY_CHANGE = 4'b1000,
					UPDATE_COLOR = 4'b1001;
//					PLOT = 3'b100;
	always @(posedge clock) 
	begin
		if (!reset_n) begin
			current_state <= DRAW_UP;
			end
		else begin
			current_state <= next_state;
		end 
	end
		
	always @(*)
		begin:state_table
		case(current_state)
			DRAW_UP: next_state = DRAW_DOWN;
			DRAW_DOWN: next_state = DRAW_LEFT;
			DRAW_LEFT: next_state = DRAW_RIGHT;
			DRAW_RIGHT: next_state = READY_CHANGE;
			READY_CHANGE: next_state = clicked? UPDATE_COLOR:READY_CHANGE;
			UPDATE_COLOR : begin
			if (direction == 2'b00)
				next_state = CHANGE_UP;
			else if (direction == 2'b01)
				next_state = CHANGE_DOWN;
			else if (direction == 2'b10)
				next_state = CHANGE_RIGHT;
			else if (direction == 2'b11)
				next_state = CHANGE_LEFT;
			end
			CHANGE_UP: next_state = clicked? CHANGE_UP:READY_CHANGE;
			CHANGE_DOWN: next_state = clicked? CHANGE_DOWN: READY_CHANGE;
			CHANGE_RIGHT: next_state = clicked? CHANGE_RIGHT: READY_CHANGE;
			CHANGE_LEFT: next_state = clicked? CHANGE_LEFT: READY_CHANGE;
			
		endcase 
		end 
			
	always @(*)
		begin
		out_color = 3'b111; 
		case(current_state)
			DRAW_UP: begin 
				out_x <= 8'b01001110;
				out_y <= 7'b0110110;
				out_color <= 3'b111;
				end 
			DRAW_DOWN: begin
				out_x <= 8'b01001110;
				out_y <= 7'b0111110; 
				out_color <= 3'b111;
				end
			DRAW_LEFT: begin
				out_x <= 8'b01001010;
				out_y <= 7'b0111010;
				out_color <= 3'b111;
				end
			DRAW_RIGHT: begin
				out_x <= 8'b01010010;
				out_y <= 7'b0111010;
				out_color <= 3'b111;
				end
			READY_CHANGE : begin
				out_x <= 8'b00000000;
				out_y <= 7'b0000000;
				out_color <= 3'b111;
				end
			UPDATE_COLOR:begin
				end
			CHANGE_DOWN: begin
				out_x <= 8'b01001110;
				out_y <= 7'b0111110;
				out_color <= 3'b010;
				end 
			CHANGE_UP: begin
				out_x <= 8'b01001110;
				out_y <= 7'b0110110;
				out_color <= 3'b010;
				end 
			CHANGE_LEFT: begin
				out_x <= 8'b01001010;
				out_y <= 7'b0111010;
				out_color <= 3'b010;
				end 
			CHANGE_RIGHT: begin
				out_x <= 8'b01010010;
				out_y <= 7'b0111010;
				out_color <= 3'b010;
				end 
		endcase 
		end 
endmodule 

//// Up
//x_choose <= 8'b01001110
//y_choose <= 7'b0110110
//
//// Right
//x_choose <= 8'b01010010
//y_choose <= 7'b0111010
//
//// Down
//x_choose <= 8'b01001110
//y_choose <= 7'b0111110
//
//// Left
//x_choose <= 8'b01001010
//y_choose <= 7'b0111010
