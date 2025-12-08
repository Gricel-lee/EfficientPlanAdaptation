dtmc
evolve int r1_maxRetry_t2l2 [1..10];
evolve int r1_maxRetry_t3l3 [1..10];
evolve int r1_maxRetry_t2l3 [1..10];
evolve int r1_maxRetry_t3l6 [1..10];
evolve int r1_maxRetry_t2l9a [1..10];
evolve int r1_maxRetry_t2l9b [1..10];
evolve int r1_maxRetry_t2l9c [1..10];
evolve int r2_maxRetry_t2l4 [1..10];
evolve int r2_maxRetry_t2l7a [1..10];
evolve int r2_maxRetry_t2l7b [1..10];
evolve int r2_maxRetry_t2l5 [1..10];
evolve int worker2_maxRetry_t1l6 [1..5];

const double p_r1_t2l2=0.99;
const double p_r1_t3l3=0.97;
const double p_r1_t2l3=0.99;
const double p_r1_t3l6=0.97;
const double p_r1_t2l9a=0.99;
const double p_r1_t2l9b=0.99;
const double p_r1_t2l9c=0.99;
const double p_r2_t2l4=0.99;
const double p_r2_t2l7a=0.99;
const double p_r2_t2l7b=0.99;
const double p_r2_t2l5=0.99;
const double p_worker2_t1l6=1.0;
const int r1Final = 11;
const int r1Fail = 12;
const int r2Final = 8;
const int r2Fail = 9;
const int worker2Final = 4;
const int worker2Fail = 5;

module _r1
  r1 : [0..13];
  r1retry_t2l2 : [0..r1_maxRetry_t2l2] init 0;
  r1retry_t3l3 : [0..r1_maxRetry_t3l3] init 0;
  r1retry_t2l3 : [0..r1_maxRetry_t2l3] init 0;
  r1retry_t3l6 : [0..r1_maxRetry_t3l6] init 0;
  r1retry_t2l9a : [0..r1_maxRetry_t2l9a] init 0;
  r1retry_t2l9b : [0..r1_maxRetry_t2l9b] init 0;
  r1retry_t2l9c : [0..r1_maxRetry_t2l9c] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1dot2l2Retry] r1=1 & r1retry_t2l2 < r1_maxRetry_t2l2 -> p_r1_t2l2 : (r1'=r1+1) + (1-p_r1_t2l2) : (r1'=r1) & (r1retry_t2l2' = r1retry_t2l2+1);
  [r1dot2l2] r1=1 & r1retry_t2l2 >= r1_maxRetry_t2l2 -> 1:(r1'=r1Fail);
  [r1movel3] r1=2-> 1:(r1'=2+1);
  [r1dot3l3Retry] r1=3 & r1retry_t3l3 < r1_maxRetry_t3l3 -> p_r1_t3l3 : (r1'=r1+1) + (1-p_r1_t3l3) : (r1'=r1) & (r1retry_t3l3' = r1retry_t3l3+1);
  [r1dot3l3] r1=3 & r1retry_t3l3 >= r1_maxRetry_t3l3 -> 1:(r1'=r1Fail);
  [r1dot2l3Retry] r1=4 & r1retry_t2l3 < r1_maxRetry_t2l3 -> p_r1_t2l3 : (r1'=r1+1) + (1-p_r1_t2l3) : (r1'=r1) & (r1retry_t2l3' = r1retry_t2l3+1);
  [r1dot2l3] r1=4 & r1retry_t2l3 >= r1_maxRetry_t2l3 -> 1:(r1'=r1Fail);
  [r1movel6] r1=5-> 1:(r1'=5+1);
  [r1dot3l6Retry] r1=6 & r1retry_t3l6 < r1_maxRetry_t3l6 -> p_r1_t3l6 : (r1'=r1+1) + (1-p_r1_t3l6) : (r1'=r1) & (r1retry_t3l6' = r1retry_t3l6+1);
  [r1dot3l6] r1=6 & r1retry_t3l6 >= r1_maxRetry_t3l6 -> 1:(r1'=r1Fail);
  [r1movel9] r1=7-> 1:(r1'=7+1);
  [r1dot2l9aRetry] r1=8 & r1retry_t2l9a < r1_maxRetry_t2l9a -> p_r1_t2l9a : (r1'=r1+1) + (1-p_r1_t2l9a) : (r1'=r1) & (r1retry_t2l9a' = r1retry_t2l9a+1);
  [r1dot2l9a] r1=8 & r1retry_t2l9a >= r1_maxRetry_t2l9a -> 1:(r1'=r1Fail);
  [r1dot2l9bRetry] r1=9 & r1retry_t2l9b < r1_maxRetry_t2l9b -> p_r1_t2l9b : (r1'=r1+1) + (1-p_r1_t2l9b) : (r1'=r1) & (r1retry_t2l9b' = r1retry_t2l9b+1);
  [r1dot2l9b] r1=9 & r1retry_t2l9b >= r1_maxRetry_t2l9b -> 1:(r1'=r1Fail);
  [r1dot2l9cRetry] r1=10 & r1retry_t2l9c < r1_maxRetry_t2l9c -> p_r1_t2l9c : (r1'=r1+1) + (1-p_r1_t2l9c) : (r1'=r1) & (r1retry_t2l9c' = r1retry_t2l9c+1);
  [r1dot2l9c] r1=10 & r1retry_t2l9c >= r1_maxRetry_t2l9c -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..10];
  r2retry_t2l4 : [0..r2_maxRetry_t2l4] init 0;
  r2retry_t2l7a : [0..r2_maxRetry_t2l7a] init 0;
  r2retry_t2l7b : [0..r2_maxRetry_t2l7b] init 0;
  r2retry_t2l5 : [0..r2_maxRetry_t2l5] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2dot2l4Retry] r2=1 & r2retry_t2l4 < r2_maxRetry_t2l4 -> p_r2_t2l4 : (r2'=r2+1) + (1-p_r2_t2l4) : (r2'=r2) & (r2retry_t2l4' = r2retry_t2l4+1);
  [r2dot2l4] r2=1 & r2retry_t2l4 >= r2_maxRetry_t2l4 -> 1:(r2'=r2Fail);
  [r2movel7] r2=2-> 1:(r2'=2+1);
  [r2dot2l7aRetry] r2=3 & r2retry_t2l7a < r2_maxRetry_t2l7a -> p_r2_t2l7a : (r2'=r2+1) + (1-p_r2_t2l7a) : (r2'=r2) & (r2retry_t2l7a' = r2retry_t2l7a+1);
  [r2dot2l7a] r2=3 & r2retry_t2l7a >= r2_maxRetry_t2l7a -> 1:(r2'=r2Fail);
  [r2dot2l7bRetry] r2=4 & r2retry_t2l7b < r2_maxRetry_t2l7b -> p_r2_t2l7b : (r2'=r2+1) + (1-p_r2_t2l7b) : (r2'=r2) & (r2retry_t2l7b' = r2retry_t2l7b+1);
  [r2dot2l7b] r2=4 & r2retry_t2l7b >= r2_maxRetry_t2l7b -> 1:(r2'=r2Fail);
  [r2movel8] r2=5-> 1:(r2'=5+1);
  [r2movel5] r2=6-> 1:(r2'=6+1);
  [r2dot2l5Retry] r2=7 & r2retry_t2l5 < r2_maxRetry_t2l5 -> p_r2_t2l5 : (r2'=r2+1) + (1-p_r2_t2l5) : (r2'=r2) & (r2retry_t2l5' = r2retry_t2l5+1);
  [r2dot2l5] r2=7 & r2retry_t2l5 >= r2_maxRetry_t2l5 -> 1:(r2'=r2Fail);
endmodule

module _worker2
  worker2 : [0..6];
  worker2retry_t1l6 : [0..worker2_maxRetry_t1l6] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2movel3] worker2=1-> 1:(worker2'=1+1);
  [worker2movel6] worker2=2-> 1:(worker2'=2+1);
  [worker2dot1l6Retry] worker2=3 & worker2retry_t1l6 < worker2_maxRetry_t1l6 -> p_worker2_t1l6 : (worker2'=worker2+1) + (1-p_worker2_t1l6) : (worker2'=worker2) & (worker2retry_t1l6' = worker2retry_t1l6+1);
  [worker2dot1l6] worker2=3 & worker2retry_t1l6 >= worker2_maxRetry_t1l6 -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r1movel2] true:1;
  [r1dot2l2] true:1;
  [r1dot2l2Retry] true:1;
  [r1movel3] true:1;
  [r1dot3l3] true:1;
  [r1dot3l3Retry] true:1;
  [r1dot2l3] true:1;
  [r1dot2l3Retry] true:1;
  [r1movel6] true:1;
  [r1dot3l6] true:1;
  [r1dot3l6Retry] true:1;
  [r1movel9] true:1;
  [r1dot2l9a] true:1;
  [r1dot2l9aRetry] true:1;
  [r1dot2l9b] true:1;
  [r1dot2l9bRetry] true:1;
  [r1dot2l9c] true:1;
  [r1dot2l9cRetry] true:1;
  [r2movel4] true:1;
  [r2dot2l4] true:1;
  [r2dot2l4Retry] true:1;
  [r2movel7] true:1;
  [r2dot2l7a] true:1;
  [r2dot2l7aRetry] true:1;
  [r2dot2l7b] true:1;
  [r2dot2l7bRetry] true:1;
  [r2movel8] true:1;
  [r2movel5] true:1;
  [r2dot2l5] true:1;
  [r2dot2l5Retry] true:1;
  [worker2movel2] true:1;
  [worker2movel3] true:1;
  [worker2movel6] true:1;
  [worker2dot1l6] true:3;
  [worker2dot1l6Retry] true:3;
endrewards