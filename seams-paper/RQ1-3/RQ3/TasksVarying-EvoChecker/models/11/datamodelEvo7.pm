dtmc
evolve int r2_maxRetry_t2l7 [1..10];
evolve int r2_maxRetry_t3l8 [1..10];
evolve int r2_maxRetry_t3l9 [1..10];
evolve int r2_maxRetry_t3l6 [1..10];
evolve int worker1_maxRetry_t1l4 [1..5];
evolve int worker1_maxRetry_t1l7 [1..5];
evolve int worker1_maxRetry_t3l7 [1..5];
evolve int worker2_maxRetry_t1l2 [1..5];
evolve int worker2_maxRetry_t1l5 [1..5];
evolve int r1_maxRetry_t3l1 [1..10];
evolve int r1_maxRetry_t2l2 [1..10];

const double p_r2_t2l7=0.99;
const double p_r2_t3l8=0.97;
const double p_r2_t3l9=0.97;
const double p_r2_t3l6=0.97;
const double p_worker1_t1l4=1.0;
const double p_worker1_t1l7=1.0;
const double p_worker1_t3l7=0.99;
const double p_worker2_t1l2=1.0;
const double p_worker2_t1l5=1.0;
const double p_r1_t3l1=0.97;
const double p_r1_t2l2=0.99;
const int r2Final = 9;
const int r2Fail = 10;
const int worker1Final = 5;
const int worker1Fail = 6;
const int worker2Final = 4;
const int worker2Fail = 5;
const int r1Final = 3;
const int r1Fail = 4;

module _r2
  r2 : [0..11];
  r2retry_t2l7 : [0..r2_maxRetry_t2l7] init 0;
  r2retry_t3l8 : [0..r2_maxRetry_t3l8] init 0;
  r2retry_t3l9 : [0..r2_maxRetry_t3l9] init 0;
  r2retry_t3l6 : [0..r2_maxRetry_t3l6] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2movel7] r2=1-> 1:(r2'=1+1);
  [r2dot2l7Retry] r2=2 & r2retry_t2l7 < r2_maxRetry_t2l7 -> p_r2_t2l7 : (r2'=r2+1) + (1-p_r2_t2l7) : (r2'=r2) & (r2retry_t2l7' = r2retry_t2l7+1);
  [r2dot2l7] r2=2 & r2retry_t2l7 >= r2_maxRetry_t2l7 -> 1:(r2'=r2Fail);
  [r2movel8] r2=3-> 1:(r2'=3+1);
  [r2dot3l8Retry] r2=4 & r2retry_t3l8 < r2_maxRetry_t3l8 -> p_r2_t3l8 : (r2'=r2+1) + (1-p_r2_t3l8) : (r2'=r2) & (r2retry_t3l8' = r2retry_t3l8+1);
  [r2dot3l8] r2=4 & r2retry_t3l8 >= r2_maxRetry_t3l8 -> 1:(r2'=r2Fail);
  [r2movel9] r2=5-> 1:(r2'=5+1);
  [r2dot3l9Retry] r2=6 & r2retry_t3l9 < r2_maxRetry_t3l9 -> p_r2_t3l9 : (r2'=r2+1) + (1-p_r2_t3l9) : (r2'=r2) & (r2retry_t3l9' = r2retry_t3l9+1);
  [r2dot3l9] r2=6 & r2retry_t3l9 >= r2_maxRetry_t3l9 -> 1:(r2'=r2Fail);
  [r2movel6] r2=7-> 1:(r2'=7+1);
  [r2dot3l6Retry] r2=8 & r2retry_t3l6 < r2_maxRetry_t3l6 -> p_r2_t3l6 : (r2'=r2+1) + (1-p_r2_t3l6) : (r2'=r2) & (r2retry_t3l6' = r2retry_t3l6+1);
  [r2dot3l6] r2=8 & r2retry_t3l6 >= r2_maxRetry_t3l6 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..7];
  worker1retry_t1l4 : [0..worker1_maxRetry_t1l4] init 0;
  worker1retry_t1l7 : [0..worker1_maxRetry_t1l7] init 0;
  worker1retry_t3l7 : [0..worker1_maxRetry_t3l7] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l4Retry] worker1=1 & worker1retry_t1l4 < worker1_maxRetry_t1l4 -> p_worker1_t1l4 : (worker1'=worker1+1) + (1-p_worker1_t1l4) : (worker1'=worker1) & (worker1retry_t1l4' = worker1retry_t1l4+1);
  [worker1dot1l4] worker1=1 & worker1retry_t1l4 >= worker1_maxRetry_t1l4 -> 1:(worker1'=worker1Fail);
  [worker1movel7] worker1=2-> 1:(worker1'=2+1);
  [worker1dot1l7Retry] worker1=3 & worker1retry_t1l7 < worker1_maxRetry_t1l7 -> p_worker1_t1l7 : (worker1'=worker1+1) + (1-p_worker1_t1l7) : (worker1'=worker1) & (worker1retry_t1l7' = worker1retry_t1l7+1);
  [worker1dot1l7] worker1=3 & worker1retry_t1l7 >= worker1_maxRetry_t1l7 -> 1:(worker1'=worker1Fail);
  [worker1dot3l7Retry] worker1=4 & worker1retry_t3l7 < worker1_maxRetry_t3l7 -> p_worker1_t3l7 : (worker1'=worker1+1) + (1-p_worker1_t3l7) : (worker1'=worker1) & (worker1retry_t3l7' = worker1retry_t3l7+1);
  [worker1dot3l7] worker1=4 & worker1retry_t3l7 >= worker1_maxRetry_t3l7 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..6];
  worker2retry_t1l2 : [0..worker2_maxRetry_t1l2] init 0;
  worker2retry_t1l5 : [0..worker2_maxRetry_t1l5] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l2Retry] worker2=1 & worker2retry_t1l2 < worker2_maxRetry_t1l2 -> p_worker2_t1l2 : (worker2'=worker2+1) + (1-p_worker2_t1l2) : (worker2'=worker2) & (worker2retry_t1l2' = worker2retry_t1l2+1);
  [worker2dot1l2] worker2=1 & worker2retry_t1l2 >= worker2_maxRetry_t1l2 -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=2-> 1:(worker2'=2+1);
  [worker2dot1l5Retry] worker2=3 & worker2retry_t1l5 < worker2_maxRetry_t1l5 -> p_worker2_t1l5 : (worker2'=worker2+1) + (1-p_worker2_t1l5) : (worker2'=worker2) & (worker2retry_t1l5' = worker2retry_t1l5+1);
  [worker2dot1l5] worker2=3 & worker2retry_t1l5 >= worker2_maxRetry_t1l5 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..5];
  r1retry_t3l1 : [0..r1_maxRetry_t3l1] init 0;
  r1retry_t2l2 : [0..r1_maxRetry_t2l2] init 0;

  [r1dot3l1Retry] r1=0 & r1retry_t3l1 < r1_maxRetry_t3l1 -> p_r1_t3l1 : (r1'=r1+1) + (1-p_r1_t3l1) : (r1'=r1) & (r1retry_t3l1' = r1retry_t3l1+1);
  [r1dot3l1] r1=0 & r1retry_t3l1 >= r1_maxRetry_t3l1 -> 1:(r1'=r1Fail);
  [r1movel2] r1=1-> 1:(r1'=1+1);
  [r1dot2l2Retry] r1=2 & r1retry_t2l2 < r1_maxRetry_t2l2 -> p_r1_t2l2 : (r1'=r1+1) + (1-p_r1_t2l2) : (r1'=r1) & (r1retry_t2l2' = r1retry_t2l2+1);
  [r1dot2l2] r1=2 & r1retry_t2l2 >= r1_maxRetry_t2l2 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [r2movel4] true:1;
  [r2movel7] true:1;
  [r2dot2l7] true:1;
  [r2dot2l7Retry] true:1;
  [r2movel8] true:1;
  [r2dot3l8] true:1;
  [r2dot3l8Retry] true:1;
  [r2movel9] true:1;
  [r2dot3l9] true:1;
  [r2dot3l9Retry] true:1;
  [r2movel6] true:1;
  [r2dot3l6] true:1;
  [r2dot3l6Retry] true:1;
  [worker1movel4] true:1;
  [worker1dot1l4] true:3;
  [worker1dot1l4Retry] true:3;
  [worker1movel7] true:1;
  [worker1dot1l7] true:3;
  [worker1dot1l7Retry] true:3;
  [worker1dot3l7] true:5;
  [worker1dot3l7Retry] true:5;
  [worker2movel2] true:1;
  [worker2dot1l2] true:3;
  [worker2dot1l2Retry] true:3;
  [worker2movel5] true:1;
  [worker2dot1l5] true:3;
  [worker2dot1l5Retry] true:3;
  [r1dot3l1] true:1;
  [r1dot3l1Retry] true:1;
  [r1movel2] true:1;
  [r1dot2l2] true:1;
  [r1dot2l2Retry] true:1;
endrewards