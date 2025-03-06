dtmc
evolve int r2_maxRetry_t2l3b [1..10];
evolve int r2_maxRetry_t2l3a [1..10];
evolve int r2_maxRetry_t2l9 [1..10];
evolve int r2_maxRetry_t3l7b [1..10];
evolve int r2_maxRetry_t3l7a [1..10];
evolve int worker1_maxRetry_t1l2 [1..5];
evolve int worker1_maxRetry_t1l5 [1..5];
evolve int worker1_maxRetry_t3l8 [1..5];
evolve int worker1_maxRetry_t1l9 [1..5];
evolve int worker2_maxRetry_t3l1 [1..5];
evolve int worker2_maxRetry_t1l4 [1..5];

const double p_r2_t2l3b=0.99;
const double p_r2_t2l3a=0.99;
const double p_r2_t2l9=0.99;
const double p_r2_t3l7b=0.97;
const double p_r2_t3l7a=0.97;
const double p_worker1_t1l2=1.0;
const double p_worker1_t1l5=1.0;
const double p_worker1_t3l8=0.99;
const double p_worker1_t1l9=1.0;
const double p_worker2_t3l1=0.99;
const double p_worker2_t1l4=1.0;
const int r2Final = 11;
const int r2Fail = 12;
const int worker1Final = 8;
const int worker1Fail = 9;
const int worker2Final = 3;
const int worker2Fail = 4;

module _r2
  r2 : [0..13];
  r2retry_t2l3b : [0..r2_maxRetry_t2l3b] init 0;
  r2retry_t2l3a : [0..r2_maxRetry_t2l3a] init 0;
  r2retry_t2l9 : [0..r2_maxRetry_t2l9] init 0;
  r2retry_t3l7b : [0..r2_maxRetry_t3l7b] init 0;
  r2retry_t3l7a : [0..r2_maxRetry_t3l7a] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2movel3] r2=1-> 1:(r2'=1+1);
  [r2dot2l3bRetry] r2=2 & r2retry_t2l3b < r2_maxRetry_t2l3b -> p_r2_t2l3b : (r2'=r2+1) + (1-p_r2_t2l3b) : (r2'=r2) & (r2retry_t2l3b' = r2retry_t2l3b+1);
  [r2dot2l3b] r2=2 & r2retry_t2l3b >= r2_maxRetry_t2l3b -> 1:(r2'=r2Fail);
  [r2dot2l3aRetry] r2=3 & r2retry_t2l3a < r2_maxRetry_t2l3a -> p_r2_t2l3a : (r2'=r2+1) + (1-p_r2_t2l3a) : (r2'=r2) & (r2retry_t2l3a' = r2retry_t2l3a+1);
  [r2dot2l3a] r2=3 & r2retry_t2l3a >= r2_maxRetry_t2l3a -> 1:(r2'=r2Fail);
  [r2movel6] r2=4-> 1:(r2'=4+1);
  [r2movel9] r2=5-> 1:(r2'=5+1);
  [r2dot2l9Retry] r2=6 & r2retry_t2l9 < r2_maxRetry_t2l9 -> p_r2_t2l9 : (r2'=r2+1) + (1-p_r2_t2l9) : (r2'=r2) & (r2retry_t2l9' = r2retry_t2l9+1);
  [r2dot2l9] r2=6 & r2retry_t2l9 >= r2_maxRetry_t2l9 -> 1:(r2'=r2Fail);
  [r2movel8] r2=7-> 1:(r2'=7+1);
  [r2movel7] r2=8-> 1:(r2'=8+1);
  [r2dot3l7bRetry] r2=9 & r2retry_t3l7b < r2_maxRetry_t3l7b -> p_r2_t3l7b : (r2'=r2+1) + (1-p_r2_t3l7b) : (r2'=r2) & (r2retry_t3l7b' = r2retry_t3l7b+1);
  [r2dot3l7b] r2=9 & r2retry_t3l7b >= r2_maxRetry_t3l7b -> 1:(r2'=r2Fail);
  [r2dot3l7aRetry] r2=10 & r2retry_t3l7a < r2_maxRetry_t3l7a -> p_r2_t3l7a : (r2'=r2+1) + (1-p_r2_t3l7a) : (r2'=r2) & (r2retry_t3l7a' = r2retry_t3l7a+1);
  [r2dot3l7a] r2=10 & r2retry_t3l7a >= r2_maxRetry_t3l7a -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..10];
  worker1retry_t1l2 : [0..worker1_maxRetry_t1l2] init 0;
  worker1retry_t1l5 : [0..worker1_maxRetry_t1l5] init 0;
  worker1retry_t3l8 : [0..worker1_maxRetry_t3l8] init 0;
  worker1retry_t1l9 : [0..worker1_maxRetry_t1l9] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l2Retry] worker1=1 & worker1retry_t1l2 < worker1_maxRetry_t1l2 -> p_worker1_t1l2 : (worker1'=worker1+1) + (1-p_worker1_t1l2) : (worker1'=worker1) & (worker1retry_t1l2' = worker1retry_t1l2+1);
  [worker1dot1l2] worker1=1 & worker1retry_t1l2 >= worker1_maxRetry_t1l2 -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=2-> 1:(worker1'=2+1);
  [worker1dot1l5Retry] worker1=3 & worker1retry_t1l5 < worker1_maxRetry_t1l5 -> p_worker1_t1l5 : (worker1'=worker1+1) + (1-p_worker1_t1l5) : (worker1'=worker1) & (worker1retry_t1l5' = worker1retry_t1l5+1);
  [worker1dot1l5] worker1=3 & worker1retry_t1l5 >= worker1_maxRetry_t1l5 -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=4-> 1:(worker1'=4+1);
  [worker1dot3l8Retry] worker1=5 & worker1retry_t3l8 < worker1_maxRetry_t3l8 -> p_worker1_t3l8 : (worker1'=worker1+1) + (1-p_worker1_t3l8) : (worker1'=worker1) & (worker1retry_t3l8' = worker1retry_t3l8+1);
  [worker1dot3l8] worker1=5 & worker1retry_t3l8 >= worker1_maxRetry_t3l8 -> 1:(worker1'=worker1Fail);
  [worker1movel9] worker1=6-> 1:(worker1'=6+1);
  [worker1dot1l9Retry] worker1=7 & worker1retry_t1l9 < worker1_maxRetry_t1l9 -> p_worker1_t1l9 : (worker1'=worker1+1) + (1-p_worker1_t1l9) : (worker1'=worker1) & (worker1retry_t1l9' = worker1retry_t1l9+1);
  [worker1dot1l9] worker1=7 & worker1retry_t1l9 >= worker1_maxRetry_t1l9 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..5];
  worker2retry_t3l1 : [0..worker2_maxRetry_t3l1] init 0;
  worker2retry_t1l4 : [0..worker2_maxRetry_t1l4] init 0;

  [worker2dot3l1Retry] worker2=0 & worker2retry_t3l1 < worker2_maxRetry_t3l1 -> p_worker2_t3l1 : (worker2'=worker2+1) + (1-p_worker2_t3l1) : (worker2'=worker2) & (worker2retry_t3l1' = worker2retry_t3l1+1);
  [worker2dot3l1] worker2=0 & worker2retry_t3l1 >= worker2_maxRetry_t3l1 -> 1:(worker2'=worker2Fail);
  [worker2movel4] worker2=1-> 1:(worker2'=1+1);
  [worker2dot1l4Retry] worker2=2 & worker2retry_t1l4 < worker2_maxRetry_t1l4 -> p_worker2_t1l4 : (worker2'=worker2+1) + (1-p_worker2_t1l4) : (worker2'=worker2) & (worker2retry_t1l4' = worker2retry_t1l4+1);
  [worker2dot1l4] worker2=2 & worker2retry_t1l4 >= worker2_maxRetry_t1l4 -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r2movel2] true:1;
  [r2movel3] true:1;
  [r2dot2l3b] true:1;
  [r2dot2l3bRetry] true:1;
  [r2dot2l3a] true:1;
  [r2dot2l3aRetry] true:1;
  [r2movel6] true:1;
  [r2movel9] true:1;
  [r2dot2l9] true:1;
  [r2dot2l9Retry] true:1;
  [r2movel8] true:1;
  [r2movel7] true:1;
  [r2dot3l7b] true:1;
  [r2dot3l7bRetry] true:1;
  [r2dot3l7a] true:1;
  [r2dot3l7aRetry] true:1;
  [worker1movel2] true:1;
  [worker1dot1l2] true:3;
  [worker1dot1l2Retry] true:3;
  [worker1movel5] true:1;
  [worker1dot1l5] true:3;
  [worker1dot1l5Retry] true:3;
  [worker1movel8] true:1;
  [worker1dot3l8] true:5;
  [worker1dot3l8Retry] true:5;
  [worker1movel9] true:1;
  [worker1dot1l9] true:3;
  [worker1dot1l9Retry] true:3;
  [worker2dot3l1] true:5;
  [worker2dot3l1Retry] true:5;
  [worker2movel4] true:1;
  [worker2dot1l4] true:3;
  [worker2dot1l4Retry] true:3;
endrewards