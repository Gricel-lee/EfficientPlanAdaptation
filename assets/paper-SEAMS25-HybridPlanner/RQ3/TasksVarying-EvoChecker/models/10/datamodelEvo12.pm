dtmc
evolve int worker2_maxRetry_t1l2 [1..5];
evolve int worker2_maxRetry_t1l5d [1..5];
evolve int worker2_maxRetry_t1l5b [1..5];
evolve int worker2_maxRetry_t1l5c [1..5];
evolve int worker2_maxRetry_t3l5 [1..5];
evolve int worker2_maxRetry_t1l5a [1..5];
evolve int r1_maxRetry_t3l3 [1..10];
evolve int r1_maxRetry_t2l3 [1..10];
evolve int r1_maxRetry_t2l9 [1..10];
evolve int r1_maxRetry_t3l9 [1..10];

const double p_worker2_t1l2=1.0;
const double p_worker2_t1l5d=1.0;
const double p_worker2_t1l5b=1.0;
const double p_worker2_t1l5c=1.0;
const double p_worker2_t3l5=0.99;
const double p_worker2_t1l5a=1.0;
const double p_r1_t3l3=0.97;
const double p_r1_t2l3=0.99;
const double p_r1_t2l9=0.99;
const double p_r1_t3l9=0.97;
const int worker2Final = 8;
const int worker2Fail = 9;
const int r1Final = 8;
const int r1Fail = 9;

module _worker2
  worker2 : [0..10];
  worker2retry_t1l2 : [0..worker2_maxRetry_t1l2] init 0;
  worker2retry_t1l5d : [0..worker2_maxRetry_t1l5d] init 0;
  worker2retry_t1l5b : [0..worker2_maxRetry_t1l5b] init 0;
  worker2retry_t1l5c : [0..worker2_maxRetry_t1l5c] init 0;
  worker2retry_t3l5 : [0..worker2_maxRetry_t3l5] init 0;
  worker2retry_t1l5a : [0..worker2_maxRetry_t1l5a] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l2Retry] worker2=1 & worker2retry_t1l2 < worker2_maxRetry_t1l2 -> p_worker2_t1l2 : (worker2'=worker2+1) + (1-p_worker2_t1l2) : (worker2'=worker2) & (worker2retry_t1l2' = worker2retry_t1l2+1);
  [worker2dot1l2] worker2=1 & worker2retry_t1l2 >= worker2_maxRetry_t1l2 -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=2-> 1:(worker2'=2+1);
  [worker2dot1l5dRetry] worker2=3 & worker2retry_t1l5d < worker2_maxRetry_t1l5d -> p_worker2_t1l5d : (worker2'=worker2+1) + (1-p_worker2_t1l5d) : (worker2'=worker2) & (worker2retry_t1l5d' = worker2retry_t1l5d+1);
  [worker2dot1l5d] worker2=3 & worker2retry_t1l5d >= worker2_maxRetry_t1l5d -> 1:(worker2'=worker2Fail);
  [worker2dot1l5bRetry] worker2=4 & worker2retry_t1l5b < worker2_maxRetry_t1l5b -> p_worker2_t1l5b : (worker2'=worker2+1) + (1-p_worker2_t1l5b) : (worker2'=worker2) & (worker2retry_t1l5b' = worker2retry_t1l5b+1);
  [worker2dot1l5b] worker2=4 & worker2retry_t1l5b >= worker2_maxRetry_t1l5b -> 1:(worker2'=worker2Fail);
  [worker2dot1l5cRetry] worker2=5 & worker2retry_t1l5c < worker2_maxRetry_t1l5c -> p_worker2_t1l5c : (worker2'=worker2+1) + (1-p_worker2_t1l5c) : (worker2'=worker2) & (worker2retry_t1l5c' = worker2retry_t1l5c+1);
  [worker2dot1l5c] worker2=5 & worker2retry_t1l5c >= worker2_maxRetry_t1l5c -> 1:(worker2'=worker2Fail);
  [worker2dot3l5Retry] worker2=6 & worker2retry_t3l5 < worker2_maxRetry_t3l5 -> p_worker2_t3l5 : (worker2'=worker2+1) + (1-p_worker2_t3l5) : (worker2'=worker2) & (worker2retry_t3l5' = worker2retry_t3l5+1);
  [worker2dot3l5] worker2=6 & worker2retry_t3l5 >= worker2_maxRetry_t3l5 -> 1:(worker2'=worker2Fail);
  [worker2dot1l5aRetry] worker2=7 & worker2retry_t1l5a < worker2_maxRetry_t1l5a -> p_worker2_t1l5a : (worker2'=worker2+1) + (1-p_worker2_t1l5a) : (worker2'=worker2) & (worker2retry_t1l5a' = worker2retry_t1l5a+1);
  [worker2dot1l5a] worker2=7 & worker2retry_t1l5a >= worker2_maxRetry_t1l5a -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..10];
  r1retry_t3l3 : [0..r1_maxRetry_t3l3] init 0;
  r1retry_t2l3 : [0..r1_maxRetry_t2l3] init 0;
  r1retry_t2l9 : [0..r1_maxRetry_t2l9] init 0;
  r1retry_t3l9 : [0..r1_maxRetry_t3l9] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1movel3] r1=1-> 1:(r1'=1+1);
  [r1dot3l3Retry] r1=2 & r1retry_t3l3 < r1_maxRetry_t3l3 -> p_r1_t3l3 : (r1'=r1+1) + (1-p_r1_t3l3) : (r1'=r1) & (r1retry_t3l3' = r1retry_t3l3+1);
  [r1dot3l3] r1=2 & r1retry_t3l3 >= r1_maxRetry_t3l3 -> 1:(r1'=r1Fail);
  [r1dot2l3Retry] r1=3 & r1retry_t2l3 < r1_maxRetry_t2l3 -> p_r1_t2l3 : (r1'=r1+1) + (1-p_r1_t2l3) : (r1'=r1) & (r1retry_t2l3' = r1retry_t2l3+1);
  [r1dot2l3] r1=3 & r1retry_t2l3 >= r1_maxRetry_t2l3 -> 1:(r1'=r1Fail);
  [r1movel6] r1=4-> 1:(r1'=4+1);
  [r1movel9] r1=5-> 1:(r1'=5+1);
  [r1dot2l9Retry] r1=6 & r1retry_t2l9 < r1_maxRetry_t2l9 -> p_r1_t2l9 : (r1'=r1+1) + (1-p_r1_t2l9) : (r1'=r1) & (r1retry_t2l9' = r1retry_t2l9+1);
  [r1dot2l9] r1=6 & r1retry_t2l9 >= r1_maxRetry_t2l9 -> 1:(r1'=r1Fail);
  [r1dot3l9Retry] r1=7 & r1retry_t3l9 < r1_maxRetry_t3l9 -> p_r1_t3l9 : (r1'=r1+1) + (1-p_r1_t3l9) : (r1'=r1) & (r1retry_t3l9' = r1retry_t3l9+1);
  [r1dot3l9] r1=7 & r1retry_t3l9 >= r1_maxRetry_t3l9 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [worker2movel2] true:1;
  [worker2dot1l2] true:3;
  [worker2dot1l2Retry] true:3;
  [worker2movel5] true:1;
  [worker2dot1l5d] true:3;
  [worker2dot1l5dRetry] true:3;
  [worker2dot1l5b] true:3;
  [worker2dot1l5bRetry] true:3;
  [worker2dot1l5c] true:3;
  [worker2dot1l5cRetry] true:3;
  [worker2dot3l5] true:5;
  [worker2dot3l5Retry] true:5;
  [worker2dot1l5a] true:3;
  [worker2dot1l5aRetry] true:3;
  [r1movel2] true:1;
  [r1movel3] true:1;
  [r1dot3l3] true:1;
  [r1dot3l3Retry] true:1;
  [r1dot2l3] true:1;
  [r1dot2l3Retry] true:1;
  [r1movel6] true:1;
  [r1movel9] true:1;
  [r1dot2l9] true:1;
  [r1dot2l9Retry] true:1;
  [r1dot3l9] true:1;
  [r1dot3l9Retry] true:1;
endrewards