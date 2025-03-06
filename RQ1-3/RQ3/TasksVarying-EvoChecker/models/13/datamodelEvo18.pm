dtmc
evolve int worker2_maxRetry_t1l2 [1..5];
evolve int worker2_maxRetry_t1l5 [1..5];
evolve int worker2_maxRetry_t1l8 [1..5];
evolve int worker2_maxRetry_t1l7 [1..5];
evolve int r1_maxRetry_t3l4 [1..10];
evolve int r1_maxRetry_t2l7 [1..10];
evolve int r1_maxRetry_t2l8a [1..10];
evolve int r1_maxRetry_t2l8b [1..10];
evolve int r1_maxRetry_t2l5 [1..10];
evolve int r1_maxRetry_t3l6a [1..10];
evolve int r1_maxRetry_t3l6b [1..10];
evolve int r1_maxRetry_t3l3 [1..10];
evolve int worker1_maxRetry_t1l1 [1..5];

const double p_worker2_t1l2=1.0;
const double p_worker2_t1l5=1.0;
const double p_worker2_t1l8=1.0;
const double p_worker2_t1l7=1.0;
const double p_r1_t3l4=0.97;
const double p_r1_t2l7=0.99;
const double p_r1_t2l8a=0.99;
const double p_r1_t2l8b=0.99;
const double p_r1_t2l5=0.99;
const double p_r1_t3l6a=0.97;
const double p_r1_t3l6b=0.97;
const double p_r1_t3l3=0.97;
const double p_worker1_t1l1=1.0;
const int worker2Final = 8;
const int worker2Fail = 9;
const int r1Final = 14;
const int r1Fail = 15;
const int worker1Final = 1;
const int worker1Fail = 2;

module _worker2
  worker2 : [0..10];
  worker2retry_t1l2 : [0..worker2_maxRetry_t1l2] init 0;
  worker2retry_t1l5 : [0..worker2_maxRetry_t1l5] init 0;
  worker2retry_t1l8 : [0..worker2_maxRetry_t1l8] init 0;
  worker2retry_t1l7 : [0..worker2_maxRetry_t1l7] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l2Retry] worker2=1 & worker2retry_t1l2 < worker2_maxRetry_t1l2 -> p_worker2_t1l2 : (worker2'=worker2+1) + (1-p_worker2_t1l2) : (worker2'=worker2) & (worker2retry_t1l2' = worker2retry_t1l2+1);
  [worker2dot1l2] worker2=1 & worker2retry_t1l2 >= worker2_maxRetry_t1l2 -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=2-> 1:(worker2'=2+1);
  [worker2dot1l5Retry] worker2=3 & worker2retry_t1l5 < worker2_maxRetry_t1l5 -> p_worker2_t1l5 : (worker2'=worker2+1) + (1-p_worker2_t1l5) : (worker2'=worker2) & (worker2retry_t1l5' = worker2retry_t1l5+1);
  [worker2dot1l5] worker2=3 & worker2retry_t1l5 >= worker2_maxRetry_t1l5 -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=4-> 1:(worker2'=4+1);
  [worker2dot1l8Retry] worker2=5 & worker2retry_t1l8 < worker2_maxRetry_t1l8 -> p_worker2_t1l8 : (worker2'=worker2+1) + (1-p_worker2_t1l8) : (worker2'=worker2) & (worker2retry_t1l8' = worker2retry_t1l8+1);
  [worker2dot1l8] worker2=5 & worker2retry_t1l8 >= worker2_maxRetry_t1l8 -> 1:(worker2'=worker2Fail);
  [worker2movel7] worker2=6-> 1:(worker2'=6+1);
  [worker2dot1l7Retry] worker2=7 & worker2retry_t1l7 < worker2_maxRetry_t1l7 -> p_worker2_t1l7 : (worker2'=worker2+1) + (1-p_worker2_t1l7) : (worker2'=worker2) & (worker2retry_t1l7' = worker2retry_t1l7+1);
  [worker2dot1l7] worker2=7 & worker2retry_t1l7 >= worker2_maxRetry_t1l7 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..16];
  r1retry_t3l4 : [0..r1_maxRetry_t3l4] init 0;
  r1retry_t2l7 : [0..r1_maxRetry_t2l7] init 0;
  r1retry_t2l8a : [0..r1_maxRetry_t2l8a] init 0;
  r1retry_t2l8b : [0..r1_maxRetry_t2l8b] init 0;
  r1retry_t2l5 : [0..r1_maxRetry_t2l5] init 0;
  r1retry_t3l6a : [0..r1_maxRetry_t3l6a] init 0;
  r1retry_t3l6b : [0..r1_maxRetry_t3l6b] init 0;
  r1retry_t3l3 : [0..r1_maxRetry_t3l3] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1dot3l4Retry] r1=1 & r1retry_t3l4 < r1_maxRetry_t3l4 -> p_r1_t3l4 : (r1'=r1+1) + (1-p_r1_t3l4) : (r1'=r1) & (r1retry_t3l4' = r1retry_t3l4+1);
  [r1dot3l4] r1=1 & r1retry_t3l4 >= r1_maxRetry_t3l4 -> 1:(r1'=r1Fail);
  [r1movel7] r1=2-> 1:(r1'=2+1);
  [r1dot2l7Retry] r1=3 & r1retry_t2l7 < r1_maxRetry_t2l7 -> p_r1_t2l7 : (r1'=r1+1) + (1-p_r1_t2l7) : (r1'=r1) & (r1retry_t2l7' = r1retry_t2l7+1);
  [r1dot2l7] r1=3 & r1retry_t2l7 >= r1_maxRetry_t2l7 -> 1:(r1'=r1Fail);
  [r1movel8] r1=4-> 1:(r1'=4+1);
  [r1dot2l8aRetry] r1=5 & r1retry_t2l8a < r1_maxRetry_t2l8a -> p_r1_t2l8a : (r1'=r1+1) + (1-p_r1_t2l8a) : (r1'=r1) & (r1retry_t2l8a' = r1retry_t2l8a+1);
  [r1dot2l8a] r1=5 & r1retry_t2l8a >= r1_maxRetry_t2l8a -> 1:(r1'=r1Fail);
  [r1dot2l8bRetry] r1=6 & r1retry_t2l8b < r1_maxRetry_t2l8b -> p_r1_t2l8b : (r1'=r1+1) + (1-p_r1_t2l8b) : (r1'=r1) & (r1retry_t2l8b' = r1retry_t2l8b+1);
  [r1dot2l8b] r1=6 & r1retry_t2l8b >= r1_maxRetry_t2l8b -> 1:(r1'=r1Fail);
  [r1movel5] r1=7-> 1:(r1'=7+1);
  [r1dot2l5Retry] r1=8 & r1retry_t2l5 < r1_maxRetry_t2l5 -> p_r1_t2l5 : (r1'=r1+1) + (1-p_r1_t2l5) : (r1'=r1) & (r1retry_t2l5' = r1retry_t2l5+1);
  [r1dot2l5] r1=8 & r1retry_t2l5 >= r1_maxRetry_t2l5 -> 1:(r1'=r1Fail);
  [r1movel6] r1=9-> 1:(r1'=9+1);
  [r1dot3l6aRetry] r1=10 & r1retry_t3l6a < r1_maxRetry_t3l6a -> p_r1_t3l6a : (r1'=r1+1) + (1-p_r1_t3l6a) : (r1'=r1) & (r1retry_t3l6a' = r1retry_t3l6a+1);
  [r1dot3l6a] r1=10 & r1retry_t3l6a >= r1_maxRetry_t3l6a -> 1:(r1'=r1Fail);
  [r1dot3l6bRetry] r1=11 & r1retry_t3l6b < r1_maxRetry_t3l6b -> p_r1_t3l6b : (r1'=r1+1) + (1-p_r1_t3l6b) : (r1'=r1) & (r1retry_t3l6b' = r1retry_t3l6b+1);
  [r1dot3l6b] r1=11 & r1retry_t3l6b >= r1_maxRetry_t3l6b -> 1:(r1'=r1Fail);
  [r1movel3] r1=12-> 1:(r1'=12+1);
  [r1dot3l3Retry] r1=13 & r1retry_t3l3 < r1_maxRetry_t3l3 -> p_r1_t3l3 : (r1'=r1+1) + (1-p_r1_t3l3) : (r1'=r1) & (r1retry_t3l3' = r1retry_t3l3+1);
  [r1dot3l3] r1=13 & r1retry_t3l3 >= r1_maxRetry_t3l3 -> 1:(r1'=r1Fail);
endmodule

module _worker1
  worker1 : [0..3];
  worker1retry_t1l1 : [0..worker1_maxRetry_t1l1] init 0;

  [worker1dot1l1Retry] worker1=0 & worker1retry_t1l1 < worker1_maxRetry_t1l1 -> p_worker1_t1l1 : (worker1'=worker1+1) + (1-p_worker1_t1l1) : (worker1'=worker1) & (worker1retry_t1l1' = worker1retry_t1l1+1);
  [worker1dot1l1] worker1=0 & worker1retry_t1l1 >= worker1_maxRetry_t1l1 -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [worker2movel2] true:1;
  [worker2dot1l2] true:3;
  [worker2dot1l2Retry] true:3;
  [worker2movel5] true:1;
  [worker2dot1l5] true:3;
  [worker2dot1l5Retry] true:3;
  [worker2movel8] true:1;
  [worker2dot1l8] true:3;
  [worker2dot1l8Retry] true:3;
  [worker2movel7] true:1;
  [worker2dot1l7] true:3;
  [worker2dot1l7Retry] true:3;
  [r1movel4] true:1;
  [r1dot3l4] true:1;
  [r1dot3l4Retry] true:1;
  [r1movel7] true:1;
  [r1dot2l7] true:1;
  [r1dot2l7Retry] true:1;
  [r1movel8] true:1;
  [r1dot2l8a] true:1;
  [r1dot2l8aRetry] true:1;
  [r1dot2l8b] true:1;
  [r1dot2l8bRetry] true:1;
  [r1movel5] true:1;
  [r1dot2l5] true:1;
  [r1dot2l5Retry] true:1;
  [r1movel6] true:1;
  [r1dot3l6a] true:1;
  [r1dot3l6aRetry] true:1;
  [r1dot3l6b] true:1;
  [r1dot3l6bRetry] true:1;
  [r1movel3] true:1;
  [r1dot3l3] true:1;
  [r1dot3l3Retry] true:1;
  [worker1dot1l1] true:3;
  [worker1dot1l1Retry] true:3;
endrewards