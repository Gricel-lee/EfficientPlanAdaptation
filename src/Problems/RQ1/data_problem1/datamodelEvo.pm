dtmc
evolve int r1_maxRetry_t3l3 [1..3];
evolve int r1_maxRetry_t3l5 [1..3];

const double p_r1_t3l3=0.97;
const double p_r1_t3l5=0.97;
const int r1Final = 5;
const int r1Fail = 6;

module _r1
  r1 : [0..7];
  r1retry_t3l3 : [0..r1_maxRetry_t3l3] init 0;
  r1retry_t3l5 : [0..r1_maxRetry_t3l5] init 0;

  [r1movel3] r1=0-> 1:(r1'=0+1);
  [r1dot3l3Retry] r1=1 & r1retry_t3l3 < r1_maxRetry_t3l3 -> p_r1_t3l3 : (r1'=r1+1) + (1-p_r1_t3l3) : (r1'=r1) & (r1retry_t3l3' = r1retry_t3l3+1);
  [r1dot3l3] r1=1 & r1retry_t3l3 >= r1_maxRetry_t3l3 -> 1:(r1'=r1Fail);
  [r1movel5] r1=2-> 1:(r1'=2+1);
  [r1movel6] r1=3-> 1:(r1'=3+1);
  [r1dot3l5Retry] r1=4 & r1retry_t3l5 < r1_maxRetry_t3l5 -> p_r1_t3l5 : (r1'=r1+1) + (1-p_r1_t3l5) : (r1'=r1) & (r1retry_t3l5' = r1retry_t3l5+1);
  [r1dot3l5] r1=4 & r1retry_t3l5 >= r1_maxRetry_t3l5 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [r1movel3] true:1;
  [r1dot3l3] true:1;
  [r1dot3l3Retry] true:1;
  [r1movel5] true:1;
  [r1movel6] true:1;
  [r1dot3l5] true:1;
  [r1dot3l5Retry] true:1;
endrewards