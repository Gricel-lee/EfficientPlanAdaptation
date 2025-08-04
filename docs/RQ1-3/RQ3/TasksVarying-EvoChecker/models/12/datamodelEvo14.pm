dtmc
evolve int r2_maxRetry_t2l2b [1..10];
evolve int r2_maxRetry_t2l2a [1..10];
evolve int r2_maxRetry_t3l2 [1..10];
evolve int r2_maxRetry_t2l5a [1..10];
evolve int r2_maxRetry_t2l5b [1..10];
evolve int r2_maxRetry_t2l6 [1..10];
evolve int worker1_maxRetry_t1l1a [1..5];
evolve int worker1_maxRetry_t1l1b [1..5];
evolve int worker1_maxRetry_t1l4 [1..5];
evolve int worker1_maxRetry_t3l7 [1..5];
evolve int worker1_maxRetry_t1l7 [1..5];
evolve int worker2_maxRetry_t1l6 [1..5];

const double p_r2_t2l2b=0.99;
const double p_r2_t2l2a=0.99;
const double p_r2_t3l2=0.97;
const double p_r2_t2l5a=0.99;
const double p_r2_t2l5b=0.99;
const double p_r2_t2l6=0.99;
const double p_worker1_t1l1a=1.0;
const double p_worker1_t1l1b=1.0;
const double p_worker1_t1l4=1.0;
const double p_worker1_t3l7=0.99;
const double p_worker1_t1l7=1.0;
const double p_worker2_t1l6=1.0;
const int r2Final = 10;
const int r2Fail = 11;
const int worker1Final = 7;
const int worker1Fail = 8;
const int worker2Final = 4;
const int worker2Fail = 5;

module _r2
  r2 : [0..12];
  r2retry_t2l2b : [0..r2_maxRetry_t2l2b] init 0;
  r2retry_t2l2a : [0..r2_maxRetry_t2l2a] init 0;
  r2retry_t3l2 : [0..r2_maxRetry_t3l2] init 0;
  r2retry_t2l5a : [0..r2_maxRetry_t2l5a] init 0;
  r2retry_t2l5b : [0..r2_maxRetry_t2l5b] init 0;
  r2retry_t2l6 : [0..r2_maxRetry_t2l6] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2dot2l2bRetry] r2=1 & r2retry_t2l2b < r2_maxRetry_t2l2b -> p_r2_t2l2b : (r2'=r2+1) + (1-p_r2_t2l2b) : (r2'=r2) & (r2retry_t2l2b' = r2retry_t2l2b+1);
  [r2dot2l2b] r2=1 & r2retry_t2l2b >= r2_maxRetry_t2l2b -> 1:(r2'=r2Fail);
  [r2dot2l2aRetry] r2=2 & r2retry_t2l2a < r2_maxRetry_t2l2a -> p_r2_t2l2a : (r2'=r2+1) + (1-p_r2_t2l2a) : (r2'=r2) & (r2retry_t2l2a' = r2retry_t2l2a+1);
  [r2dot2l2a] r2=2 & r2retry_t2l2a >= r2_maxRetry_t2l2a -> 1:(r2'=r2Fail);
  [r2dot3l2Retry] r2=3 & r2retry_t3l2 < r2_maxRetry_t3l2 -> p_r2_t3l2 : (r2'=r2+1) + (1-p_r2_t3l2) : (r2'=r2) & (r2retry_t3l2' = r2retry_t3l2+1);
  [r2dot3l2] r2=3 & r2retry_t3l2 >= r2_maxRetry_t3l2 -> 1:(r2'=r2Fail);
  [r2movel5] r2=4-> 1:(r2'=4+1);
  [r2dot2l5aRetry] r2=5 & r2retry_t2l5a < r2_maxRetry_t2l5a -> p_r2_t2l5a : (r2'=r2+1) + (1-p_r2_t2l5a) : (r2'=r2) & (r2retry_t2l5a' = r2retry_t2l5a+1);
  [r2dot2l5a] r2=5 & r2retry_t2l5a >= r2_maxRetry_t2l5a -> 1:(r2'=r2Fail);
  [r2dot2l5bRetry] r2=6 & r2retry_t2l5b < r2_maxRetry_t2l5b -> p_r2_t2l5b : (r2'=r2+1) + (1-p_r2_t2l5b) : (r2'=r2) & (r2retry_t2l5b' = r2retry_t2l5b+1);
  [r2dot2l5b] r2=6 & r2retry_t2l5b >= r2_maxRetry_t2l5b -> 1:(r2'=r2Fail);
  [r2movel6] r2=7-> 1:(r2'=7+1);
  [r2dot2l6Retry] r2=8 & r2retry_t2l6 < r2_maxRetry_t2l6 -> p_r2_t2l6 : (r2'=r2+1) + (1-p_r2_t2l6) : (r2'=r2) & (r2retry_t2l6' = r2retry_t2l6+1);
  [r2dot2l6] r2=8 & r2retry_t2l6 >= r2_maxRetry_t2l6 -> 1:(r2'=r2Fail);
  [r2movel9] r2=9-> 1:(r2'=9+1);
endmodule

module _worker1
  worker1 : [0..9];
  worker1retry_t1l1a : [0..worker1_maxRetry_t1l1a] init 0;
  worker1retry_t1l1b : [0..worker1_maxRetry_t1l1b] init 0;
  worker1retry_t1l4 : [0..worker1_maxRetry_t1l4] init 0;
  worker1retry_t3l7 : [0..worker1_maxRetry_t3l7] init 0;
  worker1retry_t1l7 : [0..worker1_maxRetry_t1l7] init 0;

  [worker1dot1l1aRetry] worker1=0 & worker1retry_t1l1a < worker1_maxRetry_t1l1a -> p_worker1_t1l1a : (worker1'=worker1+1) + (1-p_worker1_t1l1a) : (worker1'=worker1) & (worker1retry_t1l1a' = worker1retry_t1l1a+1);
  [worker1dot1l1a] worker1=0 & worker1retry_t1l1a >= worker1_maxRetry_t1l1a -> 1:(worker1'=worker1Fail);
  [worker1dot1l1bRetry] worker1=1 & worker1retry_t1l1b < worker1_maxRetry_t1l1b -> p_worker1_t1l1b : (worker1'=worker1+1) + (1-p_worker1_t1l1b) : (worker1'=worker1) & (worker1retry_t1l1b' = worker1retry_t1l1b+1);
  [worker1dot1l1b] worker1=1 & worker1retry_t1l1b >= worker1_maxRetry_t1l1b -> 1:(worker1'=worker1Fail);
  [worker1movel4] worker1=2-> 1:(worker1'=2+1);
  [worker1dot1l4Retry] worker1=3 & worker1retry_t1l4 < worker1_maxRetry_t1l4 -> p_worker1_t1l4 : (worker1'=worker1+1) + (1-p_worker1_t1l4) : (worker1'=worker1) & (worker1retry_t1l4' = worker1retry_t1l4+1);
  [worker1dot1l4] worker1=3 & worker1retry_t1l4 >= worker1_maxRetry_t1l4 -> 1:(worker1'=worker1Fail);
  [worker1movel7] worker1=4-> 1:(worker1'=4+1);
  [worker1dot3l7Retry] worker1=5 & worker1retry_t3l7 < worker1_maxRetry_t3l7 -> p_worker1_t3l7 : (worker1'=worker1+1) + (1-p_worker1_t3l7) : (worker1'=worker1) & (worker1retry_t3l7' = worker1retry_t3l7+1);
  [worker1dot3l7] worker1=5 & worker1retry_t3l7 >= worker1_maxRetry_t3l7 -> 1:(worker1'=worker1Fail);
  [worker1dot1l7Retry] worker1=6 & worker1retry_t1l7 < worker1_maxRetry_t1l7 -> p_worker1_t1l7 : (worker1'=worker1+1) + (1-p_worker1_t1l7) : (worker1'=worker1) & (worker1retry_t1l7' = worker1retry_t1l7+1);
  [worker1dot1l7] worker1=6 & worker1retry_t1l7 >= worker1_maxRetry_t1l7 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..6];
  worker2retry_t1l6 : [0..worker2_maxRetry_t1l6] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2movel5] worker2=1-> 1:(worker2'=1+1);
  [worker2movel6] worker2=2-> 1:(worker2'=2+1);
  [worker2dot1l6Retry] worker2=3 & worker2retry_t1l6 < worker2_maxRetry_t1l6 -> p_worker2_t1l6 : (worker2'=worker2+1) + (1-p_worker2_t1l6) : (worker2'=worker2) & (worker2retry_t1l6' = worker2retry_t1l6+1);
  [worker2dot1l6] worker2=3 & worker2retry_t1l6 >= worker2_maxRetry_t1l6 -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r2movel2] true:1;
  [r2dot2l2b] true:1;
  [r2dot2l2bRetry] true:1;
  [r2dot2l2a] true:1;
  [r2dot2l2aRetry] true:1;
  [r2dot3l2] true:1;
  [r2dot3l2Retry] true:1;
  [r2movel5] true:1;
  [r2dot2l5a] true:1;
  [r2dot2l5aRetry] true:1;
  [r2dot2l5b] true:1;
  [r2dot2l5bRetry] true:1;
  [r2movel6] true:1;
  [r2dot2l6] true:1;
  [r2dot2l6Retry] true:1;
  [r2movel9] true:1;
  [worker1dot1l1a] true:3;
  [worker1dot1l1aRetry] true:3;
  [worker1dot1l1b] true:3;
  [worker1dot1l1bRetry] true:3;
  [worker1movel4] true:1;
  [worker1dot1l4] true:3;
  [worker1dot1l4Retry] true:3;
  [worker1movel7] true:1;
  [worker1dot3l7] true:5;
  [worker1dot3l7Retry] true:5;
  [worker1dot1l7] true:3;
  [worker1dot1l7Retry] true:3;
  [worker2movel2] true:1;
  [worker2movel5] true:1;
  [worker2movel6] true:1;
  [worker2dot1l6] true:3;
  [worker2dot1l6Retry] true:3;
endrewards