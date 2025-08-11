dtmc
evolve int r1_maxRetry_t2l4 [1..10];
evolve int r1_maxRetry_t3l4a [1..10];
evolve int r2_maxRetry_t2l2 [1..10];
evolve int r2_maxRetry_t3l3 [1..10];
evolve int r2_maxRetry_t3l6 [1..10];
evolve int r2_maxRetry_t3l9 [1..10];
evolve int r2_maxRetry_t2l9 [1..10];
evolve int worker2_maxRetry_t3l4b [1..5];
evolve int worker2_maxRetry_t3l7 [1..5];
evolve int worker2_maxRetry_t1l8 [1..5];
evolve int worker2_maxRetry_t1l5a [1..5];
evolve int worker2_maxRetry_t1l5b [1..5];

const double p_r1_t2l4=0.99;
const double p_r1_t3l4a=0.97;
const double p_r2_t2l2=0.99;
const double p_r2_t3l3=0.97;
const double p_r2_t3l6=0.97;
const double p_r2_t3l9=0.97;
const double p_r2_t2l9=0.99;
const double p_worker2_t3l4b=0.99;
const double p_worker2_t3l7=0.99;
const double p_worker2_t1l8=1.0;
const double p_worker2_t1l5a=1.0;
const double p_worker2_t1l5b=1.0;
const int r1Final = 3;
const int r1Fail = 4;
const int r2Final = 9;
const int r2Fail = 10;
const int worker2Final = 9;
const int worker2Fail = 10;

module _r1
  r1 : [0..5];
  r1retry_t2l4 : [0..r1_maxRetry_t2l4] init 0;
  r1retry_t3l4a : [0..r1_maxRetry_t3l4a] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1dot2l4Retry] r1=1 & r1retry_t2l4 < r1_maxRetry_t2l4 -> p_r1_t2l4 : (r1'=r1+1) + (1-p_r1_t2l4) : (r1'=r1) & (r1retry_t2l4' = r1retry_t2l4+1);
  [r1dot2l4] r1=1 & r1retry_t2l4 >= r1_maxRetry_t2l4 -> 1:(r1'=r1Fail);
  [r1dot3l4aRetry] r1=2 & r1retry_t3l4a < r1_maxRetry_t3l4a -> p_r1_t3l4a : (r1'=r1+1) + (1-p_r1_t3l4a) : (r1'=r1) & (r1retry_t3l4a' = r1retry_t3l4a+1);
  [r1dot3l4a] r1=2 & r1retry_t3l4a >= r1_maxRetry_t3l4a -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..11];
  r2retry_t2l2 : [0..r2_maxRetry_t2l2] init 0;
  r2retry_t3l3 : [0..r2_maxRetry_t3l3] init 0;
  r2retry_t3l6 : [0..r2_maxRetry_t3l6] init 0;
  r2retry_t3l9 : [0..r2_maxRetry_t3l9] init 0;
  r2retry_t2l9 : [0..r2_maxRetry_t2l9] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2dot2l2Retry] r2=1 & r2retry_t2l2 < r2_maxRetry_t2l2 -> p_r2_t2l2 : (r2'=r2+1) + (1-p_r2_t2l2) : (r2'=r2) & (r2retry_t2l2' = r2retry_t2l2+1);
  [r2dot2l2] r2=1 & r2retry_t2l2 >= r2_maxRetry_t2l2 -> 1:(r2'=r2Fail);
  [r2movel3] r2=2-> 1:(r2'=2+1);
  [r2dot3l3Retry] r2=3 & r2retry_t3l3 < r2_maxRetry_t3l3 -> p_r2_t3l3 : (r2'=r2+1) + (1-p_r2_t3l3) : (r2'=r2) & (r2retry_t3l3' = r2retry_t3l3+1);
  [r2dot3l3] r2=3 & r2retry_t3l3 >= r2_maxRetry_t3l3 -> 1:(r2'=r2Fail);
  [r2movel6] r2=4-> 1:(r2'=4+1);
  [r2dot3l6Retry] r2=5 & r2retry_t3l6 < r2_maxRetry_t3l6 -> p_r2_t3l6 : (r2'=r2+1) + (1-p_r2_t3l6) : (r2'=r2) & (r2retry_t3l6' = r2retry_t3l6+1);
  [r2dot3l6] r2=5 & r2retry_t3l6 >= r2_maxRetry_t3l6 -> 1:(r2'=r2Fail);
  [r2movel9] r2=6-> 1:(r2'=6+1);
  [r2dot3l9Retry] r2=7 & r2retry_t3l9 < r2_maxRetry_t3l9 -> p_r2_t3l9 : (r2'=r2+1) + (1-p_r2_t3l9) : (r2'=r2) & (r2retry_t3l9' = r2retry_t3l9+1);
  [r2dot3l9] r2=7 & r2retry_t3l9 >= r2_maxRetry_t3l9 -> 1:(r2'=r2Fail);
  [r2dot2l9Retry] r2=8 & r2retry_t2l9 < r2_maxRetry_t2l9 -> p_r2_t2l9 : (r2'=r2+1) + (1-p_r2_t2l9) : (r2'=r2) & (r2retry_t2l9' = r2retry_t2l9+1);
  [r2dot2l9] r2=8 & r2retry_t2l9 >= r2_maxRetry_t2l9 -> 1:(r2'=r2Fail);
endmodule

module _worker2
  worker2 : [0..11];
  worker2retry_t3l4b : [0..worker2_maxRetry_t3l4b] init 0;
  worker2retry_t3l7 : [0..worker2_maxRetry_t3l7] init 0;
  worker2retry_t1l8 : [0..worker2_maxRetry_t1l8] init 0;
  worker2retry_t1l5a : [0..worker2_maxRetry_t1l5a] init 0;
  worker2retry_t1l5b : [0..worker2_maxRetry_t1l5b] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2dot3l4bRetry] worker2=1 & worker2retry_t3l4b < worker2_maxRetry_t3l4b -> p_worker2_t3l4b : (worker2'=worker2+1) + (1-p_worker2_t3l4b) : (worker2'=worker2) & (worker2retry_t3l4b' = worker2retry_t3l4b+1);
  [worker2dot3l4b] worker2=1 & worker2retry_t3l4b >= worker2_maxRetry_t3l4b -> 1:(worker2'=worker2Fail);
  [worker2movel7] worker2=2-> 1:(worker2'=2+1);
  [worker2dot3l7Retry] worker2=3 & worker2retry_t3l7 < worker2_maxRetry_t3l7 -> p_worker2_t3l7 : (worker2'=worker2+1) + (1-p_worker2_t3l7) : (worker2'=worker2) & (worker2retry_t3l7' = worker2retry_t3l7+1);
  [worker2dot3l7] worker2=3 & worker2retry_t3l7 >= worker2_maxRetry_t3l7 -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=4-> 1:(worker2'=4+1);
  [worker2dot1l8Retry] worker2=5 & worker2retry_t1l8 < worker2_maxRetry_t1l8 -> p_worker2_t1l8 : (worker2'=worker2+1) + (1-p_worker2_t1l8) : (worker2'=worker2) & (worker2retry_t1l8' = worker2retry_t1l8+1);
  [worker2dot1l8] worker2=5 & worker2retry_t1l8 >= worker2_maxRetry_t1l8 -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=6-> 1:(worker2'=6+1);
  [worker2dot1l5aRetry] worker2=7 & worker2retry_t1l5a < worker2_maxRetry_t1l5a -> p_worker2_t1l5a : (worker2'=worker2+1) + (1-p_worker2_t1l5a) : (worker2'=worker2) & (worker2retry_t1l5a' = worker2retry_t1l5a+1);
  [worker2dot1l5a] worker2=7 & worker2retry_t1l5a >= worker2_maxRetry_t1l5a -> 1:(worker2'=worker2Fail);
  [worker2dot1l5bRetry] worker2=8 & worker2retry_t1l5b < worker2_maxRetry_t1l5b -> p_worker2_t1l5b : (worker2'=worker2+1) + (1-p_worker2_t1l5b) : (worker2'=worker2) & (worker2retry_t1l5b' = worker2retry_t1l5b+1);
  [worker2dot1l5b] worker2=8 & worker2retry_t1l5b >= worker2_maxRetry_t1l5b -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r1movel4] true:1;
  [r1dot2l4] true:1;
  [r1dot2l4Retry] true:1;
  [r1dot3l4a] true:1;
  [r1dot3l4aRetry] true:1;
  [r2movel2] true:1;
  [r2dot2l2] true:1;
  [r2dot2l2Retry] true:1;
  [r2movel3] true:1;
  [r2dot3l3] true:1;
  [r2dot3l3Retry] true:1;
  [r2movel6] true:1;
  [r2dot3l6] true:1;
  [r2dot3l6Retry] true:1;
  [r2movel9] true:1;
  [r2dot3l9] true:1;
  [r2dot3l9Retry] true:1;
  [r2dot2l9] true:1;
  [r2dot2l9Retry] true:1;
  [worker2movel4] true:1;
  [worker2dot3l4b] true:5;
  [worker2dot3l4bRetry] true:5;
  [worker2movel7] true:1;
  [worker2dot3l7] true:5;
  [worker2dot3l7Retry] true:5;
  [worker2movel8] true:1;
  [worker2dot1l8] true:3;
  [worker2dot1l8Retry] true:3;
  [worker2movel5] true:1;
  [worker2dot1l5a] true:3;
  [worker2dot1l5aRetry] true:3;
  [worker2dot1l5b] true:3;
  [worker2dot1l5bRetry] true:3;
endrewards