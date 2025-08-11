dtmc
evolve int worker2_maxRetry_t3l1a [1..5];
evolve int worker2_maxRetry_t3l1b [1..5];
evolve int worker2_maxRetry_t3l1c [1..5];
evolve int r1_maxRetry_t3l1d [1..10];
evolve int r1_maxRetry_t2l2 [1..10];
evolve int r2_maxRetry_t2l4 [1..10];
evolve int r2_maxRetry_t2l7 [1..10];
evolve int worker1_maxRetry_t1l7 [1..5];
evolve int worker1_maxRetry_t1l5b [1..5];
evolve int worker1_maxRetry_t1l5a [1..5];
evolve int worker1_maxRetry_t1l8 [1..5];
evolve int worker1_maxRetry_t3l8 [1..5];
evolve int worker1_maxRetry_t1l9 [1..5];

const double p_worker2_t3l1a=0.99;
const double p_worker2_t3l1b=0.99;
const double p_worker2_t3l1c=0.99;
const double p_r1_t3l1d=0.97;
const double p_r1_t2l2=0.99;
const double p_r2_t2l4=0.99;
const double p_r2_t2l7=0.99;
const double p_worker1_t1l7=1.0;
const double p_worker1_t1l5b=1.0;
const double p_worker1_t1l5a=1.0;
const double p_worker1_t1l8=1.0;
const double p_worker1_t3l8=0.99;
const double p_worker1_t1l9=1.0;
const int worker2Final = 3;
const int worker2Fail = 4;
const int r1Final = 3;
const int r1Fail = 4;
const int r2Final = 4;
const int r2Fail = 5;
const int worker1Final = 12;
const int worker1Fail = 13;

module _worker2
  worker2 : [0..5];
  worker2retry_t3l1a : [0..worker2_maxRetry_t3l1a] init 0;
  worker2retry_t3l1b : [0..worker2_maxRetry_t3l1b] init 0;
  worker2retry_t3l1c : [0..worker2_maxRetry_t3l1c] init 0;

  [worker2dot3l1aRetry] worker2=0 & worker2retry_t3l1a < worker2_maxRetry_t3l1a -> p_worker2_t3l1a : (worker2'=worker2+1) + (1-p_worker2_t3l1a) : (worker2'=worker2) & (worker2retry_t3l1a' = worker2retry_t3l1a+1);
  [worker2dot3l1a] worker2=0 & worker2retry_t3l1a >= worker2_maxRetry_t3l1a -> 1:(worker2'=worker2Fail);
  [worker2dot3l1bRetry] worker2=1 & worker2retry_t3l1b < worker2_maxRetry_t3l1b -> p_worker2_t3l1b : (worker2'=worker2+1) + (1-p_worker2_t3l1b) : (worker2'=worker2) & (worker2retry_t3l1b' = worker2retry_t3l1b+1);
  [worker2dot3l1b] worker2=1 & worker2retry_t3l1b >= worker2_maxRetry_t3l1b -> 1:(worker2'=worker2Fail);
  [worker2dot3l1cRetry] worker2=2 & worker2retry_t3l1c < worker2_maxRetry_t3l1c -> p_worker2_t3l1c : (worker2'=worker2+1) + (1-p_worker2_t3l1c) : (worker2'=worker2) & (worker2retry_t3l1c' = worker2retry_t3l1c+1);
  [worker2dot3l1c] worker2=2 & worker2retry_t3l1c >= worker2_maxRetry_t3l1c -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..5];
  r1retry_t3l1d : [0..r1_maxRetry_t3l1d] init 0;
  r1retry_t2l2 : [0..r1_maxRetry_t2l2] init 0;

  [r1dot3l1dRetry] r1=0 & r1retry_t3l1d < r1_maxRetry_t3l1d -> p_r1_t3l1d : (r1'=r1+1) + (1-p_r1_t3l1d) : (r1'=r1) & (r1retry_t3l1d' = r1retry_t3l1d+1);
  [r1dot3l1d] r1=0 & r1retry_t3l1d >= r1_maxRetry_t3l1d -> 1:(r1'=r1Fail);
  [r1movel2] r1=1-> 1:(r1'=1+1);
  [r1dot2l2Retry] r1=2 & r1retry_t2l2 < r1_maxRetry_t2l2 -> p_r1_t2l2 : (r1'=r1+1) + (1-p_r1_t2l2) : (r1'=r1) & (r1retry_t2l2' = r1retry_t2l2+1);
  [r1dot2l2] r1=2 & r1retry_t2l2 >= r1_maxRetry_t2l2 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..6];
  r2retry_t2l4 : [0..r2_maxRetry_t2l4] init 0;
  r2retry_t2l7 : [0..r2_maxRetry_t2l7] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2dot2l4Retry] r2=1 & r2retry_t2l4 < r2_maxRetry_t2l4 -> p_r2_t2l4 : (r2'=r2+1) + (1-p_r2_t2l4) : (r2'=r2) & (r2retry_t2l4' = r2retry_t2l4+1);
  [r2dot2l4] r2=1 & r2retry_t2l4 >= r2_maxRetry_t2l4 -> 1:(r2'=r2Fail);
  [r2movel7] r2=2-> 1:(r2'=2+1);
  [r2dot2l7Retry] r2=3 & r2retry_t2l7 < r2_maxRetry_t2l7 -> p_r2_t2l7 : (r2'=r2+1) + (1-p_r2_t2l7) : (r2'=r2) & (r2retry_t2l7' = r2retry_t2l7+1);
  [r2dot2l7] r2=3 & r2retry_t2l7 >= r2_maxRetry_t2l7 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..14];
  worker1retry_t1l7 : [0..worker1_maxRetry_t1l7] init 0;
  worker1retry_t1l5b : [0..worker1_maxRetry_t1l5b] init 0;
  worker1retry_t1l5a : [0..worker1_maxRetry_t1l5a] init 0;
  worker1retry_t1l8 : [0..worker1_maxRetry_t1l8] init 0;
  worker1retry_t3l8 : [0..worker1_maxRetry_t3l8] init 0;
  worker1retry_t1l9 : [0..worker1_maxRetry_t1l9] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1movel7] worker1=1-> 1:(worker1'=1+1);
  [worker1dot1l7Retry] worker1=2 & worker1retry_t1l7 < worker1_maxRetry_t1l7 -> p_worker1_t1l7 : (worker1'=worker1+1) + (1-p_worker1_t1l7) : (worker1'=worker1) & (worker1retry_t1l7' = worker1retry_t1l7+1);
  [worker1dot1l7] worker1=2 & worker1retry_t1l7 >= worker1_maxRetry_t1l7 -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=3-> 1:(worker1'=3+1);
  [worker1movel5] worker1=4-> 1:(worker1'=4+1);
  [worker1dot1l5bRetry] worker1=5 & worker1retry_t1l5b < worker1_maxRetry_t1l5b -> p_worker1_t1l5b : (worker1'=worker1+1) + (1-p_worker1_t1l5b) : (worker1'=worker1) & (worker1retry_t1l5b' = worker1retry_t1l5b+1);
  [worker1dot1l5b] worker1=5 & worker1retry_t1l5b >= worker1_maxRetry_t1l5b -> 1:(worker1'=worker1Fail);
  [worker1dot1l5aRetry] worker1=6 & worker1retry_t1l5a < worker1_maxRetry_t1l5a -> p_worker1_t1l5a : (worker1'=worker1+1) + (1-p_worker1_t1l5a) : (worker1'=worker1) & (worker1retry_t1l5a' = worker1retry_t1l5a+1);
  [worker1dot1l5a] worker1=6 & worker1retry_t1l5a >= worker1_maxRetry_t1l5a -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=7-> 1:(worker1'=7+1);
  [worker1dot1l8Retry] worker1=8 & worker1retry_t1l8 < worker1_maxRetry_t1l8 -> p_worker1_t1l8 : (worker1'=worker1+1) + (1-p_worker1_t1l8) : (worker1'=worker1) & (worker1retry_t1l8' = worker1retry_t1l8+1);
  [worker1dot1l8] worker1=8 & worker1retry_t1l8 >= worker1_maxRetry_t1l8 -> 1:(worker1'=worker1Fail);
  [worker1dot3l8Retry] worker1=9 & worker1retry_t3l8 < worker1_maxRetry_t3l8 -> p_worker1_t3l8 : (worker1'=worker1+1) + (1-p_worker1_t3l8) : (worker1'=worker1) & (worker1retry_t3l8' = worker1retry_t3l8+1);
  [worker1dot3l8] worker1=9 & worker1retry_t3l8 >= worker1_maxRetry_t3l8 -> 1:(worker1'=worker1Fail);
  [worker1movel9] worker1=10-> 1:(worker1'=10+1);
  [worker1dot1l9Retry] worker1=11 & worker1retry_t1l9 < worker1_maxRetry_t1l9 -> p_worker1_t1l9 : (worker1'=worker1+1) + (1-p_worker1_t1l9) : (worker1'=worker1) & (worker1retry_t1l9' = worker1retry_t1l9+1);
  [worker1dot1l9] worker1=11 & worker1retry_t1l9 >= worker1_maxRetry_t1l9 -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [worker2dot3l1a] true:5;
  [worker2dot3l1aRetry] true:5;
  [worker2dot3l1b] true:5;
  [worker2dot3l1bRetry] true:5;
  [worker2dot3l1c] true:5;
  [worker2dot3l1cRetry] true:5;
  [r1dot3l1d] true:1;
  [r1dot3l1dRetry] true:1;
  [r1movel2] true:1;
  [r1dot2l2] true:1;
  [r1dot2l2Retry] true:1;
  [r2movel4] true:1;
  [r2dot2l4] true:1;
  [r2dot2l4Retry] true:1;
  [r2movel7] true:1;
  [r2dot2l7] true:1;
  [r2dot2l7Retry] true:1;
  [worker1movel4] true:1;
  [worker1movel7] true:1;
  [worker1dot1l7] true:3;
  [worker1dot1l7Retry] true:3;
  [worker1movel8] true:1;
  [worker1movel5] true:1;
  [worker1dot1l5b] true:3;
  [worker1dot1l5bRetry] true:3;
  [worker1dot1l5a] true:3;
  [worker1dot1l5aRetry] true:3;
  [worker1movel8] true:1;
  [worker1dot1l8] true:3;
  [worker1dot1l8Retry] true:3;
  [worker1dot3l8] true:5;
  [worker1dot3l8Retry] true:5;
  [worker1movel9] true:1;
  [worker1dot1l9] true:3;
  [worker1dot1l9Retry] true:3;
endrewards