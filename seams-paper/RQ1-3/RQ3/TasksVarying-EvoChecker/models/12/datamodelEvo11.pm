dtmc
evolve int r1_maxRetry_t3l1 [1..10];
evolve int r2_maxRetry_t2l4 [1..10];
evolve int r2_maxRetry_t2l5 [1..10];
evolve int r2_maxRetry_t3l8 [1..10];
evolve int r2_maxRetry_t3l7a [1..10];
evolve int r2_maxRetry_t3l7b [1..10];
evolve int r2_maxRetry_t3l7c [1..10];
evolve int worker1_maxRetry_t3l2 [1..5];
evolve int worker1_maxRetry_t3l6a [1..5];
evolve int worker1_maxRetry_t3l6b [1..5];
evolve int worker1_maxRetry_t1l6a [1..5];
evolve int worker1_maxRetry_t1l6b [1..5];

const double p_r1_t3l1=0.97;
const double p_r2_t2l4=0.99;
const double p_r2_t2l5=0.99;
const double p_r2_t3l8=0.97;
const double p_r2_t3l7a=0.97;
const double p_r2_t3l7b=0.97;
const double p_r2_t3l7c=0.97;
const double p_worker1_t3l2=0.99;
const double p_worker1_t3l6a=0.99;
const double p_worker1_t3l6b=0.99;
const double p_worker1_t1l6a=1.0;
const double p_worker1_t1l6b=1.0;
const int r1Final = 1;
const int r1Fail = 2;
const int r2Final = 10;
const int r2Fail = 11;
const int worker1Final = 8;
const int worker1Fail = 9;

module _r1
  r1 : [0..3];
  r1retry_t3l1 : [0..r1_maxRetry_t3l1] init 0;

  [r1dot3l1Retry] r1=0 & r1retry_t3l1 < r1_maxRetry_t3l1 -> p_r1_t3l1 : (r1'=r1+1) + (1-p_r1_t3l1) : (r1'=r1) & (r1retry_t3l1' = r1retry_t3l1+1);
  [r1dot3l1] r1=0 & r1retry_t3l1 >= r1_maxRetry_t3l1 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..12];
  r2retry_t2l4 : [0..r2_maxRetry_t2l4] init 0;
  r2retry_t2l5 : [0..r2_maxRetry_t2l5] init 0;
  r2retry_t3l8 : [0..r2_maxRetry_t3l8] init 0;
  r2retry_t3l7a : [0..r2_maxRetry_t3l7a] init 0;
  r2retry_t3l7b : [0..r2_maxRetry_t3l7b] init 0;
  r2retry_t3l7c : [0..r2_maxRetry_t3l7c] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2dot2l4Retry] r2=1 & r2retry_t2l4 < r2_maxRetry_t2l4 -> p_r2_t2l4 : (r2'=r2+1) + (1-p_r2_t2l4) : (r2'=r2) & (r2retry_t2l4' = r2retry_t2l4+1);
  [r2dot2l4] r2=1 & r2retry_t2l4 >= r2_maxRetry_t2l4 -> 1:(r2'=r2Fail);
  [r2movel5] r2=2-> 1:(r2'=2+1);
  [r2dot2l5Retry] r2=3 & r2retry_t2l5 < r2_maxRetry_t2l5 -> p_r2_t2l5 : (r2'=r2+1) + (1-p_r2_t2l5) : (r2'=r2) & (r2retry_t2l5' = r2retry_t2l5+1);
  [r2dot2l5] r2=3 & r2retry_t2l5 >= r2_maxRetry_t2l5 -> 1:(r2'=r2Fail);
  [r2movel8] r2=4-> 1:(r2'=4+1);
  [r2dot3l8Retry] r2=5 & r2retry_t3l8 < r2_maxRetry_t3l8 -> p_r2_t3l8 : (r2'=r2+1) + (1-p_r2_t3l8) : (r2'=r2) & (r2retry_t3l8' = r2retry_t3l8+1);
  [r2dot3l8] r2=5 & r2retry_t3l8 >= r2_maxRetry_t3l8 -> 1:(r2'=r2Fail);
  [r2movel7] r2=6-> 1:(r2'=6+1);
  [r2dot3l7aRetry] r2=7 & r2retry_t3l7a < r2_maxRetry_t3l7a -> p_r2_t3l7a : (r2'=r2+1) + (1-p_r2_t3l7a) : (r2'=r2) & (r2retry_t3l7a' = r2retry_t3l7a+1);
  [r2dot3l7a] r2=7 & r2retry_t3l7a >= r2_maxRetry_t3l7a -> 1:(r2'=r2Fail);
  [r2dot3l7bRetry] r2=8 & r2retry_t3l7b < r2_maxRetry_t3l7b -> p_r2_t3l7b : (r2'=r2+1) + (1-p_r2_t3l7b) : (r2'=r2) & (r2retry_t3l7b' = r2retry_t3l7b+1);
  [r2dot3l7b] r2=8 & r2retry_t3l7b >= r2_maxRetry_t3l7b -> 1:(r2'=r2Fail);
  [r2dot3l7cRetry] r2=9 & r2retry_t3l7c < r2_maxRetry_t3l7c -> p_r2_t3l7c : (r2'=r2+1) + (1-p_r2_t3l7c) : (r2'=r2) & (r2retry_t3l7c' = r2retry_t3l7c+1);
  [r2dot3l7c] r2=9 & r2retry_t3l7c >= r2_maxRetry_t3l7c -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..10];
  worker1retry_t3l2 : [0..worker1_maxRetry_t3l2] init 0;
  worker1retry_t3l6a : [0..worker1_maxRetry_t3l6a] init 0;
  worker1retry_t3l6b : [0..worker1_maxRetry_t3l6b] init 0;
  worker1retry_t1l6a : [0..worker1_maxRetry_t1l6a] init 0;
  worker1retry_t1l6b : [0..worker1_maxRetry_t1l6b] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1dot3l2Retry] worker1=1 & worker1retry_t3l2 < worker1_maxRetry_t3l2 -> p_worker1_t3l2 : (worker1'=worker1+1) + (1-p_worker1_t3l2) : (worker1'=worker1) & (worker1retry_t3l2' = worker1retry_t3l2+1);
  [worker1dot3l2] worker1=1 & worker1retry_t3l2 >= worker1_maxRetry_t3l2 -> 1:(worker1'=worker1Fail);
  [worker1movel3] worker1=2-> 1:(worker1'=2+1);
  [worker1movel6] worker1=3-> 1:(worker1'=3+1);
  [worker1dot3l6aRetry] worker1=4 & worker1retry_t3l6a < worker1_maxRetry_t3l6a -> p_worker1_t3l6a : (worker1'=worker1+1) + (1-p_worker1_t3l6a) : (worker1'=worker1) & (worker1retry_t3l6a' = worker1retry_t3l6a+1);
  [worker1dot3l6a] worker1=4 & worker1retry_t3l6a >= worker1_maxRetry_t3l6a -> 1:(worker1'=worker1Fail);
  [worker1dot3l6bRetry] worker1=5 & worker1retry_t3l6b < worker1_maxRetry_t3l6b -> p_worker1_t3l6b : (worker1'=worker1+1) + (1-p_worker1_t3l6b) : (worker1'=worker1) & (worker1retry_t3l6b' = worker1retry_t3l6b+1);
  [worker1dot3l6b] worker1=5 & worker1retry_t3l6b >= worker1_maxRetry_t3l6b -> 1:(worker1'=worker1Fail);
  [worker1dot1l6aRetry] worker1=6 & worker1retry_t1l6a < worker1_maxRetry_t1l6a -> p_worker1_t1l6a : (worker1'=worker1+1) + (1-p_worker1_t1l6a) : (worker1'=worker1) & (worker1retry_t1l6a' = worker1retry_t1l6a+1);
  [worker1dot1l6a] worker1=6 & worker1retry_t1l6a >= worker1_maxRetry_t1l6a -> 1:(worker1'=worker1Fail);
  [worker1dot1l6bRetry] worker1=7 & worker1retry_t1l6b < worker1_maxRetry_t1l6b -> p_worker1_t1l6b : (worker1'=worker1+1) + (1-p_worker1_t1l6b) : (worker1'=worker1) & (worker1retry_t1l6b' = worker1retry_t1l6b+1);
  [worker1dot1l6b] worker1=7 & worker1retry_t1l6b >= worker1_maxRetry_t1l6b -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [r1dot3l1] true:1;
  [r1dot3l1Retry] true:1;
  [r2movel4] true:1;
  [r2dot2l4] true:1;
  [r2dot2l4Retry] true:1;
  [r2movel5] true:1;
  [r2dot2l5] true:1;
  [r2dot2l5Retry] true:1;
  [r2movel8] true:1;
  [r2dot3l8] true:1;
  [r2dot3l8Retry] true:1;
  [r2movel7] true:1;
  [r2dot3l7a] true:1;
  [r2dot3l7aRetry] true:1;
  [r2dot3l7b] true:1;
  [r2dot3l7bRetry] true:1;
  [r2dot3l7c] true:1;
  [r2dot3l7cRetry] true:1;
  [worker1movel2] true:1;
  [worker1dot3l2] true:5;
  [worker1dot3l2Retry] true:5;
  [worker1movel3] true:1;
  [worker1movel6] true:1;
  [worker1dot3l6a] true:5;
  [worker1dot3l6aRetry] true:5;
  [worker1dot3l6b] true:5;
  [worker1dot3l6bRetry] true:5;
  [worker1dot1l6a] true:3;
  [worker1dot1l6aRetry] true:3;
  [worker1dot1l6b] true:3;
  [worker1dot1l6bRetry] true:3;
endrewards