dtmc
evolve int worker1_maxRetry_t3l4 [1..5];
evolve int worker2_maxRetry_t1l2 [1..5];
evolve int worker2_maxRetry_t1l6 [1..5];
evolve int worker2_maxRetry_t1l9 [1..5];
evolve int r1_maxRetry_t3l1 [1..10];
evolve int r2_maxRetry_t2l2 [1..10];
evolve int r2_maxRetry_t3l5 [1..10];
evolve int r2_maxRetry_t2l6 [1..10];
evolve int r2_maxRetry_t2l9b [1..10];
evolve int r2_maxRetry_t2l9a [1..10];

const double p_worker1_t3l4=0.99;
const double p_worker2_t1l2=1.0;
const double p_worker2_t1l6=1.0;
const double p_worker2_t1l9=1.0;
const double p_r1_t3l1=0.97;
const double p_r2_t2l2=0.99;
const double p_r2_t3l5=0.97;
const double p_r2_t2l6=0.99;
const double p_r2_t2l9b=0.99;
const double p_r2_t2l9a=0.99;
const int worker1Final = 2;
const int worker1Fail = 3;
const int worker2Final = 7;
const int worker2Fail = 8;
const int r1Final = 1;
const int r1Fail = 2;
const int r2Final = 10;
const int r2Fail = 11;

module _worker1
  worker1 : [0..4];
  worker1retry_t3l4 : [0..worker1_maxRetry_t3l4] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot3l4Retry] worker1=1 & worker1retry_t3l4 < worker1_maxRetry_t3l4 -> p_worker1_t3l4 : (worker1'=worker1+1) + (1-p_worker1_t3l4) : (worker1'=worker1) & (worker1retry_t3l4' = worker1retry_t3l4+1);
  [worker1dot3l4] worker1=1 & worker1retry_t3l4 >= worker1_maxRetry_t3l4 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..9];
  worker2retry_t1l2 : [0..worker2_maxRetry_t1l2] init 0;
  worker2retry_t1l6 : [0..worker2_maxRetry_t1l6] init 0;
  worker2retry_t1l9 : [0..worker2_maxRetry_t1l9] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l2Retry] worker2=1 & worker2retry_t1l2 < worker2_maxRetry_t1l2 -> p_worker2_t1l2 : (worker2'=worker2+1) + (1-p_worker2_t1l2) : (worker2'=worker2) & (worker2retry_t1l2' = worker2retry_t1l2+1);
  [worker2dot1l2] worker2=1 & worker2retry_t1l2 >= worker2_maxRetry_t1l2 -> 1:(worker2'=worker2Fail);
  [worker2movel3] worker2=2-> 1:(worker2'=2+1);
  [worker2movel6] worker2=3-> 1:(worker2'=3+1);
  [worker2dot1l6Retry] worker2=4 & worker2retry_t1l6 < worker2_maxRetry_t1l6 -> p_worker2_t1l6 : (worker2'=worker2+1) + (1-p_worker2_t1l6) : (worker2'=worker2) & (worker2retry_t1l6' = worker2retry_t1l6+1);
  [worker2dot1l6] worker2=4 & worker2retry_t1l6 >= worker2_maxRetry_t1l6 -> 1:(worker2'=worker2Fail);
  [worker2movel9] worker2=5-> 1:(worker2'=5+1);
  [worker2dot1l9Retry] worker2=6 & worker2retry_t1l9 < worker2_maxRetry_t1l9 -> p_worker2_t1l9 : (worker2'=worker2+1) + (1-p_worker2_t1l9) : (worker2'=worker2) & (worker2retry_t1l9' = worker2retry_t1l9+1);
  [worker2dot1l9] worker2=6 & worker2retry_t1l9 >= worker2_maxRetry_t1l9 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..3];
  r1retry_t3l1 : [0..r1_maxRetry_t3l1] init 0;

  [r1dot3l1Retry] r1=0 & r1retry_t3l1 < r1_maxRetry_t3l1 -> p_r1_t3l1 : (r1'=r1+1) + (1-p_r1_t3l1) : (r1'=r1) & (r1retry_t3l1' = r1retry_t3l1+1);
  [r1dot3l1] r1=0 & r1retry_t3l1 >= r1_maxRetry_t3l1 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..12];
  r2retry_t2l2 : [0..r2_maxRetry_t2l2] init 0;
  r2retry_t3l5 : [0..r2_maxRetry_t3l5] init 0;
  r2retry_t2l6 : [0..r2_maxRetry_t2l6] init 0;
  r2retry_t2l9b : [0..r2_maxRetry_t2l9b] init 0;
  r2retry_t2l9a : [0..r2_maxRetry_t2l9a] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2dot2l2Retry] r2=1 & r2retry_t2l2 < r2_maxRetry_t2l2 -> p_r2_t2l2 : (r2'=r2+1) + (1-p_r2_t2l2) : (r2'=r2) & (r2retry_t2l2' = r2retry_t2l2+1);
  [r2dot2l2] r2=1 & r2retry_t2l2 >= r2_maxRetry_t2l2 -> 1:(r2'=r2Fail);
  [r2movel5] r2=2-> 1:(r2'=2+1);
  [r2dot3l5Retry] r2=3 & r2retry_t3l5 < r2_maxRetry_t3l5 -> p_r2_t3l5 : (r2'=r2+1) + (1-p_r2_t3l5) : (r2'=r2) & (r2retry_t3l5' = r2retry_t3l5+1);
  [r2dot3l5] r2=3 & r2retry_t3l5 >= r2_maxRetry_t3l5 -> 1:(r2'=r2Fail);
  [r2movel6] r2=4-> 1:(r2'=4+1);
  [r2dot2l6Retry] r2=5 & r2retry_t2l6 < r2_maxRetry_t2l6 -> p_r2_t2l6 : (r2'=r2+1) + (1-p_r2_t2l6) : (r2'=r2) & (r2retry_t2l6' = r2retry_t2l6+1);
  [r2dot2l6] r2=5 & r2retry_t2l6 >= r2_maxRetry_t2l6 -> 1:(r2'=r2Fail);
  [r2movel9] r2=6-> 1:(r2'=6+1);
  [r2dot2l9bRetry] r2=7 & r2retry_t2l9b < r2_maxRetry_t2l9b -> p_r2_t2l9b : (r2'=r2+1) + (1-p_r2_t2l9b) : (r2'=r2) & (r2retry_t2l9b' = r2retry_t2l9b+1);
  [r2dot2l9b] r2=7 & r2retry_t2l9b >= r2_maxRetry_t2l9b -> 1:(r2'=r2Fail);
  [r2dot2l9aRetry] r2=8 & r2retry_t2l9a < r2_maxRetry_t2l9a -> p_r2_t2l9a : (r2'=r2+1) + (1-p_r2_t2l9a) : (r2'=r2) & (r2retry_t2l9a' = r2retry_t2l9a+1);
  [r2dot2l9a] r2=8 & r2retry_t2l9a >= r2_maxRetry_t2l9a -> 1:(r2'=r2Fail);
  [r2movel8] r2=9-> 1:(r2'=9+1);
endmodule

rewards "cost"
  [worker1movel4] true:1;
  [worker1dot3l4] true:5;
  [worker1dot3l4Retry] true:5;
  [worker2movel2] true:1;
  [worker2dot1l2] true:3;
  [worker2dot1l2Retry] true:3;
  [worker2movel3] true:1;
  [worker2movel6] true:1;
  [worker2dot1l6] true:3;
  [worker2dot1l6Retry] true:3;
  [worker2movel9] true:1;
  [worker2dot1l9] true:3;
  [worker2dot1l9Retry] true:3;
  [r1dot3l1] true:1;
  [r1dot3l1Retry] true:1;
  [r2movel2] true:1;
  [r2dot2l2] true:1;
  [r2dot2l2Retry] true:1;
  [r2movel5] true:1;
  [r2dot3l5] true:1;
  [r2dot3l5Retry] true:1;
  [r2movel6] true:1;
  [r2dot2l6] true:1;
  [r2dot2l6Retry] true:1;
  [r2movel9] true:1;
  [r2dot2l9b] true:1;
  [r2dot2l9bRetry] true:1;
  [r2dot2l9a] true:1;
  [r2dot2l9aRetry] true:1;
  [r2movel8] true:1;
endrewards