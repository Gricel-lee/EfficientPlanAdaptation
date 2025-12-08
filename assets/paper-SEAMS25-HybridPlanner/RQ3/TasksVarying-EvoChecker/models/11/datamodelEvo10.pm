dtmc
evolve int r2_maxRetry_t2l1 [1..10];
evolve int worker1_maxRetry_t3l4 [1..5];
evolve int worker1_maxRetry_t3l7 [1..5];
evolve int worker2_maxRetry_t3l2 [1..5];
evolve int worker2_maxRetry_t1l5b [1..5];
evolve int worker2_maxRetry_t1l5a [1..5];
evolve int r1_maxRetry_t3l3 [1..10];
evolve int r1_maxRetry_t3l6 [1..10];
evolve int r1_maxRetry_t2l5 [1..10];
evolve int r1_maxRetry_t2l8 [1..10];
evolve int r1_maxRetry_t2l9 [1..10];

const double p_r2_t2l1=0.99;
const double p_worker1_t3l4=0.99;
const double p_worker1_t3l7=0.99;
const double p_worker2_t3l2=0.99;
const double p_worker2_t1l5b=1.0;
const double p_worker2_t1l5a=1.0;
const double p_r1_t3l3=0.97;
const double p_r1_t3l6=0.97;
const double p_r1_t2l5=0.99;
const double p_r1_t2l8=0.99;
const double p_r1_t2l9=0.99;
const int r2Final = 1;
const int r2Fail = 2;
const int worker1Final = 4;
const int worker1Fail = 5;
const int worker2Final = 5;
const int worker2Fail = 6;
const int r1Final = 11;
const int r1Fail = 12;

module _r2
  r2 : [0..3];
  r2retry_t2l1 : [0..r2_maxRetry_t2l1] init 0;

  [r2dot2l1Retry] r2=0 & r2retry_t2l1 < r2_maxRetry_t2l1 -> p_r2_t2l1 : (r2'=r2+1) + (1-p_r2_t2l1) : (r2'=r2) & (r2retry_t2l1' = r2retry_t2l1+1);
  [r2dot2l1] r2=0 & r2retry_t2l1 >= r2_maxRetry_t2l1 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..6];
  worker1retry_t3l4 : [0..worker1_maxRetry_t3l4] init 0;
  worker1retry_t3l7 : [0..worker1_maxRetry_t3l7] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot3l4Retry] worker1=1 & worker1retry_t3l4 < worker1_maxRetry_t3l4 -> p_worker1_t3l4 : (worker1'=worker1+1) + (1-p_worker1_t3l4) : (worker1'=worker1) & (worker1retry_t3l4' = worker1retry_t3l4+1);
  [worker1dot3l4] worker1=1 & worker1retry_t3l4 >= worker1_maxRetry_t3l4 -> 1:(worker1'=worker1Fail);
  [worker1movel7] worker1=2-> 1:(worker1'=2+1);
  [worker1dot3l7Retry] worker1=3 & worker1retry_t3l7 < worker1_maxRetry_t3l7 -> p_worker1_t3l7 : (worker1'=worker1+1) + (1-p_worker1_t3l7) : (worker1'=worker1) & (worker1retry_t3l7' = worker1retry_t3l7+1);
  [worker1dot3l7] worker1=3 & worker1retry_t3l7 >= worker1_maxRetry_t3l7 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..7];
  worker2retry_t3l2 : [0..worker2_maxRetry_t3l2] init 0;
  worker2retry_t1l5b : [0..worker2_maxRetry_t1l5b] init 0;
  worker2retry_t1l5a : [0..worker2_maxRetry_t1l5a] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot3l2Retry] worker2=1 & worker2retry_t3l2 < worker2_maxRetry_t3l2 -> p_worker2_t3l2 : (worker2'=worker2+1) + (1-p_worker2_t3l2) : (worker2'=worker2) & (worker2retry_t3l2' = worker2retry_t3l2+1);
  [worker2dot3l2] worker2=1 & worker2retry_t3l2 >= worker2_maxRetry_t3l2 -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=2-> 1:(worker2'=2+1);
  [worker2dot1l5bRetry] worker2=3 & worker2retry_t1l5b < worker2_maxRetry_t1l5b -> p_worker2_t1l5b : (worker2'=worker2+1) + (1-p_worker2_t1l5b) : (worker2'=worker2) & (worker2retry_t1l5b' = worker2retry_t1l5b+1);
  [worker2dot1l5b] worker2=3 & worker2retry_t1l5b >= worker2_maxRetry_t1l5b -> 1:(worker2'=worker2Fail);
  [worker2dot1l5aRetry] worker2=4 & worker2retry_t1l5a < worker2_maxRetry_t1l5a -> p_worker2_t1l5a : (worker2'=worker2+1) + (1-p_worker2_t1l5a) : (worker2'=worker2) & (worker2retry_t1l5a' = worker2retry_t1l5a+1);
  [worker2dot1l5a] worker2=4 & worker2retry_t1l5a >= worker2_maxRetry_t1l5a -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..13];
  r1retry_t3l3 : [0..r1_maxRetry_t3l3] init 0;
  r1retry_t3l6 : [0..r1_maxRetry_t3l6] init 0;
  r1retry_t2l5 : [0..r1_maxRetry_t2l5] init 0;
  r1retry_t2l8 : [0..r1_maxRetry_t2l8] init 0;
  r1retry_t2l9 : [0..r1_maxRetry_t2l9] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1movel3] r1=1-> 1:(r1'=1+1);
  [r1dot3l3Retry] r1=2 & r1retry_t3l3 < r1_maxRetry_t3l3 -> p_r1_t3l3 : (r1'=r1+1) + (1-p_r1_t3l3) : (r1'=r1) & (r1retry_t3l3' = r1retry_t3l3+1);
  [r1dot3l3] r1=2 & r1retry_t3l3 >= r1_maxRetry_t3l3 -> 1:(r1'=r1Fail);
  [r1movel6] r1=3-> 1:(r1'=3+1);
  [r1dot3l6Retry] r1=4 & r1retry_t3l6 < r1_maxRetry_t3l6 -> p_r1_t3l6 : (r1'=r1+1) + (1-p_r1_t3l6) : (r1'=r1) & (r1retry_t3l6' = r1retry_t3l6+1);
  [r1dot3l6] r1=4 & r1retry_t3l6 >= r1_maxRetry_t3l6 -> 1:(r1'=r1Fail);
  [r1movel5] r1=5-> 1:(r1'=5+1);
  [r1dot2l5Retry] r1=6 & r1retry_t2l5 < r1_maxRetry_t2l5 -> p_r1_t2l5 : (r1'=r1+1) + (1-p_r1_t2l5) : (r1'=r1) & (r1retry_t2l5' = r1retry_t2l5+1);
  [r1dot2l5] r1=6 & r1retry_t2l5 >= r1_maxRetry_t2l5 -> 1:(r1'=r1Fail);
  [r1movel8] r1=7-> 1:(r1'=7+1);
  [r1dot2l8Retry] r1=8 & r1retry_t2l8 < r1_maxRetry_t2l8 -> p_r1_t2l8 : (r1'=r1+1) + (1-p_r1_t2l8) : (r1'=r1) & (r1retry_t2l8' = r1retry_t2l8+1);
  [r1dot2l8] r1=8 & r1retry_t2l8 >= r1_maxRetry_t2l8 -> 1:(r1'=r1Fail);
  [r1movel9] r1=9-> 1:(r1'=9+1);
  [r1dot2l9Retry] r1=10 & r1retry_t2l9 < r1_maxRetry_t2l9 -> p_r1_t2l9 : (r1'=r1+1) + (1-p_r1_t2l9) : (r1'=r1) & (r1retry_t2l9' = r1retry_t2l9+1);
  [r1dot2l9] r1=10 & r1retry_t2l9 >= r1_maxRetry_t2l9 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [r2dot2l1] true:1;
  [r2dot2l1Retry] true:1;
  [worker1movel4] true:1;
  [worker1dot3l4] true:5;
  [worker1dot3l4Retry] true:5;
  [worker1movel7] true:1;
  [worker1dot3l7] true:5;
  [worker1dot3l7Retry] true:5;
  [worker2movel2] true:1;
  [worker2dot3l2] true:5;
  [worker2dot3l2Retry] true:5;
  [worker2movel5] true:1;
  [worker2dot1l5b] true:3;
  [worker2dot1l5bRetry] true:3;
  [worker2dot1l5a] true:3;
  [worker2dot1l5aRetry] true:3;
  [r1movel2] true:1;
  [r1movel3] true:1;
  [r1dot3l3] true:1;
  [r1dot3l3Retry] true:1;
  [r1movel6] true:1;
  [r1dot3l6] true:1;
  [r1dot3l6Retry] true:1;
  [r1movel5] true:1;
  [r1dot2l5] true:1;
  [r1dot2l5Retry] true:1;
  [r1movel8] true:1;
  [r1dot2l8] true:1;
  [r1dot2l8Retry] true:1;
  [r1movel9] true:1;
  [r1dot2l9] true:1;
  [r1dot2l9Retry] true:1;
endrewards