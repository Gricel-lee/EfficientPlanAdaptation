dtmc
evolve int r2_maxRetry_t2l4 [1..10];
evolve int r2_maxRetry_t3l6 [1..10];
evolve int r2_maxRetry_t2l9 [1..10];
evolve int r2_maxRetry_t3l3 [1..10];
evolve int r2_maxRetry_t2l3 [1..10];
evolve int worker1_maxRetry_t1l2 [1..5];
evolve int worker1_maxRetry_t1l5 [1..5];
evolve int worker1_maxRetry_t3l5 [1..5];
evolve int worker1_maxRetry_t1l6 [1..5];
evolve int worker1_maxRetry_t1l9 [1..5];
evolve int r1_maxRetry_t2l1 [1..10];

const double p_r2_t2l4=0.99;
const double p_r2_t3l6=0.97;
const double p_r2_t2l9=0.99;
const double p_r2_t3l3=0.97;
const double p_r2_t2l3=0.99;
const double p_worker1_t1l2=1.0;
const double p_worker1_t1l5=1.0;
const double p_worker1_t3l5=0.99;
const double p_worker1_t1l6=1.0;
const double p_worker1_t1l9=1.0;
const double p_r1_t2l1=0.99;
const int r2Final = 11;
const int r2Fail = 12;
const int worker1Final = 9;
const int worker1Fail = 10;
const int r1Final = 1;
const int r1Fail = 2;

module _r2
  r2 : [0..13];
  r2retry_t2l4 : [0..r2_maxRetry_t2l4] init 0;
  r2retry_t3l6 : [0..r2_maxRetry_t3l6] init 0;
  r2retry_t2l9 : [0..r2_maxRetry_t2l9] init 0;
  r2retry_t3l3 : [0..r2_maxRetry_t3l3] init 0;
  r2retry_t2l3 : [0..r2_maxRetry_t2l3] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2dot2l4Retry] r2=1 & r2retry_t2l4 < r2_maxRetry_t2l4 -> p_r2_t2l4 : (r2'=r2+1) + (1-p_r2_t2l4) : (r2'=r2) & (r2retry_t2l4' = r2retry_t2l4+1);
  [r2dot2l4] r2=1 & r2retry_t2l4 >= r2_maxRetry_t2l4 -> 1:(r2'=r2Fail);
  [r2movel5] r2=2-> 1:(r2'=2+1);
  [r2movel6] r2=3-> 1:(r2'=3+1);
  [r2dot3l6Retry] r2=4 & r2retry_t3l6 < r2_maxRetry_t3l6 -> p_r2_t3l6 : (r2'=r2+1) + (1-p_r2_t3l6) : (r2'=r2) & (r2retry_t3l6' = r2retry_t3l6+1);
  [r2dot3l6] r2=4 & r2retry_t3l6 >= r2_maxRetry_t3l6 -> 1:(r2'=r2Fail);
  [r2movel9] r2=5-> 1:(r2'=5+1);
  [r2dot2l9Retry] r2=6 & r2retry_t2l9 < r2_maxRetry_t2l9 -> p_r2_t2l9 : (r2'=r2+1) + (1-p_r2_t2l9) : (r2'=r2) & (r2retry_t2l9' = r2retry_t2l9+1);
  [r2dot2l9] r2=6 & r2retry_t2l9 >= r2_maxRetry_t2l9 -> 1:(r2'=r2Fail);
  [r2movel6] r2=7-> 1:(r2'=7+1);
  [r2movel3] r2=8-> 1:(r2'=8+1);
  [r2dot3l3Retry] r2=9 & r2retry_t3l3 < r2_maxRetry_t3l3 -> p_r2_t3l3 : (r2'=r2+1) + (1-p_r2_t3l3) : (r2'=r2) & (r2retry_t3l3' = r2retry_t3l3+1);
  [r2dot3l3] r2=9 & r2retry_t3l3 >= r2_maxRetry_t3l3 -> 1:(r2'=r2Fail);
  [r2dot2l3Retry] r2=10 & r2retry_t2l3 < r2_maxRetry_t2l3 -> p_r2_t2l3 : (r2'=r2+1) + (1-p_r2_t2l3) : (r2'=r2) & (r2retry_t2l3' = r2retry_t2l3+1);
  [r2dot2l3] r2=10 & r2retry_t2l3 >= r2_maxRetry_t2l3 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..11];
  worker1retry_t1l2 : [0..worker1_maxRetry_t1l2] init 0;
  worker1retry_t1l5 : [0..worker1_maxRetry_t1l5] init 0;
  worker1retry_t3l5 : [0..worker1_maxRetry_t3l5] init 0;
  worker1retry_t1l6 : [0..worker1_maxRetry_t1l6] init 0;
  worker1retry_t1l9 : [0..worker1_maxRetry_t1l9] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l2Retry] worker1=1 & worker1retry_t1l2 < worker1_maxRetry_t1l2 -> p_worker1_t1l2 : (worker1'=worker1+1) + (1-p_worker1_t1l2) : (worker1'=worker1) & (worker1retry_t1l2' = worker1retry_t1l2+1);
  [worker1dot1l2] worker1=1 & worker1retry_t1l2 >= worker1_maxRetry_t1l2 -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=2-> 1:(worker1'=2+1);
  [worker1dot1l5Retry] worker1=3 & worker1retry_t1l5 < worker1_maxRetry_t1l5 -> p_worker1_t1l5 : (worker1'=worker1+1) + (1-p_worker1_t1l5) : (worker1'=worker1) & (worker1retry_t1l5' = worker1retry_t1l5+1);
  [worker1dot1l5] worker1=3 & worker1retry_t1l5 >= worker1_maxRetry_t1l5 -> 1:(worker1'=worker1Fail);
  [worker1dot3l5Retry] worker1=4 & worker1retry_t3l5 < worker1_maxRetry_t3l5 -> p_worker1_t3l5 : (worker1'=worker1+1) + (1-p_worker1_t3l5) : (worker1'=worker1) & (worker1retry_t3l5' = worker1retry_t3l5+1);
  [worker1dot3l5] worker1=4 & worker1retry_t3l5 >= worker1_maxRetry_t3l5 -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=5-> 1:(worker1'=5+1);
  [worker1dot1l6Retry] worker1=6 & worker1retry_t1l6 < worker1_maxRetry_t1l6 -> p_worker1_t1l6 : (worker1'=worker1+1) + (1-p_worker1_t1l6) : (worker1'=worker1) & (worker1retry_t1l6' = worker1retry_t1l6+1);
  [worker1dot1l6] worker1=6 & worker1retry_t1l6 >= worker1_maxRetry_t1l6 -> 1:(worker1'=worker1Fail);
  [worker1movel9] worker1=7-> 1:(worker1'=7+1);
  [worker1dot1l9Retry] worker1=8 & worker1retry_t1l9 < worker1_maxRetry_t1l9 -> p_worker1_t1l9 : (worker1'=worker1+1) + (1-p_worker1_t1l9) : (worker1'=worker1) & (worker1retry_t1l9' = worker1retry_t1l9+1);
  [worker1dot1l9] worker1=8 & worker1retry_t1l9 >= worker1_maxRetry_t1l9 -> 1:(worker1'=worker1Fail);
endmodule

module _r1
  r1 : [0..3];
  r1retry_t2l1 : [0..r1_maxRetry_t2l1] init 0;

  [r1dot2l1Retry] r1=0 & r1retry_t2l1 < r1_maxRetry_t2l1 -> p_r1_t2l1 : (r1'=r1+1) + (1-p_r1_t2l1) : (r1'=r1) & (r1retry_t2l1' = r1retry_t2l1+1);
  [r1dot2l1] r1=0 & r1retry_t2l1 >= r1_maxRetry_t2l1 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [r2movel4] true:1;
  [r2dot2l4] true:1;
  [r2dot2l4Retry] true:1;
  [r2movel5] true:1;
  [r2movel6] true:1;
  [r2dot3l6] true:1;
  [r2dot3l6Retry] true:1;
  [r2movel9] true:1;
  [r2dot2l9] true:1;
  [r2dot2l9Retry] true:1;
  [r2movel6] true:1;
  [r2movel3] true:1;
  [r2dot3l3] true:1;
  [r2dot3l3Retry] true:1;
  [r2dot2l3] true:1;
  [r2dot2l3Retry] true:1;
  [worker1movel2] true:1;
  [worker1dot1l2] true:3;
  [worker1dot1l2Retry] true:3;
  [worker1movel5] true:1;
  [worker1dot1l5] true:3;
  [worker1dot1l5Retry] true:3;
  [worker1dot3l5] true:5;
  [worker1dot3l5Retry] true:5;
  [worker1movel6] true:1;
  [worker1dot1l6] true:3;
  [worker1dot1l6Retry] true:3;
  [worker1movel9] true:1;
  [worker1dot1l9] true:3;
  [worker1dot1l9Retry] true:3;
  [r1dot2l1] true:1;
  [r1dot2l1Retry] true:1;
endrewards