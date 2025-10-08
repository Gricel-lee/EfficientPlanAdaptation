dtmc
evolve int r1_maxRetry_t1_wsa [1..1];
evolve int r1_maxRetry_t3_ala [1..1];
evolve int r1_maxRetry_t1_wsb [1..1];
evolve int r1_maxRetry_t3_alb [1..1];
evolve int r3_maxRetry_t4_db1 [1..1];
evolve int r3_maxRetry_t4_ps1 [1..1];
evolve int h1_maxRetry_t2_qc2 [1..1];
evolve int h1_maxRetry_t2_qc1 [1..1];

const double p_r1_t1_wsa=0.99;
const double p_r1_t3_ala=0.95;
const double p_r1_t1_wsb=0.99;
const double p_r1_t3_alb=0.95;
const double p_r3_t4_db1=0.99;
const double p_r3_t4_ps1=0.99;
const double p_h1_t2_qc2=0.97;
const double p_h1_t2_qc1=0.97;
const int r1Final = 8;
const int r1Fail = 9;
const int r3Final = 3;
const int r3Fail = 4;
const int h1Final = 2;
const int h1Fail = 3;

module _r1
  r1 : [0..10];
  r1retry_t1_wsa : [0..r1_maxRetry_t1_wsa] init 0;
  r1retry_t3_ala : [0..r1_maxRetry_t3_ala] init 0;
  r1retry_t1_wsb : [0..r1_maxRetry_t1_wsb] init 0;
  r1retry_t3_alb : [0..r1_maxRetry_t3_alb] init 0;

  [r1movel6] r1=0-> 1:(r1'=0+1);
  [r1dot1_wsaRetry] r1=1 & r1retry_t1_wsa < r1_maxRetry_t1_wsa -> p_r1_t1_wsa : (r1'=r1+1) + (1-p_r1_t1_wsa) : (r1'=r1) & (r1retry_t1_wsa' = r1retry_t1_wsa+1);
  [r1dot1_wsa] r1=1 & r1retry_t1_wsa >= r1_maxRetry_t1_wsa -> 1:(r1'=r1Fail);
  [r1movel4] r1=2-> 1:(r1'=2+1);
  [r1dot3_alaRetry] r1=3 & r1retry_t3_ala < r1_maxRetry_t3_ala -> p_r1_t3_ala : (r1'=r1+1) + (1-p_r1_t3_ala) : (r1'=r1) & (r1retry_t3_ala' = r1retry_t3_ala+1);
  [r1dot3_ala] r1=3 & r1retry_t3_ala >= r1_maxRetry_t3_ala -> 1:(r1'=r1Fail);
  [r1movel7] r1=4-> 1:(r1'=4+1);
  [r1dot1_wsbRetry] r1=5 & r1retry_t1_wsb < r1_maxRetry_t1_wsb -> p_r1_t1_wsb : (r1'=r1+1) + (1-p_r1_t1_wsb) : (r1'=r1) & (r1retry_t1_wsb' = r1retry_t1_wsb+1);
  [r1dot1_wsb] r1=5 & r1retry_t1_wsb >= r1_maxRetry_t1_wsb -> 1:(r1'=r1Fail);
  [r1movel5] r1=6-> 1:(r1'=6+1);
  [r1dot3_albRetry] r1=7 & r1retry_t3_alb < r1_maxRetry_t3_alb -> p_r1_t3_alb : (r1'=r1+1) + (1-p_r1_t3_alb) : (r1'=r1) & (r1retry_t3_alb' = r1retry_t3_alb+1);
  [r1dot3_alb] r1=7 & r1retry_t3_alb >= r1_maxRetry_t3_alb -> 1:(r1'=r1Fail);
endmodule

module _r3
  r3 : [0..5];
  r3retry_t4_db1 : [0..r3_maxRetry_t4_db1] init 0;
  r3retry_t4_ps1 : [0..r3_maxRetry_t4_ps1] init 0;

  [r3dot4_db1Retry] r3=0 & r3retry_t4_db1 < r3_maxRetry_t4_db1 -> p_r3_t4_db1 : (r3'=r3+1) + (1-p_r3_t4_db1) : (r3'=r3) & (r3retry_t4_db1' = r3retry_t4_db1+1);
  [r3dot4_db1] r3=0 & r3retry_t4_db1 >= r3_maxRetry_t4_db1 -> 1:(r3'=r3Fail);
  [r3movel9] r3=1-> 1:(r3'=1+1);
  [r3dot4_ps1Retry] r3=2 & r3retry_t4_ps1 < r3_maxRetry_t4_ps1 -> p_r3_t4_ps1 : (r3'=r3+1) + (1-p_r3_t4_ps1) : (r3'=r3) & (r3retry_t4_ps1' = r3retry_t4_ps1+1);
  [r3dot4_ps1] r3=2 & r3retry_t4_ps1 >= r3_maxRetry_t4_ps1 -> 1:(r3'=r3Fail);
endmodule

module _h1
  h1 : [0..4];
  h1retry_t2_qc2 : [0..h1_maxRetry_t2_qc2] init 0;
  h1retry_t2_qc1 : [0..h1_maxRetry_t2_qc1] init 0;

  [h1dot2_qc2Retry] h1=0 & h1retry_t2_qc2 < h1_maxRetry_t2_qc2 -> p_h1_t2_qc2 : (h1'=h1+1) + (1-p_h1_t2_qc2) : (h1'=h1) & (h1retry_t2_qc2' = h1retry_t2_qc2+1);
  [h1dot2_qc2] h1=0 & h1retry_t2_qc2 >= h1_maxRetry_t2_qc2 -> 1:(h1'=h1Fail);
  [h1dot2_qc1Retry] h1=1 & h1retry_t2_qc1 < h1_maxRetry_t2_qc1 -> p_h1_t2_qc1 : (h1'=h1+1) + (1-p_h1_t2_qc1) : (h1'=h1) & (h1retry_t2_qc1' = h1retry_t2_qc1+1);
  [h1dot2_qc1] h1=1 & h1retry_t2_qc1 >= h1_maxRetry_t2_qc1 -> 1:(h1'=h1Fail);
endmodule

rewards "cost"
  [r1movel6] true:1;
  [r1dot1_wsa] true:1;
  [r1dot1_wsaRetry] true:1;
  [r1movel4] true:1;
  [r1dot3_ala] true:1;
  [r1dot3_alaRetry] true:1;
  [r1movel7] true:1;
  [r1dot1_wsb] true:1;
  [r1dot1_wsbRetry] true:1;
  [r1movel5] true:1;
  [r1dot3_alb] true:1;
  [r1dot3_albRetry] true:1;
  [r3dot4_db1] true:1;
  [r3dot4_db1Retry] true:1;
  [r3movel9] true:1;
  [r3dot4_ps1] true:1;
  [r3dot4_ps1Retry] true:1;
  [h1dot2_qc2] true:1;
  [h1dot2_qc2Retry] true:1;
  [h1dot2_qc1] true:1;
  [h1dot2_qc1Retry] true:1;
endrewards