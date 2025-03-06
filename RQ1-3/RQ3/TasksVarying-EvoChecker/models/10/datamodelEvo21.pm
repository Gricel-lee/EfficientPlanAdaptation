dtmc
evolve int worker1_maxRetry_t3l2 [1..5];
evolve int worker1_maxRetry_t1l3 [1..5];
evolve int worker1_maxRetry_t3l3 [1..5];
evolve int worker1_maxRetry_t1l6 [1..5];
evolve int worker1_maxRetry_t3l5 [1..5];
evolve int worker1_maxRetry_t1l8a [1..5];
evolve int worker1_maxRetry_t1l8b [1..5];
evolve int worker1_maxRetry_t3l8 [1..5];
evolve int worker2_maxRetry_t3l1 [1..5];
evolve int r2_maxRetry_t2l9 [1..10];

const double p_worker1_t3l2=0.99;
const double p_worker1_t1l3=1.0;
const double p_worker1_t3l3=0.99;
const double p_worker1_t1l6=1.0;
const double p_worker1_t3l5=0.99;
const double p_worker1_t1l8a=1.0;
const double p_worker1_t1l8b=1.0;
const double p_worker1_t3l8=0.99;
const double p_worker2_t3l1=0.99;
const double p_r2_t2l9=0.99;
const int worker1Final = 13;
const int worker1Fail = 14;
const int worker2Final = 1;
const int worker2Fail = 2;
const int r2Final = 5;
const int r2Fail = 6;

module _worker1
  worker1 : [0..15];
  worker1retry_t3l2 : [0..worker1_maxRetry_t3l2] init 0;
  worker1retry_t1l3 : [0..worker1_maxRetry_t1l3] init 0;
  worker1retry_t3l3 : [0..worker1_maxRetry_t3l3] init 0;
  worker1retry_t1l6 : [0..worker1_maxRetry_t1l6] init 0;
  worker1retry_t3l5 : [0..worker1_maxRetry_t3l5] init 0;
  worker1retry_t1l8a : [0..worker1_maxRetry_t1l8a] init 0;
  worker1retry_t1l8b : [0..worker1_maxRetry_t1l8b] init 0;
  worker1retry_t3l8 : [0..worker1_maxRetry_t3l8] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1dot3l2Retry] worker1=1 & worker1retry_t3l2 < worker1_maxRetry_t3l2 -> p_worker1_t3l2 : (worker1'=worker1+1) + (1-p_worker1_t3l2) : (worker1'=worker1) & (worker1retry_t3l2' = worker1retry_t3l2+1);
  [worker1dot3l2] worker1=1 & worker1retry_t3l2 >= worker1_maxRetry_t3l2 -> 1:(worker1'=worker1Fail);
  [worker1movel3] worker1=2-> 1:(worker1'=2+1);
  [worker1dot1l3Retry] worker1=3 & worker1retry_t1l3 < worker1_maxRetry_t1l3 -> p_worker1_t1l3 : (worker1'=worker1+1) + (1-p_worker1_t1l3) : (worker1'=worker1) & (worker1retry_t1l3' = worker1retry_t1l3+1);
  [worker1dot1l3] worker1=3 & worker1retry_t1l3 >= worker1_maxRetry_t1l3 -> 1:(worker1'=worker1Fail);
  [worker1dot3l3Retry] worker1=4 & worker1retry_t3l3 < worker1_maxRetry_t3l3 -> p_worker1_t3l3 : (worker1'=worker1+1) + (1-p_worker1_t3l3) : (worker1'=worker1) & (worker1retry_t3l3' = worker1retry_t3l3+1);
  [worker1dot3l3] worker1=4 & worker1retry_t3l3 >= worker1_maxRetry_t3l3 -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=5-> 1:(worker1'=5+1);
  [worker1dot1l6Retry] worker1=6 & worker1retry_t1l6 < worker1_maxRetry_t1l6 -> p_worker1_t1l6 : (worker1'=worker1+1) + (1-p_worker1_t1l6) : (worker1'=worker1) & (worker1retry_t1l6' = worker1retry_t1l6+1);
  [worker1dot1l6] worker1=6 & worker1retry_t1l6 >= worker1_maxRetry_t1l6 -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=7-> 1:(worker1'=7+1);
  [worker1dot3l5Retry] worker1=8 & worker1retry_t3l5 < worker1_maxRetry_t3l5 -> p_worker1_t3l5 : (worker1'=worker1+1) + (1-p_worker1_t3l5) : (worker1'=worker1) & (worker1retry_t3l5' = worker1retry_t3l5+1);
  [worker1dot3l5] worker1=8 & worker1retry_t3l5 >= worker1_maxRetry_t3l5 -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=9-> 1:(worker1'=9+1);
  [worker1dot1l8aRetry] worker1=10 & worker1retry_t1l8a < worker1_maxRetry_t1l8a -> p_worker1_t1l8a : (worker1'=worker1+1) + (1-p_worker1_t1l8a) : (worker1'=worker1) & (worker1retry_t1l8a' = worker1retry_t1l8a+1);
  [worker1dot1l8a] worker1=10 & worker1retry_t1l8a >= worker1_maxRetry_t1l8a -> 1:(worker1'=worker1Fail);
  [worker1dot1l8bRetry] worker1=11 & worker1retry_t1l8b < worker1_maxRetry_t1l8b -> p_worker1_t1l8b : (worker1'=worker1+1) + (1-p_worker1_t1l8b) : (worker1'=worker1) & (worker1retry_t1l8b' = worker1retry_t1l8b+1);
  [worker1dot1l8b] worker1=11 & worker1retry_t1l8b >= worker1_maxRetry_t1l8b -> 1:(worker1'=worker1Fail);
  [worker1dot3l8Retry] worker1=12 & worker1retry_t3l8 < worker1_maxRetry_t3l8 -> p_worker1_t3l8 : (worker1'=worker1+1) + (1-p_worker1_t3l8) : (worker1'=worker1) & (worker1retry_t3l8' = worker1retry_t3l8+1);
  [worker1dot3l8] worker1=12 & worker1retry_t3l8 >= worker1_maxRetry_t3l8 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..3];
  worker2retry_t3l1 : [0..worker2_maxRetry_t3l1] init 0;

  [worker2dot3l1Retry] worker2=0 & worker2retry_t3l1 < worker2_maxRetry_t3l1 -> p_worker2_t3l1 : (worker2'=worker2+1) + (1-p_worker2_t3l1) : (worker2'=worker2) & (worker2retry_t3l1' = worker2retry_t3l1+1);
  [worker2dot3l1] worker2=0 & worker2retry_t3l1 >= worker2_maxRetry_t3l1 -> 1:(worker2'=worker2Fail);
endmodule

module _r2
  r2 : [0..7];
  r2retry_t2l9 : [0..r2_maxRetry_t2l9] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2movel5] r2=1-> 1:(r2'=1+1);
  [r2movel6] r2=2-> 1:(r2'=2+1);
  [r2movel9] r2=3-> 1:(r2'=3+1);
  [r2dot2l9Retry] r2=4 & r2retry_t2l9 < r2_maxRetry_t2l9 -> p_r2_t2l9 : (r2'=r2+1) + (1-p_r2_t2l9) : (r2'=r2) & (r2retry_t2l9' = r2retry_t2l9+1);
  [r2dot2l9] r2=4 & r2retry_t2l9 >= r2_maxRetry_t2l9 -> 1:(r2'=r2Fail);
endmodule

rewards "cost"
  [worker1movel2] true:1;
  [worker1dot3l2] true:5;
  [worker1dot3l2Retry] true:5;
  [worker1movel3] true:1;
  [worker1dot1l3] true:3;
  [worker1dot1l3Retry] true:3;
  [worker1dot3l3] true:5;
  [worker1dot3l3Retry] true:5;
  [worker1movel6] true:1;
  [worker1dot1l6] true:3;
  [worker1dot1l6Retry] true:3;
  [worker1movel5] true:1;
  [worker1dot3l5] true:5;
  [worker1dot3l5Retry] true:5;
  [worker1movel8] true:1;
  [worker1dot1l8a] true:3;
  [worker1dot1l8aRetry] true:3;
  [worker1dot1l8b] true:3;
  [worker1dot1l8bRetry] true:3;
  [worker1dot3l8] true:5;
  [worker1dot3l8Retry] true:5;
  [worker2dot3l1] true:5;
  [worker2dot3l1Retry] true:5;
  [r2movel4] true:1;
  [r2movel5] true:1;
  [r2movel6] true:1;
  [r2movel9] true:1;
  [r2dot2l9] true:1;
  [r2dot2l9Retry] true:1;
endrewards