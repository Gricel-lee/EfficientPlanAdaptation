dtmc
evolve int r2_maxRetry_t2l2 [1..10];
evolve int worker1_maxRetry_t1l2a [1..5];
evolve int worker1_maxRetry_t1l2b [1..5];
evolve int worker1_maxRetry_t1l3b [1..5];
evolve int worker1_maxRetry_t1l3a [1..5];
evolve int worker1_maxRetry_t1l9 [1..5];
evolve int worker2_maxRetry_t3l1b [1..5];
evolve int worker2_maxRetry_t3l1a [1..5];
evolve int r1_maxRetry_t3l4 [1..10];
evolve int r1_maxRetry_t2l4 [1..10];
evolve int r1_maxRetry_t2l7 [1..10];

const double p_r2_t2l2=0.99;
const double p_worker1_t1l2a=1.0;
const double p_worker1_t1l2b=1.0;
const double p_worker1_t1l3b=1.0;
const double p_worker1_t1l3a=1.0;
const double p_worker1_t1l9=1.0;
const double p_worker2_t3l1b=0.99;
const double p_worker2_t3l1a=0.99;
const double p_r1_t3l4=0.97;
const double p_r1_t2l4=0.99;
const double p_r1_t2l7=0.99;
const int r2Final = 2;
const int r2Fail = 3;
const int worker1Final = 9;
const int worker1Fail = 10;
const int worker2Final = 2;
const int worker2Fail = 3;
const int r1Final = 5;
const int r1Fail = 6;

module _r2
  r2 : [0..4];
  r2retry_t2l2 : [0..r2_maxRetry_t2l2] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2dot2l2Retry] r2=1 & r2retry_t2l2 < r2_maxRetry_t2l2 -> p_r2_t2l2 : (r2'=r2+1) + (1-p_r2_t2l2) : (r2'=r2) & (r2retry_t2l2' = r2retry_t2l2+1);
  [r2dot2l2] r2=1 & r2retry_t2l2 >= r2_maxRetry_t2l2 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..11];
  worker1retry_t1l2a : [0..worker1_maxRetry_t1l2a] init 0;
  worker1retry_t1l2b : [0..worker1_maxRetry_t1l2b] init 0;
  worker1retry_t1l3b : [0..worker1_maxRetry_t1l3b] init 0;
  worker1retry_t1l3a : [0..worker1_maxRetry_t1l3a] init 0;
  worker1retry_t1l9 : [0..worker1_maxRetry_t1l9] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l2aRetry] worker1=1 & worker1retry_t1l2a < worker1_maxRetry_t1l2a -> p_worker1_t1l2a : (worker1'=worker1+1) + (1-p_worker1_t1l2a) : (worker1'=worker1) & (worker1retry_t1l2a' = worker1retry_t1l2a+1);
  [worker1dot1l2a] worker1=1 & worker1retry_t1l2a >= worker1_maxRetry_t1l2a -> 1:(worker1'=worker1Fail);
  [worker1dot1l2bRetry] worker1=2 & worker1retry_t1l2b < worker1_maxRetry_t1l2b -> p_worker1_t1l2b : (worker1'=worker1+1) + (1-p_worker1_t1l2b) : (worker1'=worker1) & (worker1retry_t1l2b' = worker1retry_t1l2b+1);
  [worker1dot1l2b] worker1=2 & worker1retry_t1l2b >= worker1_maxRetry_t1l2b -> 1:(worker1'=worker1Fail);
  [worker1movel3] worker1=3-> 1:(worker1'=3+1);
  [worker1dot1l3bRetry] worker1=4 & worker1retry_t1l3b < worker1_maxRetry_t1l3b -> p_worker1_t1l3b : (worker1'=worker1+1) + (1-p_worker1_t1l3b) : (worker1'=worker1) & (worker1retry_t1l3b' = worker1retry_t1l3b+1);
  [worker1dot1l3b] worker1=4 & worker1retry_t1l3b >= worker1_maxRetry_t1l3b -> 1:(worker1'=worker1Fail);
  [worker1dot1l3aRetry] worker1=5 & worker1retry_t1l3a < worker1_maxRetry_t1l3a -> p_worker1_t1l3a : (worker1'=worker1+1) + (1-p_worker1_t1l3a) : (worker1'=worker1) & (worker1retry_t1l3a' = worker1retry_t1l3a+1);
  [worker1dot1l3a] worker1=5 & worker1retry_t1l3a >= worker1_maxRetry_t1l3a -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=6-> 1:(worker1'=6+1);
  [worker1movel9] worker1=7-> 1:(worker1'=7+1);
  [worker1dot1l9Retry] worker1=8 & worker1retry_t1l9 < worker1_maxRetry_t1l9 -> p_worker1_t1l9 : (worker1'=worker1+1) + (1-p_worker1_t1l9) : (worker1'=worker1) & (worker1retry_t1l9' = worker1retry_t1l9+1);
  [worker1dot1l9] worker1=8 & worker1retry_t1l9 >= worker1_maxRetry_t1l9 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..4];
  worker2retry_t3l1b : [0..worker2_maxRetry_t3l1b] init 0;
  worker2retry_t3l1a : [0..worker2_maxRetry_t3l1a] init 0;

  [worker2dot3l1bRetry] worker2=0 & worker2retry_t3l1b < worker2_maxRetry_t3l1b -> p_worker2_t3l1b : (worker2'=worker2+1) + (1-p_worker2_t3l1b) : (worker2'=worker2) & (worker2retry_t3l1b' = worker2retry_t3l1b+1);
  [worker2dot3l1b] worker2=0 & worker2retry_t3l1b >= worker2_maxRetry_t3l1b -> 1:(worker2'=worker2Fail);
  [worker2dot3l1aRetry] worker2=1 & worker2retry_t3l1a < worker2_maxRetry_t3l1a -> p_worker2_t3l1a : (worker2'=worker2+1) + (1-p_worker2_t3l1a) : (worker2'=worker2) & (worker2retry_t3l1a' = worker2retry_t3l1a+1);
  [worker2dot3l1a] worker2=1 & worker2retry_t3l1a >= worker2_maxRetry_t3l1a -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..7];
  r1retry_t3l4 : [0..r1_maxRetry_t3l4] init 0;
  r1retry_t2l4 : [0..r1_maxRetry_t2l4] init 0;
  r1retry_t2l7 : [0..r1_maxRetry_t2l7] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1dot3l4Retry] r1=1 & r1retry_t3l4 < r1_maxRetry_t3l4 -> p_r1_t3l4 : (r1'=r1+1) + (1-p_r1_t3l4) : (r1'=r1) & (r1retry_t3l4' = r1retry_t3l4+1);
  [r1dot3l4] r1=1 & r1retry_t3l4 >= r1_maxRetry_t3l4 -> 1:(r1'=r1Fail);
  [r1dot2l4Retry] r1=2 & r1retry_t2l4 < r1_maxRetry_t2l4 -> p_r1_t2l4 : (r1'=r1+1) + (1-p_r1_t2l4) : (r1'=r1) & (r1retry_t2l4' = r1retry_t2l4+1);
  [r1dot2l4] r1=2 & r1retry_t2l4 >= r1_maxRetry_t2l4 -> 1:(r1'=r1Fail);
  [r1movel7] r1=3-> 1:(r1'=3+1);
  [r1dot2l7Retry] r1=4 & r1retry_t2l7 < r1_maxRetry_t2l7 -> p_r1_t2l7 : (r1'=r1+1) + (1-p_r1_t2l7) : (r1'=r1) & (r1retry_t2l7' = r1retry_t2l7+1);
  [r1dot2l7] r1=4 & r1retry_t2l7 >= r1_maxRetry_t2l7 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [r2movel2] true:1;
  [r2dot2l2] true:1;
  [r2dot2l2Retry] true:1;
  [worker1movel2] true:1;
  [worker1dot1l2a] true:3;
  [worker1dot1l2aRetry] true:3;
  [worker1dot1l2b] true:3;
  [worker1dot1l2bRetry] true:3;
  [worker1movel3] true:1;
  [worker1dot1l3b] true:3;
  [worker1dot1l3bRetry] true:3;
  [worker1dot1l3a] true:3;
  [worker1dot1l3aRetry] true:3;
  [worker1movel6] true:1;
  [worker1movel9] true:1;
  [worker1dot1l9] true:3;
  [worker1dot1l9Retry] true:3;
  [worker2dot3l1b] true:5;
  [worker2dot3l1bRetry] true:5;
  [worker2dot3l1a] true:5;
  [worker2dot3l1aRetry] true:5;
  [r1movel4] true:1;
  [r1dot3l4] true:1;
  [r1dot3l4Retry] true:1;
  [r1dot2l4] true:1;
  [r1dot2l4Retry] true:1;
  [r1movel7] true:1;
  [r1dot2l7] true:1;
  [r1dot2l7Retry] true:1;
endrewards