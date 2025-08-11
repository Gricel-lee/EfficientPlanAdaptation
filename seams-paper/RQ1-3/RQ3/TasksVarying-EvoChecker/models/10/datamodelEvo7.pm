dtmc
evolve int worker2_maxRetry_t3l4 [1..5];
evolve int worker2_maxRetry_t1l7 [1..5];
evolve int worker2_maxRetry_t3l7 [1..5];
evolve int worker2_maxRetry_t3l8 [1..5];
evolve int worker2_maxRetry_t1l5 [1..5];
evolve int worker2_maxRetry_t3l6 [1..5];
evolve int worker2_maxRetry_t1l3 [1..5];
evolve int r2_maxRetry_t3l1 [1..10];
evolve int r2_maxRetry_t2l2b [1..10];
evolve int r2_maxRetry_t2l2a [1..10];

const double p_worker2_t3l4=0.99;
const double p_worker2_t1l7=1.0;
const double p_worker2_t3l7=0.99;
const double p_worker2_t3l8=0.99;
const double p_worker2_t1l5=1.0;
const double p_worker2_t3l6=0.99;
const double p_worker2_t1l3=1.0;
const double p_r2_t3l1=0.97;
const double p_r2_t2l2b=0.99;
const double p_r2_t2l2a=0.99;
const int worker2Final = 13;
const int worker2Fail = 14;
const int r2Final = 4;
const int r2Fail = 5;

module _worker2
  worker2 : [0..15];
  worker2retry_t3l4 : [0..worker2_maxRetry_t3l4] init 0;
  worker2retry_t1l7 : [0..worker2_maxRetry_t1l7] init 0;
  worker2retry_t3l7 : [0..worker2_maxRetry_t3l7] init 0;
  worker2retry_t3l8 : [0..worker2_maxRetry_t3l8] init 0;
  worker2retry_t1l5 : [0..worker2_maxRetry_t1l5] init 0;
  worker2retry_t3l6 : [0..worker2_maxRetry_t3l6] init 0;
  worker2retry_t1l3 : [0..worker2_maxRetry_t1l3] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2dot3l4Retry] worker2=1 & worker2retry_t3l4 < worker2_maxRetry_t3l4 -> p_worker2_t3l4 : (worker2'=worker2+1) + (1-p_worker2_t3l4) : (worker2'=worker2) & (worker2retry_t3l4' = worker2retry_t3l4+1);
  [worker2dot3l4] worker2=1 & worker2retry_t3l4 >= worker2_maxRetry_t3l4 -> 1:(worker2'=worker2Fail);
  [worker2movel7] worker2=2-> 1:(worker2'=2+1);
  [worker2dot1l7Retry] worker2=3 & worker2retry_t1l7 < worker2_maxRetry_t1l7 -> p_worker2_t1l7 : (worker2'=worker2+1) + (1-p_worker2_t1l7) : (worker2'=worker2) & (worker2retry_t1l7' = worker2retry_t1l7+1);
  [worker2dot1l7] worker2=3 & worker2retry_t1l7 >= worker2_maxRetry_t1l7 -> 1:(worker2'=worker2Fail);
  [worker2dot3l7Retry] worker2=4 & worker2retry_t3l7 < worker2_maxRetry_t3l7 -> p_worker2_t3l7 : (worker2'=worker2+1) + (1-p_worker2_t3l7) : (worker2'=worker2) & (worker2retry_t3l7' = worker2retry_t3l7+1);
  [worker2dot3l7] worker2=4 & worker2retry_t3l7 >= worker2_maxRetry_t3l7 -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=5-> 1:(worker2'=5+1);
  [worker2dot3l8Retry] worker2=6 & worker2retry_t3l8 < worker2_maxRetry_t3l8 -> p_worker2_t3l8 : (worker2'=worker2+1) + (1-p_worker2_t3l8) : (worker2'=worker2) & (worker2retry_t3l8' = worker2retry_t3l8+1);
  [worker2dot3l8] worker2=6 & worker2retry_t3l8 >= worker2_maxRetry_t3l8 -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=7-> 1:(worker2'=7+1);
  [worker2dot1l5Retry] worker2=8 & worker2retry_t1l5 < worker2_maxRetry_t1l5 -> p_worker2_t1l5 : (worker2'=worker2+1) + (1-p_worker2_t1l5) : (worker2'=worker2) & (worker2retry_t1l5' = worker2retry_t1l5+1);
  [worker2dot1l5] worker2=8 & worker2retry_t1l5 >= worker2_maxRetry_t1l5 -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=9-> 1:(worker2'=9+1);
  [worker2dot3l6Retry] worker2=10 & worker2retry_t3l6 < worker2_maxRetry_t3l6 -> p_worker2_t3l6 : (worker2'=worker2+1) + (1-p_worker2_t3l6) : (worker2'=worker2) & (worker2retry_t3l6' = worker2retry_t3l6+1);
  [worker2dot3l6] worker2=10 & worker2retry_t3l6 >= worker2_maxRetry_t3l6 -> 1:(worker2'=worker2Fail);
  [worker2movel3] worker2=11-> 1:(worker2'=11+1);
  [worker2dot1l3Retry] worker2=12 & worker2retry_t1l3 < worker2_maxRetry_t1l3 -> p_worker2_t1l3 : (worker2'=worker2+1) + (1-p_worker2_t1l3) : (worker2'=worker2) & (worker2retry_t1l3' = worker2retry_t1l3+1);
  [worker2dot1l3] worker2=12 & worker2retry_t1l3 >= worker2_maxRetry_t1l3 -> 1:(worker2'=worker2Fail);
endmodule

module _r2
  r2 : [0..6];
  r2retry_t3l1 : [0..r2_maxRetry_t3l1] init 0;
  r2retry_t2l2b : [0..r2_maxRetry_t2l2b] init 0;
  r2retry_t2l2a : [0..r2_maxRetry_t2l2a] init 0;

  [r2dot3l1Retry] r2=0 & r2retry_t3l1 < r2_maxRetry_t3l1 -> p_r2_t3l1 : (r2'=r2+1) + (1-p_r2_t3l1) : (r2'=r2) & (r2retry_t3l1' = r2retry_t3l1+1);
  [r2dot3l1] r2=0 & r2retry_t3l1 >= r2_maxRetry_t3l1 -> 1:(r2'=r2Fail);
  [r2movel2] r2=1-> 1:(r2'=1+1);
  [r2dot2l2bRetry] r2=2 & r2retry_t2l2b < r2_maxRetry_t2l2b -> p_r2_t2l2b : (r2'=r2+1) + (1-p_r2_t2l2b) : (r2'=r2) & (r2retry_t2l2b' = r2retry_t2l2b+1);
  [r2dot2l2b] r2=2 & r2retry_t2l2b >= r2_maxRetry_t2l2b -> 1:(r2'=r2Fail);
  [r2dot2l2aRetry] r2=3 & r2retry_t2l2a < r2_maxRetry_t2l2a -> p_r2_t2l2a : (r2'=r2+1) + (1-p_r2_t2l2a) : (r2'=r2) & (r2retry_t2l2a' = r2retry_t2l2a+1);
  [r2dot2l2a] r2=3 & r2retry_t2l2a >= r2_maxRetry_t2l2a -> 1:(r2'=r2Fail);
endmodule

rewards "cost"
  [worker2movel4] true:1;
  [worker2dot3l4] true:5;
  [worker2dot3l4Retry] true:5;
  [worker2movel7] true:1;
  [worker2dot1l7] true:3;
  [worker2dot1l7Retry] true:3;
  [worker2dot3l7] true:5;
  [worker2dot3l7Retry] true:5;
  [worker2movel8] true:1;
  [worker2dot3l8] true:5;
  [worker2dot3l8Retry] true:5;
  [worker2movel5] true:1;
  [worker2dot1l5] true:3;
  [worker2dot1l5Retry] true:3;
  [worker2movel6] true:1;
  [worker2dot3l6] true:5;
  [worker2dot3l6Retry] true:5;
  [worker2movel3] true:1;
  [worker2dot1l3] true:3;
  [worker2dot1l3Retry] true:3;
  [r2dot3l1] true:1;
  [r2dot3l1Retry] true:1;
  [r2movel2] true:1;
  [r2dot2l2b] true:1;
  [r2dot2l2bRetry] true:1;
  [r2dot2l2a] true:1;
  [r2dot2l2aRetry] true:1;
endrewards