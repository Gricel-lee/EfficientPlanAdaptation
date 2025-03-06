dtmc
evolve int worker1_maxRetry_t1l8 [1..5];
evolve int worker1_maxRetry_t1l9c [1..5];
evolve int worker1_maxRetry_t1l9a [1..5];
evolve int worker1_maxRetry_t1l9b [1..5];
evolve int worker1_maxRetry_t1l9d [1..5];
evolve int r1_maxRetry_t2l7 [1..10];
evolve int r1_maxRetry_t2l8 [1..10];
evolve int r1_maxRetry_t2l9 [1..10];
evolve int r1_maxRetry_t3l3 [1..10];
evolve int r1_maxRetry_t2l3 [1..10];

const double p_worker1_t1l8=1.0;
const double p_worker1_t1l9c=1.0;
const double p_worker1_t1l9a=1.0;
const double p_worker1_t1l9b=1.0;
const double p_worker1_t1l9d=1.0;
const double p_r1_t2l7=0.99;
const double p_r1_t2l8=0.99;
const double p_r1_t2l9=0.99;
const double p_r1_t3l3=0.97;
const double p_r1_t2l3=0.99;
const int worker1Final = 9;
const int worker1Fail = 10;
const int r1Final = 11;
const int r1Fail = 12;

module _worker1
  worker1 : [0..11];
  worker1retry_t1l8 : [0..worker1_maxRetry_t1l8] init 0;
  worker1retry_t1l9c : [0..worker1_maxRetry_t1l9c] init 0;
  worker1retry_t1l9a : [0..worker1_maxRetry_t1l9a] init 0;
  worker1retry_t1l9b : [0..worker1_maxRetry_t1l9b] init 0;
  worker1retry_t1l9d : [0..worker1_maxRetry_t1l9d] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1movel5] worker1=1-> 1:(worker1'=1+1);
  [worker1movel8] worker1=2-> 1:(worker1'=2+1);
  [worker1dot1l8Retry] worker1=3 & worker1retry_t1l8 < worker1_maxRetry_t1l8 -> p_worker1_t1l8 : (worker1'=worker1+1) + (1-p_worker1_t1l8) : (worker1'=worker1) & (worker1retry_t1l8' = worker1retry_t1l8+1);
  [worker1dot1l8] worker1=3 & worker1retry_t1l8 >= worker1_maxRetry_t1l8 -> 1:(worker1'=worker1Fail);
  [worker1movel9] worker1=4-> 1:(worker1'=4+1);
  [worker1dot1l9cRetry] worker1=5 & worker1retry_t1l9c < worker1_maxRetry_t1l9c -> p_worker1_t1l9c : (worker1'=worker1+1) + (1-p_worker1_t1l9c) : (worker1'=worker1) & (worker1retry_t1l9c' = worker1retry_t1l9c+1);
  [worker1dot1l9c] worker1=5 & worker1retry_t1l9c >= worker1_maxRetry_t1l9c -> 1:(worker1'=worker1Fail);
  [worker1dot1l9aRetry] worker1=6 & worker1retry_t1l9a < worker1_maxRetry_t1l9a -> p_worker1_t1l9a : (worker1'=worker1+1) + (1-p_worker1_t1l9a) : (worker1'=worker1) & (worker1retry_t1l9a' = worker1retry_t1l9a+1);
  [worker1dot1l9a] worker1=6 & worker1retry_t1l9a >= worker1_maxRetry_t1l9a -> 1:(worker1'=worker1Fail);
  [worker1dot1l9bRetry] worker1=7 & worker1retry_t1l9b < worker1_maxRetry_t1l9b -> p_worker1_t1l9b : (worker1'=worker1+1) + (1-p_worker1_t1l9b) : (worker1'=worker1) & (worker1retry_t1l9b' = worker1retry_t1l9b+1);
  [worker1dot1l9b] worker1=7 & worker1retry_t1l9b >= worker1_maxRetry_t1l9b -> 1:(worker1'=worker1Fail);
  [worker1dot1l9dRetry] worker1=8 & worker1retry_t1l9d < worker1_maxRetry_t1l9d -> p_worker1_t1l9d : (worker1'=worker1+1) + (1-p_worker1_t1l9d) : (worker1'=worker1) & (worker1retry_t1l9d' = worker1retry_t1l9d+1);
  [worker1dot1l9d] worker1=8 & worker1retry_t1l9d >= worker1_maxRetry_t1l9d -> 1:(worker1'=worker1Fail);
endmodule

module _r1
  r1 : [0..13];
  r1retry_t2l7 : [0..r1_maxRetry_t2l7] init 0;
  r1retry_t2l8 : [0..r1_maxRetry_t2l8] init 0;
  r1retry_t2l9 : [0..r1_maxRetry_t2l9] init 0;
  r1retry_t3l3 : [0..r1_maxRetry_t3l3] init 0;
  r1retry_t2l3 : [0..r1_maxRetry_t2l3] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1movel7] r1=1-> 1:(r1'=1+1);
  [r1dot2l7Retry] r1=2 & r1retry_t2l7 < r1_maxRetry_t2l7 -> p_r1_t2l7 : (r1'=r1+1) + (1-p_r1_t2l7) : (r1'=r1) & (r1retry_t2l7' = r1retry_t2l7+1);
  [r1dot2l7] r1=2 & r1retry_t2l7 >= r1_maxRetry_t2l7 -> 1:(r1'=r1Fail);
  [r1movel8] r1=3-> 1:(r1'=3+1);
  [r1dot2l8Retry] r1=4 & r1retry_t2l8 < r1_maxRetry_t2l8 -> p_r1_t2l8 : (r1'=r1+1) + (1-p_r1_t2l8) : (r1'=r1) & (r1retry_t2l8' = r1retry_t2l8+1);
  [r1dot2l8] r1=4 & r1retry_t2l8 >= r1_maxRetry_t2l8 -> 1:(r1'=r1Fail);
  [r1movel9] r1=5-> 1:(r1'=5+1);
  [r1dot2l9Retry] r1=6 & r1retry_t2l9 < r1_maxRetry_t2l9 -> p_r1_t2l9 : (r1'=r1+1) + (1-p_r1_t2l9) : (r1'=r1) & (r1retry_t2l9' = r1retry_t2l9+1);
  [r1dot2l9] r1=6 & r1retry_t2l9 >= r1_maxRetry_t2l9 -> 1:(r1'=r1Fail);
  [r1movel6] r1=7-> 1:(r1'=7+1);
  [r1movel3] r1=8-> 1:(r1'=8+1);
  [r1dot3l3Retry] r1=9 & r1retry_t3l3 < r1_maxRetry_t3l3 -> p_r1_t3l3 : (r1'=r1+1) + (1-p_r1_t3l3) : (r1'=r1) & (r1retry_t3l3' = r1retry_t3l3+1);
  [r1dot3l3] r1=9 & r1retry_t3l3 >= r1_maxRetry_t3l3 -> 1:(r1'=r1Fail);
  [r1dot2l3Retry] r1=10 & r1retry_t2l3 < r1_maxRetry_t2l3 -> p_r1_t2l3 : (r1'=r1+1) + (1-p_r1_t2l3) : (r1'=r1) & (r1retry_t2l3' = r1retry_t2l3+1);
  [r1dot2l3] r1=10 & r1retry_t2l3 >= r1_maxRetry_t2l3 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [worker1movel2] true:1;
  [worker1movel5] true:1;
  [worker1movel8] true:1;
  [worker1dot1l8] true:3;
  [worker1dot1l8Retry] true:3;
  [worker1movel9] true:1;
  [worker1dot1l9c] true:3;
  [worker1dot1l9cRetry] true:3;
  [worker1dot1l9a] true:3;
  [worker1dot1l9aRetry] true:3;
  [worker1dot1l9b] true:3;
  [worker1dot1l9bRetry] true:3;
  [worker1dot1l9d] true:3;
  [worker1dot1l9dRetry] true:3;
  [r1movel4] true:1;
  [r1movel7] true:1;
  [r1dot2l7] true:1;
  [r1dot2l7Retry] true:1;
  [r1movel8] true:1;
  [r1dot2l8] true:1;
  [r1dot2l8Retry] true:1;
  [r1movel9] true:1;
  [r1dot2l9] true:1;
  [r1dot2l9Retry] true:1;
  [r1movel6] true:1;
  [r1movel3] true:1;
  [r1dot3l3] true:1;
  [r1dot3l3Retry] true:1;
  [r1dot2l3] true:1;
  [r1dot2l3Retry] true:1;
endrewards