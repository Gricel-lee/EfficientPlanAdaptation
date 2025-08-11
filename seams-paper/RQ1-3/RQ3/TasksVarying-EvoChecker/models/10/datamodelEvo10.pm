dtmc
evolve int worker1_maxRetry_t3l1 [1..5];
evolve int worker2_maxRetry_t1l4b [1..5];
evolve int worker2_maxRetry_t1l4a [1..5];
evolve int worker2_maxRetry_t3l7 [1..5];
evolve int worker2_maxRetry_t1l8 [1..5];
evolve int worker2_maxRetry_t1l9 [1..5];
evolve int worker2_maxRetry_t3l6a [1..5];
evolve int worker2_maxRetry_t3l6b [1..5];
evolve int r1_maxRetry_t2l1b [1..10];
evolve int r1_maxRetry_t2l1a [1..10];

const double p_worker1_t3l1=0.99;
const double p_worker2_t1l4b=1.0;
const double p_worker2_t1l4a=1.0;
const double p_worker2_t3l7=0.99;
const double p_worker2_t1l8=1.0;
const double p_worker2_t1l9=1.0;
const double p_worker2_t3l6a=0.99;
const double p_worker2_t3l6b=0.99;
const double p_r1_t2l1b=0.99;
const double p_r1_t2l1a=0.99;
const int worker1Final = 1;
const int worker1Fail = 2;
const int worker2Final = 12;
const int worker2Fail = 13;
const int r1Final = 2;
const int r1Fail = 3;

module _worker1
  worker1 : [0..3];
  worker1retry_t3l1 : [0..worker1_maxRetry_t3l1] init 0;

  [worker1dot3l1Retry] worker1=0 & worker1retry_t3l1 < worker1_maxRetry_t3l1 -> p_worker1_t3l1 : (worker1'=worker1+1) + (1-p_worker1_t3l1) : (worker1'=worker1) & (worker1retry_t3l1' = worker1retry_t3l1+1);
  [worker1dot3l1] worker1=0 & worker1retry_t3l1 >= worker1_maxRetry_t3l1 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..14];
  worker2retry_t1l4b : [0..worker2_maxRetry_t1l4b] init 0;
  worker2retry_t1l4a : [0..worker2_maxRetry_t1l4a] init 0;
  worker2retry_t3l7 : [0..worker2_maxRetry_t3l7] init 0;
  worker2retry_t1l8 : [0..worker2_maxRetry_t1l8] init 0;
  worker2retry_t1l9 : [0..worker2_maxRetry_t1l9] init 0;
  worker2retry_t3l6a : [0..worker2_maxRetry_t3l6a] init 0;
  worker2retry_t3l6b : [0..worker2_maxRetry_t3l6b] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l4bRetry] worker2=1 & worker2retry_t1l4b < worker2_maxRetry_t1l4b -> p_worker2_t1l4b : (worker2'=worker2+1) + (1-p_worker2_t1l4b) : (worker2'=worker2) & (worker2retry_t1l4b' = worker2retry_t1l4b+1);
  [worker2dot1l4b] worker2=1 & worker2retry_t1l4b >= worker2_maxRetry_t1l4b -> 1:(worker2'=worker2Fail);
  [worker2dot1l4aRetry] worker2=2 & worker2retry_t1l4a < worker2_maxRetry_t1l4a -> p_worker2_t1l4a : (worker2'=worker2+1) + (1-p_worker2_t1l4a) : (worker2'=worker2) & (worker2retry_t1l4a' = worker2retry_t1l4a+1);
  [worker2dot1l4a] worker2=2 & worker2retry_t1l4a >= worker2_maxRetry_t1l4a -> 1:(worker2'=worker2Fail);
  [worker2movel7] worker2=3-> 1:(worker2'=3+1);
  [worker2dot3l7Retry] worker2=4 & worker2retry_t3l7 < worker2_maxRetry_t3l7 -> p_worker2_t3l7 : (worker2'=worker2+1) + (1-p_worker2_t3l7) : (worker2'=worker2) & (worker2retry_t3l7' = worker2retry_t3l7+1);
  [worker2dot3l7] worker2=4 & worker2retry_t3l7 >= worker2_maxRetry_t3l7 -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=5-> 1:(worker2'=5+1);
  [worker2dot1l8Retry] worker2=6 & worker2retry_t1l8 < worker2_maxRetry_t1l8 -> p_worker2_t1l8 : (worker2'=worker2+1) + (1-p_worker2_t1l8) : (worker2'=worker2) & (worker2retry_t1l8' = worker2retry_t1l8+1);
  [worker2dot1l8] worker2=6 & worker2retry_t1l8 >= worker2_maxRetry_t1l8 -> 1:(worker2'=worker2Fail);
  [worker2movel9] worker2=7-> 1:(worker2'=7+1);
  [worker2dot1l9Retry] worker2=8 & worker2retry_t1l9 < worker2_maxRetry_t1l9 -> p_worker2_t1l9 : (worker2'=worker2+1) + (1-p_worker2_t1l9) : (worker2'=worker2) & (worker2retry_t1l9' = worker2retry_t1l9+1);
  [worker2dot1l9] worker2=8 & worker2retry_t1l9 >= worker2_maxRetry_t1l9 -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=9-> 1:(worker2'=9+1);
  [worker2dot3l6aRetry] worker2=10 & worker2retry_t3l6a < worker2_maxRetry_t3l6a -> p_worker2_t3l6a : (worker2'=worker2+1) + (1-p_worker2_t3l6a) : (worker2'=worker2) & (worker2retry_t3l6a' = worker2retry_t3l6a+1);
  [worker2dot3l6a] worker2=10 & worker2retry_t3l6a >= worker2_maxRetry_t3l6a -> 1:(worker2'=worker2Fail);
  [worker2dot3l6bRetry] worker2=11 & worker2retry_t3l6b < worker2_maxRetry_t3l6b -> p_worker2_t3l6b : (worker2'=worker2+1) + (1-p_worker2_t3l6b) : (worker2'=worker2) & (worker2retry_t3l6b' = worker2retry_t3l6b+1);
  [worker2dot3l6b] worker2=11 & worker2retry_t3l6b >= worker2_maxRetry_t3l6b -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..4];
  r1retry_t2l1b : [0..r1_maxRetry_t2l1b] init 0;
  r1retry_t2l1a : [0..r1_maxRetry_t2l1a] init 0;

  [r1dot2l1bRetry] r1=0 & r1retry_t2l1b < r1_maxRetry_t2l1b -> p_r1_t2l1b : (r1'=r1+1) + (1-p_r1_t2l1b) : (r1'=r1) & (r1retry_t2l1b' = r1retry_t2l1b+1);
  [r1dot2l1b] r1=0 & r1retry_t2l1b >= r1_maxRetry_t2l1b -> 1:(r1'=r1Fail);
  [r1dot2l1aRetry] r1=1 & r1retry_t2l1a < r1_maxRetry_t2l1a -> p_r1_t2l1a : (r1'=r1+1) + (1-p_r1_t2l1a) : (r1'=r1) & (r1retry_t2l1a' = r1retry_t2l1a+1);
  [r1dot2l1a] r1=1 & r1retry_t2l1a >= r1_maxRetry_t2l1a -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [worker1dot3l1] true:5;
  [worker1dot3l1Retry] true:5;
  [worker2movel4] true:1;
  [worker2dot1l4b] true:3;
  [worker2dot1l4bRetry] true:3;
  [worker2dot1l4a] true:3;
  [worker2dot1l4aRetry] true:3;
  [worker2movel7] true:1;
  [worker2dot3l7] true:5;
  [worker2dot3l7Retry] true:5;
  [worker2movel8] true:1;
  [worker2dot1l8] true:3;
  [worker2dot1l8Retry] true:3;
  [worker2movel9] true:1;
  [worker2dot1l9] true:3;
  [worker2dot1l9Retry] true:3;
  [worker2movel6] true:1;
  [worker2dot3l6a] true:5;
  [worker2dot3l6aRetry] true:5;
  [worker2dot3l6b] true:5;
  [worker2dot3l6bRetry] true:5;
  [r1dot2l1b] true:1;
  [r1dot2l1bRetry] true:1;
  [r1dot2l1a] true:1;
  [r1dot2l1aRetry] true:1;
endrewards