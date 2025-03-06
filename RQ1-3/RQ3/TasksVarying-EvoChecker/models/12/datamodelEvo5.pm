dtmc
evolve int r1_maxRetry_t3l4 [1..10];
evolve int r1_maxRetry_t3l7 [1..10];
evolve int r1_maxRetry_t3l8 [1..10];
evolve int r1_maxRetry_t3l9 [1..10];
evolve int r1_maxRetry_t2l9 [1..10];
evolve int r2_maxRetry_t2l1 [1..10];
evolve int r2_maxRetry_t3l1 [1..10];
evolve int r2_maxRetry_t2l2 [1..10];
evolve int worker1_maxRetry_t3l3 [1..5];
evolve int worker1_maxRetry_t1l3 [1..5];
evolve int worker2_maxRetry_t1l4 [1..5];
evolve int worker2_maxRetry_t1l5 [1..5];

const double p_r1_t3l4=0.97;
const double p_r1_t3l7=0.97;
const double p_r1_t3l8=0.97;
const double p_r1_t3l9=0.97;
const double p_r1_t2l9=0.99;
const double p_r2_t2l1=0.99;
const double p_r2_t3l1=0.97;
const double p_r2_t2l2=0.99;
const double p_worker1_t3l3=0.99;
const double p_worker1_t1l3=1.0;
const double p_worker2_t1l4=1.0;
const double p_worker2_t1l5=1.0;
const int r1Final = 9;
const int r1Fail = 10;
const int r2Final = 4;
const int r2Fail = 5;
const int worker1Final = 4;
const int worker1Fail = 5;
const int worker2Final = 4;
const int worker2Fail = 5;

module _r1
  r1 : [0..11];
  r1retry_t3l4 : [0..r1_maxRetry_t3l4] init 0;
  r1retry_t3l7 : [0..r1_maxRetry_t3l7] init 0;
  r1retry_t3l8 : [0..r1_maxRetry_t3l8] init 0;
  r1retry_t3l9 : [0..r1_maxRetry_t3l9] init 0;
  r1retry_t2l9 : [0..r1_maxRetry_t2l9] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1dot3l4Retry] r1=1 & r1retry_t3l4 < r1_maxRetry_t3l4 -> p_r1_t3l4 : (r1'=r1+1) + (1-p_r1_t3l4) : (r1'=r1) & (r1retry_t3l4' = r1retry_t3l4+1);
  [r1dot3l4] r1=1 & r1retry_t3l4 >= r1_maxRetry_t3l4 -> 1:(r1'=r1Fail);
  [r1movel7] r1=2-> 1:(r1'=2+1);
  [r1dot3l7Retry] r1=3 & r1retry_t3l7 < r1_maxRetry_t3l7 -> p_r1_t3l7 : (r1'=r1+1) + (1-p_r1_t3l7) : (r1'=r1) & (r1retry_t3l7' = r1retry_t3l7+1);
  [r1dot3l7] r1=3 & r1retry_t3l7 >= r1_maxRetry_t3l7 -> 1:(r1'=r1Fail);
  [r1movel8] r1=4-> 1:(r1'=4+1);
  [r1dot3l8Retry] r1=5 & r1retry_t3l8 < r1_maxRetry_t3l8 -> p_r1_t3l8 : (r1'=r1+1) + (1-p_r1_t3l8) : (r1'=r1) & (r1retry_t3l8' = r1retry_t3l8+1);
  [r1dot3l8] r1=5 & r1retry_t3l8 >= r1_maxRetry_t3l8 -> 1:(r1'=r1Fail);
  [r1movel9] r1=6-> 1:(r1'=6+1);
  [r1dot3l9Retry] r1=7 & r1retry_t3l9 < r1_maxRetry_t3l9 -> p_r1_t3l9 : (r1'=r1+1) + (1-p_r1_t3l9) : (r1'=r1) & (r1retry_t3l9' = r1retry_t3l9+1);
  [r1dot3l9] r1=7 & r1retry_t3l9 >= r1_maxRetry_t3l9 -> 1:(r1'=r1Fail);
  [r1dot2l9Retry] r1=8 & r1retry_t2l9 < r1_maxRetry_t2l9 -> p_r1_t2l9 : (r1'=r1+1) + (1-p_r1_t2l9) : (r1'=r1) & (r1retry_t2l9' = r1retry_t2l9+1);
  [r1dot2l9] r1=8 & r1retry_t2l9 >= r1_maxRetry_t2l9 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..6];
  r2retry_t2l1 : [0..r2_maxRetry_t2l1] init 0;
  r2retry_t3l1 : [0..r2_maxRetry_t3l1] init 0;
  r2retry_t2l2 : [0..r2_maxRetry_t2l2] init 0;

  [r2dot2l1Retry] r2=0 & r2retry_t2l1 < r2_maxRetry_t2l1 -> p_r2_t2l1 : (r2'=r2+1) + (1-p_r2_t2l1) : (r2'=r2) & (r2retry_t2l1' = r2retry_t2l1+1);
  [r2dot2l1] r2=0 & r2retry_t2l1 >= r2_maxRetry_t2l1 -> 1:(r2'=r2Fail);
  [r2dot3l1Retry] r2=1 & r2retry_t3l1 < r2_maxRetry_t3l1 -> p_r2_t3l1 : (r2'=r2+1) + (1-p_r2_t3l1) : (r2'=r2) & (r2retry_t3l1' = r2retry_t3l1+1);
  [r2dot3l1] r2=1 & r2retry_t3l1 >= r2_maxRetry_t3l1 -> 1:(r2'=r2Fail);
  [r2movel2] r2=2-> 1:(r2'=2+1);
  [r2dot2l2Retry] r2=3 & r2retry_t2l2 < r2_maxRetry_t2l2 -> p_r2_t2l2 : (r2'=r2+1) + (1-p_r2_t2l2) : (r2'=r2) & (r2retry_t2l2' = r2retry_t2l2+1);
  [r2dot2l2] r2=3 & r2retry_t2l2 >= r2_maxRetry_t2l2 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..6];
  worker1retry_t3l3 : [0..worker1_maxRetry_t3l3] init 0;
  worker1retry_t1l3 : [0..worker1_maxRetry_t1l3] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1movel3] worker1=1-> 1:(worker1'=1+1);
  [worker1dot3l3Retry] worker1=2 & worker1retry_t3l3 < worker1_maxRetry_t3l3 -> p_worker1_t3l3 : (worker1'=worker1+1) + (1-p_worker1_t3l3) : (worker1'=worker1) & (worker1retry_t3l3' = worker1retry_t3l3+1);
  [worker1dot3l3] worker1=2 & worker1retry_t3l3 >= worker1_maxRetry_t3l3 -> 1:(worker1'=worker1Fail);
  [worker1dot1l3Retry] worker1=3 & worker1retry_t1l3 < worker1_maxRetry_t1l3 -> p_worker1_t1l3 : (worker1'=worker1+1) + (1-p_worker1_t1l3) : (worker1'=worker1) & (worker1retry_t1l3' = worker1retry_t1l3+1);
  [worker1dot1l3] worker1=3 & worker1retry_t1l3 >= worker1_maxRetry_t1l3 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..6];
  worker2retry_t1l4 : [0..worker2_maxRetry_t1l4] init 0;
  worker2retry_t1l5 : [0..worker2_maxRetry_t1l5] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l4Retry] worker2=1 & worker2retry_t1l4 < worker2_maxRetry_t1l4 -> p_worker2_t1l4 : (worker2'=worker2+1) + (1-p_worker2_t1l4) : (worker2'=worker2) & (worker2retry_t1l4' = worker2retry_t1l4+1);
  [worker2dot1l4] worker2=1 & worker2retry_t1l4 >= worker2_maxRetry_t1l4 -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=2-> 1:(worker2'=2+1);
  [worker2dot1l5Retry] worker2=3 & worker2retry_t1l5 < worker2_maxRetry_t1l5 -> p_worker2_t1l5 : (worker2'=worker2+1) + (1-p_worker2_t1l5) : (worker2'=worker2) & (worker2retry_t1l5' = worker2retry_t1l5+1);
  [worker2dot1l5] worker2=3 & worker2retry_t1l5 >= worker2_maxRetry_t1l5 -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r1movel4] true:1;
  [r1dot3l4] true:1;
  [r1dot3l4Retry] true:1;
  [r1movel7] true:1;
  [r1dot3l7] true:1;
  [r1dot3l7Retry] true:1;
  [r1movel8] true:1;
  [r1dot3l8] true:1;
  [r1dot3l8Retry] true:1;
  [r1movel9] true:1;
  [r1dot3l9] true:1;
  [r1dot3l9Retry] true:1;
  [r1dot2l9] true:1;
  [r1dot2l9Retry] true:1;
  [r2dot2l1] true:1;
  [r2dot2l1Retry] true:1;
  [r2dot3l1] true:1;
  [r2dot3l1Retry] true:1;
  [r2movel2] true:1;
  [r2dot2l2] true:1;
  [r2dot2l2Retry] true:1;
  [worker1movel2] true:1;
  [worker1movel3] true:1;
  [worker1dot3l3] true:5;
  [worker1dot3l3Retry] true:5;
  [worker1dot1l3] true:3;
  [worker1dot1l3Retry] true:3;
  [worker2movel4] true:1;
  [worker2dot1l4] true:3;
  [worker2dot1l4Retry] true:3;
  [worker2movel5] true:1;
  [worker2dot1l5] true:3;
  [worker2dot1l5Retry] true:3;
endrewards