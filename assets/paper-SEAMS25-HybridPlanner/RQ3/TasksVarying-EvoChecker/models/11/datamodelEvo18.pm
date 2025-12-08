dtmc
evolve int r2_maxRetry_t3l4 [1..10];
evolve int r2_maxRetry_t2l5a [1..10];
evolve int r2_maxRetry_t2l5b [1..10];
evolve int r2_maxRetry_t3l8a [1..10];
evolve int r2_maxRetry_t2l8 [1..10];
evolve int r2_maxRetry_t3l8b [1..10];
evolve int r2_maxRetry_t2l9 [1..10];
evolve int worker1_maxRetry_t1l2c [1..5];
evolve int worker1_maxRetry_t1l2b [1..5];
evolve int worker1_maxRetry_t1l2a [1..5];
evolve int r1_maxRetry_t2l3 [1..10];

const double p_r2_t3l4=0.97;
const double p_r2_t2l5a=0.99;
const double p_r2_t2l5b=0.99;
const double p_r2_t3l8a=0.97;
const double p_r2_t2l8=0.99;
const double p_r2_t3l8b=0.97;
const double p_r2_t2l9=0.99;
const double p_worker1_t1l2c=1.0;
const double p_worker1_t1l2b=1.0;
const double p_worker1_t1l2a=1.0;
const double p_r1_t2l3=0.99;
const int r2Final = 11;
const int r2Fail = 12;
const int worker1Final = 4;
const int worker1Fail = 5;
const int r1Final = 3;
const int r1Fail = 4;

module _r2
  r2 : [0..13];
  r2retry_t3l4 : [0..r2_maxRetry_t3l4] init 0;
  r2retry_t2l5a : [0..r2_maxRetry_t2l5a] init 0;
  r2retry_t2l5b : [0..r2_maxRetry_t2l5b] init 0;
  r2retry_t3l8a : [0..r2_maxRetry_t3l8a] init 0;
  r2retry_t2l8 : [0..r2_maxRetry_t2l8] init 0;
  r2retry_t3l8b : [0..r2_maxRetry_t3l8b] init 0;
  r2retry_t2l9 : [0..r2_maxRetry_t2l9] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2dot3l4Retry] r2=1 & r2retry_t3l4 < r2_maxRetry_t3l4 -> p_r2_t3l4 : (r2'=r2+1) + (1-p_r2_t3l4) : (r2'=r2) & (r2retry_t3l4' = r2retry_t3l4+1);
  [r2dot3l4] r2=1 & r2retry_t3l4 >= r2_maxRetry_t3l4 -> 1:(r2'=r2Fail);
  [r2movel5] r2=2-> 1:(r2'=2+1);
  [r2dot2l5aRetry] r2=3 & r2retry_t2l5a < r2_maxRetry_t2l5a -> p_r2_t2l5a : (r2'=r2+1) + (1-p_r2_t2l5a) : (r2'=r2) & (r2retry_t2l5a' = r2retry_t2l5a+1);
  [r2dot2l5a] r2=3 & r2retry_t2l5a >= r2_maxRetry_t2l5a -> 1:(r2'=r2Fail);
  [r2dot2l5bRetry] r2=4 & r2retry_t2l5b < r2_maxRetry_t2l5b -> p_r2_t2l5b : (r2'=r2+1) + (1-p_r2_t2l5b) : (r2'=r2) & (r2retry_t2l5b' = r2retry_t2l5b+1);
  [r2dot2l5b] r2=4 & r2retry_t2l5b >= r2_maxRetry_t2l5b -> 1:(r2'=r2Fail);
  [r2movel8] r2=5-> 1:(r2'=5+1);
  [r2dot3l8aRetry] r2=6 & r2retry_t3l8a < r2_maxRetry_t3l8a -> p_r2_t3l8a : (r2'=r2+1) + (1-p_r2_t3l8a) : (r2'=r2) & (r2retry_t3l8a' = r2retry_t3l8a+1);
  [r2dot3l8a] r2=6 & r2retry_t3l8a >= r2_maxRetry_t3l8a -> 1:(r2'=r2Fail);
  [r2dot2l8Retry] r2=7 & r2retry_t2l8 < r2_maxRetry_t2l8 -> p_r2_t2l8 : (r2'=r2+1) + (1-p_r2_t2l8) : (r2'=r2) & (r2retry_t2l8' = r2retry_t2l8+1);
  [r2dot2l8] r2=7 & r2retry_t2l8 >= r2_maxRetry_t2l8 -> 1:(r2'=r2Fail);
  [r2dot3l8bRetry] r2=8 & r2retry_t3l8b < r2_maxRetry_t3l8b -> p_r2_t3l8b : (r2'=r2+1) + (1-p_r2_t3l8b) : (r2'=r2) & (r2retry_t3l8b' = r2retry_t3l8b+1);
  [r2dot3l8b] r2=8 & r2retry_t3l8b >= r2_maxRetry_t3l8b -> 1:(r2'=r2Fail);
  [r2movel9] r2=9-> 1:(r2'=9+1);
  [r2dot2l9Retry] r2=10 & r2retry_t2l9 < r2_maxRetry_t2l9 -> p_r2_t2l9 : (r2'=r2+1) + (1-p_r2_t2l9) : (r2'=r2) & (r2retry_t2l9' = r2retry_t2l9+1);
  [r2dot2l9] r2=10 & r2retry_t2l9 >= r2_maxRetry_t2l9 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..6];
  worker1retry_t1l2c : [0..worker1_maxRetry_t1l2c] init 0;
  worker1retry_t1l2b : [0..worker1_maxRetry_t1l2b] init 0;
  worker1retry_t1l2a : [0..worker1_maxRetry_t1l2a] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l2cRetry] worker1=1 & worker1retry_t1l2c < worker1_maxRetry_t1l2c -> p_worker1_t1l2c : (worker1'=worker1+1) + (1-p_worker1_t1l2c) : (worker1'=worker1) & (worker1retry_t1l2c' = worker1retry_t1l2c+1);
  [worker1dot1l2c] worker1=1 & worker1retry_t1l2c >= worker1_maxRetry_t1l2c -> 1:(worker1'=worker1Fail);
  [worker1dot1l2bRetry] worker1=2 & worker1retry_t1l2b < worker1_maxRetry_t1l2b -> p_worker1_t1l2b : (worker1'=worker1+1) + (1-p_worker1_t1l2b) : (worker1'=worker1) & (worker1retry_t1l2b' = worker1retry_t1l2b+1);
  [worker1dot1l2b] worker1=2 & worker1retry_t1l2b >= worker1_maxRetry_t1l2b -> 1:(worker1'=worker1Fail);
  [worker1dot1l2aRetry] worker1=3 & worker1retry_t1l2a < worker1_maxRetry_t1l2a -> p_worker1_t1l2a : (worker1'=worker1+1) + (1-p_worker1_t1l2a) : (worker1'=worker1) & (worker1retry_t1l2a' = worker1retry_t1l2a+1);
  [worker1dot1l2a] worker1=3 & worker1retry_t1l2a >= worker1_maxRetry_t1l2a -> 1:(worker1'=worker1Fail);
endmodule

module _r1
  r1 : [0..5];
  r1retry_t2l3 : [0..r1_maxRetry_t2l3] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1movel3] r1=1-> 1:(r1'=1+1);
  [r1dot2l3Retry] r1=2 & r1retry_t2l3 < r1_maxRetry_t2l3 -> p_r1_t2l3 : (r1'=r1+1) + (1-p_r1_t2l3) : (r1'=r1) & (r1retry_t2l3' = r1retry_t2l3+1);
  [r1dot2l3] r1=2 & r1retry_t2l3 >= r1_maxRetry_t2l3 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [r2movel4] true:1;
  [r2dot3l4] true:1;
  [r2dot3l4Retry] true:1;
  [r2movel5] true:1;
  [r2dot2l5a] true:1;
  [r2dot2l5aRetry] true:1;
  [r2dot2l5b] true:1;
  [r2dot2l5bRetry] true:1;
  [r2movel8] true:1;
  [r2dot3l8a] true:1;
  [r2dot3l8aRetry] true:1;
  [r2dot2l8] true:1;
  [r2dot2l8Retry] true:1;
  [r2dot3l8b] true:1;
  [r2dot3l8bRetry] true:1;
  [r2movel9] true:1;
  [r2dot2l9] true:1;
  [r2dot2l9Retry] true:1;
  [worker1movel2] true:1;
  [worker1dot1l2c] true:3;
  [worker1dot1l2cRetry] true:3;
  [worker1dot1l2b] true:3;
  [worker1dot1l2bRetry] true:3;
  [worker1dot1l2a] true:3;
  [worker1dot1l2aRetry] true:3;
  [r1movel2] true:1;
  [r1movel3] true:1;
  [r1dot2l3] true:1;
  [r1dot2l3Retry] true:1;
endrewards