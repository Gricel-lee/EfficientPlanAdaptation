dtmc
evolve int r1_maxRetry_t3l3 [1..10];
evolve int r1_maxRetry_t2l6b [1..10];
evolve int r1_maxRetry_t2l6a [1..10];
evolve int r2_maxRetry_t3l7 [1..10];
evolve int r2_maxRetry_t2l8 [1..10];
evolve int worker2_maxRetry_t1l5 [1..5];
evolve int worker2_maxRetry_t1l6a [1..5];
evolve int worker2_maxRetry_t1l6b [1..5];
evolve int worker2_maxRetry_t1l9 [1..5];
evolve int worker2_maxRetry_t3l9a [1..5];
evolve int worker2_maxRetry_t3l9c [1..5];
evolve int worker2_maxRetry_t3l9b [1..5];

const double p_r1_t3l3=0.97;
const double p_r1_t2l6b=0.99;
const double p_r1_t2l6a=0.99;
const double p_r2_t3l7=0.97;
const double p_r2_t2l8=0.99;
const double p_worker2_t1l5=1.0;
const double p_worker2_t1l6a=1.0;
const double p_worker2_t1l6b=1.0;
const double p_worker2_t1l9=1.0;
const double p_worker2_t3l9a=0.99;
const double p_worker2_t3l9c=0.99;
const double p_worker2_t3l9b=0.99;
const int r1Final = 6;
const int r1Fail = 7;
const int r2Final = 5;
const int r2Fail = 6;
const int worker2Final = 11;
const int worker2Fail = 12;

module _r1
  r1 : [0..8];
  r1retry_t3l3 : [0..r1_maxRetry_t3l3] init 0;
  r1retry_t2l6b : [0..r1_maxRetry_t2l6b] init 0;
  r1retry_t2l6a : [0..r1_maxRetry_t2l6a] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1movel3] r1=1-> 1:(r1'=1+1);
  [r1dot3l3Retry] r1=2 & r1retry_t3l3 < r1_maxRetry_t3l3 -> p_r1_t3l3 : (r1'=r1+1) + (1-p_r1_t3l3) : (r1'=r1) & (r1retry_t3l3' = r1retry_t3l3+1);
  [r1dot3l3] r1=2 & r1retry_t3l3 >= r1_maxRetry_t3l3 -> 1:(r1'=r1Fail);
  [r1movel6] r1=3-> 1:(r1'=3+1);
  [r1dot2l6bRetry] r1=4 & r1retry_t2l6b < r1_maxRetry_t2l6b -> p_r1_t2l6b : (r1'=r1+1) + (1-p_r1_t2l6b) : (r1'=r1) & (r1retry_t2l6b' = r1retry_t2l6b+1);
  [r1dot2l6b] r1=4 & r1retry_t2l6b >= r1_maxRetry_t2l6b -> 1:(r1'=r1Fail);
  [r1dot2l6aRetry] r1=5 & r1retry_t2l6a < r1_maxRetry_t2l6a -> p_r1_t2l6a : (r1'=r1+1) + (1-p_r1_t2l6a) : (r1'=r1) & (r1retry_t2l6a' = r1retry_t2l6a+1);
  [r1dot2l6a] r1=5 & r1retry_t2l6a >= r1_maxRetry_t2l6a -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..7];
  r2retry_t3l7 : [0..r2_maxRetry_t3l7] init 0;
  r2retry_t2l8 : [0..r2_maxRetry_t2l8] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2movel7] r2=1-> 1:(r2'=1+1);
  [r2dot3l7Retry] r2=2 & r2retry_t3l7 < r2_maxRetry_t3l7 -> p_r2_t3l7 : (r2'=r2+1) + (1-p_r2_t3l7) : (r2'=r2) & (r2retry_t3l7' = r2retry_t3l7+1);
  [r2dot3l7] r2=2 & r2retry_t3l7 >= r2_maxRetry_t3l7 -> 1:(r2'=r2Fail);
  [r2movel8] r2=3-> 1:(r2'=3+1);
  [r2dot2l8Retry] r2=4 & r2retry_t2l8 < r2_maxRetry_t2l8 -> p_r2_t2l8 : (r2'=r2+1) + (1-p_r2_t2l8) : (r2'=r2) & (r2retry_t2l8' = r2retry_t2l8+1);
  [r2dot2l8] r2=4 & r2retry_t2l8 >= r2_maxRetry_t2l8 -> 1:(r2'=r2Fail);
endmodule

module _worker2
  worker2 : [0..13];
  worker2retry_t1l5 : [0..worker2_maxRetry_t1l5] init 0;
  worker2retry_t1l6a : [0..worker2_maxRetry_t1l6a] init 0;
  worker2retry_t1l6b : [0..worker2_maxRetry_t1l6b] init 0;
  worker2retry_t1l9 : [0..worker2_maxRetry_t1l9] init 0;
  worker2retry_t3l9a : [0..worker2_maxRetry_t3l9a] init 0;
  worker2retry_t3l9c : [0..worker2_maxRetry_t3l9c] init 0;
  worker2retry_t3l9b : [0..worker2_maxRetry_t3l9b] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2movel5] worker2=1-> 1:(worker2'=1+1);
  [worker2dot1l5Retry] worker2=2 & worker2retry_t1l5 < worker2_maxRetry_t1l5 -> p_worker2_t1l5 : (worker2'=worker2+1) + (1-p_worker2_t1l5) : (worker2'=worker2) & (worker2retry_t1l5' = worker2retry_t1l5+1);
  [worker2dot1l5] worker2=2 & worker2retry_t1l5 >= worker2_maxRetry_t1l5 -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=3-> 1:(worker2'=3+1);
  [worker2dot1l6aRetry] worker2=4 & worker2retry_t1l6a < worker2_maxRetry_t1l6a -> p_worker2_t1l6a : (worker2'=worker2+1) + (1-p_worker2_t1l6a) : (worker2'=worker2) & (worker2retry_t1l6a' = worker2retry_t1l6a+1);
  [worker2dot1l6a] worker2=4 & worker2retry_t1l6a >= worker2_maxRetry_t1l6a -> 1:(worker2'=worker2Fail);
  [worker2dot1l6bRetry] worker2=5 & worker2retry_t1l6b < worker2_maxRetry_t1l6b -> p_worker2_t1l6b : (worker2'=worker2+1) + (1-p_worker2_t1l6b) : (worker2'=worker2) & (worker2retry_t1l6b' = worker2retry_t1l6b+1);
  [worker2dot1l6b] worker2=5 & worker2retry_t1l6b >= worker2_maxRetry_t1l6b -> 1:(worker2'=worker2Fail);
  [worker2movel9] worker2=6-> 1:(worker2'=6+1);
  [worker2dot1l9Retry] worker2=7 & worker2retry_t1l9 < worker2_maxRetry_t1l9 -> p_worker2_t1l9 : (worker2'=worker2+1) + (1-p_worker2_t1l9) : (worker2'=worker2) & (worker2retry_t1l9' = worker2retry_t1l9+1);
  [worker2dot1l9] worker2=7 & worker2retry_t1l9 >= worker2_maxRetry_t1l9 -> 1:(worker2'=worker2Fail);
  [worker2dot3l9aRetry] worker2=8 & worker2retry_t3l9a < worker2_maxRetry_t3l9a -> p_worker2_t3l9a : (worker2'=worker2+1) + (1-p_worker2_t3l9a) : (worker2'=worker2) & (worker2retry_t3l9a' = worker2retry_t3l9a+1);
  [worker2dot3l9a] worker2=8 & worker2retry_t3l9a >= worker2_maxRetry_t3l9a -> 1:(worker2'=worker2Fail);
  [worker2dot3l9cRetry] worker2=9 & worker2retry_t3l9c < worker2_maxRetry_t3l9c -> p_worker2_t3l9c : (worker2'=worker2+1) + (1-p_worker2_t3l9c) : (worker2'=worker2) & (worker2retry_t3l9c' = worker2retry_t3l9c+1);
  [worker2dot3l9c] worker2=9 & worker2retry_t3l9c >= worker2_maxRetry_t3l9c -> 1:(worker2'=worker2Fail);
  [worker2dot3l9bRetry] worker2=10 & worker2retry_t3l9b < worker2_maxRetry_t3l9b -> p_worker2_t3l9b : (worker2'=worker2+1) + (1-p_worker2_t3l9b) : (worker2'=worker2) & (worker2retry_t3l9b' = worker2retry_t3l9b+1);
  [worker2dot3l9b] worker2=10 & worker2retry_t3l9b >= worker2_maxRetry_t3l9b -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r1movel2] true:1;
  [r1movel3] true:1;
  [r1dot3l3] true:1;
  [r1dot3l3Retry] true:1;
  [r1movel6] true:1;
  [r1dot2l6b] true:1;
  [r1dot2l6bRetry] true:1;
  [r1dot2l6a] true:1;
  [r1dot2l6aRetry] true:1;
  [r2movel4] true:1;
  [r2movel7] true:1;
  [r2dot3l7] true:1;
  [r2dot3l7Retry] true:1;
  [r2movel8] true:1;
  [r2dot2l8] true:1;
  [r2dot2l8Retry] true:1;
  [worker2movel4] true:1;
  [worker2movel5] true:1;
  [worker2dot1l5] true:3;
  [worker2dot1l5Retry] true:3;
  [worker2movel6] true:1;
  [worker2dot1l6a] true:3;
  [worker2dot1l6aRetry] true:3;
  [worker2dot1l6b] true:3;
  [worker2dot1l6bRetry] true:3;
  [worker2movel9] true:1;
  [worker2dot1l9] true:3;
  [worker2dot1l9Retry] true:3;
  [worker2dot3l9a] true:5;
  [worker2dot3l9aRetry] true:5;
  [worker2dot3l9c] true:5;
  [worker2dot3l9cRetry] true:5;
  [worker2dot3l9b] true:5;
  [worker2dot3l9bRetry] true:5;
endrewards