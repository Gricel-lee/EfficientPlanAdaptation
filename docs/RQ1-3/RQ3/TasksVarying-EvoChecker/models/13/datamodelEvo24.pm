dtmc
evolve int worker2_maxRetry_t3l1 [1..5];
evolve int worker2_maxRetry_t1l1 [1..5];
evolve int worker2_maxRetry_t3l3 [1..5];
evolve int worker2_maxRetry_t1l3 [1..5];
evolve int worker2_maxRetry_t3l2 [1..5];
evolve int worker2_maxRetry_t1l5 [1..5];
evolve int worker2_maxRetry_t1l8 [1..5];
evolve int r1_maxRetry_t3l7 [1..10];
evolve int r1_maxRetry_t2l7 [1..10];
evolve int r1_maxRetry_t2l8 [1..10];
evolve int r1_maxRetry_t3l9 [1..10];
evolve int r1_maxRetry_t2l9 [1..10];
evolve int r1_maxRetry_t2l5 [1..10];

const double p_worker2_t3l1=0.99;
const double p_worker2_t1l1=1.0;
const double p_worker2_t3l3=0.99;
const double p_worker2_t1l3=1.0;
const double p_worker2_t3l2=0.99;
const double p_worker2_t1l5=1.0;
const double p_worker2_t1l8=1.0;
const double p_r1_t3l7=0.97;
const double p_r1_t2l7=0.99;
const double p_r1_t2l8=0.99;
const double p_r1_t3l9=0.97;
const double p_r1_t2l9=0.99;
const double p_r1_t2l5=0.99;
const int worker2Final = 12;
const int worker2Fail = 13;
const int r1Final = 12;
const int r1Fail = 13;

module _worker2
  worker2 : [0..14];
  worker2retry_t3l1 : [0..worker2_maxRetry_t3l1] init 0;
  worker2retry_t1l1 : [0..worker2_maxRetry_t1l1] init 0;
  worker2retry_t3l3 : [0..worker2_maxRetry_t3l3] init 0;
  worker2retry_t1l3 : [0..worker2_maxRetry_t1l3] init 0;
  worker2retry_t3l2 : [0..worker2_maxRetry_t3l2] init 0;
  worker2retry_t1l5 : [0..worker2_maxRetry_t1l5] init 0;
  worker2retry_t1l8 : [0..worker2_maxRetry_t1l8] init 0;

  [worker2dot3l1Retry] worker2=0 & worker2retry_t3l1 < worker2_maxRetry_t3l1 -> p_worker2_t3l1 : (worker2'=worker2+1) + (1-p_worker2_t3l1) : (worker2'=worker2) & (worker2retry_t3l1' = worker2retry_t3l1+1);
  [worker2dot3l1] worker2=0 & worker2retry_t3l1 >= worker2_maxRetry_t3l1 -> 1:(worker2'=worker2Fail);
  [worker2dot1l1Retry] worker2=1 & worker2retry_t1l1 < worker2_maxRetry_t1l1 -> p_worker2_t1l1 : (worker2'=worker2+1) + (1-p_worker2_t1l1) : (worker2'=worker2) & (worker2retry_t1l1' = worker2retry_t1l1+1);
  [worker2dot1l1] worker2=1 & worker2retry_t1l1 >= worker2_maxRetry_t1l1 -> 1:(worker2'=worker2Fail);
  [worker2movel2] worker2=2-> 1:(worker2'=2+1);
  [worker2movel3] worker2=3-> 1:(worker2'=3+1);
  [worker2dot3l3Retry] worker2=4 & worker2retry_t3l3 < worker2_maxRetry_t3l3 -> p_worker2_t3l3 : (worker2'=worker2+1) + (1-p_worker2_t3l3) : (worker2'=worker2) & (worker2retry_t3l3' = worker2retry_t3l3+1);
  [worker2dot3l3] worker2=4 & worker2retry_t3l3 >= worker2_maxRetry_t3l3 -> 1:(worker2'=worker2Fail);
  [worker2dot1l3Retry] worker2=5 & worker2retry_t1l3 < worker2_maxRetry_t1l3 -> p_worker2_t1l3 : (worker2'=worker2+1) + (1-p_worker2_t1l3) : (worker2'=worker2) & (worker2retry_t1l3' = worker2retry_t1l3+1);
  [worker2dot1l3] worker2=5 & worker2retry_t1l3 >= worker2_maxRetry_t1l3 -> 1:(worker2'=worker2Fail);
  [worker2movel2] worker2=6-> 1:(worker2'=6+1);
  [worker2dot3l2Retry] worker2=7 & worker2retry_t3l2 < worker2_maxRetry_t3l2 -> p_worker2_t3l2 : (worker2'=worker2+1) + (1-p_worker2_t3l2) : (worker2'=worker2) & (worker2retry_t3l2' = worker2retry_t3l2+1);
  [worker2dot3l2] worker2=7 & worker2retry_t3l2 >= worker2_maxRetry_t3l2 -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=8-> 1:(worker2'=8+1);
  [worker2dot1l5Retry] worker2=9 & worker2retry_t1l5 < worker2_maxRetry_t1l5 -> p_worker2_t1l5 : (worker2'=worker2+1) + (1-p_worker2_t1l5) : (worker2'=worker2) & (worker2retry_t1l5' = worker2retry_t1l5+1);
  [worker2dot1l5] worker2=9 & worker2retry_t1l5 >= worker2_maxRetry_t1l5 -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=10-> 1:(worker2'=10+1);
  [worker2dot1l8Retry] worker2=11 & worker2retry_t1l8 < worker2_maxRetry_t1l8 -> p_worker2_t1l8 : (worker2'=worker2+1) + (1-p_worker2_t1l8) : (worker2'=worker2) & (worker2retry_t1l8' = worker2retry_t1l8+1);
  [worker2dot1l8] worker2=11 & worker2retry_t1l8 >= worker2_maxRetry_t1l8 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..14];
  r1retry_t3l7 : [0..r1_maxRetry_t3l7] init 0;
  r1retry_t2l7 : [0..r1_maxRetry_t2l7] init 0;
  r1retry_t2l8 : [0..r1_maxRetry_t2l8] init 0;
  r1retry_t3l9 : [0..r1_maxRetry_t3l9] init 0;
  r1retry_t2l9 : [0..r1_maxRetry_t2l9] init 0;
  r1retry_t2l5 : [0..r1_maxRetry_t2l5] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1movel7] r1=1-> 1:(r1'=1+1);
  [r1dot3l7Retry] r1=2 & r1retry_t3l7 < r1_maxRetry_t3l7 -> p_r1_t3l7 : (r1'=r1+1) + (1-p_r1_t3l7) : (r1'=r1) & (r1retry_t3l7' = r1retry_t3l7+1);
  [r1dot3l7] r1=2 & r1retry_t3l7 >= r1_maxRetry_t3l7 -> 1:(r1'=r1Fail);
  [r1dot2l7Retry] r1=3 & r1retry_t2l7 < r1_maxRetry_t2l7 -> p_r1_t2l7 : (r1'=r1+1) + (1-p_r1_t2l7) : (r1'=r1) & (r1retry_t2l7' = r1retry_t2l7+1);
  [r1dot2l7] r1=3 & r1retry_t2l7 >= r1_maxRetry_t2l7 -> 1:(r1'=r1Fail);
  [r1movel8] r1=4-> 1:(r1'=4+1);
  [r1dot2l8Retry] r1=5 & r1retry_t2l8 < r1_maxRetry_t2l8 -> p_r1_t2l8 : (r1'=r1+1) + (1-p_r1_t2l8) : (r1'=r1) & (r1retry_t2l8' = r1retry_t2l8+1);
  [r1dot2l8] r1=5 & r1retry_t2l8 >= r1_maxRetry_t2l8 -> 1:(r1'=r1Fail);
  [r1movel9] r1=6-> 1:(r1'=6+1);
  [r1dot3l9Retry] r1=7 & r1retry_t3l9 < r1_maxRetry_t3l9 -> p_r1_t3l9 : (r1'=r1+1) + (1-p_r1_t3l9) : (r1'=r1) & (r1retry_t3l9' = r1retry_t3l9+1);
  [r1dot3l9] r1=7 & r1retry_t3l9 >= r1_maxRetry_t3l9 -> 1:(r1'=r1Fail);
  [r1dot2l9Retry] r1=8 & r1retry_t2l9 < r1_maxRetry_t2l9 -> p_r1_t2l9 : (r1'=r1+1) + (1-p_r1_t2l9) : (r1'=r1) & (r1retry_t2l9' = r1retry_t2l9+1);
  [r1dot2l9] r1=8 & r1retry_t2l9 >= r1_maxRetry_t2l9 -> 1:(r1'=r1Fail);
  [r1movel6] r1=9-> 1:(r1'=9+1);
  [r1movel5] r1=10-> 1:(r1'=10+1);
  [r1dot2l5Retry] r1=11 & r1retry_t2l5 < r1_maxRetry_t2l5 -> p_r1_t2l5 : (r1'=r1+1) + (1-p_r1_t2l5) : (r1'=r1) & (r1retry_t2l5' = r1retry_t2l5+1);
  [r1dot2l5] r1=11 & r1retry_t2l5 >= r1_maxRetry_t2l5 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [worker2dot3l1] true:5;
  [worker2dot3l1Retry] true:5;
  [worker2dot1l1] true:3;
  [worker2dot1l1Retry] true:3;
  [worker2movel2] true:1;
  [worker2movel3] true:1;
  [worker2dot3l3] true:5;
  [worker2dot3l3Retry] true:5;
  [worker2dot1l3] true:3;
  [worker2dot1l3Retry] true:3;
  [worker2movel2] true:1;
  [worker2dot3l2] true:5;
  [worker2dot3l2Retry] true:5;
  [worker2movel5] true:1;
  [worker2dot1l5] true:3;
  [worker2dot1l5Retry] true:3;
  [worker2movel8] true:1;
  [worker2dot1l8] true:3;
  [worker2dot1l8Retry] true:3;
  [r1movel4] true:1;
  [r1movel7] true:1;
  [r1dot3l7] true:1;
  [r1dot3l7Retry] true:1;
  [r1dot2l7] true:1;
  [r1dot2l7Retry] true:1;
  [r1movel8] true:1;
  [r1dot2l8] true:1;
  [r1dot2l8Retry] true:1;
  [r1movel9] true:1;
  [r1dot3l9] true:1;
  [r1dot3l9Retry] true:1;
  [r1dot2l9] true:1;
  [r1dot2l9Retry] true:1;
  [r1movel6] true:1;
  [r1movel5] true:1;
  [r1dot2l5] true:1;
  [r1dot2l5Retry] true:1;
endrewards