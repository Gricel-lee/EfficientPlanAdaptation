dtmc
evolve int r2_maxRetry_t2l7 [1..10];
evolve int r2_maxRetry_t2l5 [1..10];
evolve int r2_maxRetry_t3l5 [1..10];
evolve int r2_maxRetry_t2l6b [1..10];
evolve int r2_maxRetry_t2l6a [1..10];
evolve int worker1_maxRetry_t1l7 [1..5];
evolve int worker1_maxRetry_t3l7 [1..5];
evolve int worker2_maxRetry_t3l2 [1..5];
evolve int worker2_maxRetry_t1l3 [1..5];
evolve int worker2_maxRetry_t1l9 [1..5];
evolve int r1_maxRetry_t2l1 [1..10];

const double p_r2_t2l7=0.99;
const double p_r2_t2l5=0.99;
const double p_r2_t3l5=0.97;
const double p_r2_t2l6b=0.99;
const double p_r2_t2l6a=0.99;
const double p_worker1_t1l7=1.0;
const double p_worker1_t3l7=0.99;
const double p_worker2_t3l2=0.99;
const double p_worker2_t1l3=1.0;
const double p_worker2_t1l9=1.0;
const double p_r1_t2l1=0.99;
const int r2Final = 10;
const int r2Fail = 11;
const int worker1Final = 4;
const int worker1Fail = 5;
const int worker2Final = 7;
const int worker2Fail = 8;
const int r1Final = 1;
const int r1Fail = 2;

module _r2
  r2 : [0..12];
  r2retry_t2l7 : [0..r2_maxRetry_t2l7] init 0;
  r2retry_t2l5 : [0..r2_maxRetry_t2l5] init 0;
  r2retry_t3l5 : [0..r2_maxRetry_t3l5] init 0;
  r2retry_t2l6b : [0..r2_maxRetry_t2l6b] init 0;
  r2retry_t2l6a : [0..r2_maxRetry_t2l6a] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2movel7] r2=1-> 1:(r2'=1+1);
  [r2dot2l7Retry] r2=2 & r2retry_t2l7 < r2_maxRetry_t2l7 -> p_r2_t2l7 : (r2'=r2+1) + (1-p_r2_t2l7) : (r2'=r2) & (r2retry_t2l7' = r2retry_t2l7+1);
  [r2dot2l7] r2=2 & r2retry_t2l7 >= r2_maxRetry_t2l7 -> 1:(r2'=r2Fail);
  [r2movel8] r2=3-> 1:(r2'=3+1);
  [r2movel5] r2=4-> 1:(r2'=4+1);
  [r2dot2l5Retry] r2=5 & r2retry_t2l5 < r2_maxRetry_t2l5 -> p_r2_t2l5 : (r2'=r2+1) + (1-p_r2_t2l5) : (r2'=r2) & (r2retry_t2l5' = r2retry_t2l5+1);
  [r2dot2l5] r2=5 & r2retry_t2l5 >= r2_maxRetry_t2l5 -> 1:(r2'=r2Fail);
  [r2dot3l5Retry] r2=6 & r2retry_t3l5 < r2_maxRetry_t3l5 -> p_r2_t3l5 : (r2'=r2+1) + (1-p_r2_t3l5) : (r2'=r2) & (r2retry_t3l5' = r2retry_t3l5+1);
  [r2dot3l5] r2=6 & r2retry_t3l5 >= r2_maxRetry_t3l5 -> 1:(r2'=r2Fail);
  [r2movel6] r2=7-> 1:(r2'=7+1);
  [r2dot2l6bRetry] r2=8 & r2retry_t2l6b < r2_maxRetry_t2l6b -> p_r2_t2l6b : (r2'=r2+1) + (1-p_r2_t2l6b) : (r2'=r2) & (r2retry_t2l6b' = r2retry_t2l6b+1);
  [r2dot2l6b] r2=8 & r2retry_t2l6b >= r2_maxRetry_t2l6b -> 1:(r2'=r2Fail);
  [r2dot2l6aRetry] r2=9 & r2retry_t2l6a < r2_maxRetry_t2l6a -> p_r2_t2l6a : (r2'=r2+1) + (1-p_r2_t2l6a) : (r2'=r2) & (r2retry_t2l6a' = r2retry_t2l6a+1);
  [r2dot2l6a] r2=9 & r2retry_t2l6a >= r2_maxRetry_t2l6a -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..6];
  worker1retry_t1l7 : [0..worker1_maxRetry_t1l7] init 0;
  worker1retry_t3l7 : [0..worker1_maxRetry_t3l7] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1movel7] worker1=1-> 1:(worker1'=1+1);
  [worker1dot1l7Retry] worker1=2 & worker1retry_t1l7 < worker1_maxRetry_t1l7 -> p_worker1_t1l7 : (worker1'=worker1+1) + (1-p_worker1_t1l7) : (worker1'=worker1) & (worker1retry_t1l7' = worker1retry_t1l7+1);
  [worker1dot1l7] worker1=2 & worker1retry_t1l7 >= worker1_maxRetry_t1l7 -> 1:(worker1'=worker1Fail);
  [worker1dot3l7Retry] worker1=3 & worker1retry_t3l7 < worker1_maxRetry_t3l7 -> p_worker1_t3l7 : (worker1'=worker1+1) + (1-p_worker1_t3l7) : (worker1'=worker1) & (worker1retry_t3l7' = worker1retry_t3l7+1);
  [worker1dot3l7] worker1=3 & worker1retry_t3l7 >= worker1_maxRetry_t3l7 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..9];
  worker2retry_t3l2 : [0..worker2_maxRetry_t3l2] init 0;
  worker2retry_t1l3 : [0..worker2_maxRetry_t1l3] init 0;
  worker2retry_t1l9 : [0..worker2_maxRetry_t1l9] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot3l2Retry] worker2=1 & worker2retry_t3l2 < worker2_maxRetry_t3l2 -> p_worker2_t3l2 : (worker2'=worker2+1) + (1-p_worker2_t3l2) : (worker2'=worker2) & (worker2retry_t3l2' = worker2retry_t3l2+1);
  [worker2dot3l2] worker2=1 & worker2retry_t3l2 >= worker2_maxRetry_t3l2 -> 1:(worker2'=worker2Fail);
  [worker2movel3] worker2=2-> 1:(worker2'=2+1);
  [worker2dot1l3Retry] worker2=3 & worker2retry_t1l3 < worker2_maxRetry_t1l3 -> p_worker2_t1l3 : (worker2'=worker2+1) + (1-p_worker2_t1l3) : (worker2'=worker2) & (worker2retry_t1l3' = worker2retry_t1l3+1);
  [worker2dot1l3] worker2=3 & worker2retry_t1l3 >= worker2_maxRetry_t1l3 -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=4-> 1:(worker2'=4+1);
  [worker2movel9] worker2=5-> 1:(worker2'=5+1);
  [worker2dot1l9Retry] worker2=6 & worker2retry_t1l9 < worker2_maxRetry_t1l9 -> p_worker2_t1l9 : (worker2'=worker2+1) + (1-p_worker2_t1l9) : (worker2'=worker2) & (worker2retry_t1l9' = worker2retry_t1l9+1);
  [worker2dot1l9] worker2=6 & worker2retry_t1l9 >= worker2_maxRetry_t1l9 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..3];
  r1retry_t2l1 : [0..r1_maxRetry_t2l1] init 0;

  [r1dot2l1Retry] r1=0 & r1retry_t2l1 < r1_maxRetry_t2l1 -> p_r1_t2l1 : (r1'=r1+1) + (1-p_r1_t2l1) : (r1'=r1) & (r1retry_t2l1' = r1retry_t2l1+1);
  [r1dot2l1] r1=0 & r1retry_t2l1 >= r1_maxRetry_t2l1 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [r2movel4] true:1;
  [r2movel7] true:1;
  [r2dot2l7] true:1;
  [r2dot2l7Retry] true:1;
  [r2movel8] true:1;
  [r2movel5] true:1;
  [r2dot2l5] true:1;
  [r2dot2l5Retry] true:1;
  [r2dot3l5] true:1;
  [r2dot3l5Retry] true:1;
  [r2movel6] true:1;
  [r2dot2l6b] true:1;
  [r2dot2l6bRetry] true:1;
  [r2dot2l6a] true:1;
  [r2dot2l6aRetry] true:1;
  [worker1movel4] true:1;
  [worker1movel7] true:1;
  [worker1dot1l7] true:3;
  [worker1dot1l7Retry] true:3;
  [worker1dot3l7] true:5;
  [worker1dot3l7Retry] true:5;
  [worker2movel2] true:1;
  [worker2dot3l2] true:5;
  [worker2dot3l2Retry] true:5;
  [worker2movel3] true:1;
  [worker2dot1l3] true:3;
  [worker2dot1l3Retry] true:3;
  [worker2movel6] true:1;
  [worker2movel9] true:1;
  [worker2dot1l9] true:3;
  [worker2dot1l9Retry] true:3;
  [r1dot2l1] true:1;
  [r1dot2l1Retry] true:1;
endrewards