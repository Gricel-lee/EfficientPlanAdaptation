dtmc
evolve int r2_maxRetry_t3l7 [1..10];
evolve int r2_maxRetry_t2l8 [1..10];
evolve int r2_maxRetry_t3l9b [1..10];
evolve int r2_maxRetry_t3l9a [1..10];
evolve int worker1_maxRetry_t1l2b [1..5];
evolve int worker1_maxRetry_t1l2a [1..5];
evolve int worker1_maxRetry_t3l3 [1..5];
evolve int worker2_maxRetry_t1l4 [1..5];
evolve int worker2_maxRetry_t1l5 [1..5];
evolve int worker2_maxRetry_t3l5c [1..5];
evolve int worker2_maxRetry_t3l5b [1..5];
evolve int worker2_maxRetry_t3l5a [1..5];

const double p_r2_t3l7=0.97;
const double p_r2_t2l8=0.99;
const double p_r2_t3l9b=0.97;
const double p_r2_t3l9a=0.97;
const double p_worker1_t1l2b=1.0;
const double p_worker1_t1l2a=1.0;
const double p_worker1_t3l3=0.99;
const double p_worker2_t1l4=1.0;
const double p_worker2_t1l5=1.0;
const double p_worker2_t3l5c=0.99;
const double p_worker2_t3l5b=0.99;
const double p_worker2_t3l5a=0.99;
const int r2Final = 8;
const int r2Fail = 9;
const int worker1Final = 5;
const int worker1Fail = 6;
const int worker2Final = 7;
const int worker2Fail = 8;

module _r2
  r2 : [0..10];
  r2retry_t3l7 : [0..r2_maxRetry_t3l7] init 0;
  r2retry_t2l8 : [0..r2_maxRetry_t2l8] init 0;
  r2retry_t3l9b : [0..r2_maxRetry_t3l9b] init 0;
  r2retry_t3l9a : [0..r2_maxRetry_t3l9a] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2movel7] r2=1-> 1:(r2'=1+1);
  [r2dot3l7Retry] r2=2 & r2retry_t3l7 < r2_maxRetry_t3l7 -> p_r2_t3l7 : (r2'=r2+1) + (1-p_r2_t3l7) : (r2'=r2) & (r2retry_t3l7' = r2retry_t3l7+1);
  [r2dot3l7] r2=2 & r2retry_t3l7 >= r2_maxRetry_t3l7 -> 1:(r2'=r2Fail);
  [r2movel8] r2=3-> 1:(r2'=3+1);
  [r2dot2l8Retry] r2=4 & r2retry_t2l8 < r2_maxRetry_t2l8 -> p_r2_t2l8 : (r2'=r2+1) + (1-p_r2_t2l8) : (r2'=r2) & (r2retry_t2l8' = r2retry_t2l8+1);
  [r2dot2l8] r2=4 & r2retry_t2l8 >= r2_maxRetry_t2l8 -> 1:(r2'=r2Fail);
  [r2movel9] r2=5-> 1:(r2'=5+1);
  [r2dot3l9bRetry] r2=6 & r2retry_t3l9b < r2_maxRetry_t3l9b -> p_r2_t3l9b : (r2'=r2+1) + (1-p_r2_t3l9b) : (r2'=r2) & (r2retry_t3l9b' = r2retry_t3l9b+1);
  [r2dot3l9b] r2=6 & r2retry_t3l9b >= r2_maxRetry_t3l9b -> 1:(r2'=r2Fail);
  [r2dot3l9aRetry] r2=7 & r2retry_t3l9a < r2_maxRetry_t3l9a -> p_r2_t3l9a : (r2'=r2+1) + (1-p_r2_t3l9a) : (r2'=r2) & (r2retry_t3l9a' = r2retry_t3l9a+1);
  [r2dot3l9a] r2=7 & r2retry_t3l9a >= r2_maxRetry_t3l9a -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..7];
  worker1retry_t1l2b : [0..worker1_maxRetry_t1l2b] init 0;
  worker1retry_t1l2a : [0..worker1_maxRetry_t1l2a] init 0;
  worker1retry_t3l3 : [0..worker1_maxRetry_t3l3] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l2bRetry] worker1=1 & worker1retry_t1l2b < worker1_maxRetry_t1l2b -> p_worker1_t1l2b : (worker1'=worker1+1) + (1-p_worker1_t1l2b) : (worker1'=worker1) & (worker1retry_t1l2b' = worker1retry_t1l2b+1);
  [worker1dot1l2b] worker1=1 & worker1retry_t1l2b >= worker1_maxRetry_t1l2b -> 1:(worker1'=worker1Fail);
  [worker1dot1l2aRetry] worker1=2 & worker1retry_t1l2a < worker1_maxRetry_t1l2a -> p_worker1_t1l2a : (worker1'=worker1+1) + (1-p_worker1_t1l2a) : (worker1'=worker1) & (worker1retry_t1l2a' = worker1retry_t1l2a+1);
  [worker1dot1l2a] worker1=2 & worker1retry_t1l2a >= worker1_maxRetry_t1l2a -> 1:(worker1'=worker1Fail);
  [worker1movel3] worker1=3-> 1:(worker1'=3+1);
  [worker1dot3l3Retry] worker1=4 & worker1retry_t3l3 < worker1_maxRetry_t3l3 -> p_worker1_t3l3 : (worker1'=worker1+1) + (1-p_worker1_t3l3) : (worker1'=worker1) & (worker1retry_t3l3' = worker1retry_t3l3+1);
  [worker1dot3l3] worker1=4 & worker1retry_t3l3 >= worker1_maxRetry_t3l3 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..9];
  worker2retry_t1l4 : [0..worker2_maxRetry_t1l4] init 0;
  worker2retry_t1l5 : [0..worker2_maxRetry_t1l5] init 0;
  worker2retry_t3l5c : [0..worker2_maxRetry_t3l5c] init 0;
  worker2retry_t3l5b : [0..worker2_maxRetry_t3l5b] init 0;
  worker2retry_t3l5a : [0..worker2_maxRetry_t3l5a] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l4Retry] worker2=1 & worker2retry_t1l4 < worker2_maxRetry_t1l4 -> p_worker2_t1l4 : (worker2'=worker2+1) + (1-p_worker2_t1l4) : (worker2'=worker2) & (worker2retry_t1l4' = worker2retry_t1l4+1);
  [worker2dot1l4] worker2=1 & worker2retry_t1l4 >= worker2_maxRetry_t1l4 -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=2-> 1:(worker2'=2+1);
  [worker2dot1l5Retry] worker2=3 & worker2retry_t1l5 < worker2_maxRetry_t1l5 -> p_worker2_t1l5 : (worker2'=worker2+1) + (1-p_worker2_t1l5) : (worker2'=worker2) & (worker2retry_t1l5' = worker2retry_t1l5+1);
  [worker2dot1l5] worker2=3 & worker2retry_t1l5 >= worker2_maxRetry_t1l5 -> 1:(worker2'=worker2Fail);
  [worker2dot3l5cRetry] worker2=4 & worker2retry_t3l5c < worker2_maxRetry_t3l5c -> p_worker2_t3l5c : (worker2'=worker2+1) + (1-p_worker2_t3l5c) : (worker2'=worker2) & (worker2retry_t3l5c' = worker2retry_t3l5c+1);
  [worker2dot3l5c] worker2=4 & worker2retry_t3l5c >= worker2_maxRetry_t3l5c -> 1:(worker2'=worker2Fail);
  [worker2dot3l5bRetry] worker2=5 & worker2retry_t3l5b < worker2_maxRetry_t3l5b -> p_worker2_t3l5b : (worker2'=worker2+1) + (1-p_worker2_t3l5b) : (worker2'=worker2) & (worker2retry_t3l5b' = worker2retry_t3l5b+1);
  [worker2dot3l5b] worker2=5 & worker2retry_t3l5b >= worker2_maxRetry_t3l5b -> 1:(worker2'=worker2Fail);
  [worker2dot3l5aRetry] worker2=6 & worker2retry_t3l5a < worker2_maxRetry_t3l5a -> p_worker2_t3l5a : (worker2'=worker2+1) + (1-p_worker2_t3l5a) : (worker2'=worker2) & (worker2retry_t3l5a' = worker2retry_t3l5a+1);
  [worker2dot3l5a] worker2=6 & worker2retry_t3l5a >= worker2_maxRetry_t3l5a -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r2movel4] true:1;
  [r2movel7] true:1;
  [r2dot3l7] true:1;
  [r2dot3l7Retry] true:1;
  [r2movel8] true:1;
  [r2dot2l8] true:1;
  [r2dot2l8Retry] true:1;
  [r2movel9] true:1;
  [r2dot3l9b] true:1;
  [r2dot3l9bRetry] true:1;
  [r2dot3l9a] true:1;
  [r2dot3l9aRetry] true:1;
  [worker1movel2] true:1;
  [worker1dot1l2b] true:3;
  [worker1dot1l2bRetry] true:3;
  [worker1dot1l2a] true:3;
  [worker1dot1l2aRetry] true:3;
  [worker1movel3] true:1;
  [worker1dot3l3] true:5;
  [worker1dot3l3Retry] true:5;
  [worker2movel4] true:1;
  [worker2dot1l4] true:3;
  [worker2dot1l4Retry] true:3;
  [worker2movel5] true:1;
  [worker2dot1l5] true:3;
  [worker2dot1l5Retry] true:3;
  [worker2dot3l5c] true:5;
  [worker2dot3l5cRetry] true:5;
  [worker2dot3l5b] true:5;
  [worker2dot3l5bRetry] true:5;
  [worker2dot3l5a] true:5;
  [worker2dot3l5aRetry] true:5;
endrewards