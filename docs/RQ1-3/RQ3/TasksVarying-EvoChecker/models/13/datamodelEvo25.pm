dtmc
evolve int r1_maxRetry_t3l1 [1..10];
evolve int r1_maxRetry_t2l1 [1..10];
evolve int r1_maxRetry_t3l7 [1..10];
evolve int r1_maxRetry_t2l7 [1..10];
evolve int r2_maxRetry_t2l2 [1..10];
evolve int r2_maxRetry_t2l5 [1..10];
evolve int r2_maxRetry_t2l6 [1..10];
evolve int r2_maxRetry_t3l6 [1..10];
evolve int r2_maxRetry_t3l3 [1..10];
evolve int r2_maxRetry_t2l3 [1..10];
evolve int worker1_maxRetry_t1l5 [1..5];
evolve int worker1_maxRetry_t3l9 [1..5];
evolve int worker1_maxRetry_t1l9 [1..5];

const double p_r1_t3l1=0.97;
const double p_r1_t2l1=0.99;
const double p_r1_t3l7=0.97;
const double p_r1_t2l7=0.99;
const double p_r2_t2l2=0.99;
const double p_r2_t2l5=0.99;
const double p_r2_t2l6=0.99;
const double p_r2_t3l6=0.97;
const double p_r2_t3l3=0.97;
const double p_r2_t2l3=0.99;
const double p_worker1_t1l5=1.0;
const double p_worker1_t3l9=0.99;
const double p_worker1_t1l9=1.0;
const int r1Final = 6;
const int r1Fail = 7;
const int r2Final = 10;
const int r2Fail = 11;
const int worker1Final = 7;
const int worker1Fail = 8;

module _r1
  r1 : [0..8];
  r1retry_t3l1 : [0..r1_maxRetry_t3l1] init 0;
  r1retry_t2l1 : [0..r1_maxRetry_t2l1] init 0;
  r1retry_t3l7 : [0..r1_maxRetry_t3l7] init 0;
  r1retry_t2l7 : [0..r1_maxRetry_t2l7] init 0;

  [r1dot3l1Retry] r1=0 & r1retry_t3l1 < r1_maxRetry_t3l1 -> p_r1_t3l1 : (r1'=r1+1) + (1-p_r1_t3l1) : (r1'=r1) & (r1retry_t3l1' = r1retry_t3l1+1);
  [r1dot3l1] r1=0 & r1retry_t3l1 >= r1_maxRetry_t3l1 -> 1:(r1'=r1Fail);
  [r1dot2l1Retry] r1=1 & r1retry_t2l1 < r1_maxRetry_t2l1 -> p_r1_t2l1 : (r1'=r1+1) + (1-p_r1_t2l1) : (r1'=r1) & (r1retry_t2l1' = r1retry_t2l1+1);
  [r1dot2l1] r1=1 & r1retry_t2l1 >= r1_maxRetry_t2l1 -> 1:(r1'=r1Fail);
  [r1movel4] r1=2-> 1:(r1'=2+1);
  [r1movel7] r1=3-> 1:(r1'=3+1);
  [r1dot3l7Retry] r1=4 & r1retry_t3l7 < r1_maxRetry_t3l7 -> p_r1_t3l7 : (r1'=r1+1) + (1-p_r1_t3l7) : (r1'=r1) & (r1retry_t3l7' = r1retry_t3l7+1);
  [r1dot3l7] r1=4 & r1retry_t3l7 >= r1_maxRetry_t3l7 -> 1:(r1'=r1Fail);
  [r1dot2l7Retry] r1=5 & r1retry_t2l7 < r1_maxRetry_t2l7 -> p_r1_t2l7 : (r1'=r1+1) + (1-p_r1_t2l7) : (r1'=r1) & (r1retry_t2l7' = r1retry_t2l7+1);
  [r1dot2l7] r1=5 & r1retry_t2l7 >= r1_maxRetry_t2l7 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..12];
  r2retry_t2l2 : [0..r2_maxRetry_t2l2] init 0;
  r2retry_t2l5 : [0..r2_maxRetry_t2l5] init 0;
  r2retry_t2l6 : [0..r2_maxRetry_t2l6] init 0;
  r2retry_t3l6 : [0..r2_maxRetry_t3l6] init 0;
  r2retry_t3l3 : [0..r2_maxRetry_t3l3] init 0;
  r2retry_t2l3 : [0..r2_maxRetry_t2l3] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2dot2l2Retry] r2=1 & r2retry_t2l2 < r2_maxRetry_t2l2 -> p_r2_t2l2 : (r2'=r2+1) + (1-p_r2_t2l2) : (r2'=r2) & (r2retry_t2l2' = r2retry_t2l2+1);
  [r2dot2l2] r2=1 & r2retry_t2l2 >= r2_maxRetry_t2l2 -> 1:(r2'=r2Fail);
  [r2movel5] r2=2-> 1:(r2'=2+1);
  [r2dot2l5Retry] r2=3 & r2retry_t2l5 < r2_maxRetry_t2l5 -> p_r2_t2l5 : (r2'=r2+1) + (1-p_r2_t2l5) : (r2'=r2) & (r2retry_t2l5' = r2retry_t2l5+1);
  [r2dot2l5] r2=3 & r2retry_t2l5 >= r2_maxRetry_t2l5 -> 1:(r2'=r2Fail);
  [r2movel6] r2=4-> 1:(r2'=4+1);
  [r2dot2l6Retry] r2=5 & r2retry_t2l6 < r2_maxRetry_t2l6 -> p_r2_t2l6 : (r2'=r2+1) + (1-p_r2_t2l6) : (r2'=r2) & (r2retry_t2l6' = r2retry_t2l6+1);
  [r2dot2l6] r2=5 & r2retry_t2l6 >= r2_maxRetry_t2l6 -> 1:(r2'=r2Fail);
  [r2dot3l6Retry] r2=6 & r2retry_t3l6 < r2_maxRetry_t3l6 -> p_r2_t3l6 : (r2'=r2+1) + (1-p_r2_t3l6) : (r2'=r2) & (r2retry_t3l6' = r2retry_t3l6+1);
  [r2dot3l6] r2=6 & r2retry_t3l6 >= r2_maxRetry_t3l6 -> 1:(r2'=r2Fail);
  [r2movel3] r2=7-> 1:(r2'=7+1);
  [r2dot3l3Retry] r2=8 & r2retry_t3l3 < r2_maxRetry_t3l3 -> p_r2_t3l3 : (r2'=r2+1) + (1-p_r2_t3l3) : (r2'=r2) & (r2retry_t3l3' = r2retry_t3l3+1);
  [r2dot3l3] r2=8 & r2retry_t3l3 >= r2_maxRetry_t3l3 -> 1:(r2'=r2Fail);
  [r2dot2l3Retry] r2=9 & r2retry_t2l3 < r2_maxRetry_t2l3 -> p_r2_t2l3 : (r2'=r2+1) + (1-p_r2_t2l3) : (r2'=r2) & (r2retry_t2l3' = r2retry_t2l3+1);
  [r2dot2l3] r2=9 & r2retry_t2l3 >= r2_maxRetry_t2l3 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..9];
  worker1retry_t1l5 : [0..worker1_maxRetry_t1l5] init 0;
  worker1retry_t3l9 : [0..worker1_maxRetry_t3l9] init 0;
  worker1retry_t1l9 : [0..worker1_maxRetry_t1l9] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1movel5] worker1=1-> 1:(worker1'=1+1);
  [worker1dot1l5Retry] worker1=2 & worker1retry_t1l5 < worker1_maxRetry_t1l5 -> p_worker1_t1l5 : (worker1'=worker1+1) + (1-p_worker1_t1l5) : (worker1'=worker1) & (worker1retry_t1l5' = worker1retry_t1l5+1);
  [worker1dot1l5] worker1=2 & worker1retry_t1l5 >= worker1_maxRetry_t1l5 -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=3-> 1:(worker1'=3+1);
  [worker1movel9] worker1=4-> 1:(worker1'=4+1);
  [worker1dot3l9Retry] worker1=5 & worker1retry_t3l9 < worker1_maxRetry_t3l9 -> p_worker1_t3l9 : (worker1'=worker1+1) + (1-p_worker1_t3l9) : (worker1'=worker1) & (worker1retry_t3l9' = worker1retry_t3l9+1);
  [worker1dot3l9] worker1=5 & worker1retry_t3l9 >= worker1_maxRetry_t3l9 -> 1:(worker1'=worker1Fail);
  [worker1dot1l9Retry] worker1=6 & worker1retry_t1l9 < worker1_maxRetry_t1l9 -> p_worker1_t1l9 : (worker1'=worker1+1) + (1-p_worker1_t1l9) : (worker1'=worker1) & (worker1retry_t1l9' = worker1retry_t1l9+1);
  [worker1dot1l9] worker1=6 & worker1retry_t1l9 >= worker1_maxRetry_t1l9 -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [r1dot3l1] true:1;
  [r1dot3l1Retry] true:1;
  [r1dot2l1] true:1;
  [r1dot2l1Retry] true:1;
  [r1movel4] true:1;
  [r1movel7] true:1;
  [r1dot3l7] true:1;
  [r1dot3l7Retry] true:1;
  [r1dot2l7] true:1;
  [r1dot2l7Retry] true:1;
  [r2movel2] true:1;
  [r2dot2l2] true:1;
  [r2dot2l2Retry] true:1;
  [r2movel5] true:1;
  [r2dot2l5] true:1;
  [r2dot2l5Retry] true:1;
  [r2movel6] true:1;
  [r2dot2l6] true:1;
  [r2dot2l6Retry] true:1;
  [r2dot3l6] true:1;
  [r2dot3l6Retry] true:1;
  [r2movel3] true:1;
  [r2dot3l3] true:1;
  [r2dot3l3Retry] true:1;
  [r2dot2l3] true:1;
  [r2dot2l3Retry] true:1;
  [worker1movel2] true:1;
  [worker1movel5] true:1;
  [worker1dot1l5] true:3;
  [worker1dot1l5Retry] true:3;
  [worker1movel8] true:1;
  [worker1movel9] true:1;
  [worker1dot3l9] true:5;
  [worker1dot3l9Retry] true:5;
  [worker1dot1l9] true:3;
  [worker1dot1l9Retry] true:3;
endrewards