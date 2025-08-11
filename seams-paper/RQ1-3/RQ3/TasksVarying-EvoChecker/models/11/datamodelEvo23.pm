dtmc
evolve int r2_maxRetry_t2l4b [1..10];
evolve int r2_maxRetry_t2l4a [1..10];
evolve int r2_maxRetry_t2l5a [1..10];
evolve int r2_maxRetry_t2l5c [1..10];
evolve int r2_maxRetry_t2l5b [1..10];
evolve int r2_maxRetry_t2l8 [1..10];
evolve int r2_maxRetry_t3l9 [1..10];
evolve int r2_maxRetry_t2l9 [1..10];
evolve int worker1_maxRetry_t3l3 [1..5];
evolve int worker2_maxRetry_t1l7 [1..5];
evolve int worker2_maxRetry_t1l8 [1..5];

const double p_r2_t2l4b=0.99;
const double p_r2_t2l4a=0.99;
const double p_r2_t2l5a=0.99;
const double p_r2_t2l5c=0.99;
const double p_r2_t2l5b=0.99;
const double p_r2_t2l8=0.99;
const double p_r2_t3l9=0.97;
const double p_r2_t2l9=0.99;
const double p_worker1_t3l3=0.99;
const double p_worker2_t1l7=1.0;
const double p_worker2_t1l8=1.0;
const int r2Final = 12;
const int r2Fail = 13;
const int worker1Final = 3;
const int worker1Fail = 4;
const int worker2Final = 5;
const int worker2Fail = 6;

module _r2
  r2 : [0..14];
  r2retry_t2l4b : [0..r2_maxRetry_t2l4b] init 0;
  r2retry_t2l4a : [0..r2_maxRetry_t2l4a] init 0;
  r2retry_t2l5a : [0..r2_maxRetry_t2l5a] init 0;
  r2retry_t2l5c : [0..r2_maxRetry_t2l5c] init 0;
  r2retry_t2l5b : [0..r2_maxRetry_t2l5b] init 0;
  r2retry_t2l8 : [0..r2_maxRetry_t2l8] init 0;
  r2retry_t3l9 : [0..r2_maxRetry_t3l9] init 0;
  r2retry_t2l9 : [0..r2_maxRetry_t2l9] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2dot2l4bRetry] r2=1 & r2retry_t2l4b < r2_maxRetry_t2l4b -> p_r2_t2l4b : (r2'=r2+1) + (1-p_r2_t2l4b) : (r2'=r2) & (r2retry_t2l4b' = r2retry_t2l4b+1);
  [r2dot2l4b] r2=1 & r2retry_t2l4b >= r2_maxRetry_t2l4b -> 1:(r2'=r2Fail);
  [r2dot2l4aRetry] r2=2 & r2retry_t2l4a < r2_maxRetry_t2l4a -> p_r2_t2l4a : (r2'=r2+1) + (1-p_r2_t2l4a) : (r2'=r2) & (r2retry_t2l4a' = r2retry_t2l4a+1);
  [r2dot2l4a] r2=2 & r2retry_t2l4a >= r2_maxRetry_t2l4a -> 1:(r2'=r2Fail);
  [r2movel5] r2=3-> 1:(r2'=3+1);
  [r2dot2l5aRetry] r2=4 & r2retry_t2l5a < r2_maxRetry_t2l5a -> p_r2_t2l5a : (r2'=r2+1) + (1-p_r2_t2l5a) : (r2'=r2) & (r2retry_t2l5a' = r2retry_t2l5a+1);
  [r2dot2l5a] r2=4 & r2retry_t2l5a >= r2_maxRetry_t2l5a -> 1:(r2'=r2Fail);
  [r2dot2l5cRetry] r2=5 & r2retry_t2l5c < r2_maxRetry_t2l5c -> p_r2_t2l5c : (r2'=r2+1) + (1-p_r2_t2l5c) : (r2'=r2) & (r2retry_t2l5c' = r2retry_t2l5c+1);
  [r2dot2l5c] r2=5 & r2retry_t2l5c >= r2_maxRetry_t2l5c -> 1:(r2'=r2Fail);
  [r2dot2l5bRetry] r2=6 & r2retry_t2l5b < r2_maxRetry_t2l5b -> p_r2_t2l5b : (r2'=r2+1) + (1-p_r2_t2l5b) : (r2'=r2) & (r2retry_t2l5b' = r2retry_t2l5b+1);
  [r2dot2l5b] r2=6 & r2retry_t2l5b >= r2_maxRetry_t2l5b -> 1:(r2'=r2Fail);
  [r2movel8] r2=7-> 1:(r2'=7+1);
  [r2dot2l8Retry] r2=8 & r2retry_t2l8 < r2_maxRetry_t2l8 -> p_r2_t2l8 : (r2'=r2+1) + (1-p_r2_t2l8) : (r2'=r2) & (r2retry_t2l8' = r2retry_t2l8+1);
  [r2dot2l8] r2=8 & r2retry_t2l8 >= r2_maxRetry_t2l8 -> 1:(r2'=r2Fail);
  [r2movel9] r2=9-> 1:(r2'=9+1);
  [r2dot3l9Retry] r2=10 & r2retry_t3l9 < r2_maxRetry_t3l9 -> p_r2_t3l9 : (r2'=r2+1) + (1-p_r2_t3l9) : (r2'=r2) & (r2retry_t3l9' = r2retry_t3l9+1);
  [r2dot3l9] r2=10 & r2retry_t3l9 >= r2_maxRetry_t3l9 -> 1:(r2'=r2Fail);
  [r2dot2l9Retry] r2=11 & r2retry_t2l9 < r2_maxRetry_t2l9 -> p_r2_t2l9 : (r2'=r2+1) + (1-p_r2_t2l9) : (r2'=r2) & (r2retry_t2l9' = r2retry_t2l9+1);
  [r2dot2l9] r2=11 & r2retry_t2l9 >= r2_maxRetry_t2l9 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..5];
  worker1retry_t3l3 : [0..worker1_maxRetry_t3l3] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1movel3] worker1=1-> 1:(worker1'=1+1);
  [worker1dot3l3Retry] worker1=2 & worker1retry_t3l3 < worker1_maxRetry_t3l3 -> p_worker1_t3l3 : (worker1'=worker1+1) + (1-p_worker1_t3l3) : (worker1'=worker1) & (worker1retry_t3l3' = worker1retry_t3l3+1);
  [worker1dot3l3] worker1=2 & worker1retry_t3l3 >= worker1_maxRetry_t3l3 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..7];
  worker2retry_t1l7 : [0..worker2_maxRetry_t1l7] init 0;
  worker2retry_t1l8 : [0..worker2_maxRetry_t1l8] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2movel7] worker2=1-> 1:(worker2'=1+1);
  [worker2dot1l7Retry] worker2=2 & worker2retry_t1l7 < worker2_maxRetry_t1l7 -> p_worker2_t1l7 : (worker2'=worker2+1) + (1-p_worker2_t1l7) : (worker2'=worker2) & (worker2retry_t1l7' = worker2retry_t1l7+1);
  [worker2dot1l7] worker2=2 & worker2retry_t1l7 >= worker2_maxRetry_t1l7 -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=3-> 1:(worker2'=3+1);
  [worker2dot1l8Retry] worker2=4 & worker2retry_t1l8 < worker2_maxRetry_t1l8 -> p_worker2_t1l8 : (worker2'=worker2+1) + (1-p_worker2_t1l8) : (worker2'=worker2) & (worker2retry_t1l8' = worker2retry_t1l8+1);
  [worker2dot1l8] worker2=4 & worker2retry_t1l8 >= worker2_maxRetry_t1l8 -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r2movel4] true:1;
  [r2dot2l4b] true:1;
  [r2dot2l4bRetry] true:1;
  [r2dot2l4a] true:1;
  [r2dot2l4aRetry] true:1;
  [r2movel5] true:1;
  [r2dot2l5a] true:1;
  [r2dot2l5aRetry] true:1;
  [r2dot2l5c] true:1;
  [r2dot2l5cRetry] true:1;
  [r2dot2l5b] true:1;
  [r2dot2l5bRetry] true:1;
  [r2movel8] true:1;
  [r2dot2l8] true:1;
  [r2dot2l8Retry] true:1;
  [r2movel9] true:1;
  [r2dot3l9] true:1;
  [r2dot3l9Retry] true:1;
  [r2dot2l9] true:1;
  [r2dot2l9Retry] true:1;
  [worker1movel2] true:1;
  [worker1movel3] true:1;
  [worker1dot3l3] true:5;
  [worker1dot3l3Retry] true:5;
  [worker2movel4] true:1;
  [worker2movel7] true:1;
  [worker2dot1l7] true:3;
  [worker2dot1l7Retry] true:3;
  [worker2movel8] true:1;
  [worker2dot1l8] true:3;
  [worker2dot1l8Retry] true:3;
endrewards