dtmc
evolve int r1_maxRetry_t2l4 [1..10];
evolve int r1_maxRetry_t2l5a [1..10];
evolve int r1_maxRetry_t2l5b [1..10];
evolve int r1_maxRetry_t3l6 [1..10];
evolve int r1_maxRetry_t2l9 [1..10];
evolve int worker1_maxRetry_t1l1a [1..5];
evolve int worker1_maxRetry_t1l1b [1..5];
evolve int worker2_maxRetry_t3l2 [1..5];
evolve int worker2_maxRetry_t1l2 [1..5];
evolve int worker2_maxRetry_t3l5 [1..5];
evolve int worker2_maxRetry_t3l8 [1..5];
evolve int worker2_maxRetry_t1l8 [1..5];

const double p_r1_t2l4=0.99;
const double p_r1_t2l5a=0.99;
const double p_r1_t2l5b=0.99;
const double p_r1_t3l6=0.97;
const double p_r1_t2l9=0.99;
const double p_worker1_t1l1a=1.0;
const double p_worker1_t1l1b=1.0;
const double p_worker2_t3l2=0.99;
const double p_worker2_t1l2=1.0;
const double p_worker2_t3l5=0.99;
const double p_worker2_t3l8=0.99;
const double p_worker2_t1l8=1.0;
const int r1Final = 9;
const int r1Fail = 10;
const int worker1Final = 2;
const int worker1Fail = 3;
const int worker2Final = 8;
const int worker2Fail = 9;

module _r1
  r1 : [0..11];
  r1retry_t2l4 : [0..r1_maxRetry_t2l4] init 0;
  r1retry_t2l5a : [0..r1_maxRetry_t2l5a] init 0;
  r1retry_t2l5b : [0..r1_maxRetry_t2l5b] init 0;
  r1retry_t3l6 : [0..r1_maxRetry_t3l6] init 0;
  r1retry_t2l9 : [0..r1_maxRetry_t2l9] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1dot2l4Retry] r1=1 & r1retry_t2l4 < r1_maxRetry_t2l4 -> p_r1_t2l4 : (r1'=r1+1) + (1-p_r1_t2l4) : (r1'=r1) & (r1retry_t2l4' = r1retry_t2l4+1);
  [r1dot2l4] r1=1 & r1retry_t2l4 >= r1_maxRetry_t2l4 -> 1:(r1'=r1Fail);
  [r1movel5] r1=2-> 1:(r1'=2+1);
  [r1dot2l5aRetry] r1=3 & r1retry_t2l5a < r1_maxRetry_t2l5a -> p_r1_t2l5a : (r1'=r1+1) + (1-p_r1_t2l5a) : (r1'=r1) & (r1retry_t2l5a' = r1retry_t2l5a+1);
  [r1dot2l5a] r1=3 & r1retry_t2l5a >= r1_maxRetry_t2l5a -> 1:(r1'=r1Fail);
  [r1dot2l5bRetry] r1=4 & r1retry_t2l5b < r1_maxRetry_t2l5b -> p_r1_t2l5b : (r1'=r1+1) + (1-p_r1_t2l5b) : (r1'=r1) & (r1retry_t2l5b' = r1retry_t2l5b+1);
  [r1dot2l5b] r1=4 & r1retry_t2l5b >= r1_maxRetry_t2l5b -> 1:(r1'=r1Fail);
  [r1movel6] r1=5-> 1:(r1'=5+1);
  [r1dot3l6Retry] r1=6 & r1retry_t3l6 < r1_maxRetry_t3l6 -> p_r1_t3l6 : (r1'=r1+1) + (1-p_r1_t3l6) : (r1'=r1) & (r1retry_t3l6' = r1retry_t3l6+1);
  [r1dot3l6] r1=6 & r1retry_t3l6 >= r1_maxRetry_t3l6 -> 1:(r1'=r1Fail);
  [r1movel9] r1=7-> 1:(r1'=7+1);
  [r1dot2l9Retry] r1=8 & r1retry_t2l9 < r1_maxRetry_t2l9 -> p_r1_t2l9 : (r1'=r1+1) + (1-p_r1_t2l9) : (r1'=r1) & (r1retry_t2l9' = r1retry_t2l9+1);
  [r1dot2l9] r1=8 & r1retry_t2l9 >= r1_maxRetry_t2l9 -> 1:(r1'=r1Fail);
endmodule

module _worker1
  worker1 : [0..4];
  worker1retry_t1l1a : [0..worker1_maxRetry_t1l1a] init 0;
  worker1retry_t1l1b : [0..worker1_maxRetry_t1l1b] init 0;

  [worker1dot1l1aRetry] worker1=0 & worker1retry_t1l1a < worker1_maxRetry_t1l1a -> p_worker1_t1l1a : (worker1'=worker1+1) + (1-p_worker1_t1l1a) : (worker1'=worker1) & (worker1retry_t1l1a' = worker1retry_t1l1a+1);
  [worker1dot1l1a] worker1=0 & worker1retry_t1l1a >= worker1_maxRetry_t1l1a -> 1:(worker1'=worker1Fail);
  [worker1dot1l1bRetry] worker1=1 & worker1retry_t1l1b < worker1_maxRetry_t1l1b -> p_worker1_t1l1b : (worker1'=worker1+1) + (1-p_worker1_t1l1b) : (worker1'=worker1) & (worker1retry_t1l1b' = worker1retry_t1l1b+1);
  [worker1dot1l1b] worker1=1 & worker1retry_t1l1b >= worker1_maxRetry_t1l1b -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..10];
  worker2retry_t3l2 : [0..worker2_maxRetry_t3l2] init 0;
  worker2retry_t1l2 : [0..worker2_maxRetry_t1l2] init 0;
  worker2retry_t3l5 : [0..worker2_maxRetry_t3l5] init 0;
  worker2retry_t3l8 : [0..worker2_maxRetry_t3l8] init 0;
  worker2retry_t1l8 : [0..worker2_maxRetry_t1l8] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot3l2Retry] worker2=1 & worker2retry_t3l2 < worker2_maxRetry_t3l2 -> p_worker2_t3l2 : (worker2'=worker2+1) + (1-p_worker2_t3l2) : (worker2'=worker2) & (worker2retry_t3l2' = worker2retry_t3l2+1);
  [worker2dot3l2] worker2=1 & worker2retry_t3l2 >= worker2_maxRetry_t3l2 -> 1:(worker2'=worker2Fail);
  [worker2dot1l2Retry] worker2=2 & worker2retry_t1l2 < worker2_maxRetry_t1l2 -> p_worker2_t1l2 : (worker2'=worker2+1) + (1-p_worker2_t1l2) : (worker2'=worker2) & (worker2retry_t1l2' = worker2retry_t1l2+1);
  [worker2dot1l2] worker2=2 & worker2retry_t1l2 >= worker2_maxRetry_t1l2 -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=3-> 1:(worker2'=3+1);
  [worker2dot3l5Retry] worker2=4 & worker2retry_t3l5 < worker2_maxRetry_t3l5 -> p_worker2_t3l5 : (worker2'=worker2+1) + (1-p_worker2_t3l5) : (worker2'=worker2) & (worker2retry_t3l5' = worker2retry_t3l5+1);
  [worker2dot3l5] worker2=4 & worker2retry_t3l5 >= worker2_maxRetry_t3l5 -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=5-> 1:(worker2'=5+1);
  [worker2dot3l8Retry] worker2=6 & worker2retry_t3l8 < worker2_maxRetry_t3l8 -> p_worker2_t3l8 : (worker2'=worker2+1) + (1-p_worker2_t3l8) : (worker2'=worker2) & (worker2retry_t3l8' = worker2retry_t3l8+1);
  [worker2dot3l8] worker2=6 & worker2retry_t3l8 >= worker2_maxRetry_t3l8 -> 1:(worker2'=worker2Fail);
  [worker2dot1l8Retry] worker2=7 & worker2retry_t1l8 < worker2_maxRetry_t1l8 -> p_worker2_t1l8 : (worker2'=worker2+1) + (1-p_worker2_t1l8) : (worker2'=worker2) & (worker2retry_t1l8' = worker2retry_t1l8+1);
  [worker2dot1l8] worker2=7 & worker2retry_t1l8 >= worker2_maxRetry_t1l8 -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r1movel4] true:1;
  [r1dot2l4] true:1;
  [r1dot2l4Retry] true:1;
  [r1movel5] true:1;
  [r1dot2l5a] true:1;
  [r1dot2l5aRetry] true:1;
  [r1dot2l5b] true:1;
  [r1dot2l5bRetry] true:1;
  [r1movel6] true:1;
  [r1dot3l6] true:1;
  [r1dot3l6Retry] true:1;
  [r1movel9] true:1;
  [r1dot2l9] true:1;
  [r1dot2l9Retry] true:1;
  [worker1dot1l1a] true:3;
  [worker1dot1l1aRetry] true:3;
  [worker1dot1l1b] true:3;
  [worker1dot1l1bRetry] true:3;
  [worker2movel2] true:1;
  [worker2dot3l2] true:5;
  [worker2dot3l2Retry] true:5;
  [worker2dot1l2] true:3;
  [worker2dot1l2Retry] true:3;
  [worker2movel5] true:1;
  [worker2dot3l5] true:5;
  [worker2dot3l5Retry] true:5;
  [worker2movel8] true:1;
  [worker2dot3l8] true:5;
  [worker2dot3l8Retry] true:5;
  [worker2dot1l8] true:3;
  [worker2dot1l8Retry] true:3;
endrewards