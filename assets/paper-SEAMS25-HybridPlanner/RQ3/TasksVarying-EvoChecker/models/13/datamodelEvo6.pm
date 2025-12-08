dtmc
evolve int worker2_maxRetry_t3l7 [1..5];
evolve int worker2_maxRetry_t1l7 [1..5];
evolve int worker2_maxRetry_t1l8a [1..5];
evolve int worker2_maxRetry_t3l8 [1..5];
evolve int worker2_maxRetry_t1l8b [1..5];
evolve int worker2_maxRetry_t1l9 [1..5];
evolve int r1_maxRetry_t2l4 [1..10];
evolve int r2_maxRetry_t3l1 [1..10];
evolve int r2_maxRetry_t2l2 [1..10];
evolve int worker1_maxRetry_t1l1 [1..5];
evolve int worker1_maxRetry_t1l2a [1..5];
evolve int worker1_maxRetry_t1l2b [1..5];
evolve int worker1_maxRetry_t3l5 [1..5];

const double p_worker2_t3l7=0.99;
const double p_worker2_t1l7=1.0;
const double p_worker2_t1l8a=1.0;
const double p_worker2_t3l8=0.99;
const double p_worker2_t1l8b=1.0;
const double p_worker2_t1l9=1.0;
const double p_r1_t2l4=0.99;
const double p_r2_t3l1=0.97;
const double p_r2_t2l2=0.99;
const double p_worker1_t1l1=1.0;
const double p_worker1_t1l2a=1.0;
const double p_worker1_t1l2b=1.0;
const double p_worker1_t3l5=0.99;
const int worker2Final = 10;
const int worker2Fail = 11;
const int r1Final = 2;
const int r1Fail = 3;
const int r2Final = 3;
const int r2Fail = 4;
const int worker1Final = 6;
const int worker1Fail = 7;

module _worker2
  worker2 : [0..12];
  worker2retry_t3l7 : [0..worker2_maxRetry_t3l7] init 0;
  worker2retry_t1l7 : [0..worker2_maxRetry_t1l7] init 0;
  worker2retry_t1l8a : [0..worker2_maxRetry_t1l8a] init 0;
  worker2retry_t3l8 : [0..worker2_maxRetry_t3l8] init 0;
  worker2retry_t1l8b : [0..worker2_maxRetry_t1l8b] init 0;
  worker2retry_t1l9 : [0..worker2_maxRetry_t1l9] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2movel7] worker2=1-> 1:(worker2'=1+1);
  [worker2dot3l7Retry] worker2=2 & worker2retry_t3l7 < worker2_maxRetry_t3l7 -> p_worker2_t3l7 : (worker2'=worker2+1) + (1-p_worker2_t3l7) : (worker2'=worker2) & (worker2retry_t3l7' = worker2retry_t3l7+1);
  [worker2dot3l7] worker2=2 & worker2retry_t3l7 >= worker2_maxRetry_t3l7 -> 1:(worker2'=worker2Fail);
  [worker2dot1l7Retry] worker2=3 & worker2retry_t1l7 < worker2_maxRetry_t1l7 -> p_worker2_t1l7 : (worker2'=worker2+1) + (1-p_worker2_t1l7) : (worker2'=worker2) & (worker2retry_t1l7' = worker2retry_t1l7+1);
  [worker2dot1l7] worker2=3 & worker2retry_t1l7 >= worker2_maxRetry_t1l7 -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=4-> 1:(worker2'=4+1);
  [worker2dot1l8aRetry] worker2=5 & worker2retry_t1l8a < worker2_maxRetry_t1l8a -> p_worker2_t1l8a : (worker2'=worker2+1) + (1-p_worker2_t1l8a) : (worker2'=worker2) & (worker2retry_t1l8a' = worker2retry_t1l8a+1);
  [worker2dot1l8a] worker2=5 & worker2retry_t1l8a >= worker2_maxRetry_t1l8a -> 1:(worker2'=worker2Fail);
  [worker2dot3l8Retry] worker2=6 & worker2retry_t3l8 < worker2_maxRetry_t3l8 -> p_worker2_t3l8 : (worker2'=worker2+1) + (1-p_worker2_t3l8) : (worker2'=worker2) & (worker2retry_t3l8' = worker2retry_t3l8+1);
  [worker2dot3l8] worker2=6 & worker2retry_t3l8 >= worker2_maxRetry_t3l8 -> 1:(worker2'=worker2Fail);
  [worker2dot1l8bRetry] worker2=7 & worker2retry_t1l8b < worker2_maxRetry_t1l8b -> p_worker2_t1l8b : (worker2'=worker2+1) + (1-p_worker2_t1l8b) : (worker2'=worker2) & (worker2retry_t1l8b' = worker2retry_t1l8b+1);
  [worker2dot1l8b] worker2=7 & worker2retry_t1l8b >= worker2_maxRetry_t1l8b -> 1:(worker2'=worker2Fail);
  [worker2movel9] worker2=8-> 1:(worker2'=8+1);
  [worker2dot1l9Retry] worker2=9 & worker2retry_t1l9 < worker2_maxRetry_t1l9 -> p_worker2_t1l9 : (worker2'=worker2+1) + (1-p_worker2_t1l9) : (worker2'=worker2) & (worker2retry_t1l9' = worker2retry_t1l9+1);
  [worker2dot1l9] worker2=9 & worker2retry_t1l9 >= worker2_maxRetry_t1l9 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..4];
  r1retry_t2l4 : [0..r1_maxRetry_t2l4] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1dot2l4Retry] r1=1 & r1retry_t2l4 < r1_maxRetry_t2l4 -> p_r1_t2l4 : (r1'=r1+1) + (1-p_r1_t2l4) : (r1'=r1) & (r1retry_t2l4' = r1retry_t2l4+1);
  [r1dot2l4] r1=1 & r1retry_t2l4 >= r1_maxRetry_t2l4 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..5];
  r2retry_t3l1 : [0..r2_maxRetry_t3l1] init 0;
  r2retry_t2l2 : [0..r2_maxRetry_t2l2] init 0;

  [r2dot3l1Retry] r2=0 & r2retry_t3l1 < r2_maxRetry_t3l1 -> p_r2_t3l1 : (r2'=r2+1) + (1-p_r2_t3l1) : (r2'=r2) & (r2retry_t3l1' = r2retry_t3l1+1);
  [r2dot3l1] r2=0 & r2retry_t3l1 >= r2_maxRetry_t3l1 -> 1:(r2'=r2Fail);
  [r2movel2] r2=1-> 1:(r2'=1+1);
  [r2dot2l2Retry] r2=2 & r2retry_t2l2 < r2_maxRetry_t2l2 -> p_r2_t2l2 : (r2'=r2+1) + (1-p_r2_t2l2) : (r2'=r2) & (r2retry_t2l2' = r2retry_t2l2+1);
  [r2dot2l2] r2=2 & r2retry_t2l2 >= r2_maxRetry_t2l2 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..8];
  worker1retry_t1l1 : [0..worker1_maxRetry_t1l1] init 0;
  worker1retry_t1l2a : [0..worker1_maxRetry_t1l2a] init 0;
  worker1retry_t1l2b : [0..worker1_maxRetry_t1l2b] init 0;
  worker1retry_t3l5 : [0..worker1_maxRetry_t3l5] init 0;

  [worker1dot1l1Retry] worker1=0 & worker1retry_t1l1 < worker1_maxRetry_t1l1 -> p_worker1_t1l1 : (worker1'=worker1+1) + (1-p_worker1_t1l1) : (worker1'=worker1) & (worker1retry_t1l1' = worker1retry_t1l1+1);
  [worker1dot1l1] worker1=0 & worker1retry_t1l1 >= worker1_maxRetry_t1l1 -> 1:(worker1'=worker1Fail);
  [worker1movel2] worker1=1-> 1:(worker1'=1+1);
  [worker1dot1l2aRetry] worker1=2 & worker1retry_t1l2a < worker1_maxRetry_t1l2a -> p_worker1_t1l2a : (worker1'=worker1+1) + (1-p_worker1_t1l2a) : (worker1'=worker1) & (worker1retry_t1l2a' = worker1retry_t1l2a+1);
  [worker1dot1l2a] worker1=2 & worker1retry_t1l2a >= worker1_maxRetry_t1l2a -> 1:(worker1'=worker1Fail);
  [worker1dot1l2bRetry] worker1=3 & worker1retry_t1l2b < worker1_maxRetry_t1l2b -> p_worker1_t1l2b : (worker1'=worker1+1) + (1-p_worker1_t1l2b) : (worker1'=worker1) & (worker1retry_t1l2b' = worker1retry_t1l2b+1);
  [worker1dot1l2b] worker1=3 & worker1retry_t1l2b >= worker1_maxRetry_t1l2b -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=4-> 1:(worker1'=4+1);
  [worker1dot3l5Retry] worker1=5 & worker1retry_t3l5 < worker1_maxRetry_t3l5 -> p_worker1_t3l5 : (worker1'=worker1+1) + (1-p_worker1_t3l5) : (worker1'=worker1) & (worker1retry_t3l5' = worker1retry_t3l5+1);
  [worker1dot3l5] worker1=5 & worker1retry_t3l5 >= worker1_maxRetry_t3l5 -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [worker2movel4] true:1;
  [worker2movel7] true:1;
  [worker2dot3l7] true:5;
  [worker2dot3l7Retry] true:5;
  [worker2dot1l7] true:3;
  [worker2dot1l7Retry] true:3;
  [worker2movel8] true:1;
  [worker2dot1l8a] true:3;
  [worker2dot1l8aRetry] true:3;
  [worker2dot3l8] true:5;
  [worker2dot3l8Retry] true:5;
  [worker2dot1l8b] true:3;
  [worker2dot1l8bRetry] true:3;
  [worker2movel9] true:1;
  [worker2dot1l9] true:3;
  [worker2dot1l9Retry] true:3;
  [r1movel4] true:1;
  [r1dot2l4] true:1;
  [r1dot2l4Retry] true:1;
  [r2dot3l1] true:1;
  [r2dot3l1Retry] true:1;
  [r2movel2] true:1;
  [r2dot2l2] true:1;
  [r2dot2l2Retry] true:1;
  [worker1dot1l1] true:3;
  [worker1dot1l1Retry] true:3;
  [worker1movel2] true:1;
  [worker1dot1l2a] true:3;
  [worker1dot1l2aRetry] true:3;
  [worker1dot1l2b] true:3;
  [worker1dot1l2bRetry] true:3;
  [worker1movel5] true:1;
  [worker1dot3l5] true:5;
  [worker1dot3l5Retry] true:5;
endrewards