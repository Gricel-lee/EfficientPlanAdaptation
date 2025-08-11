dtmc
evolve int r2_maxRetry_t3l2 [1..10];
evolve int r2_maxRetry_t2l2b [1..10];
evolve int r2_maxRetry_t2l2a [1..10];
evolve int r2_maxRetry_t2l2c [1..10];
evolve int r2_maxRetry_t3l5 [1..10];
evolve int r2_maxRetry_t2l6 [1..10];
evolve int r2_maxRetry_t2l9 [1..10];
evolve int r2_maxRetry_t3l8 [1..10];
evolve int r2_maxRetry_t3l7 [1..10];
evolve int worker1_maxRetry_t1l1 [1..5];
evolve int r1_maxRetry_t2l1 [1..10];

const double p_r2_t3l2=0.97;
const double p_r2_t2l2b=0.99;
const double p_r2_t2l2a=0.99;
const double p_r2_t2l2c=0.99;
const double p_r2_t3l5=0.97;
const double p_r2_t2l6=0.99;
const double p_r2_t2l9=0.99;
const double p_r2_t3l8=0.97;
const double p_r2_t3l7=0.97;
const double p_worker1_t1l1=1.0;
const double p_r1_t2l1=0.99;
const int r2Final = 15;
const int r2Fail = 16;
const int worker1Final = 1;
const int worker1Fail = 2;
const int r1Final = 1;
const int r1Fail = 2;

module _r2
  r2 : [0..17];
  r2retry_t3l2 : [0..r2_maxRetry_t3l2] init 0;
  r2retry_t2l2b : [0..r2_maxRetry_t2l2b] init 0;
  r2retry_t2l2a : [0..r2_maxRetry_t2l2a] init 0;
  r2retry_t2l2c : [0..r2_maxRetry_t2l2c] init 0;
  r2retry_t3l5 : [0..r2_maxRetry_t3l5] init 0;
  r2retry_t2l6 : [0..r2_maxRetry_t2l6] init 0;
  r2retry_t2l9 : [0..r2_maxRetry_t2l9] init 0;
  r2retry_t3l8 : [0..r2_maxRetry_t3l8] init 0;
  r2retry_t3l7 : [0..r2_maxRetry_t3l7] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2dot3l2Retry] r2=1 & r2retry_t3l2 < r2_maxRetry_t3l2 -> p_r2_t3l2 : (r2'=r2+1) + (1-p_r2_t3l2) : (r2'=r2) & (r2retry_t3l2' = r2retry_t3l2+1);
  [r2dot3l2] r2=1 & r2retry_t3l2 >= r2_maxRetry_t3l2 -> 1:(r2'=r2Fail);
  [r2dot2l2bRetry] r2=2 & r2retry_t2l2b < r2_maxRetry_t2l2b -> p_r2_t2l2b : (r2'=r2+1) + (1-p_r2_t2l2b) : (r2'=r2) & (r2retry_t2l2b' = r2retry_t2l2b+1);
  [r2dot2l2b] r2=2 & r2retry_t2l2b >= r2_maxRetry_t2l2b -> 1:(r2'=r2Fail);
  [r2dot2l2aRetry] r2=3 & r2retry_t2l2a < r2_maxRetry_t2l2a -> p_r2_t2l2a : (r2'=r2+1) + (1-p_r2_t2l2a) : (r2'=r2) & (r2retry_t2l2a' = r2retry_t2l2a+1);
  [r2dot2l2a] r2=3 & r2retry_t2l2a >= r2_maxRetry_t2l2a -> 1:(r2'=r2Fail);
  [r2dot2l2cRetry] r2=4 & r2retry_t2l2c < r2_maxRetry_t2l2c -> p_r2_t2l2c : (r2'=r2+1) + (1-p_r2_t2l2c) : (r2'=r2) & (r2retry_t2l2c' = r2retry_t2l2c+1);
  [r2dot2l2c] r2=4 & r2retry_t2l2c >= r2_maxRetry_t2l2c -> 1:(r2'=r2Fail);
  [r2movel5] r2=5-> 1:(r2'=5+1);
  [r2dot3l5Retry] r2=6 & r2retry_t3l5 < r2_maxRetry_t3l5 -> p_r2_t3l5 : (r2'=r2+1) + (1-p_r2_t3l5) : (r2'=r2) & (r2retry_t3l5' = r2retry_t3l5+1);
  [r2dot3l5] r2=6 & r2retry_t3l5 >= r2_maxRetry_t3l5 -> 1:(r2'=r2Fail);
  [r2movel6] r2=7-> 1:(r2'=7+1);
  [r2dot2l6Retry] r2=8 & r2retry_t2l6 < r2_maxRetry_t2l6 -> p_r2_t2l6 : (r2'=r2+1) + (1-p_r2_t2l6) : (r2'=r2) & (r2retry_t2l6' = r2retry_t2l6+1);
  [r2dot2l6] r2=8 & r2retry_t2l6 >= r2_maxRetry_t2l6 -> 1:(r2'=r2Fail);
  [r2movel9] r2=9-> 1:(r2'=9+1);
  [r2dot2l9Retry] r2=10 & r2retry_t2l9 < r2_maxRetry_t2l9 -> p_r2_t2l9 : (r2'=r2+1) + (1-p_r2_t2l9) : (r2'=r2) & (r2retry_t2l9' = r2retry_t2l9+1);
  [r2dot2l9] r2=10 & r2retry_t2l9 >= r2_maxRetry_t2l9 -> 1:(r2'=r2Fail);
  [r2movel8] r2=11-> 1:(r2'=11+1);
  [r2dot3l8Retry] r2=12 & r2retry_t3l8 < r2_maxRetry_t3l8 -> p_r2_t3l8 : (r2'=r2+1) + (1-p_r2_t3l8) : (r2'=r2) & (r2retry_t3l8' = r2retry_t3l8+1);
  [r2dot3l8] r2=12 & r2retry_t3l8 >= r2_maxRetry_t3l8 -> 1:(r2'=r2Fail);
  [r2movel7] r2=13-> 1:(r2'=13+1);
  [r2dot3l7Retry] r2=14 & r2retry_t3l7 < r2_maxRetry_t3l7 -> p_r2_t3l7 : (r2'=r2+1) + (1-p_r2_t3l7) : (r2'=r2) & (r2retry_t3l7' = r2retry_t3l7+1);
  [r2dot3l7] r2=14 & r2retry_t3l7 >= r2_maxRetry_t3l7 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..3];
  worker1retry_t1l1 : [0..worker1_maxRetry_t1l1] init 0;

  [worker1dot1l1Retry] worker1=0 & worker1retry_t1l1 < worker1_maxRetry_t1l1 -> p_worker1_t1l1 : (worker1'=worker1+1) + (1-p_worker1_t1l1) : (worker1'=worker1) & (worker1retry_t1l1' = worker1retry_t1l1+1);
  [worker1dot1l1] worker1=0 & worker1retry_t1l1 >= worker1_maxRetry_t1l1 -> 1:(worker1'=worker1Fail);
endmodule

module _r1
  r1 : [0..3];
  r1retry_t2l1 : [0..r1_maxRetry_t2l1] init 0;

  [r1dot2l1Retry] r1=0 & r1retry_t2l1 < r1_maxRetry_t2l1 -> p_r1_t2l1 : (r1'=r1+1) + (1-p_r1_t2l1) : (r1'=r1) & (r1retry_t2l1' = r1retry_t2l1+1);
  [r1dot2l1] r1=0 & r1retry_t2l1 >= r1_maxRetry_t2l1 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [r2movel2] true:1;
  [r2dot3l2] true:1;
  [r2dot3l2Retry] true:1;
  [r2dot2l2b] true:1;
  [r2dot2l2bRetry] true:1;
  [r2dot2l2a] true:1;
  [r2dot2l2aRetry] true:1;
  [r2dot2l2c] true:1;
  [r2dot2l2cRetry] true:1;
  [r2movel5] true:1;
  [r2dot3l5] true:1;
  [r2dot3l5Retry] true:1;
  [r2movel6] true:1;
  [r2dot2l6] true:1;
  [r2dot2l6Retry] true:1;
  [r2movel9] true:1;
  [r2dot2l9] true:1;
  [r2dot2l9Retry] true:1;
  [r2movel8] true:1;
  [r2dot3l8] true:1;
  [r2dot3l8Retry] true:1;
  [r2movel7] true:1;
  [r2dot3l7] true:1;
  [r2dot3l7Retry] true:1;
  [worker1dot1l1] true:3;
  [worker1dot1l1Retry] true:3;
  [r1dot2l1] true:1;
  [r1dot2l1Retry] true:1;
endrewards