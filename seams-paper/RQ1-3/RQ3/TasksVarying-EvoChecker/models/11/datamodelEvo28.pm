dtmc
evolve int worker1_maxRetry_t3l1 [1..5];
evolve int worker1_maxRetry_t1l1 [1..5];
evolve int worker2_maxRetry_t1l4 [1..5];
evolve int worker2_maxRetry_t3l7a [1..5];
evolve int worker2_maxRetry_t3l7c [1..5];
evolve int worker2_maxRetry_t3l7b [1..5];
evolve int worker2_maxRetry_t3l8 [1..5];
evolve int worker2_maxRetry_t3l9 [1..5];
evolve int r1_maxRetry_t2l2 [1..10];
evolve int r1_maxRetry_t3l2b [1..10];
evolve int r1_maxRetry_t3l2a [1..10];

const double p_worker1_t3l1=0.99;
const double p_worker1_t1l1=1.0;
const double p_worker2_t1l4=1.0;
const double p_worker2_t3l7a=0.99;
const double p_worker2_t3l7c=0.99;
const double p_worker2_t3l7b=0.99;
const double p_worker2_t3l8=0.99;
const double p_worker2_t3l9=0.99;
const double p_r1_t2l2=0.99;
const double p_r1_t3l2b=0.97;
const double p_r1_t3l2a=0.97;
const int worker1Final = 2;
const int worker1Fail = 3;
const int worker2Final = 10;
const int worker2Fail = 11;
const int r1Final = 4;
const int r1Fail = 5;

module _worker1
  worker1 : [0..4];
  worker1retry_t3l1 : [0..worker1_maxRetry_t3l1] init 0;
  worker1retry_t1l1 : [0..worker1_maxRetry_t1l1] init 0;

  [worker1dot3l1Retry] worker1=0 & worker1retry_t3l1 < worker1_maxRetry_t3l1 -> p_worker1_t3l1 : (worker1'=worker1+1) + (1-p_worker1_t3l1) : (worker1'=worker1) & (worker1retry_t3l1' = worker1retry_t3l1+1);
  [worker1dot3l1] worker1=0 & worker1retry_t3l1 >= worker1_maxRetry_t3l1 -> 1:(worker1'=worker1Fail);
  [worker1dot1l1Retry] worker1=1 & worker1retry_t1l1 < worker1_maxRetry_t1l1 -> p_worker1_t1l1 : (worker1'=worker1+1) + (1-p_worker1_t1l1) : (worker1'=worker1) & (worker1retry_t1l1' = worker1retry_t1l1+1);
  [worker1dot1l1] worker1=1 & worker1retry_t1l1 >= worker1_maxRetry_t1l1 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..12];
  worker2retry_t1l4 : [0..worker2_maxRetry_t1l4] init 0;
  worker2retry_t3l7a : [0..worker2_maxRetry_t3l7a] init 0;
  worker2retry_t3l7c : [0..worker2_maxRetry_t3l7c] init 0;
  worker2retry_t3l7b : [0..worker2_maxRetry_t3l7b] init 0;
  worker2retry_t3l8 : [0..worker2_maxRetry_t3l8] init 0;
  worker2retry_t3l9 : [0..worker2_maxRetry_t3l9] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l4Retry] worker2=1 & worker2retry_t1l4 < worker2_maxRetry_t1l4 -> p_worker2_t1l4 : (worker2'=worker2+1) + (1-p_worker2_t1l4) : (worker2'=worker2) & (worker2retry_t1l4' = worker2retry_t1l4+1);
  [worker2dot1l4] worker2=1 & worker2retry_t1l4 >= worker2_maxRetry_t1l4 -> 1:(worker2'=worker2Fail);
  [worker2movel7] worker2=2-> 1:(worker2'=2+1);
  [worker2dot3l7aRetry] worker2=3 & worker2retry_t3l7a < worker2_maxRetry_t3l7a -> p_worker2_t3l7a : (worker2'=worker2+1) + (1-p_worker2_t3l7a) : (worker2'=worker2) & (worker2retry_t3l7a' = worker2retry_t3l7a+1);
  [worker2dot3l7a] worker2=3 & worker2retry_t3l7a >= worker2_maxRetry_t3l7a -> 1:(worker2'=worker2Fail);
  [worker2dot3l7cRetry] worker2=4 & worker2retry_t3l7c < worker2_maxRetry_t3l7c -> p_worker2_t3l7c : (worker2'=worker2+1) + (1-p_worker2_t3l7c) : (worker2'=worker2) & (worker2retry_t3l7c' = worker2retry_t3l7c+1);
  [worker2dot3l7c] worker2=4 & worker2retry_t3l7c >= worker2_maxRetry_t3l7c -> 1:(worker2'=worker2Fail);
  [worker2dot3l7bRetry] worker2=5 & worker2retry_t3l7b < worker2_maxRetry_t3l7b -> p_worker2_t3l7b : (worker2'=worker2+1) + (1-p_worker2_t3l7b) : (worker2'=worker2) & (worker2retry_t3l7b' = worker2retry_t3l7b+1);
  [worker2dot3l7b] worker2=5 & worker2retry_t3l7b >= worker2_maxRetry_t3l7b -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=6-> 1:(worker2'=6+1);
  [worker2dot3l8Retry] worker2=7 & worker2retry_t3l8 < worker2_maxRetry_t3l8 -> p_worker2_t3l8 : (worker2'=worker2+1) + (1-p_worker2_t3l8) : (worker2'=worker2) & (worker2retry_t3l8' = worker2retry_t3l8+1);
  [worker2dot3l8] worker2=7 & worker2retry_t3l8 >= worker2_maxRetry_t3l8 -> 1:(worker2'=worker2Fail);
  [worker2movel9] worker2=8-> 1:(worker2'=8+1);
  [worker2dot3l9Retry] worker2=9 & worker2retry_t3l9 < worker2_maxRetry_t3l9 -> p_worker2_t3l9 : (worker2'=worker2+1) + (1-p_worker2_t3l9) : (worker2'=worker2) & (worker2retry_t3l9' = worker2retry_t3l9+1);
  [worker2dot3l9] worker2=9 & worker2retry_t3l9 >= worker2_maxRetry_t3l9 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..6];
  r1retry_t2l2 : [0..r1_maxRetry_t2l2] init 0;
  r1retry_t3l2b : [0..r1_maxRetry_t3l2b] init 0;
  r1retry_t3l2a : [0..r1_maxRetry_t3l2a] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1dot2l2Retry] r1=1 & r1retry_t2l2 < r1_maxRetry_t2l2 -> p_r1_t2l2 : (r1'=r1+1) + (1-p_r1_t2l2) : (r1'=r1) & (r1retry_t2l2' = r1retry_t2l2+1);
  [r1dot2l2] r1=1 & r1retry_t2l2 >= r1_maxRetry_t2l2 -> 1:(r1'=r1Fail);
  [r1dot3l2bRetry] r1=2 & r1retry_t3l2b < r1_maxRetry_t3l2b -> p_r1_t3l2b : (r1'=r1+1) + (1-p_r1_t3l2b) : (r1'=r1) & (r1retry_t3l2b' = r1retry_t3l2b+1);
  [r1dot3l2b] r1=2 & r1retry_t3l2b >= r1_maxRetry_t3l2b -> 1:(r1'=r1Fail);
  [r1dot3l2aRetry] r1=3 & r1retry_t3l2a < r1_maxRetry_t3l2a -> p_r1_t3l2a : (r1'=r1+1) + (1-p_r1_t3l2a) : (r1'=r1) & (r1retry_t3l2a' = r1retry_t3l2a+1);
  [r1dot3l2a] r1=3 & r1retry_t3l2a >= r1_maxRetry_t3l2a -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [worker1dot3l1] true:5;
  [worker1dot3l1Retry] true:5;
  [worker1dot1l1] true:3;
  [worker1dot1l1Retry] true:3;
  [worker2movel4] true:1;
  [worker2dot1l4] true:3;
  [worker2dot1l4Retry] true:3;
  [worker2movel7] true:1;
  [worker2dot3l7a] true:5;
  [worker2dot3l7aRetry] true:5;
  [worker2dot3l7c] true:5;
  [worker2dot3l7cRetry] true:5;
  [worker2dot3l7b] true:5;
  [worker2dot3l7bRetry] true:5;
  [worker2movel8] true:1;
  [worker2dot3l8] true:5;
  [worker2dot3l8Retry] true:5;
  [worker2movel9] true:1;
  [worker2dot3l9] true:5;
  [worker2dot3l9Retry] true:5;
  [r1movel2] true:1;
  [r1dot2l2] true:1;
  [r1dot2l2Retry] true:1;
  [r1dot3l2b] true:1;
  [r1dot3l2bRetry] true:1;
  [r1dot3l2a] true:1;
  [r1dot3l2aRetry] true:1;
endrewards