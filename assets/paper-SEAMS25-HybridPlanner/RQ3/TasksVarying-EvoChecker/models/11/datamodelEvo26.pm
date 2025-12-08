dtmc
evolve int r2_maxRetry_t2l8 [1..10];
evolve int r2_maxRetry_t3l9 [1..10];
evolve int r2_maxRetry_t2l9 [1..10];
evolve int worker1_maxRetry_t1l2a [1..5];
evolve int worker1_maxRetry_t3l2 [1..5];
evolve int worker1_maxRetry_t1l2b [1..5];
evolve int worker1_maxRetry_t3l3 [1..5];
evolve int worker1_maxRetry_t1l6 [1..5];
evolve int worker1_maxRetry_t1l8 [1..5];
evolve int worker2_maxRetry_t1l1a [1..5];
evolve int worker2_maxRetry_t1l1b [1..5];

const double p_r2_t2l8=0.99;
const double p_r2_t3l9=0.97;
const double p_r2_t2l9=0.99;
const double p_worker1_t1l2a=1.0;
const double p_worker1_t3l2=0.99;
const double p_worker1_t1l2b=1.0;
const double p_worker1_t3l3=0.99;
const double p_worker1_t1l6=1.0;
const double p_worker1_t1l8=1.0;
const double p_worker2_t1l1a=1.0;
const double p_worker2_t1l1b=1.0;
const int r2Final = 7;
const int r2Fail = 8;
const int worker1Final = 11;
const int worker1Fail = 12;
const int worker2Final = 2;
const int worker2Fail = 3;

module _r2
  r2 : [0..9];
  r2retry_t2l8 : [0..r2_maxRetry_t2l8] init 0;
  r2retry_t3l9 : [0..r2_maxRetry_t3l9] init 0;
  r2retry_t2l9 : [0..r2_maxRetry_t2l9] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2movel5] r2=1-> 1:(r2'=1+1);
  [r2movel8] r2=2-> 1:(r2'=2+1);
  [r2dot2l8Retry] r2=3 & r2retry_t2l8 < r2_maxRetry_t2l8 -> p_r2_t2l8 : (r2'=r2+1) + (1-p_r2_t2l8) : (r2'=r2) & (r2retry_t2l8' = r2retry_t2l8+1);
  [r2dot2l8] r2=3 & r2retry_t2l8 >= r2_maxRetry_t2l8 -> 1:(r2'=r2Fail);
  [r2movel9] r2=4-> 1:(r2'=4+1);
  [r2dot3l9Retry] r2=5 & r2retry_t3l9 < r2_maxRetry_t3l9 -> p_r2_t3l9 : (r2'=r2+1) + (1-p_r2_t3l9) : (r2'=r2) & (r2retry_t3l9' = r2retry_t3l9+1);
  [r2dot3l9] r2=5 & r2retry_t3l9 >= r2_maxRetry_t3l9 -> 1:(r2'=r2Fail);
  [r2dot2l9Retry] r2=6 & r2retry_t2l9 < r2_maxRetry_t2l9 -> p_r2_t2l9 : (r2'=r2+1) + (1-p_r2_t2l9) : (r2'=r2) & (r2retry_t2l9' = r2retry_t2l9+1);
  [r2dot2l9] r2=6 & r2retry_t2l9 >= r2_maxRetry_t2l9 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..13];
  worker1retry_t1l2a : [0..worker1_maxRetry_t1l2a] init 0;
  worker1retry_t3l2 : [0..worker1_maxRetry_t3l2] init 0;
  worker1retry_t1l2b : [0..worker1_maxRetry_t1l2b] init 0;
  worker1retry_t3l3 : [0..worker1_maxRetry_t3l3] init 0;
  worker1retry_t1l6 : [0..worker1_maxRetry_t1l6] init 0;
  worker1retry_t1l8 : [0..worker1_maxRetry_t1l8] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l2aRetry] worker1=1 & worker1retry_t1l2a < worker1_maxRetry_t1l2a -> p_worker1_t1l2a : (worker1'=worker1+1) + (1-p_worker1_t1l2a) : (worker1'=worker1) & (worker1retry_t1l2a' = worker1retry_t1l2a+1);
  [worker1dot1l2a] worker1=1 & worker1retry_t1l2a >= worker1_maxRetry_t1l2a -> 1:(worker1'=worker1Fail);
  [worker1dot3l2Retry] worker1=2 & worker1retry_t3l2 < worker1_maxRetry_t3l2 -> p_worker1_t3l2 : (worker1'=worker1+1) + (1-p_worker1_t3l2) : (worker1'=worker1) & (worker1retry_t3l2' = worker1retry_t3l2+1);
  [worker1dot3l2] worker1=2 & worker1retry_t3l2 >= worker1_maxRetry_t3l2 -> 1:(worker1'=worker1Fail);
  [worker1dot1l2bRetry] worker1=3 & worker1retry_t1l2b < worker1_maxRetry_t1l2b -> p_worker1_t1l2b : (worker1'=worker1+1) + (1-p_worker1_t1l2b) : (worker1'=worker1) & (worker1retry_t1l2b' = worker1retry_t1l2b+1);
  [worker1dot1l2b] worker1=3 & worker1retry_t1l2b >= worker1_maxRetry_t1l2b -> 1:(worker1'=worker1Fail);
  [worker1movel3] worker1=4-> 1:(worker1'=4+1);
  [worker1dot3l3Retry] worker1=5 & worker1retry_t3l3 < worker1_maxRetry_t3l3 -> p_worker1_t3l3 : (worker1'=worker1+1) + (1-p_worker1_t3l3) : (worker1'=worker1) & (worker1retry_t3l3' = worker1retry_t3l3+1);
  [worker1dot3l3] worker1=5 & worker1retry_t3l3 >= worker1_maxRetry_t3l3 -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=6-> 1:(worker1'=6+1);
  [worker1dot1l6Retry] worker1=7 & worker1retry_t1l6 < worker1_maxRetry_t1l6 -> p_worker1_t1l6 : (worker1'=worker1+1) + (1-p_worker1_t1l6) : (worker1'=worker1) & (worker1retry_t1l6' = worker1retry_t1l6+1);
  [worker1dot1l6] worker1=7 & worker1retry_t1l6 >= worker1_maxRetry_t1l6 -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=8-> 1:(worker1'=8+1);
  [worker1movel8] worker1=9-> 1:(worker1'=9+1);
  [worker1dot1l8Retry] worker1=10 & worker1retry_t1l8 < worker1_maxRetry_t1l8 -> p_worker1_t1l8 : (worker1'=worker1+1) + (1-p_worker1_t1l8) : (worker1'=worker1) & (worker1retry_t1l8' = worker1retry_t1l8+1);
  [worker1dot1l8] worker1=10 & worker1retry_t1l8 >= worker1_maxRetry_t1l8 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..4];
  worker2retry_t1l1a : [0..worker2_maxRetry_t1l1a] init 0;
  worker2retry_t1l1b : [0..worker2_maxRetry_t1l1b] init 0;

  [worker2dot1l1aRetry] worker2=0 & worker2retry_t1l1a < worker2_maxRetry_t1l1a -> p_worker2_t1l1a : (worker2'=worker2+1) + (1-p_worker2_t1l1a) : (worker2'=worker2) & (worker2retry_t1l1a' = worker2retry_t1l1a+1);
  [worker2dot1l1a] worker2=0 & worker2retry_t1l1a >= worker2_maxRetry_t1l1a -> 1:(worker2'=worker2Fail);
  [worker2dot1l1bRetry] worker2=1 & worker2retry_t1l1b < worker2_maxRetry_t1l1b -> p_worker2_t1l1b : (worker2'=worker2+1) + (1-p_worker2_t1l1b) : (worker2'=worker2) & (worker2retry_t1l1b' = worker2retry_t1l1b+1);
  [worker2dot1l1b] worker2=1 & worker2retry_t1l1b >= worker2_maxRetry_t1l1b -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r2movel4] true:1;
  [r2movel5] true:1;
  [r2movel8] true:1;
  [r2dot2l8] true:1;
  [r2dot2l8Retry] true:1;
  [r2movel9] true:1;
  [r2dot3l9] true:1;
  [r2dot3l9Retry] true:1;
  [r2dot2l9] true:1;
  [r2dot2l9Retry] true:1;
  [worker1movel2] true:1;
  [worker1dot1l2a] true:3;
  [worker1dot1l2aRetry] true:3;
  [worker1dot3l2] true:5;
  [worker1dot3l2Retry] true:5;
  [worker1dot1l2b] true:3;
  [worker1dot1l2bRetry] true:3;
  [worker1movel3] true:1;
  [worker1dot3l3] true:5;
  [worker1dot3l3Retry] true:5;
  [worker1movel6] true:1;
  [worker1dot1l6] true:3;
  [worker1dot1l6Retry] true:3;
  [worker1movel5] true:1;
  [worker1movel8] true:1;
  [worker1dot1l8] true:3;
  [worker1dot1l8Retry] true:3;
  [worker2dot1l1a] true:3;
  [worker2dot1l1aRetry] true:3;
  [worker2dot1l1b] true:3;
  [worker2dot1l1bRetry] true:3;
endrewards