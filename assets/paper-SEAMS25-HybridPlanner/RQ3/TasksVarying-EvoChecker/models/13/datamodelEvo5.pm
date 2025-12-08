dtmc
evolve int worker2_maxRetry_t1l7 [1..5];
evolve int worker2_maxRetry_t1l9 [1..5];
evolve int r1_maxRetry_t3l1b [1..10];
evolve int r1_maxRetry_t2l2 [1..10];
evolve int r1_maxRetry_t2l3 [1..10];
evolve int r1_maxRetry_t3l3 [1..10];
evolve int r1_maxRetry_t3l6 [1..10];
evolve int r2_maxRetry_t2l4 [1..10];
evolve int r2_maxRetry_t2l7 [1..10];
evolve int r2_maxRetry_t3l7 [1..10];
evolve int r2_maxRetry_t2l8 [1..10];
evolve int r2_maxRetry_t3l8 [1..10];
evolve int worker1_maxRetry_t3l1a [1..5];

const double p_worker2_t1l7=1.0;
const double p_worker2_t1l9=1.0;
const double p_r1_t3l1b=0.97;
const double p_r1_t2l2=0.99;
const double p_r1_t2l3=0.99;
const double p_r1_t3l3=0.97;
const double p_r1_t3l6=0.97;
const double p_r2_t2l4=0.99;
const double p_r2_t2l7=0.99;
const double p_r2_t3l7=0.97;
const double p_r2_t2l8=0.99;
const double p_r2_t3l8=0.97;
const double p_worker1_t3l1a=0.99;
const int worker2Final = 6;
const int worker2Fail = 7;
const int r1Final = 8;
const int r1Fail = 9;
const int r2Final = 8;
const int r2Fail = 9;
const int worker1Final = 1;
const int worker1Fail = 2;

module _worker2
  worker2 : [0..8];
  worker2retry_t1l7 : [0..worker2_maxRetry_t1l7] init 0;
  worker2retry_t1l9 : [0..worker2_maxRetry_t1l9] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2movel7] worker2=1-> 1:(worker2'=1+1);
  [worker2dot1l7Retry] worker2=2 & worker2retry_t1l7 < worker2_maxRetry_t1l7 -> p_worker2_t1l7 : (worker2'=worker2+1) + (1-p_worker2_t1l7) : (worker2'=worker2) & (worker2retry_t1l7' = worker2retry_t1l7+1);
  [worker2dot1l7] worker2=2 & worker2retry_t1l7 >= worker2_maxRetry_t1l7 -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=3-> 1:(worker2'=3+1);
  [worker2movel9] worker2=4-> 1:(worker2'=4+1);
  [worker2dot1l9Retry] worker2=5 & worker2retry_t1l9 < worker2_maxRetry_t1l9 -> p_worker2_t1l9 : (worker2'=worker2+1) + (1-p_worker2_t1l9) : (worker2'=worker2) & (worker2retry_t1l9' = worker2retry_t1l9+1);
  [worker2dot1l9] worker2=5 & worker2retry_t1l9 >= worker2_maxRetry_t1l9 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..10];
  r1retry_t3l1b : [0..r1_maxRetry_t3l1b] init 0;
  r1retry_t2l2 : [0..r1_maxRetry_t2l2] init 0;
  r1retry_t2l3 : [0..r1_maxRetry_t2l3] init 0;
  r1retry_t3l3 : [0..r1_maxRetry_t3l3] init 0;
  r1retry_t3l6 : [0..r1_maxRetry_t3l6] init 0;

  [r1dot3l1bRetry] r1=0 & r1retry_t3l1b < r1_maxRetry_t3l1b -> p_r1_t3l1b : (r1'=r1+1) + (1-p_r1_t3l1b) : (r1'=r1) & (r1retry_t3l1b' = r1retry_t3l1b+1);
  [r1dot3l1b] r1=0 & r1retry_t3l1b >= r1_maxRetry_t3l1b -> 1:(r1'=r1Fail);
  [r1movel2] r1=1-> 1:(r1'=1+1);
  [r1dot2l2Retry] r1=2 & r1retry_t2l2 < r1_maxRetry_t2l2 -> p_r1_t2l2 : (r1'=r1+1) + (1-p_r1_t2l2) : (r1'=r1) & (r1retry_t2l2' = r1retry_t2l2+1);
  [r1dot2l2] r1=2 & r1retry_t2l2 >= r1_maxRetry_t2l2 -> 1:(r1'=r1Fail);
  [r1movel3] r1=3-> 1:(r1'=3+1);
  [r1dot2l3Retry] r1=4 & r1retry_t2l3 < r1_maxRetry_t2l3 -> p_r1_t2l3 : (r1'=r1+1) + (1-p_r1_t2l3) : (r1'=r1) & (r1retry_t2l3' = r1retry_t2l3+1);
  [r1dot2l3] r1=4 & r1retry_t2l3 >= r1_maxRetry_t2l3 -> 1:(r1'=r1Fail);
  [r1dot3l3Retry] r1=5 & r1retry_t3l3 < r1_maxRetry_t3l3 -> p_r1_t3l3 : (r1'=r1+1) + (1-p_r1_t3l3) : (r1'=r1) & (r1retry_t3l3' = r1retry_t3l3+1);
  [r1dot3l3] r1=5 & r1retry_t3l3 >= r1_maxRetry_t3l3 -> 1:(r1'=r1Fail);
  [r1movel6] r1=6-> 1:(r1'=6+1);
  [r1dot3l6Retry] r1=7 & r1retry_t3l6 < r1_maxRetry_t3l6 -> p_r1_t3l6 : (r1'=r1+1) + (1-p_r1_t3l6) : (r1'=r1) & (r1retry_t3l6' = r1retry_t3l6+1);
  [r1dot3l6] r1=7 & r1retry_t3l6 >= r1_maxRetry_t3l6 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..10];
  r2retry_t2l4 : [0..r2_maxRetry_t2l4] init 0;
  r2retry_t2l7 : [0..r2_maxRetry_t2l7] init 0;
  r2retry_t3l7 : [0..r2_maxRetry_t3l7] init 0;
  r2retry_t2l8 : [0..r2_maxRetry_t2l8] init 0;
  r2retry_t3l8 : [0..r2_maxRetry_t3l8] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2dot2l4Retry] r2=1 & r2retry_t2l4 < r2_maxRetry_t2l4 -> p_r2_t2l4 : (r2'=r2+1) + (1-p_r2_t2l4) : (r2'=r2) & (r2retry_t2l4' = r2retry_t2l4+1);
  [r2dot2l4] r2=1 & r2retry_t2l4 >= r2_maxRetry_t2l4 -> 1:(r2'=r2Fail);
  [r2movel7] r2=2-> 1:(r2'=2+1);
  [r2dot2l7Retry] r2=3 & r2retry_t2l7 < r2_maxRetry_t2l7 -> p_r2_t2l7 : (r2'=r2+1) + (1-p_r2_t2l7) : (r2'=r2) & (r2retry_t2l7' = r2retry_t2l7+1);
  [r2dot2l7] r2=3 & r2retry_t2l7 >= r2_maxRetry_t2l7 -> 1:(r2'=r2Fail);
  [r2dot3l7Retry] r2=4 & r2retry_t3l7 < r2_maxRetry_t3l7 -> p_r2_t3l7 : (r2'=r2+1) + (1-p_r2_t3l7) : (r2'=r2) & (r2retry_t3l7' = r2retry_t3l7+1);
  [r2dot3l7] r2=4 & r2retry_t3l7 >= r2_maxRetry_t3l7 -> 1:(r2'=r2Fail);
  [r2movel8] r2=5-> 1:(r2'=5+1);
  [r2dot2l8Retry] r2=6 & r2retry_t2l8 < r2_maxRetry_t2l8 -> p_r2_t2l8 : (r2'=r2+1) + (1-p_r2_t2l8) : (r2'=r2) & (r2retry_t2l8' = r2retry_t2l8+1);
  [r2dot2l8] r2=6 & r2retry_t2l8 >= r2_maxRetry_t2l8 -> 1:(r2'=r2Fail);
  [r2dot3l8Retry] r2=7 & r2retry_t3l8 < r2_maxRetry_t3l8 -> p_r2_t3l8 : (r2'=r2+1) + (1-p_r2_t3l8) : (r2'=r2) & (r2retry_t3l8' = r2retry_t3l8+1);
  [r2dot3l8] r2=7 & r2retry_t3l8 >= r2_maxRetry_t3l8 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..3];
  worker1retry_t3l1a : [0..worker1_maxRetry_t3l1a] init 0;

  [worker1dot3l1aRetry] worker1=0 & worker1retry_t3l1a < worker1_maxRetry_t3l1a -> p_worker1_t3l1a : (worker1'=worker1+1) + (1-p_worker1_t3l1a) : (worker1'=worker1) & (worker1retry_t3l1a' = worker1retry_t3l1a+1);
  [worker1dot3l1a] worker1=0 & worker1retry_t3l1a >= worker1_maxRetry_t3l1a -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [worker2movel4] true:1;
  [worker2movel7] true:1;
  [worker2dot1l7] true:3;
  [worker2dot1l7Retry] true:3;
  [worker2movel8] true:1;
  [worker2movel9] true:1;
  [worker2dot1l9] true:3;
  [worker2dot1l9Retry] true:3;
  [r1dot3l1b] true:1;
  [r1dot3l1bRetry] true:1;
  [r1movel2] true:1;
  [r1dot2l2] true:1;
  [r1dot2l2Retry] true:1;
  [r1movel3] true:1;
  [r1dot2l3] true:1;
  [r1dot2l3Retry] true:1;
  [r1dot3l3] true:1;
  [r1dot3l3Retry] true:1;
  [r1movel6] true:1;
  [r1dot3l6] true:1;
  [r1dot3l6Retry] true:1;
  [r2movel4] true:1;
  [r2dot2l4] true:1;
  [r2dot2l4Retry] true:1;
  [r2movel7] true:1;
  [r2dot2l7] true:1;
  [r2dot2l7Retry] true:1;
  [r2dot3l7] true:1;
  [r2dot3l7Retry] true:1;
  [r2movel8] true:1;
  [r2dot2l8] true:1;
  [r2dot2l8Retry] true:1;
  [r2dot3l8] true:1;
  [r2dot3l8Retry] true:1;
  [worker1dot3l1a] true:5;
  [worker1dot3l1aRetry] true:5;
endrewards