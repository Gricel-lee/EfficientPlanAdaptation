dtmc
evolve int r2_maxRetry_t3l1 [1..10];
evolve int worker1_maxRetry_t1l5 [1..5];
evolve int worker1_maxRetry_t3l8 [1..5];
evolve int worker1_maxRetry_t3l7 [1..5];
evolve int worker2_maxRetry_t1l1 [1..5];
evolve int r1_maxRetry_t2l2 [1..10];
evolve int r1_maxRetry_t2l3 [1..10];
evolve int r1_maxRetry_t3l3 [1..10];
evolve int r1_maxRetry_t3l6 [1..10];
evolve int r1_maxRetry_t2l5 [1..10];
evolve int r1_maxRetry_t2l4 [1..10];

const double p_r2_t3l1=0.97;
const double p_worker1_t1l5=1.0;
const double p_worker1_t3l8=0.99;
const double p_worker1_t3l7=0.99;
const double p_worker2_t1l1=1.0;
const double p_r1_t2l2=0.99;
const double p_r1_t2l3=0.99;
const double p_r1_t3l3=0.97;
const double p_r1_t3l6=0.97;
const double p_r1_t2l5=0.99;
const double p_r1_t2l4=0.99;
const int r2Final = 1;
const int r2Fail = 2;
const int worker1Final = 7;
const int worker1Fail = 8;
const int worker2Final = 1;
const int worker2Fail = 2;
const int r1Final = 11;
const int r1Fail = 12;

module _r2
  r2 : [0..3];
  r2retry_t3l1 : [0..r2_maxRetry_t3l1] init 0;

  [r2dot3l1Retry] r2=0 & r2retry_t3l1 < r2_maxRetry_t3l1 -> p_r2_t3l1 : (r2'=r2+1) + (1-p_r2_t3l1) : (r2'=r2) & (r2retry_t3l1' = r2retry_t3l1+1);
  [r2dot3l1] r2=0 & r2retry_t3l1 >= r2_maxRetry_t3l1 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..9];
  worker1retry_t1l5 : [0..worker1_maxRetry_t1l5] init 0;
  worker1retry_t3l8 : [0..worker1_maxRetry_t3l8] init 0;
  worker1retry_t3l7 : [0..worker1_maxRetry_t3l7] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1movel5] worker1=1-> 1:(worker1'=1+1);
  [worker1dot1l5Retry] worker1=2 & worker1retry_t1l5 < worker1_maxRetry_t1l5 -> p_worker1_t1l5 : (worker1'=worker1+1) + (1-p_worker1_t1l5) : (worker1'=worker1) & (worker1retry_t1l5' = worker1retry_t1l5+1);
  [worker1dot1l5] worker1=2 & worker1retry_t1l5 >= worker1_maxRetry_t1l5 -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=3-> 1:(worker1'=3+1);
  [worker1dot3l8Retry] worker1=4 & worker1retry_t3l8 < worker1_maxRetry_t3l8 -> p_worker1_t3l8 : (worker1'=worker1+1) + (1-p_worker1_t3l8) : (worker1'=worker1) & (worker1retry_t3l8' = worker1retry_t3l8+1);
  [worker1dot3l8] worker1=4 & worker1retry_t3l8 >= worker1_maxRetry_t3l8 -> 1:(worker1'=worker1Fail);
  [worker1movel7] worker1=5-> 1:(worker1'=5+1);
  [worker1dot3l7Retry] worker1=6 & worker1retry_t3l7 < worker1_maxRetry_t3l7 -> p_worker1_t3l7 : (worker1'=worker1+1) + (1-p_worker1_t3l7) : (worker1'=worker1) & (worker1retry_t3l7' = worker1retry_t3l7+1);
  [worker1dot3l7] worker1=6 & worker1retry_t3l7 >= worker1_maxRetry_t3l7 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..3];
  worker2retry_t1l1 : [0..worker2_maxRetry_t1l1] init 0;

  [worker2dot1l1Retry] worker2=0 & worker2retry_t1l1 < worker2_maxRetry_t1l1 -> p_worker2_t1l1 : (worker2'=worker2+1) + (1-p_worker2_t1l1) : (worker2'=worker2) & (worker2retry_t1l1' = worker2retry_t1l1+1);
  [worker2dot1l1] worker2=0 & worker2retry_t1l1 >= worker2_maxRetry_t1l1 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..13];
  r1retry_t2l2 : [0..r1_maxRetry_t2l2] init 0;
  r1retry_t2l3 : [0..r1_maxRetry_t2l3] init 0;
  r1retry_t3l3 : [0..r1_maxRetry_t3l3] init 0;
  r1retry_t3l6 : [0..r1_maxRetry_t3l6] init 0;
  r1retry_t2l5 : [0..r1_maxRetry_t2l5] init 0;
  r1retry_t2l4 : [0..r1_maxRetry_t2l4] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1dot2l2Retry] r1=1 & r1retry_t2l2 < r1_maxRetry_t2l2 -> p_r1_t2l2 : (r1'=r1+1) + (1-p_r1_t2l2) : (r1'=r1) & (r1retry_t2l2' = r1retry_t2l2+1);
  [r1dot2l2] r1=1 & r1retry_t2l2 >= r1_maxRetry_t2l2 -> 1:(r1'=r1Fail);
  [r1movel3] r1=2-> 1:(r1'=2+1);
  [r1dot2l3Retry] r1=3 & r1retry_t2l3 < r1_maxRetry_t2l3 -> p_r1_t2l3 : (r1'=r1+1) + (1-p_r1_t2l3) : (r1'=r1) & (r1retry_t2l3' = r1retry_t2l3+1);
  [r1dot2l3] r1=3 & r1retry_t2l3 >= r1_maxRetry_t2l3 -> 1:(r1'=r1Fail);
  [r1dot3l3Retry] r1=4 & r1retry_t3l3 < r1_maxRetry_t3l3 -> p_r1_t3l3 : (r1'=r1+1) + (1-p_r1_t3l3) : (r1'=r1) & (r1retry_t3l3' = r1retry_t3l3+1);
  [r1dot3l3] r1=4 & r1retry_t3l3 >= r1_maxRetry_t3l3 -> 1:(r1'=r1Fail);
  [r1movel6] r1=5-> 1:(r1'=5+1);
  [r1dot3l6Retry] r1=6 & r1retry_t3l6 < r1_maxRetry_t3l6 -> p_r1_t3l6 : (r1'=r1+1) + (1-p_r1_t3l6) : (r1'=r1) & (r1retry_t3l6' = r1retry_t3l6+1);
  [r1dot3l6] r1=6 & r1retry_t3l6 >= r1_maxRetry_t3l6 -> 1:(r1'=r1Fail);
  [r1movel5] r1=7-> 1:(r1'=7+1);
  [r1dot2l5Retry] r1=8 & r1retry_t2l5 < r1_maxRetry_t2l5 -> p_r1_t2l5 : (r1'=r1+1) + (1-p_r1_t2l5) : (r1'=r1) & (r1retry_t2l5' = r1retry_t2l5+1);
  [r1dot2l5] r1=8 & r1retry_t2l5 >= r1_maxRetry_t2l5 -> 1:(r1'=r1Fail);
  [r1movel4] r1=9-> 1:(r1'=9+1);
  [r1dot2l4Retry] r1=10 & r1retry_t2l4 < r1_maxRetry_t2l4 -> p_r1_t2l4 : (r1'=r1+1) + (1-p_r1_t2l4) : (r1'=r1) & (r1retry_t2l4' = r1retry_t2l4+1);
  [r1dot2l4] r1=10 & r1retry_t2l4 >= r1_maxRetry_t2l4 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [r2dot3l1] true:1;
  [r2dot3l1Retry] true:1;
  [worker1movel4] true:1;
  [worker1movel5] true:1;
  [worker1dot1l5] true:3;
  [worker1dot1l5Retry] true:3;
  [worker1movel8] true:1;
  [worker1dot3l8] true:5;
  [worker1dot3l8Retry] true:5;
  [worker1movel7] true:1;
  [worker1dot3l7] true:5;
  [worker1dot3l7Retry] true:5;
  [worker2dot1l1] true:3;
  [worker2dot1l1Retry] true:3;
  [r1movel2] true:1;
  [r1dot2l2] true:1;
  [r1dot2l2Retry] true:1;
  [r1movel3] true:1;
  [r1dot2l3] true:1;
  [r1dot2l3Retry] true:1;
  [r1dot3l3] true:1;
  [r1dot3l3Retry] true:1;
  [r1movel6] true:1;
  [r1dot3l6] true:1;
  [r1dot3l6Retry] true:1;
  [r1movel5] true:1;
  [r1dot2l5] true:1;
  [r1dot2l5Retry] true:1;
  [r1movel4] true:1;
  [r1dot2l4] true:1;
  [r1dot2l4Retry] true:1;
endrewards