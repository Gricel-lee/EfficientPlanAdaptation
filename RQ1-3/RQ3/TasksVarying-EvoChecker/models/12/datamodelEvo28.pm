dtmc
evolve int r1_maxRetry_t2l4 [1..10];
evolve int r1_maxRetry_t3l5 [1..10];
evolve int r1_maxRetry_t3l6a [1..10];
evolve int r1_maxRetry_t3l6b [1..10];
evolve int r1_maxRetry_t2l6 [1..10];
evolve int worker1_maxRetry_t1l7 [1..5];
evolve int worker1_maxRetry_t1l8 [1..5];
evolve int worker1_maxRetry_t3l9 [1..5];
evolve int worker1_maxRetry_t1l9 [1..5];
evolve int worker2_maxRetry_t1l2 [1..5];
evolve int worker2_maxRetry_t1l3 [1..5];
evolve int worker2_maxRetry_t3l3 [1..5];

const double p_r1_t2l4=0.99;
const double p_r1_t3l5=0.97;
const double p_r1_t3l6a=0.97;
const double p_r1_t3l6b=0.97;
const double p_r1_t2l6=0.99;
const double p_worker1_t1l7=1.0;
const double p_worker1_t1l8=1.0;
const double p_worker1_t3l9=0.99;
const double p_worker1_t1l9=1.0;
const double p_worker2_t1l2=1.0;
const double p_worker2_t1l3=1.0;
const double p_worker2_t3l3=0.99;
const int r1Final = 8;
const int r1Fail = 9;
const int worker1Final = 8;
const int worker1Fail = 9;
const int worker2Final = 5;
const int worker2Fail = 6;

module _r1
  r1 : [0..10];
  r1retry_t2l4 : [0..r1_maxRetry_t2l4] init 0;
  r1retry_t3l5 : [0..r1_maxRetry_t3l5] init 0;
  r1retry_t3l6a : [0..r1_maxRetry_t3l6a] init 0;
  r1retry_t3l6b : [0..r1_maxRetry_t3l6b] init 0;
  r1retry_t2l6 : [0..r1_maxRetry_t2l6] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1dot2l4Retry] r1=1 & r1retry_t2l4 < r1_maxRetry_t2l4 -> p_r1_t2l4 : (r1'=r1+1) + (1-p_r1_t2l4) : (r1'=r1) & (r1retry_t2l4' = r1retry_t2l4+1);
  [r1dot2l4] r1=1 & r1retry_t2l4 >= r1_maxRetry_t2l4 -> 1:(r1'=r1Fail);
  [r1movel5] r1=2-> 1:(r1'=2+1);
  [r1dot3l5Retry] r1=3 & r1retry_t3l5 < r1_maxRetry_t3l5 -> p_r1_t3l5 : (r1'=r1+1) + (1-p_r1_t3l5) : (r1'=r1) & (r1retry_t3l5' = r1retry_t3l5+1);
  [r1dot3l5] r1=3 & r1retry_t3l5 >= r1_maxRetry_t3l5 -> 1:(r1'=r1Fail);
  [r1movel6] r1=4-> 1:(r1'=4+1);
  [r1dot3l6aRetry] r1=5 & r1retry_t3l6a < r1_maxRetry_t3l6a -> p_r1_t3l6a : (r1'=r1+1) + (1-p_r1_t3l6a) : (r1'=r1) & (r1retry_t3l6a' = r1retry_t3l6a+1);
  [r1dot3l6a] r1=5 & r1retry_t3l6a >= r1_maxRetry_t3l6a -> 1:(r1'=r1Fail);
  [r1dot3l6bRetry] r1=6 & r1retry_t3l6b < r1_maxRetry_t3l6b -> p_r1_t3l6b : (r1'=r1+1) + (1-p_r1_t3l6b) : (r1'=r1) & (r1retry_t3l6b' = r1retry_t3l6b+1);
  [r1dot3l6b] r1=6 & r1retry_t3l6b >= r1_maxRetry_t3l6b -> 1:(r1'=r1Fail);
  [r1dot2l6Retry] r1=7 & r1retry_t2l6 < r1_maxRetry_t2l6 -> p_r1_t2l6 : (r1'=r1+1) + (1-p_r1_t2l6) : (r1'=r1) & (r1retry_t2l6' = r1retry_t2l6+1);
  [r1dot2l6] r1=7 & r1retry_t2l6 >= r1_maxRetry_t2l6 -> 1:(r1'=r1Fail);
endmodule

module _worker1
  worker1 : [0..10];
  worker1retry_t1l7 : [0..worker1_maxRetry_t1l7] init 0;
  worker1retry_t1l8 : [0..worker1_maxRetry_t1l8] init 0;
  worker1retry_t3l9 : [0..worker1_maxRetry_t3l9] init 0;
  worker1retry_t1l9 : [0..worker1_maxRetry_t1l9] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1movel7] worker1=1-> 1:(worker1'=1+1);
  [worker1dot1l7Retry] worker1=2 & worker1retry_t1l7 < worker1_maxRetry_t1l7 -> p_worker1_t1l7 : (worker1'=worker1+1) + (1-p_worker1_t1l7) : (worker1'=worker1) & (worker1retry_t1l7' = worker1retry_t1l7+1);
  [worker1dot1l7] worker1=2 & worker1retry_t1l7 >= worker1_maxRetry_t1l7 -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=3-> 1:(worker1'=3+1);
  [worker1dot1l8Retry] worker1=4 & worker1retry_t1l8 < worker1_maxRetry_t1l8 -> p_worker1_t1l8 : (worker1'=worker1+1) + (1-p_worker1_t1l8) : (worker1'=worker1) & (worker1retry_t1l8' = worker1retry_t1l8+1);
  [worker1dot1l8] worker1=4 & worker1retry_t1l8 >= worker1_maxRetry_t1l8 -> 1:(worker1'=worker1Fail);
  [worker1movel9] worker1=5-> 1:(worker1'=5+1);
  [worker1dot3l9Retry] worker1=6 & worker1retry_t3l9 < worker1_maxRetry_t3l9 -> p_worker1_t3l9 : (worker1'=worker1+1) + (1-p_worker1_t3l9) : (worker1'=worker1) & (worker1retry_t3l9' = worker1retry_t3l9+1);
  [worker1dot3l9] worker1=6 & worker1retry_t3l9 >= worker1_maxRetry_t3l9 -> 1:(worker1'=worker1Fail);
  [worker1dot1l9Retry] worker1=7 & worker1retry_t1l9 < worker1_maxRetry_t1l9 -> p_worker1_t1l9 : (worker1'=worker1+1) + (1-p_worker1_t1l9) : (worker1'=worker1) & (worker1retry_t1l9' = worker1retry_t1l9+1);
  [worker1dot1l9] worker1=7 & worker1retry_t1l9 >= worker1_maxRetry_t1l9 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..7];
  worker2retry_t1l2 : [0..worker2_maxRetry_t1l2] init 0;
  worker2retry_t1l3 : [0..worker2_maxRetry_t1l3] init 0;
  worker2retry_t3l3 : [0..worker2_maxRetry_t3l3] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l2Retry] worker2=1 & worker2retry_t1l2 < worker2_maxRetry_t1l2 -> p_worker2_t1l2 : (worker2'=worker2+1) + (1-p_worker2_t1l2) : (worker2'=worker2) & (worker2retry_t1l2' = worker2retry_t1l2+1);
  [worker2dot1l2] worker2=1 & worker2retry_t1l2 >= worker2_maxRetry_t1l2 -> 1:(worker2'=worker2Fail);
  [worker2movel3] worker2=2-> 1:(worker2'=2+1);
  [worker2dot1l3Retry] worker2=3 & worker2retry_t1l3 < worker2_maxRetry_t1l3 -> p_worker2_t1l3 : (worker2'=worker2+1) + (1-p_worker2_t1l3) : (worker2'=worker2) & (worker2retry_t1l3' = worker2retry_t1l3+1);
  [worker2dot1l3] worker2=3 & worker2retry_t1l3 >= worker2_maxRetry_t1l3 -> 1:(worker2'=worker2Fail);
  [worker2dot3l3Retry] worker2=4 & worker2retry_t3l3 < worker2_maxRetry_t3l3 -> p_worker2_t3l3 : (worker2'=worker2+1) + (1-p_worker2_t3l3) : (worker2'=worker2) & (worker2retry_t3l3' = worker2retry_t3l3+1);
  [worker2dot3l3] worker2=4 & worker2retry_t3l3 >= worker2_maxRetry_t3l3 -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r1movel4] true:1;
  [r1dot2l4] true:1;
  [r1dot2l4Retry] true:1;
  [r1movel5] true:1;
  [r1dot3l5] true:1;
  [r1dot3l5Retry] true:1;
  [r1movel6] true:1;
  [r1dot3l6a] true:1;
  [r1dot3l6aRetry] true:1;
  [r1dot3l6b] true:1;
  [r1dot3l6bRetry] true:1;
  [r1dot2l6] true:1;
  [r1dot2l6Retry] true:1;
  [worker1movel4] true:1;
  [worker1movel7] true:1;
  [worker1dot1l7] true:3;
  [worker1dot1l7Retry] true:3;
  [worker1movel8] true:1;
  [worker1dot1l8] true:3;
  [worker1dot1l8Retry] true:3;
  [worker1movel9] true:1;
  [worker1dot3l9] true:5;
  [worker1dot3l9Retry] true:5;
  [worker1dot1l9] true:3;
  [worker1dot1l9Retry] true:3;
  [worker2movel2] true:1;
  [worker2dot1l2] true:3;
  [worker2dot1l2Retry] true:3;
  [worker2movel3] true:1;
  [worker2dot1l3] true:3;
  [worker2dot1l3Retry] true:3;
  [worker2dot3l3] true:5;
  [worker2dot3l3Retry] true:5;
endrewards