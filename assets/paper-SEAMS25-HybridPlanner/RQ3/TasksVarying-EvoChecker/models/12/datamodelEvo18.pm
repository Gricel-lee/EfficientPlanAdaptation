dtmc
evolve int r2_maxRetry_t2l2a [1..10];
evolve int r2_maxRetry_t2l2c [1..10];
evolve int r2_maxRetry_t2l2b [1..10];
evolve int r2_maxRetry_t3l3 [1..10];
evolve int r2_maxRetry_t3l6 [1..10];
evolve int r2_maxRetry_t2l5a [1..10];
evolve int r2_maxRetry_t2l5b [1..10];
evolve int worker1_maxRetry_t1l4b [1..5];
evolve int worker1_maxRetry_t1l4a [1..5];
evolve int worker1_maxRetry_t1l7 [1..5];
evolve int worker1_maxRetry_t3l8 [1..5];
evolve int worker2_maxRetry_t1l1 [1..5];

const double p_r2_t2l2a=0.99;
const double p_r2_t2l2c=0.99;
const double p_r2_t2l2b=0.99;
const double p_r2_t3l3=0.97;
const double p_r2_t3l6=0.97;
const double p_r2_t2l5a=0.99;
const double p_r2_t2l5b=0.99;
const double p_worker1_t1l4b=1.0;
const double p_worker1_t1l4a=1.0;
const double p_worker1_t1l7=1.0;
const double p_worker1_t3l8=0.99;
const double p_worker2_t1l1=1.0;
const int r2Final = 11;
const int r2Fail = 12;
const int worker1Final = 7;
const int worker1Fail = 8;
const int worker2Final = 1;
const int worker2Fail = 2;

module _r2
  r2 : [0..13];
  r2retry_t2l2a : [0..r2_maxRetry_t2l2a] init 0;
  r2retry_t2l2c : [0..r2_maxRetry_t2l2c] init 0;
  r2retry_t2l2b : [0..r2_maxRetry_t2l2b] init 0;
  r2retry_t3l3 : [0..r2_maxRetry_t3l3] init 0;
  r2retry_t3l6 : [0..r2_maxRetry_t3l6] init 0;
  r2retry_t2l5a : [0..r2_maxRetry_t2l5a] init 0;
  r2retry_t2l5b : [0..r2_maxRetry_t2l5b] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2dot2l2aRetry] r2=1 & r2retry_t2l2a < r2_maxRetry_t2l2a -> p_r2_t2l2a : (r2'=r2+1) + (1-p_r2_t2l2a) : (r2'=r2) & (r2retry_t2l2a' = r2retry_t2l2a+1);
  [r2dot2l2a] r2=1 & r2retry_t2l2a >= r2_maxRetry_t2l2a -> 1:(r2'=r2Fail);
  [r2dot2l2cRetry] r2=2 & r2retry_t2l2c < r2_maxRetry_t2l2c -> p_r2_t2l2c : (r2'=r2+1) + (1-p_r2_t2l2c) : (r2'=r2) & (r2retry_t2l2c' = r2retry_t2l2c+1);
  [r2dot2l2c] r2=2 & r2retry_t2l2c >= r2_maxRetry_t2l2c -> 1:(r2'=r2Fail);
  [r2dot2l2bRetry] r2=3 & r2retry_t2l2b < r2_maxRetry_t2l2b -> p_r2_t2l2b : (r2'=r2+1) + (1-p_r2_t2l2b) : (r2'=r2) & (r2retry_t2l2b' = r2retry_t2l2b+1);
  [r2dot2l2b] r2=3 & r2retry_t2l2b >= r2_maxRetry_t2l2b -> 1:(r2'=r2Fail);
  [r2movel3] r2=4-> 1:(r2'=4+1);
  [r2dot3l3Retry] r2=5 & r2retry_t3l3 < r2_maxRetry_t3l3 -> p_r2_t3l3 : (r2'=r2+1) + (1-p_r2_t3l3) : (r2'=r2) & (r2retry_t3l3' = r2retry_t3l3+1);
  [r2dot3l3] r2=5 & r2retry_t3l3 >= r2_maxRetry_t3l3 -> 1:(r2'=r2Fail);
  [r2movel6] r2=6-> 1:(r2'=6+1);
  [r2dot3l6Retry] r2=7 & r2retry_t3l6 < r2_maxRetry_t3l6 -> p_r2_t3l6 : (r2'=r2+1) + (1-p_r2_t3l6) : (r2'=r2) & (r2retry_t3l6' = r2retry_t3l6+1);
  [r2dot3l6] r2=7 & r2retry_t3l6 >= r2_maxRetry_t3l6 -> 1:(r2'=r2Fail);
  [r2movel5] r2=8-> 1:(r2'=8+1);
  [r2dot2l5aRetry] r2=9 & r2retry_t2l5a < r2_maxRetry_t2l5a -> p_r2_t2l5a : (r2'=r2+1) + (1-p_r2_t2l5a) : (r2'=r2) & (r2retry_t2l5a' = r2retry_t2l5a+1);
  [r2dot2l5a] r2=9 & r2retry_t2l5a >= r2_maxRetry_t2l5a -> 1:(r2'=r2Fail);
  [r2dot2l5bRetry] r2=10 & r2retry_t2l5b < r2_maxRetry_t2l5b -> p_r2_t2l5b : (r2'=r2+1) + (1-p_r2_t2l5b) : (r2'=r2) & (r2retry_t2l5b' = r2retry_t2l5b+1);
  [r2dot2l5b] r2=10 & r2retry_t2l5b >= r2_maxRetry_t2l5b -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..9];
  worker1retry_t1l4b : [0..worker1_maxRetry_t1l4b] init 0;
  worker1retry_t1l4a : [0..worker1_maxRetry_t1l4a] init 0;
  worker1retry_t1l7 : [0..worker1_maxRetry_t1l7] init 0;
  worker1retry_t3l8 : [0..worker1_maxRetry_t3l8] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l4bRetry] worker1=1 & worker1retry_t1l4b < worker1_maxRetry_t1l4b -> p_worker1_t1l4b : (worker1'=worker1+1) + (1-p_worker1_t1l4b) : (worker1'=worker1) & (worker1retry_t1l4b' = worker1retry_t1l4b+1);
  [worker1dot1l4b] worker1=1 & worker1retry_t1l4b >= worker1_maxRetry_t1l4b -> 1:(worker1'=worker1Fail);
  [worker1dot1l4aRetry] worker1=2 & worker1retry_t1l4a < worker1_maxRetry_t1l4a -> p_worker1_t1l4a : (worker1'=worker1+1) + (1-p_worker1_t1l4a) : (worker1'=worker1) & (worker1retry_t1l4a' = worker1retry_t1l4a+1);
  [worker1dot1l4a] worker1=2 & worker1retry_t1l4a >= worker1_maxRetry_t1l4a -> 1:(worker1'=worker1Fail);
  [worker1movel7] worker1=3-> 1:(worker1'=3+1);
  [worker1dot1l7Retry] worker1=4 & worker1retry_t1l7 < worker1_maxRetry_t1l7 -> p_worker1_t1l7 : (worker1'=worker1+1) + (1-p_worker1_t1l7) : (worker1'=worker1) & (worker1retry_t1l7' = worker1retry_t1l7+1);
  [worker1dot1l7] worker1=4 & worker1retry_t1l7 >= worker1_maxRetry_t1l7 -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=5-> 1:(worker1'=5+1);
  [worker1dot3l8Retry] worker1=6 & worker1retry_t3l8 < worker1_maxRetry_t3l8 -> p_worker1_t3l8 : (worker1'=worker1+1) + (1-p_worker1_t3l8) : (worker1'=worker1) & (worker1retry_t3l8' = worker1retry_t3l8+1);
  [worker1dot3l8] worker1=6 & worker1retry_t3l8 >= worker1_maxRetry_t3l8 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..3];
  worker2retry_t1l1 : [0..worker2_maxRetry_t1l1] init 0;

  [worker2dot1l1Retry] worker2=0 & worker2retry_t1l1 < worker2_maxRetry_t1l1 -> p_worker2_t1l1 : (worker2'=worker2+1) + (1-p_worker2_t1l1) : (worker2'=worker2) & (worker2retry_t1l1' = worker2retry_t1l1+1);
  [worker2dot1l1] worker2=0 & worker2retry_t1l1 >= worker2_maxRetry_t1l1 -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r2movel2] true:1;
  [r2dot2l2a] true:1;
  [r2dot2l2aRetry] true:1;
  [r2dot2l2c] true:1;
  [r2dot2l2cRetry] true:1;
  [r2dot2l2b] true:1;
  [r2dot2l2bRetry] true:1;
  [r2movel3] true:1;
  [r2dot3l3] true:1;
  [r2dot3l3Retry] true:1;
  [r2movel6] true:1;
  [r2dot3l6] true:1;
  [r2dot3l6Retry] true:1;
  [r2movel5] true:1;
  [r2dot2l5a] true:1;
  [r2dot2l5aRetry] true:1;
  [r2dot2l5b] true:1;
  [r2dot2l5bRetry] true:1;
  [worker1movel4] true:1;
  [worker1dot1l4b] true:3;
  [worker1dot1l4bRetry] true:3;
  [worker1dot1l4a] true:3;
  [worker1dot1l4aRetry] true:3;
  [worker1movel7] true:1;
  [worker1dot1l7] true:3;
  [worker1dot1l7Retry] true:3;
  [worker1movel8] true:1;
  [worker1dot3l8] true:5;
  [worker1dot3l8Retry] true:5;
  [worker2dot1l1] true:3;
  [worker2dot1l1Retry] true:3;
endrewards