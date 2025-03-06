dtmc
evolve int worker2_maxRetry_t1l1 [1..5];
evolve int r1_maxRetry_t3l2 [1..10];
evolve int r1_maxRetry_t2l3 [1..10];
evolve int r1_maxRetry_t3l9 [1..10];
evolve int r1_maxRetry_t2l9 [1..10];
evolve int r2_maxRetry_t3l1 [1..10];
evolve int worker1_maxRetry_t1l4b [1..5];
evolve int worker1_maxRetry_t3l4 [1..5];
evolve int worker1_maxRetry_t1l4a [1..5];
evolve int worker1_maxRetry_t3l7 [1..5];
evolve int worker1_maxRetry_t1l8 [1..5];
evolve int worker1_maxRetry_t3l5 [1..5];
evolve int worker1_maxRetry_t1l6 [1..5];

const double p_worker2_t1l1=1.0;
const double p_r1_t3l2=0.97;
const double p_r1_t2l3=0.99;
const double p_r1_t3l9=0.97;
const double p_r1_t2l9=0.99;
const double p_r2_t3l1=0.97;
const double p_worker1_t1l4b=1.0;
const double p_worker1_t3l4=0.99;
const double p_worker1_t1l4a=1.0;
const double p_worker1_t3l7=0.99;
const double p_worker1_t1l8=1.0;
const double p_worker1_t3l5=0.99;
const double p_worker1_t1l6=1.0;
const int worker2Final = 1;
const int worker2Fail = 2;
const int r1Final = 8;
const int r1Fail = 9;
const int r2Final = 1;
const int r2Fail = 2;
const int worker1Final = 12;
const int worker1Fail = 13;

module _worker2
  worker2 : [0..3];
  worker2retry_t1l1 : [0..worker2_maxRetry_t1l1] init 0;

  [worker2dot1l1Retry] worker2=0 & worker2retry_t1l1 < worker2_maxRetry_t1l1 -> p_worker2_t1l1 : (worker2'=worker2+1) + (1-p_worker2_t1l1) : (worker2'=worker2) & (worker2retry_t1l1' = worker2retry_t1l1+1);
  [worker2dot1l1] worker2=0 & worker2retry_t1l1 >= worker2_maxRetry_t1l1 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..10];
  r1retry_t3l2 : [0..r1_maxRetry_t3l2] init 0;
  r1retry_t2l3 : [0..r1_maxRetry_t2l3] init 0;
  r1retry_t3l9 : [0..r1_maxRetry_t3l9] init 0;
  r1retry_t2l9 : [0..r1_maxRetry_t2l9] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1dot3l2Retry] r1=1 & r1retry_t3l2 < r1_maxRetry_t3l2 -> p_r1_t3l2 : (r1'=r1+1) + (1-p_r1_t3l2) : (r1'=r1) & (r1retry_t3l2' = r1retry_t3l2+1);
  [r1dot3l2] r1=1 & r1retry_t3l2 >= r1_maxRetry_t3l2 -> 1:(r1'=r1Fail);
  [r1movel3] r1=2-> 1:(r1'=2+1);
  [r1dot2l3Retry] r1=3 & r1retry_t2l3 < r1_maxRetry_t2l3 -> p_r1_t2l3 : (r1'=r1+1) + (1-p_r1_t2l3) : (r1'=r1) & (r1retry_t2l3' = r1retry_t2l3+1);
  [r1dot2l3] r1=3 & r1retry_t2l3 >= r1_maxRetry_t2l3 -> 1:(r1'=r1Fail);
  [r1movel6] r1=4-> 1:(r1'=4+1);
  [r1movel9] r1=5-> 1:(r1'=5+1);
  [r1dot3l9Retry] r1=6 & r1retry_t3l9 < r1_maxRetry_t3l9 -> p_r1_t3l9 : (r1'=r1+1) + (1-p_r1_t3l9) : (r1'=r1) & (r1retry_t3l9' = r1retry_t3l9+1);
  [r1dot3l9] r1=6 & r1retry_t3l9 >= r1_maxRetry_t3l9 -> 1:(r1'=r1Fail);
  [r1dot2l9Retry] r1=7 & r1retry_t2l9 < r1_maxRetry_t2l9 -> p_r1_t2l9 : (r1'=r1+1) + (1-p_r1_t2l9) : (r1'=r1) & (r1retry_t2l9' = r1retry_t2l9+1);
  [r1dot2l9] r1=7 & r1retry_t2l9 >= r1_maxRetry_t2l9 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..3];
  r2retry_t3l1 : [0..r2_maxRetry_t3l1] init 0;

  [r2dot3l1Retry] r2=0 & r2retry_t3l1 < r2_maxRetry_t3l1 -> p_r2_t3l1 : (r2'=r2+1) + (1-p_r2_t3l1) : (r2'=r2) & (r2retry_t3l1' = r2retry_t3l1+1);
  [r2dot3l1] r2=0 & r2retry_t3l1 >= r2_maxRetry_t3l1 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..14];
  worker1retry_t1l4b : [0..worker1_maxRetry_t1l4b] init 0;
  worker1retry_t3l4 : [0..worker1_maxRetry_t3l4] init 0;
  worker1retry_t1l4a : [0..worker1_maxRetry_t1l4a] init 0;
  worker1retry_t3l7 : [0..worker1_maxRetry_t3l7] init 0;
  worker1retry_t1l8 : [0..worker1_maxRetry_t1l8] init 0;
  worker1retry_t3l5 : [0..worker1_maxRetry_t3l5] init 0;
  worker1retry_t1l6 : [0..worker1_maxRetry_t1l6] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l4bRetry] worker1=1 & worker1retry_t1l4b < worker1_maxRetry_t1l4b -> p_worker1_t1l4b : (worker1'=worker1+1) + (1-p_worker1_t1l4b) : (worker1'=worker1) & (worker1retry_t1l4b' = worker1retry_t1l4b+1);
  [worker1dot1l4b] worker1=1 & worker1retry_t1l4b >= worker1_maxRetry_t1l4b -> 1:(worker1'=worker1Fail);
  [worker1dot3l4Retry] worker1=2 & worker1retry_t3l4 < worker1_maxRetry_t3l4 -> p_worker1_t3l4 : (worker1'=worker1+1) + (1-p_worker1_t3l4) : (worker1'=worker1) & (worker1retry_t3l4' = worker1retry_t3l4+1);
  [worker1dot3l4] worker1=2 & worker1retry_t3l4 >= worker1_maxRetry_t3l4 -> 1:(worker1'=worker1Fail);
  [worker1dot1l4aRetry] worker1=3 & worker1retry_t1l4a < worker1_maxRetry_t1l4a -> p_worker1_t1l4a : (worker1'=worker1+1) + (1-p_worker1_t1l4a) : (worker1'=worker1) & (worker1retry_t1l4a' = worker1retry_t1l4a+1);
  [worker1dot1l4a] worker1=3 & worker1retry_t1l4a >= worker1_maxRetry_t1l4a -> 1:(worker1'=worker1Fail);
  [worker1movel7] worker1=4-> 1:(worker1'=4+1);
  [worker1dot3l7Retry] worker1=5 & worker1retry_t3l7 < worker1_maxRetry_t3l7 -> p_worker1_t3l7 : (worker1'=worker1+1) + (1-p_worker1_t3l7) : (worker1'=worker1) & (worker1retry_t3l7' = worker1retry_t3l7+1);
  [worker1dot3l7] worker1=5 & worker1retry_t3l7 >= worker1_maxRetry_t3l7 -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=6-> 1:(worker1'=6+1);
  [worker1dot1l8Retry] worker1=7 & worker1retry_t1l8 < worker1_maxRetry_t1l8 -> p_worker1_t1l8 : (worker1'=worker1+1) + (1-p_worker1_t1l8) : (worker1'=worker1) & (worker1retry_t1l8' = worker1retry_t1l8+1);
  [worker1dot1l8] worker1=7 & worker1retry_t1l8 >= worker1_maxRetry_t1l8 -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=8-> 1:(worker1'=8+1);
  [worker1dot3l5Retry] worker1=9 & worker1retry_t3l5 < worker1_maxRetry_t3l5 -> p_worker1_t3l5 : (worker1'=worker1+1) + (1-p_worker1_t3l5) : (worker1'=worker1) & (worker1retry_t3l5' = worker1retry_t3l5+1);
  [worker1dot3l5] worker1=9 & worker1retry_t3l5 >= worker1_maxRetry_t3l5 -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=10-> 1:(worker1'=10+1);
  [worker1dot1l6Retry] worker1=11 & worker1retry_t1l6 < worker1_maxRetry_t1l6 -> p_worker1_t1l6 : (worker1'=worker1+1) + (1-p_worker1_t1l6) : (worker1'=worker1) & (worker1retry_t1l6' = worker1retry_t1l6+1);
  [worker1dot1l6] worker1=11 & worker1retry_t1l6 >= worker1_maxRetry_t1l6 -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [worker2dot1l1] true:3;
  [worker2dot1l1Retry] true:3;
  [r1movel2] true:1;
  [r1dot3l2] true:1;
  [r1dot3l2Retry] true:1;
  [r1movel3] true:1;
  [r1dot2l3] true:1;
  [r1dot2l3Retry] true:1;
  [r1movel6] true:1;
  [r1movel9] true:1;
  [r1dot3l9] true:1;
  [r1dot3l9Retry] true:1;
  [r1dot2l9] true:1;
  [r1dot2l9Retry] true:1;
  [r2dot3l1] true:1;
  [r2dot3l1Retry] true:1;
  [worker1movel4] true:1;
  [worker1dot1l4b] true:3;
  [worker1dot1l4bRetry] true:3;
  [worker1dot3l4] true:5;
  [worker1dot3l4Retry] true:5;
  [worker1dot1l4a] true:3;
  [worker1dot1l4aRetry] true:3;
  [worker1movel7] true:1;
  [worker1dot3l7] true:5;
  [worker1dot3l7Retry] true:5;
  [worker1movel8] true:1;
  [worker1dot1l8] true:3;
  [worker1dot1l8Retry] true:3;
  [worker1movel5] true:1;
  [worker1dot3l5] true:5;
  [worker1dot3l5Retry] true:5;
  [worker1movel6] true:1;
  [worker1dot1l6] true:3;
  [worker1dot1l6Retry] true:3;
endrewards