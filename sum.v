//modul zwracajcy generacje i propagacje dwoch sygnalow
module gp (
input x, y, //sygnaly wejsciowe
output g, p // generacja i propagacja
);

assign g = x & y;
assign p = x ^ y;

endmodule

//modul komorki szarej
module gray (
input g, p, g_pop, //sygnaly wejsciowe
output o_g
);

assign o_g = g|(p & g_pop);

endmodule

//modul komorki czarnej
module black (
input g, p, g_pop, p_pop,
output o_g, o_p
);

assign o_g = g|(p & g_pop);
assign o_p = p & p_pop;

endmodule

//modul przedstawiajacy zerowy rzad (generacji i propagacji) sumatora typu sklansky
module sklansky_0 (
input wire [5:0]i_x,
input wire [5:0]i_y,
  output wire [5:0]o_g,
  output wire [5:0]o_p
);

gp gp_0(i_x[0], i_y[0], o_g[0], o_p[0]);
gp gp_1(i_x[1], i_y[1], o_g[1], o_p[1]);
gp gp_2(i_x[2], i_y[2], o_g[2], o_p[2]);
gp gp_3(i_x[3], i_y[3], o_g[3], o_p[3]);
gp gp_4(i_x[4], i_y[4], o_g[4], o_p[4]);
gp gp_5(i_x[5], i_y[5], o_g[5], o_p[5]);

endmodule

//modul przedstawiajacy pierwszy rzad (obliczajacy prefiksy dla grup 2 bitowych) sumatora typu sklansky
module sklansky_1 (
input wire [5:0]i_g,
input wire [5:0]i_p,
output wire [5:0]o_g,
output wire [3:0]o_p
);
assign o_p[0]=i_p[2];
assign o_p[2]=i_p[4];
assign o_g[0]=i_g[0];
assign o_g[2]=i_g[2];
assign o_g[4]=i_g[4];

gray gray_1(i_g[1], i_p[1], i_g[0], o_g[1]);
black black_3(i_g[3], i_p[3], i_g[2], i_p[2], o_g[3], o_p[1]);
black black_5(i_g[5], i_p[5], i_g[4], i_p[4], o_g[5], o_p[3]);

endmodule

//modul przedstawiajacy drugi rzad (obliczajacy prefiksy dla grup 4 bitowych) sumatora typu sklansky
module sklansky_2 (
input wire [5:0]i_g,
input wire [3:0]i_p,
output wire [5:0]o_g,
output wire [1:0]o_p
);
assign o_p[0]=i_p[2];
assign o_p[1]=i_p[3];
assign o_g[0]=i_g[0];
assign o_g[1]=i_g[1];
assign o_g[4]=i_g[4];
assign o_g[5]=i_g[5];

gray gray_2(i_g[2], i_p[0], i_g[1], o_g[2]);
gray gray_3(i_g[3], i_p[1], i_g[1], o_g[3]);

endmodule

//modul przedstawiajacy trzeci rzad (obliczajacy prefiksy dla grup 6 bitowych) sumatora typu sklansky
module sklansky_3 (
input wire [5:0]i_g,
input wire [1:0]i_p,
output wire [5:0]o_g
);
assign o_g[0]=i_g[0];
assign o_g[1]=i_g[1];
assign o_g[2]=i_g[2];
assign o_g[3]=i_g[3];

gray gray_4(i_g[4], i_p[0], i_g[3], o_g[4]);
gray gray_5(i_g[5], i_p[1], i_g[3], o_g[5]);

endmodule

//modul przedstawiajcy ostatni rzad (zliczajacy wynik) sumatora typu sklansky
module sklansky_4 (
input wire [5:0]i_g,
input wire [5:0]i_p,
output wire [5:0]o_s,
output wire o_carry
);
assign o_carry=i_g[5];
assign o_s[0]=i_p[0];
assign o_s[5:1]=i_p[5:1]^i_g[4:0];

endmodule

//modul skupiajacy caly sumator 6-bitowy typu sklansky
module sklansky_all (
input wire [5:0]i_x,
input wire [5:0]i_y,
output wire [5:0]o_s,
output wire o_carry
);

wire [5:0]g0; //generacja po wyjsciu z modulu sklansky_0
wire [5:0]p0; //propagacja po wyjsciu z modulu sklansky_0
wire [5:0]g1; //generacja po wyjsciu z modulu sklansky_1
wire [3:0]p1; //propagacja po wyjsciu z modulu sklansky_1
wire [5:0]g2; //generacja po wyjsciu z modulu sklansky_2
wire [1:0]p2; //propagacja po wyjsciu z modulu sklansky_2
wire [5:0]g3; //generacja po wyjsciu z modulu sklansky_3

sklansky_0 s0(i_x, i_y, g0, p0);
sklansky_1 s1(g0, p0, g1, p1);
sklansky_2 s2(g1, p1, g2, p2);
sklansky_3 s3(g2, p2, g3);
sklansky_4 s4(g3, p0, o_s, o_carry);

endmodule
