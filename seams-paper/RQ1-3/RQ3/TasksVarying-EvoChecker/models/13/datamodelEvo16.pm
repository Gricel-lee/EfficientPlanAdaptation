dtmc
evolve int worker2_maxRetry_t1l4 [1..5];
evolve int worker2_maxRetry_t1l7 [1..5];
evolve int worker2_maxRetry_t1l8 [1..5];
evolve int worker2_maxRetry_t3l8 [1..5];
evolve int r1_maxRetry_t2l4 [1..10];
evolve int r1_maxRetry_t3l5 [1..10];
evolve int r1_maxRetry_t2l8 [1..10];
evolve int r1_maxRetry_t2l9 [1..10];
evolve int r1_maxRetry_t3l9 [1..10];
evolve int r2_maxRetry_t3l2a [1..10];
evolve int r2_maxRetry_t3l2b [1..10];
evolve int r2_maxRetry_t2l3 [1..10];
evolve int worker1_maxRetry_t3l1 [1..5];

const double p_worker2_t1l4=1.0;
const double p_worker2_t1l7=1.0;
const double p_worker2_t1l8=1.0;
const double p_worker2_t3l8=0.99;
const double p_r1_t2l4=0.99;
const double p_r1_t3l5=0.97;
const double p_r1_t2l8=0.99;
const double p_r1_t2l9=0.99;
const double p_r1_t3l9=0.97;
const double p_r2_t3l2a=0.97;
const double p_r2_t3l2b=0.97;
const double p_r2_t2l3=0.99;
const double p_worker1_t3l1=0.99;
const int worker2Final = 7;
const int worker2Fail = 8;
const int r1Final = 9;
const int r1Fail = 10;
const int r2Final = 5;
const int r2Fail = 6;
const int worker1Final = 1;
const int worker1Fail = 2;

module _worker2
  worker2 : [0..9];
  worker2retry_t1l4 : [0..worker2_maxRetry_t1l4] init 0;
  worker2retry_t1l7 : [0..worker2_maxRetry_t1l7] init 0;
  worker2retry_t1l8 : [0..worker2_maxRetry_t1l8] init 0;
  worker2retry_t3l8 : [0..worker2_maxRetry_t3l8] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l4Retry] worker2=1 & worker2retry_t1l4 < worker2_maxRetry_t1l4 -> p_worker2_t1l4 : (worker2'=worker2+1) + (1-p_worker2_t1l4) : (worker2'=worker2) & (worker2retry_t1l4' = worker2retry_t1l4+1);
  [worker2dot1l4] worker2=1 & worker2retry_t1l4 >= worker2_maxRetry_t1l4 -> 1:(worker2'=worker2Fail);
  [worker2movel7] worker2=2-> 1:(worker2'=2+1);
  [worker2dot1l7Retry] worker2=3 & worker2retry_t1l7 < worker2_maxRetry_t1l7 -> p_worker2_t1l7 : (worker2'=worker2+1) + (1-p_worker2_t1l7) : (worker2'=worker2) & (worker2retry_t1l7' = worker2retry_t1l7+1);
  [worker2dot1l7] worker2=3 & worker2retry_t1l7 >= worker2_maxRetry_t1l7 -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=4-> 1:(worker2'=4+1);
  [worker2dot1l8Retry] worker2=5 & worker2retry_t1l8 < worker2_maxRetry_t1l8 -> p_worker2_t1l8 : (worker2'=worker2+1) + (1-p_worker2_t1l8) : (worker2'=worker2) & (worker2retry_t1l8' = worker2retry_t1l8+1);
  [worker2dot1l8] worker2=5 & worker2retry_t1l8 >= worker2_maxRetry_t1l8 -> 1:(worker2'=worker2Fail);
  [worker2dot3l8Retry] worker2=6 & worker2retry_t3l8 < worker2_maxRetry_t3l8 -> p_worker2_t3l8 : (worker2'=worker2+1) + (1-p_worker2_t3l8) : (worker2'=worker2) & (worker2retry_t3l8' = worker2retry_t3l8+1);
  [worker2dot3l8] worker2=6 & worker2retry_t3l8 >= worker2_maxRetry_t3l8 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..11];
  r1retry_t2l4 : [0..r1_maxRetry_t2l4] init 0;
  r1retry_t3l5 : [0..r1_maxRetry_t3l5] init 0;
  r1retry_t2l8 : [0..r1_maxRetry_t2l8] init 0;
  r1retry_t2l9 : [0..r1_maxRetry_t2l9] init 0;
  r1retry_t3l9 : [0..r1_maxRetry_t3l9] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1dot2l4Retry] r1=1 & r1retry_t2l4 < r1_maxRetry_t2l4 -> p_r1_t2l4 : (r1'=r1+1) + (1-p_r1_t2l4) : (r1'=r1) & (r1retry_t2l4' = r1retry_t2l4+1);
  [r1dot2l4] r1=1 & r1retry_t2l4 >= r1_maxRetry_t2l4 -> 1:(r1'=r1Fail);
  [r1movel5] r1=2-> 1:(r1'=2+1);
  [r1dot3l5Retry] r1=3 & r1retry_t3l5 < r1_maxRetry_t3l5 -> p_r1_t3l5 : (r1'=r1+1) + (1-p_r1_t3l5) : (r1'=r1) & (r1retry_t3l5' = r1retry_t3l5+1);
  [r1dot3l5] r1=3 & r1retry_t3l5 >= r1_maxRetry_t3l5 -> 1:(r1'=r1Fail);
  [r1movel8] r1=4-> 1:(r1'=4+1);
  [r1dot2l8Retry] r1=5 & r1retry_t2l8 < r1_maxRetry_t2l8 -> p_r1_t2l8 : (r1'=r1+1) + (1-p_r1_t2l8) : (r1'=r1) & (r1retry_t2l8' = r1retry_t2l8+1);
  [r1dot2l8] r1=5 & r1retry_t2l8 >= r1_maxRetry_t2l8 -> 1:(r1'=r1Fail);
  [r1movel9] r1=6-> 1:(r1'=6+1);
  [r1dot2l9Retry] r1=7 & r1retry_t2l9 < r1_maxRetry_t2l9 -> p_r1_t2l9 : (r1'=r1+1) + (1-p_r1_t2l9) : (r1'=r1) & (r1retry_t2l9' = r1retry_t2l9+1);
  [r1dot2l9] r1=7 & r1retry_t2l9 >= r1_maxRetry_t2l9 -> 1:(r1'=r1Fail);
  [r1dot3l9Retry] r1=8 & r1retry_t3l9 < r1_maxRetry_t3l9 -> p_r1_t3l9 : (r1'=r1+1) + (1-p_r1_t3l9) : (r1'=r1) & (r1retry_t3l9' = r1retry_t3l9+1);
  [r1dot3l9] r1=8 & r1retry_t3l9 >= r1_maxRetry_t3l9 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..7];
  r2retry_t3l2a : [0..r2_maxRetry_t3l2a] init 0;
  r2retry_t3l2b : [0..r2_maxRetry_t3l2b] init 0;
  r2retry_t2l3 : [0..r2_maxRetry_t2l3] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2dot3l2aRetry] r2=1 & r2retry_t3l2a < r2_maxRetry_t3l2a -> p_r2_t3l2a : (r2'=r2+1) + (1-p_r2_t3l2a) : (r2'=r2) & (r2retry_t3l2a' = r2retry_t3l2a+1);
  [r2dot3l2a] r2=1 & r2retry_t3l2a >= r2_maxRetry_t3l2a -> 1:(r2'=r2Fail);
  [r2dot3l2bRetry] r2=2 & r2retry_t3l2b < r2_maxRetry_t3l2b -> p_r2_t3l2b : (r2'=r2+1) + (1-p_r2_t3l2b) : (r2'=r2) & (r2retry_t3l2b' = r2retry_t3l2b+1);
  [r2dot3l2b] r2=2 & r2retry_t3l2b >= r2_maxRetry_t3l2b -> 1:(r2'=r2Fail);
  [r2movel3] r2=3-> 1:(r2'=3+1);
  [r2dot2l3Retry] r2=4 & r2retry_t2l3 < r2_maxRetry_t2l3 -> p_r2_t2l3 : (r2'=r2+1) + (1-p_r2_t2l3) : (r2'=r2) & (r2retry_t2l3' = r2retry_t2l3+1);
  [r2dot2l3] r2=4 & r2retry_t2l3 >= r2_maxRetry_t2l3 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..3];
  worker1retry_t3l1 : [0..worker1_maxRetry_t3l1] init 0;

  [worker1dot3l1Retry] worker1=0 & worker1retry_t3l1 < worker1_maxRetry_t3l1 -> p_worker1_t3l1 : (worker1'=worker1+1) + (1-p_worker1_t3l1) : (worker1'=worker1) & (worker1retry_t3l1' = worker1retry_t3l1+1);
  [worker1dot3l1] worker1=0 & worker1retry_t3l1 >= worker1_maxRetry_t3l1 -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [worker2movel4] true:1;
  [worker2dot1l4] true:3;
  [worker2dot1l4Retry] true:3;
  [worker2movel7] true:1;
  [worker2dot1l7] true:3;
  [worker2dot1l7Retry] true:3;
  [worker2movel8] true:1;
  [worker2dot1l8] true:3;
  [worker2dot1l8Retry] true:3;
  [worker2dot3l8] true:5;
  [worker2dot3l8Retry] true:5;
  [r1movel4] true:1;
  [r1dot2l4] true:1;
  [r1dot2l4Retry] true:1;
  [r1movel5] true:1;
  [r1dot3l5] true:1;
  [r1dot3l5Retry] true:1;
  [r1movel8] true:1;
  [r1dot2l8] true:1;
  [r1dot2l8Retry] true:1;
  [r1movel9] true:1;
  [r1dot2l9] true:1;
  [r1dot2l9Retry] true:1;
  [r1dot3l9] true:1;
  [r1dot3l9Retry] true:1;
  [r2movel2] true:1;
  [r2dot3l2a] true:1;
  [r2dot3l2aRetry] true:1;
  [r2dot3l2b] true:1;
  [r2dot3l2bRetry] true:1;
  [r2movel3] true:1;
  [r2dot2l3] true:1;
  [r2dot2l3Retry] true:1;
  [worker1dot3l1] true:5;
  [worker1dot3l1Retry] true:5;
endrewards