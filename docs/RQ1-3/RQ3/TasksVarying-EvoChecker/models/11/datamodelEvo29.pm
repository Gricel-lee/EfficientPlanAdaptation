dtmc
evolve int r2_maxRetry_t2l1 [1..10];
evolve int worker1_maxRetry_t1l2 [1..5];
evolve int worker1_maxRetry_t3l5b [1..5];
evolve int worker1_maxRetry_t3l5a [1..5];
evolve int worker1_maxRetry_t1l6 [1..5];
evolve int worker2_maxRetry_t3l4b [1..5];
evolve int worker2_maxRetry_t3l4a [1..5];
evolve int worker2_maxRetry_t3l7 [1..5];
evolve int worker2_maxRetry_t3l8 [1..5];
evolve int r1_maxRetry_t2l2 [1..10];
evolve int r1_maxRetry_t2l3 [1..10];

const double p_r2_t2l1=0.99;
const double p_worker1_t1l2=1.0;
const double p_worker1_t3l5b=0.99;
const double p_worker1_t3l5a=0.99;
const double p_worker1_t1l6=1.0;
const double p_worker2_t3l4b=0.99;
const double p_worker2_t3l4a=0.99;
const double p_worker2_t3l7=0.99;
const double p_worker2_t3l8=0.99;
const double p_r1_t2l2=0.99;
const double p_r1_t2l3=0.99;
const int r2Final = 1;
const int r2Fail = 2;
const int worker1Final = 7;
const int worker1Fail = 8;
const int worker2Final = 7;
const int worker2Fail = 8;
const int r1Final = 4;
const int r1Fail = 5;

module _r2
  r2 : [0..3];
  r2retry_t2l1 : [0..r2_maxRetry_t2l1] init 0;

  [r2dot2l1Retry] r2=0 & r2retry_t2l1 < r2_maxRetry_t2l1 -> p_r2_t2l1 : (r2'=r2+1) + (1-p_r2_t2l1) : (r2'=r2) & (r2retry_t2l1' = r2retry_t2l1+1);
  [r2dot2l1] r2=0 & r2retry_t2l1 >= r2_maxRetry_t2l1 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..9];
  worker1retry_t1l2 : [0..worker1_maxRetry_t1l2] init 0;
  worker1retry_t3l5b : [0..worker1_maxRetry_t3l5b] init 0;
  worker1retry_t3l5a : [0..worker1_maxRetry_t3l5a] init 0;
  worker1retry_t1l6 : [0..worker1_maxRetry_t1l6] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l2Retry] worker1=1 & worker1retry_t1l2 < worker1_maxRetry_t1l2 -> p_worker1_t1l2 : (worker1'=worker1+1) + (1-p_worker1_t1l2) : (worker1'=worker1) & (worker1retry_t1l2' = worker1retry_t1l2+1);
  [worker1dot1l2] worker1=1 & worker1retry_t1l2 >= worker1_maxRetry_t1l2 -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=2-> 1:(worker1'=2+1);
  [worker1dot3l5bRetry] worker1=3 & worker1retry_t3l5b < worker1_maxRetry_t3l5b -> p_worker1_t3l5b : (worker1'=worker1+1) + (1-p_worker1_t3l5b) : (worker1'=worker1) & (worker1retry_t3l5b' = worker1retry_t3l5b+1);
  [worker1dot3l5b] worker1=3 & worker1retry_t3l5b >= worker1_maxRetry_t3l5b -> 1:(worker1'=worker1Fail);
  [worker1dot3l5aRetry] worker1=4 & worker1retry_t3l5a < worker1_maxRetry_t3l5a -> p_worker1_t3l5a : (worker1'=worker1+1) + (1-p_worker1_t3l5a) : (worker1'=worker1) & (worker1retry_t3l5a' = worker1retry_t3l5a+1);
  [worker1dot3l5a] worker1=4 & worker1retry_t3l5a >= worker1_maxRetry_t3l5a -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=5-> 1:(worker1'=5+1);
  [worker1dot1l6Retry] worker1=6 & worker1retry_t1l6 < worker1_maxRetry_t1l6 -> p_worker1_t1l6 : (worker1'=worker1+1) + (1-p_worker1_t1l6) : (worker1'=worker1) & (worker1retry_t1l6' = worker1retry_t1l6+1);
  [worker1dot1l6] worker1=6 & worker1retry_t1l6 >= worker1_maxRetry_t1l6 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..9];
  worker2retry_t3l4b : [0..worker2_maxRetry_t3l4b] init 0;
  worker2retry_t3l4a : [0..worker2_maxRetry_t3l4a] init 0;
  worker2retry_t3l7 : [0..worker2_maxRetry_t3l7] init 0;
  worker2retry_t3l8 : [0..worker2_maxRetry_t3l8] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2dot3l4bRetry] worker2=1 & worker2retry_t3l4b < worker2_maxRetry_t3l4b -> p_worker2_t3l4b : (worker2'=worker2+1) + (1-p_worker2_t3l4b) : (worker2'=worker2) & (worker2retry_t3l4b' = worker2retry_t3l4b+1);
  [worker2dot3l4b] worker2=1 & worker2retry_t3l4b >= worker2_maxRetry_t3l4b -> 1:(worker2'=worker2Fail);
  [worker2dot3l4aRetry] worker2=2 & worker2retry_t3l4a < worker2_maxRetry_t3l4a -> p_worker2_t3l4a : (worker2'=worker2+1) + (1-p_worker2_t3l4a) : (worker2'=worker2) & (worker2retry_t3l4a' = worker2retry_t3l4a+1);
  [worker2dot3l4a] worker2=2 & worker2retry_t3l4a >= worker2_maxRetry_t3l4a -> 1:(worker2'=worker2Fail);
  [worker2movel7] worker2=3-> 1:(worker2'=3+1);
  [worker2dot3l7Retry] worker2=4 & worker2retry_t3l7 < worker2_maxRetry_t3l7 -> p_worker2_t3l7 : (worker2'=worker2+1) + (1-p_worker2_t3l7) : (worker2'=worker2) & (worker2retry_t3l7' = worker2retry_t3l7+1);
  [worker2dot3l7] worker2=4 & worker2retry_t3l7 >= worker2_maxRetry_t3l7 -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=5-> 1:(worker2'=5+1);
  [worker2dot3l8Retry] worker2=6 & worker2retry_t3l8 < worker2_maxRetry_t3l8 -> p_worker2_t3l8 : (worker2'=worker2+1) + (1-p_worker2_t3l8) : (worker2'=worker2) & (worker2retry_t3l8' = worker2retry_t3l8+1);
  [worker2dot3l8] worker2=6 & worker2retry_t3l8 >= worker2_maxRetry_t3l8 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..6];
  r1retry_t2l2 : [0..r1_maxRetry_t2l2] init 0;
  r1retry_t2l3 : [0..r1_maxRetry_t2l3] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1dot2l2Retry] r1=1 & r1retry_t2l2 < r1_maxRetry_t2l2 -> p_r1_t2l2 : (r1'=r1+1) + (1-p_r1_t2l2) : (r1'=r1) & (r1retry_t2l2' = r1retry_t2l2+1);
  [r1dot2l2] r1=1 & r1retry_t2l2 >= r1_maxRetry_t2l2 -> 1:(r1'=r1Fail);
  [r1movel3] r1=2-> 1:(r1'=2+1);
  [r1dot2l3Retry] r1=3 & r1retry_t2l3 < r1_maxRetry_t2l3 -> p_r1_t2l3 : (r1'=r1+1) + (1-p_r1_t2l3) : (r1'=r1) & (r1retry_t2l3' = r1retry_t2l3+1);
  [r1dot2l3] r1=3 & r1retry_t2l3 >= r1_maxRetry_t2l3 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [r2dot2l1] true:1;
  [r2dot2l1Retry] true:1;
  [worker1movel2] true:1;
  [worker1dot1l2] true:3;
  [worker1dot1l2Retry] true:3;
  [worker1movel5] true:1;
  [worker1dot3l5b] true:5;
  [worker1dot3l5bRetry] true:5;
  [worker1dot3l5a] true:5;
  [worker1dot3l5aRetry] true:5;
  [worker1movel6] true:1;
  [worker1dot1l6] true:3;
  [worker1dot1l6Retry] true:3;
  [worker2movel4] true:1;
  [worker2dot3l4b] true:5;
  [worker2dot3l4bRetry] true:5;
  [worker2dot3l4a] true:5;
  [worker2dot3l4aRetry] true:5;
  [worker2movel7] true:1;
  [worker2dot3l7] true:5;
  [worker2dot3l7Retry] true:5;
  [worker2movel8] true:1;
  [worker2dot3l8] true:5;
  [worker2dot3l8Retry] true:5;
  [r1movel2] true:1;
  [r1dot2l2] true:1;
  [r1dot2l2Retry] true:1;
  [r1movel3] true:1;
  [r1dot2l3] true:1;
  [r1dot2l3Retry] true:1;
endrewards