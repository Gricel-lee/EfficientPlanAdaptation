dtmc
evolve int worker2_maxRetry_t1l1 [1..5];
evolve int r1_maxRetry_t2l7 [1..10];
evolve int r1_maxRetry_t3l8 [1..10];
evolve int r1_maxRetry_t2l8 [1..10];
evolve int r1_maxRetry_t2l5a [1..10];
evolve int r1_maxRetry_t2l5b [1..10];
evolve int r1_maxRetry_t2l9 [1..10];
evolve int r2_maxRetry_t3l2 [1..10];
evolve int r2_maxRetry_t2l3 [1..10];
evolve int worker1_maxRetry_t1l4 [1..5];
evolve int worker1_maxRetry_t1l5a [1..5];
evolve int worker1_maxRetry_t1l5b [1..5];
evolve int worker1_maxRetry_t1l6 [1..5];

const double p_worker2_t1l1=1.0;
const double p_r1_t2l7=0.99;
const double p_r1_t3l8=0.97;
const double p_r1_t2l8=0.99;
const double p_r1_t2l5a=0.99;
const double p_r1_t2l5b=0.99;
const double p_r1_t2l9=0.99;
const double p_r2_t3l2=0.97;
const double p_r2_t2l3=0.99;
const double p_worker1_t1l4=1.0;
const double p_worker1_t1l5a=1.0;
const double p_worker1_t1l5b=1.0;
const double p_worker1_t1l6=1.0;
const int worker2Final = 1;
const int worker2Fail = 2;
const int r1Final = 12;
const int r1Fail = 13;
const int r2Final = 4;
const int r2Fail = 5;
const int worker1Final = 7;
const int worker1Fail = 8;

module _worker2
  worker2 : [0..3];
  worker2retry_t1l1 : [0..worker2_maxRetry_t1l1] init 0;

  [worker2dot1l1Retry] worker2=0 & worker2retry_t1l1 < worker2_maxRetry_t1l1 -> p_worker2_t1l1 : (worker2'=worker2+1) + (1-p_worker2_t1l1) : (worker2'=worker2) & (worker2retry_t1l1' = worker2retry_t1l1+1);
  [worker2dot1l1] worker2=0 & worker2retry_t1l1 >= worker2_maxRetry_t1l1 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..14];
  r1retry_t2l7 : [0..r1_maxRetry_t2l7] init 0;
  r1retry_t3l8 : [0..r1_maxRetry_t3l8] init 0;
  r1retry_t2l8 : [0..r1_maxRetry_t2l8] init 0;
  r1retry_t2l5a : [0..r1_maxRetry_t2l5a] init 0;
  r1retry_t2l5b : [0..r1_maxRetry_t2l5b] init 0;
  r1retry_t2l9 : [0..r1_maxRetry_t2l9] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1movel7] r1=1-> 1:(r1'=1+1);
  [r1dot2l7Retry] r1=2 & r1retry_t2l7 < r1_maxRetry_t2l7 -> p_r1_t2l7 : (r1'=r1+1) + (1-p_r1_t2l7) : (r1'=r1) & (r1retry_t2l7' = r1retry_t2l7+1);
  [r1dot2l7] r1=2 & r1retry_t2l7 >= r1_maxRetry_t2l7 -> 1:(r1'=r1Fail);
  [r1movel8] r1=3-> 1:(r1'=3+1);
  [r1dot3l8Retry] r1=4 & r1retry_t3l8 < r1_maxRetry_t3l8 -> p_r1_t3l8 : (r1'=r1+1) + (1-p_r1_t3l8) : (r1'=r1) & (r1retry_t3l8' = r1retry_t3l8+1);
  [r1dot3l8] r1=4 & r1retry_t3l8 >= r1_maxRetry_t3l8 -> 1:(r1'=r1Fail);
  [r1dot2l8Retry] r1=5 & r1retry_t2l8 < r1_maxRetry_t2l8 -> p_r1_t2l8 : (r1'=r1+1) + (1-p_r1_t2l8) : (r1'=r1) & (r1retry_t2l8' = r1retry_t2l8+1);
  [r1dot2l8] r1=5 & r1retry_t2l8 >= r1_maxRetry_t2l8 -> 1:(r1'=r1Fail);
  [r1movel5] r1=6-> 1:(r1'=6+1);
  [r1dot2l5aRetry] r1=7 & r1retry_t2l5a < r1_maxRetry_t2l5a -> p_r1_t2l5a : (r1'=r1+1) + (1-p_r1_t2l5a) : (r1'=r1) & (r1retry_t2l5a' = r1retry_t2l5a+1);
  [r1dot2l5a] r1=7 & r1retry_t2l5a >= r1_maxRetry_t2l5a -> 1:(r1'=r1Fail);
  [r1dot2l5bRetry] r1=8 & r1retry_t2l5b < r1_maxRetry_t2l5b -> p_r1_t2l5b : (r1'=r1+1) + (1-p_r1_t2l5b) : (r1'=r1) & (r1retry_t2l5b' = r1retry_t2l5b+1);
  [r1dot2l5b] r1=8 & r1retry_t2l5b >= r1_maxRetry_t2l5b -> 1:(r1'=r1Fail);
  [r1movel8] r1=9-> 1:(r1'=9+1);
  [r1movel9] r1=10-> 1:(r1'=10+1);
  [r1dot2l9Retry] r1=11 & r1retry_t2l9 < r1_maxRetry_t2l9 -> p_r1_t2l9 : (r1'=r1+1) + (1-p_r1_t2l9) : (r1'=r1) & (r1retry_t2l9' = r1retry_t2l9+1);
  [r1dot2l9] r1=11 & r1retry_t2l9 >= r1_maxRetry_t2l9 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..6];
  r2retry_t3l2 : [0..r2_maxRetry_t3l2] init 0;
  r2retry_t2l3 : [0..r2_maxRetry_t2l3] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2dot3l2Retry] r2=1 & r2retry_t3l2 < r2_maxRetry_t3l2 -> p_r2_t3l2 : (r2'=r2+1) + (1-p_r2_t3l2) : (r2'=r2) & (r2retry_t3l2' = r2retry_t3l2+1);
  [r2dot3l2] r2=1 & r2retry_t3l2 >= r2_maxRetry_t3l2 -> 1:(r2'=r2Fail);
  [r2movel3] r2=2-> 1:(r2'=2+1);
  [r2dot2l3Retry] r2=3 & r2retry_t2l3 < r2_maxRetry_t2l3 -> p_r2_t2l3 : (r2'=r2+1) + (1-p_r2_t2l3) : (r2'=r2) & (r2retry_t2l3' = r2retry_t2l3+1);
  [r2dot2l3] r2=3 & r2retry_t2l3 >= r2_maxRetry_t2l3 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..9];
  worker1retry_t1l4 : [0..worker1_maxRetry_t1l4] init 0;
  worker1retry_t1l5a : [0..worker1_maxRetry_t1l5a] init 0;
  worker1retry_t1l5b : [0..worker1_maxRetry_t1l5b] init 0;
  worker1retry_t1l6 : [0..worker1_maxRetry_t1l6] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l4Retry] worker1=1 & worker1retry_t1l4 < worker1_maxRetry_t1l4 -> p_worker1_t1l4 : (worker1'=worker1+1) + (1-p_worker1_t1l4) : (worker1'=worker1) & (worker1retry_t1l4' = worker1retry_t1l4+1);
  [worker1dot1l4] worker1=1 & worker1retry_t1l4 >= worker1_maxRetry_t1l4 -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=2-> 1:(worker1'=2+1);
  [worker1dot1l5aRetry] worker1=3 & worker1retry_t1l5a < worker1_maxRetry_t1l5a -> p_worker1_t1l5a : (worker1'=worker1+1) + (1-p_worker1_t1l5a) : (worker1'=worker1) & (worker1retry_t1l5a' = worker1retry_t1l5a+1);
  [worker1dot1l5a] worker1=3 & worker1retry_t1l5a >= worker1_maxRetry_t1l5a -> 1:(worker1'=worker1Fail);
  [worker1dot1l5bRetry] worker1=4 & worker1retry_t1l5b < worker1_maxRetry_t1l5b -> p_worker1_t1l5b : (worker1'=worker1+1) + (1-p_worker1_t1l5b) : (worker1'=worker1) & (worker1retry_t1l5b' = worker1retry_t1l5b+1);
  [worker1dot1l5b] worker1=4 & worker1retry_t1l5b >= worker1_maxRetry_t1l5b -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=5-> 1:(worker1'=5+1);
  [worker1dot1l6Retry] worker1=6 & worker1retry_t1l6 < worker1_maxRetry_t1l6 -> p_worker1_t1l6 : (worker1'=worker1+1) + (1-p_worker1_t1l6) : (worker1'=worker1) & (worker1retry_t1l6' = worker1retry_t1l6+1);
  [worker1dot1l6] worker1=6 & worker1retry_t1l6 >= worker1_maxRetry_t1l6 -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [worker2dot1l1] true:3;
  [worker2dot1l1Retry] true:3;
  [r1movel4] true:1;
  [r1movel7] true:1;
  [r1dot2l7] true:1;
  [r1dot2l7Retry] true:1;
  [r1movel8] true:1;
  [r1dot3l8] true:1;
  [r1dot3l8Retry] true:1;
  [r1dot2l8] true:1;
  [r1dot2l8Retry] true:1;
  [r1movel5] true:1;
  [r1dot2l5a] true:1;
  [r1dot2l5aRetry] true:1;
  [r1dot2l5b] true:1;
  [r1dot2l5bRetry] true:1;
  [r1movel8] true:1;
  [r1movel9] true:1;
  [r1dot2l9] true:1;
  [r1dot2l9Retry] true:1;
  [r2movel2] true:1;
  [r2dot3l2] true:1;
  [r2dot3l2Retry] true:1;
  [r2movel3] true:1;
  [r2dot2l3] true:1;
  [r2dot2l3Retry] true:1;
  [worker1movel4] true:1;
  [worker1dot1l4] true:3;
  [worker1dot1l4Retry] true:3;
  [worker1movel5] true:1;
  [worker1dot1l5a] true:3;
  [worker1dot1l5aRetry] true:3;
  [worker1dot1l5b] true:3;
  [worker1dot1l5bRetry] true:3;
  [worker1movel6] true:1;
  [worker1dot1l6] true:3;
  [worker1dot1l6Retry] true:3;
endrewards