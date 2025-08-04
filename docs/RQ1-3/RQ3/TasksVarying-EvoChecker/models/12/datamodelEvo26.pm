dtmc
evolve int r1_maxRetry_t3l1a [1..10];
evolve int r1_maxRetry_t2l1 [1..10];
evolve int r1_maxRetry_t3l1b [1..10];
evolve int r2_maxRetry_t2l4 [1..10];
evolve int r2_maxRetry_t2l7 [1..10];
evolve int worker1_maxRetry_t1l7 [1..5];
evolve int worker1_maxRetry_t1l5b [1..5];
evolve int worker1_maxRetry_t1l5a [1..5];
evolve int worker2_maxRetry_t3l3b [1..5];
evolve int worker2_maxRetry_t3l3a [1..5];
evolve int worker2_maxRetry_t3l6 [1..5];
evolve int worker2_maxRetry_t3l9 [1..5];

const double p_r1_t3l1a=0.97;
const double p_r1_t2l1=0.99;
const double p_r1_t3l1b=0.97;
const double p_r2_t2l4=0.99;
const double p_r2_t2l7=0.99;
const double p_worker1_t1l7=1.0;
const double p_worker1_t1l5b=1.0;
const double p_worker1_t1l5a=1.0;
const double p_worker2_t3l3b=0.99;
const double p_worker2_t3l3a=0.99;
const double p_worker2_t3l6=0.99;
const double p_worker2_t3l9=0.99;
const int r1Final = 3;
const int r1Fail = 4;
const int r2Final = 4;
const int r2Fail = 5;
const int worker1Final = 7;
const int worker1Fail = 8;
const int worker2Final = 8;
const int worker2Fail = 9;

module _r1
  r1 : [0..5];
  r1retry_t3l1a : [0..r1_maxRetry_t3l1a] init 0;
  r1retry_t2l1 : [0..r1_maxRetry_t2l1] init 0;
  r1retry_t3l1b : [0..r1_maxRetry_t3l1b] init 0;

  [r1dot3l1aRetry] r1=0 & r1retry_t3l1a < r1_maxRetry_t3l1a -> p_r1_t3l1a : (r1'=r1+1) + (1-p_r1_t3l1a) : (r1'=r1) & (r1retry_t3l1a' = r1retry_t3l1a+1);
  [r1dot3l1a] r1=0 & r1retry_t3l1a >= r1_maxRetry_t3l1a -> 1:(r1'=r1Fail);
  [r1dot2l1Retry] r1=1 & r1retry_t2l1 < r1_maxRetry_t2l1 -> p_r1_t2l1 : (r1'=r1+1) + (1-p_r1_t2l1) : (r1'=r1) & (r1retry_t2l1' = r1retry_t2l1+1);
  [r1dot2l1] r1=1 & r1retry_t2l1 >= r1_maxRetry_t2l1 -> 1:(r1'=r1Fail);
  [r1dot3l1bRetry] r1=2 & r1retry_t3l1b < r1_maxRetry_t3l1b -> p_r1_t3l1b : (r1'=r1+1) + (1-p_r1_t3l1b) : (r1'=r1) & (r1retry_t3l1b' = r1retry_t3l1b+1);
  [r1dot3l1b] r1=2 & r1retry_t3l1b >= r1_maxRetry_t3l1b -> 1:(r1'=r1Fail);
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
  worker1 : [0..9];
  worker1retry_t1l7 : [0..worker1_maxRetry_t1l7] init 0;
  worker1retry_t1l5b : [0..worker1_maxRetry_t1l5b] init 0;
  worker1retry_t1l5a : [0..worker1_maxRetry_t1l5a] init 0;

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
endmodule

module _worker2
  worker2 : [0..10];
  worker2retry_t3l3b : [0..worker2_maxRetry_t3l3b] init 0;
  worker2retry_t3l3a : [0..worker2_maxRetry_t3l3a] init 0;
  worker2retry_t3l6 : [0..worker2_maxRetry_t3l6] init 0;
  worker2retry_t3l9 : [0..worker2_maxRetry_t3l9] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2movel3] worker2=1-> 1:(worker2'=1+1);
  [worker2dot3l3bRetry] worker2=2 & worker2retry_t3l3b < worker2_maxRetry_t3l3b -> p_worker2_t3l3b : (worker2'=worker2+1) + (1-p_worker2_t3l3b) : (worker2'=worker2) & (worker2retry_t3l3b' = worker2retry_t3l3b+1);
  [worker2dot3l3b] worker2=2 & worker2retry_t3l3b >= worker2_maxRetry_t3l3b -> 1:(worker2'=worker2Fail);
  [worker2dot3l3aRetry] worker2=3 & worker2retry_t3l3a < worker2_maxRetry_t3l3a -> p_worker2_t3l3a : (worker2'=worker2+1) + (1-p_worker2_t3l3a) : (worker2'=worker2) & (worker2retry_t3l3a' = worker2retry_t3l3a+1);
  [worker2dot3l3a] worker2=3 & worker2retry_t3l3a >= worker2_maxRetry_t3l3a -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=4-> 1:(worker2'=4+1);
  [worker2dot3l6Retry] worker2=5 & worker2retry_t3l6 < worker2_maxRetry_t3l6 -> p_worker2_t3l6 : (worker2'=worker2+1) + (1-p_worker2_t3l6) : (worker2'=worker2) & (worker2retry_t3l6' = worker2retry_t3l6+1);
  [worker2dot3l6] worker2=5 & worker2retry_t3l6 >= worker2_maxRetry_t3l6 -> 1:(worker2'=worker2Fail);
  [worker2movel9] worker2=6-> 1:(worker2'=6+1);
  [worker2dot3l9Retry] worker2=7 & worker2retry_t3l9 < worker2_maxRetry_t3l9 -> p_worker2_t3l9 : (worker2'=worker2+1) + (1-p_worker2_t3l9) : (worker2'=worker2) & (worker2retry_t3l9' = worker2retry_t3l9+1);
  [worker2dot3l9] worker2=7 & worker2retry_t3l9 >= worker2_maxRetry_t3l9 -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r1dot3l1a] true:1;
  [r1dot3l1aRetry] true:1;
  [r1dot2l1] true:1;
  [r1dot2l1Retry] true:1;
  [r1dot3l1b] true:1;
  [r1dot3l1bRetry] true:1;
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
  [worker2movel2] true:1;
  [worker2movel3] true:1;
  [worker2dot3l3b] true:5;
  [worker2dot3l3bRetry] true:5;
  [worker2dot3l3a] true:5;
  [worker2dot3l3aRetry] true:5;
  [worker2movel6] true:1;
  [worker2dot3l6] true:5;
  [worker2dot3l6Retry] true:5;
  [worker2movel9] true:1;
  [worker2dot3l9] true:5;
  [worker2dot3l9Retry] true:5;
endrewards