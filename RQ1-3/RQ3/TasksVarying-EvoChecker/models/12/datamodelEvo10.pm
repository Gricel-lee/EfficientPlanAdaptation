dtmc
evolve int r1_maxRetry_t2l2 [1..10];
evolve int r1_maxRetry_t2l8 [1..10];
evolve int worker1_maxRetry_t1l1 [1..5];
evolve int worker2_maxRetry_t3l4 [1..5];
evolve int worker2_maxRetry_t1l4 [1..5];
evolve int worker2_maxRetry_t3l7b [1..5];
evolve int worker2_maxRetry_t3l7a [1..5];
evolve int worker2_maxRetry_t1l8 [1..5];
evolve int worker2_maxRetry_t1l9b [1..5];
evolve int worker2_maxRetry_t1l9a [1..5];
evolve int worker2_maxRetry_t3l6 [1..5];
evolve int worker2_maxRetry_t1l3 [1..5];

const double p_r1_t2l2=0.99;
const double p_r1_t2l8=0.99;
const double p_worker1_t1l1=1.0;
const double p_worker2_t3l4=0.99;
const double p_worker2_t1l4=1.0;
const double p_worker2_t3l7b=0.99;
const double p_worker2_t3l7a=0.99;
const double p_worker2_t1l8=1.0;
const double p_worker2_t1l9b=1.0;
const double p_worker2_t1l9a=1.0;
const double p_worker2_t3l6=0.99;
const double p_worker2_t1l3=1.0;
const int r1Final = 5;
const int r1Fail = 6;
const int worker1Final = 1;
const int worker1Fail = 2;
const int worker2Final = 15;
const int worker2Fail = 16;

module _r1
  r1 : [0..7];
  r1retry_t2l2 : [0..r1_maxRetry_t2l2] init 0;
  r1retry_t2l8 : [0..r1_maxRetry_t2l8] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1dot2l2Retry] r1=1 & r1retry_t2l2 < r1_maxRetry_t2l2 -> p_r1_t2l2 : (r1'=r1+1) + (1-p_r1_t2l2) : (r1'=r1) & (r1retry_t2l2' = r1retry_t2l2+1);
  [r1dot2l2] r1=1 & r1retry_t2l2 >= r1_maxRetry_t2l2 -> 1:(r1'=r1Fail);
  [r1movel5] r1=2-> 1:(r1'=2+1);
  [r1movel8] r1=3-> 1:(r1'=3+1);
  [r1dot2l8Retry] r1=4 & r1retry_t2l8 < r1_maxRetry_t2l8 -> p_r1_t2l8 : (r1'=r1+1) + (1-p_r1_t2l8) : (r1'=r1) & (r1retry_t2l8' = r1retry_t2l8+1);
  [r1dot2l8] r1=4 & r1retry_t2l8 >= r1_maxRetry_t2l8 -> 1:(r1'=r1Fail);
endmodule

module _worker1
  worker1 : [0..3];
  worker1retry_t1l1 : [0..worker1_maxRetry_t1l1] init 0;

  [worker1dot1l1Retry] worker1=0 & worker1retry_t1l1 < worker1_maxRetry_t1l1 -> p_worker1_t1l1 : (worker1'=worker1+1) + (1-p_worker1_t1l1) : (worker1'=worker1) & (worker1retry_t1l1' = worker1retry_t1l1+1);
  [worker1dot1l1] worker1=0 & worker1retry_t1l1 >= worker1_maxRetry_t1l1 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..17];
  worker2retry_t3l4 : [0..worker2_maxRetry_t3l4] init 0;
  worker2retry_t1l4 : [0..worker2_maxRetry_t1l4] init 0;
  worker2retry_t3l7b : [0..worker2_maxRetry_t3l7b] init 0;
  worker2retry_t3l7a : [0..worker2_maxRetry_t3l7a] init 0;
  worker2retry_t1l8 : [0..worker2_maxRetry_t1l8] init 0;
  worker2retry_t1l9b : [0..worker2_maxRetry_t1l9b] init 0;
  worker2retry_t1l9a : [0..worker2_maxRetry_t1l9a] init 0;
  worker2retry_t3l6 : [0..worker2_maxRetry_t3l6] init 0;
  worker2retry_t1l3 : [0..worker2_maxRetry_t1l3] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2dot3l4Retry] worker2=1 & worker2retry_t3l4 < worker2_maxRetry_t3l4 -> p_worker2_t3l4 : (worker2'=worker2+1) + (1-p_worker2_t3l4) : (worker2'=worker2) & (worker2retry_t3l4' = worker2retry_t3l4+1);
  [worker2dot3l4] worker2=1 & worker2retry_t3l4 >= worker2_maxRetry_t3l4 -> 1:(worker2'=worker2Fail);
  [worker2dot1l4Retry] worker2=2 & worker2retry_t1l4 < worker2_maxRetry_t1l4 -> p_worker2_t1l4 : (worker2'=worker2+1) + (1-p_worker2_t1l4) : (worker2'=worker2) & (worker2retry_t1l4' = worker2retry_t1l4+1);
  [worker2dot1l4] worker2=2 & worker2retry_t1l4 >= worker2_maxRetry_t1l4 -> 1:(worker2'=worker2Fail);
  [worker2movel7] worker2=3-> 1:(worker2'=3+1);
  [worker2dot3l7bRetry] worker2=4 & worker2retry_t3l7b < worker2_maxRetry_t3l7b -> p_worker2_t3l7b : (worker2'=worker2+1) + (1-p_worker2_t3l7b) : (worker2'=worker2) & (worker2retry_t3l7b' = worker2retry_t3l7b+1);
  [worker2dot3l7b] worker2=4 & worker2retry_t3l7b >= worker2_maxRetry_t3l7b -> 1:(worker2'=worker2Fail);
  [worker2dot3l7aRetry] worker2=5 & worker2retry_t3l7a < worker2_maxRetry_t3l7a -> p_worker2_t3l7a : (worker2'=worker2+1) + (1-p_worker2_t3l7a) : (worker2'=worker2) & (worker2retry_t3l7a' = worker2retry_t3l7a+1);
  [worker2dot3l7a] worker2=5 & worker2retry_t3l7a >= worker2_maxRetry_t3l7a -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=6-> 1:(worker2'=6+1);
  [worker2dot1l8Retry] worker2=7 & worker2retry_t1l8 < worker2_maxRetry_t1l8 -> p_worker2_t1l8 : (worker2'=worker2+1) + (1-p_worker2_t1l8) : (worker2'=worker2) & (worker2retry_t1l8' = worker2retry_t1l8+1);
  [worker2dot1l8] worker2=7 & worker2retry_t1l8 >= worker2_maxRetry_t1l8 -> 1:(worker2'=worker2Fail);
  [worker2movel9] worker2=8-> 1:(worker2'=8+1);
  [worker2dot1l9bRetry] worker2=9 & worker2retry_t1l9b < worker2_maxRetry_t1l9b -> p_worker2_t1l9b : (worker2'=worker2+1) + (1-p_worker2_t1l9b) : (worker2'=worker2) & (worker2retry_t1l9b' = worker2retry_t1l9b+1);
  [worker2dot1l9b] worker2=9 & worker2retry_t1l9b >= worker2_maxRetry_t1l9b -> 1:(worker2'=worker2Fail);
  [worker2dot1l9aRetry] worker2=10 & worker2retry_t1l9a < worker2_maxRetry_t1l9a -> p_worker2_t1l9a : (worker2'=worker2+1) + (1-p_worker2_t1l9a) : (worker2'=worker2) & (worker2retry_t1l9a' = worker2retry_t1l9a+1);
  [worker2dot1l9a] worker2=10 & worker2retry_t1l9a >= worker2_maxRetry_t1l9a -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=11-> 1:(worker2'=11+1);
  [worker2dot3l6Retry] worker2=12 & worker2retry_t3l6 < worker2_maxRetry_t3l6 -> p_worker2_t3l6 : (worker2'=worker2+1) + (1-p_worker2_t3l6) : (worker2'=worker2) & (worker2retry_t3l6' = worker2retry_t3l6+1);
  [worker2dot3l6] worker2=12 & worker2retry_t3l6 >= worker2_maxRetry_t3l6 -> 1:(worker2'=worker2Fail);
  [worker2movel3] worker2=13-> 1:(worker2'=13+1);
  [worker2dot1l3Retry] worker2=14 & worker2retry_t1l3 < worker2_maxRetry_t1l3 -> p_worker2_t1l3 : (worker2'=worker2+1) + (1-p_worker2_t1l3) : (worker2'=worker2) & (worker2retry_t1l3' = worker2retry_t1l3+1);
  [worker2dot1l3] worker2=14 & worker2retry_t1l3 >= worker2_maxRetry_t1l3 -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r1movel2] true:1;
  [r1dot2l2] true:1;
  [r1dot2l2Retry] true:1;
  [r1movel5] true:1;
  [r1movel8] true:1;
  [r1dot2l8] true:1;
  [r1dot2l8Retry] true:1;
  [worker1dot1l1] true:3;
  [worker1dot1l1Retry] true:3;
  [worker2movel4] true:1;
  [worker2dot3l4] true:5;
  [worker2dot3l4Retry] true:5;
  [worker2dot1l4] true:3;
  [worker2dot1l4Retry] true:3;
  [worker2movel7] true:1;
  [worker2dot3l7b] true:5;
  [worker2dot3l7bRetry] true:5;
  [worker2dot3l7a] true:5;
  [worker2dot3l7aRetry] true:5;
  [worker2movel8] true:1;
  [worker2dot1l8] true:3;
  [worker2dot1l8Retry] true:3;
  [worker2movel9] true:1;
  [worker2dot1l9b] true:3;
  [worker2dot1l9bRetry] true:3;
  [worker2dot1l9a] true:3;
  [worker2dot1l9aRetry] true:3;
  [worker2movel6] true:1;
  [worker2dot3l6] true:5;
  [worker2dot3l6Retry] true:5;
  [worker2movel3] true:1;
  [worker2dot1l3] true:3;
  [worker2dot1l3Retry] true:3;
endrewards