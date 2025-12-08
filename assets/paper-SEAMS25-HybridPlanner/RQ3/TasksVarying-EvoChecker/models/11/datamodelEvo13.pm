dtmc
evolve int r2_maxRetry_t3l2 [1..10];
evolve int r2_maxRetry_t2l3 [1..10];
evolve int r2_maxRetry_t2l6 [1..10];
evolve int r2_maxRetry_t2l9b [1..10];
evolve int r2_maxRetry_t2l9a [1..10];
evolve int worker1_maxRetry_t1l5 [1..5];
evolve int worker1_maxRetry_t1l6a [1..5];
evolve int worker1_maxRetry_t1l6b [1..5];
evolve int worker2_maxRetry_t3l1 [1..5];
evolve int r1_maxRetry_t2l4 [1..10];
evolve int r1_maxRetry_t3l4 [1..10];

const double p_r2_t3l2=0.97;
const double p_r2_t2l3=0.99;
const double p_r2_t2l6=0.99;
const double p_r2_t2l9b=0.99;
const double p_r2_t2l9a=0.99;
const double p_worker1_t1l5=1.0;
const double p_worker1_t1l6a=1.0;
const double p_worker1_t1l6b=1.0;
const double p_worker2_t3l1=0.99;
const double p_r1_t2l4=0.99;
const double p_r1_t3l4=0.97;
const int r2Final = 9;
const int r2Fail = 10;
const int worker1Final = 6;
const int worker1Fail = 7;
const int worker2Final = 1;
const int worker2Fail = 2;
const int r1Final = 3;
const int r1Fail = 4;

module _r2
  r2 : [0..11];
  r2retry_t3l2 : [0..r2_maxRetry_t3l2] init 0;
  r2retry_t2l3 : [0..r2_maxRetry_t2l3] init 0;
  r2retry_t2l6 : [0..r2_maxRetry_t2l6] init 0;
  r2retry_t2l9b : [0..r2_maxRetry_t2l9b] init 0;
  r2retry_t2l9a : [0..r2_maxRetry_t2l9a] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2dot3l2Retry] r2=1 & r2retry_t3l2 < r2_maxRetry_t3l2 -> p_r2_t3l2 : (r2'=r2+1) + (1-p_r2_t3l2) : (r2'=r2) & (r2retry_t3l2' = r2retry_t3l2+1);
  [r2dot3l2] r2=1 & r2retry_t3l2 >= r2_maxRetry_t3l2 -> 1:(r2'=r2Fail);
  [r2movel3] r2=2-> 1:(r2'=2+1);
  [r2dot2l3Retry] r2=3 & r2retry_t2l3 < r2_maxRetry_t2l3 -> p_r2_t2l3 : (r2'=r2+1) + (1-p_r2_t2l3) : (r2'=r2) & (r2retry_t2l3' = r2retry_t2l3+1);
  [r2dot2l3] r2=3 & r2retry_t2l3 >= r2_maxRetry_t2l3 -> 1:(r2'=r2Fail);
  [r2movel6] r2=4-> 1:(r2'=4+1);
  [r2dot2l6Retry] r2=5 & r2retry_t2l6 < r2_maxRetry_t2l6 -> p_r2_t2l6 : (r2'=r2+1) + (1-p_r2_t2l6) : (r2'=r2) & (r2retry_t2l6' = r2retry_t2l6+1);
  [r2dot2l6] r2=5 & r2retry_t2l6 >= r2_maxRetry_t2l6 -> 1:(r2'=r2Fail);
  [r2movel9] r2=6-> 1:(r2'=6+1);
  [r2dot2l9bRetry] r2=7 & r2retry_t2l9b < r2_maxRetry_t2l9b -> p_r2_t2l9b : (r2'=r2+1) + (1-p_r2_t2l9b) : (r2'=r2) & (r2retry_t2l9b' = r2retry_t2l9b+1);
  [r2dot2l9b] r2=7 & r2retry_t2l9b >= r2_maxRetry_t2l9b -> 1:(r2'=r2Fail);
  [r2dot2l9aRetry] r2=8 & r2retry_t2l9a < r2_maxRetry_t2l9a -> p_r2_t2l9a : (r2'=r2+1) + (1-p_r2_t2l9a) : (r2'=r2) & (r2retry_t2l9a' = r2retry_t2l9a+1);
  [r2dot2l9a] r2=8 & r2retry_t2l9a >= r2_maxRetry_t2l9a -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..8];
  worker1retry_t1l5 : [0..worker1_maxRetry_t1l5] init 0;
  worker1retry_t1l6a : [0..worker1_maxRetry_t1l6a] init 0;
  worker1retry_t1l6b : [0..worker1_maxRetry_t1l6b] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1movel5] worker1=1-> 1:(worker1'=1+1);
  [worker1dot1l5Retry] worker1=2 & worker1retry_t1l5 < worker1_maxRetry_t1l5 -> p_worker1_t1l5 : (worker1'=worker1+1) + (1-p_worker1_t1l5) : (worker1'=worker1) & (worker1retry_t1l5' = worker1retry_t1l5+1);
  [worker1dot1l5] worker1=2 & worker1retry_t1l5 >= worker1_maxRetry_t1l5 -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=3-> 1:(worker1'=3+1);
  [worker1dot1l6aRetry] worker1=4 & worker1retry_t1l6a < worker1_maxRetry_t1l6a -> p_worker1_t1l6a : (worker1'=worker1+1) + (1-p_worker1_t1l6a) : (worker1'=worker1) & (worker1retry_t1l6a' = worker1retry_t1l6a+1);
  [worker1dot1l6a] worker1=4 & worker1retry_t1l6a >= worker1_maxRetry_t1l6a -> 1:(worker1'=worker1Fail);
  [worker1dot1l6bRetry] worker1=5 & worker1retry_t1l6b < worker1_maxRetry_t1l6b -> p_worker1_t1l6b : (worker1'=worker1+1) + (1-p_worker1_t1l6b) : (worker1'=worker1) & (worker1retry_t1l6b' = worker1retry_t1l6b+1);
  [worker1dot1l6b] worker1=5 & worker1retry_t1l6b >= worker1_maxRetry_t1l6b -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..3];
  worker2retry_t3l1 : [0..worker2_maxRetry_t3l1] init 0;

  [worker2dot3l1Retry] worker2=0 & worker2retry_t3l1 < worker2_maxRetry_t3l1 -> p_worker2_t3l1 : (worker2'=worker2+1) + (1-p_worker2_t3l1) : (worker2'=worker2) & (worker2retry_t3l1' = worker2retry_t3l1+1);
  [worker2dot3l1] worker2=0 & worker2retry_t3l1 >= worker2_maxRetry_t3l1 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..5];
  r1retry_t2l4 : [0..r1_maxRetry_t2l4] init 0;
  r1retry_t3l4 : [0..r1_maxRetry_t3l4] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1dot2l4Retry] r1=1 & r1retry_t2l4 < r1_maxRetry_t2l4 -> p_r1_t2l4 : (r1'=r1+1) + (1-p_r1_t2l4) : (r1'=r1) & (r1retry_t2l4' = r1retry_t2l4+1);
  [r1dot2l4] r1=1 & r1retry_t2l4 >= r1_maxRetry_t2l4 -> 1:(r1'=r1Fail);
  [r1dot3l4Retry] r1=2 & r1retry_t3l4 < r1_maxRetry_t3l4 -> p_r1_t3l4 : (r1'=r1+1) + (1-p_r1_t3l4) : (r1'=r1) & (r1retry_t3l4' = r1retry_t3l4+1);
  [r1dot3l4] r1=2 & r1retry_t3l4 >= r1_maxRetry_t3l4 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [r2movel2] true:1;
  [r2dot3l2] true:1;
  [r2dot3l2Retry] true:1;
  [r2movel3] true:1;
  [r2dot2l3] true:1;
  [r2dot2l3Retry] true:1;
  [r2movel6] true:1;
  [r2dot2l6] true:1;
  [r2dot2l6Retry] true:1;
  [r2movel9] true:1;
  [r2dot2l9b] true:1;
  [r2dot2l9bRetry] true:1;
  [r2dot2l9a] true:1;
  [r2dot2l9aRetry] true:1;
  [worker1movel2] true:1;
  [worker1movel5] true:1;
  [worker1dot1l5] true:3;
  [worker1dot1l5Retry] true:3;
  [worker1movel6] true:1;
  [worker1dot1l6a] true:3;
  [worker1dot1l6aRetry] true:3;
  [worker1dot1l6b] true:3;
  [worker1dot1l6bRetry] true:3;
  [worker2dot3l1] true:5;
  [worker2dot3l1Retry] true:5;
  [r1movel4] true:1;
  [r1dot2l4] true:1;
  [r1dot2l4Retry] true:1;
  [r1dot3l4] true:1;
  [r1dot3l4Retry] true:1;
endrewards