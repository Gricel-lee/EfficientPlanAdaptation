dtmc
evolve int worker1_maxRetry_t3l1 [1..5];
evolve int worker2_maxRetry_t1l2 [1..5];
evolve int worker2_maxRetry_t3l5b [1..5];
evolve int worker2_maxRetry_t1l6 [1..5];
evolve int worker2_maxRetry_t1l9 [1..5];
evolve int worker2_maxRetry_t1l8a [1..5];
evolve int worker2_maxRetry_t1l8b [1..5];
evolve int worker2_maxRetry_t3l7 [1..5];
evolve int r1_maxRetry_t2l4 [1..10];
evolve int r1_maxRetry_t3l5a [1..10];
evolve int r1_maxRetry_t2l6 [1..10];

const double p_worker1_t3l1=0.99;
const double p_worker2_t1l2=1.0;
const double p_worker2_t3l5b=0.99;
const double p_worker2_t1l6=1.0;
const double p_worker2_t1l9=1.0;
const double p_worker2_t1l8a=1.0;
const double p_worker2_t1l8b=1.0;
const double p_worker2_t3l7=0.99;
const double p_r1_t2l4=0.99;
const double p_r1_t3l5a=0.97;
const double p_r1_t2l6=0.99;
const int worker1Final = 1;
const int worker1Fail = 2;
const int worker2Final = 13;
const int worker2Fail = 14;
const int r1Final = 6;
const int r1Fail = 7;

module _worker1
  worker1 : [0..3];
  worker1retry_t3l1 : [0..worker1_maxRetry_t3l1] init 0;

  [worker1dot3l1Retry] worker1=0 & worker1retry_t3l1 < worker1_maxRetry_t3l1 -> p_worker1_t3l1 : (worker1'=worker1+1) + (1-p_worker1_t3l1) : (worker1'=worker1) & (worker1retry_t3l1' = worker1retry_t3l1+1);
  [worker1dot3l1] worker1=0 & worker1retry_t3l1 >= worker1_maxRetry_t3l1 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..15];
  worker2retry_t1l2 : [0..worker2_maxRetry_t1l2] init 0;
  worker2retry_t3l5b : [0..worker2_maxRetry_t3l5b] init 0;
  worker2retry_t1l6 : [0..worker2_maxRetry_t1l6] init 0;
  worker2retry_t1l9 : [0..worker2_maxRetry_t1l9] init 0;
  worker2retry_t1l8a : [0..worker2_maxRetry_t1l8a] init 0;
  worker2retry_t1l8b : [0..worker2_maxRetry_t1l8b] init 0;
  worker2retry_t3l7 : [0..worker2_maxRetry_t3l7] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l2Retry] worker2=1 & worker2retry_t1l2 < worker2_maxRetry_t1l2 -> p_worker2_t1l2 : (worker2'=worker2+1) + (1-p_worker2_t1l2) : (worker2'=worker2) & (worker2retry_t1l2' = worker2retry_t1l2+1);
  [worker2dot1l2] worker2=1 & worker2retry_t1l2 >= worker2_maxRetry_t1l2 -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=2-> 1:(worker2'=2+1);
  [worker2dot3l5bRetry] worker2=3 & worker2retry_t3l5b < worker2_maxRetry_t3l5b -> p_worker2_t3l5b : (worker2'=worker2+1) + (1-p_worker2_t3l5b) : (worker2'=worker2) & (worker2retry_t3l5b' = worker2retry_t3l5b+1);
  [worker2dot3l5b] worker2=3 & worker2retry_t3l5b >= worker2_maxRetry_t3l5b -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=4-> 1:(worker2'=4+1);
  [worker2dot1l6Retry] worker2=5 & worker2retry_t1l6 < worker2_maxRetry_t1l6 -> p_worker2_t1l6 : (worker2'=worker2+1) + (1-p_worker2_t1l6) : (worker2'=worker2) & (worker2retry_t1l6' = worker2retry_t1l6+1);
  [worker2dot1l6] worker2=5 & worker2retry_t1l6 >= worker2_maxRetry_t1l6 -> 1:(worker2'=worker2Fail);
  [worker2movel9] worker2=6-> 1:(worker2'=6+1);
  [worker2dot1l9Retry] worker2=7 & worker2retry_t1l9 < worker2_maxRetry_t1l9 -> p_worker2_t1l9 : (worker2'=worker2+1) + (1-p_worker2_t1l9) : (worker2'=worker2) & (worker2retry_t1l9' = worker2retry_t1l9+1);
  [worker2dot1l9] worker2=7 & worker2retry_t1l9 >= worker2_maxRetry_t1l9 -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=8-> 1:(worker2'=8+1);
  [worker2dot1l8aRetry] worker2=9 & worker2retry_t1l8a < worker2_maxRetry_t1l8a -> p_worker2_t1l8a : (worker2'=worker2+1) + (1-p_worker2_t1l8a) : (worker2'=worker2) & (worker2retry_t1l8a' = worker2retry_t1l8a+1);
  [worker2dot1l8a] worker2=9 & worker2retry_t1l8a >= worker2_maxRetry_t1l8a -> 1:(worker2'=worker2Fail);
  [worker2dot1l8bRetry] worker2=10 & worker2retry_t1l8b < worker2_maxRetry_t1l8b -> p_worker2_t1l8b : (worker2'=worker2+1) + (1-p_worker2_t1l8b) : (worker2'=worker2) & (worker2retry_t1l8b' = worker2retry_t1l8b+1);
  [worker2dot1l8b] worker2=10 & worker2retry_t1l8b >= worker2_maxRetry_t1l8b -> 1:(worker2'=worker2Fail);
  [worker2movel7] worker2=11-> 1:(worker2'=11+1);
  [worker2dot3l7Retry] worker2=12 & worker2retry_t3l7 < worker2_maxRetry_t3l7 -> p_worker2_t3l7 : (worker2'=worker2+1) + (1-p_worker2_t3l7) : (worker2'=worker2) & (worker2retry_t3l7' = worker2retry_t3l7+1);
  [worker2dot3l7] worker2=12 & worker2retry_t3l7 >= worker2_maxRetry_t3l7 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..8];
  r1retry_t2l4 : [0..r1_maxRetry_t2l4] init 0;
  r1retry_t3l5a : [0..r1_maxRetry_t3l5a] init 0;
  r1retry_t2l6 : [0..r1_maxRetry_t2l6] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1dot2l4Retry] r1=1 & r1retry_t2l4 < r1_maxRetry_t2l4 -> p_r1_t2l4 : (r1'=r1+1) + (1-p_r1_t2l4) : (r1'=r1) & (r1retry_t2l4' = r1retry_t2l4+1);
  [r1dot2l4] r1=1 & r1retry_t2l4 >= r1_maxRetry_t2l4 -> 1:(r1'=r1Fail);
  [r1movel5] r1=2-> 1:(r1'=2+1);
  [r1dot3l5aRetry] r1=3 & r1retry_t3l5a < r1_maxRetry_t3l5a -> p_r1_t3l5a : (r1'=r1+1) + (1-p_r1_t3l5a) : (r1'=r1) & (r1retry_t3l5a' = r1retry_t3l5a+1);
  [r1dot3l5a] r1=3 & r1retry_t3l5a >= r1_maxRetry_t3l5a -> 1:(r1'=r1Fail);
  [r1movel6] r1=4-> 1:(r1'=4+1);
  [r1dot2l6Retry] r1=5 & r1retry_t2l6 < r1_maxRetry_t2l6 -> p_r1_t2l6 : (r1'=r1+1) + (1-p_r1_t2l6) : (r1'=r1) & (r1retry_t2l6' = r1retry_t2l6+1);
  [r1dot2l6] r1=5 & r1retry_t2l6 >= r1_maxRetry_t2l6 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [worker1dot3l1] true:5;
  [worker1dot3l1Retry] true:5;
  [worker2movel2] true:1;
  [worker2dot1l2] true:3;
  [worker2dot1l2Retry] true:3;
  [worker2movel5] true:1;
  [worker2dot3l5b] true:5;
  [worker2dot3l5bRetry] true:5;
  [worker2movel6] true:1;
  [worker2dot1l6] true:3;
  [worker2dot1l6Retry] true:3;
  [worker2movel9] true:1;
  [worker2dot1l9] true:3;
  [worker2dot1l9Retry] true:3;
  [worker2movel8] true:1;
  [worker2dot1l8a] true:3;
  [worker2dot1l8aRetry] true:3;
  [worker2dot1l8b] true:3;
  [worker2dot1l8bRetry] true:3;
  [worker2movel7] true:1;
  [worker2dot3l7] true:5;
  [worker2dot3l7Retry] true:5;
  [r1movel4] true:1;
  [r1dot2l4] true:1;
  [r1dot2l4Retry] true:1;
  [r1movel5] true:1;
  [r1dot3l5a] true:1;
  [r1dot3l5aRetry] true:1;
  [r1movel6] true:1;
  [r1dot2l6] true:1;
  [r1dot2l6Retry] true:1;
endrewards