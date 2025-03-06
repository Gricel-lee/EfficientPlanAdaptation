dtmc
evolve int worker2_maxRetry_t1l4 [1..5];
evolve int worker2_maxRetry_t1l7 [1..5];
evolve int worker2_maxRetry_t3l8 [1..5];
evolve int worker2_maxRetry_t1l8 [1..5];
evolve int worker2_maxRetry_t3l5 [1..5];
evolve int r1_maxRetry_t2l2b [1..10];
evolve int r1_maxRetry_t2l2a [1..10];
evolve int r1_maxRetry_t3l2 [1..10];
evolve int r1_maxRetry_t2l3 [1..10];
evolve int r2_maxRetry_t2l1b [1..10];
evolve int r2_maxRetry_t3l1 [1..10];
evolve int r2_maxRetry_t2l1a [1..10];
evolve int worker1_maxRetry_t1l1 [1..5];

const double p_worker2_t1l4=1.0;
const double p_worker2_t1l7=1.0;
const double p_worker2_t3l8=0.99;
const double p_worker2_t1l8=1.0;
const double p_worker2_t3l5=0.99;
const double p_r1_t2l2b=0.99;
const double p_r1_t2l2a=0.99;
const double p_r1_t3l2=0.97;
const double p_r1_t2l3=0.99;
const double p_r2_t2l1b=0.99;
const double p_r2_t3l1=0.97;
const double p_r2_t2l1a=0.99;
const double p_worker1_t1l1=1.0;
const int worker2Final = 9;
const int worker2Fail = 10;
const int r1Final = 6;
const int r1Fail = 7;
const int r2Final = 3;
const int r2Fail = 4;
const int worker1Final = 1;
const int worker1Fail = 2;

module _worker2
  worker2 : [0..11];
  worker2retry_t1l4 : [0..worker2_maxRetry_t1l4] init 0;
  worker2retry_t1l7 : [0..worker2_maxRetry_t1l7] init 0;
  worker2retry_t3l8 : [0..worker2_maxRetry_t3l8] init 0;
  worker2retry_t1l8 : [0..worker2_maxRetry_t1l8] init 0;
  worker2retry_t3l5 : [0..worker2_maxRetry_t3l5] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l4Retry] worker2=1 & worker2retry_t1l4 < worker2_maxRetry_t1l4 -> p_worker2_t1l4 : (worker2'=worker2+1) + (1-p_worker2_t1l4) : (worker2'=worker2) & (worker2retry_t1l4' = worker2retry_t1l4+1);
  [worker2dot1l4] worker2=1 & worker2retry_t1l4 >= worker2_maxRetry_t1l4 -> 1:(worker2'=worker2Fail);
  [worker2movel7] worker2=2-> 1:(worker2'=2+1);
  [worker2dot1l7Retry] worker2=3 & worker2retry_t1l7 < worker2_maxRetry_t1l7 -> p_worker2_t1l7 : (worker2'=worker2+1) + (1-p_worker2_t1l7) : (worker2'=worker2) & (worker2retry_t1l7' = worker2retry_t1l7+1);
  [worker2dot1l7] worker2=3 & worker2retry_t1l7 >= worker2_maxRetry_t1l7 -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=4-> 1:(worker2'=4+1);
  [worker2dot3l8Retry] worker2=5 & worker2retry_t3l8 < worker2_maxRetry_t3l8 -> p_worker2_t3l8 : (worker2'=worker2+1) + (1-p_worker2_t3l8) : (worker2'=worker2) & (worker2retry_t3l8' = worker2retry_t3l8+1);
  [worker2dot3l8] worker2=5 & worker2retry_t3l8 >= worker2_maxRetry_t3l8 -> 1:(worker2'=worker2Fail);
  [worker2dot1l8Retry] worker2=6 & worker2retry_t1l8 < worker2_maxRetry_t1l8 -> p_worker2_t1l8 : (worker2'=worker2+1) + (1-p_worker2_t1l8) : (worker2'=worker2) & (worker2retry_t1l8' = worker2retry_t1l8+1);
  [worker2dot1l8] worker2=6 & worker2retry_t1l8 >= worker2_maxRetry_t1l8 -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=7-> 1:(worker2'=7+1);
  [worker2dot3l5Retry] worker2=8 & worker2retry_t3l5 < worker2_maxRetry_t3l5 -> p_worker2_t3l5 : (worker2'=worker2+1) + (1-p_worker2_t3l5) : (worker2'=worker2) & (worker2retry_t3l5' = worker2retry_t3l5+1);
  [worker2dot3l5] worker2=8 & worker2retry_t3l5 >= worker2_maxRetry_t3l5 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..8];
  r1retry_t2l2b : [0..r1_maxRetry_t2l2b] init 0;
  r1retry_t2l2a : [0..r1_maxRetry_t2l2a] init 0;
  r1retry_t3l2 : [0..r1_maxRetry_t3l2] init 0;
  r1retry_t2l3 : [0..r1_maxRetry_t2l3] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1dot2l2bRetry] r1=1 & r1retry_t2l2b < r1_maxRetry_t2l2b -> p_r1_t2l2b : (r1'=r1+1) + (1-p_r1_t2l2b) : (r1'=r1) & (r1retry_t2l2b' = r1retry_t2l2b+1);
  [r1dot2l2b] r1=1 & r1retry_t2l2b >= r1_maxRetry_t2l2b -> 1:(r1'=r1Fail);
  [r1dot2l2aRetry] r1=2 & r1retry_t2l2a < r1_maxRetry_t2l2a -> p_r1_t2l2a : (r1'=r1+1) + (1-p_r1_t2l2a) : (r1'=r1) & (r1retry_t2l2a' = r1retry_t2l2a+1);
  [r1dot2l2a] r1=2 & r1retry_t2l2a >= r1_maxRetry_t2l2a -> 1:(r1'=r1Fail);
  [r1dot3l2Retry] r1=3 & r1retry_t3l2 < r1_maxRetry_t3l2 -> p_r1_t3l2 : (r1'=r1+1) + (1-p_r1_t3l2) : (r1'=r1) & (r1retry_t3l2' = r1retry_t3l2+1);
  [r1dot3l2] r1=3 & r1retry_t3l2 >= r1_maxRetry_t3l2 -> 1:(r1'=r1Fail);
  [r1movel3] r1=4-> 1:(r1'=4+1);
  [r1dot2l3Retry] r1=5 & r1retry_t2l3 < r1_maxRetry_t2l3 -> p_r1_t2l3 : (r1'=r1+1) + (1-p_r1_t2l3) : (r1'=r1) & (r1retry_t2l3' = r1retry_t2l3+1);
  [r1dot2l3] r1=5 & r1retry_t2l3 >= r1_maxRetry_t2l3 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..5];
  r2retry_t2l1b : [0..r2_maxRetry_t2l1b] init 0;
  r2retry_t3l1 : [0..r2_maxRetry_t3l1] init 0;
  r2retry_t2l1a : [0..r2_maxRetry_t2l1a] init 0;

  [r2dot2l1bRetry] r2=0 & r2retry_t2l1b < r2_maxRetry_t2l1b -> p_r2_t2l1b : (r2'=r2+1) + (1-p_r2_t2l1b) : (r2'=r2) & (r2retry_t2l1b' = r2retry_t2l1b+1);
  [r2dot2l1b] r2=0 & r2retry_t2l1b >= r2_maxRetry_t2l1b -> 1:(r2'=r2Fail);
  [r2dot3l1Retry] r2=1 & r2retry_t3l1 < r2_maxRetry_t3l1 -> p_r2_t3l1 : (r2'=r2+1) + (1-p_r2_t3l1) : (r2'=r2) & (r2retry_t3l1' = r2retry_t3l1+1);
  [r2dot3l1] r2=1 & r2retry_t3l1 >= r2_maxRetry_t3l1 -> 1:(r2'=r2Fail);
  [r2dot2l1aRetry] r2=2 & r2retry_t2l1a < r2_maxRetry_t2l1a -> p_r2_t2l1a : (r2'=r2+1) + (1-p_r2_t2l1a) : (r2'=r2) & (r2retry_t2l1a' = r2retry_t2l1a+1);
  [r2dot2l1a] r2=2 & r2retry_t2l1a >= r2_maxRetry_t2l1a -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..3];
  worker1retry_t1l1 : [0..worker1_maxRetry_t1l1] init 0;

  [worker1dot1l1Retry] worker1=0 & worker1retry_t1l1 < worker1_maxRetry_t1l1 -> p_worker1_t1l1 : (worker1'=worker1+1) + (1-p_worker1_t1l1) : (worker1'=worker1) & (worker1retry_t1l1' = worker1retry_t1l1+1);
  [worker1dot1l1] worker1=0 & worker1retry_t1l1 >= worker1_maxRetry_t1l1 -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [worker2movel4] true:1;
  [worker2dot1l4] true:3;
  [worker2dot1l4Retry] true:3;
  [worker2movel7] true:1;
  [worker2dot1l7] true:3;
  [worker2dot1l7Retry] true:3;
  [worker2movel8] true:1;
  [worker2dot3l8] true:5;
  [worker2dot3l8Retry] true:5;
  [worker2dot1l8] true:3;
  [worker2dot1l8Retry] true:3;
  [worker2movel5] true:1;
  [worker2dot3l5] true:5;
  [worker2dot3l5Retry] true:5;
  [r1movel2] true:1;
  [r1dot2l2b] true:1;
  [r1dot2l2bRetry] true:1;
  [r1dot2l2a] true:1;
  [r1dot2l2aRetry] true:1;
  [r1dot3l2] true:1;
  [r1dot3l2Retry] true:1;
  [r1movel3] true:1;
  [r1dot2l3] true:1;
  [r1dot2l3Retry] true:1;
  [r2dot2l1b] true:1;
  [r2dot2l1bRetry] true:1;
  [r2dot3l1] true:1;
  [r2dot3l1Retry] true:1;
  [r2dot2l1a] true:1;
  [r2dot2l1aRetry] true:1;
  [worker1dot1l1] true:3;
  [worker1dot1l1Retry] true:3;
endrewards