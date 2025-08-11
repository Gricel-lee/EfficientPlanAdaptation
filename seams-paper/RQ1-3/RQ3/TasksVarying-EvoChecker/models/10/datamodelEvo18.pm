dtmc
evolve int worker1_maxRetry_t1l4 [1..5];
evolve int worker1_maxRetry_t1l7 [1..5];
evolve int worker1_maxRetry_t1l8 [1..5];
evolve int worker1_maxRetry_t1l6 [1..5];
evolve int worker1_maxRetry_t3l3 [1..5];
evolve int worker2_maxRetry_t3l1 [1..5];
evolve int r2_maxRetry_t3l2 [1..10];
evolve int r2_maxRetry_t2l5b [1..10];
evolve int r2_maxRetry_t2l5a [1..10];
evolve int r2_maxRetry_t2l5c [1..10];

const double p_worker1_t1l4=1.0;
const double p_worker1_t1l7=1.0;
const double p_worker1_t1l8=1.0;
const double p_worker1_t1l6=1.0;
const double p_worker1_t3l3=0.99;
const double p_worker2_t3l1=0.99;
const double p_r2_t3l2=0.97;
const double p_r2_t2l5b=0.99;
const double p_r2_t2l5a=0.99;
const double p_r2_t2l5c=0.99;
const int worker1Final = 11;
const int worker1Fail = 12;
const int worker2Final = 1;
const int worker2Fail = 2;
const int r2Final = 6;
const int r2Fail = 7;

module _worker1
  worker1 : [0..13];
  worker1retry_t1l4 : [0..worker1_maxRetry_t1l4] init 0;
  worker1retry_t1l7 : [0..worker1_maxRetry_t1l7] init 0;
  worker1retry_t1l8 : [0..worker1_maxRetry_t1l8] init 0;
  worker1retry_t1l6 : [0..worker1_maxRetry_t1l6] init 0;
  worker1retry_t3l3 : [0..worker1_maxRetry_t3l3] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l4Retry] worker1=1 & worker1retry_t1l4 < worker1_maxRetry_t1l4 -> p_worker1_t1l4 : (worker1'=worker1+1) + (1-p_worker1_t1l4) : (worker1'=worker1) & (worker1retry_t1l4' = worker1retry_t1l4+1);
  [worker1dot1l4] worker1=1 & worker1retry_t1l4 >= worker1_maxRetry_t1l4 -> 1:(worker1'=worker1Fail);
  [worker1movel7] worker1=2-> 1:(worker1'=2+1);
  [worker1dot1l7Retry] worker1=3 & worker1retry_t1l7 < worker1_maxRetry_t1l7 -> p_worker1_t1l7 : (worker1'=worker1+1) + (1-p_worker1_t1l7) : (worker1'=worker1) & (worker1retry_t1l7' = worker1retry_t1l7+1);
  [worker1dot1l7] worker1=3 & worker1retry_t1l7 >= worker1_maxRetry_t1l7 -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=4-> 1:(worker1'=4+1);
  [worker1dot1l8Retry] worker1=5 & worker1retry_t1l8 < worker1_maxRetry_t1l8 -> p_worker1_t1l8 : (worker1'=worker1+1) + (1-p_worker1_t1l8) : (worker1'=worker1) & (worker1retry_t1l8' = worker1retry_t1l8+1);
  [worker1dot1l8] worker1=5 & worker1retry_t1l8 >= worker1_maxRetry_t1l8 -> 1:(worker1'=worker1Fail);
  [worker1movel9] worker1=6-> 1:(worker1'=6+1);
  [worker1movel6] worker1=7-> 1:(worker1'=7+1);
  [worker1dot1l6Retry] worker1=8 & worker1retry_t1l6 < worker1_maxRetry_t1l6 -> p_worker1_t1l6 : (worker1'=worker1+1) + (1-p_worker1_t1l6) : (worker1'=worker1) & (worker1retry_t1l6' = worker1retry_t1l6+1);
  [worker1dot1l6] worker1=8 & worker1retry_t1l6 >= worker1_maxRetry_t1l6 -> 1:(worker1'=worker1Fail);
  [worker1movel3] worker1=9-> 1:(worker1'=9+1);
  [worker1dot3l3Retry] worker1=10 & worker1retry_t3l3 < worker1_maxRetry_t3l3 -> p_worker1_t3l3 : (worker1'=worker1+1) + (1-p_worker1_t3l3) : (worker1'=worker1) & (worker1retry_t3l3' = worker1retry_t3l3+1);
  [worker1dot3l3] worker1=10 & worker1retry_t3l3 >= worker1_maxRetry_t3l3 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..3];
  worker2retry_t3l1 : [0..worker2_maxRetry_t3l1] init 0;

  [worker2dot3l1Retry] worker2=0 & worker2retry_t3l1 < worker2_maxRetry_t3l1 -> p_worker2_t3l1 : (worker2'=worker2+1) + (1-p_worker2_t3l1) : (worker2'=worker2) & (worker2retry_t3l1' = worker2retry_t3l1+1);
  [worker2dot3l1] worker2=0 & worker2retry_t3l1 >= worker2_maxRetry_t3l1 -> 1:(worker2'=worker2Fail);
endmodule

module _r2
  r2 : [0..8];
  r2retry_t3l2 : [0..r2_maxRetry_t3l2] init 0;
  r2retry_t2l5b : [0..r2_maxRetry_t2l5b] init 0;
  r2retry_t2l5a : [0..r2_maxRetry_t2l5a] init 0;
  r2retry_t2l5c : [0..r2_maxRetry_t2l5c] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2dot3l2Retry] r2=1 & r2retry_t3l2 < r2_maxRetry_t3l2 -> p_r2_t3l2 : (r2'=r2+1) + (1-p_r2_t3l2) : (r2'=r2) & (r2retry_t3l2' = r2retry_t3l2+1);
  [r2dot3l2] r2=1 & r2retry_t3l2 >= r2_maxRetry_t3l2 -> 1:(r2'=r2Fail);
  [r2movel5] r2=2-> 1:(r2'=2+1);
  [r2dot2l5bRetry] r2=3 & r2retry_t2l5b < r2_maxRetry_t2l5b -> p_r2_t2l5b : (r2'=r2+1) + (1-p_r2_t2l5b) : (r2'=r2) & (r2retry_t2l5b' = r2retry_t2l5b+1);
  [r2dot2l5b] r2=3 & r2retry_t2l5b >= r2_maxRetry_t2l5b -> 1:(r2'=r2Fail);
  [r2dot2l5aRetry] r2=4 & r2retry_t2l5a < r2_maxRetry_t2l5a -> p_r2_t2l5a : (r2'=r2+1) + (1-p_r2_t2l5a) : (r2'=r2) & (r2retry_t2l5a' = r2retry_t2l5a+1);
  [r2dot2l5a] r2=4 & r2retry_t2l5a >= r2_maxRetry_t2l5a -> 1:(r2'=r2Fail);
  [r2dot2l5cRetry] r2=5 & r2retry_t2l5c < r2_maxRetry_t2l5c -> p_r2_t2l5c : (r2'=r2+1) + (1-p_r2_t2l5c) : (r2'=r2) & (r2retry_t2l5c' = r2retry_t2l5c+1);
  [r2dot2l5c] r2=5 & r2retry_t2l5c >= r2_maxRetry_t2l5c -> 1:(r2'=r2Fail);
endmodule

rewards "cost"
  [worker1movel4] true:1;
  [worker1dot1l4] true:3;
  [worker1dot1l4Retry] true:3;
  [worker1movel7] true:1;
  [worker1dot1l7] true:3;
  [worker1dot1l7Retry] true:3;
  [worker1movel8] true:1;
  [worker1dot1l8] true:3;
  [worker1dot1l8Retry] true:3;
  [worker1movel9] true:1;
  [worker1movel6] true:1;
  [worker1dot1l6] true:3;
  [worker1dot1l6Retry] true:3;
  [worker1movel3] true:1;
  [worker1dot3l3] true:5;
  [worker1dot3l3Retry] true:5;
  [worker2dot3l1] true:5;
  [worker2dot3l1Retry] true:5;
  [r2movel2] true:1;
  [r2dot3l2] true:1;
  [r2dot3l2Retry] true:1;
  [r2movel5] true:1;
  [r2dot2l5b] true:1;
  [r2dot2l5bRetry] true:1;
  [r2dot2l5a] true:1;
  [r2dot2l5aRetry] true:1;
  [r2dot2l5c] true:1;
  [r2dot2l5cRetry] true:1;
endrewards