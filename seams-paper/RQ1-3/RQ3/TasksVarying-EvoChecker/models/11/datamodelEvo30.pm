dtmc
evolve int r2_maxRetry_t2l4 [1..10];
evolve int r2_maxRetry_t2l9 [1..10];
evolve int worker1_maxRetry_t3l1b [1..5];
evolve int worker1_maxRetry_t3l1d [1..5];
evolve int worker1_maxRetry_t1l1 [1..5];
evolve int worker1_maxRetry_t3l1c [1..5];
evolve int worker2_maxRetry_t1l2a [1..5];
evolve int worker2_maxRetry_t1l2b [1..5];
evolve int worker2_maxRetry_t1l3 [1..5];
evolve int worker2_maxRetry_t1l5 [1..5];
evolve int r1_maxRetry_t3l1a [1..10];

const double p_r2_t2l4=0.99;
const double p_r2_t2l9=0.99;
const double p_worker1_t3l1b=0.99;
const double p_worker1_t3l1d=0.99;
const double p_worker1_t1l1=1.0;
const double p_worker1_t3l1c=0.99;
const double p_worker2_t1l2a=1.0;
const double p_worker2_t1l2b=1.0;
const double p_worker2_t1l3=1.0;
const double p_worker2_t1l5=1.0;
const double p_r1_t3l1a=0.97;
const int r2Final = 6;
const int r2Fail = 7;
const int worker1Final = 4;
const int worker1Fail = 5;
const int worker2Final = 8;
const int worker2Fail = 9;
const int r1Final = 1;
const int r1Fail = 2;

module _r2
  r2 : [0..8];
  r2retry_t2l4 : [0..r2_maxRetry_t2l4] init 0;
  r2retry_t2l9 : [0..r2_maxRetry_t2l9] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2dot2l4Retry] r2=1 & r2retry_t2l4 < r2_maxRetry_t2l4 -> p_r2_t2l4 : (r2'=r2+1) + (1-p_r2_t2l4) : (r2'=r2) & (r2retry_t2l4' = r2retry_t2l4+1);
  [r2dot2l4] r2=1 & r2retry_t2l4 >= r2_maxRetry_t2l4 -> 1:(r2'=r2Fail);
  [r2movel7] r2=2-> 1:(r2'=2+1);
  [r2movel8] r2=3-> 1:(r2'=3+1);
  [r2movel9] r2=4-> 1:(r2'=4+1);
  [r2dot2l9Retry] r2=5 & r2retry_t2l9 < r2_maxRetry_t2l9 -> p_r2_t2l9 : (r2'=r2+1) + (1-p_r2_t2l9) : (r2'=r2) & (r2retry_t2l9' = r2retry_t2l9+1);
  [r2dot2l9] r2=5 & r2retry_t2l9 >= r2_maxRetry_t2l9 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..6];
  worker1retry_t3l1b : [0..worker1_maxRetry_t3l1b] init 0;
  worker1retry_t3l1d : [0..worker1_maxRetry_t3l1d] init 0;
  worker1retry_t1l1 : [0..worker1_maxRetry_t1l1] init 0;
  worker1retry_t3l1c : [0..worker1_maxRetry_t3l1c] init 0;

  [worker1dot3l1bRetry] worker1=0 & worker1retry_t3l1b < worker1_maxRetry_t3l1b -> p_worker1_t3l1b : (worker1'=worker1+1) + (1-p_worker1_t3l1b) : (worker1'=worker1) & (worker1retry_t3l1b' = worker1retry_t3l1b+1);
  [worker1dot3l1b] worker1=0 & worker1retry_t3l1b >= worker1_maxRetry_t3l1b -> 1:(worker1'=worker1Fail);
  [worker1dot3l1dRetry] worker1=1 & worker1retry_t3l1d < worker1_maxRetry_t3l1d -> p_worker1_t3l1d : (worker1'=worker1+1) + (1-p_worker1_t3l1d) : (worker1'=worker1) & (worker1retry_t3l1d' = worker1retry_t3l1d+1);
  [worker1dot3l1d] worker1=1 & worker1retry_t3l1d >= worker1_maxRetry_t3l1d -> 1:(worker1'=worker1Fail);
  [worker1dot1l1Retry] worker1=2 & worker1retry_t1l1 < worker1_maxRetry_t1l1 -> p_worker1_t1l1 : (worker1'=worker1+1) + (1-p_worker1_t1l1) : (worker1'=worker1) & (worker1retry_t1l1' = worker1retry_t1l1+1);
  [worker1dot1l1] worker1=2 & worker1retry_t1l1 >= worker1_maxRetry_t1l1 -> 1:(worker1'=worker1Fail);
  [worker1dot3l1cRetry] worker1=3 & worker1retry_t3l1c < worker1_maxRetry_t3l1c -> p_worker1_t3l1c : (worker1'=worker1+1) + (1-p_worker1_t3l1c) : (worker1'=worker1) & (worker1retry_t3l1c' = worker1retry_t3l1c+1);
  [worker1dot3l1c] worker1=3 & worker1retry_t3l1c >= worker1_maxRetry_t3l1c -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..10];
  worker2retry_t1l2a : [0..worker2_maxRetry_t1l2a] init 0;
  worker2retry_t1l2b : [0..worker2_maxRetry_t1l2b] init 0;
  worker2retry_t1l3 : [0..worker2_maxRetry_t1l3] init 0;
  worker2retry_t1l5 : [0..worker2_maxRetry_t1l5] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l2aRetry] worker2=1 & worker2retry_t1l2a < worker2_maxRetry_t1l2a -> p_worker2_t1l2a : (worker2'=worker2+1) + (1-p_worker2_t1l2a) : (worker2'=worker2) & (worker2retry_t1l2a' = worker2retry_t1l2a+1);
  [worker2dot1l2a] worker2=1 & worker2retry_t1l2a >= worker2_maxRetry_t1l2a -> 1:(worker2'=worker2Fail);
  [worker2dot1l2bRetry] worker2=2 & worker2retry_t1l2b < worker2_maxRetry_t1l2b -> p_worker2_t1l2b : (worker2'=worker2+1) + (1-p_worker2_t1l2b) : (worker2'=worker2) & (worker2retry_t1l2b' = worker2retry_t1l2b+1);
  [worker2dot1l2b] worker2=2 & worker2retry_t1l2b >= worker2_maxRetry_t1l2b -> 1:(worker2'=worker2Fail);
  [worker2movel3] worker2=3-> 1:(worker2'=3+1);
  [worker2dot1l3Retry] worker2=4 & worker2retry_t1l3 < worker2_maxRetry_t1l3 -> p_worker2_t1l3 : (worker2'=worker2+1) + (1-p_worker2_t1l3) : (worker2'=worker2) & (worker2retry_t1l3' = worker2retry_t1l3+1);
  [worker2dot1l3] worker2=4 & worker2retry_t1l3 >= worker2_maxRetry_t1l3 -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=5-> 1:(worker2'=5+1);
  [worker2movel5] worker2=6-> 1:(worker2'=6+1);
  [worker2dot1l5Retry] worker2=7 & worker2retry_t1l5 < worker2_maxRetry_t1l5 -> p_worker2_t1l5 : (worker2'=worker2+1) + (1-p_worker2_t1l5) : (worker2'=worker2) & (worker2retry_t1l5' = worker2retry_t1l5+1);
  [worker2dot1l5] worker2=7 & worker2retry_t1l5 >= worker2_maxRetry_t1l5 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..3];
  r1retry_t3l1a : [0..r1_maxRetry_t3l1a] init 0;

  [r1dot3l1aRetry] r1=0 & r1retry_t3l1a < r1_maxRetry_t3l1a -> p_r1_t3l1a : (r1'=r1+1) + (1-p_r1_t3l1a) : (r1'=r1) & (r1retry_t3l1a' = r1retry_t3l1a+1);
  [r1dot3l1a] r1=0 & r1retry_t3l1a >= r1_maxRetry_t3l1a -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [r2movel4] true:1;
  [r2dot2l4] true:1;
  [r2dot2l4Retry] true:1;
  [r2movel7] true:1;
  [r2movel8] true:1;
  [r2movel9] true:1;
  [r2dot2l9] true:1;
  [r2dot2l9Retry] true:1;
  [worker1dot3l1b] true:5;
  [worker1dot3l1bRetry] true:5;
  [worker1dot3l1d] true:5;
  [worker1dot3l1dRetry] true:5;
  [worker1dot1l1] true:3;
  [worker1dot1l1Retry] true:3;
  [worker1dot3l1c] true:5;
  [worker1dot3l1cRetry] true:5;
  [worker2movel2] true:1;
  [worker2dot1l2a] true:3;
  [worker2dot1l2aRetry] true:3;
  [worker2dot1l2b] true:3;
  [worker2dot1l2bRetry] true:3;
  [worker2movel3] true:1;
  [worker2dot1l3] true:3;
  [worker2dot1l3Retry] true:3;
  [worker2movel6] true:1;
  [worker2movel5] true:1;
  [worker2dot1l5] true:3;
  [worker2dot1l5Retry] true:3;
  [r1dot3l1a] true:1;
  [r1dot3l1aRetry] true:1;
endrewards