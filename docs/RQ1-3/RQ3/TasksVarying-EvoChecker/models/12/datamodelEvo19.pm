dtmc
evolve int r2_maxRetry_t2l2 [1..10];
evolve int r2_maxRetry_t2l3 [1..10];
evolve int r2_maxRetry_t3l9b [1..10];
evolve int r2_maxRetry_t3l9a [1..10];
evolve int r2_maxRetry_t2l8 [1..10];
evolve int r2_maxRetry_t3l8 [1..10];
evolve int worker1_maxRetry_t3l4 [1..5];
evolve int worker1_maxRetry_t1l4 [1..5];
evolve int worker1_maxRetry_t1l5 [1..5];
evolve int worker1_maxRetry_t1l8 [1..5];
evolve int worker2_maxRetry_t1l1 [1..5];
evolve int worker2_maxRetry_t1l3 [1..5];

const double p_r2_t2l2=0.99;
const double p_r2_t2l3=0.99;
const double p_r2_t3l9b=0.97;
const double p_r2_t3l9a=0.97;
const double p_r2_t2l8=0.99;
const double p_r2_t3l8=0.97;
const double p_worker1_t3l4=0.99;
const double p_worker1_t1l4=1.0;
const double p_worker1_t1l5=1.0;
const double p_worker1_t1l8=1.0;
const double p_worker2_t1l1=1.0;
const double p_worker2_t1l3=1.0;
const int r2Final = 12;
const int r2Fail = 13;
const int worker1Final = 7;
const int worker1Fail = 8;
const int worker2Final = 4;
const int worker2Fail = 5;

module _r2
  r2 : [0..14];
  r2retry_t2l2 : [0..r2_maxRetry_t2l2] init 0;
  r2retry_t2l3 : [0..r2_maxRetry_t2l3] init 0;
  r2retry_t3l9b : [0..r2_maxRetry_t3l9b] init 0;
  r2retry_t3l9a : [0..r2_maxRetry_t3l9a] init 0;
  r2retry_t2l8 : [0..r2_maxRetry_t2l8] init 0;
  r2retry_t3l8 : [0..r2_maxRetry_t3l8] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2dot2l2Retry] r2=1 & r2retry_t2l2 < r2_maxRetry_t2l2 -> p_r2_t2l2 : (r2'=r2+1) + (1-p_r2_t2l2) : (r2'=r2) & (r2retry_t2l2' = r2retry_t2l2+1);
  [r2dot2l2] r2=1 & r2retry_t2l2 >= r2_maxRetry_t2l2 -> 1:(r2'=r2Fail);
  [r2movel3] r2=2-> 1:(r2'=2+1);
  [r2dot2l3Retry] r2=3 & r2retry_t2l3 < r2_maxRetry_t2l3 -> p_r2_t2l3 : (r2'=r2+1) + (1-p_r2_t2l3) : (r2'=r2) & (r2retry_t2l3' = r2retry_t2l3+1);
  [r2dot2l3] r2=3 & r2retry_t2l3 >= r2_maxRetry_t2l3 -> 1:(r2'=r2Fail);
  [r2movel6] r2=4-> 1:(r2'=4+1);
  [r2movel9] r2=5-> 1:(r2'=5+1);
  [r2dot3l9bRetry] r2=6 & r2retry_t3l9b < r2_maxRetry_t3l9b -> p_r2_t3l9b : (r2'=r2+1) + (1-p_r2_t3l9b) : (r2'=r2) & (r2retry_t3l9b' = r2retry_t3l9b+1);
  [r2dot3l9b] r2=6 & r2retry_t3l9b >= r2_maxRetry_t3l9b -> 1:(r2'=r2Fail);
  [r2dot3l9aRetry] r2=7 & r2retry_t3l9a < r2_maxRetry_t3l9a -> p_r2_t3l9a : (r2'=r2+1) + (1-p_r2_t3l9a) : (r2'=r2) & (r2retry_t3l9a' = r2retry_t3l9a+1);
  [r2dot3l9a] r2=7 & r2retry_t3l9a >= r2_maxRetry_t3l9a -> 1:(r2'=r2Fail);
  [r2movel8] r2=8-> 1:(r2'=8+1);
  [r2dot2l8Retry] r2=9 & r2retry_t2l8 < r2_maxRetry_t2l8 -> p_r2_t2l8 : (r2'=r2+1) + (1-p_r2_t2l8) : (r2'=r2) & (r2retry_t2l8' = r2retry_t2l8+1);
  [r2dot2l8] r2=9 & r2retry_t2l8 >= r2_maxRetry_t2l8 -> 1:(r2'=r2Fail);
  [r2dot3l8Retry] r2=10 & r2retry_t3l8 < r2_maxRetry_t3l8 -> p_r2_t3l8 : (r2'=r2+1) + (1-p_r2_t3l8) : (r2'=r2) & (r2retry_t3l8' = r2retry_t3l8+1);
  [r2dot3l8] r2=10 & r2retry_t3l8 >= r2_maxRetry_t3l8 -> 1:(r2'=r2Fail);
  [r2movel9] r2=11-> 1:(r2'=11+1);
endmodule

module _worker1
  worker1 : [0..9];
  worker1retry_t3l4 : [0..worker1_maxRetry_t3l4] init 0;
  worker1retry_t1l4 : [0..worker1_maxRetry_t1l4] init 0;
  worker1retry_t1l5 : [0..worker1_maxRetry_t1l5] init 0;
  worker1retry_t1l8 : [0..worker1_maxRetry_t1l8] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot3l4Retry] worker1=1 & worker1retry_t3l4 < worker1_maxRetry_t3l4 -> p_worker1_t3l4 : (worker1'=worker1+1) + (1-p_worker1_t3l4) : (worker1'=worker1) & (worker1retry_t3l4' = worker1retry_t3l4+1);
  [worker1dot3l4] worker1=1 & worker1retry_t3l4 >= worker1_maxRetry_t3l4 -> 1:(worker1'=worker1Fail);
  [worker1dot1l4Retry] worker1=2 & worker1retry_t1l4 < worker1_maxRetry_t1l4 -> p_worker1_t1l4 : (worker1'=worker1+1) + (1-p_worker1_t1l4) : (worker1'=worker1) & (worker1retry_t1l4' = worker1retry_t1l4+1);
  [worker1dot1l4] worker1=2 & worker1retry_t1l4 >= worker1_maxRetry_t1l4 -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=3-> 1:(worker1'=3+1);
  [worker1dot1l5Retry] worker1=4 & worker1retry_t1l5 < worker1_maxRetry_t1l5 -> p_worker1_t1l5 : (worker1'=worker1+1) + (1-p_worker1_t1l5) : (worker1'=worker1) & (worker1retry_t1l5' = worker1retry_t1l5+1);
  [worker1dot1l5] worker1=4 & worker1retry_t1l5 >= worker1_maxRetry_t1l5 -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=5-> 1:(worker1'=5+1);
  [worker1dot1l8Retry] worker1=6 & worker1retry_t1l8 < worker1_maxRetry_t1l8 -> p_worker1_t1l8 : (worker1'=worker1+1) + (1-p_worker1_t1l8) : (worker1'=worker1) & (worker1retry_t1l8' = worker1retry_t1l8+1);
  [worker1dot1l8] worker1=6 & worker1retry_t1l8 >= worker1_maxRetry_t1l8 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..6];
  worker2retry_t1l1 : [0..worker2_maxRetry_t1l1] init 0;
  worker2retry_t1l3 : [0..worker2_maxRetry_t1l3] init 0;

  [worker2dot1l1Retry] worker2=0 & worker2retry_t1l1 < worker2_maxRetry_t1l1 -> p_worker2_t1l1 : (worker2'=worker2+1) + (1-p_worker2_t1l1) : (worker2'=worker2) & (worker2retry_t1l1' = worker2retry_t1l1+1);
  [worker2dot1l1] worker2=0 & worker2retry_t1l1 >= worker2_maxRetry_t1l1 -> 1:(worker2'=worker2Fail);
  [worker2movel2] worker2=1-> 1:(worker2'=1+1);
  [worker2movel3] worker2=2-> 1:(worker2'=2+1);
  [worker2dot1l3Retry] worker2=3 & worker2retry_t1l3 < worker2_maxRetry_t1l3 -> p_worker2_t1l3 : (worker2'=worker2+1) + (1-p_worker2_t1l3) : (worker2'=worker2) & (worker2retry_t1l3' = worker2retry_t1l3+1);
  [worker2dot1l3] worker2=3 & worker2retry_t1l3 >= worker2_maxRetry_t1l3 -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r2movel2] true:1;
  [r2dot2l2] true:1;
  [r2dot2l2Retry] true:1;
  [r2movel3] true:1;
  [r2dot2l3] true:1;
  [r2dot2l3Retry] true:1;
  [r2movel6] true:1;
  [r2movel9] true:1;
  [r2dot3l9b] true:1;
  [r2dot3l9bRetry] true:1;
  [r2dot3l9a] true:1;
  [r2dot3l9aRetry] true:1;
  [r2movel8] true:1;
  [r2dot2l8] true:1;
  [r2dot2l8Retry] true:1;
  [r2dot3l8] true:1;
  [r2dot3l8Retry] true:1;
  [r2movel9] true:1;
  [worker1movel4] true:1;
  [worker1dot3l4] true:5;
  [worker1dot3l4Retry] true:5;
  [worker1dot1l4] true:3;
  [worker1dot1l4Retry] true:3;
  [worker1movel5] true:1;
  [worker1dot1l5] true:3;
  [worker1dot1l5Retry] true:3;
  [worker1movel8] true:1;
  [worker1dot1l8] true:3;
  [worker1dot1l8Retry] true:3;
  [worker2dot1l1] true:3;
  [worker2dot1l1Retry] true:3;
  [worker2movel2] true:1;
  [worker2movel3] true:1;
  [worker2dot1l3] true:3;
  [worker2dot1l3Retry] true:3;
endrewards