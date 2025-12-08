dtmc
evolve int r1_maxRetry_t3l6b [1..10];
evolve int r1_maxRetry_t2l6 [1..10];
evolve int r1_maxRetry_t3l6a [1..10];
evolve int r1_maxRetry_t2l9 [1..10];
evolve int r1_maxRetry_t2l8 [1..10];
evolve int r2_maxRetry_t3l1 [1..10];
evolve int r2_maxRetry_t2l1 [1..10];
evolve int worker1_maxRetry_t1l1 [1..5];
evolve int worker1_maxRetry_t1l5 [1..5];
evolve int worker1_maxRetry_t3l5 [1..5];
evolve int worker2_maxRetry_t3l4 [1..5];
evolve int worker2_maxRetry_t1l7 [1..5];

const double p_r1_t3l6b=0.97;
const double p_r1_t2l6=0.99;
const double p_r1_t3l6a=0.97;
const double p_r1_t2l9=0.99;
const double p_r1_t2l8=0.99;
const double p_r2_t3l1=0.97;
const double p_r2_t2l1=0.99;
const double p_worker1_t1l1=1.0;
const double p_worker1_t1l5=1.0;
const double p_worker1_t3l5=0.99;
const double p_worker2_t3l4=0.99;
const double p_worker2_t1l7=1.0;
const int r1Final = 10;
const int r1Fail = 11;
const int r2Final = 2;
const int r2Fail = 3;
const int worker1Final = 5;
const int worker1Fail = 6;
const int worker2Final = 4;
const int worker2Fail = 5;

module _r1
  r1 : [0..12];
  r1retry_t3l6b : [0..r1_maxRetry_t3l6b] init 0;
  r1retry_t2l6 : [0..r1_maxRetry_t2l6] init 0;
  r1retry_t3l6a : [0..r1_maxRetry_t3l6a] init 0;
  r1retry_t2l9 : [0..r1_maxRetry_t2l9] init 0;
  r1retry_t2l8 : [0..r1_maxRetry_t2l8] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1movel5] r1=1-> 1:(r1'=1+1);
  [r1movel6] r1=2-> 1:(r1'=2+1);
  [r1dot3l6bRetry] r1=3 & r1retry_t3l6b < r1_maxRetry_t3l6b -> p_r1_t3l6b : (r1'=r1+1) + (1-p_r1_t3l6b) : (r1'=r1) & (r1retry_t3l6b' = r1retry_t3l6b+1);
  [r1dot3l6b] r1=3 & r1retry_t3l6b >= r1_maxRetry_t3l6b -> 1:(r1'=r1Fail);
  [r1dot2l6Retry] r1=4 & r1retry_t2l6 < r1_maxRetry_t2l6 -> p_r1_t2l6 : (r1'=r1+1) + (1-p_r1_t2l6) : (r1'=r1) & (r1retry_t2l6' = r1retry_t2l6+1);
  [r1dot2l6] r1=4 & r1retry_t2l6 >= r1_maxRetry_t2l6 -> 1:(r1'=r1Fail);
  [r1dot3l6aRetry] r1=5 & r1retry_t3l6a < r1_maxRetry_t3l6a -> p_r1_t3l6a : (r1'=r1+1) + (1-p_r1_t3l6a) : (r1'=r1) & (r1retry_t3l6a' = r1retry_t3l6a+1);
  [r1dot3l6a] r1=5 & r1retry_t3l6a >= r1_maxRetry_t3l6a -> 1:(r1'=r1Fail);
  [r1movel9] r1=6-> 1:(r1'=6+1);
  [r1dot2l9Retry] r1=7 & r1retry_t2l9 < r1_maxRetry_t2l9 -> p_r1_t2l9 : (r1'=r1+1) + (1-p_r1_t2l9) : (r1'=r1) & (r1retry_t2l9' = r1retry_t2l9+1);
  [r1dot2l9] r1=7 & r1retry_t2l9 >= r1_maxRetry_t2l9 -> 1:(r1'=r1Fail);
  [r1movel8] r1=8-> 1:(r1'=8+1);
  [r1dot2l8Retry] r1=9 & r1retry_t2l8 < r1_maxRetry_t2l8 -> p_r1_t2l8 : (r1'=r1+1) + (1-p_r1_t2l8) : (r1'=r1) & (r1retry_t2l8' = r1retry_t2l8+1);
  [r1dot2l8] r1=9 & r1retry_t2l8 >= r1_maxRetry_t2l8 -> 1:(r1'=r1Fail);
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
  worker1 : [0..7];
  worker1retry_t1l1 : [0..worker1_maxRetry_t1l1] init 0;
  worker1retry_t1l5 : [0..worker1_maxRetry_t1l5] init 0;
  worker1retry_t3l5 : [0..worker1_maxRetry_t3l5] init 0;

  [worker1dot1l1Retry] worker1=0 & worker1retry_t1l1 < worker1_maxRetry_t1l1 -> p_worker1_t1l1 : (worker1'=worker1+1) + (1-p_worker1_t1l1) : (worker1'=worker1) & (worker1retry_t1l1' = worker1retry_t1l1+1);
  [worker1dot1l1] worker1=0 & worker1retry_t1l1 >= worker1_maxRetry_t1l1 -> 1:(worker1'=worker1Fail);
  [worker1movel2] worker1=1-> 1:(worker1'=1+1);
  [worker1movel5] worker1=2-> 1:(worker1'=2+1);
  [worker1dot1l5Retry] worker1=3 & worker1retry_t1l5 < worker1_maxRetry_t1l5 -> p_worker1_t1l5 : (worker1'=worker1+1) + (1-p_worker1_t1l5) : (worker1'=worker1) & (worker1retry_t1l5' = worker1retry_t1l5+1);
  [worker1dot1l5] worker1=3 & worker1retry_t1l5 >= worker1_maxRetry_t1l5 -> 1:(worker1'=worker1Fail);
  [worker1dot3l5Retry] worker1=4 & worker1retry_t3l5 < worker1_maxRetry_t3l5 -> p_worker1_t3l5 : (worker1'=worker1+1) + (1-p_worker1_t3l5) : (worker1'=worker1) & (worker1retry_t3l5' = worker1retry_t3l5+1);
  [worker1dot3l5] worker1=4 & worker1retry_t3l5 >= worker1_maxRetry_t3l5 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..6];
  worker2retry_t3l4 : [0..worker2_maxRetry_t3l4] init 0;
  worker2retry_t1l7 : [0..worker2_maxRetry_t1l7] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2dot3l4Retry] worker2=1 & worker2retry_t3l4 < worker2_maxRetry_t3l4 -> p_worker2_t3l4 : (worker2'=worker2+1) + (1-p_worker2_t3l4) : (worker2'=worker2) & (worker2retry_t3l4' = worker2retry_t3l4+1);
  [worker2dot3l4] worker2=1 & worker2retry_t3l4 >= worker2_maxRetry_t3l4 -> 1:(worker2'=worker2Fail);
  [worker2movel7] worker2=2-> 1:(worker2'=2+1);
  [worker2dot1l7Retry] worker2=3 & worker2retry_t1l7 < worker2_maxRetry_t1l7 -> p_worker2_t1l7 : (worker2'=worker2+1) + (1-p_worker2_t1l7) : (worker2'=worker2) & (worker2retry_t1l7' = worker2retry_t1l7+1);
  [worker2dot1l7] worker2=3 & worker2retry_t1l7 >= worker2_maxRetry_t1l7 -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r1movel4] true:1;
  [r1movel5] true:1;
  [r1movel6] true:1;
  [r1dot3l6b] true:1;
  [r1dot3l6bRetry] true:1;
  [r1dot2l6] true:1;
  [r1dot2l6Retry] true:1;
  [r1dot3l6a] true:1;
  [r1dot3l6aRetry] true:1;
  [r1movel9] true:1;
  [r1dot2l9] true:1;
  [r1dot2l9Retry] true:1;
  [r1movel8] true:1;
  [r1dot2l8] true:1;
  [r1dot2l8Retry] true:1;
  [r2dot3l1] true:1;
  [r2dot3l1Retry] true:1;
  [r2dot2l1] true:1;
  [r2dot2l1Retry] true:1;
  [worker1dot1l1] true:3;
  [worker1dot1l1Retry] true:3;
  [worker1movel2] true:1;
  [worker1movel5] true:1;
  [worker1dot1l5] true:3;
  [worker1dot1l5Retry] true:3;
  [worker1dot3l5] true:5;
  [worker1dot3l5Retry] true:5;
  [worker2movel4] true:1;
  [worker2dot3l4] true:5;
  [worker2dot3l4Retry] true:5;
  [worker2movel7] true:1;
  [worker2dot1l7] true:3;
  [worker2dot1l7Retry] true:3;
endrewards