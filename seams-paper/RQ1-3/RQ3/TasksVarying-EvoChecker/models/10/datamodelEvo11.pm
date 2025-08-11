dtmc
evolve int worker1_maxRetry_t3l7b [1..5];
evolve int worker1_maxRetry_t3l7a [1..5];
evolve int worker1_maxRetry_t1l9a [1..5];
evolve int worker1_maxRetry_t1l9b [1..5];
evolve int worker1_maxRetry_t3l9b [1..5];
evolve int worker1_maxRetry_t3l9a [1..5];
evolve int worker1_maxRetry_t1l6 [1..5];
evolve int r1_maxRetry_t3l2 [1..10];
evolve int r1_maxRetry_t2l5 [1..10];
evolve int r1_maxRetry_t3l5 [1..10];

const double p_worker1_t3l7b=0.99;
const double p_worker1_t3l7a=0.99;
const double p_worker1_t1l9a=1.0;
const double p_worker1_t1l9b=1.0;
const double p_worker1_t3l9b=0.99;
const double p_worker1_t3l9a=0.99;
const double p_worker1_t1l6=1.0;
const double p_r1_t3l2=0.97;
const double p_r1_t2l5=0.99;
const double p_r1_t3l5=0.97;
const int worker1Final = 12;
const int worker1Fail = 13;
const int r1Final = 5;
const int r1Fail = 6;

module _worker1
  worker1 : [0..14];
  worker1retry_t3l7b : [0..worker1_maxRetry_t3l7b] init 0;
  worker1retry_t3l7a : [0..worker1_maxRetry_t3l7a] init 0;
  worker1retry_t1l9a : [0..worker1_maxRetry_t1l9a] init 0;
  worker1retry_t1l9b : [0..worker1_maxRetry_t1l9b] init 0;
  worker1retry_t3l9b : [0..worker1_maxRetry_t3l9b] init 0;
  worker1retry_t3l9a : [0..worker1_maxRetry_t3l9a] init 0;
  worker1retry_t1l6 : [0..worker1_maxRetry_t1l6] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1movel7] worker1=1-> 1:(worker1'=1+1);
  [worker1dot3l7bRetry] worker1=2 & worker1retry_t3l7b < worker1_maxRetry_t3l7b -> p_worker1_t3l7b : (worker1'=worker1+1) + (1-p_worker1_t3l7b) : (worker1'=worker1) & (worker1retry_t3l7b' = worker1retry_t3l7b+1);
  [worker1dot3l7b] worker1=2 & worker1retry_t3l7b >= worker1_maxRetry_t3l7b -> 1:(worker1'=worker1Fail);
  [worker1dot3l7aRetry] worker1=3 & worker1retry_t3l7a < worker1_maxRetry_t3l7a -> p_worker1_t3l7a : (worker1'=worker1+1) + (1-p_worker1_t3l7a) : (worker1'=worker1) & (worker1retry_t3l7a' = worker1retry_t3l7a+1);
  [worker1dot3l7a] worker1=3 & worker1retry_t3l7a >= worker1_maxRetry_t3l7a -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=4-> 1:(worker1'=4+1);
  [worker1movel9] worker1=5-> 1:(worker1'=5+1);
  [worker1dot1l9aRetry] worker1=6 & worker1retry_t1l9a < worker1_maxRetry_t1l9a -> p_worker1_t1l9a : (worker1'=worker1+1) + (1-p_worker1_t1l9a) : (worker1'=worker1) & (worker1retry_t1l9a' = worker1retry_t1l9a+1);
  [worker1dot1l9a] worker1=6 & worker1retry_t1l9a >= worker1_maxRetry_t1l9a -> 1:(worker1'=worker1Fail);
  [worker1dot1l9bRetry] worker1=7 & worker1retry_t1l9b < worker1_maxRetry_t1l9b -> p_worker1_t1l9b : (worker1'=worker1+1) + (1-p_worker1_t1l9b) : (worker1'=worker1) & (worker1retry_t1l9b' = worker1retry_t1l9b+1);
  [worker1dot1l9b] worker1=7 & worker1retry_t1l9b >= worker1_maxRetry_t1l9b -> 1:(worker1'=worker1Fail);
  [worker1dot3l9bRetry] worker1=8 & worker1retry_t3l9b < worker1_maxRetry_t3l9b -> p_worker1_t3l9b : (worker1'=worker1+1) + (1-p_worker1_t3l9b) : (worker1'=worker1) & (worker1retry_t3l9b' = worker1retry_t3l9b+1);
  [worker1dot3l9b] worker1=8 & worker1retry_t3l9b >= worker1_maxRetry_t3l9b -> 1:(worker1'=worker1Fail);
  [worker1dot3l9aRetry] worker1=9 & worker1retry_t3l9a < worker1_maxRetry_t3l9a -> p_worker1_t3l9a : (worker1'=worker1+1) + (1-p_worker1_t3l9a) : (worker1'=worker1) & (worker1retry_t3l9a' = worker1retry_t3l9a+1);
  [worker1dot3l9a] worker1=9 & worker1retry_t3l9a >= worker1_maxRetry_t3l9a -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=10-> 1:(worker1'=10+1);
  [worker1dot1l6Retry] worker1=11 & worker1retry_t1l6 < worker1_maxRetry_t1l6 -> p_worker1_t1l6 : (worker1'=worker1+1) + (1-p_worker1_t1l6) : (worker1'=worker1) & (worker1retry_t1l6' = worker1retry_t1l6+1);
  [worker1dot1l6] worker1=11 & worker1retry_t1l6 >= worker1_maxRetry_t1l6 -> 1:(worker1'=worker1Fail);
endmodule

module _r1
  r1 : [0..7];
  r1retry_t3l2 : [0..r1_maxRetry_t3l2] init 0;
  r1retry_t2l5 : [0..r1_maxRetry_t2l5] init 0;
  r1retry_t3l5 : [0..r1_maxRetry_t3l5] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1dot3l2Retry] r1=1 & r1retry_t3l2 < r1_maxRetry_t3l2 -> p_r1_t3l2 : (r1'=r1+1) + (1-p_r1_t3l2) : (r1'=r1) & (r1retry_t3l2' = r1retry_t3l2+1);
  [r1dot3l2] r1=1 & r1retry_t3l2 >= r1_maxRetry_t3l2 -> 1:(r1'=r1Fail);
  [r1movel5] r1=2-> 1:(r1'=2+1);
  [r1dot2l5Retry] r1=3 & r1retry_t2l5 < r1_maxRetry_t2l5 -> p_r1_t2l5 : (r1'=r1+1) + (1-p_r1_t2l5) : (r1'=r1) & (r1retry_t2l5' = r1retry_t2l5+1);
  [r1dot2l5] r1=3 & r1retry_t2l5 >= r1_maxRetry_t2l5 -> 1:(r1'=r1Fail);
  [r1dot3l5Retry] r1=4 & r1retry_t3l5 < r1_maxRetry_t3l5 -> p_r1_t3l5 : (r1'=r1+1) + (1-p_r1_t3l5) : (r1'=r1) & (r1retry_t3l5' = r1retry_t3l5+1);
  [r1dot3l5] r1=4 & r1retry_t3l5 >= r1_maxRetry_t3l5 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [worker1movel4] true:1;
  [worker1movel7] true:1;
  [worker1dot3l7b] true:5;
  [worker1dot3l7bRetry] true:5;
  [worker1dot3l7a] true:5;
  [worker1dot3l7aRetry] true:5;
  [worker1movel8] true:1;
  [worker1movel9] true:1;
  [worker1dot1l9a] true:3;
  [worker1dot1l9aRetry] true:3;
  [worker1dot1l9b] true:3;
  [worker1dot1l9bRetry] true:3;
  [worker1dot3l9b] true:5;
  [worker1dot3l9bRetry] true:5;
  [worker1dot3l9a] true:5;
  [worker1dot3l9aRetry] true:5;
  [worker1movel6] true:1;
  [worker1dot1l6] true:3;
  [worker1dot1l6Retry] true:3;
  [r1movel2] true:1;
  [r1dot3l2] true:1;
  [r1dot3l2Retry] true:1;
  [r1movel5] true:1;
  [r1dot2l5] true:1;
  [r1dot2l5Retry] true:1;
  [r1dot3l5] true:1;
  [r1dot3l5Retry] true:1;
endrewards