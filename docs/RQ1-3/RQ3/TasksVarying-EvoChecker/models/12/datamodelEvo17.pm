dtmc
evolve int r1_maxRetry_t2l2 [1..10];
evolve int r1_maxRetry_t3l2 [1..10];
evolve int r1_maxRetry_t2l3 [1..10];
evolve int r1_maxRetry_t2l6 [1..10];
evolve int r2_maxRetry_t3l4 [1..10];
evolve int r2_maxRetry_t3l7 [1..10];
evolve int worker2_maxRetry_t1l2 [1..5];
evolve int worker2_maxRetry_t1l5 [1..5];
evolve int worker2_maxRetry_t3l5 [1..5];
evolve int worker2_maxRetry_t1l8 [1..5];
evolve int worker2_maxRetry_t1l9b [1..5];
evolve int worker2_maxRetry_t1l9a [1..5];

const double p_r1_t2l2=0.99;
const double p_r1_t3l2=0.97;
const double p_r1_t2l3=0.99;
const double p_r1_t2l6=0.99;
const double p_r2_t3l4=0.97;
const double p_r2_t3l7=0.97;
const double p_worker2_t1l2=1.0;
const double p_worker2_t1l5=1.0;
const double p_worker2_t3l5=0.99;
const double p_worker2_t1l8=1.0;
const double p_worker2_t1l9b=1.0;
const double p_worker2_t1l9a=1.0;
const int r1Final = 7;
const int r1Fail = 8;
const int r2Final = 4;
const int r2Fail = 5;
const int worker2Final = 10;
const int worker2Fail = 11;

module _r1
  r1 : [0..9];
  r1retry_t2l2 : [0..r1_maxRetry_t2l2] init 0;
  r1retry_t3l2 : [0..r1_maxRetry_t3l2] init 0;
  r1retry_t2l3 : [0..r1_maxRetry_t2l3] init 0;
  r1retry_t2l6 : [0..r1_maxRetry_t2l6] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1dot2l2Retry] r1=1 & r1retry_t2l2 < r1_maxRetry_t2l2 -> p_r1_t2l2 : (r1'=r1+1) + (1-p_r1_t2l2) : (r1'=r1) & (r1retry_t2l2' = r1retry_t2l2+1);
  [r1dot2l2] r1=1 & r1retry_t2l2 >= r1_maxRetry_t2l2 -> 1:(r1'=r1Fail);
  [r1dot3l2Retry] r1=2 & r1retry_t3l2 < r1_maxRetry_t3l2 -> p_r1_t3l2 : (r1'=r1+1) + (1-p_r1_t3l2) : (r1'=r1) & (r1retry_t3l2' = r1retry_t3l2+1);
  [r1dot3l2] r1=2 & r1retry_t3l2 >= r1_maxRetry_t3l2 -> 1:(r1'=r1Fail);
  [r1movel3] r1=3-> 1:(r1'=3+1);
  [r1dot2l3Retry] r1=4 & r1retry_t2l3 < r1_maxRetry_t2l3 -> p_r1_t2l3 : (r1'=r1+1) + (1-p_r1_t2l3) : (r1'=r1) & (r1retry_t2l3' = r1retry_t2l3+1);
  [r1dot2l3] r1=4 & r1retry_t2l3 >= r1_maxRetry_t2l3 -> 1:(r1'=r1Fail);
  [r1movel6] r1=5-> 1:(r1'=5+1);
  [r1dot2l6Retry] r1=6 & r1retry_t2l6 < r1_maxRetry_t2l6 -> p_r1_t2l6 : (r1'=r1+1) + (1-p_r1_t2l6) : (r1'=r1) & (r1retry_t2l6' = r1retry_t2l6+1);
  [r1dot2l6] r1=6 & r1retry_t2l6 >= r1_maxRetry_t2l6 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..6];
  r2retry_t3l4 : [0..r2_maxRetry_t3l4] init 0;
  r2retry_t3l7 : [0..r2_maxRetry_t3l7] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2dot3l4Retry] r2=1 & r2retry_t3l4 < r2_maxRetry_t3l4 -> p_r2_t3l4 : (r2'=r2+1) + (1-p_r2_t3l4) : (r2'=r2) & (r2retry_t3l4' = r2retry_t3l4+1);
  [r2dot3l4] r2=1 & r2retry_t3l4 >= r2_maxRetry_t3l4 -> 1:(r2'=r2Fail);
  [r2movel7] r2=2-> 1:(r2'=2+1);
  [r2dot3l7Retry] r2=3 & r2retry_t3l7 < r2_maxRetry_t3l7 -> p_r2_t3l7 : (r2'=r2+1) + (1-p_r2_t3l7) : (r2'=r2) & (r2retry_t3l7' = r2retry_t3l7+1);
  [r2dot3l7] r2=3 & r2retry_t3l7 >= r2_maxRetry_t3l7 -> 1:(r2'=r2Fail);
endmodule

module _worker2
  worker2 : [0..12];
  worker2retry_t1l2 : [0..worker2_maxRetry_t1l2] init 0;
  worker2retry_t1l5 : [0..worker2_maxRetry_t1l5] init 0;
  worker2retry_t3l5 : [0..worker2_maxRetry_t3l5] init 0;
  worker2retry_t1l8 : [0..worker2_maxRetry_t1l8] init 0;
  worker2retry_t1l9b : [0..worker2_maxRetry_t1l9b] init 0;
  worker2retry_t1l9a : [0..worker2_maxRetry_t1l9a] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l2Retry] worker2=1 & worker2retry_t1l2 < worker2_maxRetry_t1l2 -> p_worker2_t1l2 : (worker2'=worker2+1) + (1-p_worker2_t1l2) : (worker2'=worker2) & (worker2retry_t1l2' = worker2retry_t1l2+1);
  [worker2dot1l2] worker2=1 & worker2retry_t1l2 >= worker2_maxRetry_t1l2 -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=2-> 1:(worker2'=2+1);
  [worker2dot1l5Retry] worker2=3 & worker2retry_t1l5 < worker2_maxRetry_t1l5 -> p_worker2_t1l5 : (worker2'=worker2+1) + (1-p_worker2_t1l5) : (worker2'=worker2) & (worker2retry_t1l5' = worker2retry_t1l5+1);
  [worker2dot1l5] worker2=3 & worker2retry_t1l5 >= worker2_maxRetry_t1l5 -> 1:(worker2'=worker2Fail);
  [worker2dot3l5Retry] worker2=4 & worker2retry_t3l5 < worker2_maxRetry_t3l5 -> p_worker2_t3l5 : (worker2'=worker2+1) + (1-p_worker2_t3l5) : (worker2'=worker2) & (worker2retry_t3l5' = worker2retry_t3l5+1);
  [worker2dot3l5] worker2=4 & worker2retry_t3l5 >= worker2_maxRetry_t3l5 -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=5-> 1:(worker2'=5+1);
  [worker2dot1l8Retry] worker2=6 & worker2retry_t1l8 < worker2_maxRetry_t1l8 -> p_worker2_t1l8 : (worker2'=worker2+1) + (1-p_worker2_t1l8) : (worker2'=worker2) & (worker2retry_t1l8' = worker2retry_t1l8+1);
  [worker2dot1l8] worker2=6 & worker2retry_t1l8 >= worker2_maxRetry_t1l8 -> 1:(worker2'=worker2Fail);
  [worker2movel9] worker2=7-> 1:(worker2'=7+1);
  [worker2dot1l9bRetry] worker2=8 & worker2retry_t1l9b < worker2_maxRetry_t1l9b -> p_worker2_t1l9b : (worker2'=worker2+1) + (1-p_worker2_t1l9b) : (worker2'=worker2) & (worker2retry_t1l9b' = worker2retry_t1l9b+1);
  [worker2dot1l9b] worker2=8 & worker2retry_t1l9b >= worker2_maxRetry_t1l9b -> 1:(worker2'=worker2Fail);
  [worker2dot1l9aRetry] worker2=9 & worker2retry_t1l9a < worker2_maxRetry_t1l9a -> p_worker2_t1l9a : (worker2'=worker2+1) + (1-p_worker2_t1l9a) : (worker2'=worker2) & (worker2retry_t1l9a' = worker2retry_t1l9a+1);
  [worker2dot1l9a] worker2=9 & worker2retry_t1l9a >= worker2_maxRetry_t1l9a -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r1movel2] true:1;
  [r1dot2l2] true:1;
  [r1dot2l2Retry] true:1;
  [r1dot3l2] true:1;
  [r1dot3l2Retry] true:1;
  [r1movel3] true:1;
  [r1dot2l3] true:1;
  [r1dot2l3Retry] true:1;
  [r1movel6] true:1;
  [r1dot2l6] true:1;
  [r1dot2l6Retry] true:1;
  [r2movel4] true:1;
  [r2dot3l4] true:1;
  [r2dot3l4Retry] true:1;
  [r2movel7] true:1;
  [r2dot3l7] true:1;
  [r2dot3l7Retry] true:1;
  [worker2movel2] true:1;
  [worker2dot1l2] true:3;
  [worker2dot1l2Retry] true:3;
  [worker2movel5] true:1;
  [worker2dot1l5] true:3;
  [worker2dot1l5Retry] true:3;
  [worker2dot3l5] true:5;
  [worker2dot3l5Retry] true:5;
  [worker2movel8] true:1;
  [worker2dot1l8] true:3;
  [worker2dot1l8Retry] true:3;
  [worker2movel9] true:1;
  [worker2dot1l9b] true:3;
  [worker2dot1l9bRetry] true:3;
  [worker2dot1l9a] true:3;
  [worker2dot1l9aRetry] true:3;
endrewards