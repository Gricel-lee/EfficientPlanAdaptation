dtmc
evolve int worker2_maxRetry_t3l4 [1..5];
evolve int worker2_maxRetry_t3l7a [1..5];
evolve int worker2_maxRetry_t1l7a [1..5];
evolve int worker2_maxRetry_t1l7c [1..5];
evolve int worker2_maxRetry_t1l7b [1..5];
evolve int worker2_maxRetry_t1l5 [1..5];
evolve int r1_maxRetry_t2l2 [1..10];
evolve int r1_maxRetry_t3l2 [1..10];
evolve int r1_maxRetry_t3l3 [1..10];
evolve int r1_maxRetry_t2l3 [1..10];
evolve int r2_maxRetry_t2l4 [1..10];
evolve int r2_maxRetry_t2l7 [1..10];
evolve int r2_maxRetry_t3l7b [1..10];

const double p_worker2_t3l4=0.99;
const double p_worker2_t3l7a=0.99;
const double p_worker2_t1l7a=1.0;
const double p_worker2_t1l7c=1.0;
const double p_worker2_t1l7b=1.0;
const double p_worker2_t1l5=1.0;
const double p_r1_t2l2=0.99;
const double p_r1_t3l2=0.97;
const double p_r1_t3l3=0.97;
const double p_r1_t2l3=0.99;
const double p_r2_t2l4=0.99;
const double p_r2_t2l7=0.99;
const double p_r2_t3l7b=0.97;
const int worker2Final = 10;
const int worker2Fail = 11;
const int r1Final = 6;
const int r1Fail = 7;
const int r2Final = 5;
const int r2Fail = 6;

module _worker2
  worker2 : [0..12];
  worker2retry_t3l4 : [0..worker2_maxRetry_t3l4] init 0;
  worker2retry_t3l7a : [0..worker2_maxRetry_t3l7a] init 0;
  worker2retry_t1l7a : [0..worker2_maxRetry_t1l7a] init 0;
  worker2retry_t1l7c : [0..worker2_maxRetry_t1l7c] init 0;
  worker2retry_t1l7b : [0..worker2_maxRetry_t1l7b] init 0;
  worker2retry_t1l5 : [0..worker2_maxRetry_t1l5] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2dot3l4Retry] worker2=1 & worker2retry_t3l4 < worker2_maxRetry_t3l4 -> p_worker2_t3l4 : (worker2'=worker2+1) + (1-p_worker2_t3l4) : (worker2'=worker2) & (worker2retry_t3l4' = worker2retry_t3l4+1);
  [worker2dot3l4] worker2=1 & worker2retry_t3l4 >= worker2_maxRetry_t3l4 -> 1:(worker2'=worker2Fail);
  [worker2movel7] worker2=2-> 1:(worker2'=2+1);
  [worker2dot3l7aRetry] worker2=3 & worker2retry_t3l7a < worker2_maxRetry_t3l7a -> p_worker2_t3l7a : (worker2'=worker2+1) + (1-p_worker2_t3l7a) : (worker2'=worker2) & (worker2retry_t3l7a' = worker2retry_t3l7a+1);
  [worker2dot3l7a] worker2=3 & worker2retry_t3l7a >= worker2_maxRetry_t3l7a -> 1:(worker2'=worker2Fail);
  [worker2dot1l7aRetry] worker2=4 & worker2retry_t1l7a < worker2_maxRetry_t1l7a -> p_worker2_t1l7a : (worker2'=worker2+1) + (1-p_worker2_t1l7a) : (worker2'=worker2) & (worker2retry_t1l7a' = worker2retry_t1l7a+1);
  [worker2dot1l7a] worker2=4 & worker2retry_t1l7a >= worker2_maxRetry_t1l7a -> 1:(worker2'=worker2Fail);
  [worker2dot1l7cRetry] worker2=5 & worker2retry_t1l7c < worker2_maxRetry_t1l7c -> p_worker2_t1l7c : (worker2'=worker2+1) + (1-p_worker2_t1l7c) : (worker2'=worker2) & (worker2retry_t1l7c' = worker2retry_t1l7c+1);
  [worker2dot1l7c] worker2=5 & worker2retry_t1l7c >= worker2_maxRetry_t1l7c -> 1:(worker2'=worker2Fail);
  [worker2dot1l7bRetry] worker2=6 & worker2retry_t1l7b < worker2_maxRetry_t1l7b -> p_worker2_t1l7b : (worker2'=worker2+1) + (1-p_worker2_t1l7b) : (worker2'=worker2) & (worker2retry_t1l7b' = worker2retry_t1l7b+1);
  [worker2dot1l7b] worker2=6 & worker2retry_t1l7b >= worker2_maxRetry_t1l7b -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=7-> 1:(worker2'=7+1);
  [worker2movel5] worker2=8-> 1:(worker2'=8+1);
  [worker2dot1l5Retry] worker2=9 & worker2retry_t1l5 < worker2_maxRetry_t1l5 -> p_worker2_t1l5 : (worker2'=worker2+1) + (1-p_worker2_t1l5) : (worker2'=worker2) & (worker2retry_t1l5' = worker2retry_t1l5+1);
  [worker2dot1l5] worker2=9 & worker2retry_t1l5 >= worker2_maxRetry_t1l5 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..8];
  r1retry_t2l2 : [0..r1_maxRetry_t2l2] init 0;
  r1retry_t3l2 : [0..r1_maxRetry_t3l2] init 0;
  r1retry_t3l3 : [0..r1_maxRetry_t3l3] init 0;
  r1retry_t2l3 : [0..r1_maxRetry_t2l3] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1dot2l2Retry] r1=1 & r1retry_t2l2 < r1_maxRetry_t2l2 -> p_r1_t2l2 : (r1'=r1+1) + (1-p_r1_t2l2) : (r1'=r1) & (r1retry_t2l2' = r1retry_t2l2+1);
  [r1dot2l2] r1=1 & r1retry_t2l2 >= r1_maxRetry_t2l2 -> 1:(r1'=r1Fail);
  [r1dot3l2Retry] r1=2 & r1retry_t3l2 < r1_maxRetry_t3l2 -> p_r1_t3l2 : (r1'=r1+1) + (1-p_r1_t3l2) : (r1'=r1) & (r1retry_t3l2' = r1retry_t3l2+1);
  [r1dot3l2] r1=2 & r1retry_t3l2 >= r1_maxRetry_t3l2 -> 1:(r1'=r1Fail);
  [r1movel3] r1=3-> 1:(r1'=3+1);
  [r1dot3l3Retry] r1=4 & r1retry_t3l3 < r1_maxRetry_t3l3 -> p_r1_t3l3 : (r1'=r1+1) + (1-p_r1_t3l3) : (r1'=r1) & (r1retry_t3l3' = r1retry_t3l3+1);
  [r1dot3l3] r1=4 & r1retry_t3l3 >= r1_maxRetry_t3l3 -> 1:(r1'=r1Fail);
  [r1dot2l3Retry] r1=5 & r1retry_t2l3 < r1_maxRetry_t2l3 -> p_r1_t2l3 : (r1'=r1+1) + (1-p_r1_t2l3) : (r1'=r1) & (r1retry_t2l3' = r1retry_t2l3+1);
  [r1dot2l3] r1=5 & r1retry_t2l3 >= r1_maxRetry_t2l3 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..7];
  r2retry_t2l4 : [0..r2_maxRetry_t2l4] init 0;
  r2retry_t2l7 : [0..r2_maxRetry_t2l7] init 0;
  r2retry_t3l7b : [0..r2_maxRetry_t3l7b] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2dot2l4Retry] r2=1 & r2retry_t2l4 < r2_maxRetry_t2l4 -> p_r2_t2l4 : (r2'=r2+1) + (1-p_r2_t2l4) : (r2'=r2) & (r2retry_t2l4' = r2retry_t2l4+1);
  [r2dot2l4] r2=1 & r2retry_t2l4 >= r2_maxRetry_t2l4 -> 1:(r2'=r2Fail);
  [r2movel7] r2=2-> 1:(r2'=2+1);
  [r2dot2l7Retry] r2=3 & r2retry_t2l7 < r2_maxRetry_t2l7 -> p_r2_t2l7 : (r2'=r2+1) + (1-p_r2_t2l7) : (r2'=r2) & (r2retry_t2l7' = r2retry_t2l7+1);
  [r2dot2l7] r2=3 & r2retry_t2l7 >= r2_maxRetry_t2l7 -> 1:(r2'=r2Fail);
  [r2dot3l7bRetry] r2=4 & r2retry_t3l7b < r2_maxRetry_t3l7b -> p_r2_t3l7b : (r2'=r2+1) + (1-p_r2_t3l7b) : (r2'=r2) & (r2retry_t3l7b' = r2retry_t3l7b+1);
  [r2dot3l7b] r2=4 & r2retry_t3l7b >= r2_maxRetry_t3l7b -> 1:(r2'=r2Fail);
endmodule

rewards "cost"
  [worker2movel4] true:1;
  [worker2dot3l4] true:5;
  [worker2dot3l4Retry] true:5;
  [worker2movel7] true:1;
  [worker2dot3l7a] true:5;
  [worker2dot3l7aRetry] true:5;
  [worker2dot1l7a] true:3;
  [worker2dot1l7aRetry] true:3;
  [worker2dot1l7c] true:3;
  [worker2dot1l7cRetry] true:3;
  [worker2dot1l7b] true:3;
  [worker2dot1l7bRetry] true:3;
  [worker2movel8] true:1;
  [worker2movel5] true:1;
  [worker2dot1l5] true:3;
  [worker2dot1l5Retry] true:3;
  [r1movel2] true:1;
  [r1dot2l2] true:1;
  [r1dot2l2Retry] true:1;
  [r1dot3l2] true:1;
  [r1dot3l2Retry] true:1;
  [r1movel3] true:1;
  [r1dot3l3] true:1;
  [r1dot3l3Retry] true:1;
  [r1dot2l3] true:1;
  [r1dot2l3Retry] true:1;
  [r2movel4] true:1;
  [r2dot2l4] true:1;
  [r2dot2l4Retry] true:1;
  [r2movel7] true:1;
  [r2dot2l7] true:1;
  [r2dot2l7Retry] true:1;
  [r2dot3l7b] true:1;
  [r2dot3l7bRetry] true:1;
endrewards