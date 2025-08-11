dtmc
evolve int worker2_maxRetry_t1l4 [1..5];
evolve int worker2_maxRetry_t1l7 [1..5];
evolve int worker2_maxRetry_t1l8 [1..5];
evolve int worker2_maxRetry_t1l9 [1..5];
evolve int worker2_maxRetry_t3l9 [1..5];
evolve int worker2_maxRetry_t1l6 [1..5];
evolve int worker2_maxRetry_t1l3 [1..5];
evolve int r1_maxRetry_t2l4a [1..10];
evolve int r1_maxRetry_t2l4b [1..10];
evolve int r1_maxRetry_t3l5 [1..10];
evolve int r1_maxRetry_t3l2 [1..10];
evolve int r1_maxRetry_t2l2 [1..10];
evolve int r2_maxRetry_t3l1 [1..10];

const double p_worker2_t1l4=1.0;
const double p_worker2_t1l7=1.0;
const double p_worker2_t1l8=1.0;
const double p_worker2_t1l9=1.0;
const double p_worker2_t3l9=0.99;
const double p_worker2_t1l6=1.0;
const double p_worker2_t1l3=1.0;
const double p_r1_t2l4a=0.99;
const double p_r1_t2l4b=0.99;
const double p_r1_t3l5=0.97;
const double p_r1_t3l2=0.97;
const double p_r1_t2l2=0.99;
const double p_r2_t3l1=0.97;
const int worker2Final = 13;
const int worker2Fail = 14;
const int r1Final = 8;
const int r1Fail = 9;
const int r2Final = 1;
const int r2Fail = 2;

module _worker2
  worker2 : [0..15];
  worker2retry_t1l4 : [0..worker2_maxRetry_t1l4] init 0;
  worker2retry_t1l7 : [0..worker2_maxRetry_t1l7] init 0;
  worker2retry_t1l8 : [0..worker2_maxRetry_t1l8] init 0;
  worker2retry_t1l9 : [0..worker2_maxRetry_t1l9] init 0;
  worker2retry_t3l9 : [0..worker2_maxRetry_t3l9] init 0;
  worker2retry_t1l6 : [0..worker2_maxRetry_t1l6] init 0;
  worker2retry_t1l3 : [0..worker2_maxRetry_t1l3] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l4Retry] worker2=1 & worker2retry_t1l4 < worker2_maxRetry_t1l4 -> p_worker2_t1l4 : (worker2'=worker2+1) + (1-p_worker2_t1l4) : (worker2'=worker2) & (worker2retry_t1l4' = worker2retry_t1l4+1);
  [worker2dot1l4] worker2=1 & worker2retry_t1l4 >= worker2_maxRetry_t1l4 -> 1:(worker2'=worker2Fail);
  [worker2movel7] worker2=2-> 1:(worker2'=2+1);
  [worker2dot1l7Retry] worker2=3 & worker2retry_t1l7 < worker2_maxRetry_t1l7 -> p_worker2_t1l7 : (worker2'=worker2+1) + (1-p_worker2_t1l7) : (worker2'=worker2) & (worker2retry_t1l7' = worker2retry_t1l7+1);
  [worker2dot1l7] worker2=3 & worker2retry_t1l7 >= worker2_maxRetry_t1l7 -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=4-> 1:(worker2'=4+1);
  [worker2dot1l8Retry] worker2=5 & worker2retry_t1l8 < worker2_maxRetry_t1l8 -> p_worker2_t1l8 : (worker2'=worker2+1) + (1-p_worker2_t1l8) : (worker2'=worker2) & (worker2retry_t1l8' = worker2retry_t1l8+1);
  [worker2dot1l8] worker2=5 & worker2retry_t1l8 >= worker2_maxRetry_t1l8 -> 1:(worker2'=worker2Fail);
  [worker2movel9] worker2=6-> 1:(worker2'=6+1);
  [worker2dot1l9Retry] worker2=7 & worker2retry_t1l9 < worker2_maxRetry_t1l9 -> p_worker2_t1l9 : (worker2'=worker2+1) + (1-p_worker2_t1l9) : (worker2'=worker2) & (worker2retry_t1l9' = worker2retry_t1l9+1);
  [worker2dot1l9] worker2=7 & worker2retry_t1l9 >= worker2_maxRetry_t1l9 -> 1:(worker2'=worker2Fail);
  [worker2dot3l9Retry] worker2=8 & worker2retry_t3l9 < worker2_maxRetry_t3l9 -> p_worker2_t3l9 : (worker2'=worker2+1) + (1-p_worker2_t3l9) : (worker2'=worker2) & (worker2retry_t3l9' = worker2retry_t3l9+1);
  [worker2dot3l9] worker2=8 & worker2retry_t3l9 >= worker2_maxRetry_t3l9 -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=9-> 1:(worker2'=9+1);
  [worker2dot1l6Retry] worker2=10 & worker2retry_t1l6 < worker2_maxRetry_t1l6 -> p_worker2_t1l6 : (worker2'=worker2+1) + (1-p_worker2_t1l6) : (worker2'=worker2) & (worker2retry_t1l6' = worker2retry_t1l6+1);
  [worker2dot1l6] worker2=10 & worker2retry_t1l6 >= worker2_maxRetry_t1l6 -> 1:(worker2'=worker2Fail);
  [worker2movel3] worker2=11-> 1:(worker2'=11+1);
  [worker2dot1l3Retry] worker2=12 & worker2retry_t1l3 < worker2_maxRetry_t1l3 -> p_worker2_t1l3 : (worker2'=worker2+1) + (1-p_worker2_t1l3) : (worker2'=worker2) & (worker2retry_t1l3' = worker2retry_t1l3+1);
  [worker2dot1l3] worker2=12 & worker2retry_t1l3 >= worker2_maxRetry_t1l3 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..10];
  r1retry_t2l4a : [0..r1_maxRetry_t2l4a] init 0;
  r1retry_t2l4b : [0..r1_maxRetry_t2l4b] init 0;
  r1retry_t3l5 : [0..r1_maxRetry_t3l5] init 0;
  r1retry_t3l2 : [0..r1_maxRetry_t3l2] init 0;
  r1retry_t2l2 : [0..r1_maxRetry_t2l2] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1dot2l4aRetry] r1=1 & r1retry_t2l4a < r1_maxRetry_t2l4a -> p_r1_t2l4a : (r1'=r1+1) + (1-p_r1_t2l4a) : (r1'=r1) & (r1retry_t2l4a' = r1retry_t2l4a+1);
  [r1dot2l4a] r1=1 & r1retry_t2l4a >= r1_maxRetry_t2l4a -> 1:(r1'=r1Fail);
  [r1dot2l4bRetry] r1=2 & r1retry_t2l4b < r1_maxRetry_t2l4b -> p_r1_t2l4b : (r1'=r1+1) + (1-p_r1_t2l4b) : (r1'=r1) & (r1retry_t2l4b' = r1retry_t2l4b+1);
  [r1dot2l4b] r1=2 & r1retry_t2l4b >= r1_maxRetry_t2l4b -> 1:(r1'=r1Fail);
  [r1movel5] r1=3-> 1:(r1'=3+1);
  [r1dot3l5Retry] r1=4 & r1retry_t3l5 < r1_maxRetry_t3l5 -> p_r1_t3l5 : (r1'=r1+1) + (1-p_r1_t3l5) : (r1'=r1) & (r1retry_t3l5' = r1retry_t3l5+1);
  [r1dot3l5] r1=4 & r1retry_t3l5 >= r1_maxRetry_t3l5 -> 1:(r1'=r1Fail);
  [r1movel2] r1=5-> 1:(r1'=5+1);
  [r1dot3l2Retry] r1=6 & r1retry_t3l2 < r1_maxRetry_t3l2 -> p_r1_t3l2 : (r1'=r1+1) + (1-p_r1_t3l2) : (r1'=r1) & (r1retry_t3l2' = r1retry_t3l2+1);
  [r1dot3l2] r1=6 & r1retry_t3l2 >= r1_maxRetry_t3l2 -> 1:(r1'=r1Fail);
  [r1dot2l2Retry] r1=7 & r1retry_t2l2 < r1_maxRetry_t2l2 -> p_r1_t2l2 : (r1'=r1+1) + (1-p_r1_t2l2) : (r1'=r1) & (r1retry_t2l2' = r1retry_t2l2+1);
  [r1dot2l2] r1=7 & r1retry_t2l2 >= r1_maxRetry_t2l2 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..3];
  r2retry_t3l1 : [0..r2_maxRetry_t3l1] init 0;

  [r2dot3l1Retry] r2=0 & r2retry_t3l1 < r2_maxRetry_t3l1 -> p_r2_t3l1 : (r2'=r2+1) + (1-p_r2_t3l1) : (r2'=r2) & (r2retry_t3l1' = r2retry_t3l1+1);
  [r2dot3l1] r2=0 & r2retry_t3l1 >= r2_maxRetry_t3l1 -> 1:(r2'=r2Fail);
endmodule

rewards "cost"
  [worker2movel4] true:1;
  [worker2dot1l4] true:3;
  [worker2dot1l4Retry] true:3;
  [worker2movel7] true:1;
  [worker2dot1l7] true:3;
  [worker2dot1l7Retry] true:3;
  [worker2movel8] true:1;
  [worker2dot1l8] true:3;
  [worker2dot1l8Retry] true:3;
  [worker2movel9] true:1;
  [worker2dot1l9] true:3;
  [worker2dot1l9Retry] true:3;
  [worker2dot3l9] true:5;
  [worker2dot3l9Retry] true:5;
  [worker2movel6] true:1;
  [worker2dot1l6] true:3;
  [worker2dot1l6Retry] true:3;
  [worker2movel3] true:1;
  [worker2dot1l3] true:3;
  [worker2dot1l3Retry] true:3;
  [r1movel4] true:1;
  [r1dot2l4a] true:1;
  [r1dot2l4aRetry] true:1;
  [r1dot2l4b] true:1;
  [r1dot2l4bRetry] true:1;
  [r1movel5] true:1;
  [r1dot3l5] true:1;
  [r1dot3l5Retry] true:1;
  [r1movel2] true:1;
  [r1dot3l2] true:1;
  [r1dot3l2Retry] true:1;
  [r1dot2l2] true:1;
  [r1dot2l2Retry] true:1;
  [r2dot3l1] true:1;
  [r2dot3l1Retry] true:1;
endrewards