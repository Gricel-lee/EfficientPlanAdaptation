dtmc
evolve int worker2_maxRetry_t1l4 [1..5];
evolve int worker2_maxRetry_t3l6a [1..5];
evolve int worker2_maxRetry_t3l6b [1..5];
evolve int worker2_maxRetry_t1l9 [1..5];
evolve int r1_maxRetry_t3l1 [1..10];
evolve int r1_maxRetry_t2l4 [1..10];
evolve int r1_maxRetry_t3l4 [1..10];
evolve int r1_maxRetry_t3l7b [1..10];
evolve int r1_maxRetry_t3l7a [1..10];
evolve int r2_maxRetry_t2l2b [1..10];
evolve int r2_maxRetry_t2l2a [1..10];
evolve int worker1_maxRetry_t1l1b [1..5];
evolve int worker1_maxRetry_t1l1a [1..5];

const double p_worker2_t1l4=1.0;
const double p_worker2_t3l6a=0.99;
const double p_worker2_t3l6b=0.99;
const double p_worker2_t1l9=1.0;
const double p_r1_t3l1=0.97;
const double p_r1_t2l4=0.99;
const double p_r1_t3l4=0.97;
const double p_r1_t3l7b=0.97;
const double p_r1_t3l7a=0.97;
const double p_r2_t2l2b=0.99;
const double p_r2_t2l2a=0.99;
const double p_worker1_t1l1b=1.0;
const double p_worker1_t1l1a=1.0;
const int worker2Final = 8;
const int worker2Fail = 9;
const int r1Final = 7;
const int r1Fail = 8;
const int r2Final = 3;
const int r2Fail = 4;
const int worker1Final = 2;
const int worker1Fail = 3;

module _worker2
  worker2 : [0..10];
  worker2retry_t1l4 : [0..worker2_maxRetry_t1l4] init 0;
  worker2retry_t3l6a : [0..worker2_maxRetry_t3l6a] init 0;
  worker2retry_t3l6b : [0..worker2_maxRetry_t3l6b] init 0;
  worker2retry_t1l9 : [0..worker2_maxRetry_t1l9] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l4Retry] worker2=1 & worker2retry_t1l4 < worker2_maxRetry_t1l4 -> p_worker2_t1l4 : (worker2'=worker2+1) + (1-p_worker2_t1l4) : (worker2'=worker2) & (worker2retry_t1l4' = worker2retry_t1l4+1);
  [worker2dot1l4] worker2=1 & worker2retry_t1l4 >= worker2_maxRetry_t1l4 -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=2-> 1:(worker2'=2+1);
  [worker2movel6] worker2=3-> 1:(worker2'=3+1);
  [worker2dot3l6aRetry] worker2=4 & worker2retry_t3l6a < worker2_maxRetry_t3l6a -> p_worker2_t3l6a : (worker2'=worker2+1) + (1-p_worker2_t3l6a) : (worker2'=worker2) & (worker2retry_t3l6a' = worker2retry_t3l6a+1);
  [worker2dot3l6a] worker2=4 & worker2retry_t3l6a >= worker2_maxRetry_t3l6a -> 1:(worker2'=worker2Fail);
  [worker2dot3l6bRetry] worker2=5 & worker2retry_t3l6b < worker2_maxRetry_t3l6b -> p_worker2_t3l6b : (worker2'=worker2+1) + (1-p_worker2_t3l6b) : (worker2'=worker2) & (worker2retry_t3l6b' = worker2retry_t3l6b+1);
  [worker2dot3l6b] worker2=5 & worker2retry_t3l6b >= worker2_maxRetry_t3l6b -> 1:(worker2'=worker2Fail);
  [worker2movel9] worker2=6-> 1:(worker2'=6+1);
  [worker2dot1l9Retry] worker2=7 & worker2retry_t1l9 < worker2_maxRetry_t1l9 -> p_worker2_t1l9 : (worker2'=worker2+1) + (1-p_worker2_t1l9) : (worker2'=worker2) & (worker2retry_t1l9' = worker2retry_t1l9+1);
  [worker2dot1l9] worker2=7 & worker2retry_t1l9 >= worker2_maxRetry_t1l9 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..9];
  r1retry_t3l1 : [0..r1_maxRetry_t3l1] init 0;
  r1retry_t2l4 : [0..r1_maxRetry_t2l4] init 0;
  r1retry_t3l4 : [0..r1_maxRetry_t3l4] init 0;
  r1retry_t3l7b : [0..r1_maxRetry_t3l7b] init 0;
  r1retry_t3l7a : [0..r1_maxRetry_t3l7a] init 0;

  [r1dot3l1Retry] r1=0 & r1retry_t3l1 < r1_maxRetry_t3l1 -> p_r1_t3l1 : (r1'=r1+1) + (1-p_r1_t3l1) : (r1'=r1) & (r1retry_t3l1' = r1retry_t3l1+1);
  [r1dot3l1] r1=0 & r1retry_t3l1 >= r1_maxRetry_t3l1 -> 1:(r1'=r1Fail);
  [r1movel4] r1=1-> 1:(r1'=1+1);
  [r1dot2l4Retry] r1=2 & r1retry_t2l4 < r1_maxRetry_t2l4 -> p_r1_t2l4 : (r1'=r1+1) + (1-p_r1_t2l4) : (r1'=r1) & (r1retry_t2l4' = r1retry_t2l4+1);
  [r1dot2l4] r1=2 & r1retry_t2l4 >= r1_maxRetry_t2l4 -> 1:(r1'=r1Fail);
  [r1dot3l4Retry] r1=3 & r1retry_t3l4 < r1_maxRetry_t3l4 -> p_r1_t3l4 : (r1'=r1+1) + (1-p_r1_t3l4) : (r1'=r1) & (r1retry_t3l4' = r1retry_t3l4+1);
  [r1dot3l4] r1=3 & r1retry_t3l4 >= r1_maxRetry_t3l4 -> 1:(r1'=r1Fail);
  [r1movel7] r1=4-> 1:(r1'=4+1);
  [r1dot3l7bRetry] r1=5 & r1retry_t3l7b < r1_maxRetry_t3l7b -> p_r1_t3l7b : (r1'=r1+1) + (1-p_r1_t3l7b) : (r1'=r1) & (r1retry_t3l7b' = r1retry_t3l7b+1);
  [r1dot3l7b] r1=5 & r1retry_t3l7b >= r1_maxRetry_t3l7b -> 1:(r1'=r1Fail);
  [r1dot3l7aRetry] r1=6 & r1retry_t3l7a < r1_maxRetry_t3l7a -> p_r1_t3l7a : (r1'=r1+1) + (1-p_r1_t3l7a) : (r1'=r1) & (r1retry_t3l7a' = r1retry_t3l7a+1);
  [r1dot3l7a] r1=6 & r1retry_t3l7a >= r1_maxRetry_t3l7a -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..5];
  r2retry_t2l2b : [0..r2_maxRetry_t2l2b] init 0;
  r2retry_t2l2a : [0..r2_maxRetry_t2l2a] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2dot2l2bRetry] r2=1 & r2retry_t2l2b < r2_maxRetry_t2l2b -> p_r2_t2l2b : (r2'=r2+1) + (1-p_r2_t2l2b) : (r2'=r2) & (r2retry_t2l2b' = r2retry_t2l2b+1);
  [r2dot2l2b] r2=1 & r2retry_t2l2b >= r2_maxRetry_t2l2b -> 1:(r2'=r2Fail);
  [r2dot2l2aRetry] r2=2 & r2retry_t2l2a < r2_maxRetry_t2l2a -> p_r2_t2l2a : (r2'=r2+1) + (1-p_r2_t2l2a) : (r2'=r2) & (r2retry_t2l2a' = r2retry_t2l2a+1);
  [r2dot2l2a] r2=2 & r2retry_t2l2a >= r2_maxRetry_t2l2a -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..4];
  worker1retry_t1l1b : [0..worker1_maxRetry_t1l1b] init 0;
  worker1retry_t1l1a : [0..worker1_maxRetry_t1l1a] init 0;

  [worker1dot1l1bRetry] worker1=0 & worker1retry_t1l1b < worker1_maxRetry_t1l1b -> p_worker1_t1l1b : (worker1'=worker1+1) + (1-p_worker1_t1l1b) : (worker1'=worker1) & (worker1retry_t1l1b' = worker1retry_t1l1b+1);
  [worker1dot1l1b] worker1=0 & worker1retry_t1l1b >= worker1_maxRetry_t1l1b -> 1:(worker1'=worker1Fail);
  [worker1dot1l1aRetry] worker1=1 & worker1retry_t1l1a < worker1_maxRetry_t1l1a -> p_worker1_t1l1a : (worker1'=worker1+1) + (1-p_worker1_t1l1a) : (worker1'=worker1) & (worker1retry_t1l1a' = worker1retry_t1l1a+1);
  [worker1dot1l1a] worker1=1 & worker1retry_t1l1a >= worker1_maxRetry_t1l1a -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [worker2movel4] true:1;
  [worker2dot1l4] true:3;
  [worker2dot1l4Retry] true:3;
  [worker2movel5] true:1;
  [worker2movel6] true:1;
  [worker2dot3l6a] true:5;
  [worker2dot3l6aRetry] true:5;
  [worker2dot3l6b] true:5;
  [worker2dot3l6bRetry] true:5;
  [worker2movel9] true:1;
  [worker2dot1l9] true:3;
  [worker2dot1l9Retry] true:3;
  [r1dot3l1] true:1;
  [r1dot3l1Retry] true:1;
  [r1movel4] true:1;
  [r1dot2l4] true:1;
  [r1dot2l4Retry] true:1;
  [r1dot3l4] true:1;
  [r1dot3l4Retry] true:1;
  [r1movel7] true:1;
  [r1dot3l7b] true:1;
  [r1dot3l7bRetry] true:1;
  [r1dot3l7a] true:1;
  [r1dot3l7aRetry] true:1;
  [r2movel2] true:1;
  [r2dot2l2b] true:1;
  [r2dot2l2bRetry] true:1;
  [r2dot2l2a] true:1;
  [r2dot2l2aRetry] true:1;
  [worker1dot1l1b] true:3;
  [worker1dot1l1bRetry] true:3;
  [worker1dot1l1a] true:3;
  [worker1dot1l1aRetry] true:3;
endrewards