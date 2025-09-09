module wallace_bootn_mult(
    input wire [15:0] multiplicand, multiplier,
    output wire [31:0] op
);

 //****************Booths*********************//

    wire [15:0] M, MN;
    wire [16:0] M2, MN2;
    wire [16:0] Mt;
    
    assign M = multiplicand;
    assign MN = ~M + 1'b1;
    assign M2 = {M, 1'b0};    
    assign MN2 = {MN, 1'b0};  
    assign Mt = {multiplier, 1'b0}; 

    wire [31:0] PP0 ;
    wire [29:0] PP1 ;
    wire [27:0] PP2 ;
    wire [25:0] PP3 ;
    wire [23:0] PP4 ;
    wire [21:0] PP5 ;
    wire [19:0] PP6 ;
    wire [17:0] PP7 ;
             
              
   assign PP0 = (Mt[2:0] == 3'b000 || Mt[2:0] == 3'b111) ? 32'b0 :
             (Mt[2:0] == 3'b001 || Mt[2:0] == 3'b010) ? {{16{M[15]}}, M} :
             (Mt[2:0] == 3'b011) ? {{15{M2[16]}}, M2} :
             (Mt[2:0] == 3'b100) ? {{15{MN2[16]}},MN2} :
             {{16{MN[15]}}, MN};  // 3'b101 or 3'b110
   assign PP1 = (Mt[4:2] == 3'b000 || Mt[4:2] == 3'b111) ? 30'b0 :
             (Mt[4:2] == 3'b001 || Mt[4:2] == 3'b010) ? {{14{M[15]}}, M} :
             (Mt[4:2] == 3'b011) ? {{13{M2[16]}},M2} :
             (Mt[4:2] == 3'b100) ? {{13{MN2[16]}}, MN2} :
             {{14{MN[15]}}, MN};  // 3'b101 or 3'b110
    assign PP2 = (Mt[6:4] == 3'b000 || Mt[6:4] == 3'b111) ? 28'b0 :
             (Mt[6:4] == 3'b001 || Mt[6:4] == 3'b010) ? {{12{M[15]}}, M} :
             (Mt[6:4] == 3'b011) ? {{11{M2[16]}},M2} :
             (Mt[6:4] == 3'b100) ? {{11{MN2[16]}},MN2} :
             {{12{MN[15]}}, MN};  // 3'b101 or 3'b110          
    assign PP3 = (Mt[8:6] == 3'b000 || Mt[8:6] == 3'b111) ? 26'b0 :
             (Mt[8:6] == 3'b001 || Mt[8:6] == 3'b010) ? {{10{M[15]}}, M} :
             (Mt[8:6] == 3'b011) ? {{9{M2[16]}},M2} :
             (Mt[8:6] == 3'b100) ? {{9{MN2[16]}},MN2} :
             {{10{MN[15]}}, MN};  // 3'b101 or 3'b110  
    assign PP4 = (Mt[10:8] == 3'b000 || Mt[10:8] == 3'b111) ? 24'b0 :
             (Mt[10:8] == 3'b001 || Mt[10:8] == 3'b010) ? {{8{M[15]}}, M} :
             (Mt[10:8] == 3'b011) ? {{7{M2[16]}}, M2} :
             (Mt[10:8] == 3'b100) ? {{7{MN2[16]}}, MN2} :
             {{8{MN[15]}}, MN};  // 3'b101 or 3'b110  
    assign PP5 = (Mt[12:10] == 3'b000 || Mt[12:10] == 3'b111) ?22'b0 :
             (Mt[12:10] == 3'b001 || Mt[12:10] == 3'b010) ? {{6{M[15]}}, M} :
             (Mt[12:10] == 3'b011) ? {{5{M2[16]}},M2} :
             (Mt[12:10] == 3'b100) ? {{5{MN2[16]}},MN2} :
             {{6{MN[15]}}, MN};  // 3'b101 or 3'b110  
    assign PP6 = (Mt[14:12] == 3'b000 || Mt[14:12] == 3'b111) ? 20'b0 :
             (Mt[14:12] == 3'b001 || Mt[14:12] == 3'b010) ? {{4{M[15]}}, M} :
             (Mt[14:12] == 3'b011) ? {{3{M2[16]}},M2} :
             (Mt[14:12] == 3'b100) ? {{3{MN2[16]}}, MN2} :
             {{4{MN[15]}}, MN};  // 3'b101 or 3'b110     
    assign PP7 = (Mt[16:14] == 3'b000 || Mt[16:14] == 3'b111) ? 18'b0 :
             (Mt[16:14] == 3'b001 || Mt[16:14] == 3'b010) ? {{2{M[15]}}, M} :
             (Mt[16:14] == 3'b011) ? {{M2[16]}, M2} :
             (Mt[16:14] == 3'b100) ? {{MN2[16]},MN2} :
             {{2{MN[15]}}, MN};  // 3'b101 or 3'b110              
             
             
 //****************Wallace tree*********************// 
 //******Level_1*******//
  wire [29:0] Level1_sum;
  wire [29:0] Level1_carry;
      genvar A;
    generate
        for (A = 0; A < 2; A = A + 1) begin 
            half_adder HA (
                .A    (PP0[A+2]),
                .B    (PP1[A]),
                .Sum  (Level1_sum[A]),
                .Carry(Level1_carry[A])
            );
        end
    endgenerate
    generate
    for (A = 2; A < 30; A = A + 1) begin 
        full_adder FA (
            .A    (PP0[A+2]),   // 예시: 다른 인덱스
            .B    (PP1[A]),
            .Cin  (PP2[A-2]),
            .Sum  (Level1_sum[A]),
            .Cout (Level1_carry[A])
        );
    end
endgenerate


 //******Level_2*******//     
 wire [28:0] Level2_sum;
 wire [28:0] Level2_carry;                            
      genvar B;
    generate
        for (B = 0; B < 3; B = B + 1) begin 
            half_adder HA (
                .A    (Level1_sum[B+1]),
                .B    (Level1_carry[B]),
                .Sum  (Level2_sum[B]),
                .Carry(Level2_carry[B])
            );
        end
    endgenerate
    generate
    for (B = 3; B < 29; B = B + 1) begin 
        full_adder FA (
            .A    (Level1_sum[B+1]),   
            .B    (Level1_carry[B]),
            .Cin  (PP3[B-3]),
            .Sum  (Level2_sum[B]),
            .Cout (Level2_carry[B])
        );
    end
endgenerate
 //******Level_3*******//     
 wire [27:0] Level3_sum;
 wire [27:0] Level3_carry; 
 genvar C;
    generate
        for (C = 0; C < 4; C = C + 1) begin 
            half_adder HA (
                .A    (Level2_sum[C+1]),
                .B    (Level2_carry[C]),
                .Sum  (Level3_sum[C]),
                .Carry(Level3_carry[C])
            );
        end
    endgenerate
    generate
    for (C = 4; C < 28; C = C + 1) begin 
        full_adder FA (
            .A    (Level2_sum[C+1]),   
            .B    (Level2_carry[C]),
            .Cin  (PP4[C-4]),
            .Sum  (Level3_sum[C]),
            .Cout (Level3_carry[C])
        );
    end
endgenerate
//******Level_4*******//     
 wire [26:0] Level4_sum;
 wire [26:0] Level4_carry; 
 
     genvar D;
    generate
        for (D = 0; D < 5; D = D + 1) begin 
            half_adder HA (
                .A    (Level3_sum[D+1]),
                .B    (Level3_carry[D]),
                .Sum  (Level4_sum[D]),
                .Carry(Level4_carry[D])
            );
        end
    endgenerate
    generate
    for (D = 5; D < 27; D = D + 1) begin 
        full_adder FA (
            .A    (Level3_sum[D+1]),   
            .B    (Level3_carry[D]),
            .Cin  (PP5[D-5]),
            .Sum  (Level4_sum[D]),
            .Cout (Level4_carry[D])
        );
    end
endgenerate
//******Level_5*******//     
 wire [25:0] Level5_sum;
 wire [25:0] Level5_carry; 

     genvar E;
    generate
        for (E = 0; E < 6; E = E + 1) begin 
            half_adder HA (
                .A    (Level4_sum[E+1]),
                .B    (Level4_carry[E]),
                .Sum  (Level5_sum[E]),
                .Carry(Level5_carry[E])
            );
        end
    endgenerate
    generate
    for (E = 6; E < 26; E = E + 1) begin 
        full_adder FA (
            .A    (Level4_sum[E+1]),   
            .B    (Level4_carry[E]),
            .Cin  (PP6[E-6]),
            .Sum  (Level5_sum[E]),
            .Cout (Level5_carry[E])
        );
    end
endgenerate
//******Level_6*******//     

 wire [24:0] Level6_sum;
 wire [24:0] Level6_carry; 

     genvar F;
    generate
        for (F = 0; F < 7; F = F + 1) begin 
            half_adder HA (
                .A    (Level5_sum[F+1]),
                .B    (Level5_carry[F]),
                .Sum  (Level6_sum[F]),
                .Carry(Level6_carry[F])
            );
        end
    endgenerate
    generate
    for (F = 7; F < 25; F = F + 1) begin 
        full_adder FA (
            .A    (Level5_sum[F+1]),   
            .B    (Level5_carry[F]),
            .Cin  (PP7[F-7]),
            .Sum  (Level6_sum[F]),
            .Cout (Level6_carry[F])
        );
    end
endgenerate

//**********Final Carry-Save Adder Stage**********
 wire [23:0] Final_sum;
 wire [23:0] Final_carry; 
 
    half_adder HA1 (
     .A    (Level6_sum[1]),   
     .B    (Level6_carry[0]),
     .Sum  (Final_sum[0]),
     .Carry(Final_carry[0])
 );
     genvar G;
    generate
        for (G = 1; G < 24; G = G + 1) begin 
        full_adder FA (
            .A    (Level6_sum[G+1]),   
            .B    (Level6_carry[G]),
            .Cin  (Final_carry[G-1]),
            .Sum  (Final_sum[G]),
            .Cout (Final_carry[G])
            );
        end
    endgenerate








    assign op = {Final_sum ,Level6_sum[0],Level5_sum[0],Level4_sum[0],Level3_sum[0],Level2_sum[0],Level1_sum[0],PP0[1:0]};

endmodule
