dtmc
evolve int r1_maxRetry_t2l2 [1..10];
evolve int r1_maxRetry_t2l6 [1..10];
evolve int r1_maxRetry_t2l9b [1..10];
evolve int r1_maxRetry_t2l9a [1..10];
evolve int r1_maxRetry_t2l8 [1..10];
evolve int r2_maxRetry_t2l1 [1..10];
evolve int worker1_maxRetry_t3l4a [1..5];
evolve int worker1_maxRetry_t1l4b [1..5];
evolve int worker1_maxRetry_t3l4b [1..5];
evolve int worker1_maxRetry_t1l4a [1..5];
evolve int worker1_maxRetry_t1l7 [1..5];
evolve int worker2_maxRetry_t1l2 [1..5];

const double p_r1_t2l2=0.99;
const double p_r1_t2l6=0.99;
const double p_r1_t2l9b=0.99;
const double p_r1_t2l9a=0.99;
const double p_r1_t2l8=0.99;
const double p_r2_t2l1=0.99;
const double p_worker1_t3l4a=0.99;
const double p_worker1_t1l4b=1.0;
const double p_worker1_t3l4b=0.99;
const double p_worker1_t1l4a=1.0;
const double p_worker1_t1l7=1.0;
const double p_worker2_t1l2=1.0;
const int r1Final = 10;
const int r1Fail = 11;
const int r2Final = 1;
const int r2Fail = 2;
const int worker1Final = 7;
const int worker1Fail = 8;
const int worker2Final = 2;
const int worker2Fail = 3;

module _r1
  r1 : [0..12];
  r1retry_t2l2 : [0..r1_maxRetry_t2l2] init 0;
  r1retry_t2l6 : [0..r1_maxRetry_t2l6] init 0;
  r1retry_t2l9b : [0..r1_maxRetry_t2l9b] init 0;
  r1retry_t2l9a : [0..r1_maxRetry_t2l9a] init 0;
  r1retry_t2l8 : [0..r1_maxRetry_t2l8] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1dot2l2Retry] r1=1 & r1retry_t2l2 < r1_maxRetry_t2l2 -> p_r1_t2l2 : (r1'=r1+1) + (1-p_r1_t2l2) : (r1'=r1) & (r1retry_t2l2' = r1retry_t2l2+1);
  [r1dot2l2] r1=1 & r1retry_t2l2 >= r1_maxRetry_t2l2 -> 1:(r1'=r1Fail);
  [r1movel5] r1=2-> 1:(r1'=2+1);
  [r1movel6] r1=3-> 1:(r1'=3+1);
  [r1dot2l6Retry] r1=4 & r1retry_t2l6 < r1_maxRetry_t2l6 -> p_r1_t2l6 : (r1'=r1+1) + (1-p_r1_t2l6) : (r1'=r1) & (r1retry_t2l6' = r1retry_t2l6+1);
  [r1dot2l6] r1=4 & r1retry_t2l6 >= r1_maxRetry_t2l6 -> 1:(r1'=r1Fail);
  [r1movel9] r1=5-> 1:(r1'=5+1);
  [r1dot2l9bRetry] r1=6 & r1retry_t2l9b < r1_maxRetry_t2l9b -> p_r1_t2l9b : (r1'=r1+1) + (1-p_r1_t2l9b) : (r1'=r1) & (r1retry_t2l9b' = r1retry_t2l9b+1);
  [r1dot2l9b] r1=6 & r1retry_t2l9b >= r1_maxRetry_t2l9b -> 1:(r1'=r1Fail);
  [r1dot2l9aRetry] r1=7 & r1retry_t2l9a < r1_maxRetry_t2l9a -> p_r1_t2l9a : (r1'=r1+1) + (1-p_r1_t2l9a) : (r1'=r1) & (r1retry_t2l9a' = r1retry_t2l9a+1);
  [r1dot2l9a] r1=7 & r1retry_t2l9a >= r1_maxRetry_t2l9a -> 1:(r1'=r1Fail);
  [r1movel8] r1=8-> 1:(r1'=8+1);
  [r1dot2l8Retry] r1=9 & r1retry_t2l8 < r1_maxRetry_t2l8 -> p_r1_t2l8 : (r1'=r1+1) + (1-p_r1_t2l8) : (r1'=r1) & (r1retry_t2l8' = r1retry_t2l8+1);
  [r1dot2l8] r1=9 & r1retry_t2l8 >= r1_maxRetry_t2l8 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..3];
  r2retry_t2l1 : [0..r2_maxRetry_t2l1] init 0;

  [r2dot2l1Retry] r2=0 & r2retry_t2l1 < r2_maxRetry_t2l1 -> p_r2_t2l1 : (r2'=r2+1) + (1-p_r2_t2l1) : (r2'=r2) & (r2retry_t2l1' = r2retry_t2l1+1);
  [r2dot2l1] r2=0 & r2retry_t2l1 >= r2_maxRetry_t2l1 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..9];
  worker1retry_t3l4a : [0..worker1_maxRetry_t3l4a] init 0;
  worker1retry_t1l4b : [0..worker1_maxRetry_t1l4b] init 0;
  worker1retry_t3l4b : [0..worker1_maxRetry_t3l4b] init 0;
  worker1retry_t1l4a : [0..worker1_maxRetry_t1l4a] init 0;
  worker1retry_t1l7 : [0..worker1_maxRetry_t1l7] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot3l4aRetry] worker1=1 & worker1retry_t3l4a < worker1_maxRetry_t3l4a -> p_worker1_t3l4a : (worker1'=worker1+1) + (1-p_worker1_t3l4a) : (worker1'=worker1) & (worker1retry_t3l4a' = worker1retry_t3l4a+1);
  [worker1dot3l4a] worker1=1 & worker1retry_t3l4a >= worker1_maxRetry_t3l4a -> 1:(worker1'=worker1Fail);
  [worker1dot1l4bRetry] worker1=2 & worker1retry_t1l4b < worker1_maxRetry_t1l4b -> p_worker1_t1l4b : (worker1'=worker1+1) + (1-p_worker1_t1l4b) : (worker1'=worker1) & (worker1retry_t1l4b' = worker1retry_t1l4b+1);
  [worker1dot1l4b] worker1=2 & worker1retry_t1l4b >= worker1_maxRetry_t1l4b -> 1:(worker1'=worker1Fail);
  [worker1dot3l4bRetry] worker1=3 & worker1retry_t3l4b < worker1_maxRetry_t3l4b -> p_worker1_t3l4b : (worker1'=worker1+1) + (1-p_worker1_t3l4b) : (worker1'=worker1) & (worker1retry_t3l4b' = worker1retry_t3l4b+1);
  [worker1dot3l4b] worker1=3 & worker1retry_t3l4b >= worker1_maxRetry_t3l4b -> 1:(worker1'=worker1Fail);
  [worker1dot1l4aRetry] worker1=4 & worker1retry_t1l4a < worker1_maxRetry_t1l4a -> p_worker1_t1l4a : (worker1'=worker1+1) + (1-p_worker1_t1l4a) : (worker1'=worker1) & (worker1retry_t1l4a' = worker1retry_t1l4a+1);
  [worker1dot1l4a] worker1=4 & worker1retry_t1l4a >= worker1_maxRetry_t1l4a -> 1:(worker1'=worker1Fail);
  [worker1movel7] worker1=5-> 1:(worker1'=5+1);
  [worker1dot1l7Retry] worker1=6 & worker1retry_t1l7 < worker1_maxRetry_t1l7 -> p_worker1_t1l7 : (worker1'=worker1+1) + (1-p_worker1_t1l7) : (worker1'=worker1) & (worker1retry_t1l7' = worker1retry_t1l7+1);
  [worker1dot1l7] worker1=6 & worker1retry_t1l7 >= worker1_maxRetry_t1l7 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..4];
  worker2retry_t1l2 : [0..worker2_maxRetry_t1l2] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l2Retry] worker2=1 & worker2retry_t1l2 < worker2_maxRetry_t1l2 -> p_worker2_t1l2 : (worker2'=worker2+1) + (1-p_worker2_t1l2) : (worker2'=worker2) & (worker2retry_t1l2' = worker2retry_t1l2+1);
  [worker2dot1l2] worker2=1 & worker2retry_t1l2 >= worker2_maxRetry_t1l2 -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r1movel2] true:1;
  [r1dot2l2] true:1;
  [r1dot2l2Retry] true:1;
  [r1movel5] true:1;
  [r1movel6] true:1;
  [r1dot2l6] true:1;
  [r1dot2l6Retry] true:1;
  [r1movel9] true:1;
  [r1dot2l9b] true:1;
  [r1dot2l9bRetry] true:1;
  [r1dot2l9a] true:1;
  [r1dot2l9aRetry] true:1;
  [r1movel8] true:1;
  [r1dot2l8] true:1;
  [r1dot2l8Retry] true:1;
  [r2dot2l1] true:1;
  [r2dot2l1Retry] true:1;
  [worker1movel4] true:1;
  [worker1dot3l4a] true:5;
  [worker1dot3l4aRetry] true:5;
  [worker1dot1l4b] true:3;
  [worker1dot1l4bRetry] true:3;
  [worker1dot3l4b] true:5;
  [worker1dot3l4bRetry] true:5;
  [worker1dot1l4a] true:3;
  [worker1dot1l4aRetry] true:3;
  [worker1movel7] true:1;
  [worker1dot1l7] true:3;
  [worker1dot1l7Retry] true:3;
  [worker2movel2] true:1;
  [worker2dot1l2] true:3;
  [worker2dot1l2Retry] true:3;
endrewards