dtmc
evolve int worker2_maxRetry_t1l2a [1..5];
evolve int worker2_maxRetry_t1l2b [1..5];
evolve int worker2_maxRetry_t1l9 [1..5];
evolve int r1_maxRetry_t3l2b [1..10];
evolve int r1_maxRetry_t3l2c [1..10];
evolve int r1_maxRetry_t2l5a [1..10];
evolve int r1_maxRetry_t2l5b [1..10];
evolve int r1_maxRetry_t2l8a [1..10];
evolve int r1_maxRetry_t2l8c [1..10];
evolve int r1_maxRetry_t2l8b [1..10];
evolve int r2_maxRetry_t3l2a [1..10];
evolve int r2_maxRetry_t2l3 [1..10];
evolve int worker1_maxRetry_t3l1 [1..5];

const double p_worker2_t1l2a=1.0;
const double p_worker2_t1l2b=1.0;
const double p_worker2_t1l9=1.0;
const double p_r1_t3l2b=0.97;
const double p_r1_t3l2c=0.97;
const double p_r1_t2l5a=0.99;
const double p_r1_t2l5b=0.99;
const double p_r1_t2l8a=0.99;
const double p_r1_t2l8c=0.99;
const double p_r1_t2l8b=0.99;
const double p_r2_t3l2a=0.97;
const double p_r2_t2l3=0.99;
const double p_worker1_t3l1=0.99;
const int worker2Final = 7;
const int worker2Fail = 8;
const int r1Final = 10;
const int r1Fail = 11;
const int r2Final = 4;
const int r2Fail = 5;
const int worker1Final = 1;
const int worker1Fail = 2;

module _worker2
  worker2 : [0..9];
  worker2retry_t1l2a : [0..worker2_maxRetry_t1l2a] init 0;
  worker2retry_t1l2b : [0..worker2_maxRetry_t1l2b] init 0;
  worker2retry_t1l9 : [0..worker2_maxRetry_t1l9] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l2aRetry] worker2=1 & worker2retry_t1l2a < worker2_maxRetry_t1l2a -> p_worker2_t1l2a : (worker2'=worker2+1) + (1-p_worker2_t1l2a) : (worker2'=worker2) & (worker2retry_t1l2a' = worker2retry_t1l2a+1);
  [worker2dot1l2a] worker2=1 & worker2retry_t1l2a >= worker2_maxRetry_t1l2a -> 1:(worker2'=worker2Fail);
  [worker2dot1l2bRetry] worker2=2 & worker2retry_t1l2b < worker2_maxRetry_t1l2b -> p_worker2_t1l2b : (worker2'=worker2+1) + (1-p_worker2_t1l2b) : (worker2'=worker2) & (worker2retry_t1l2b' = worker2retry_t1l2b+1);
  [worker2dot1l2b] worker2=2 & worker2retry_t1l2b >= worker2_maxRetry_t1l2b -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=3-> 1:(worker2'=3+1);
  [worker2movel8] worker2=4-> 1:(worker2'=4+1);
  [worker2movel9] worker2=5-> 1:(worker2'=5+1);
  [worker2dot1l9Retry] worker2=6 & worker2retry_t1l9 < worker2_maxRetry_t1l9 -> p_worker2_t1l9 : (worker2'=worker2+1) + (1-p_worker2_t1l9) : (worker2'=worker2) & (worker2retry_t1l9' = worker2retry_t1l9+1);
  [worker2dot1l9] worker2=6 & worker2retry_t1l9 >= worker2_maxRetry_t1l9 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..12];
  r1retry_t3l2b : [0..r1_maxRetry_t3l2b] init 0;
  r1retry_t3l2c : [0..r1_maxRetry_t3l2c] init 0;
  r1retry_t2l5a : [0..r1_maxRetry_t2l5a] init 0;
  r1retry_t2l5b : [0..r1_maxRetry_t2l5b] init 0;
  r1retry_t2l8a : [0..r1_maxRetry_t2l8a] init 0;
  r1retry_t2l8c : [0..r1_maxRetry_t2l8c] init 0;
  r1retry_t2l8b : [0..r1_maxRetry_t2l8b] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1dot3l2bRetry] r1=1 & r1retry_t3l2b < r1_maxRetry_t3l2b -> p_r1_t3l2b : (r1'=r1+1) + (1-p_r1_t3l2b) : (r1'=r1) & (r1retry_t3l2b' = r1retry_t3l2b+1);
  [r1dot3l2b] r1=1 & r1retry_t3l2b >= r1_maxRetry_t3l2b -> 1:(r1'=r1Fail);
  [r1dot3l2cRetry] r1=2 & r1retry_t3l2c < r1_maxRetry_t3l2c -> p_r1_t3l2c : (r1'=r1+1) + (1-p_r1_t3l2c) : (r1'=r1) & (r1retry_t3l2c' = r1retry_t3l2c+1);
  [r1dot3l2c] r1=2 & r1retry_t3l2c >= r1_maxRetry_t3l2c -> 1:(r1'=r1Fail);
  [r1movel5] r1=3-> 1:(r1'=3+1);
  [r1dot2l5aRetry] r1=4 & r1retry_t2l5a < r1_maxRetry_t2l5a -> p_r1_t2l5a : (r1'=r1+1) + (1-p_r1_t2l5a) : (r1'=r1) & (r1retry_t2l5a' = r1retry_t2l5a+1);
  [r1dot2l5a] r1=4 & r1retry_t2l5a >= r1_maxRetry_t2l5a -> 1:(r1'=r1Fail);
  [r1dot2l5bRetry] r1=5 & r1retry_t2l5b < r1_maxRetry_t2l5b -> p_r1_t2l5b : (r1'=r1+1) + (1-p_r1_t2l5b) : (r1'=r1) & (r1retry_t2l5b' = r1retry_t2l5b+1);
  [r1dot2l5b] r1=5 & r1retry_t2l5b >= r1_maxRetry_t2l5b -> 1:(r1'=r1Fail);
  [r1movel8] r1=6-> 1:(r1'=6+1);
  [r1dot2l8aRetry] r1=7 & r1retry_t2l8a < r1_maxRetry_t2l8a -> p_r1_t2l8a : (r1'=r1+1) + (1-p_r1_t2l8a) : (r1'=r1) & (r1retry_t2l8a' = r1retry_t2l8a+1);
  [r1dot2l8a] r1=7 & r1retry_t2l8a >= r1_maxRetry_t2l8a -> 1:(r1'=r1Fail);
  [r1dot2l8cRetry] r1=8 & r1retry_t2l8c < r1_maxRetry_t2l8c -> p_r1_t2l8c : (r1'=r1+1) + (1-p_r1_t2l8c) : (r1'=r1) & (r1retry_t2l8c' = r1retry_t2l8c+1);
  [r1dot2l8c] r1=8 & r1retry_t2l8c >= r1_maxRetry_t2l8c -> 1:(r1'=r1Fail);
  [r1dot2l8bRetry] r1=9 & r1retry_t2l8b < r1_maxRetry_t2l8b -> p_r1_t2l8b : (r1'=r1+1) + (1-p_r1_t2l8b) : (r1'=r1) & (r1retry_t2l8b' = r1retry_t2l8b+1);
  [r1dot2l8b] r1=9 & r1retry_t2l8b >= r1_maxRetry_t2l8b -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..6];
  r2retry_t3l2a : [0..r2_maxRetry_t3l2a] init 0;
  r2retry_t2l3 : [0..r2_maxRetry_t2l3] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2dot3l2aRetry] r2=1 & r2retry_t3l2a < r2_maxRetry_t3l2a -> p_r2_t3l2a : (r2'=r2+1) + (1-p_r2_t3l2a) : (r2'=r2) & (r2retry_t3l2a' = r2retry_t3l2a+1);
  [r2dot3l2a] r2=1 & r2retry_t3l2a >= r2_maxRetry_t3l2a -> 1:(r2'=r2Fail);
  [r2movel3] r2=2-> 1:(r2'=2+1);
  [r2dot2l3Retry] r2=3 & r2retry_t2l3 < r2_maxRetry_t2l3 -> p_r2_t2l3 : (r2'=r2+1) + (1-p_r2_t2l3) : (r2'=r2) & (r2retry_t2l3' = r2retry_t2l3+1);
  [r2dot2l3] r2=3 & r2retry_t2l3 >= r2_maxRetry_t2l3 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..3];
  worker1retry_t3l1 : [0..worker1_maxRetry_t3l1] init 0;

  [worker1dot3l1Retry] worker1=0 & worker1retry_t3l1 < worker1_maxRetry_t3l1 -> p_worker1_t3l1 : (worker1'=worker1+1) + (1-p_worker1_t3l1) : (worker1'=worker1) & (worker1retry_t3l1' = worker1retry_t3l1+1);
  [worker1dot3l1] worker1=0 & worker1retry_t3l1 >= worker1_maxRetry_t3l1 -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [worker2movel2] true:1;
  [worker2dot1l2a] true:3;
  [worker2dot1l2aRetry] true:3;
  [worker2dot1l2b] true:3;
  [worker2dot1l2bRetry] true:3;
  [worker2movel5] true:1;
  [worker2movel8] true:1;
  [worker2movel9] true:1;
  [worker2dot1l9] true:3;
  [worker2dot1l9Retry] true:3;
  [r1movel2] true:1;
  [r1dot3l2b] true:1;
  [r1dot3l2bRetry] true:1;
  [r1dot3l2c] true:1;
  [r1dot3l2cRetry] true:1;
  [r1movel5] true:1;
  [r1dot2l5a] true:1;
  [r1dot2l5aRetry] true:1;
  [r1dot2l5b] true:1;
  [r1dot2l5bRetry] true:1;
  [r1movel8] true:1;
  [r1dot2l8a] true:1;
  [r1dot2l8aRetry] true:1;
  [r1dot2l8c] true:1;
  [r1dot2l8cRetry] true:1;
  [r1dot2l8b] true:1;
  [r1dot2l8bRetry] true:1;
  [r2movel2] true:1;
  [r2dot3l2a] true:1;
  [r2dot3l2aRetry] true:1;
  [r2movel3] true:1;
  [r2dot2l3] true:1;
  [r2dot2l3Retry] true:1;
  [worker1dot3l1] true:5;
  [worker1dot3l1Retry] true:5;
endrewards