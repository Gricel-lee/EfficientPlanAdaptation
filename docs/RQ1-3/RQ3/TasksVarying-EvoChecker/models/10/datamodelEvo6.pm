dtmc
evolve int worker1_maxRetry_t1l8 [1..5];
evolve int worker1_maxRetry_t1l5a [1..5];
evolve int worker1_maxRetry_t1l5b [1..5];
evolve int worker1_maxRetry_t1l6 [1..5];
evolve int worker1_maxRetry_t1l9 [1..5];
evolve int worker2_maxRetry_t3l1 [1..5];
evolve int r2_maxRetry_t2l3 [1..10];
evolve int r2_maxRetry_t3l3 [1..10];
evolve int r2_maxRetry_t2l9 [1..10];
evolve int r2_maxRetry_t2l8 [1..10];

const double p_worker1_t1l8=1.0;
const double p_worker1_t1l5a=1.0;
const double p_worker1_t1l5b=1.0;
const double p_worker1_t1l6=1.0;
const double p_worker1_t1l9=1.0;
const double p_worker2_t3l1=0.99;
const double p_r2_t2l3=0.99;
const double p_r2_t3l3=0.97;
const double p_r2_t2l9=0.99;
const double p_r2_t2l8=0.99;
const int worker1Final = 11;
const int worker1Fail = 12;
const int worker2Final = 1;
const int worker2Fail = 2;
const int r2Final = 9;
const int r2Fail = 10;

module _worker1
  worker1 : [0..13];
  worker1retry_t1l8 : [0..worker1_maxRetry_t1l8] init 0;
  worker1retry_t1l5a : [0..worker1_maxRetry_t1l5a] init 0;
  worker1retry_t1l5b : [0..worker1_maxRetry_t1l5b] init 0;
  worker1retry_t1l6 : [0..worker1_maxRetry_t1l6] init 0;
  worker1retry_t1l9 : [0..worker1_maxRetry_t1l9] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1movel5] worker1=1-> 1:(worker1'=1+1);
  [worker1movel8] worker1=2-> 1:(worker1'=2+1);
  [worker1dot1l8Retry] worker1=3 & worker1retry_t1l8 < worker1_maxRetry_t1l8 -> p_worker1_t1l8 : (worker1'=worker1+1) + (1-p_worker1_t1l8) : (worker1'=worker1) & (worker1retry_t1l8' = worker1retry_t1l8+1);
  [worker1dot1l8] worker1=3 & worker1retry_t1l8 >= worker1_maxRetry_t1l8 -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=4-> 1:(worker1'=4+1);
  [worker1dot1l5aRetry] worker1=5 & worker1retry_t1l5a < worker1_maxRetry_t1l5a -> p_worker1_t1l5a : (worker1'=worker1+1) + (1-p_worker1_t1l5a) : (worker1'=worker1) & (worker1retry_t1l5a' = worker1retry_t1l5a+1);
  [worker1dot1l5a] worker1=5 & worker1retry_t1l5a >= worker1_maxRetry_t1l5a -> 1:(worker1'=worker1Fail);
  [worker1dot1l5bRetry] worker1=6 & worker1retry_t1l5b < worker1_maxRetry_t1l5b -> p_worker1_t1l5b : (worker1'=worker1+1) + (1-p_worker1_t1l5b) : (worker1'=worker1) & (worker1retry_t1l5b' = worker1retry_t1l5b+1);
  [worker1dot1l5b] worker1=6 & worker1retry_t1l5b >= worker1_maxRetry_t1l5b -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=7-> 1:(worker1'=7+1);
  [worker1dot1l6Retry] worker1=8 & worker1retry_t1l6 < worker1_maxRetry_t1l6 -> p_worker1_t1l6 : (worker1'=worker1+1) + (1-p_worker1_t1l6) : (worker1'=worker1) & (worker1retry_t1l6' = worker1retry_t1l6+1);
  [worker1dot1l6] worker1=8 & worker1retry_t1l6 >= worker1_maxRetry_t1l6 -> 1:(worker1'=worker1Fail);
  [worker1movel9] worker1=9-> 1:(worker1'=9+1);
  [worker1dot1l9Retry] worker1=10 & worker1retry_t1l9 < worker1_maxRetry_t1l9 -> p_worker1_t1l9 : (worker1'=worker1+1) + (1-p_worker1_t1l9) : (worker1'=worker1) & (worker1retry_t1l9' = worker1retry_t1l9+1);
  [worker1dot1l9] worker1=10 & worker1retry_t1l9 >= worker1_maxRetry_t1l9 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..3];
  worker2retry_t3l1 : [0..worker2_maxRetry_t3l1] init 0;

  [worker2dot3l1Retry] worker2=0 & worker2retry_t3l1 < worker2_maxRetry_t3l1 -> p_worker2_t3l1 : (worker2'=worker2+1) + (1-p_worker2_t3l1) : (worker2'=worker2) & (worker2retry_t3l1' = worker2retry_t3l1+1);
  [worker2dot3l1] worker2=0 & worker2retry_t3l1 >= worker2_maxRetry_t3l1 -> 1:(worker2'=worker2Fail);
endmodule

module _r2
  r2 : [0..11];
  r2retry_t2l3 : [0..r2_maxRetry_t2l3] init 0;
  r2retry_t3l3 : [0..r2_maxRetry_t3l3] init 0;
  r2retry_t2l9 : [0..r2_maxRetry_t2l9] init 0;
  r2retry_t2l8 : [0..r2_maxRetry_t2l8] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2movel3] r2=1-> 1:(r2'=1+1);
  [r2dot2l3Retry] r2=2 & r2retry_t2l3 < r2_maxRetry_t2l3 -> p_r2_t2l3 : (r2'=r2+1) + (1-p_r2_t2l3) : (r2'=r2) & (r2retry_t2l3' = r2retry_t2l3+1);
  [r2dot2l3] r2=2 & r2retry_t2l3 >= r2_maxRetry_t2l3 -> 1:(r2'=r2Fail);
  [r2dot3l3Retry] r2=3 & r2retry_t3l3 < r2_maxRetry_t3l3 -> p_r2_t3l3 : (r2'=r2+1) + (1-p_r2_t3l3) : (r2'=r2) & (r2retry_t3l3' = r2retry_t3l3+1);
  [r2dot3l3] r2=3 & r2retry_t3l3 >= r2_maxRetry_t3l3 -> 1:(r2'=r2Fail);
  [r2movel6] r2=4-> 1:(r2'=4+1);
  [r2movel9] r2=5-> 1:(r2'=5+1);
  [r2dot2l9Retry] r2=6 & r2retry_t2l9 < r2_maxRetry_t2l9 -> p_r2_t2l9 : (r2'=r2+1) + (1-p_r2_t2l9) : (r2'=r2) & (r2retry_t2l9' = r2retry_t2l9+1);
  [r2dot2l9] r2=6 & r2retry_t2l9 >= r2_maxRetry_t2l9 -> 1:(r2'=r2Fail);
  [r2movel8] r2=7-> 1:(r2'=7+1);
  [r2dot2l8Retry] r2=8 & r2retry_t2l8 < r2_maxRetry_t2l8 -> p_r2_t2l8 : (r2'=r2+1) + (1-p_r2_t2l8) : (r2'=r2) & (r2retry_t2l8' = r2retry_t2l8+1);
  [r2dot2l8] r2=8 & r2retry_t2l8 >= r2_maxRetry_t2l8 -> 1:(r2'=r2Fail);
endmodule

rewards "cost"
  [worker1movel4] true:1;
  [worker1movel5] true:1;
  [worker1movel8] true:1;
  [worker1dot1l8] true:3;
  [worker1dot1l8Retry] true:3;
  [worker1movel5] true:1;
  [worker1dot1l5a] true:3;
  [worker1dot1l5aRetry] true:3;
  [worker1dot1l5b] true:3;
  [worker1dot1l5bRetry] true:3;
  [worker1movel6] true:1;
  [worker1dot1l6] true:3;
  [worker1dot1l6Retry] true:3;
  [worker1movel9] true:1;
  [worker1dot1l9] true:3;
  [worker1dot1l9Retry] true:3;
  [worker2dot3l1] true:5;
  [worker2dot3l1Retry] true:5;
  [r2movel2] true:1;
  [r2movel3] true:1;
  [r2dot2l3] true:1;
  [r2dot2l3Retry] true:1;
  [r2dot3l3] true:1;
  [r2dot3l3Retry] true:1;
  [r2movel6] true:1;
  [r2movel9] true:1;
  [r2dot2l9] true:1;
  [r2dot2l9Retry] true:1;
  [r2movel8] true:1;
  [r2dot2l8] true:1;
  [r2dot2l8Retry] true:1;
endrewards