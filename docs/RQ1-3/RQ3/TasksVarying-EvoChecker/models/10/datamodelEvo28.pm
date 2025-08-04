dtmc
evolve int worker1_maxRetry_t1l1 [1..5];
evolve int worker2_maxRetry_t1l5 [1..5];
evolve int worker2_maxRetry_t3l8b [1..5];
evolve int worker2_maxRetry_t3l8a [1..5];
evolve int r1_maxRetry_t2l3 [1..10];
evolve int r1_maxRetry_t2l9c [1..10];
evolve int r1_maxRetry_t2l9b [1..10];
evolve int r1_maxRetry_t3l9 [1..10];
evolve int r1_maxRetry_t2l9a [1..10];
evolve int r2_maxRetry_t3l1 [1..10];

const double p_worker1_t1l1=1.0;
const double p_worker2_t1l5=1.0;
const double p_worker2_t3l8b=0.99;
const double p_worker2_t3l8a=0.99;
const double p_r1_t2l3=0.99;
const double p_r1_t2l9c=0.99;
const double p_r1_t2l9b=0.99;
const double p_r1_t3l9=0.97;
const double p_r1_t2l9a=0.99;
const double p_r2_t3l1=0.97;
const int worker1Final = 1;
const int worker1Fail = 2;
const int worker2Final = 6;
const int worker2Fail = 7;
const int r1Final = 9;
const int r1Fail = 10;
const int r2Final = 1;
const int r2Fail = 2;

module _worker1
  worker1 : [0..3];
  worker1retry_t1l1 : [0..worker1_maxRetry_t1l1] init 0;

  [worker1dot1l1Retry] worker1=0 & worker1retry_t1l1 < worker1_maxRetry_t1l1 -> p_worker1_t1l1 : (worker1'=worker1+1) + (1-p_worker1_t1l1) : (worker1'=worker1) & (worker1retry_t1l1' = worker1retry_t1l1+1);
  [worker1dot1l1] worker1=0 & worker1retry_t1l1 >= worker1_maxRetry_t1l1 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..8];
  worker2retry_t1l5 : [0..worker2_maxRetry_t1l5] init 0;
  worker2retry_t3l8b : [0..worker2_maxRetry_t3l8b] init 0;
  worker2retry_t3l8a : [0..worker2_maxRetry_t3l8a] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2movel5] worker2=1-> 1:(worker2'=1+1);
  [worker2dot1l5Retry] worker2=2 & worker2retry_t1l5 < worker2_maxRetry_t1l5 -> p_worker2_t1l5 : (worker2'=worker2+1) + (1-p_worker2_t1l5) : (worker2'=worker2) & (worker2retry_t1l5' = worker2retry_t1l5+1);
  [worker2dot1l5] worker2=2 & worker2retry_t1l5 >= worker2_maxRetry_t1l5 -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=3-> 1:(worker2'=3+1);
  [worker2dot3l8bRetry] worker2=4 & worker2retry_t3l8b < worker2_maxRetry_t3l8b -> p_worker2_t3l8b : (worker2'=worker2+1) + (1-p_worker2_t3l8b) : (worker2'=worker2) & (worker2retry_t3l8b' = worker2retry_t3l8b+1);
  [worker2dot3l8b] worker2=4 & worker2retry_t3l8b >= worker2_maxRetry_t3l8b -> 1:(worker2'=worker2Fail);
  [worker2dot3l8aRetry] worker2=5 & worker2retry_t3l8a < worker2_maxRetry_t3l8a -> p_worker2_t3l8a : (worker2'=worker2+1) + (1-p_worker2_t3l8a) : (worker2'=worker2) & (worker2retry_t3l8a' = worker2retry_t3l8a+1);
  [worker2dot3l8a] worker2=5 & worker2retry_t3l8a >= worker2_maxRetry_t3l8a -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..11];
  r1retry_t2l3 : [0..r1_maxRetry_t2l3] init 0;
  r1retry_t2l9c : [0..r1_maxRetry_t2l9c] init 0;
  r1retry_t2l9b : [0..r1_maxRetry_t2l9b] init 0;
  r1retry_t3l9 : [0..r1_maxRetry_t3l9] init 0;
  r1retry_t2l9a : [0..r1_maxRetry_t2l9a] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1movel3] r1=1-> 1:(r1'=1+1);
  [r1dot2l3Retry] r1=2 & r1retry_t2l3 < r1_maxRetry_t2l3 -> p_r1_t2l3 : (r1'=r1+1) + (1-p_r1_t2l3) : (r1'=r1) & (r1retry_t2l3' = r1retry_t2l3+1);
  [r1dot2l3] r1=2 & r1retry_t2l3 >= r1_maxRetry_t2l3 -> 1:(r1'=r1Fail);
  [r1movel6] r1=3-> 1:(r1'=3+1);
  [r1movel9] r1=4-> 1:(r1'=4+1);
  [r1dot2l9cRetry] r1=5 & r1retry_t2l9c < r1_maxRetry_t2l9c -> p_r1_t2l9c : (r1'=r1+1) + (1-p_r1_t2l9c) : (r1'=r1) & (r1retry_t2l9c' = r1retry_t2l9c+1);
  [r1dot2l9c] r1=5 & r1retry_t2l9c >= r1_maxRetry_t2l9c -> 1:(r1'=r1Fail);
  [r1dot2l9bRetry] r1=6 & r1retry_t2l9b < r1_maxRetry_t2l9b -> p_r1_t2l9b : (r1'=r1+1) + (1-p_r1_t2l9b) : (r1'=r1) & (r1retry_t2l9b' = r1retry_t2l9b+1);
  [r1dot2l9b] r1=6 & r1retry_t2l9b >= r1_maxRetry_t2l9b -> 1:(r1'=r1Fail);
  [r1dot3l9Retry] r1=7 & r1retry_t3l9 < r1_maxRetry_t3l9 -> p_r1_t3l9 : (r1'=r1+1) + (1-p_r1_t3l9) : (r1'=r1) & (r1retry_t3l9' = r1retry_t3l9+1);
  [r1dot3l9] r1=7 & r1retry_t3l9 >= r1_maxRetry_t3l9 -> 1:(r1'=r1Fail);
  [r1dot2l9aRetry] r1=8 & r1retry_t2l9a < r1_maxRetry_t2l9a -> p_r1_t2l9a : (r1'=r1+1) + (1-p_r1_t2l9a) : (r1'=r1) & (r1retry_t2l9a' = r1retry_t2l9a+1);
  [r1dot2l9a] r1=8 & r1retry_t2l9a >= r1_maxRetry_t2l9a -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..3];
  r2retry_t3l1 : [0..r2_maxRetry_t3l1] init 0;

  [r2dot3l1Retry] r2=0 & r2retry_t3l1 < r2_maxRetry_t3l1 -> p_r2_t3l1 : (r2'=r2+1) + (1-p_r2_t3l1) : (r2'=r2) & (r2retry_t3l1' = r2retry_t3l1+1);
  [r2dot3l1] r2=0 & r2retry_t3l1 >= r2_maxRetry_t3l1 -> 1:(r2'=r2Fail);
endmodule

rewards "cost"
  [worker1dot1l1] true:3;
  [worker1dot1l1Retry] true:3;
  [worker2movel4] true:1;
  [worker2movel5] true:1;
  [worker2dot1l5] true:3;
  [worker2dot1l5Retry] true:3;
  [worker2movel8] true:1;
  [worker2dot3l8b] true:5;
  [worker2dot3l8bRetry] true:5;
  [worker2dot3l8a] true:5;
  [worker2dot3l8aRetry] true:5;
  [r1movel2] true:1;
  [r1movel3] true:1;
  [r1dot2l3] true:1;
  [r1dot2l3Retry] true:1;
  [r1movel6] true:1;
  [r1movel9] true:1;
  [r1dot2l9c] true:1;
  [r1dot2l9cRetry] true:1;
  [r1dot2l9b] true:1;
  [r1dot2l9bRetry] true:1;
  [r1dot3l9] true:1;
  [r1dot3l9Retry] true:1;
  [r1dot2l9a] true:1;
  [r1dot2l9aRetry] true:1;
  [r2dot3l1] true:1;
  [r2dot3l1Retry] true:1;
endrewards