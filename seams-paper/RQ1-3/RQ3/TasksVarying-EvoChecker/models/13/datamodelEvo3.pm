dtmc
evolve int worker2_maxRetry_t1l3 [1..5];
evolve int worker2_maxRetry_t3l3 [1..5];
evolve int r1_maxRetry_t3l2a [1..10];
evolve int r1_maxRetry_t3l2b [1..10];
evolve int r1_maxRetry_t3l5 [1..10];
evolve int r1_maxRetry_t3l6 [1..10];
evolve int r1_maxRetry_t2l6a [1..10];
evolve int r1_maxRetry_t2l6b [1..10];
evolve int r2_maxRetry_t2l1 [1..10];
evolve int r2_maxRetry_t2l7 [1..10];
evolve int worker1_maxRetry_t1l5 [1..5];
evolve int worker1_maxRetry_t1l8 [1..5];
evolve int worker1_maxRetry_t3l8 [1..5];

const double p_worker2_t1l3=1.0;
const double p_worker2_t3l3=0.99;
const double p_r1_t3l2a=0.97;
const double p_r1_t3l2b=0.97;
const double p_r1_t3l5=0.97;
const double p_r1_t3l6=0.97;
const double p_r1_t2l6a=0.99;
const double p_r1_t2l6b=0.99;
const double p_r2_t2l1=0.99;
const double p_r2_t2l7=0.99;
const double p_worker1_t1l5=1.0;
const double p_worker1_t1l8=1.0;
const double p_worker1_t3l8=0.99;
const int worker2Final = 4;
const int worker2Fail = 5;
const int r1Final = 9;
const int r1Fail = 10;
const int r2Final = 4;
const int r2Fail = 5;
const int worker1Final = 6;
const int worker1Fail = 7;

module _worker2
  worker2 : [0..6];
  worker2retry_t1l3 : [0..worker2_maxRetry_t1l3] init 0;
  worker2retry_t3l3 : [0..worker2_maxRetry_t3l3] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2movel3] worker2=1-> 1:(worker2'=1+1);
  [worker2dot1l3Retry] worker2=2 & worker2retry_t1l3 < worker2_maxRetry_t1l3 -> p_worker2_t1l3 : (worker2'=worker2+1) + (1-p_worker2_t1l3) : (worker2'=worker2) & (worker2retry_t1l3' = worker2retry_t1l3+1);
  [worker2dot1l3] worker2=2 & worker2retry_t1l3 >= worker2_maxRetry_t1l3 -> 1:(worker2'=worker2Fail);
  [worker2dot3l3Retry] worker2=3 & worker2retry_t3l3 < worker2_maxRetry_t3l3 -> p_worker2_t3l3 : (worker2'=worker2+1) + (1-p_worker2_t3l3) : (worker2'=worker2) & (worker2retry_t3l3' = worker2retry_t3l3+1);
  [worker2dot3l3] worker2=3 & worker2retry_t3l3 >= worker2_maxRetry_t3l3 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..11];
  r1retry_t3l2a : [0..r1_maxRetry_t3l2a] init 0;
  r1retry_t3l2b : [0..r1_maxRetry_t3l2b] init 0;
  r1retry_t3l5 : [0..r1_maxRetry_t3l5] init 0;
  r1retry_t3l6 : [0..r1_maxRetry_t3l6] init 0;
  r1retry_t2l6a : [0..r1_maxRetry_t2l6a] init 0;
  r1retry_t2l6b : [0..r1_maxRetry_t2l6b] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1dot3l2aRetry] r1=1 & r1retry_t3l2a < r1_maxRetry_t3l2a -> p_r1_t3l2a : (r1'=r1+1) + (1-p_r1_t3l2a) : (r1'=r1) & (r1retry_t3l2a' = r1retry_t3l2a+1);
  [r1dot3l2a] r1=1 & r1retry_t3l2a >= r1_maxRetry_t3l2a -> 1:(r1'=r1Fail);
  [r1dot3l2bRetry] r1=2 & r1retry_t3l2b < r1_maxRetry_t3l2b -> p_r1_t3l2b : (r1'=r1+1) + (1-p_r1_t3l2b) : (r1'=r1) & (r1retry_t3l2b' = r1retry_t3l2b+1);
  [r1dot3l2b] r1=2 & r1retry_t3l2b >= r1_maxRetry_t3l2b -> 1:(r1'=r1Fail);
  [r1movel5] r1=3-> 1:(r1'=3+1);
  [r1dot3l5Retry] r1=4 & r1retry_t3l5 < r1_maxRetry_t3l5 -> p_r1_t3l5 : (r1'=r1+1) + (1-p_r1_t3l5) : (r1'=r1) & (r1retry_t3l5' = r1retry_t3l5+1);
  [r1dot3l5] r1=4 & r1retry_t3l5 >= r1_maxRetry_t3l5 -> 1:(r1'=r1Fail);
  [r1movel6] r1=5-> 1:(r1'=5+1);
  [r1dot3l6Retry] r1=6 & r1retry_t3l6 < r1_maxRetry_t3l6 -> p_r1_t3l6 : (r1'=r1+1) + (1-p_r1_t3l6) : (r1'=r1) & (r1retry_t3l6' = r1retry_t3l6+1);
  [r1dot3l6] r1=6 & r1retry_t3l6 >= r1_maxRetry_t3l6 -> 1:(r1'=r1Fail);
  [r1dot2l6aRetry] r1=7 & r1retry_t2l6a < r1_maxRetry_t2l6a -> p_r1_t2l6a : (r1'=r1+1) + (1-p_r1_t2l6a) : (r1'=r1) & (r1retry_t2l6a' = r1retry_t2l6a+1);
  [r1dot2l6a] r1=7 & r1retry_t2l6a >= r1_maxRetry_t2l6a -> 1:(r1'=r1Fail);
  [r1dot2l6bRetry] r1=8 & r1retry_t2l6b < r1_maxRetry_t2l6b -> p_r1_t2l6b : (r1'=r1+1) + (1-p_r1_t2l6b) : (r1'=r1) & (r1retry_t2l6b' = r1retry_t2l6b+1);
  [r1dot2l6b] r1=8 & r1retry_t2l6b >= r1_maxRetry_t2l6b -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..6];
  r2retry_t2l1 : [0..r2_maxRetry_t2l1] init 0;
  r2retry_t2l7 : [0..r2_maxRetry_t2l7] init 0;

  [r2dot2l1Retry] r2=0 & r2retry_t2l1 < r2_maxRetry_t2l1 -> p_r2_t2l1 : (r2'=r2+1) + (1-p_r2_t2l1) : (r2'=r2) & (r2retry_t2l1' = r2retry_t2l1+1);
  [r2dot2l1] r2=0 & r2retry_t2l1 >= r2_maxRetry_t2l1 -> 1:(r2'=r2Fail);
  [r2movel4] r2=1-> 1:(r2'=1+1);
  [r2movel7] r2=2-> 1:(r2'=2+1);
  [r2dot2l7Retry] r2=3 & r2retry_t2l7 < r2_maxRetry_t2l7 -> p_r2_t2l7 : (r2'=r2+1) + (1-p_r2_t2l7) : (r2'=r2) & (r2retry_t2l7' = r2retry_t2l7+1);
  [r2dot2l7] r2=3 & r2retry_t2l7 >= r2_maxRetry_t2l7 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..8];
  worker1retry_t1l5 : [0..worker1_maxRetry_t1l5] init 0;
  worker1retry_t1l8 : [0..worker1_maxRetry_t1l8] init 0;
  worker1retry_t3l8 : [0..worker1_maxRetry_t3l8] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1movel5] worker1=1-> 1:(worker1'=1+1);
  [worker1dot1l5Retry] worker1=2 & worker1retry_t1l5 < worker1_maxRetry_t1l5 -> p_worker1_t1l5 : (worker1'=worker1+1) + (1-p_worker1_t1l5) : (worker1'=worker1) & (worker1retry_t1l5' = worker1retry_t1l5+1);
  [worker1dot1l5] worker1=2 & worker1retry_t1l5 >= worker1_maxRetry_t1l5 -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=3-> 1:(worker1'=3+1);
  [worker1dot1l8Retry] worker1=4 & worker1retry_t1l8 < worker1_maxRetry_t1l8 -> p_worker1_t1l8 : (worker1'=worker1+1) + (1-p_worker1_t1l8) : (worker1'=worker1) & (worker1retry_t1l8' = worker1retry_t1l8+1);
  [worker1dot1l8] worker1=4 & worker1retry_t1l8 >= worker1_maxRetry_t1l8 -> 1:(worker1'=worker1Fail);
  [worker1dot3l8Retry] worker1=5 & worker1retry_t3l8 < worker1_maxRetry_t3l8 -> p_worker1_t3l8 : (worker1'=worker1+1) + (1-p_worker1_t3l8) : (worker1'=worker1) & (worker1retry_t3l8' = worker1retry_t3l8+1);
  [worker1dot3l8] worker1=5 & worker1retry_t3l8 >= worker1_maxRetry_t3l8 -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [worker2movel2] true:1;
  [worker2movel3] true:1;
  [worker2dot1l3] true:3;
  [worker2dot1l3Retry] true:3;
  [worker2dot3l3] true:5;
  [worker2dot3l3Retry] true:5;
  [r1movel2] true:1;
  [r1dot3l2a] true:1;
  [r1dot3l2aRetry] true:1;
  [r1dot3l2b] true:1;
  [r1dot3l2bRetry] true:1;
  [r1movel5] true:1;
  [r1dot3l5] true:1;
  [r1dot3l5Retry] true:1;
  [r1movel6] true:1;
  [r1dot3l6] true:1;
  [r1dot3l6Retry] true:1;
  [r1dot2l6a] true:1;
  [r1dot2l6aRetry] true:1;
  [r1dot2l6b] true:1;
  [r1dot2l6bRetry] true:1;
  [r2dot2l1] true:1;
  [r2dot2l1Retry] true:1;
  [r2movel4] true:1;
  [r2movel7] true:1;
  [r2dot2l7] true:1;
  [r2dot2l7Retry] true:1;
  [worker1movel2] true:1;
  [worker1movel5] true:1;
  [worker1dot1l5] true:3;
  [worker1dot1l5Retry] true:3;
  [worker1movel8] true:1;
  [worker1dot1l8] true:3;
  [worker1dot1l8Retry] true:3;
  [worker1dot3l8] true:5;
  [worker1dot3l8Retry] true:5;
endrewards