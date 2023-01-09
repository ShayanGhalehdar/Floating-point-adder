`timescale 1ns/1ns
module fp_adder(
  
  input  [31:0]a,
  input [31:0]b,
  output [31:0]s
  );
  
  wire hba , hbb;
  wire [25:0]fa,fb;
  wire [7:0]ea,eb;
  wire [8:0]ecompare;
  wire [7:0]edifference;
  wire [25:0]fa_shift,fb_shift;
  wire [23:0]sticky_vector,sticky_shift;
  wire [26:0]fa_grs,fb_grs;
  wire [28:0]fa2c,fb2c;
  wire [28:0]sum2c;
  wire [27:0]summag;
  wire sumsign;
  wire [7:0]exp,e;
  wire [4:0]first_one,first_one_only_normalized;
  wire [25:0]summag_normalized;
  wire [22:0]f;
  
    
  assign hba=|a[30:23];
  assign hbb=|b[30:23];
  assign fa={hba,a[22:0],2'b00};
  assign fb={hbb,b[22:0],2'b00};
  assign ea= hba ? a[30:23] : 8'b00000001;
  assign eb= hbb ? b[30:23] : 8'b00000001;
  assign ecompare= {1'b0,ea} + {1'b0,~eb} + 9'b000000001;
  assign edifference= ecompare[8] ? ecompare[7:0] : ~ecompare[7:0] + 1'b1;
  assign fa_shift= ecompare[8] ? fa : fa>>edifference;
  assign fb_shift= ecompare[8] ? fb>>edifference : fb;
  assign sticky_vector = ecompare[8] ? {|fb[25:0],|fb[24:0],|fb[23:0],|fb[22:0],
  |fb[21:0],|fb[20:0],|fb[19:0],|fb[18:0],|fb[17:0],|fb[16:0],|fb[15:0],
  |fb[14:0],|fb[13:0],|fb[12:0],|fb[11:0],|fb[10:0],|fb[9:0],|fb[8:0],
  |fb[7:0],|fb[6:0],|fb[5:0],|fb[4:0],|fb[3:0],|fb[2:0]}
  : {|fa[25:0],|fa[24:0],|fa[23:0],|fa[22:0],
  |fa[21:0],|fa[20:0],|fa[19:0],|fa[18:0],|fa[17:0],|fa[16:0],|fa[15:0],
  |fa[14:0],|fa[13:0],|fa[12:0],|fa[11:0],|fa[10:0],|fa[9:0],|fa[8:0],
  |fa[7:0],|fa[6:0],|fa[5:0],|fa[4:0],|fa[3:0],|fa[2:0]} ;
  assign sticky_shift= edifference>3 ? sticky_vector>>(edifference-3) : sticky_vector ;
  assign fa_grs = ecompare[8] ? {fa_shift,1'b0} : (edifference<=2 ? {fa_shift,1'b0} : {fa_shift,sticky_shift[0]});
  assign fb_grs = ecompare[8] ? (edifference<=2 ? {fb_shift,1'b0} : {fb_shift,sticky_shift[0]}) : {fb_shift,1'b0};
  assign fa2c = a[31] ? (fa_grs==0 ? {2'b00,fa_grs} : {2'b11,~fa_grs+1'b1}) : {2'b00,fa_grs};
  assign fb2c = b[31] ? (fb_grs==0 ? {2'b00,fb_grs} : {2'b11,~fb_grs+1'b1}) : {2'b00,fb_grs};
  assign sum2c = fa2c + fb2c;
  assign summag = sum2c[28] ? ~(sum2c[27:0]-1'b1) : sum2c[27:0];
  assign sumsign = sum2c[28];
  assign exp = ecompare[8] ? ea : eb;

  assign first_one_only_normalized = summag[27] ? 27 : summag[26] ? 26 :
  summag[25] ? 25 : summag[24] ? 24 : summag[23] ? 23 : summag[22] ? 22 :
  summag[21] ? 21 : summag[20] ? 20 : summag[19] ? 19 : summag[18] ? 18 :
  summag[17] ? 17 : summag[16] ? 16 : summag[15] ? 15 : summag[14] ? 14 :
  summag[13] ? 13 : summag[12] ? 12 : summag[11] ? 11 : summag[10] ? 10 :
  summag[9] ? 9 : summag[8] ? 8 : summag[7] ? 7 : summag[6] ? 6 :
  summag[5] ? 5 : summag[4] ? 4 : summag[3] ? 3 : summag[2] ? 2 :
  summag[1] ? 1 : summag[0] ? 0 : 0 ;
  
  assign first_one = (2+exp)>(28-first_one_only_normalized) ? first_one_only_normalized : (27-exp) ;
  
  assign e = ((a[30:0]==b[30:0])&&(a[31]!=b[31])) ? 0 :
  (2+exp)<=(28-first_one_only_normalized) ? 0 :(first_one==27 ? exp+1 : first_one==26 ? exp :
  first_one==25 ? exp-1 : first_one==24 ? exp-2 : first_one==23 ? exp-3 :
  first_one==22 ? exp-4 : first_one==21 ? exp-5 : first_one==20 ? exp-6 :
  first_one==19 ? exp-7 : first_one==18 ? exp-8 : first_one==17 ? exp-9 :
  first_one==16 ? exp-10 : first_one==15 ? exp-11 : first_one==14 ? exp-12 :
  first_one==13 ? exp-13 : first_one==12 ? exp-14 : first_one==11 ? exp-15 :
  first_one==10 ? exp-16 : first_one==9 ? exp-17 : first_one==8 ? exp-18 :
  first_one==7 ? exp-19 : first_one==6 ? exp-20 : first_one==5 ? exp-21 :
  first_one==4 ? exp-22 : first_one==3 ? exp-23 : first_one==2 ? exp-24 :
  first_one==1 ? exp-25 : first_one==0 ? exp-26 : 0) ;
  
  assign summag_normalized = first_one==27 ? (summag>>1) : first_one==26 ? (summag) :
  first_one==25 ? (summag<<1) : first_one==24 ? (summag<<2) : first_one==23 ? (summag<<3) :
  first_one==22 ? (summag<<4) : first_one==21 ? (summag<<5) : first_one==20 ? (summag<<6) :
  first_one==19 ? (summag<<7) : first_one==18 ? (summag<<8) : first_one==17 ? (summag<<9) :
  first_one==16 ? (summag<<10) : first_one==15 ? (summag<<11) : first_one==14 ? (summag<<12) :
  first_one==13 ? (summag<<13) : first_one==12 ? (summag<<14) : first_one==11 ? (summag<<15) :
  first_one==10 ? (summag<<16) : first_one==9 ? (summag<<17) : first_one==8 ? (summag<<18) :
  first_one==7 ? (summag<<19) : first_one==6 ? (summag<<20) : first_one==5 ? (summag<<21) :
  first_one==4 ? (summag<<22) : first_one==3 ? (summag<<23) : first_one==2 ? (summag<<24) :
  first_one==1 ? (summag<<25) : first_one==0 ? (summag<<27) : 0 ;
  
  assign f = first_one==27 ? (summag_normalized[2]==0 ? summag_normalized[25:3] :
  (summag_normalized[1] ? summag_normalized[25:3]+1'b1 :
  (summag_normalized[0] ? summag_normalized[25:3]+1'b1 :
  (summag[0] ? summag_normalized[25:3]+1'b1 :
  (summag_normalized[3] ? summag_normalized[25:3]+1'b1 : summag_normalized[25:3]))))) :
  (summag_normalized[2]==0 ? summag_normalized[25:3] :
  (summag_normalized[1] ? summag_normalized[25:3]+1'b1 :
  (summag_normalized[0] ? summag_normalized[25:3]+1'b1 :
  (summag_normalized[3] ? summag_normalized[25:3]+1'b1 : summag_normalized[25:3]))));
  
  assign s={sumsign,e,f};
  
endmodule