dtmc
evolve int r1_maxRetry_t2l1 [1..10];
evolve int r1_maxRetry_t3l1 [1..10];
evolve int r1_maxRetry_t2l2 [1..10];
evolve int r1_maxRetry_t2l5 [1..10];
evolve int r1_maxRetry_t3l8 [1..10];
evolve int r1_maxRetry_t2l8 [1..10];
evolve int worker2_maxRetry_t1l7b [1..5];
evolve int worker2_maxRetry_t1l7a [1..5];
evolve int worker2_maxRetry_t1l8b [1..5];
evolve int worker2_maxRetry_t1l8a [1..5];
evolve int worker2_maxRetry_t1l9 [1..5];
evolve int worker2_maxRetry_t3l6 [1..5];

const double p_r1_t2l1=0.99;
const double p_r1_t3l1=0.97;
const double p_r1_t2l2=0.99;
const double p_r1_t2l5=0.99;
const double p_r1_t3l8=0.97;
const double p_r1_t2l8=0.99;
const double p_worker2_t1l7b=1.0;
const double p_worker2_t1l7a=1.0;
const double p_worker2_t1l8b=1.0;
const double p_worker2_t1l8a=1.0;
const double p_worker2_t1l9=1.0;
const double p_worker2_t3l6=0.99;
const int r1Final = 9;
const int r1Fail = 10;
const int worker2Final = 11;
const int worker2Fail = 12;

module _r1
  r1 : [0..11];
  r1retry_t2l1 : [0..r1_maxRetry_t2l1] init 0;
  r1retry_t3l1 : [0..r1_maxRetry_t3l1] init 0;
  r1retry_t2l2 : [0..r1_maxRetry_t2l2] init 0;
  r1retry_t2l5 : [0..r1_maxRetry_t2l5] init 0;
  r1retry_t3l8 : [0..r1_maxRetry_t3l8] init 0;
  r1retry_t2l8 : [0..r1_maxRetry_t2l8] init 0;

  [r1dot2l1Retry] r1=0 & r1retry_t2l1 < r1_maxRetry_t2l1 -> p_r1_t2l1 : (r1'=r1+1) + (1-p_r1_t2l1) : (r1'=r1) & (r1retry_t2l1' = r1retry_t2l1+1);
  [r1dot2l1] r1=0 & r1retry_t2l1 >= r1_maxRetry_t2l1 -> 1:(r1'=r1Fail);
  [r1dot3l1Retry] r1=1 & r1retry_t3l1 < r1_maxRetry_t3l1 -> p_r1_t3l1 : (r1'=r1+1) + (1-p_r1_t3l1) : (r1'=r1) & (r1retry_t3l1' = r1retry_t3l1+1);
  [r1dot3l1] r1=1 & r1retry_t3l1 >= r1_maxRetry_t3l1 -> 1:(r1'=r1Fail);
  [r1movel2] r1=2-> 1:(r1'=2+1);
  [r1dot2l2Retry] r1=3 & r1retry_t2l2 < r1_maxRetry_t2l2 -> p_r1_t2l2 : (r1'=r1+1) + (1-p_r1_t2l2) : (r1'=r1) & (r1retry_t2l2' = r1retry_t2l2+1);
  [r1dot2l2] r1=3 & r1retry_t2l2 >= r1_maxRetry_t2l2 -> 1:(r1'=r1Fail);
  [r1movel5] r1=4-> 1:(r1'=4+1);
  [r1dot2l5Retry] r1=5 & r1retry_t2l5 < r1_maxRetry_t2l5 -> p_r1_t2l5 : (r1'=r1+1) + (1-p_r1_t2l5) : (r1'=r1) & (r1retry_t2l5' = r1retry_t2l5+1);
  [r1dot2l5] r1=5 & r1retry_t2l5 >= r1_maxRetry_t2l5 -> 1:(r1'=r1Fail);
  [r1movel8] r1=6-> 1:(r1'=6+1);
  [r1dot3l8Retry] r1=7 & r1retry_t3l8 < r1_maxRetry_t3l8 -> p_r1_t3l8 : (r1'=r1+1) + (1-p_r1_t3l8) : (r1'=r1) & (r1retry_t3l8' = r1retry_t3l8+1);
  [r1dot3l8] r1=7 & r1retry_t3l8 >= r1_maxRetry_t3l8 -> 1:(r1'=r1Fail);
  [r1dot2l8Retry] r1=8 & r1retry_t2l8 < r1_maxRetry_t2l8 -> p_r1_t2l8 : (r1'=r1+1) + (1-p_r1_t2l8) : (r1'=r1) & (r1retry_t2l8' = r1retry_t2l8+1);
  [r1dot2l8] r1=8 & r1retry_t2l8 >= r1_maxRetry_t2l8 -> 1:(r1'=r1Fail);
endmodule

module _worker2
  worker2 : [0..13];
  worker2retry_t1l7b : [0..worker2_maxRetry_t1l7b] init 0;
  worker2retry_t1l7a : [0..worker2_maxRetry_t1l7a] init 0;
  worker2retry_t1l8b : [0..worker2_maxRetry_t1l8b] init 0;
  worker2retry_t1l8a : [0..worker2_maxRetry_t1l8a] init 0;
  worker2retry_t1l9 : [0..worker2_maxRetry_t1l9] init 0;
  worker2retry_t3l6 : [0..worker2_maxRetry_t3l6] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2movel7] worker2=1-> 1:(worker2'=1+1);
  [worker2dot1l7bRetry] worker2=2 & worker2retry_t1l7b < worker2_maxRetry_t1l7b -> p_worker2_t1l7b : (worker2'=worker2+1) + (1-p_worker2_t1l7b) : (worker2'=worker2) & (worker2retry_t1l7b' = worker2retry_t1l7b+1);
  [worker2dot1l7b] worker2=2 & worker2retry_t1l7b >= worker2_maxRetry_t1l7b -> 1:(worker2'=worker2Fail);
  [worker2dot1l7aRetry] worker2=3 & worker2retry_t1l7a < worker2_maxRetry_t1l7a -> p_worker2_t1l7a : (worker2'=worker2+1) + (1-p_worker2_t1l7a) : (worker2'=worker2) & (worker2retry_t1l7a' = worker2retry_t1l7a+1);
  [worker2dot1l7a] worker2=3 & worker2retry_t1l7a >= worker2_maxRetry_t1l7a -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=4-> 1:(worker2'=4+1);
  [worker2dot1l8bRetry] worker2=5 & worker2retry_t1l8b < worker2_maxRetry_t1l8b -> p_worker2_t1l8b : (worker2'=worker2+1) + (1-p_worker2_t1l8b) : (worker2'=worker2) & (worker2retry_t1l8b' = worker2retry_t1l8b+1);
  [worker2dot1l8b] worker2=5 & worker2retry_t1l8b >= worker2_maxRetry_t1l8b -> 1:(worker2'=worker2Fail);
  [worker2dot1l8aRetry] worker2=6 & worker2retry_t1l8a < worker2_maxRetry_t1l8a -> p_worker2_t1l8a : (worker2'=worker2+1) + (1-p_worker2_t1l8a) : (worker2'=worker2) & (worker2retry_t1l8a' = worker2retry_t1l8a+1);
  [worker2dot1l8a] worker2=6 & worker2retry_t1l8a >= worker2_maxRetry_t1l8a -> 1:(worker2'=worker2Fail);
  [worker2movel9] worker2=7-> 1:(worker2'=7+1);
  [worker2dot1l9Retry] worker2=8 & worker2retry_t1l9 < worker2_maxRetry_t1l9 -> p_worker2_t1l9 : (worker2'=worker2+1) + (1-p_worker2_t1l9) : (worker2'=worker2) & (worker2retry_t1l9' = worker2retry_t1l9+1);
  [worker2dot1l9] worker2=8 & worker2retry_t1l9 >= worker2_maxRetry_t1l9 -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=9-> 1:(worker2'=9+1);
  [worker2dot3l6Retry] worker2=10 & worker2retry_t3l6 < worker2_maxRetry_t3l6 -> p_worker2_t3l6 : (worker2'=worker2+1) + (1-p_worker2_t3l6) : (worker2'=worker2) & (worker2retry_t3l6' = worker2retry_t3l6+1);
  [worker2dot3l6] worker2=10 & worker2retry_t3l6 >= worker2_maxRetry_t3l6 -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r1dot2l1] true:1;
  [r1dot2l1Retry] true:1;
  [r1dot3l1] true:1;
  [r1dot3l1Retry] true:1;
  [r1movel2] true:1;
  [r1dot2l2] true:1;
  [r1dot2l2Retry] true:1;
  [r1movel5] true:1;
  [r1dot2l5] true:1;
  [r1dot2l5Retry] true:1;
  [r1movel8] true:1;
  [r1dot3l8] true:1;
  [r1dot3l8Retry] true:1;
  [r1dot2l8] true:1;
  [r1dot2l8Retry] true:1;
  [worker2movel4] true:1;
  [worker2movel7] true:1;
  [worker2dot1l7b] true:3;
  [worker2dot1l7bRetry] true:3;
  [worker2dot1l7a] true:3;
  [worker2dot1l7aRetry] true:3;
  [worker2movel8] true:1;
  [worker2dot1l8b] true:3;
  [worker2dot1l8bRetry] true:3;
  [worker2dot1l8a] true:3;
  [worker2dot1l8aRetry] true:3;
  [worker2movel9] true:1;
  [worker2dot1l9] true:3;
  [worker2dot1l9Retry] true:3;
  [worker2movel6] true:1;
  [worker2dot3l6] true:5;
  [worker2dot3l6Retry] true:5;
endrewards