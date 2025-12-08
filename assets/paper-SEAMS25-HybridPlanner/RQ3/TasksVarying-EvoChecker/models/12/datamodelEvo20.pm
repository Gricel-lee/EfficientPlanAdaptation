dtmc
evolve int r1_maxRetry_t2l1 [1..10];
evolve int r2_maxRetry_t2l4 [1..10];
evolve int r2_maxRetry_t3l5 [1..10];
evolve int r2_maxRetry_t2l6 [1..10];
evolve int r2_maxRetry_t2l3a [1..10];
evolve int r2_maxRetry_t2l3c [1..10];
evolve int r2_maxRetry_t2l3b [1..10];
evolve int worker1_maxRetry_t1l7 [1..5];
evolve int worker1_maxRetry_t3l8 [1..5];
evolve int worker1_maxRetry_t3l9 [1..5];
evolve int worker1_maxRetry_t1l9 [1..5];
evolve int worker2_maxRetry_t1l2 [1..5];

const double p_r1_t2l1=0.99;
const double p_r2_t2l4=0.99;
const double p_r2_t3l5=0.97;
const double p_r2_t2l6=0.99;
const double p_r2_t2l3a=0.99;
const double p_r2_t2l3c=0.99;
const double p_r2_t2l3b=0.99;
const double p_worker1_t1l7=1.0;
const double p_worker1_t3l8=0.99;
const double p_worker1_t3l9=0.99;
const double p_worker1_t1l9=1.0;
const double p_worker2_t1l2=1.0;
const int r1Final = 1;
const int r1Fail = 2;
const int r2Final = 10;
const int r2Fail = 11;
const int worker1Final = 8;
const int worker1Fail = 9;
const int worker2Final = 2;
const int worker2Fail = 3;

module _r1
  r1 : [0..3];
  r1retry_t2l1 : [0..r1_maxRetry_t2l1] init 0;

  [r1dot2l1Retry] r1=0 & r1retry_t2l1 < r1_maxRetry_t2l1 -> p_r1_t2l1 : (r1'=r1+1) + (1-p_r1_t2l1) : (r1'=r1) & (r1retry_t2l1' = r1retry_t2l1+1);
  [r1dot2l1] r1=0 & r1retry_t2l1 >= r1_maxRetry_t2l1 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..12];
  r2retry_t2l4 : [0..r2_maxRetry_t2l4] init 0;
  r2retry_t3l5 : [0..r2_maxRetry_t3l5] init 0;
  r2retry_t2l6 : [0..r2_maxRetry_t2l6] init 0;
  r2retry_t2l3a : [0..r2_maxRetry_t2l3a] init 0;
  r2retry_t2l3c : [0..r2_maxRetry_t2l3c] init 0;
  r2retry_t2l3b : [0..r2_maxRetry_t2l3b] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2dot2l4Retry] r2=1 & r2retry_t2l4 < r2_maxRetry_t2l4 -> p_r2_t2l4 : (r2'=r2+1) + (1-p_r2_t2l4) : (r2'=r2) & (r2retry_t2l4' = r2retry_t2l4+1);
  [r2dot2l4] r2=1 & r2retry_t2l4 >= r2_maxRetry_t2l4 -> 1:(r2'=r2Fail);
  [r2movel5] r2=2-> 1:(r2'=2+1);
  [r2dot3l5Retry] r2=3 & r2retry_t3l5 < r2_maxRetry_t3l5 -> p_r2_t3l5 : (r2'=r2+1) + (1-p_r2_t3l5) : (r2'=r2) & (r2retry_t3l5' = r2retry_t3l5+1);
  [r2dot3l5] r2=3 & r2retry_t3l5 >= r2_maxRetry_t3l5 -> 1:(r2'=r2Fail);
  [r2movel6] r2=4-> 1:(r2'=4+1);
  [r2dot2l6Retry] r2=5 & r2retry_t2l6 < r2_maxRetry_t2l6 -> p_r2_t2l6 : (r2'=r2+1) + (1-p_r2_t2l6) : (r2'=r2) & (r2retry_t2l6' = r2retry_t2l6+1);
  [r2dot2l6] r2=5 & r2retry_t2l6 >= r2_maxRetry_t2l6 -> 1:(r2'=r2Fail);
  [r2movel3] r2=6-> 1:(r2'=6+1);
  [r2dot2l3aRetry] r2=7 & r2retry_t2l3a < r2_maxRetry_t2l3a -> p_r2_t2l3a : (r2'=r2+1) + (1-p_r2_t2l3a) : (r2'=r2) & (r2retry_t2l3a' = r2retry_t2l3a+1);
  [r2dot2l3a] r2=7 & r2retry_t2l3a >= r2_maxRetry_t2l3a -> 1:(r2'=r2Fail);
  [r2dot2l3cRetry] r2=8 & r2retry_t2l3c < r2_maxRetry_t2l3c -> p_r2_t2l3c : (r2'=r2+1) + (1-p_r2_t2l3c) : (r2'=r2) & (r2retry_t2l3c' = r2retry_t2l3c+1);
  [r2dot2l3c] r2=8 & r2retry_t2l3c >= r2_maxRetry_t2l3c -> 1:(r2'=r2Fail);
  [r2dot2l3bRetry] r2=9 & r2retry_t2l3b < r2_maxRetry_t2l3b -> p_r2_t2l3b : (r2'=r2+1) + (1-p_r2_t2l3b) : (r2'=r2) & (r2retry_t2l3b' = r2retry_t2l3b+1);
  [r2dot2l3b] r2=9 & r2retry_t2l3b >= r2_maxRetry_t2l3b -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..10];
  worker1retry_t1l7 : [0..worker1_maxRetry_t1l7] init 0;
  worker1retry_t3l8 : [0..worker1_maxRetry_t3l8] init 0;
  worker1retry_t3l9 : [0..worker1_maxRetry_t3l9] init 0;
  worker1retry_t1l9 : [0..worker1_maxRetry_t1l9] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1movel7] worker1=1-> 1:(worker1'=1+1);
  [worker1dot1l7Retry] worker1=2 & worker1retry_t1l7 < worker1_maxRetry_t1l7 -> p_worker1_t1l7 : (worker1'=worker1+1) + (1-p_worker1_t1l7) : (worker1'=worker1) & (worker1retry_t1l7' = worker1retry_t1l7+1);
  [worker1dot1l7] worker1=2 & worker1retry_t1l7 >= worker1_maxRetry_t1l7 -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=3-> 1:(worker1'=3+1);
  [worker1dot3l8Retry] worker1=4 & worker1retry_t3l8 < worker1_maxRetry_t3l8 -> p_worker1_t3l8 : (worker1'=worker1+1) + (1-p_worker1_t3l8) : (worker1'=worker1) & (worker1retry_t3l8' = worker1retry_t3l8+1);
  [worker1dot3l8] worker1=4 & worker1retry_t3l8 >= worker1_maxRetry_t3l8 -> 1:(worker1'=worker1Fail);
  [worker1movel9] worker1=5-> 1:(worker1'=5+1);
  [worker1dot3l9Retry] worker1=6 & worker1retry_t3l9 < worker1_maxRetry_t3l9 -> p_worker1_t3l9 : (worker1'=worker1+1) + (1-p_worker1_t3l9) : (worker1'=worker1) & (worker1retry_t3l9' = worker1retry_t3l9+1);
  [worker1dot3l9] worker1=6 & worker1retry_t3l9 >= worker1_maxRetry_t3l9 -> 1:(worker1'=worker1Fail);
  [worker1dot1l9Retry] worker1=7 & worker1retry_t1l9 < worker1_maxRetry_t1l9 -> p_worker1_t1l9 : (worker1'=worker1+1) + (1-p_worker1_t1l9) : (worker1'=worker1) & (worker1retry_t1l9' = worker1retry_t1l9+1);
  [worker1dot1l9] worker1=7 & worker1retry_t1l9 >= worker1_maxRetry_t1l9 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..4];
  worker2retry_t1l2 : [0..worker2_maxRetry_t1l2] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l2Retry] worker2=1 & worker2retry_t1l2 < worker2_maxRetry_t1l2 -> p_worker2_t1l2 : (worker2'=worker2+1) + (1-p_worker2_t1l2) : (worker2'=worker2) & (worker2retry_t1l2' = worker2retry_t1l2+1);
  [worker2dot1l2] worker2=1 & worker2retry_t1l2 >= worker2_maxRetry_t1l2 -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r1dot2l1] true:1;
  [r1dot2l1Retry] true:1;
  [r2movel4] true:1;
  [r2dot2l4] true:1;
  [r2dot2l4Retry] true:1;
  [r2movel5] true:1;
  [r2dot3l5] true:1;
  [r2dot3l5Retry] true:1;
  [r2movel6] true:1;
  [r2dot2l6] true:1;
  [r2dot2l6Retry] true:1;
  [r2movel3] true:1;
  [r2dot2l3a] true:1;
  [r2dot2l3aRetry] true:1;
  [r2dot2l3c] true:1;
  [r2dot2l3cRetry] true:1;
  [r2dot2l3b] true:1;
  [r2dot2l3bRetry] true:1;
  [worker1movel4] true:1;
  [worker1movel7] true:1;
  [worker1dot1l7] true:3;
  [worker1dot1l7Retry] true:3;
  [worker1movel8] true:1;
  [worker1dot3l8] true:5;
  [worker1dot3l8Retry] true:5;
  [worker1movel9] true:1;
  [worker1dot3l9] true:5;
  [worker1dot3l9Retry] true:5;
  [worker1dot1l9] true:3;
  [worker1dot1l9Retry] true:3;
  [worker2movel2] true:1;
  [worker2dot1l2] true:3;
  [worker2dot1l2Retry] true:3;
endrewards