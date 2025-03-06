dtmc
evolve int r1_maxRetry_t3l4 [1..10];
evolve int r1_maxRetry_t2l5 [1..10];
evolve int r2_maxRetry_t2l3b [1..10];
evolve int r2_maxRetry_t2l3a [1..10];
evolve int worker1_maxRetry_t1l1 [1..5];
evolve int worker2_maxRetry_t3l2 [1..5];
evolve int worker2_maxRetry_t1l3b [1..5];
evolve int worker2_maxRetry_t1l3a [1..5];
evolve int worker2_maxRetry_t3l6 [1..5];
evolve int worker2_maxRetry_t1l9b [1..5];
evolve int worker2_maxRetry_t1l9a [1..5];
evolve int worker2_maxRetry_t1l8 [1..5];

const double p_r1_t3l4=0.97;
const double p_r1_t2l5=0.99;
const double p_r2_t2l3b=0.99;
const double p_r2_t2l3a=0.99;
const double p_worker1_t1l1=1.0;
const double p_worker2_t3l2=0.99;
const double p_worker2_t1l3b=1.0;
const double p_worker2_t1l3a=1.0;
const double p_worker2_t3l6=0.99;
const double p_worker2_t1l9b=1.0;
const double p_worker2_t1l9a=1.0;
const double p_worker2_t1l8=1.0;
const int r1Final = 4;
const int r1Fail = 5;
const int r2Final = 4;
const int r2Fail = 5;
const int worker1Final = 1;
const int worker1Fail = 2;
const int worker2Final = 12;
const int worker2Fail = 13;

module _r1
  r1 : [0..6];
  r1retry_t3l4 : [0..r1_maxRetry_t3l4] init 0;
  r1retry_t2l5 : [0..r1_maxRetry_t2l5] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1dot3l4Retry] r1=1 & r1retry_t3l4 < r1_maxRetry_t3l4 -> p_r1_t3l4 : (r1'=r1+1) + (1-p_r1_t3l4) : (r1'=r1) & (r1retry_t3l4' = r1retry_t3l4+1);
  [r1dot3l4] r1=1 & r1retry_t3l4 >= r1_maxRetry_t3l4 -> 1:(r1'=r1Fail);
  [r1movel5] r1=2-> 1:(r1'=2+1);
  [r1dot2l5Retry] r1=3 & r1retry_t2l5 < r1_maxRetry_t2l5 -> p_r1_t2l5 : (r1'=r1+1) + (1-p_r1_t2l5) : (r1'=r1) & (r1retry_t2l5' = r1retry_t2l5+1);
  [r1dot2l5] r1=3 & r1retry_t2l5 >= r1_maxRetry_t2l5 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..6];
  r2retry_t2l3b : [0..r2_maxRetry_t2l3b] init 0;
  r2retry_t2l3a : [0..r2_maxRetry_t2l3a] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2movel3] r2=1-> 1:(r2'=1+1);
  [r2dot2l3bRetry] r2=2 & r2retry_t2l3b < r2_maxRetry_t2l3b -> p_r2_t2l3b : (r2'=r2+1) + (1-p_r2_t2l3b) : (r2'=r2) & (r2retry_t2l3b' = r2retry_t2l3b+1);
  [r2dot2l3b] r2=2 & r2retry_t2l3b >= r2_maxRetry_t2l3b -> 1:(r2'=r2Fail);
  [r2dot2l3aRetry] r2=3 & r2retry_t2l3a < r2_maxRetry_t2l3a -> p_r2_t2l3a : (r2'=r2+1) + (1-p_r2_t2l3a) : (r2'=r2) & (r2retry_t2l3a' = r2retry_t2l3a+1);
  [r2dot2l3a] r2=3 & r2retry_t2l3a >= r2_maxRetry_t2l3a -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..3];
  worker1retry_t1l1 : [0..worker1_maxRetry_t1l1] init 0;

  [worker1dot1l1Retry] worker1=0 & worker1retry_t1l1 < worker1_maxRetry_t1l1 -> p_worker1_t1l1 : (worker1'=worker1+1) + (1-p_worker1_t1l1) : (worker1'=worker1) & (worker1retry_t1l1' = worker1retry_t1l1+1);
  [worker1dot1l1] worker1=0 & worker1retry_t1l1 >= worker1_maxRetry_t1l1 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..14];
  worker2retry_t3l2 : [0..worker2_maxRetry_t3l2] init 0;
  worker2retry_t1l3b : [0..worker2_maxRetry_t1l3b] init 0;
  worker2retry_t1l3a : [0..worker2_maxRetry_t1l3a] init 0;
  worker2retry_t3l6 : [0..worker2_maxRetry_t3l6] init 0;
  worker2retry_t1l9b : [0..worker2_maxRetry_t1l9b] init 0;
  worker2retry_t1l9a : [0..worker2_maxRetry_t1l9a] init 0;
  worker2retry_t1l8 : [0..worker2_maxRetry_t1l8] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot3l2Retry] worker2=1 & worker2retry_t3l2 < worker2_maxRetry_t3l2 -> p_worker2_t3l2 : (worker2'=worker2+1) + (1-p_worker2_t3l2) : (worker2'=worker2) & (worker2retry_t3l2' = worker2retry_t3l2+1);
  [worker2dot3l2] worker2=1 & worker2retry_t3l2 >= worker2_maxRetry_t3l2 -> 1:(worker2'=worker2Fail);
  [worker2movel3] worker2=2-> 1:(worker2'=2+1);
  [worker2dot1l3bRetry] worker2=3 & worker2retry_t1l3b < worker2_maxRetry_t1l3b -> p_worker2_t1l3b : (worker2'=worker2+1) + (1-p_worker2_t1l3b) : (worker2'=worker2) & (worker2retry_t1l3b' = worker2retry_t1l3b+1);
  [worker2dot1l3b] worker2=3 & worker2retry_t1l3b >= worker2_maxRetry_t1l3b -> 1:(worker2'=worker2Fail);
  [worker2dot1l3aRetry] worker2=4 & worker2retry_t1l3a < worker2_maxRetry_t1l3a -> p_worker2_t1l3a : (worker2'=worker2+1) + (1-p_worker2_t1l3a) : (worker2'=worker2) & (worker2retry_t1l3a' = worker2retry_t1l3a+1);
  [worker2dot1l3a] worker2=4 & worker2retry_t1l3a >= worker2_maxRetry_t1l3a -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=5-> 1:(worker2'=5+1);
  [worker2dot3l6Retry] worker2=6 & worker2retry_t3l6 < worker2_maxRetry_t3l6 -> p_worker2_t3l6 : (worker2'=worker2+1) + (1-p_worker2_t3l6) : (worker2'=worker2) & (worker2retry_t3l6' = worker2retry_t3l6+1);
  [worker2dot3l6] worker2=6 & worker2retry_t3l6 >= worker2_maxRetry_t3l6 -> 1:(worker2'=worker2Fail);
  [worker2movel9] worker2=7-> 1:(worker2'=7+1);
  [worker2dot1l9bRetry] worker2=8 & worker2retry_t1l9b < worker2_maxRetry_t1l9b -> p_worker2_t1l9b : (worker2'=worker2+1) + (1-p_worker2_t1l9b) : (worker2'=worker2) & (worker2retry_t1l9b' = worker2retry_t1l9b+1);
  [worker2dot1l9b] worker2=8 & worker2retry_t1l9b >= worker2_maxRetry_t1l9b -> 1:(worker2'=worker2Fail);
  [worker2dot1l9aRetry] worker2=9 & worker2retry_t1l9a < worker2_maxRetry_t1l9a -> p_worker2_t1l9a : (worker2'=worker2+1) + (1-p_worker2_t1l9a) : (worker2'=worker2) & (worker2retry_t1l9a' = worker2retry_t1l9a+1);
  [worker2dot1l9a] worker2=9 & worker2retry_t1l9a >= worker2_maxRetry_t1l9a -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=10-> 1:(worker2'=10+1);
  [worker2dot1l8Retry] worker2=11 & worker2retry_t1l8 < worker2_maxRetry_t1l8 -> p_worker2_t1l8 : (worker2'=worker2+1) + (1-p_worker2_t1l8) : (worker2'=worker2) & (worker2retry_t1l8' = worker2retry_t1l8+1);
  [worker2dot1l8] worker2=11 & worker2retry_t1l8 >= worker2_maxRetry_t1l8 -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r1movel4] true:1;
  [r1dot3l4] true:1;
  [r1dot3l4Retry] true:1;
  [r1movel5] true:1;
  [r1dot2l5] true:1;
  [r1dot2l5Retry] true:1;
  [r2movel2] true:1;
  [r2movel3] true:1;
  [r2dot2l3b] true:1;
  [r2dot2l3bRetry] true:1;
  [r2dot2l3a] true:1;
  [r2dot2l3aRetry] true:1;
  [worker1dot1l1] true:3;
  [worker1dot1l1Retry] true:3;
  [worker2movel2] true:1;
  [worker2dot3l2] true:5;
  [worker2dot3l2Retry] true:5;
  [worker2movel3] true:1;
  [worker2dot1l3b] true:3;
  [worker2dot1l3bRetry] true:3;
  [worker2dot1l3a] true:3;
  [worker2dot1l3aRetry] true:3;
  [worker2movel6] true:1;
  [worker2dot3l6] true:5;
  [worker2dot3l6Retry] true:5;
  [worker2movel9] true:1;
  [worker2dot1l9b] true:3;
  [worker2dot1l9bRetry] true:3;
  [worker2dot1l9a] true:3;
  [worker2dot1l9aRetry] true:3;
  [worker2movel8] true:1;
  [worker2dot1l8] true:3;
  [worker2dot1l8Retry] true:3;
endrewards