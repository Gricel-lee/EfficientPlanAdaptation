dtmc
evolve int r1_maxRetry_t2l4 [1..10];
evolve int r1_maxRetry_t3l5c [1..10];
evolve int r1_maxRetry_t3l5b [1..10];
evolve int r1_maxRetry_t3l5a [1..10];
evolve int r1_maxRetry_t2l2 [1..10];
evolve int r1_maxRetry_t3l3 [1..10];
evolve int r1_maxRetry_t3l9 [1..10];
evolve int r1_maxRetry_t2l9 [1..10];
evolve int r2_maxRetry_t2l1 [1..10];
evolve int worker2_maxRetry_t1l7b [1..5];
evolve int worker2_maxRetry_t1l7a [1..5];
evolve int worker2_maxRetry_t1l8 [1..5];

const double p_r1_t2l4=0.99;
const double p_r1_t3l5c=0.97;
const double p_r1_t3l5b=0.97;
const double p_r1_t3l5a=0.97;
const double p_r1_t2l2=0.99;
const double p_r1_t3l3=0.97;
const double p_r1_t3l9=0.97;
const double p_r1_t2l9=0.99;
const double p_r2_t2l1=0.99;
const double p_worker2_t1l7b=1.0;
const double p_worker2_t1l7a=1.0;
const double p_worker2_t1l8=1.0;
const int r1Final = 14;
const int r1Fail = 15;
const int r2Final = 1;
const int r2Fail = 2;
const int worker2Final = 6;
const int worker2Fail = 7;

module _r1
  r1 : [0..16];
  r1retry_t2l4 : [0..r1_maxRetry_t2l4] init 0;
  r1retry_t3l5c : [0..r1_maxRetry_t3l5c] init 0;
  r1retry_t3l5b : [0..r1_maxRetry_t3l5b] init 0;
  r1retry_t3l5a : [0..r1_maxRetry_t3l5a] init 0;
  r1retry_t2l2 : [0..r1_maxRetry_t2l2] init 0;
  r1retry_t3l3 : [0..r1_maxRetry_t3l3] init 0;
  r1retry_t3l9 : [0..r1_maxRetry_t3l9] init 0;
  r1retry_t2l9 : [0..r1_maxRetry_t2l9] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1dot2l4Retry] r1=1 & r1retry_t2l4 < r1_maxRetry_t2l4 -> p_r1_t2l4 : (r1'=r1+1) + (1-p_r1_t2l4) : (r1'=r1) & (r1retry_t2l4' = r1retry_t2l4+1);
  [r1dot2l4] r1=1 & r1retry_t2l4 >= r1_maxRetry_t2l4 -> 1:(r1'=r1Fail);
  [r1movel5] r1=2-> 1:(r1'=2+1);
  [r1dot3l5cRetry] r1=3 & r1retry_t3l5c < r1_maxRetry_t3l5c -> p_r1_t3l5c : (r1'=r1+1) + (1-p_r1_t3l5c) : (r1'=r1) & (r1retry_t3l5c' = r1retry_t3l5c+1);
  [r1dot3l5c] r1=3 & r1retry_t3l5c >= r1_maxRetry_t3l5c -> 1:(r1'=r1Fail);
  [r1dot3l5bRetry] r1=4 & r1retry_t3l5b < r1_maxRetry_t3l5b -> p_r1_t3l5b : (r1'=r1+1) + (1-p_r1_t3l5b) : (r1'=r1) & (r1retry_t3l5b' = r1retry_t3l5b+1);
  [r1dot3l5b] r1=4 & r1retry_t3l5b >= r1_maxRetry_t3l5b -> 1:(r1'=r1Fail);
  [r1dot3l5aRetry] r1=5 & r1retry_t3l5a < r1_maxRetry_t3l5a -> p_r1_t3l5a : (r1'=r1+1) + (1-p_r1_t3l5a) : (r1'=r1) & (r1retry_t3l5a' = r1retry_t3l5a+1);
  [r1dot3l5a] r1=5 & r1retry_t3l5a >= r1_maxRetry_t3l5a -> 1:(r1'=r1Fail);
  [r1movel2] r1=6-> 1:(r1'=6+1);
  [r1dot2l2Retry] r1=7 & r1retry_t2l2 < r1_maxRetry_t2l2 -> p_r1_t2l2 : (r1'=r1+1) + (1-p_r1_t2l2) : (r1'=r1) & (r1retry_t2l2' = r1retry_t2l2+1);
  [r1dot2l2] r1=7 & r1retry_t2l2 >= r1_maxRetry_t2l2 -> 1:(r1'=r1Fail);
  [r1movel3] r1=8-> 1:(r1'=8+1);
  [r1dot3l3Retry] r1=9 & r1retry_t3l3 < r1_maxRetry_t3l3 -> p_r1_t3l3 : (r1'=r1+1) + (1-p_r1_t3l3) : (r1'=r1) & (r1retry_t3l3' = r1retry_t3l3+1);
  [r1dot3l3] r1=9 & r1retry_t3l3 >= r1_maxRetry_t3l3 -> 1:(r1'=r1Fail);
  [r1movel6] r1=10-> 1:(r1'=10+1);
  [r1movel9] r1=11-> 1:(r1'=11+1);
  [r1dot3l9Retry] r1=12 & r1retry_t3l9 < r1_maxRetry_t3l9 -> p_r1_t3l9 : (r1'=r1+1) + (1-p_r1_t3l9) : (r1'=r1) & (r1retry_t3l9' = r1retry_t3l9+1);
  [r1dot3l9] r1=12 & r1retry_t3l9 >= r1_maxRetry_t3l9 -> 1:(r1'=r1Fail);
  [r1dot2l9Retry] r1=13 & r1retry_t2l9 < r1_maxRetry_t2l9 -> p_r1_t2l9 : (r1'=r1+1) + (1-p_r1_t2l9) : (r1'=r1) & (r1retry_t2l9' = r1retry_t2l9+1);
  [r1dot2l9] r1=13 & r1retry_t2l9 >= r1_maxRetry_t2l9 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..3];
  r2retry_t2l1 : [0..r2_maxRetry_t2l1] init 0;

  [r2dot2l1Retry] r2=0 & r2retry_t2l1 < r2_maxRetry_t2l1 -> p_r2_t2l1 : (r2'=r2+1) + (1-p_r2_t2l1) : (r2'=r2) & (r2retry_t2l1' = r2retry_t2l1+1);
  [r2dot2l1] r2=0 & r2retry_t2l1 >= r2_maxRetry_t2l1 -> 1:(r2'=r2Fail);
endmodule

module _worker2
  worker2 : [0..8];
  worker2retry_t1l7b : [0..worker2_maxRetry_t1l7b] init 0;
  worker2retry_t1l7a : [0..worker2_maxRetry_t1l7a] init 0;
  worker2retry_t1l8 : [0..worker2_maxRetry_t1l8] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2movel7] worker2=1-> 1:(worker2'=1+1);
  [worker2dot1l7bRetry] worker2=2 & worker2retry_t1l7b < worker2_maxRetry_t1l7b -> p_worker2_t1l7b : (worker2'=worker2+1) + (1-p_worker2_t1l7b) : (worker2'=worker2) & (worker2retry_t1l7b' = worker2retry_t1l7b+1);
  [worker2dot1l7b] worker2=2 & worker2retry_t1l7b >= worker2_maxRetry_t1l7b -> 1:(worker2'=worker2Fail);
  [worker2dot1l7aRetry] worker2=3 & worker2retry_t1l7a < worker2_maxRetry_t1l7a -> p_worker2_t1l7a : (worker2'=worker2+1) + (1-p_worker2_t1l7a) : (worker2'=worker2) & (worker2retry_t1l7a' = worker2retry_t1l7a+1);
  [worker2dot1l7a] worker2=3 & worker2retry_t1l7a >= worker2_maxRetry_t1l7a -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=4-> 1:(worker2'=4+1);
  [worker2dot1l8Retry] worker2=5 & worker2retry_t1l8 < worker2_maxRetry_t1l8 -> p_worker2_t1l8 : (worker2'=worker2+1) + (1-p_worker2_t1l8) : (worker2'=worker2) & (worker2retry_t1l8' = worker2retry_t1l8+1);
  [worker2dot1l8] worker2=5 & worker2retry_t1l8 >= worker2_maxRetry_t1l8 -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r1movel4] true:1;
  [r1dot2l4] true:1;
  [r1dot2l4Retry] true:1;
  [r1movel5] true:1;
  [r1dot3l5c] true:1;
  [r1dot3l5cRetry] true:1;
  [r1dot3l5b] true:1;
  [r1dot3l5bRetry] true:1;
  [r1dot3l5a] true:1;
  [r1dot3l5aRetry] true:1;
  [r1movel2] true:1;
  [r1dot2l2] true:1;
  [r1dot2l2Retry] true:1;
  [r1movel3] true:1;
  [r1dot3l3] true:1;
  [r1dot3l3Retry] true:1;
  [r1movel6] true:1;
  [r1movel9] true:1;
  [r1dot3l9] true:1;
  [r1dot3l9Retry] true:1;
  [r1dot2l9] true:1;
  [r1dot2l9Retry] true:1;
  [r2dot2l1] true:1;
  [r2dot2l1Retry] true:1;
  [worker2movel4] true:1;
  [worker2movel7] true:1;
  [worker2dot1l7b] true:3;
  [worker2dot1l7bRetry] true:3;
  [worker2dot1l7a] true:3;
  [worker2dot1l7aRetry] true:3;
  [worker2movel8] true:1;
  [worker2dot1l8] true:3;
  [worker2dot1l8Retry] true:3;
endrewards