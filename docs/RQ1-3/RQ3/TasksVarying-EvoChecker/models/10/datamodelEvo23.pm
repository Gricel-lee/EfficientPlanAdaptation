dtmc
evolve int worker1_maxRetry_t1l4 [1..5];
evolve int worker1_maxRetry_t3l5 [1..5];
evolve int worker1_maxRetry_t1l5a [1..5];
evolve int worker1_maxRetry_t1l5b [1..5];
evolve int worker1_maxRetry_t1l6 [1..5];
evolve int r1_maxRetry_t2l4 [1..10];
evolve int r2_maxRetry_t2l2 [1..10];
evolve int r2_maxRetry_t2l3 [1..10];
evolve int r2_maxRetry_t3l9 [1..10];
evolve int r2_maxRetry_t2l9 [1..10];

const double p_worker1_t1l4=1.0;
const double p_worker1_t3l5=0.99;
const double p_worker1_t1l5a=1.0;
const double p_worker1_t1l5b=1.0;
const double p_worker1_t1l6=1.0;
const double p_r1_t2l4=0.99;
const double p_r2_t2l2=0.99;
const double p_r2_t2l3=0.99;
const double p_r2_t3l9=0.97;
const double p_r2_t2l9=0.99;
const int worker1Final = 8;
const int worker1Fail = 9;
const int r1Final = 2;
const int r1Fail = 3;
const int r2Final = 8;
const int r2Fail = 9;

module _worker1
  worker1 : [0..10];
  worker1retry_t1l4 : [0..worker1_maxRetry_t1l4] init 0;
  worker1retry_t3l5 : [0..worker1_maxRetry_t3l5] init 0;
  worker1retry_t1l5a : [0..worker1_maxRetry_t1l5a] init 0;
  worker1retry_t1l5b : [0..worker1_maxRetry_t1l5b] init 0;
  worker1retry_t1l6 : [0..worker1_maxRetry_t1l6] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l4Retry] worker1=1 & worker1retry_t1l4 < worker1_maxRetry_t1l4 -> p_worker1_t1l4 : (worker1'=worker1+1) + (1-p_worker1_t1l4) : (worker1'=worker1) & (worker1retry_t1l4' = worker1retry_t1l4+1);
  [worker1dot1l4] worker1=1 & worker1retry_t1l4 >= worker1_maxRetry_t1l4 -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=2-> 1:(worker1'=2+1);
  [worker1dot3l5Retry] worker1=3 & worker1retry_t3l5 < worker1_maxRetry_t3l5 -> p_worker1_t3l5 : (worker1'=worker1+1) + (1-p_worker1_t3l5) : (worker1'=worker1) & (worker1retry_t3l5' = worker1retry_t3l5+1);
  [worker1dot3l5] worker1=3 & worker1retry_t3l5 >= worker1_maxRetry_t3l5 -> 1:(worker1'=worker1Fail);
  [worker1dot1l5aRetry] worker1=4 & worker1retry_t1l5a < worker1_maxRetry_t1l5a -> p_worker1_t1l5a : (worker1'=worker1+1) + (1-p_worker1_t1l5a) : (worker1'=worker1) & (worker1retry_t1l5a' = worker1retry_t1l5a+1);
  [worker1dot1l5a] worker1=4 & worker1retry_t1l5a >= worker1_maxRetry_t1l5a -> 1:(worker1'=worker1Fail);
  [worker1dot1l5bRetry] worker1=5 & worker1retry_t1l5b < worker1_maxRetry_t1l5b -> p_worker1_t1l5b : (worker1'=worker1+1) + (1-p_worker1_t1l5b) : (worker1'=worker1) & (worker1retry_t1l5b' = worker1retry_t1l5b+1);
  [worker1dot1l5b] worker1=5 & worker1retry_t1l5b >= worker1_maxRetry_t1l5b -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=6-> 1:(worker1'=6+1);
  [worker1dot1l6Retry] worker1=7 & worker1retry_t1l6 < worker1_maxRetry_t1l6 -> p_worker1_t1l6 : (worker1'=worker1+1) + (1-p_worker1_t1l6) : (worker1'=worker1) & (worker1retry_t1l6' = worker1retry_t1l6+1);
  [worker1dot1l6] worker1=7 & worker1retry_t1l6 >= worker1_maxRetry_t1l6 -> 1:(worker1'=worker1Fail);
endmodule

module _r1
  r1 : [0..4];
  r1retry_t2l4 : [0..r1_maxRetry_t2l4] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1dot2l4Retry] r1=1 & r1retry_t2l4 < r1_maxRetry_t2l4 -> p_r1_t2l4 : (r1'=r1+1) + (1-p_r1_t2l4) : (r1'=r1) & (r1retry_t2l4' = r1retry_t2l4+1);
  [r1dot2l4] r1=1 & r1retry_t2l4 >= r1_maxRetry_t2l4 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..10];
  r2retry_t2l2 : [0..r2_maxRetry_t2l2] init 0;
  r2retry_t2l3 : [0..r2_maxRetry_t2l3] init 0;
  r2retry_t3l9 : [0..r2_maxRetry_t3l9] init 0;
  r2retry_t2l9 : [0..r2_maxRetry_t2l9] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2dot2l2Retry] r2=1 & r2retry_t2l2 < r2_maxRetry_t2l2 -> p_r2_t2l2 : (r2'=r2+1) + (1-p_r2_t2l2) : (r2'=r2) & (r2retry_t2l2' = r2retry_t2l2+1);
  [r2dot2l2] r2=1 & r2retry_t2l2 >= r2_maxRetry_t2l2 -> 1:(r2'=r2Fail);
  [r2movel3] r2=2-> 1:(r2'=2+1);
  [r2dot2l3Retry] r2=3 & r2retry_t2l3 < r2_maxRetry_t2l3 -> p_r2_t2l3 : (r2'=r2+1) + (1-p_r2_t2l3) : (r2'=r2) & (r2retry_t2l3' = r2retry_t2l3+1);
  [r2dot2l3] r2=3 & r2retry_t2l3 >= r2_maxRetry_t2l3 -> 1:(r2'=r2Fail);
  [r2movel6] r2=4-> 1:(r2'=4+1);
  [r2movel9] r2=5-> 1:(r2'=5+1);
  [r2dot3l9Retry] r2=6 & r2retry_t3l9 < r2_maxRetry_t3l9 -> p_r2_t3l9 : (r2'=r2+1) + (1-p_r2_t3l9) : (r2'=r2) & (r2retry_t3l9' = r2retry_t3l9+1);
  [r2dot3l9] r2=6 & r2retry_t3l9 >= r2_maxRetry_t3l9 -> 1:(r2'=r2Fail);
  [r2dot2l9Retry] r2=7 & r2retry_t2l9 < r2_maxRetry_t2l9 -> p_r2_t2l9 : (r2'=r2+1) + (1-p_r2_t2l9) : (r2'=r2) & (r2retry_t2l9' = r2retry_t2l9+1);
  [r2dot2l9] r2=7 & r2retry_t2l9 >= r2_maxRetry_t2l9 -> 1:(r2'=r2Fail);
endmodule

rewards "cost"
  [worker1movel4] true:1;
  [worker1dot1l4] true:3;
  [worker1dot1l4Retry] true:3;
  [worker1movel5] true:1;
  [worker1dot3l5] true:5;
  [worker1dot3l5Retry] true:5;
  [worker1dot1l5a] true:3;
  [worker1dot1l5aRetry] true:3;
  [worker1dot1l5b] true:3;
  [worker1dot1l5bRetry] true:3;
  [worker1movel6] true:1;
  [worker1dot1l6] true:3;
  [worker1dot1l6Retry] true:3;
  [r1movel4] true:1;
  [r1dot2l4] true:1;
  [r1dot2l4Retry] true:1;
  [r2movel2] true:1;
  [r2dot2l2] true:1;
  [r2dot2l2Retry] true:1;
  [r2movel3] true:1;
  [r2dot2l3] true:1;
  [r2dot2l3Retry] true:1;
  [r2movel6] true:1;
  [r2movel9] true:1;
  [r2dot3l9] true:1;
  [r2dot3l9Retry] true:1;
  [r2dot2l9] true:1;
  [r2dot2l9Retry] true:1;
endrewards