dtmc
evolve int worker1_maxRetry_t1l2a [1..5];
evolve int worker1_maxRetry_t1l2b [1..5];
evolve int worker2_maxRetry_t1l7b [1..5];
evolve int worker2_maxRetry_t1l7a [1..5];
evolve int r2_maxRetry_t3l4 [1..10];
evolve int r2_maxRetry_t2l7 [1..10];
evolve int r2_maxRetry_t3l8 [1..10];
evolve int r2_maxRetry_t2l5 [1..10];
evolve int r2_maxRetry_t3l6 [1..10];
evolve int r2_maxRetry_t2l3 [1..10];

const double p_worker1_t1l2a=1.0;
const double p_worker1_t1l2b=1.0;
const double p_worker2_t1l7b=1.0;
const double p_worker2_t1l7a=1.0;
const double p_r2_t3l4=0.97;
const double p_r2_t2l7=0.99;
const double p_r2_t3l8=0.97;
const double p_r2_t2l5=0.99;
const double p_r2_t3l6=0.97;
const double p_r2_t2l3=0.99;
const int worker1Final = 3;
const int worker1Fail = 4;
const int worker2Final = 4;
const int worker2Fail = 5;
const int r2Final = 12;
const int r2Fail = 13;

module _worker1
  worker1 : [0..5];
  worker1retry_t1l2a : [0..worker1_maxRetry_t1l2a] init 0;
  worker1retry_t1l2b : [0..worker1_maxRetry_t1l2b] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l2aRetry] worker1=1 & worker1retry_t1l2a < worker1_maxRetry_t1l2a -> p_worker1_t1l2a : (worker1'=worker1+1) + (1-p_worker1_t1l2a) : (worker1'=worker1) & (worker1retry_t1l2a' = worker1retry_t1l2a+1);
  [worker1dot1l2a] worker1=1 & worker1retry_t1l2a >= worker1_maxRetry_t1l2a -> 1:(worker1'=worker1Fail);
  [worker1dot1l2bRetry] worker1=2 & worker1retry_t1l2b < worker1_maxRetry_t1l2b -> p_worker1_t1l2b : (worker1'=worker1+1) + (1-p_worker1_t1l2b) : (worker1'=worker1) & (worker1retry_t1l2b' = worker1retry_t1l2b+1);
  [worker1dot1l2b] worker1=2 & worker1retry_t1l2b >= worker1_maxRetry_t1l2b -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..6];
  worker2retry_t1l7b : [0..worker2_maxRetry_t1l7b] init 0;
  worker2retry_t1l7a : [0..worker2_maxRetry_t1l7a] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2movel7] worker2=1-> 1:(worker2'=1+1);
  [worker2dot1l7bRetry] worker2=2 & worker2retry_t1l7b < worker2_maxRetry_t1l7b -> p_worker2_t1l7b : (worker2'=worker2+1) + (1-p_worker2_t1l7b) : (worker2'=worker2) & (worker2retry_t1l7b' = worker2retry_t1l7b+1);
  [worker2dot1l7b] worker2=2 & worker2retry_t1l7b >= worker2_maxRetry_t1l7b -> 1:(worker2'=worker2Fail);
  [worker2dot1l7aRetry] worker2=3 & worker2retry_t1l7a < worker2_maxRetry_t1l7a -> p_worker2_t1l7a : (worker2'=worker2+1) + (1-p_worker2_t1l7a) : (worker2'=worker2) & (worker2retry_t1l7a' = worker2retry_t1l7a+1);
  [worker2dot1l7a] worker2=3 & worker2retry_t1l7a >= worker2_maxRetry_t1l7a -> 1:(worker2'=worker2Fail);
endmodule

module _r2
  r2 : [0..14];
  r2retry_t3l4 : [0..r2_maxRetry_t3l4] init 0;
  r2retry_t2l7 : [0..r2_maxRetry_t2l7] init 0;
  r2retry_t3l8 : [0..r2_maxRetry_t3l8] init 0;
  r2retry_t2l5 : [0..r2_maxRetry_t2l5] init 0;
  r2retry_t3l6 : [0..r2_maxRetry_t3l6] init 0;
  r2retry_t2l3 : [0..r2_maxRetry_t2l3] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2dot3l4Retry] r2=1 & r2retry_t3l4 < r2_maxRetry_t3l4 -> p_r2_t3l4 : (r2'=r2+1) + (1-p_r2_t3l4) : (r2'=r2) & (r2retry_t3l4' = r2retry_t3l4+1);
  [r2dot3l4] r2=1 & r2retry_t3l4 >= r2_maxRetry_t3l4 -> 1:(r2'=r2Fail);
  [r2movel7] r2=2-> 1:(r2'=2+1);
  [r2dot2l7Retry] r2=3 & r2retry_t2l7 < r2_maxRetry_t2l7 -> p_r2_t2l7 : (r2'=r2+1) + (1-p_r2_t2l7) : (r2'=r2) & (r2retry_t2l7' = r2retry_t2l7+1);
  [r2dot2l7] r2=3 & r2retry_t2l7 >= r2_maxRetry_t2l7 -> 1:(r2'=r2Fail);
  [r2movel8] r2=4-> 1:(r2'=4+1);
  [r2dot3l8Retry] r2=5 & r2retry_t3l8 < r2_maxRetry_t3l8 -> p_r2_t3l8 : (r2'=r2+1) + (1-p_r2_t3l8) : (r2'=r2) & (r2retry_t3l8' = r2retry_t3l8+1);
  [r2dot3l8] r2=5 & r2retry_t3l8 >= r2_maxRetry_t3l8 -> 1:(r2'=r2Fail);
  [r2movel5] r2=6-> 1:(r2'=6+1);
  [r2dot2l5Retry] r2=7 & r2retry_t2l5 < r2_maxRetry_t2l5 -> p_r2_t2l5 : (r2'=r2+1) + (1-p_r2_t2l5) : (r2'=r2) & (r2retry_t2l5' = r2retry_t2l5+1);
  [r2dot2l5] r2=7 & r2retry_t2l5 >= r2_maxRetry_t2l5 -> 1:(r2'=r2Fail);
  [r2movel6] r2=8-> 1:(r2'=8+1);
  [r2dot3l6Retry] r2=9 & r2retry_t3l6 < r2_maxRetry_t3l6 -> p_r2_t3l6 : (r2'=r2+1) + (1-p_r2_t3l6) : (r2'=r2) & (r2retry_t3l6' = r2retry_t3l6+1);
  [r2dot3l6] r2=9 & r2retry_t3l6 >= r2_maxRetry_t3l6 -> 1:(r2'=r2Fail);
  [r2movel3] r2=10-> 1:(r2'=10+1);
  [r2dot2l3Retry] r2=11 & r2retry_t2l3 < r2_maxRetry_t2l3 -> p_r2_t2l3 : (r2'=r2+1) + (1-p_r2_t2l3) : (r2'=r2) & (r2retry_t2l3' = r2retry_t2l3+1);
  [r2dot2l3] r2=11 & r2retry_t2l3 >= r2_maxRetry_t2l3 -> 1:(r2'=r2Fail);
endmodule

rewards "cost"
  [worker1movel2] true:1;
  [worker1dot1l2a] true:3;
  [worker1dot1l2aRetry] true:3;
  [worker1dot1l2b] true:3;
  [worker1dot1l2bRetry] true:3;
  [worker2movel4] true:1;
  [worker2movel7] true:1;
  [worker2dot1l7b] true:3;
  [worker2dot1l7bRetry] true:3;
  [worker2dot1l7a] true:3;
  [worker2dot1l7aRetry] true:3;
  [r2movel4] true:1;
  [r2dot3l4] true:1;
  [r2dot3l4Retry] true:1;
  [r2movel7] true:1;
  [r2dot2l7] true:1;
  [r2dot2l7Retry] true:1;
  [r2movel8] true:1;
  [r2dot3l8] true:1;
  [r2dot3l8Retry] true:1;
  [r2movel5] true:1;
  [r2dot2l5] true:1;
  [r2dot2l5Retry] true:1;
  [r2movel6] true:1;
  [r2dot3l6] true:1;
  [r2dot3l6Retry] true:1;
  [r2movel3] true:1;
  [r2dot2l3] true:1;
  [r2dot2l3Retry] true:1;
endrewards