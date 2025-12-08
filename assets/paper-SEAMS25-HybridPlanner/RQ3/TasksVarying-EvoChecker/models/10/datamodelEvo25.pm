dtmc
evolve int worker1_maxRetry_t3l2 [1..5];
evolve int worker1_maxRetry_t1l3 [1..5];
evolve int worker1_maxRetry_t3l6 [1..5];
evolve int worker1_maxRetry_t1l5 [1..5];
evolve int worker1_maxRetry_t1l8 [1..5];
evolve int r1_maxRetry_t2l7a [1..10];
evolve int r1_maxRetry_t3l7 [1..10];
evolve int r1_maxRetry_t2l7b [1..10];
evolve int r2_maxRetry_t2l2 [1..10];
evolve int r2_maxRetry_t2l5 [1..10];

const double p_worker1_t3l2=0.99;
const double p_worker1_t1l3=1.0;
const double p_worker1_t3l6=0.99;
const double p_worker1_t1l5=1.0;
const double p_worker1_t1l8=1.0;
const double p_r1_t2l7a=0.99;
const double p_r1_t3l7=0.97;
const double p_r1_t2l7b=0.99;
const double p_r2_t2l2=0.99;
const double p_r2_t2l5=0.99;
const int worker1Final = 10;
const int worker1Fail = 11;
const int r1Final = 5;
const int r1Fail = 6;
const int r2Final = 4;
const int r2Fail = 5;

module _worker1
  worker1 : [0..12];
  worker1retry_t3l2 : [0..worker1_maxRetry_t3l2] init 0;
  worker1retry_t1l3 : [0..worker1_maxRetry_t1l3] init 0;
  worker1retry_t3l6 : [0..worker1_maxRetry_t3l6] init 0;
  worker1retry_t1l5 : [0..worker1_maxRetry_t1l5] init 0;
  worker1retry_t1l8 : [0..worker1_maxRetry_t1l8] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1dot3l2Retry] worker1=1 & worker1retry_t3l2 < worker1_maxRetry_t3l2 -> p_worker1_t3l2 : (worker1'=worker1+1) + (1-p_worker1_t3l2) : (worker1'=worker1) & (worker1retry_t3l2' = worker1retry_t3l2+1);
  [worker1dot3l2] worker1=1 & worker1retry_t3l2 >= worker1_maxRetry_t3l2 -> 1:(worker1'=worker1Fail);
  [worker1movel3] worker1=2-> 1:(worker1'=2+1);
  [worker1dot1l3Retry] worker1=3 & worker1retry_t1l3 < worker1_maxRetry_t1l3 -> p_worker1_t1l3 : (worker1'=worker1+1) + (1-p_worker1_t1l3) : (worker1'=worker1) & (worker1retry_t1l3' = worker1retry_t1l3+1);
  [worker1dot1l3] worker1=3 & worker1retry_t1l3 >= worker1_maxRetry_t1l3 -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=4-> 1:(worker1'=4+1);
  [worker1dot3l6Retry] worker1=5 & worker1retry_t3l6 < worker1_maxRetry_t3l6 -> p_worker1_t3l6 : (worker1'=worker1+1) + (1-p_worker1_t3l6) : (worker1'=worker1) & (worker1retry_t3l6' = worker1retry_t3l6+1);
  [worker1dot3l6] worker1=5 & worker1retry_t3l6 >= worker1_maxRetry_t3l6 -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=6-> 1:(worker1'=6+1);
  [worker1dot1l5Retry] worker1=7 & worker1retry_t1l5 < worker1_maxRetry_t1l5 -> p_worker1_t1l5 : (worker1'=worker1+1) + (1-p_worker1_t1l5) : (worker1'=worker1) & (worker1retry_t1l5' = worker1retry_t1l5+1);
  [worker1dot1l5] worker1=7 & worker1retry_t1l5 >= worker1_maxRetry_t1l5 -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=8-> 1:(worker1'=8+1);
  [worker1dot1l8Retry] worker1=9 & worker1retry_t1l8 < worker1_maxRetry_t1l8 -> p_worker1_t1l8 : (worker1'=worker1+1) + (1-p_worker1_t1l8) : (worker1'=worker1) & (worker1retry_t1l8' = worker1retry_t1l8+1);
  [worker1dot1l8] worker1=9 & worker1retry_t1l8 >= worker1_maxRetry_t1l8 -> 1:(worker1'=worker1Fail);
endmodule

module _r1
  r1 : [0..7];
  r1retry_t2l7a : [0..r1_maxRetry_t2l7a] init 0;
  r1retry_t3l7 : [0..r1_maxRetry_t3l7] init 0;
  r1retry_t2l7b : [0..r1_maxRetry_t2l7b] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1movel7] r1=1-> 1:(r1'=1+1);
  [r1dot2l7aRetry] r1=2 & r1retry_t2l7a < r1_maxRetry_t2l7a -> p_r1_t2l7a : (r1'=r1+1) + (1-p_r1_t2l7a) : (r1'=r1) & (r1retry_t2l7a' = r1retry_t2l7a+1);
  [r1dot2l7a] r1=2 & r1retry_t2l7a >= r1_maxRetry_t2l7a -> 1:(r1'=r1Fail);
  [r1dot3l7Retry] r1=3 & r1retry_t3l7 < r1_maxRetry_t3l7 -> p_r1_t3l7 : (r1'=r1+1) + (1-p_r1_t3l7) : (r1'=r1) & (r1retry_t3l7' = r1retry_t3l7+1);
  [r1dot3l7] r1=3 & r1retry_t3l7 >= r1_maxRetry_t3l7 -> 1:(r1'=r1Fail);
  [r1dot2l7bRetry] r1=4 & r1retry_t2l7b < r1_maxRetry_t2l7b -> p_r1_t2l7b : (r1'=r1+1) + (1-p_r1_t2l7b) : (r1'=r1) & (r1retry_t2l7b' = r1retry_t2l7b+1);
  [r1dot2l7b] r1=4 & r1retry_t2l7b >= r1_maxRetry_t2l7b -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..6];
  r2retry_t2l2 : [0..r2_maxRetry_t2l2] init 0;
  r2retry_t2l5 : [0..r2_maxRetry_t2l5] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2dot2l2Retry] r2=1 & r2retry_t2l2 < r2_maxRetry_t2l2 -> p_r2_t2l2 : (r2'=r2+1) + (1-p_r2_t2l2) : (r2'=r2) & (r2retry_t2l2' = r2retry_t2l2+1);
  [r2dot2l2] r2=1 & r2retry_t2l2 >= r2_maxRetry_t2l2 -> 1:(r2'=r2Fail);
  [r2movel5] r2=2-> 1:(r2'=2+1);
  [r2dot2l5Retry] r2=3 & r2retry_t2l5 < r2_maxRetry_t2l5 -> p_r2_t2l5 : (r2'=r2+1) + (1-p_r2_t2l5) : (r2'=r2) & (r2retry_t2l5' = r2retry_t2l5+1);
  [r2dot2l5] r2=3 & r2retry_t2l5 >= r2_maxRetry_t2l5 -> 1:(r2'=r2Fail);
endmodule

rewards "cost"
  [worker1movel2] true:1;
  [worker1dot3l2] true:5;
  [worker1dot3l2Retry] true:5;
  [worker1movel3] true:1;
  [worker1dot1l3] true:3;
  [worker1dot1l3Retry] true:3;
  [worker1movel6] true:1;
  [worker1dot3l6] true:5;
  [worker1dot3l6Retry] true:5;
  [worker1movel5] true:1;
  [worker1dot1l5] true:3;
  [worker1dot1l5Retry] true:3;
  [worker1movel8] true:1;
  [worker1dot1l8] true:3;
  [worker1dot1l8Retry] true:3;
  [r1movel4] true:1;
  [r1movel7] true:1;
  [r1dot2l7a] true:1;
  [r1dot2l7aRetry] true:1;
  [r1dot3l7] true:1;
  [r1dot3l7Retry] true:1;
  [r1dot2l7b] true:1;
  [r1dot2l7bRetry] true:1;
  [r2movel2] true:1;
  [r2dot2l2] true:1;
  [r2dot2l2Retry] true:1;
  [r2movel5] true:1;
  [r2dot2l5] true:1;
  [r2dot2l5Retry] true:1;
endrewards