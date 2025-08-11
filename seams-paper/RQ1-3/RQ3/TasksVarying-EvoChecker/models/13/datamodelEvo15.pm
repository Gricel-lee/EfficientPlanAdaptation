dtmc
evolve int worker2_maxRetry_t1l1b [1..5];
evolve int worker2_maxRetry_t1l1a [1..5];
evolve int worker2_maxRetry_t1l3 [1..5];
evolve int r1_maxRetry_t2l1 [1..10];
evolve int worker1_maxRetry_t1l2 [1..5];
evolve int worker1_maxRetry_t3l2a [1..5];
evolve int worker1_maxRetry_t3l2b [1..5];
evolve int worker1_maxRetry_t1l5a [1..5];
evolve int worker1_maxRetry_t1l5c [1..5];
evolve int worker1_maxRetry_t1l5b [1..5];
evolve int worker1_maxRetry_t1l8 [1..5];
evolve int worker1_maxRetry_t3l7 [1..5];
evolve int worker1_maxRetry_t1l7 [1..5];

const double p_worker2_t1l1b=1.0;
const double p_worker2_t1l1a=1.0;
const double p_worker2_t1l3=1.0;
const double p_r1_t2l1=0.99;
const double p_worker1_t1l2=1.0;
const double p_worker1_t3l2a=0.99;
const double p_worker1_t3l2b=0.99;
const double p_worker1_t1l5a=1.0;
const double p_worker1_t1l5c=1.0;
const double p_worker1_t1l5b=1.0;
const double p_worker1_t1l8=1.0;
const double p_worker1_t3l7=0.99;
const double p_worker1_t1l7=1.0;
const int worker2Final = 5;
const int worker2Fail = 6;
const int r1Final = 1;
const int r1Fail = 2;
const int worker1Final = 13;
const int worker1Fail = 14;

module _worker2
  worker2 : [0..7];
  worker2retry_t1l1b : [0..worker2_maxRetry_t1l1b] init 0;
  worker2retry_t1l1a : [0..worker2_maxRetry_t1l1a] init 0;
  worker2retry_t1l3 : [0..worker2_maxRetry_t1l3] init 0;

  [worker2dot1l1bRetry] worker2=0 & worker2retry_t1l1b < worker2_maxRetry_t1l1b -> p_worker2_t1l1b : (worker2'=worker2+1) + (1-p_worker2_t1l1b) : (worker2'=worker2) & (worker2retry_t1l1b' = worker2retry_t1l1b+1);
  [worker2dot1l1b] worker2=0 & worker2retry_t1l1b >= worker2_maxRetry_t1l1b -> 1:(worker2'=worker2Fail);
  [worker2dot1l1aRetry] worker2=1 & worker2retry_t1l1a < worker2_maxRetry_t1l1a -> p_worker2_t1l1a : (worker2'=worker2+1) + (1-p_worker2_t1l1a) : (worker2'=worker2) & (worker2retry_t1l1a' = worker2retry_t1l1a+1);
  [worker2dot1l1a] worker2=1 & worker2retry_t1l1a >= worker2_maxRetry_t1l1a -> 1:(worker2'=worker2Fail);
  [worker2movel2] worker2=2-> 1:(worker2'=2+1);
  [worker2movel3] worker2=3-> 1:(worker2'=3+1);
  [worker2dot1l3Retry] worker2=4 & worker2retry_t1l3 < worker2_maxRetry_t1l3 -> p_worker2_t1l3 : (worker2'=worker2+1) + (1-p_worker2_t1l3) : (worker2'=worker2) & (worker2retry_t1l3' = worker2retry_t1l3+1);
  [worker2dot1l3] worker2=4 & worker2retry_t1l3 >= worker2_maxRetry_t1l3 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..3];
  r1retry_t2l1 : [0..r1_maxRetry_t2l1] init 0;

  [r1dot2l1Retry] r1=0 & r1retry_t2l1 < r1_maxRetry_t2l1 -> p_r1_t2l1 : (r1'=r1+1) + (1-p_r1_t2l1) : (r1'=r1) & (r1retry_t2l1' = r1retry_t2l1+1);
  [r1dot2l1] r1=0 & r1retry_t2l1 >= r1_maxRetry_t2l1 -> 1:(r1'=r1Fail);
endmodule

module _worker1
  worker1 : [0..15];
  worker1retry_t1l2 : [0..worker1_maxRetry_t1l2] init 0;
  worker1retry_t3l2a : [0..worker1_maxRetry_t3l2a] init 0;
  worker1retry_t3l2b : [0..worker1_maxRetry_t3l2b] init 0;
  worker1retry_t1l5a : [0..worker1_maxRetry_t1l5a] init 0;
  worker1retry_t1l5c : [0..worker1_maxRetry_t1l5c] init 0;
  worker1retry_t1l5b : [0..worker1_maxRetry_t1l5b] init 0;
  worker1retry_t1l8 : [0..worker1_maxRetry_t1l8] init 0;
  worker1retry_t3l7 : [0..worker1_maxRetry_t3l7] init 0;
  worker1retry_t1l7 : [0..worker1_maxRetry_t1l7] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l2Retry] worker1=1 & worker1retry_t1l2 < worker1_maxRetry_t1l2 -> p_worker1_t1l2 : (worker1'=worker1+1) + (1-p_worker1_t1l2) : (worker1'=worker1) & (worker1retry_t1l2' = worker1retry_t1l2+1);
  [worker1dot1l2] worker1=1 & worker1retry_t1l2 >= worker1_maxRetry_t1l2 -> 1:(worker1'=worker1Fail);
  [worker1dot3l2aRetry] worker1=2 & worker1retry_t3l2a < worker1_maxRetry_t3l2a -> p_worker1_t3l2a : (worker1'=worker1+1) + (1-p_worker1_t3l2a) : (worker1'=worker1) & (worker1retry_t3l2a' = worker1retry_t3l2a+1);
  [worker1dot3l2a] worker1=2 & worker1retry_t3l2a >= worker1_maxRetry_t3l2a -> 1:(worker1'=worker1Fail);
  [worker1dot3l2bRetry] worker1=3 & worker1retry_t3l2b < worker1_maxRetry_t3l2b -> p_worker1_t3l2b : (worker1'=worker1+1) + (1-p_worker1_t3l2b) : (worker1'=worker1) & (worker1retry_t3l2b' = worker1retry_t3l2b+1);
  [worker1dot3l2b] worker1=3 & worker1retry_t3l2b >= worker1_maxRetry_t3l2b -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=4-> 1:(worker1'=4+1);
  [worker1dot1l5aRetry] worker1=5 & worker1retry_t1l5a < worker1_maxRetry_t1l5a -> p_worker1_t1l5a : (worker1'=worker1+1) + (1-p_worker1_t1l5a) : (worker1'=worker1) & (worker1retry_t1l5a' = worker1retry_t1l5a+1);
  [worker1dot1l5a] worker1=5 & worker1retry_t1l5a >= worker1_maxRetry_t1l5a -> 1:(worker1'=worker1Fail);
  [worker1dot1l5cRetry] worker1=6 & worker1retry_t1l5c < worker1_maxRetry_t1l5c -> p_worker1_t1l5c : (worker1'=worker1+1) + (1-p_worker1_t1l5c) : (worker1'=worker1) & (worker1retry_t1l5c' = worker1retry_t1l5c+1);
  [worker1dot1l5c] worker1=6 & worker1retry_t1l5c >= worker1_maxRetry_t1l5c -> 1:(worker1'=worker1Fail);
  [worker1dot1l5bRetry] worker1=7 & worker1retry_t1l5b < worker1_maxRetry_t1l5b -> p_worker1_t1l5b : (worker1'=worker1+1) + (1-p_worker1_t1l5b) : (worker1'=worker1) & (worker1retry_t1l5b' = worker1retry_t1l5b+1);
  [worker1dot1l5b] worker1=7 & worker1retry_t1l5b >= worker1_maxRetry_t1l5b -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=8-> 1:(worker1'=8+1);
  [worker1dot1l8Retry] worker1=9 & worker1retry_t1l8 < worker1_maxRetry_t1l8 -> p_worker1_t1l8 : (worker1'=worker1+1) + (1-p_worker1_t1l8) : (worker1'=worker1) & (worker1retry_t1l8' = worker1retry_t1l8+1);
  [worker1dot1l8] worker1=9 & worker1retry_t1l8 >= worker1_maxRetry_t1l8 -> 1:(worker1'=worker1Fail);
  [worker1movel7] worker1=10-> 1:(worker1'=10+1);
  [worker1dot3l7Retry] worker1=11 & worker1retry_t3l7 < worker1_maxRetry_t3l7 -> p_worker1_t3l7 : (worker1'=worker1+1) + (1-p_worker1_t3l7) : (worker1'=worker1) & (worker1retry_t3l7' = worker1retry_t3l7+1);
  [worker1dot3l7] worker1=11 & worker1retry_t3l7 >= worker1_maxRetry_t3l7 -> 1:(worker1'=worker1Fail);
  [worker1dot1l7Retry] worker1=12 & worker1retry_t1l7 < worker1_maxRetry_t1l7 -> p_worker1_t1l7 : (worker1'=worker1+1) + (1-p_worker1_t1l7) : (worker1'=worker1) & (worker1retry_t1l7' = worker1retry_t1l7+1);
  [worker1dot1l7] worker1=12 & worker1retry_t1l7 >= worker1_maxRetry_t1l7 -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [worker2dot1l1b] true:3;
  [worker2dot1l1bRetry] true:3;
  [worker2dot1l1a] true:3;
  [worker2dot1l1aRetry] true:3;
  [worker2movel2] true:1;
  [worker2movel3] true:1;
  [worker2dot1l3] true:3;
  [worker2dot1l3Retry] true:3;
  [r1dot2l1] true:1;
  [r1dot2l1Retry] true:1;
  [worker1movel2] true:1;
  [worker1dot1l2] true:3;
  [worker1dot1l2Retry] true:3;
  [worker1dot3l2a] true:5;
  [worker1dot3l2aRetry] true:5;
  [worker1dot3l2b] true:5;
  [worker1dot3l2bRetry] true:5;
  [worker1movel5] true:1;
  [worker1dot1l5a] true:3;
  [worker1dot1l5aRetry] true:3;
  [worker1dot1l5c] true:3;
  [worker1dot1l5cRetry] true:3;
  [worker1dot1l5b] true:3;
  [worker1dot1l5bRetry] true:3;
  [worker1movel8] true:1;
  [worker1dot1l8] true:3;
  [worker1dot1l8Retry] true:3;
  [worker1movel7] true:1;
  [worker1dot3l7] true:5;
  [worker1dot3l7Retry] true:5;
  [worker1dot1l7] true:3;
  [worker1dot1l7Retry] true:3;
endrewards