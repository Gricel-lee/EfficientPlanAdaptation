dtmc
evolve int worker2_maxRetry_t1l5 [1..5];
evolve int worker2_maxRetry_t3l8a [1..5];
evolve int worker2_maxRetry_t1l9 [1..5];
evolve int worker2_maxRetry_t1l3 [1..5];
evolve int r1_maxRetry_t2l7 [1..10];
evolve int r1_maxRetry_t3l8b [1..10];
evolve int r1_maxRetry_t3l9 [1..10];
evolve int r1_maxRetry_t2l9 [1..10];
evolve int r2_maxRetry_t2l2 [1..10];
evolve int r2_maxRetry_t2l5 [1..10];

const double p_worker2_t1l5=1.0;
const double p_worker2_t3l8a=0.99;
const double p_worker2_t1l9=1.0;
const double p_worker2_t1l3=1.0;
const double p_r1_t2l7=0.99;
const double p_r1_t3l8b=0.97;
const double p_r1_t3l9=0.97;
const double p_r1_t2l9=0.99;
const double p_r2_t2l2=0.99;
const double p_r2_t2l5=0.99;
const int worker2Final = 10;
const int worker2Fail = 11;
const int r1Final = 8;
const int r1Fail = 9;
const int r2Final = 4;
const int r2Fail = 5;

module _worker2
  worker2 : [0..12];
  worker2retry_t1l5 : [0..worker2_maxRetry_t1l5] init 0;
  worker2retry_t3l8a : [0..worker2_maxRetry_t3l8a] init 0;
  worker2retry_t1l9 : [0..worker2_maxRetry_t1l9] init 0;
  worker2retry_t1l3 : [0..worker2_maxRetry_t1l3] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2movel5] worker2=1-> 1:(worker2'=1+1);
  [worker2dot1l5Retry] worker2=2 & worker2retry_t1l5 < worker2_maxRetry_t1l5 -> p_worker2_t1l5 : (worker2'=worker2+1) + (1-p_worker2_t1l5) : (worker2'=worker2) & (worker2retry_t1l5' = worker2retry_t1l5+1);
  [worker2dot1l5] worker2=2 & worker2retry_t1l5 >= worker2_maxRetry_t1l5 -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=3-> 1:(worker2'=3+1);
  [worker2dot3l8aRetry] worker2=4 & worker2retry_t3l8a < worker2_maxRetry_t3l8a -> p_worker2_t3l8a : (worker2'=worker2+1) + (1-p_worker2_t3l8a) : (worker2'=worker2) & (worker2retry_t3l8a' = worker2retry_t3l8a+1);
  [worker2dot3l8a] worker2=4 & worker2retry_t3l8a >= worker2_maxRetry_t3l8a -> 1:(worker2'=worker2Fail);
  [worker2movel9] worker2=5-> 1:(worker2'=5+1);
  [worker2dot1l9Retry] worker2=6 & worker2retry_t1l9 < worker2_maxRetry_t1l9 -> p_worker2_t1l9 : (worker2'=worker2+1) + (1-p_worker2_t1l9) : (worker2'=worker2) & (worker2retry_t1l9' = worker2retry_t1l9+1);
  [worker2dot1l9] worker2=6 & worker2retry_t1l9 >= worker2_maxRetry_t1l9 -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=7-> 1:(worker2'=7+1);
  [worker2movel3] worker2=8-> 1:(worker2'=8+1);
  [worker2dot1l3Retry] worker2=9 & worker2retry_t1l3 < worker2_maxRetry_t1l3 -> p_worker2_t1l3 : (worker2'=worker2+1) + (1-p_worker2_t1l3) : (worker2'=worker2) & (worker2retry_t1l3' = worker2retry_t1l3+1);
  [worker2dot1l3] worker2=9 & worker2retry_t1l3 >= worker2_maxRetry_t1l3 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..10];
  r1retry_t2l7 : [0..r1_maxRetry_t2l7] init 0;
  r1retry_t3l8b : [0..r1_maxRetry_t3l8b] init 0;
  r1retry_t3l9 : [0..r1_maxRetry_t3l9] init 0;
  r1retry_t2l9 : [0..r1_maxRetry_t2l9] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1movel7] r1=1-> 1:(r1'=1+1);
  [r1dot2l7Retry] r1=2 & r1retry_t2l7 < r1_maxRetry_t2l7 -> p_r1_t2l7 : (r1'=r1+1) + (1-p_r1_t2l7) : (r1'=r1) & (r1retry_t2l7' = r1retry_t2l7+1);
  [r1dot2l7] r1=2 & r1retry_t2l7 >= r1_maxRetry_t2l7 -> 1:(r1'=r1Fail);
  [r1movel8] r1=3-> 1:(r1'=3+1);
  [r1dot3l8bRetry] r1=4 & r1retry_t3l8b < r1_maxRetry_t3l8b -> p_r1_t3l8b : (r1'=r1+1) + (1-p_r1_t3l8b) : (r1'=r1) & (r1retry_t3l8b' = r1retry_t3l8b+1);
  [r1dot3l8b] r1=4 & r1retry_t3l8b >= r1_maxRetry_t3l8b -> 1:(r1'=r1Fail);
  [r1movel9] r1=5-> 1:(r1'=5+1);
  [r1dot3l9Retry] r1=6 & r1retry_t3l9 < r1_maxRetry_t3l9 -> p_r1_t3l9 : (r1'=r1+1) + (1-p_r1_t3l9) : (r1'=r1) & (r1retry_t3l9' = r1retry_t3l9+1);
  [r1dot3l9] r1=6 & r1retry_t3l9 >= r1_maxRetry_t3l9 -> 1:(r1'=r1Fail);
  [r1dot2l9Retry] r1=7 & r1retry_t2l9 < r1_maxRetry_t2l9 -> p_r1_t2l9 : (r1'=r1+1) + (1-p_r1_t2l9) : (r1'=r1) & (r1retry_t2l9' = r1retry_t2l9+1);
  [r1dot2l9] r1=7 & r1retry_t2l9 >= r1_maxRetry_t2l9 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..6];
  r2retry_t2l2 : [0..r2_maxRetry_t2l2] init 0;
  r2retry_t2l5 : [0..r2_maxRetry_t2l5] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2dot2l2Retry] r2=1 & r2retry_t2l2 < r2_maxRetry_t2l2 -> p_r2_t2l2 : (r2'=r2+1) + (1-p_r2_t2l2) : (r2'=r2) & (r2retry_t2l2' = r2retry_t2l2+1);
  [r2dot2l2] r2=1 & r2retry_t2l2 >= r2_maxRetry_t2l2 -> 1:(r2'=r2Fail);
  [r2movel5] r2=2-> 1:(r2'=2+1);
  [r2dot2l5Retry] r2=3 & r2retry_t2l5 < r2_maxRetry_t2l5 -> p_r2_t2l5 : (r2'=r2+1) + (1-p_r2_t2l5) : (r2'=r2) & (r2retry_t2l5' = r2retry_t2l5+1);
  [r2dot2l5] r2=3 & r2retry_t2l5 >= r2_maxRetry_t2l5 -> 1:(r2'=r2Fail);
endmodule

rewards "cost"
  [worker2movel2] true:1;
  [worker2movel5] true:1;
  [worker2dot1l5] true:3;
  [worker2dot1l5Retry] true:3;
  [worker2movel8] true:1;
  [worker2dot3l8a] true:5;
  [worker2dot3l8aRetry] true:5;
  [worker2movel9] true:1;
  [worker2dot1l9] true:3;
  [worker2dot1l9Retry] true:3;
  [worker2movel6] true:1;
  [worker2movel3] true:1;
  [worker2dot1l3] true:3;
  [worker2dot1l3Retry] true:3;
  [r1movel4] true:1;
  [r1movel7] true:1;
  [r1dot2l7] true:1;
  [r1dot2l7Retry] true:1;
  [r1movel8] true:1;
  [r1dot3l8b] true:1;
  [r1dot3l8bRetry] true:1;
  [r1movel9] true:1;
  [r1dot3l9] true:1;
  [r1dot3l9Retry] true:1;
  [r1dot2l9] true:1;
  [r1dot2l9Retry] true:1;
  [r2movel2] true:1;
  [r2dot2l2] true:1;
  [r2dot2l2Retry] true:1;
  [r2movel5] true:1;
  [r2dot2l5] true:1;
  [r2dot2l5Retry] true:1;
endrewards