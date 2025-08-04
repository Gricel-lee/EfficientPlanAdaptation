dtmc
evolve int worker1_maxRetry_t3l4b [1..5];
evolve int worker1_maxRetry_t3l4a [1..5];
evolve int worker1_maxRetry_t3l5 [1..5];
evolve int worker1_maxRetry_t1l8b [1..5];
evolve int worker1_maxRetry_t1l8a [1..5];
evolve int r1_maxRetry_t3l2 [1..10];
evolve int r1_maxRetry_t2l3 [1..10];
evolve int r1_maxRetry_t3l6 [1..10];
evolve int r2_maxRetry_t2l1b [1..10];
evolve int r2_maxRetry_t2l1a [1..10];

const double p_worker1_t3l4b=0.99;
const double p_worker1_t3l4a=0.99;
const double p_worker1_t3l5=0.99;
const double p_worker1_t1l8b=1.0;
const double p_worker1_t1l8a=1.0;
const double p_r1_t3l2=0.97;
const double p_r1_t2l3=0.99;
const double p_r1_t3l6=0.97;
const double p_r2_t2l1b=0.99;
const double p_r2_t2l1a=0.99;
const int worker1Final = 8;
const int worker1Fail = 9;
const int r1Final = 6;
const int r1Fail = 7;
const int r2Final = 2;
const int r2Fail = 3;

module _worker1
  worker1 : [0..10];
  worker1retry_t3l4b : [0..worker1_maxRetry_t3l4b] init 0;
  worker1retry_t3l4a : [0..worker1_maxRetry_t3l4a] init 0;
  worker1retry_t3l5 : [0..worker1_maxRetry_t3l5] init 0;
  worker1retry_t1l8b : [0..worker1_maxRetry_t1l8b] init 0;
  worker1retry_t1l8a : [0..worker1_maxRetry_t1l8a] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot3l4bRetry] worker1=1 & worker1retry_t3l4b < worker1_maxRetry_t3l4b -> p_worker1_t3l4b : (worker1'=worker1+1) + (1-p_worker1_t3l4b) : (worker1'=worker1) & (worker1retry_t3l4b' = worker1retry_t3l4b+1);
  [worker1dot3l4b] worker1=1 & worker1retry_t3l4b >= worker1_maxRetry_t3l4b -> 1:(worker1'=worker1Fail);
  [worker1dot3l4aRetry] worker1=2 & worker1retry_t3l4a < worker1_maxRetry_t3l4a -> p_worker1_t3l4a : (worker1'=worker1+1) + (1-p_worker1_t3l4a) : (worker1'=worker1) & (worker1retry_t3l4a' = worker1retry_t3l4a+1);
  [worker1dot3l4a] worker1=2 & worker1retry_t3l4a >= worker1_maxRetry_t3l4a -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=3-> 1:(worker1'=3+1);
  [worker1dot3l5Retry] worker1=4 & worker1retry_t3l5 < worker1_maxRetry_t3l5 -> p_worker1_t3l5 : (worker1'=worker1+1) + (1-p_worker1_t3l5) : (worker1'=worker1) & (worker1retry_t3l5' = worker1retry_t3l5+1);
  [worker1dot3l5] worker1=4 & worker1retry_t3l5 >= worker1_maxRetry_t3l5 -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=5-> 1:(worker1'=5+1);
  [worker1dot1l8bRetry] worker1=6 & worker1retry_t1l8b < worker1_maxRetry_t1l8b -> p_worker1_t1l8b : (worker1'=worker1+1) + (1-p_worker1_t1l8b) : (worker1'=worker1) & (worker1retry_t1l8b' = worker1retry_t1l8b+1);
  [worker1dot1l8b] worker1=6 & worker1retry_t1l8b >= worker1_maxRetry_t1l8b -> 1:(worker1'=worker1Fail);
  [worker1dot1l8aRetry] worker1=7 & worker1retry_t1l8a < worker1_maxRetry_t1l8a -> p_worker1_t1l8a : (worker1'=worker1+1) + (1-p_worker1_t1l8a) : (worker1'=worker1) & (worker1retry_t1l8a' = worker1retry_t1l8a+1);
  [worker1dot1l8a] worker1=7 & worker1retry_t1l8a >= worker1_maxRetry_t1l8a -> 1:(worker1'=worker1Fail);
endmodule

module _r1
  r1 : [0..8];
  r1retry_t3l2 : [0..r1_maxRetry_t3l2] init 0;
  r1retry_t2l3 : [0..r1_maxRetry_t2l3] init 0;
  r1retry_t3l6 : [0..r1_maxRetry_t3l6] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1dot3l2Retry] r1=1 & r1retry_t3l2 < r1_maxRetry_t3l2 -> p_r1_t3l2 : (r1'=r1+1) + (1-p_r1_t3l2) : (r1'=r1) & (r1retry_t3l2' = r1retry_t3l2+1);
  [r1dot3l2] r1=1 & r1retry_t3l2 >= r1_maxRetry_t3l2 -> 1:(r1'=r1Fail);
  [r1movel3] r1=2-> 1:(r1'=2+1);
  [r1dot2l3Retry] r1=3 & r1retry_t2l3 < r1_maxRetry_t2l3 -> p_r1_t2l3 : (r1'=r1+1) + (1-p_r1_t2l3) : (r1'=r1) & (r1retry_t2l3' = r1retry_t2l3+1);
  [r1dot2l3] r1=3 & r1retry_t2l3 >= r1_maxRetry_t2l3 -> 1:(r1'=r1Fail);
  [r1movel6] r1=4-> 1:(r1'=4+1);
  [r1dot3l6Retry] r1=5 & r1retry_t3l6 < r1_maxRetry_t3l6 -> p_r1_t3l6 : (r1'=r1+1) + (1-p_r1_t3l6) : (r1'=r1) & (r1retry_t3l6' = r1retry_t3l6+1);
  [r1dot3l6] r1=5 & r1retry_t3l6 >= r1_maxRetry_t3l6 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..4];
  r2retry_t2l1b : [0..r2_maxRetry_t2l1b] init 0;
  r2retry_t2l1a : [0..r2_maxRetry_t2l1a] init 0;

  [r2dot2l1bRetry] r2=0 & r2retry_t2l1b < r2_maxRetry_t2l1b -> p_r2_t2l1b : (r2'=r2+1) + (1-p_r2_t2l1b) : (r2'=r2) & (r2retry_t2l1b' = r2retry_t2l1b+1);
  [r2dot2l1b] r2=0 & r2retry_t2l1b >= r2_maxRetry_t2l1b -> 1:(r2'=r2Fail);
  [r2dot2l1aRetry] r2=1 & r2retry_t2l1a < r2_maxRetry_t2l1a -> p_r2_t2l1a : (r2'=r2+1) + (1-p_r2_t2l1a) : (r2'=r2) & (r2retry_t2l1a' = r2retry_t2l1a+1);
  [r2dot2l1a] r2=1 & r2retry_t2l1a >= r2_maxRetry_t2l1a -> 1:(r2'=r2Fail);
endmodule

rewards "cost"
  [worker1movel4] true:1;
  [worker1dot3l4b] true:5;
  [worker1dot3l4bRetry] true:5;
  [worker1dot3l4a] true:5;
  [worker1dot3l4aRetry] true:5;
  [worker1movel5] true:1;
  [worker1dot3l5] true:5;
  [worker1dot3l5Retry] true:5;
  [worker1movel8] true:1;
  [worker1dot1l8b] true:3;
  [worker1dot1l8bRetry] true:3;
  [worker1dot1l8a] true:3;
  [worker1dot1l8aRetry] true:3;
  [r1movel2] true:1;
  [r1dot3l2] true:1;
  [r1dot3l2Retry] true:1;
  [r1movel3] true:1;
  [r1dot2l3] true:1;
  [r1dot2l3Retry] true:1;
  [r1movel6] true:1;
  [r1dot3l6] true:1;
  [r1dot3l6Retry] true:1;
  [r2dot2l1b] true:1;
  [r2dot2l1bRetry] true:1;
  [r2dot2l1a] true:1;
  [r2dot2l1aRetry] true:1;
endrewards