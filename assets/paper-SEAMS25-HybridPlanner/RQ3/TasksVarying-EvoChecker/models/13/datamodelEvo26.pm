dtmc
evolve int worker2_maxRetry_t3l1 [1..5];
evolve int worker2_maxRetry_t1l1 [1..5];
evolve int r1_maxRetry_t3l2 [1..10];
evolve int r1_maxRetry_t2l3b [1..10];
evolve int r1_maxRetry_t2l3a [1..10];
evolve int r2_maxRetry_t2l1 [1..10];
evolve int worker1_maxRetry_t3l4 [1..5];
evolve int worker1_maxRetry_t1l4a [1..5];
evolve int worker1_maxRetry_t1l4c [1..5];
evolve int worker1_maxRetry_t1l4b [1..5];
evolve int worker1_maxRetry_t1l5a [1..5];
evolve int worker1_maxRetry_t3l5 [1..5];
evolve int worker1_maxRetry_t1l5b [1..5];

const double p_worker2_t3l1=0.99;
const double p_worker2_t1l1=1.0;
const double p_r1_t3l2=0.97;
const double p_r1_t2l3b=0.99;
const double p_r1_t2l3a=0.99;
const double p_r2_t2l1=0.99;
const double p_worker1_t3l4=0.99;
const double p_worker1_t1l4a=1.0;
const double p_worker1_t1l4c=1.0;
const double p_worker1_t1l4b=1.0;
const double p_worker1_t1l5a=1.0;
const double p_worker1_t3l5=0.99;
const double p_worker1_t1l5b=1.0;
const int worker2Final = 2;
const int worker2Fail = 3;
const int r1Final = 5;
const int r1Fail = 6;
const int r2Final = 1;
const int r2Fail = 2;
const int worker1Final = 9;
const int worker1Fail = 10;

module _worker2
  worker2 : [0..4];
  worker2retry_t3l1 : [0..worker2_maxRetry_t3l1] init 0;
  worker2retry_t1l1 : [0..worker2_maxRetry_t1l1] init 0;

  [worker2dot3l1Retry] worker2=0 & worker2retry_t3l1 < worker2_maxRetry_t3l1 -> p_worker2_t3l1 : (worker2'=worker2+1) + (1-p_worker2_t3l1) : (worker2'=worker2) & (worker2retry_t3l1' = worker2retry_t3l1+1);
  [worker2dot3l1] worker2=0 & worker2retry_t3l1 >= worker2_maxRetry_t3l1 -> 1:(worker2'=worker2Fail);
  [worker2dot1l1Retry] worker2=1 & worker2retry_t1l1 < worker2_maxRetry_t1l1 -> p_worker2_t1l1 : (worker2'=worker2+1) + (1-p_worker2_t1l1) : (worker2'=worker2) & (worker2retry_t1l1' = worker2retry_t1l1+1);
  [worker2dot1l1] worker2=1 & worker2retry_t1l1 >= worker2_maxRetry_t1l1 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..7];
  r1retry_t3l2 : [0..r1_maxRetry_t3l2] init 0;
  r1retry_t2l3b : [0..r1_maxRetry_t2l3b] init 0;
  r1retry_t2l3a : [0..r1_maxRetry_t2l3a] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1dot3l2Retry] r1=1 & r1retry_t3l2 < r1_maxRetry_t3l2 -> p_r1_t3l2 : (r1'=r1+1) + (1-p_r1_t3l2) : (r1'=r1) & (r1retry_t3l2' = r1retry_t3l2+1);
  [r1dot3l2] r1=1 & r1retry_t3l2 >= r1_maxRetry_t3l2 -> 1:(r1'=r1Fail);
  [r1movel3] r1=2-> 1:(r1'=2+1);
  [r1dot2l3bRetry] r1=3 & r1retry_t2l3b < r1_maxRetry_t2l3b -> p_r1_t2l3b : (r1'=r1+1) + (1-p_r1_t2l3b) : (r1'=r1) & (r1retry_t2l3b' = r1retry_t2l3b+1);
  [r1dot2l3b] r1=3 & r1retry_t2l3b >= r1_maxRetry_t2l3b -> 1:(r1'=r1Fail);
  [r1dot2l3aRetry] r1=4 & r1retry_t2l3a < r1_maxRetry_t2l3a -> p_r1_t2l3a : (r1'=r1+1) + (1-p_r1_t2l3a) : (r1'=r1) & (r1retry_t2l3a' = r1retry_t2l3a+1);
  [r1dot2l3a] r1=4 & r1retry_t2l3a >= r1_maxRetry_t2l3a -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..3];
  r2retry_t2l1 : [0..r2_maxRetry_t2l1] init 0;

  [r2dot2l1Retry] r2=0 & r2retry_t2l1 < r2_maxRetry_t2l1 -> p_r2_t2l1 : (r2'=r2+1) + (1-p_r2_t2l1) : (r2'=r2) & (r2retry_t2l1' = r2retry_t2l1+1);
  [r2dot2l1] r2=0 & r2retry_t2l1 >= r2_maxRetry_t2l1 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..11];
  worker1retry_t3l4 : [0..worker1_maxRetry_t3l4] init 0;
  worker1retry_t1l4a : [0..worker1_maxRetry_t1l4a] init 0;
  worker1retry_t1l4c : [0..worker1_maxRetry_t1l4c] init 0;
  worker1retry_t1l4b : [0..worker1_maxRetry_t1l4b] init 0;
  worker1retry_t1l5a : [0..worker1_maxRetry_t1l5a] init 0;
  worker1retry_t3l5 : [0..worker1_maxRetry_t3l5] init 0;
  worker1retry_t1l5b : [0..worker1_maxRetry_t1l5b] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot3l4Retry] worker1=1 & worker1retry_t3l4 < worker1_maxRetry_t3l4 -> p_worker1_t3l4 : (worker1'=worker1+1) + (1-p_worker1_t3l4) : (worker1'=worker1) & (worker1retry_t3l4' = worker1retry_t3l4+1);
  [worker1dot3l4] worker1=1 & worker1retry_t3l4 >= worker1_maxRetry_t3l4 -> 1:(worker1'=worker1Fail);
  [worker1dot1l4aRetry] worker1=2 & worker1retry_t1l4a < worker1_maxRetry_t1l4a -> p_worker1_t1l4a : (worker1'=worker1+1) + (1-p_worker1_t1l4a) : (worker1'=worker1) & (worker1retry_t1l4a' = worker1retry_t1l4a+1);
  [worker1dot1l4a] worker1=2 & worker1retry_t1l4a >= worker1_maxRetry_t1l4a -> 1:(worker1'=worker1Fail);
  [worker1dot1l4cRetry] worker1=3 & worker1retry_t1l4c < worker1_maxRetry_t1l4c -> p_worker1_t1l4c : (worker1'=worker1+1) + (1-p_worker1_t1l4c) : (worker1'=worker1) & (worker1retry_t1l4c' = worker1retry_t1l4c+1);
  [worker1dot1l4c] worker1=3 & worker1retry_t1l4c >= worker1_maxRetry_t1l4c -> 1:(worker1'=worker1Fail);
  [worker1dot1l4bRetry] worker1=4 & worker1retry_t1l4b < worker1_maxRetry_t1l4b -> p_worker1_t1l4b : (worker1'=worker1+1) + (1-p_worker1_t1l4b) : (worker1'=worker1) & (worker1retry_t1l4b' = worker1retry_t1l4b+1);
  [worker1dot1l4b] worker1=4 & worker1retry_t1l4b >= worker1_maxRetry_t1l4b -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=5-> 1:(worker1'=5+1);
  [worker1dot1l5aRetry] worker1=6 & worker1retry_t1l5a < worker1_maxRetry_t1l5a -> p_worker1_t1l5a : (worker1'=worker1+1) + (1-p_worker1_t1l5a) : (worker1'=worker1) & (worker1retry_t1l5a' = worker1retry_t1l5a+1);
  [worker1dot1l5a] worker1=6 & worker1retry_t1l5a >= worker1_maxRetry_t1l5a -> 1:(worker1'=worker1Fail);
  [worker1dot3l5Retry] worker1=7 & worker1retry_t3l5 < worker1_maxRetry_t3l5 -> p_worker1_t3l5 : (worker1'=worker1+1) + (1-p_worker1_t3l5) : (worker1'=worker1) & (worker1retry_t3l5' = worker1retry_t3l5+1);
  [worker1dot3l5] worker1=7 & worker1retry_t3l5 >= worker1_maxRetry_t3l5 -> 1:(worker1'=worker1Fail);
  [worker1dot1l5bRetry] worker1=8 & worker1retry_t1l5b < worker1_maxRetry_t1l5b -> p_worker1_t1l5b : (worker1'=worker1+1) + (1-p_worker1_t1l5b) : (worker1'=worker1) & (worker1retry_t1l5b' = worker1retry_t1l5b+1);
  [worker1dot1l5b] worker1=8 & worker1retry_t1l5b >= worker1_maxRetry_t1l5b -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [worker2dot3l1] true:5;
  [worker2dot3l1Retry] true:5;
  [worker2dot1l1] true:3;
  [worker2dot1l1Retry] true:3;
  [r1movel2] true:1;
  [r1dot3l2] true:1;
  [r1dot3l2Retry] true:1;
  [r1movel3] true:1;
  [r1dot2l3b] true:1;
  [r1dot2l3bRetry] true:1;
  [r1dot2l3a] true:1;
  [r1dot2l3aRetry] true:1;
  [r2dot2l1] true:1;
  [r2dot2l1Retry] true:1;
  [worker1movel4] true:1;
  [worker1dot3l4] true:5;
  [worker1dot3l4Retry] true:5;
  [worker1dot1l4a] true:3;
  [worker1dot1l4aRetry] true:3;
  [worker1dot1l4c] true:3;
  [worker1dot1l4cRetry] true:3;
  [worker1dot1l4b] true:3;
  [worker1dot1l4bRetry] true:3;
  [worker1movel5] true:1;
  [worker1dot1l5a] true:3;
  [worker1dot1l5aRetry] true:3;
  [worker1dot3l5] true:5;
  [worker1dot3l5Retry] true:5;
  [worker1dot1l5b] true:3;
  [worker1dot1l5bRetry] true:3;
endrewards