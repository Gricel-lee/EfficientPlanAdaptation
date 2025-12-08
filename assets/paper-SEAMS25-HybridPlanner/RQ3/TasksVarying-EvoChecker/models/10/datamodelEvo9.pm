dtmc
evolve int worker1_maxRetry_t3l1a [1..5];
evolve int worker1_maxRetry_t3l1b [1..5];
evolve int worker2_maxRetry_t1l2 [1..5];
evolve int worker2_maxRetry_t1l8 [1..5];
evolve int worker2_maxRetry_t1l9 [1..5];
evolve int r1_maxRetry_t2l4 [1..10];
evolve int r1_maxRetry_t2l7d [1..10];
evolve int r1_maxRetry_t2l7c [1..10];
evolve int r1_maxRetry_t2l7a [1..10];
evolve int r1_maxRetry_t2l7b [1..10];

const double p_worker1_t3l1a=0.99;
const double p_worker1_t3l1b=0.99;
const double p_worker2_t1l2=1.0;
const double p_worker2_t1l8=1.0;
const double p_worker2_t1l9=1.0;
const double p_r1_t2l4=0.99;
const double p_r1_t2l7d=0.99;
const double p_r1_t2l7c=0.99;
const double p_r1_t2l7a=0.99;
const double p_r1_t2l7b=0.99;
const int worker1Final = 2;
const int worker1Fail = 3;
const int worker2Final = 7;
const int worker2Fail = 8;
const int r1Final = 7;
const int r1Fail = 8;

module _worker1
  worker1 : [0..4];
  worker1retry_t3l1a : [0..worker1_maxRetry_t3l1a] init 0;
  worker1retry_t3l1b : [0..worker1_maxRetry_t3l1b] init 0;

  [worker1dot3l1aRetry] worker1=0 & worker1retry_t3l1a < worker1_maxRetry_t3l1a -> p_worker1_t3l1a : (worker1'=worker1+1) + (1-p_worker1_t3l1a) : (worker1'=worker1) & (worker1retry_t3l1a' = worker1retry_t3l1a+1);
  [worker1dot3l1a] worker1=0 & worker1retry_t3l1a >= worker1_maxRetry_t3l1a -> 1:(worker1'=worker1Fail);
  [worker1dot3l1bRetry] worker1=1 & worker1retry_t3l1b < worker1_maxRetry_t3l1b -> p_worker1_t3l1b : (worker1'=worker1+1) + (1-p_worker1_t3l1b) : (worker1'=worker1) & (worker1retry_t3l1b' = worker1retry_t3l1b+1);
  [worker1dot3l1b] worker1=1 & worker1retry_t3l1b >= worker1_maxRetry_t3l1b -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..9];
  worker2retry_t1l2 : [0..worker2_maxRetry_t1l2] init 0;
  worker2retry_t1l8 : [0..worker2_maxRetry_t1l8] init 0;
  worker2retry_t1l9 : [0..worker2_maxRetry_t1l9] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l2Retry] worker2=1 & worker2retry_t1l2 < worker2_maxRetry_t1l2 -> p_worker2_t1l2 : (worker2'=worker2+1) + (1-p_worker2_t1l2) : (worker2'=worker2) & (worker2retry_t1l2' = worker2retry_t1l2+1);
  [worker2dot1l2] worker2=1 & worker2retry_t1l2 >= worker2_maxRetry_t1l2 -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=2-> 1:(worker2'=2+1);
  [worker2movel8] worker2=3-> 1:(worker2'=3+1);
  [worker2dot1l8Retry] worker2=4 & worker2retry_t1l8 < worker2_maxRetry_t1l8 -> p_worker2_t1l8 : (worker2'=worker2+1) + (1-p_worker2_t1l8) : (worker2'=worker2) & (worker2retry_t1l8' = worker2retry_t1l8+1);
  [worker2dot1l8] worker2=4 & worker2retry_t1l8 >= worker2_maxRetry_t1l8 -> 1:(worker2'=worker2Fail);
  [worker2movel9] worker2=5-> 1:(worker2'=5+1);
  [worker2dot1l9Retry] worker2=6 & worker2retry_t1l9 < worker2_maxRetry_t1l9 -> p_worker2_t1l9 : (worker2'=worker2+1) + (1-p_worker2_t1l9) : (worker2'=worker2) & (worker2retry_t1l9' = worker2retry_t1l9+1);
  [worker2dot1l9] worker2=6 & worker2retry_t1l9 >= worker2_maxRetry_t1l9 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..9];
  r1retry_t2l4 : [0..r1_maxRetry_t2l4] init 0;
  r1retry_t2l7d : [0..r1_maxRetry_t2l7d] init 0;
  r1retry_t2l7c : [0..r1_maxRetry_t2l7c] init 0;
  r1retry_t2l7a : [0..r1_maxRetry_t2l7a] init 0;
  r1retry_t2l7b : [0..r1_maxRetry_t2l7b] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1dot2l4Retry] r1=1 & r1retry_t2l4 < r1_maxRetry_t2l4 -> p_r1_t2l4 : (r1'=r1+1) + (1-p_r1_t2l4) : (r1'=r1) & (r1retry_t2l4' = r1retry_t2l4+1);
  [r1dot2l4] r1=1 & r1retry_t2l4 >= r1_maxRetry_t2l4 -> 1:(r1'=r1Fail);
  [r1movel7] r1=2-> 1:(r1'=2+1);
  [r1dot2l7dRetry] r1=3 & r1retry_t2l7d < r1_maxRetry_t2l7d -> p_r1_t2l7d : (r1'=r1+1) + (1-p_r1_t2l7d) : (r1'=r1) & (r1retry_t2l7d' = r1retry_t2l7d+1);
  [r1dot2l7d] r1=3 & r1retry_t2l7d >= r1_maxRetry_t2l7d -> 1:(r1'=r1Fail);
  [r1dot2l7cRetry] r1=4 & r1retry_t2l7c < r1_maxRetry_t2l7c -> p_r1_t2l7c : (r1'=r1+1) + (1-p_r1_t2l7c) : (r1'=r1) & (r1retry_t2l7c' = r1retry_t2l7c+1);
  [r1dot2l7c] r1=4 & r1retry_t2l7c >= r1_maxRetry_t2l7c -> 1:(r1'=r1Fail);
  [r1dot2l7aRetry] r1=5 & r1retry_t2l7a < r1_maxRetry_t2l7a -> p_r1_t2l7a : (r1'=r1+1) + (1-p_r1_t2l7a) : (r1'=r1) & (r1retry_t2l7a' = r1retry_t2l7a+1);
  [r1dot2l7a] r1=5 & r1retry_t2l7a >= r1_maxRetry_t2l7a -> 1:(r1'=r1Fail);
  [r1dot2l7bRetry] r1=6 & r1retry_t2l7b < r1_maxRetry_t2l7b -> p_r1_t2l7b : (r1'=r1+1) + (1-p_r1_t2l7b) : (r1'=r1) & (r1retry_t2l7b' = r1retry_t2l7b+1);
  [r1dot2l7b] r1=6 & r1retry_t2l7b >= r1_maxRetry_t2l7b -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [worker1dot3l1a] true:5;
  [worker1dot3l1aRetry] true:5;
  [worker1dot3l1b] true:5;
  [worker1dot3l1bRetry] true:5;
  [worker2movel2] true:1;
  [worker2dot1l2] true:3;
  [worker2dot1l2Retry] true:3;
  [worker2movel5] true:1;
  [worker2movel8] true:1;
  [worker2dot1l8] true:3;
  [worker2dot1l8Retry] true:3;
  [worker2movel9] true:1;
  [worker2dot1l9] true:3;
  [worker2dot1l9Retry] true:3;
  [r1movel4] true:1;
  [r1dot2l4] true:1;
  [r1dot2l4Retry] true:1;
  [r1movel7] true:1;
  [r1dot2l7d] true:1;
  [r1dot2l7dRetry] true:1;
  [r1dot2l7c] true:1;
  [r1dot2l7cRetry] true:1;
  [r1dot2l7a] true:1;
  [r1dot2l7aRetry] true:1;
  [r1dot2l7b] true:1;
  [r1dot2l7bRetry] true:1;
endrewards