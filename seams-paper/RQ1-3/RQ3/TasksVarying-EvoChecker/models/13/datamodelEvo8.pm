dtmc
evolve int worker2_maxRetry_t1l1a [1..5];
evolve int worker2_maxRetry_t1l1b [1..5];
evolve int r1_maxRetry_t2l2 [1..10];
evolve int r1_maxRetry_t2l5 [1..10];
evolve int r1_maxRetry_t2l8 [1..10];
evolve int r1_maxRetry_t2l9 [1..10];
evolve int r1_maxRetry_t2l6 [1..10];
evolve int worker1_maxRetry_t3l4 [1..5];
evolve int worker1_maxRetry_t1l7a [1..5];
evolve int worker1_maxRetry_t1l7b [1..5];
evolve int worker1_maxRetry_t3l8a [1..5];
evolve int worker1_maxRetry_t3l8b [1..5];
evolve int worker1_maxRetry_t1l9 [1..5];

const double p_worker2_t1l1a=1.0;
const double p_worker2_t1l1b=1.0;
const double p_r1_t2l2=0.99;
const double p_r1_t2l5=0.99;
const double p_r1_t2l8=0.99;
const double p_r1_t2l9=0.99;
const double p_r1_t2l6=0.99;
const double p_worker1_t3l4=0.99;
const double p_worker1_t1l7a=1.0;
const double p_worker1_t1l7b=1.0;
const double p_worker1_t3l8a=0.99;
const double p_worker1_t3l8b=0.99;
const double p_worker1_t1l9=1.0;
const int worker2Final = 2;
const int worker2Fail = 3;
const int r1Final = 10;
const int r1Fail = 11;
const int worker1Final = 10;
const int worker1Fail = 11;

module _worker2
  worker2 : [0..4];
  worker2retry_t1l1a : [0..worker2_maxRetry_t1l1a] init 0;
  worker2retry_t1l1b : [0..worker2_maxRetry_t1l1b] init 0;

  [worker2dot1l1aRetry] worker2=0 & worker2retry_t1l1a < worker2_maxRetry_t1l1a -> p_worker2_t1l1a : (worker2'=worker2+1) + (1-p_worker2_t1l1a) : (worker2'=worker2) & (worker2retry_t1l1a' = worker2retry_t1l1a+1);
  [worker2dot1l1a] worker2=0 & worker2retry_t1l1a >= worker2_maxRetry_t1l1a -> 1:(worker2'=worker2Fail);
  [worker2dot1l1bRetry] worker2=1 & worker2retry_t1l1b < worker2_maxRetry_t1l1b -> p_worker2_t1l1b : (worker2'=worker2+1) + (1-p_worker2_t1l1b) : (worker2'=worker2) & (worker2retry_t1l1b' = worker2retry_t1l1b+1);
  [worker2dot1l1b] worker2=1 & worker2retry_t1l1b >= worker2_maxRetry_t1l1b -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..12];
  r1retry_t2l2 : [0..r1_maxRetry_t2l2] init 0;
  r1retry_t2l5 : [0..r1_maxRetry_t2l5] init 0;
  r1retry_t2l8 : [0..r1_maxRetry_t2l8] init 0;
  r1retry_t2l9 : [0..r1_maxRetry_t2l9] init 0;
  r1retry_t2l6 : [0..r1_maxRetry_t2l6] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1dot2l2Retry] r1=1 & r1retry_t2l2 < r1_maxRetry_t2l2 -> p_r1_t2l2 : (r1'=r1+1) + (1-p_r1_t2l2) : (r1'=r1) & (r1retry_t2l2' = r1retry_t2l2+1);
  [r1dot2l2] r1=1 & r1retry_t2l2 >= r1_maxRetry_t2l2 -> 1:(r1'=r1Fail);
  [r1movel5] r1=2-> 1:(r1'=2+1);
  [r1dot2l5Retry] r1=3 & r1retry_t2l5 < r1_maxRetry_t2l5 -> p_r1_t2l5 : (r1'=r1+1) + (1-p_r1_t2l5) : (r1'=r1) & (r1retry_t2l5' = r1retry_t2l5+1);
  [r1dot2l5] r1=3 & r1retry_t2l5 >= r1_maxRetry_t2l5 -> 1:(r1'=r1Fail);
  [r1movel8] r1=4-> 1:(r1'=4+1);
  [r1dot2l8Retry] r1=5 & r1retry_t2l8 < r1_maxRetry_t2l8 -> p_r1_t2l8 : (r1'=r1+1) + (1-p_r1_t2l8) : (r1'=r1) & (r1retry_t2l8' = r1retry_t2l8+1);
  [r1dot2l8] r1=5 & r1retry_t2l8 >= r1_maxRetry_t2l8 -> 1:(r1'=r1Fail);
  [r1movel9] r1=6-> 1:(r1'=6+1);
  [r1dot2l9Retry] r1=7 & r1retry_t2l9 < r1_maxRetry_t2l9 -> p_r1_t2l9 : (r1'=r1+1) + (1-p_r1_t2l9) : (r1'=r1) & (r1retry_t2l9' = r1retry_t2l9+1);
  [r1dot2l9] r1=7 & r1retry_t2l9 >= r1_maxRetry_t2l9 -> 1:(r1'=r1Fail);
  [r1movel6] r1=8-> 1:(r1'=8+1);
  [r1dot2l6Retry] r1=9 & r1retry_t2l6 < r1_maxRetry_t2l6 -> p_r1_t2l6 : (r1'=r1+1) + (1-p_r1_t2l6) : (r1'=r1) & (r1retry_t2l6' = r1retry_t2l6+1);
  [r1dot2l6] r1=9 & r1retry_t2l6 >= r1_maxRetry_t2l6 -> 1:(r1'=r1Fail);
endmodule

module _worker1
  worker1 : [0..12];
  worker1retry_t3l4 : [0..worker1_maxRetry_t3l4] init 0;
  worker1retry_t1l7a : [0..worker1_maxRetry_t1l7a] init 0;
  worker1retry_t1l7b : [0..worker1_maxRetry_t1l7b] init 0;
  worker1retry_t3l8a : [0..worker1_maxRetry_t3l8a] init 0;
  worker1retry_t3l8b : [0..worker1_maxRetry_t3l8b] init 0;
  worker1retry_t1l9 : [0..worker1_maxRetry_t1l9] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot3l4Retry] worker1=1 & worker1retry_t3l4 < worker1_maxRetry_t3l4 -> p_worker1_t3l4 : (worker1'=worker1+1) + (1-p_worker1_t3l4) : (worker1'=worker1) & (worker1retry_t3l4' = worker1retry_t3l4+1);
  [worker1dot3l4] worker1=1 & worker1retry_t3l4 >= worker1_maxRetry_t3l4 -> 1:(worker1'=worker1Fail);
  [worker1movel7] worker1=2-> 1:(worker1'=2+1);
  [worker1dot1l7aRetry] worker1=3 & worker1retry_t1l7a < worker1_maxRetry_t1l7a -> p_worker1_t1l7a : (worker1'=worker1+1) + (1-p_worker1_t1l7a) : (worker1'=worker1) & (worker1retry_t1l7a' = worker1retry_t1l7a+1);
  [worker1dot1l7a] worker1=3 & worker1retry_t1l7a >= worker1_maxRetry_t1l7a -> 1:(worker1'=worker1Fail);
  [worker1dot1l7bRetry] worker1=4 & worker1retry_t1l7b < worker1_maxRetry_t1l7b -> p_worker1_t1l7b : (worker1'=worker1+1) + (1-p_worker1_t1l7b) : (worker1'=worker1) & (worker1retry_t1l7b' = worker1retry_t1l7b+1);
  [worker1dot1l7b] worker1=4 & worker1retry_t1l7b >= worker1_maxRetry_t1l7b -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=5-> 1:(worker1'=5+1);
  [worker1dot3l8aRetry] worker1=6 & worker1retry_t3l8a < worker1_maxRetry_t3l8a -> p_worker1_t3l8a : (worker1'=worker1+1) + (1-p_worker1_t3l8a) : (worker1'=worker1) & (worker1retry_t3l8a' = worker1retry_t3l8a+1);
  [worker1dot3l8a] worker1=6 & worker1retry_t3l8a >= worker1_maxRetry_t3l8a -> 1:(worker1'=worker1Fail);
  [worker1dot3l8bRetry] worker1=7 & worker1retry_t3l8b < worker1_maxRetry_t3l8b -> p_worker1_t3l8b : (worker1'=worker1+1) + (1-p_worker1_t3l8b) : (worker1'=worker1) & (worker1retry_t3l8b' = worker1retry_t3l8b+1);
  [worker1dot3l8b] worker1=7 & worker1retry_t3l8b >= worker1_maxRetry_t3l8b -> 1:(worker1'=worker1Fail);
  [worker1movel9] worker1=8-> 1:(worker1'=8+1);
  [worker1dot1l9Retry] worker1=9 & worker1retry_t1l9 < worker1_maxRetry_t1l9 -> p_worker1_t1l9 : (worker1'=worker1+1) + (1-p_worker1_t1l9) : (worker1'=worker1) & (worker1retry_t1l9' = worker1retry_t1l9+1);
  [worker1dot1l9] worker1=9 & worker1retry_t1l9 >= worker1_maxRetry_t1l9 -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [worker2dot1l1a] true:3;
  [worker2dot1l1aRetry] true:3;
  [worker2dot1l1b] true:3;
  [worker2dot1l1bRetry] true:3;
  [r1movel2] true:1;
  [r1dot2l2] true:1;
  [r1dot2l2Retry] true:1;
  [r1movel5] true:1;
  [r1dot2l5] true:1;
  [r1dot2l5Retry] true:1;
  [r1movel8] true:1;
  [r1dot2l8] true:1;
  [r1dot2l8Retry] true:1;
  [r1movel9] true:1;
  [r1dot2l9] true:1;
  [r1dot2l9Retry] true:1;
  [r1movel6] true:1;
  [r1dot2l6] true:1;
  [r1dot2l6Retry] true:1;
  [worker1movel4] true:1;
  [worker1dot3l4] true:5;
  [worker1dot3l4Retry] true:5;
  [worker1movel7] true:1;
  [worker1dot1l7a] true:3;
  [worker1dot1l7aRetry] true:3;
  [worker1dot1l7b] true:3;
  [worker1dot1l7bRetry] true:3;
  [worker1movel8] true:1;
  [worker1dot3l8a] true:5;
  [worker1dot3l8aRetry] true:5;
  [worker1dot3l8b] true:5;
  [worker1dot3l8bRetry] true:5;
  [worker1movel9] true:1;
  [worker1dot1l9] true:3;
  [worker1dot1l9Retry] true:3;
endrewards