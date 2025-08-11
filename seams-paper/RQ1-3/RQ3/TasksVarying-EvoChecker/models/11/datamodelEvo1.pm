dtmc
evolve int r2_maxRetry_t2l4 [1..10];
evolve int r2_maxRetry_t3l5 [1..10];
evolve int r2_maxRetry_t2l5 [1..10];
evolve int r2_maxRetry_t2l8 [1..10];
evolve int worker1_maxRetry_t1l1b [1..5];
evolve int worker1_maxRetry_t1l1a [1..5];
evolve int worker1_maxRetry_t1l7 [1..5];
evolve int worker2_maxRetry_t1l3 [1..5];
evolve int worker2_maxRetry_t3l6c [1..5];
evolve int worker2_maxRetry_t3l6b [1..5];
evolve int worker2_maxRetry_t3l6a [1..5];

const double p_r2_t2l4=0.99;
const double p_r2_t3l5=0.97;
const double p_r2_t2l5=0.99;
const double p_r2_t2l8=0.99;
const double p_worker1_t1l1b=1.0;
const double p_worker1_t1l1a=1.0;
const double p_worker1_t1l7=1.0;
const double p_worker2_t1l3=1.0;
const double p_worker2_t3l6c=0.99;
const double p_worker2_t3l6b=0.99;
const double p_worker2_t3l6a=0.99;
const int r2Final = 7;
const int r2Fail = 8;
const int worker1Final = 5;
const int worker1Fail = 6;
const int worker2Final = 7;
const int worker2Fail = 8;

module _r2
  r2 : [0..9];
  r2retry_t2l4 : [0..r2_maxRetry_t2l4] init 0;
  r2retry_t3l5 : [0..r2_maxRetry_t3l5] init 0;
  r2retry_t2l5 : [0..r2_maxRetry_t2l5] init 0;
  r2retry_t2l8 : [0..r2_maxRetry_t2l8] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2dot2l4Retry] r2=1 & r2retry_t2l4 < r2_maxRetry_t2l4 -> p_r2_t2l4 : (r2'=r2+1) + (1-p_r2_t2l4) : (r2'=r2) & (r2retry_t2l4' = r2retry_t2l4+1);
  [r2dot2l4] r2=1 & r2retry_t2l4 >= r2_maxRetry_t2l4 -> 1:(r2'=r2Fail);
  [r2movel5] r2=2-> 1:(r2'=2+1);
  [r2dot3l5Retry] r2=3 & r2retry_t3l5 < r2_maxRetry_t3l5 -> p_r2_t3l5 : (r2'=r2+1) + (1-p_r2_t3l5) : (r2'=r2) & (r2retry_t3l5' = r2retry_t3l5+1);
  [r2dot3l5] r2=3 & r2retry_t3l5 >= r2_maxRetry_t3l5 -> 1:(r2'=r2Fail);
  [r2dot2l5Retry] r2=4 & r2retry_t2l5 < r2_maxRetry_t2l5 -> p_r2_t2l5 : (r2'=r2+1) + (1-p_r2_t2l5) : (r2'=r2) & (r2retry_t2l5' = r2retry_t2l5+1);
  [r2dot2l5] r2=4 & r2retry_t2l5 >= r2_maxRetry_t2l5 -> 1:(r2'=r2Fail);
  [r2movel8] r2=5-> 1:(r2'=5+1);
  [r2dot2l8Retry] r2=6 & r2retry_t2l8 < r2_maxRetry_t2l8 -> p_r2_t2l8 : (r2'=r2+1) + (1-p_r2_t2l8) : (r2'=r2) & (r2retry_t2l8' = r2retry_t2l8+1);
  [r2dot2l8] r2=6 & r2retry_t2l8 >= r2_maxRetry_t2l8 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..7];
  worker1retry_t1l1b : [0..worker1_maxRetry_t1l1b] init 0;
  worker1retry_t1l1a : [0..worker1_maxRetry_t1l1a] init 0;
  worker1retry_t1l7 : [0..worker1_maxRetry_t1l7] init 0;

  [worker1dot1l1bRetry] worker1=0 & worker1retry_t1l1b < worker1_maxRetry_t1l1b -> p_worker1_t1l1b : (worker1'=worker1+1) + (1-p_worker1_t1l1b) : (worker1'=worker1) & (worker1retry_t1l1b' = worker1retry_t1l1b+1);
  [worker1dot1l1b] worker1=0 & worker1retry_t1l1b >= worker1_maxRetry_t1l1b -> 1:(worker1'=worker1Fail);
  [worker1dot1l1aRetry] worker1=1 & worker1retry_t1l1a < worker1_maxRetry_t1l1a -> p_worker1_t1l1a : (worker1'=worker1+1) + (1-p_worker1_t1l1a) : (worker1'=worker1) & (worker1retry_t1l1a' = worker1retry_t1l1a+1);
  [worker1dot1l1a] worker1=1 & worker1retry_t1l1a >= worker1_maxRetry_t1l1a -> 1:(worker1'=worker1Fail);
  [worker1movel4] worker1=2-> 1:(worker1'=2+1);
  [worker1movel7] worker1=3-> 1:(worker1'=3+1);
  [worker1dot1l7Retry] worker1=4 & worker1retry_t1l7 < worker1_maxRetry_t1l7 -> p_worker1_t1l7 : (worker1'=worker1+1) + (1-p_worker1_t1l7) : (worker1'=worker1) & (worker1retry_t1l7' = worker1retry_t1l7+1);
  [worker1dot1l7] worker1=4 & worker1retry_t1l7 >= worker1_maxRetry_t1l7 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..9];
  worker2retry_t1l3 : [0..worker2_maxRetry_t1l3] init 0;
  worker2retry_t3l6c : [0..worker2_maxRetry_t3l6c] init 0;
  worker2retry_t3l6b : [0..worker2_maxRetry_t3l6b] init 0;
  worker2retry_t3l6a : [0..worker2_maxRetry_t3l6a] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2movel3] worker2=1-> 1:(worker2'=1+1);
  [worker2dot1l3Retry] worker2=2 & worker2retry_t1l3 < worker2_maxRetry_t1l3 -> p_worker2_t1l3 : (worker2'=worker2+1) + (1-p_worker2_t1l3) : (worker2'=worker2) & (worker2retry_t1l3' = worker2retry_t1l3+1);
  [worker2dot1l3] worker2=2 & worker2retry_t1l3 >= worker2_maxRetry_t1l3 -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=3-> 1:(worker2'=3+1);
  [worker2dot3l6cRetry] worker2=4 & worker2retry_t3l6c < worker2_maxRetry_t3l6c -> p_worker2_t3l6c : (worker2'=worker2+1) + (1-p_worker2_t3l6c) : (worker2'=worker2) & (worker2retry_t3l6c' = worker2retry_t3l6c+1);
  [worker2dot3l6c] worker2=4 & worker2retry_t3l6c >= worker2_maxRetry_t3l6c -> 1:(worker2'=worker2Fail);
  [worker2dot3l6bRetry] worker2=5 & worker2retry_t3l6b < worker2_maxRetry_t3l6b -> p_worker2_t3l6b : (worker2'=worker2+1) + (1-p_worker2_t3l6b) : (worker2'=worker2) & (worker2retry_t3l6b' = worker2retry_t3l6b+1);
  [worker2dot3l6b] worker2=5 & worker2retry_t3l6b >= worker2_maxRetry_t3l6b -> 1:(worker2'=worker2Fail);
  [worker2dot3l6aRetry] worker2=6 & worker2retry_t3l6a < worker2_maxRetry_t3l6a -> p_worker2_t3l6a : (worker2'=worker2+1) + (1-p_worker2_t3l6a) : (worker2'=worker2) & (worker2retry_t3l6a' = worker2retry_t3l6a+1);
  [worker2dot3l6a] worker2=6 & worker2retry_t3l6a >= worker2_maxRetry_t3l6a -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r2movel4] true:1;
  [r2dot2l4] true:1;
  [r2dot2l4Retry] true:1;
  [r2movel5] true:1;
  [r2dot3l5] true:1;
  [r2dot3l5Retry] true:1;
  [r2dot2l5] true:1;
  [r2dot2l5Retry] true:1;
  [r2movel8] true:1;
  [r2dot2l8] true:1;
  [r2dot2l8Retry] true:1;
  [worker1dot1l1b] true:3;
  [worker1dot1l1bRetry] true:3;
  [worker1dot1l1a] true:3;
  [worker1dot1l1aRetry] true:3;
  [worker1movel4] true:1;
  [worker1movel7] true:1;
  [worker1dot1l7] true:3;
  [worker1dot1l7Retry] true:3;
  [worker2movel2] true:1;
  [worker2movel3] true:1;
  [worker2dot1l3] true:3;
  [worker2dot1l3Retry] true:3;
  [worker2movel6] true:1;
  [worker2dot3l6c] true:5;
  [worker2dot3l6cRetry] true:5;
  [worker2dot3l6b] true:5;
  [worker2dot3l6bRetry] true:5;
  [worker2dot3l6a] true:5;
  [worker2dot3l6aRetry] true:5;
endrewards