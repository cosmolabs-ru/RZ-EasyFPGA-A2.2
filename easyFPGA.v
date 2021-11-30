module hex_decoder(input wire[3:0] nibble, input wire oe, output wire[7:0] o);
reg[7:0] segments;
assign o = segments[7:0];
	always @(*) begin
		if (!oe) begin
			segments <= ~8'b0;
		end else begin
			case (nibble)
				4'd0: 		segments <= ~8'b00111111;
				4'd1:			segments <= ~8'b00000110;
				4'd2:			segments <= ~8'b01011011;
				4'd3:			segments <= ~8'b01001111;
				4'd4:			segments <= ~8'b01100110;
				4'd5:			segments <= ~8'b01101101;
				4'd6:			segments <= ~8'b01111101;
				4'd7:			segments <= ~8'b00000111;
				4'd8:			segments <= ~8'b01111111;
				4'd9:			segments <= ~8'b01101111;
				4'd10:			segments <= ~8'b01110111;
				4'd11:			segments <= ~8'b01111100;
				4'd12:			segments <= ~8'b01011000;
				4'd13:			segments <= ~8'b01011110;
				4'd14:			segments <= ~8'b01111001;
				4'd15:			segments <= ~8'b01110001;
				default: segments <= ~8'b0;
			endcase
		end
	end
endmodule

module dyn_indicator(input wire[7:0] num, input wire clk, output wire[7:0] seg, output wire[1:0] cathodes); 
	reg hi_nibble; 
	reg r_cats[1:0];
	initial begin
		r_cats[0] <= 1;
		r_cats[1] <= 1;
	end
	assign cathodes[1] = ~r_cats[1];
	assign cathodes[0] = ~r_cats[0];

	hex_decoder hd((~hi_nibble) ? (num[7:4]) : (num[3:0]), clk, seg[7:0]);

	always @(posedge clk) begin
		hi_nibble <= ~hi_nibble;
		r_cats[1] <= ~hi_nibble;
		r_cats[0] <= hi_nibble;
	end
endmodule

module dtrig(
	input wire D, C,
	output reg Q
);
always @(posedge C)
	Q <= D;
endmodule

module clk_divider(input wire clk_hf, input wire[31:0] prescaler, output reg slow_clk);
reg [31:0] clk_div;
always @(posedge clk_hf) begin
	if (clk_div < prescaler[31:0]) 
		clk_div <= clk_div+1;
	else begin
		clk_div <= 0;
	   slow_clk <= ~slow_clk;
	end
end
endmodule

module debouncer(input wire clk20hz, raw, output wire debounced);
	wire  q0, q1;
	dtrig dt1(raw, clk20hz, q0);
	dtrig dt2(q0, clk20hz, q1);
	assign debounced = q0 & ~q1;
endmodule
