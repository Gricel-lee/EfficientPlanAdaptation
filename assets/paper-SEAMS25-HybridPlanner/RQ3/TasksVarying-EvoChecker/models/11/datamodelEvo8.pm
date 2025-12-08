dtmc
evolve int r2_maxRetry_t2l7 [1..10];
evolve int worker2_maxRetry_t3l2 [1..5];
evolve int worker2_maxRetry_t1l3 [1..5];
evolve int worker2_maxRetry_t3l6 [1..5];
evolve int worker2_maxRetry_t3l5 [1..5];
evolve int worker2_maxRetry_t1l5a [1..5];
evolve int worker2_maxRetry_t1l5b [1..5];
evolve int r1_maxRetry_t2l1 [1..10];
evolve int r1_maxRetry_t2l2a [1..10];
evolve int r1_maxRetry_t2l2b [1..10];
evolve int r1_maxRetry_t2l3 [1..10];

const double p_r2_t2l7=0.99;
const double p_worker2_t3l2=0.99;
const double p_worker2_t1l3=1.0;
const double p_worker2_t3l6=0.99;
const double p_worker2_t3l5=0.99;
const double p_worker2_t1l5a=1.0;
const double p_worker2_t1l5b=1.0;
const double p_r1_t2l1=0.99;
const double p_r1_t2l2a=0.99;
const double p_r1_t2l2b=0.99;
const double p_r1_t2l3=0.99;
const int r2Final = 3;
const int r2Fail = 4;
const int worker2Final = 10;
const int worker2Fail = 11;
const int r1Final = 6;
const int r1Fail = 7;

module _r2
  r2 : [0..5];
  r2retry_t2l7 : [0..r2_maxRetry_t2l7] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2movel7] r2=1-> 1:(r2'=1+1);
  [r2dot2l7Retry] r2=2 & r2retry_t2l7 < r2_maxRetry_t2l7 -> p_r2_t2l7 : (r2'=r2+1) + (1-p_r2_t2l7) : (r2'=r2) & (r2retry_t2l7' = r2retry_t2l7+1);
  [r2dot2l7] r2=2 & r2retry_t2l7 >= r2_maxRetry_t2l7 -> 1:(r2'=r2Fail);
endmodule

module _worker2
  worker2 : [0..12];
  worker2retry_t3l2 : [0..worker2_maxRetry_t3l2] init 0;
  worker2retry_t1l3 : [0..worker2_maxRetry_t1l3] init 0;
  worker2retry_t3l6 : [0..worker2_maxRetry_t3l6] init 0;
  worker2retry_t3l5 : [0..worker2_maxRetry_t3l5] init 0;
  worker2retry_t1l5a : [0..worker2_maxRetry_t1l5a] init 0;
  worker2retry_t1l5b : [0..worker2_maxRetry_t1l5b] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot3l2Retry] worker2=1 & worker2retry_t3l2 < worker2_maxRetry_t3l2 -> p_worker2_t3l2 : (worker2'=worker2+1) + (1-p_worker2_t3l2) : (worker2'=worker2) & (worker2retry_t3l2' = worker2retry_t3l2+1);
  [worker2dot3l2] worker2=1 & worker2retry_t3l2 >= worker2_maxRetry_t3l2 -> 1:(worker2'=worker2Fail);
  [worker2movel3] worker2=2-> 1:(worker2'=2+1);
  [worker2dot1l3Retry] worker2=3 & worker2retry_t1l3 < worker2_maxRetry_t1l3 -> p_worker2_t1l3 : (worker2'=worker2+1) + (1-p_worker2_t1l3) : (worker2'=worker2) & (worker2retry_t1l3' = worker2retry_t1l3+1);
  [worker2dot1l3] worker2=3 & worker2retry_t1l3 >= worker2_maxRetry_t1l3 -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=4-> 1:(worker2'=4+1);
  [worker2dot3l6Retry] worker2=5 & worker2retry_t3l6 < worker2_maxRetry_t3l6 -> p_worker2_t3l6 : (worker2'=worker2+1) + (1-p_worker2_t3l6) : (worker2'=worker2) & (worker2retry_t3l6' = worker2retry_t3l6+1);
  [worker2dot3l6] worker2=5 & worker2retry_t3l6 >= worker2_maxRetry_t3l6 -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=6-> 1:(worker2'=6+1);
  [worker2dot3l5Retry] worker2=7 & worker2retry_t3l5 < worker2_maxRetry_t3l5 -> p_worker2_t3l5 : (worker2'=worker2+1) + (1-p_worker2_t3l5) : (worker2'=worker2) & (worker2retry_t3l5' = worker2retry_t3l5+1);
  [worker2dot3l5] worker2=7 & worker2retry_t3l5 >= worker2_maxRetry_t3l5 -> 1:(worker2'=worker2Fail);
  [worker2dot1l5aRetry] worker2=8 & worker2retry_t1l5a < worker2_maxRetry_t1l5a -> p_worker2_t1l5a : (worker2'=worker2+1) + (1-p_worker2_t1l5a) : (worker2'=worker2) & (worker2retry_t1l5a' = worker2retry_t1l5a+1);
  [worker2dot1l5a] worker2=8 & worker2retry_t1l5a >= worker2_maxRetry_t1l5a -> 1:(worker2'=worker2Fail);
  [worker2dot1l5bRetry] worker2=9 & worker2retry_t1l5b < worker2_maxRetry_t1l5b -> p_worker2_t1l5b : (worker2'=worker2+1) + (1-p_worker2_t1l5b) : (worker2'=worker2) & (worker2retry_t1l5b' = worker2retry_t1l5b+1);
  [worker2dot1l5b] worker2=9 & worker2retry_t1l5b >= worker2_maxRetry_t1l5b -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..8];
  r1retry_t2l1 : [0..r1_maxRetry_t2l1] init 0;
  r1retry_t2l2a : [0..r1_maxRetry_t2l2a] init 0;
  r1retry_t2l2b : [0..r1_maxRetry_t2l2b] init 0;
  r1retry_t2l3 : [0..r1_maxRetry_t2l3] init 0;

  [r1dot2l1Retry] r1=0 & r1retry_t2l1 < r1_maxRetry_t2l1 -> p_r1_t2l1 : (r1'=r1+1) + (1-p_r1_t2l1) : (r1'=r1) & (r1retry_t2l1' = r1retry_t2l1+1);
  [r1dot2l1] r1=0 & r1retry_t2l1 >= r1_maxRetry_t2l1 -> 1:(r1'=r1Fail);
  [r1movel2] r1=1-> 1:(r1'=1+1);
  [r1dot2l2aRetry] r1=2 & r1retry_t2l2a < r1_maxRetry_t2l2a -> p_r1_t2l2a : (r1'=r1+1) + (1-p_r1_t2l2a) : (r1'=r1) & (r1retry_t2l2a' = r1retry_t2l2a+1);
  [r1dot2l2a] r1=2 & r1retry_t2l2a >= r1_maxRetry_t2l2a -> 1:(r1'=r1Fail);
  [r1dot2l2bRetry] r1=3 & r1retry_t2l2b < r1_maxRetry_t2l2b -> p_r1_t2l2b : (r1'=r1+1) + (1-p_r1_t2l2b) : (r1'=r1) & (r1retry_t2l2b' = r1retry_t2l2b+1);
  [r1dot2l2b] r1=3 & r1retry_t2l2b >= r1_maxRetry_t2l2b -> 1:(r1'=r1Fail);
  [r1movel3] r1=4-> 1:(r1'=4+1);
  [r1dot2l3Retry] r1=5 & r1retry_t2l3 < r1_maxRetry_t2l3 -> p_r1_t2l3 : (r1'=r1+1) + (1-p_r1_t2l3) : (r1'=r1) & (r1retry_t2l3' = r1retry_t2l3+1);
  [r1dot2l3] r1=5 & r1retry_t2l3 >= r1_maxRetry_t2l3 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [r2movel4] true:1;
  [r2movel7] true:1;
  [r2dot2l7] true:1;
  [r2dot2l7Retry] true:1;
  [worker2movel2] true:1;
  [worker2dot3l2] true:5;
  [worker2dot3l2Retry] true:5;
  [worker2movel3] true:1;
  [worker2dot1l3] true:3;
  [worker2dot1l3Retry] true:3;
  [worker2movel6] true:1;
  [worker2dot3l6] true:5;
  [worker2dot3l6Retry] true:5;
  [worker2movel5] true:1;
  [worker2dot3l5] true:5;
  [worker2dot3l5Retry] true:5;
  [worker2dot1l5a] true:3;
  [worker2dot1l5aRetry] true:3;
  [worker2dot1l5b] true:3;
  [worker2dot1l5bRetry] true:3;
  [r1dot2l1] true:1;
  [r1dot2l1Retry] true:1;
  [r1movel2] true:1;
  [r1dot2l2a] true:1;
  [r1dot2l2aRetry] true:1;
  [r1dot2l2b] true:1;
  [r1dot2l2bRetry] true:1;
  [r1movel3] true:1;
  [r1dot2l3] true:1;
  [r1dot2l3Retry] true:1;
endrewards