dtmc
evolve int r1_maxRetry_t2l1 [1..10];
evolve int r1_maxRetry_t3l1 [1..10];
evolve int r2_maxRetry_t2l2a [1..10];
evolve int r2_maxRetry_t2l2b [1..10];
evolve int r2_maxRetry_t2l5 [1..10];
evolve int r2_maxRetry_t2l9 [1..10];
evolve int r2_maxRetry_t3l9 [1..10];
evolve int r2_maxRetry_t2l6 [1..10];
evolve int worker1_maxRetry_t1l4b [1..5];
evolve int worker1_maxRetry_t1l4a [1..5];
evolve int worker1_maxRetry_t3l7 [1..5];
evolve int worker1_maxRetry_t1l9 [1..5];

const double p_r1_t2l1=0.99;
const double p_r1_t3l1=0.97;
const double p_r2_t2l2a=0.99;
const double p_r2_t2l2b=0.99;
const double p_r2_t2l5=0.99;
const double p_r2_t2l9=0.99;
const double p_r2_t3l9=0.97;
const double p_r2_t2l6=0.99;
const double p_worker1_t1l4b=1.0;
const double p_worker1_t1l4a=1.0;
const double p_worker1_t3l7=0.99;
const double p_worker1_t1l9=1.0;
const int r1Final = 2;
const int r1Fail = 3;
const int r2Final = 11;
const int r2Fail = 12;
const int worker1Final = 8;
const int worker1Fail = 9;

module _r1
  r1 : [0..4];
  r1retry_t2l1 : [0..r1_maxRetry_t2l1] init 0;
  r1retry_t3l1 : [0..r1_maxRetry_t3l1] init 0;

  [r1dot2l1Retry] r1=0 & r1retry_t2l1 < r1_maxRetry_t2l1 -> p_r1_t2l1 : (r1'=r1+1) + (1-p_r1_t2l1) : (r1'=r1) & (r1retry_t2l1' = r1retry_t2l1+1);
  [r1dot2l1] r1=0 & r1retry_t2l1 >= r1_maxRetry_t2l1 -> 1:(r1'=r1Fail);
  [r1dot3l1Retry] r1=1 & r1retry_t3l1 < r1_maxRetry_t3l1 -> p_r1_t3l1 : (r1'=r1+1) + (1-p_r1_t3l1) : (r1'=r1) & (r1retry_t3l1' = r1retry_t3l1+1);
  [r1dot3l1] r1=1 & r1retry_t3l1 >= r1_maxRetry_t3l1 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..13];
  r2retry_t2l2a : [0..r2_maxRetry_t2l2a] init 0;
  r2retry_t2l2b : [0..r2_maxRetry_t2l2b] init 0;
  r2retry_t2l5 : [0..r2_maxRetry_t2l5] init 0;
  r2retry_t2l9 : [0..r2_maxRetry_t2l9] init 0;
  r2retry_t3l9 : [0..r2_maxRetry_t3l9] init 0;
  r2retry_t2l6 : [0..r2_maxRetry_t2l6] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2dot2l2aRetry] r2=1 & r2retry_t2l2a < r2_maxRetry_t2l2a -> p_r2_t2l2a : (r2'=r2+1) + (1-p_r2_t2l2a) : (r2'=r2) & (r2retry_t2l2a' = r2retry_t2l2a+1);
  [r2dot2l2a] r2=1 & r2retry_t2l2a >= r2_maxRetry_t2l2a -> 1:(r2'=r2Fail);
  [r2dot2l2bRetry] r2=2 & r2retry_t2l2b < r2_maxRetry_t2l2b -> p_r2_t2l2b : (r2'=r2+1) + (1-p_r2_t2l2b) : (r2'=r2) & (r2retry_t2l2b' = r2retry_t2l2b+1);
  [r2dot2l2b] r2=2 & r2retry_t2l2b >= r2_maxRetry_t2l2b -> 1:(r2'=r2Fail);
  [r2movel5] r2=3-> 1:(r2'=3+1);
  [r2dot2l5Retry] r2=4 & r2retry_t2l5 < r2_maxRetry_t2l5 -> p_r2_t2l5 : (r2'=r2+1) + (1-p_r2_t2l5) : (r2'=r2) & (r2retry_t2l5' = r2retry_t2l5+1);
  [r2dot2l5] r2=4 & r2retry_t2l5 >= r2_maxRetry_t2l5 -> 1:(r2'=r2Fail);
  [r2movel8] r2=5-> 1:(r2'=5+1);
  [r2movel9] r2=6-> 1:(r2'=6+1);
  [r2dot2l9Retry] r2=7 & r2retry_t2l9 < r2_maxRetry_t2l9 -> p_r2_t2l9 : (r2'=r2+1) + (1-p_r2_t2l9) : (r2'=r2) & (r2retry_t2l9' = r2retry_t2l9+1);
  [r2dot2l9] r2=7 & r2retry_t2l9 >= r2_maxRetry_t2l9 -> 1:(r2'=r2Fail);
  [r2dot3l9Retry] r2=8 & r2retry_t3l9 < r2_maxRetry_t3l9 -> p_r2_t3l9 : (r2'=r2+1) + (1-p_r2_t3l9) : (r2'=r2) & (r2retry_t3l9' = r2retry_t3l9+1);
  [r2dot3l9] r2=8 & r2retry_t3l9 >= r2_maxRetry_t3l9 -> 1:(r2'=r2Fail);
  [r2movel6] r2=9-> 1:(r2'=9+1);
  [r2dot2l6Retry] r2=10 & r2retry_t2l6 < r2_maxRetry_t2l6 -> p_r2_t2l6 : (r2'=r2+1) + (1-p_r2_t2l6) : (r2'=r2) & (r2retry_t2l6' = r2retry_t2l6+1);
  [r2dot2l6] r2=10 & r2retry_t2l6 >= r2_maxRetry_t2l6 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..10];
  worker1retry_t1l4b : [0..worker1_maxRetry_t1l4b] init 0;
  worker1retry_t1l4a : [0..worker1_maxRetry_t1l4a] init 0;
  worker1retry_t3l7 : [0..worker1_maxRetry_t3l7] init 0;
  worker1retry_t1l9 : [0..worker1_maxRetry_t1l9] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l4bRetry] worker1=1 & worker1retry_t1l4b < worker1_maxRetry_t1l4b -> p_worker1_t1l4b : (worker1'=worker1+1) + (1-p_worker1_t1l4b) : (worker1'=worker1) & (worker1retry_t1l4b' = worker1retry_t1l4b+1);
  [worker1dot1l4b] worker1=1 & worker1retry_t1l4b >= worker1_maxRetry_t1l4b -> 1:(worker1'=worker1Fail);
  [worker1dot1l4aRetry] worker1=2 & worker1retry_t1l4a < worker1_maxRetry_t1l4a -> p_worker1_t1l4a : (worker1'=worker1+1) + (1-p_worker1_t1l4a) : (worker1'=worker1) & (worker1retry_t1l4a' = worker1retry_t1l4a+1);
  [worker1dot1l4a] worker1=2 & worker1retry_t1l4a >= worker1_maxRetry_t1l4a -> 1:(worker1'=worker1Fail);
  [worker1movel7] worker1=3-> 1:(worker1'=3+1);
  [worker1dot3l7Retry] worker1=4 & worker1retry_t3l7 < worker1_maxRetry_t3l7 -> p_worker1_t3l7 : (worker1'=worker1+1) + (1-p_worker1_t3l7) : (worker1'=worker1) & (worker1retry_t3l7' = worker1retry_t3l7+1);
  [worker1dot3l7] worker1=4 & worker1retry_t3l7 >= worker1_maxRetry_t3l7 -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=5-> 1:(worker1'=5+1);
  [worker1movel9] worker1=6-> 1:(worker1'=6+1);
  [worker1dot1l9Retry] worker1=7 & worker1retry_t1l9 < worker1_maxRetry_t1l9 -> p_worker1_t1l9 : (worker1'=worker1+1) + (1-p_worker1_t1l9) : (worker1'=worker1) & (worker1retry_t1l9' = worker1retry_t1l9+1);
  [worker1dot1l9] worker1=7 & worker1retry_t1l9 >= worker1_maxRetry_t1l9 -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [r1dot2l1] true:1;
  [r1dot2l1Retry] true:1;
  [r1dot3l1] true:1;
  [r1dot3l1Retry] true:1;
  [r2movel2] true:1;
  [r2dot2l2a] true:1;
  [r2dot2l2aRetry] true:1;
  [r2dot2l2b] true:1;
  [r2dot2l2bRetry] true:1;
  [r2movel5] true:1;
  [r2dot2l5] true:1;
  [r2dot2l5Retry] true:1;
  [r2movel8] true:1;
  [r2movel9] true:1;
  [r2dot2l9] true:1;
  [r2dot2l9Retry] true:1;
  [r2dot3l9] true:1;
  [r2dot3l9Retry] true:1;
  [r2movel6] true:1;
  [r2dot2l6] true:1;
  [r2dot2l6Retry] true:1;
  [worker1movel4] true:1;
  [worker1dot1l4b] true:3;
  [worker1dot1l4bRetry] true:3;
  [worker1dot1l4a] true:3;
  [worker1dot1l4aRetry] true:3;
  [worker1movel7] true:1;
  [worker1dot3l7] true:5;
  [worker1dot3l7Retry] true:5;
  [worker1movel8] true:1;
  [worker1movel9] true:1;
  [worker1dot1l9] true:3;
  [worker1dot1l9Retry] true:3;
endrewards