dtmc
evolve int r1_maxRetry_t2l2 [1..10];
evolve int r1_maxRetry_t2l3 [1..10];
evolve int r1_maxRetry_t2l9a [1..10];
evolve int r1_maxRetry_t2l9b [1..10];
evolve int r1_maxRetry_t2l8 [1..10];
evolve int r1_maxRetry_t3l7 [1..10];
evolve int r2_maxRetry_t3l1 [1..10];
evolve int r2_maxRetry_t2l1 [1..10];
evolve int worker1_maxRetry_t1l4 [1..5];
evolve int worker1_maxRetry_t1l5 [1..5];
evolve int worker1_maxRetry_t3l8 [1..5];
evolve int worker1_maxRetry_t1l8 [1..5];
evolve int worker1_maxRetry_t1l9 [1..5];

const double p_r1_t2l2=0.99;
const double p_r1_t2l3=0.99;
const double p_r1_t2l9a=0.99;
const double p_r1_t2l9b=0.99;
const double p_r1_t2l8=0.99;
const double p_r1_t3l7=0.97;
const double p_r2_t3l1=0.97;
const double p_r2_t2l1=0.99;
const double p_worker1_t1l4=1.0;
const double p_worker1_t1l5=1.0;
const double p_worker1_t3l8=0.99;
const double p_worker1_t1l8=1.0;
const double p_worker1_t1l9=1.0;
const int r1Final = 12;
const int r1Fail = 13;
const int r2Final = 2;
const int r2Fail = 3;
const int worker1Final = 9;
const int worker1Fail = 10;

module _r1
  r1 : [0..14];
  r1retry_t2l2 : [0..r1_maxRetry_t2l2] init 0;
  r1retry_t2l3 : [0..r1_maxRetry_t2l3] init 0;
  r1retry_t2l9a : [0..r1_maxRetry_t2l9a] init 0;
  r1retry_t2l9b : [0..r1_maxRetry_t2l9b] init 0;
  r1retry_t2l8 : [0..r1_maxRetry_t2l8] init 0;
  r1retry_t3l7 : [0..r1_maxRetry_t3l7] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1dot2l2Retry] r1=1 & r1retry_t2l2 < r1_maxRetry_t2l2 -> p_r1_t2l2 : (r1'=r1+1) + (1-p_r1_t2l2) : (r1'=r1) & (r1retry_t2l2' = r1retry_t2l2+1);
  [r1dot2l2] r1=1 & r1retry_t2l2 >= r1_maxRetry_t2l2 -> 1:(r1'=r1Fail);
  [r1movel3] r1=2-> 1:(r1'=2+1);
  [r1dot2l3Retry] r1=3 & r1retry_t2l3 < r1_maxRetry_t2l3 -> p_r1_t2l3 : (r1'=r1+1) + (1-p_r1_t2l3) : (r1'=r1) & (r1retry_t2l3' = r1retry_t2l3+1);
  [r1dot2l3] r1=3 & r1retry_t2l3 >= r1_maxRetry_t2l3 -> 1:(r1'=r1Fail);
  [r1movel6] r1=4-> 1:(r1'=4+1);
  [r1movel9] r1=5-> 1:(r1'=5+1);
  [r1dot2l9aRetry] r1=6 & r1retry_t2l9a < r1_maxRetry_t2l9a -> p_r1_t2l9a : (r1'=r1+1) + (1-p_r1_t2l9a) : (r1'=r1) & (r1retry_t2l9a' = r1retry_t2l9a+1);
  [r1dot2l9a] r1=6 & r1retry_t2l9a >= r1_maxRetry_t2l9a -> 1:(r1'=r1Fail);
  [r1dot2l9bRetry] r1=7 & r1retry_t2l9b < r1_maxRetry_t2l9b -> p_r1_t2l9b : (r1'=r1+1) + (1-p_r1_t2l9b) : (r1'=r1) & (r1retry_t2l9b' = r1retry_t2l9b+1);
  [r1dot2l9b] r1=7 & r1retry_t2l9b >= r1_maxRetry_t2l9b -> 1:(r1'=r1Fail);
  [r1movel8] r1=8-> 1:(r1'=8+1);
  [r1dot2l8Retry] r1=9 & r1retry_t2l8 < r1_maxRetry_t2l8 -> p_r1_t2l8 : (r1'=r1+1) + (1-p_r1_t2l8) : (r1'=r1) & (r1retry_t2l8' = r1retry_t2l8+1);
  [r1dot2l8] r1=9 & r1retry_t2l8 >= r1_maxRetry_t2l8 -> 1:(r1'=r1Fail);
  [r1movel7] r1=10-> 1:(r1'=10+1);
  [r1dot3l7Retry] r1=11 & r1retry_t3l7 < r1_maxRetry_t3l7 -> p_r1_t3l7 : (r1'=r1+1) + (1-p_r1_t3l7) : (r1'=r1) & (r1retry_t3l7' = r1retry_t3l7+1);
  [r1dot3l7] r1=11 & r1retry_t3l7 >= r1_maxRetry_t3l7 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..4];
  r2retry_t3l1 : [0..r2_maxRetry_t3l1] init 0;
  r2retry_t2l1 : [0..r2_maxRetry_t2l1] init 0;

  [r2dot3l1Retry] r2=0 & r2retry_t3l1 < r2_maxRetry_t3l1 -> p_r2_t3l1 : (r2'=r2+1) + (1-p_r2_t3l1) : (r2'=r2) & (r2retry_t3l1' = r2retry_t3l1+1);
  [r2dot3l1] r2=0 & r2retry_t3l1 >= r2_maxRetry_t3l1 -> 1:(r2'=r2Fail);
  [r2dot2l1Retry] r2=1 & r2retry_t2l1 < r2_maxRetry_t2l1 -> p_r2_t2l1 : (r2'=r2+1) + (1-p_r2_t2l1) : (r2'=r2) & (r2retry_t2l1' = r2retry_t2l1+1);
  [r2dot2l1] r2=1 & r2retry_t2l1 >= r2_maxRetry_t2l1 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..11];
  worker1retry_t1l4 : [0..worker1_maxRetry_t1l4] init 0;
  worker1retry_t1l5 : [0..worker1_maxRetry_t1l5] init 0;
  worker1retry_t3l8 : [0..worker1_maxRetry_t3l8] init 0;
  worker1retry_t1l8 : [0..worker1_maxRetry_t1l8] init 0;
  worker1retry_t1l9 : [0..worker1_maxRetry_t1l9] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l4Retry] worker1=1 & worker1retry_t1l4 < worker1_maxRetry_t1l4 -> p_worker1_t1l4 : (worker1'=worker1+1) + (1-p_worker1_t1l4) : (worker1'=worker1) & (worker1retry_t1l4' = worker1retry_t1l4+1);
  [worker1dot1l4] worker1=1 & worker1retry_t1l4 >= worker1_maxRetry_t1l4 -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=2-> 1:(worker1'=2+1);
  [worker1dot1l5Retry] worker1=3 & worker1retry_t1l5 < worker1_maxRetry_t1l5 -> p_worker1_t1l5 : (worker1'=worker1+1) + (1-p_worker1_t1l5) : (worker1'=worker1) & (worker1retry_t1l5' = worker1retry_t1l5+1);
  [worker1dot1l5] worker1=3 & worker1retry_t1l5 >= worker1_maxRetry_t1l5 -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=4-> 1:(worker1'=4+1);
  [worker1dot3l8Retry] worker1=5 & worker1retry_t3l8 < worker1_maxRetry_t3l8 -> p_worker1_t3l8 : (worker1'=worker1+1) + (1-p_worker1_t3l8) : (worker1'=worker1) & (worker1retry_t3l8' = worker1retry_t3l8+1);
  [worker1dot3l8] worker1=5 & worker1retry_t3l8 >= worker1_maxRetry_t3l8 -> 1:(worker1'=worker1Fail);
  [worker1dot1l8Retry] worker1=6 & worker1retry_t1l8 < worker1_maxRetry_t1l8 -> p_worker1_t1l8 : (worker1'=worker1+1) + (1-p_worker1_t1l8) : (worker1'=worker1) & (worker1retry_t1l8' = worker1retry_t1l8+1);
  [worker1dot1l8] worker1=6 & worker1retry_t1l8 >= worker1_maxRetry_t1l8 -> 1:(worker1'=worker1Fail);
  [worker1movel9] worker1=7-> 1:(worker1'=7+1);
  [worker1dot1l9Retry] worker1=8 & worker1retry_t1l9 < worker1_maxRetry_t1l9 -> p_worker1_t1l9 : (worker1'=worker1+1) + (1-p_worker1_t1l9) : (worker1'=worker1) & (worker1retry_t1l9' = worker1retry_t1l9+1);
  [worker1dot1l9] worker1=8 & worker1retry_t1l9 >= worker1_maxRetry_t1l9 -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [r1movel2] true:1;
  [r1dot2l2] true:1;
  [r1dot2l2Retry] true:1;
  [r1movel3] true:1;
  [r1dot2l3] true:1;
  [r1dot2l3Retry] true:1;
  [r1movel6] true:1;
  [r1movel9] true:1;
  [r1dot2l9a] true:1;
  [r1dot2l9aRetry] true:1;
  [r1dot2l9b] true:1;
  [r1dot2l9bRetry] true:1;
  [r1movel8] true:1;
  [r1dot2l8] true:1;
  [r1dot2l8Retry] true:1;
  [r1movel7] true:1;
  [r1dot3l7] true:1;
  [r1dot3l7Retry] true:1;
  [r2dot3l1] true:1;
  [r2dot3l1Retry] true:1;
  [r2dot2l1] true:1;
  [r2dot2l1Retry] true:1;
  [worker1movel4] true:1;
  [worker1dot1l4] true:3;
  [worker1dot1l4Retry] true:3;
  [worker1movel5] true:1;
  [worker1dot1l5] true:3;
  [worker1dot1l5Retry] true:3;
  [worker1movel8] true:1;
  [worker1dot3l8] true:5;
  [worker1dot3l8Retry] true:5;
  [worker1dot1l8] true:3;
  [worker1dot1l8Retry] true:3;
  [worker1movel9] true:1;
  [worker1dot1l9] true:3;
  [worker1dot1l9Retry] true:3;
endrewards