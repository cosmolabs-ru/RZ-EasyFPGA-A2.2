include <easyFPGA>;


module project(
  input wire S1, MASTER_CLK,
  output reg [3:0] led, 
  output wire [7:0] segs,
  output wire [1:0] cats_r,
  output wire [1:0] cats_l
);

reg [3:0]counter; 
reg [7:0] counter8;
reg[1:0] r_cats;
initial begin
	counter <= 4'b0001;
	counter8 <= 8'h00;
	r_cats <= 2'b11;
end

assign cats_r = r_cats[1:0];

wire clk20hz, clk2hz, clk5hz, clk1khz, S1_deb;
wire [7:0] di_L_in;
assign di_L_in = counter8[7:0];
clk_divider clk5(MASTER_CLK, 10000000, clk5hz);
clk_divider clk2(MASTER_CLK, 25000000, clk2hz);
clk_divider clk1k(MASTER_CLK, 50000, clk1khz);
clk_divider clk20(MASTER_CLK, 2500000, clk20hz);
debouncer deb_S1(clk20hz, S1, S1_deb);
dyn_indicator di(di_L_in[7:0], clk1khz, segs[7:0], cats_l[1:0]);

always @(*) begin
	led = ~counter[3:0];
end

always @(posedge clk5hz) begin
	if (counter8 == 8'hFF) begin
		counter8 <= 8'h00;
  end else begin
		counter8 <= counter8+1;
  end
end

always @(posedge S1_deb) begin
  if (counter == 4'b1111) begin
		counter <= 4'b0000;
  end else begin
		counter <= counter+1;
  end
end




endmodule 