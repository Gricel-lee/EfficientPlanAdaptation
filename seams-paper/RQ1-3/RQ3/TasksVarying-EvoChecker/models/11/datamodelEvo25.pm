dtmc
evolve int worker1_maxRetry_t1l1b [1..5];
evolve int worker1_maxRetry_t1l1a [1..5];
evolve int worker1_maxRetry_t3l7 [1..5];
evolve int worker1_maxRetry_t1l7 [1..5];
evolve int worker1_maxRetry_t1l8 [1..5];
evolve int worker2_maxRetry_t1l2 [1..5];
evolve int worker2_maxRetry_t1l6 [1..5];
evolve int r1_maxRetry_t2l3 [1..10];
evolve int r1_maxRetry_t2l6 [1..10];
evolve int r1_maxRetry_t2l9 [1..10];
evolve int r1_maxRetry_t3l9 [1..10];

const double p_worker1_t1l1b=1.0;
const double p_worker1_t1l1a=1.0;
const double p_worker1_t3l7=0.99;
const double p_worker1_t1l7=1.0;
const double p_worker1_t1l8=1.0;
const double p_worker2_t1l2=1.0;
const double p_worker2_t1l6=1.0;
const double p_r1_t2l3=0.99;
const double p_r1_t2l6=0.99;
const double p_r1_t2l9=0.99;
const double p_r1_t3l9=0.97;
const int worker1Final = 8;
const int worker1Fail = 9;
const int worker2Final = 5;
const int worker2Fail = 6;
const int r1Final = 8;
const int r1Fail = 9;

module _worker1
  worker1 : [0..10];
  worker1retry_t1l1b : [0..worker1_maxRetry_t1l1b] init 0;
  worker1retry_t1l1a : [0..worker1_maxRetry_t1l1a] init 0;
  worker1retry_t3l7 : [0..worker1_maxRetry_t3l7] init 0;
  worker1retry_t1l7 : [0..worker1_maxRetry_t1l7] init 0;
  worker1retry_t1l8 : [0..worker1_maxRetry_t1l8] init 0;

  [worker1dot1l1bRetry] worker1=0 & worker1retry_t1l1b < worker1_maxRetry_t1l1b -> p_worker1_t1l1b : (worker1'=worker1+1) + (1-p_worker1_t1l1b) : (worker1'=worker1) & (worker1retry_t1l1b' = worker1retry_t1l1b+1);
  [worker1dot1l1b] worker1=0 & worker1retry_t1l1b >= worker1_maxRetry_t1l1b -> 1:(worker1'=worker1Fail);
  [worker1dot1l1aRetry] worker1=1 & worker1retry_t1l1a < worker1_maxRetry_t1l1a -> p_worker1_t1l1a : (worker1'=worker1+1) + (1-p_worker1_t1l1a) : (worker1'=worker1) & (worker1retry_t1l1a' = worker1retry_t1l1a+1);
  [worker1dot1l1a] worker1=1 & worker1retry_t1l1a >= worker1_maxRetry_t1l1a -> 1:(worker1'=worker1Fail);
  [worker1movel4] worker1=2-> 1:(worker1'=2+1);
  [worker1movel7] worker1=3-> 1:(worker1'=3+1);
  [worker1dot3l7Retry] worker1=4 & worker1retry_t3l7 < worker1_maxRetry_t3l7 -> p_worker1_t3l7 : (worker1'=worker1+1) + (1-p_worker1_t3l7) : (worker1'=worker1) & (worker1retry_t3l7' = worker1retry_t3l7+1);
  [worker1dot3l7] worker1=4 & worker1retry_t3l7 >= worker1_maxRetry_t3l7 -> 1:(worker1'=worker1Fail);
  [worker1dot1l7Retry] worker1=5 & worker1retry_t1l7 < worker1_maxRetry_t1l7 -> p_worker1_t1l7 : (worker1'=worker1+1) + (1-p_worker1_t1l7) : (worker1'=worker1) & (worker1retry_t1l7' = worker1retry_t1l7+1);
  [worker1dot1l7] worker1=5 & worker1retry_t1l7 >= worker1_maxRetry_t1l7 -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=6-> 1:(worker1'=6+1);
  [worker1dot1l8Retry] worker1=7 & worker1retry_t1l8 < worker1_maxRetry_t1l8 -> p_worker1_t1l8 : (worker1'=worker1+1) + (1-p_worker1_t1l8) : (worker1'=worker1) & (worker1retry_t1l8' = worker1retry_t1l8+1);
  [worker1dot1l8] worker1=7 & worker1retry_t1l8 >= worker1_maxRetry_t1l8 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..7];
  worker2retry_t1l2 : [0..worker2_maxRetry_t1l2] init 0;
  worker2retry_t1l6 : [0..worker2_maxRetry_t1l6] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l2Retry] worker2=1 & worker2retry_t1l2 < worker2_maxRetry_t1l2 -> p_worker2_t1l2 : (worker2'=worker2+1) + (1-p_worker2_t1l2) : (worker2'=worker2) & (worker2retry_t1l2' = worker2retry_t1l2+1);
  [worker2dot1l2] worker2=1 & worker2retry_t1l2 >= worker2_maxRetry_t1l2 -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=2-> 1:(worker2'=2+1);
  [worker2movel6] worker2=3-> 1:(worker2'=3+1);
  [worker2dot1l6Retry] worker2=4 & worker2retry_t1l6 < worker2_maxRetry_t1l6 -> p_worker2_t1l6 : (worker2'=worker2+1) + (1-p_worker2_t1l6) : (worker2'=worker2) & (worker2retry_t1l6' = worker2retry_t1l6+1);
  [worker2dot1l6] worker2=4 & worker2retry_t1l6 >= worker2_maxRetry_t1l6 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..10];
  r1retry_t2l3 : [0..r1_maxRetry_t2l3] init 0;
  r1retry_t2l6 : [0..r1_maxRetry_t2l6] init 0;
  r1retry_t2l9 : [0..r1_maxRetry_t2l9] init 0;
  r1retry_t3l9 : [0..r1_maxRetry_t3l9] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1movel3] r1=1-> 1:(r1'=1+1);
  [r1dot2l3Retry] r1=2 & r1retry_t2l3 < r1_maxRetry_t2l3 -> p_r1_t2l3 : (r1'=r1+1) + (1-p_r1_t2l3) : (r1'=r1) & (r1retry_t2l3' = r1retry_t2l3+1);
  [r1dot2l3] r1=2 & r1retry_t2l3 >= r1_maxRetry_t2l3 -> 1:(r1'=r1Fail);
  [r1movel6] r1=3-> 1:(r1'=3+1);
  [r1dot2l6Retry] r1=4 & r1retry_t2l6 < r1_maxRetry_t2l6 -> p_r1_t2l6 : (r1'=r1+1) + (1-p_r1_t2l6) : (r1'=r1) & (r1retry_t2l6' = r1retry_t2l6+1);
  [r1dot2l6] r1=4 & r1retry_t2l6 >= r1_maxRetry_t2l6 -> 1:(r1'=r1Fail);
  [r1movel9] r1=5-> 1:(r1'=5+1);
  [r1dot2l9Retry] r1=6 & r1retry_t2l9 < r1_maxRetry_t2l9 -> p_r1_t2l9 : (r1'=r1+1) + (1-p_r1_t2l9) : (r1'=r1) & (r1retry_t2l9' = r1retry_t2l9+1);
  [r1dot2l9] r1=6 & r1retry_t2l9 >= r1_maxRetry_t2l9 -> 1:(r1'=r1Fail);
  [r1dot3l9Retry] r1=7 & r1retry_t3l9 < r1_maxRetry_t3l9 -> p_r1_t3l9 : (r1'=r1+1) + (1-p_r1_t3l9) : (r1'=r1) & (r1retry_t3l9' = r1retry_t3l9+1);
  [r1dot3l9] r1=7 & r1retry_t3l9 >= r1_maxRetry_t3l9 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [worker1dot1l1b] true:3;
  [worker1dot1l1bRetry] true:3;
  [worker1dot1l1a] true:3;
  [worker1dot1l1aRetry] true:3;
  [worker1movel4] true:1;
  [worker1movel7] true:1;
  [worker1dot3l7] true:5;
  [worker1dot3l7Retry] true:5;
  [worker1dot1l7] true:3;
  [worker1dot1l7Retry] true:3;
  [worker1movel8] true:1;
  [worker1dot1l8] true:3;
  [worker1dot1l8Retry] true:3;
  [worker2movel2] true:1;
  [worker2dot1l2] true:3;
  [worker2dot1l2Retry] true:3;
  [worker2movel5] true:1;
  [worker2movel6] true:1;
  [worker2dot1l6] true:3;
  [worker2dot1l6Retry] true:3;
  [r1movel2] true:1;
  [r1movel3] true:1;
  [r1dot2l3] true:1;
  [r1dot2l3Retry] true:1;
  [r1movel6] true:1;
  [r1dot2l6] true:1;
  [r1dot2l6Retry] true:1;
  [r1movel9] true:1;
  [r1dot2l9] true:1;
  [r1dot2l9Retry] true:1;
  [r1dot3l9] true:1;
  [r1dot3l9Retry] true:1;
endrewards