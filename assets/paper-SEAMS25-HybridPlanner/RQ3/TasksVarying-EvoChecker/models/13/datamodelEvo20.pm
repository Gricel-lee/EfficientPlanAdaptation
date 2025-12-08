dtmc
evolve int worker2_maxRetry_t3l2b [1..5];
evolve int worker2_maxRetry_t1l2 [1..5];
evolve int worker2_maxRetry_t3l2a [1..5];
evolve int worker2_maxRetry_t1l3b [1..5];
evolve int worker2_maxRetry_t1l3a [1..5];
evolve int worker2_maxRetry_t3l3 [1..5];
evolve int r1_maxRetry_t3l5 [1..10];
evolve int r1_maxRetry_t2l5 [1..10];
evolve int r1_maxRetry_t2l8 [1..10];
evolve int r1_maxRetry_t2l9 [1..10];
evolve int r1_maxRetry_t3l6a [1..10];
evolve int r1_maxRetry_t3l6b [1..10];
evolve int worker1_maxRetry_t1l4 [1..5];

const double p_worker2_t3l2b=0.99;
const double p_worker2_t1l2=1.0;
const double p_worker2_t3l2a=0.99;
const double p_worker2_t1l3b=1.0;
const double p_worker2_t1l3a=1.0;
const double p_worker2_t3l3=0.99;
const double p_r1_t3l5=0.97;
const double p_r1_t2l5=0.99;
const double p_r1_t2l8=0.99;
const double p_r1_t2l9=0.99;
const double p_r1_t3l6a=0.97;
const double p_r1_t3l6b=0.97;
const double p_worker1_t1l4=1.0;
const int worker2Final = 8;
const int worker2Fail = 9;
const int r1Final = 11;
const int r1Fail = 12;
const int worker1Final = 2;
const int worker1Fail = 3;

module _worker2
  worker2 : [0..10];
  worker2retry_t3l2b : [0..worker2_maxRetry_t3l2b] init 0;
  worker2retry_t1l2 : [0..worker2_maxRetry_t1l2] init 0;
  worker2retry_t3l2a : [0..worker2_maxRetry_t3l2a] init 0;
  worker2retry_t1l3b : [0..worker2_maxRetry_t1l3b] init 0;
  worker2retry_t1l3a : [0..worker2_maxRetry_t1l3a] init 0;
  worker2retry_t3l3 : [0..worker2_maxRetry_t3l3] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot3l2bRetry] worker2=1 & worker2retry_t3l2b < worker2_maxRetry_t3l2b -> p_worker2_t3l2b : (worker2'=worker2+1) + (1-p_worker2_t3l2b) : (worker2'=worker2) & (worker2retry_t3l2b' = worker2retry_t3l2b+1);
  [worker2dot3l2b] worker2=1 & worker2retry_t3l2b >= worker2_maxRetry_t3l2b -> 1:(worker2'=worker2Fail);
  [worker2dot1l2Retry] worker2=2 & worker2retry_t1l2 < worker2_maxRetry_t1l2 -> p_worker2_t1l2 : (worker2'=worker2+1) + (1-p_worker2_t1l2) : (worker2'=worker2) & (worker2retry_t1l2' = worker2retry_t1l2+1);
  [worker2dot1l2] worker2=2 & worker2retry_t1l2 >= worker2_maxRetry_t1l2 -> 1:(worker2'=worker2Fail);
  [worker2dot3l2aRetry] worker2=3 & worker2retry_t3l2a < worker2_maxRetry_t3l2a -> p_worker2_t3l2a : (worker2'=worker2+1) + (1-p_worker2_t3l2a) : (worker2'=worker2) & (worker2retry_t3l2a' = worker2retry_t3l2a+1);
  [worker2dot3l2a] worker2=3 & worker2retry_t3l2a >= worker2_maxRetry_t3l2a -> 1:(worker2'=worker2Fail);
  [worker2movel3] worker2=4-> 1:(worker2'=4+1);
  [worker2dot1l3bRetry] worker2=5 & worker2retry_t1l3b < worker2_maxRetry_t1l3b -> p_worker2_t1l3b : (worker2'=worker2+1) + (1-p_worker2_t1l3b) : (worker2'=worker2) & (worker2retry_t1l3b' = worker2retry_t1l3b+1);
  [worker2dot1l3b] worker2=5 & worker2retry_t1l3b >= worker2_maxRetry_t1l3b -> 1:(worker2'=worker2Fail);
  [worker2dot1l3aRetry] worker2=6 & worker2retry_t1l3a < worker2_maxRetry_t1l3a -> p_worker2_t1l3a : (worker2'=worker2+1) + (1-p_worker2_t1l3a) : (worker2'=worker2) & (worker2retry_t1l3a' = worker2retry_t1l3a+1);
  [worker2dot1l3a] worker2=6 & worker2retry_t1l3a >= worker2_maxRetry_t1l3a -> 1:(worker2'=worker2Fail);
  [worker2dot3l3Retry] worker2=7 & worker2retry_t3l3 < worker2_maxRetry_t3l3 -> p_worker2_t3l3 : (worker2'=worker2+1) + (1-p_worker2_t3l3) : (worker2'=worker2) & (worker2retry_t3l3' = worker2retry_t3l3+1);
  [worker2dot3l3] worker2=7 & worker2retry_t3l3 >= worker2_maxRetry_t3l3 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..13];
  r1retry_t3l5 : [0..r1_maxRetry_t3l5] init 0;
  r1retry_t2l5 : [0..r1_maxRetry_t2l5] init 0;
  r1retry_t2l8 : [0..r1_maxRetry_t2l8] init 0;
  r1retry_t2l9 : [0..r1_maxRetry_t2l9] init 0;
  r1retry_t3l6a : [0..r1_maxRetry_t3l6a] init 0;
  r1retry_t3l6b : [0..r1_maxRetry_t3l6b] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1movel5] r1=1-> 1:(r1'=1+1);
  [r1dot3l5Retry] r1=2 & r1retry_t3l5 < r1_maxRetry_t3l5 -> p_r1_t3l5 : (r1'=r1+1) + (1-p_r1_t3l5) : (r1'=r1) & (r1retry_t3l5' = r1retry_t3l5+1);
  [r1dot3l5] r1=2 & r1retry_t3l5 >= r1_maxRetry_t3l5 -> 1:(r1'=r1Fail);
  [r1dot2l5Retry] r1=3 & r1retry_t2l5 < r1_maxRetry_t2l5 -> p_r1_t2l5 : (r1'=r1+1) + (1-p_r1_t2l5) : (r1'=r1) & (r1retry_t2l5' = r1retry_t2l5+1);
  [r1dot2l5] r1=3 & r1retry_t2l5 >= r1_maxRetry_t2l5 -> 1:(r1'=r1Fail);
  [r1movel8] r1=4-> 1:(r1'=4+1);
  [r1dot2l8Retry] r1=5 & r1retry_t2l8 < r1_maxRetry_t2l8 -> p_r1_t2l8 : (r1'=r1+1) + (1-p_r1_t2l8) : (r1'=r1) & (r1retry_t2l8' = r1retry_t2l8+1);
  [r1dot2l8] r1=5 & r1retry_t2l8 >= r1_maxRetry_t2l8 -> 1:(r1'=r1Fail);
  [r1movel9] r1=6-> 1:(r1'=6+1);
  [r1dot2l9Retry] r1=7 & r1retry_t2l9 < r1_maxRetry_t2l9 -> p_r1_t2l9 : (r1'=r1+1) + (1-p_r1_t2l9) : (r1'=r1) & (r1retry_t2l9' = r1retry_t2l9+1);
  [r1dot2l9] r1=7 & r1retry_t2l9 >= r1_maxRetry_t2l9 -> 1:(r1'=r1Fail);
  [r1movel6] r1=8-> 1:(r1'=8+1);
  [r1dot3l6aRetry] r1=9 & r1retry_t3l6a < r1_maxRetry_t3l6a -> p_r1_t3l6a : (r1'=r1+1) + (1-p_r1_t3l6a) : (r1'=r1) & (r1retry_t3l6a' = r1retry_t3l6a+1);
  [r1dot3l6a] r1=9 & r1retry_t3l6a >= r1_maxRetry_t3l6a -> 1:(r1'=r1Fail);
  [r1dot3l6bRetry] r1=10 & r1retry_t3l6b < r1_maxRetry_t3l6b -> p_r1_t3l6b : (r1'=r1+1) + (1-p_r1_t3l6b) : (r1'=r1) & (r1retry_t3l6b' = r1retry_t3l6b+1);
  [r1dot3l6b] r1=10 & r1retry_t3l6b >= r1_maxRetry_t3l6b -> 1:(r1'=r1Fail);
endmodule

module _worker1
  worker1 : [0..4];
  worker1retry_t1l4 : [0..worker1_maxRetry_t1l4] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l4Retry] worker1=1 & worker1retry_t1l4 < worker1_maxRetry_t1l4 -> p_worker1_t1l4 : (worker1'=worker1+1) + (1-p_worker1_t1l4) : (worker1'=worker1) & (worker1retry_t1l4' = worker1retry_t1l4+1);
  [worker1dot1l4] worker1=1 & worker1retry_t1l4 >= worker1_maxRetry_t1l4 -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [worker2movel2] true:1;
  [worker2dot3l2b] true:5;
  [worker2dot3l2bRetry] true:5;
  [worker2dot1l2] true:3;
  [worker2dot1l2Retry] true:3;
  [worker2dot3l2a] true:5;
  [worker2dot3l2aRetry] true:5;
  [worker2movel3] true:1;
  [worker2dot1l3b] true:3;
  [worker2dot1l3bRetry] true:3;
  [worker2dot1l3a] true:3;
  [worker2dot1l3aRetry] true:3;
  [worker2dot3l3] true:5;
  [worker2dot3l3Retry] true:5;
  [r1movel4] true:1;
  [r1movel5] true:1;
  [r1dot3l5] true:1;
  [r1dot3l5Retry] true:1;
  [r1dot2l5] true:1;
  [r1dot2l5Retry] true:1;
  [r1movel8] true:1;
  [r1dot2l8] true:1;
  [r1dot2l8Retry] true:1;
  [r1movel9] true:1;
  [r1dot2l9] true:1;
  [r1dot2l9Retry] true:1;
  [r1movel6] true:1;
  [r1dot3l6a] true:1;
  [r1dot3l6aRetry] true:1;
  [r1dot3l6b] true:1;
  [r1dot3l6bRetry] true:1;
  [worker1movel4] true:1;
  [worker1dot1l4] true:3;
  [worker1dot1l4Retry] true:3;
endrewards