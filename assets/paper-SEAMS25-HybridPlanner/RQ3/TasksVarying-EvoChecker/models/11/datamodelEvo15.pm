dtmc
evolve int r2_maxRetry_t2l5 [1..10];
evolve int worker1_maxRetry_t1l2 [1..5];
evolve int worker1_maxRetry_t3l2 [1..5];
evolve int worker1_maxRetry_t3l5 [1..5];
evolve int worker1_maxRetry_t1l6 [1..5];
evolve int worker1_maxRetry_t3l8 [1..5];
evolve int worker1_maxRetry_t1l8 [1..5];
evolve int worker1_maxRetry_t3l7 [1..5];
evolve int worker2_maxRetry_t1l1 [1..5];
evolve int r1_maxRetry_t3l1 [1..10];
evolve int r1_maxRetry_t2l1 [1..10];

const double p_r2_t2l5=0.99;
const double p_worker1_t1l2=1.0;
const double p_worker1_t3l2=0.99;
const double p_worker1_t3l5=0.99;
const double p_worker1_t1l6=1.0;
const double p_worker1_t3l8=0.99;
const double p_worker1_t1l8=1.0;
const double p_worker1_t3l7=0.99;
const double p_worker2_t1l1=1.0;
const double p_r1_t3l1=0.97;
const double p_r1_t2l1=0.99;
const int r2Final = 3;
const int r2Fail = 4;
const int worker1Final = 13;
const int worker1Fail = 14;
const int worker2Final = 1;
const int worker2Fail = 2;
const int r1Final = 2;
const int r1Fail = 3;

module _r2
  r2 : [0..5];
  r2retry_t2l5 : [0..r2_maxRetry_t2l5] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2movel5] r2=1-> 1:(r2'=1+1);
  [r2dot2l5Retry] r2=2 & r2retry_t2l5 < r2_maxRetry_t2l5 -> p_r2_t2l5 : (r2'=r2+1) + (1-p_r2_t2l5) : (r2'=r2) & (r2retry_t2l5' = r2retry_t2l5+1);
  [r2dot2l5] r2=2 & r2retry_t2l5 >= r2_maxRetry_t2l5 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..15];
  worker1retry_t1l2 : [0..worker1_maxRetry_t1l2] init 0;
  worker1retry_t3l2 : [0..worker1_maxRetry_t3l2] init 0;
  worker1retry_t3l5 : [0..worker1_maxRetry_t3l5] init 0;
  worker1retry_t1l6 : [0..worker1_maxRetry_t1l6] init 0;
  worker1retry_t3l8 : [0..worker1_maxRetry_t3l8] init 0;
  worker1retry_t1l8 : [0..worker1_maxRetry_t1l8] init 0;
  worker1retry_t3l7 : [0..worker1_maxRetry_t3l7] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l2Retry] worker1=1 & worker1retry_t1l2 < worker1_maxRetry_t1l2 -> p_worker1_t1l2 : (worker1'=worker1+1) + (1-p_worker1_t1l2) : (worker1'=worker1) & (worker1retry_t1l2' = worker1retry_t1l2+1);
  [worker1dot1l2] worker1=1 & worker1retry_t1l2 >= worker1_maxRetry_t1l2 -> 1:(worker1'=worker1Fail);
  [worker1dot3l2Retry] worker1=2 & worker1retry_t3l2 < worker1_maxRetry_t3l2 -> p_worker1_t3l2 : (worker1'=worker1+1) + (1-p_worker1_t3l2) : (worker1'=worker1) & (worker1retry_t3l2' = worker1retry_t3l2+1);
  [worker1dot3l2] worker1=2 & worker1retry_t3l2 >= worker1_maxRetry_t3l2 -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=3-> 1:(worker1'=3+1);
  [worker1dot3l5Retry] worker1=4 & worker1retry_t3l5 < worker1_maxRetry_t3l5 -> p_worker1_t3l5 : (worker1'=worker1+1) + (1-p_worker1_t3l5) : (worker1'=worker1) & (worker1retry_t3l5' = worker1retry_t3l5+1);
  [worker1dot3l5] worker1=4 & worker1retry_t3l5 >= worker1_maxRetry_t3l5 -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=5-> 1:(worker1'=5+1);
  [worker1dot1l6Retry] worker1=6 & worker1retry_t1l6 < worker1_maxRetry_t1l6 -> p_worker1_t1l6 : (worker1'=worker1+1) + (1-p_worker1_t1l6) : (worker1'=worker1) & (worker1retry_t1l6' = worker1retry_t1l6+1);
  [worker1dot1l6] worker1=6 & worker1retry_t1l6 >= worker1_maxRetry_t1l6 -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=7-> 1:(worker1'=7+1);
  [worker1movel8] worker1=8-> 1:(worker1'=8+1);
  [worker1dot3l8Retry] worker1=9 & worker1retry_t3l8 < worker1_maxRetry_t3l8 -> p_worker1_t3l8 : (worker1'=worker1+1) + (1-p_worker1_t3l8) : (worker1'=worker1) & (worker1retry_t3l8' = worker1retry_t3l8+1);
  [worker1dot3l8] worker1=9 & worker1retry_t3l8 >= worker1_maxRetry_t3l8 -> 1:(worker1'=worker1Fail);
  [worker1dot1l8Retry] worker1=10 & worker1retry_t1l8 < worker1_maxRetry_t1l8 -> p_worker1_t1l8 : (worker1'=worker1+1) + (1-p_worker1_t1l8) : (worker1'=worker1) & (worker1retry_t1l8' = worker1retry_t1l8+1);
  [worker1dot1l8] worker1=10 & worker1retry_t1l8 >= worker1_maxRetry_t1l8 -> 1:(worker1'=worker1Fail);
  [worker1movel7] worker1=11-> 1:(worker1'=11+1);
  [worker1dot3l7Retry] worker1=12 & worker1retry_t3l7 < worker1_maxRetry_t3l7 -> p_worker1_t3l7 : (worker1'=worker1+1) + (1-p_worker1_t3l7) : (worker1'=worker1) & (worker1retry_t3l7' = worker1retry_t3l7+1);
  [worker1dot3l7] worker1=12 & worker1retry_t3l7 >= worker1_maxRetry_t3l7 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..3];
  worker2retry_t1l1 : [0..worker2_maxRetry_t1l1] init 0;

  [worker2dot1l1Retry] worker2=0 & worker2retry_t1l1 < worker2_maxRetry_t1l1 -> p_worker2_t1l1 : (worker2'=worker2+1) + (1-p_worker2_t1l1) : (worker2'=worker2) & (worker2retry_t1l1' = worker2retry_t1l1+1);
  [worker2dot1l1] worker2=0 & worker2retry_t1l1 >= worker2_maxRetry_t1l1 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..4];
  r1retry_t3l1 : [0..r1_maxRetry_t3l1] init 0;
  r1retry_t2l1 : [0..r1_maxRetry_t2l1] init 0;

  [r1dot3l1Retry] r1=0 & r1retry_t3l1 < r1_maxRetry_t3l1 -> p_r1_t3l1 : (r1'=r1+1) + (1-p_r1_t3l1) : (r1'=r1) & (r1retry_t3l1' = r1retry_t3l1+1);
  [r1dot3l1] r1=0 & r1retry_t3l1 >= r1_maxRetry_t3l1 -> 1:(r1'=r1Fail);
  [r1dot2l1Retry] r1=1 & r1retry_t2l1 < r1_maxRetry_t2l1 -> p_r1_t2l1 : (r1'=r1+1) + (1-p_r1_t2l1) : (r1'=r1) & (r1retry_t2l1' = r1retry_t2l1+1);
  [r1dot2l1] r1=1 & r1retry_t2l1 >= r1_maxRetry_t2l1 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [r2movel4] true:1;
  [r2movel5] true:1;
  [r2dot2l5] true:1;
  [r2dot2l5Retry] true:1;
  [worker1movel2] true:1;
  [worker1dot1l2] true:3;
  [worker1dot1l2Retry] true:3;
  [worker1dot3l2] true:5;
  [worker1dot3l2Retry] true:5;
  [worker1movel5] true:1;
  [worker1dot3l5] true:5;
  [worker1dot3l5Retry] true:5;
  [worker1movel6] true:1;
  [worker1dot1l6] true:3;
  [worker1dot1l6Retry] true:3;
  [worker1movel5] true:1;
  [worker1movel8] true:1;
  [worker1dot3l8] true:5;
  [worker1dot3l8Retry] true:5;
  [worker1dot1l8] true:3;
  [worker1dot1l8Retry] true:3;
  [worker1movel7] true:1;
  [worker1dot3l7] true:5;
  [worker1dot3l7Retry] true:5;
  [worker2dot1l1] true:3;
  [worker2dot1l1Retry] true:3;
  [r1dot3l1] true:1;
  [r1dot3l1Retry] true:1;
  [r1dot2l1] true:1;
  [r1dot2l1Retry] true:1;
endrewards