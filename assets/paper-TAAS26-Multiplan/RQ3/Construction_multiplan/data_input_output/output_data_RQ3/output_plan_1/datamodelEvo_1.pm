dtmc
evolve int h1_maxRetry_t2_ip1 [1..2];
evolve int h1_maxRetry_t2_ip2 [1..2];
evolve int h1_maxRetry_t3_bza [1..1];
evolve int r1_maxRetry_t1_msa [1..4];
evolve int r2_maxRetry_t4_wcp1 [1..5];
evolve int r2_maxRetry_t1_msb [1..4];
evolve int r3_maxRetry_t4_se1 [1..5];
evolve int r3_maxRetry_t3_bzb [1..2];

const double p_h1_t2_ip1=0.97;
const double p_h1_t2_ip2=0.97;
const double p_h1_t3_bza=0.98;
const double p_r1_t1_msa=1;
const double p_r2_t4_wcp1=0.96;
const double p_r2_t1_msb=0.83;
const double p_r3_t4_se1=0.79;
const double p_r3_t3_bzb=0.85;
const int h1Final = 4;
const int h1Fail = 5;
const int r1Final = 2;
const int r1Fail = 3;
const int r2Final = 5;
const int r2Fail = 6;
const int r3Final = 3;
const int r3Fail = 4;

module _h1
  h1 : [0..6];
  h1retry_t2_ip1 : [0..h1_maxRetry_t2_ip1] init 0;
  h1retry_t2_ip2 : [0..h1_maxRetry_t2_ip2] init 0;
  h1retry_t3_bza : [0..h1_maxRetry_t3_bza] init 0;

  [h1dot2_ip1Retry] h1=0 & h1retry_t2_ip1 < h1_maxRetry_t2_ip1 -> p_h1_t2_ip1 : (h1'=h1+1) + (1-p_h1_t2_ip1) : (h1'=h1) & (h1retry_t2_ip1' = h1retry_t2_ip1+1);
  [h1dot2_ip1] h1=0 & h1retry_t2_ip1 >= h1_maxRetry_t2_ip1 -> 1:(h1'=h1Fail);
  [h1dot2_ip2Retry] h1=1 & h1retry_t2_ip2 < h1_maxRetry_t2_ip2 -> p_h1_t2_ip2 : (h1'=h1+1) + (1-p_h1_t2_ip2) : (h1'=h1) & (h1retry_t2_ip2' = h1retry_t2_ip2+1);
  [h1dot2_ip2] h1=1 & h1retry_t2_ip2 >= h1_maxRetry_t2_ip2 -> 1:(h1'=h1Fail);
  [h1movel4] h1=2-> 1:(h1'=2+1);
  [h1dot3_bzaRetry] h1=3 & h1retry_t3_bza < h1_maxRetry_t3_bza -> p_h1_t3_bza : (h1'=h1+1) + (1-p_h1_t3_bza) : (h1'=h1) & (h1retry_t3_bza' = h1retry_t3_bza+1);
  [h1dot3_bza] h1=3 & h1retry_t3_bza >= h1_maxRetry_t3_bza -> 1:(h1'=h1Fail);
endmodule

module _r1
  r1 : [0..4];
  r1retry_t1_msa : [0..r1_maxRetry_t1_msa] init 0;

  [r1movel6] r1=0-> 1:(r1'=0+1);
  [r1dot1_msaRetry] r1=1 & r1retry_t1_msa < r1_maxRetry_t1_msa -> p_r1_t1_msa : (r1'=r1+1) + (1-p_r1_t1_msa) : (r1'=r1) & (r1retry_t1_msa' = r1retry_t1_msa+1);
  [r1dot1_msa] r1=1 & r1retry_t1_msa >= r1_maxRetry_t1_msa -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..7];
  r2retry_t4_wcp1 : [0..r2_maxRetry_t4_wcp1] init 0;
  r2retry_t1_msb : [0..r2_maxRetry_t1_msb] init 0;

  [r2movel1] r2=0-> 1:(r2'=0+1);
  [r2movel9] r2=1-> 1:(r2'=1+1);
  [r2dot4_wcp1Retry] r2=2 & r2retry_t4_wcp1 < r2_maxRetry_t4_wcp1 -> p_r2_t4_wcp1 : (r2'=r2+1) + (1-p_r2_t4_wcp1) : (r2'=r2) & (r2retry_t4_wcp1' = r2retry_t4_wcp1+1);
  [r2dot4_wcp1] r2=2 & r2retry_t4_wcp1 >= r2_maxRetry_t4_wcp1 -> 1:(r2'=r2Fail);
  [r2movel7] r2=3-> 1:(r2'=3+1);
  [r2dot1_msbRetry] r2=4 & r2retry_t1_msb < r2_maxRetry_t1_msb -> p_r2_t1_msb : (r2'=r2+1) + (1-p_r2_t1_msb) : (r2'=r2) & (r2retry_t1_msb' = r2retry_t1_msb+1);
  [r2dot1_msb] r2=4 & r2retry_t1_msb >= r2_maxRetry_t1_msb -> 1:(r2'=r2Fail);
endmodule

module _r3
  r3 : [0..5];
  r3retry_t4_se1 : [0..r3_maxRetry_t4_se1] init 0;
  r3retry_t3_bzb : [0..r3_maxRetry_t3_bzb] init 0;

  [r3dot4_se1Retry] r3=0 & r3retry_t4_se1 < r3_maxRetry_t4_se1 -> p_r3_t4_se1 : (r3'=r3+1) + (1-p_r3_t4_se1) : (r3'=r3) & (r3retry_t4_se1' = r3retry_t4_se1+1);
  [r3dot4_se1] r3=0 & r3retry_t4_se1 >= r3_maxRetry_t4_se1 -> 1:(r3'=r3Fail);
  [r3movel5] r3=1-> 1:(r3'=1+1);
  [r3dot3_bzbRetry] r3=2 & r3retry_t3_bzb < r3_maxRetry_t3_bzb -> p_r3_t3_bzb : (r3'=r3+1) + (1-p_r3_t3_bzb) : (r3'=r3) & (r3retry_t3_bzb' = r3retry_t3_bzb+1);
  [r3dot3_bzb] r3=2 & r3retry_t3_bzb >= r3_maxRetry_t3_bzb -> 1:(r3'=r3Fail);
endmodule

rewards "cost"
  [h1dot2_ip1] true:8;
  [h1dot2_ip1Retry] true:8;
  [h1dot2_ip2] true:8;
  [h1dot2_ip2Retry] true:8;
  [h1movel4] true:1;
  [h1dot3_bza] true:10;
  [h1dot3_bzaRetry] true:10;
  [r1movel6] true:1;
  [r1dot1_msa] true:2;
  [r1dot1_msaRetry] true:2;
  [r2movel1] true:1;
  [r2movel9] true:1;
  [r2dot4_wcp1] true:1;
  [r2dot4_wcp1Retry] true:1;
  [r2movel7] true:1;
  [r2dot1_msb] true:3;
  [r2dot1_msbRetry] true:3;
  [r3dot4_se1] true:2;
  [r3dot4_se1Retry] true:2;
  [r3movel5] true:1;
  [r3dot3_bzb] true:14;
  [r3dot3_bzbRetry] true:14;
endrewards