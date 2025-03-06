dtmc
evolve int worker2_maxRetry_t3l2 [1..5];
evolve int worker2_maxRetry_t1l3 [1..5];
evolve int r1_maxRetry_t3l4b [1..10];
evolve int r1_maxRetry_t3l4a [1..10];
evolve int r1_maxRetry_t2l7 [1..10];
evolve int r1_maxRetry_t3l8 [1..10];
evolve int r1_maxRetry_t2l5 [1..10];
evolve int r2_maxRetry_t3l3a [1..10];
evolve int r2_maxRetry_t3l3b [1..10];
evolve int r2_maxRetry_t2l3 [1..10];
evolve int r2_maxRetry_t3l6 [1..10];
evolve int r2_maxRetry_t3l9 [1..10];
evolve int worker1_maxRetry_t1l1 [1..5];

const double p_worker2_t3l2=0.99;
const double p_worker2_t1l3=1.0;
const double p_r1_t3l4b=0.97;
const double p_r1_t3l4a=0.97;
const double p_r1_t2l7=0.99;
const double p_r1_t3l8=0.97;
const double p_r1_t2l5=0.99;
const double p_r2_t3l3a=0.97;
const double p_r2_t3l3b=0.97;
const double p_r2_t2l3=0.99;
const double p_r2_t3l6=0.97;
const double p_r2_t3l9=0.97;
const double p_worker1_t1l1=1.0;
const int worker2Final = 4;
const int worker2Fail = 5;
const int r1Final = 9;
const int r1Fail = 10;
const int r2Final = 9;
const int r2Fail = 10;
const int worker1Final = 1;
const int worker1Fail = 2;

module _worker2
  worker2 : [0..6];
  worker2retry_t3l2 : [0..worker2_maxRetry_t3l2] init 0;
  worker2retry_t1l3 : [0..worker2_maxRetry_t1l3] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot3l2Retry] worker2=1 & worker2retry_t3l2 < worker2_maxRetry_t3l2 -> p_worker2_t3l2 : (worker2'=worker2+1) + (1-p_worker2_t3l2) : (worker2'=worker2) & (worker2retry_t3l2' = worker2retry_t3l2+1);
  [worker2dot3l2] worker2=1 & worker2retry_t3l2 >= worker2_maxRetry_t3l2 -> 1:(worker2'=worker2Fail);
  [worker2movel3] worker2=2-> 1:(worker2'=2+1);
  [worker2dot1l3Retry] worker2=3 & worker2retry_t1l3 < worker2_maxRetry_t1l3 -> p_worker2_t1l3 : (worker2'=worker2+1) + (1-p_worker2_t1l3) : (worker2'=worker2) & (worker2retry_t1l3' = worker2retry_t1l3+1);
  [worker2dot1l3] worker2=3 & worker2retry_t1l3 >= worker2_maxRetry_t1l3 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..11];
  r1retry_t3l4b : [0..r1_maxRetry_t3l4b] init 0;
  r1retry_t3l4a : [0..r1_maxRetry_t3l4a] init 0;
  r1retry_t2l7 : [0..r1_maxRetry_t2l7] init 0;
  r1retry_t3l8 : [0..r1_maxRetry_t3l8] init 0;
  r1retry_t2l5 : [0..r1_maxRetry_t2l5] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1dot3l4bRetry] r1=1 & r1retry_t3l4b < r1_maxRetry_t3l4b -> p_r1_t3l4b : (r1'=r1+1) + (1-p_r1_t3l4b) : (r1'=r1) & (r1retry_t3l4b' = r1retry_t3l4b+1);
  [r1dot3l4b] r1=1 & r1retry_t3l4b >= r1_maxRetry_t3l4b -> 1:(r1'=r1Fail);
  [r1dot3l4aRetry] r1=2 & r1retry_t3l4a < r1_maxRetry_t3l4a -> p_r1_t3l4a : (r1'=r1+1) + (1-p_r1_t3l4a) : (r1'=r1) & (r1retry_t3l4a' = r1retry_t3l4a+1);
  [r1dot3l4a] r1=2 & r1retry_t3l4a >= r1_maxRetry_t3l4a -> 1:(r1'=r1Fail);
  [r1movel7] r1=3-> 1:(r1'=3+1);
  [r1dot2l7Retry] r1=4 & r1retry_t2l7 < r1_maxRetry_t2l7 -> p_r1_t2l7 : (r1'=r1+1) + (1-p_r1_t2l7) : (r1'=r1) & (r1retry_t2l7' = r1retry_t2l7+1);
  [r1dot2l7] r1=4 & r1retry_t2l7 >= r1_maxRetry_t2l7 -> 1:(r1'=r1Fail);
  [r1movel8] r1=5-> 1:(r1'=5+1);
  [r1dot3l8Retry] r1=6 & r1retry_t3l8 < r1_maxRetry_t3l8 -> p_r1_t3l8 : (r1'=r1+1) + (1-p_r1_t3l8) : (r1'=r1) & (r1retry_t3l8' = r1retry_t3l8+1);
  [r1dot3l8] r1=6 & r1retry_t3l8 >= r1_maxRetry_t3l8 -> 1:(r1'=r1Fail);
  [r1movel5] r1=7-> 1:(r1'=7+1);
  [r1dot2l5Retry] r1=8 & r1retry_t2l5 < r1_maxRetry_t2l5 -> p_r1_t2l5 : (r1'=r1+1) + (1-p_r1_t2l5) : (r1'=r1) & (r1retry_t2l5' = r1retry_t2l5+1);
  [r1dot2l5] r1=8 & r1retry_t2l5 >= r1_maxRetry_t2l5 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..11];
  r2retry_t3l3a : [0..r2_maxRetry_t3l3a] init 0;
  r2retry_t3l3b : [0..r2_maxRetry_t3l3b] init 0;
  r2retry_t2l3 : [0..r2_maxRetry_t2l3] init 0;
  r2retry_t3l6 : [0..r2_maxRetry_t3l6] init 0;
  r2retry_t3l9 : [0..r2_maxRetry_t3l9] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2movel3] r2=1-> 1:(r2'=1+1);
  [r2dot3l3aRetry] r2=2 & r2retry_t3l3a < r2_maxRetry_t3l3a -> p_r2_t3l3a : (r2'=r2+1) + (1-p_r2_t3l3a) : (r2'=r2) & (r2retry_t3l3a' = r2retry_t3l3a+1);
  [r2dot3l3a] r2=2 & r2retry_t3l3a >= r2_maxRetry_t3l3a -> 1:(r2'=r2Fail);
  [r2dot3l3bRetry] r2=3 & r2retry_t3l3b < r2_maxRetry_t3l3b -> p_r2_t3l3b : (r2'=r2+1) + (1-p_r2_t3l3b) : (r2'=r2) & (r2retry_t3l3b' = r2retry_t3l3b+1);
  [r2dot3l3b] r2=3 & r2retry_t3l3b >= r2_maxRetry_t3l3b -> 1:(r2'=r2Fail);
  [r2dot2l3Retry] r2=4 & r2retry_t2l3 < r2_maxRetry_t2l3 -> p_r2_t2l3 : (r2'=r2+1) + (1-p_r2_t2l3) : (r2'=r2) & (r2retry_t2l3' = r2retry_t2l3+1);
  [r2dot2l3] r2=4 & r2retry_t2l3 >= r2_maxRetry_t2l3 -> 1:(r2'=r2Fail);
  [r2movel6] r2=5-> 1:(r2'=5+1);
  [r2dot3l6Retry] r2=6 & r2retry_t3l6 < r2_maxRetry_t3l6 -> p_r2_t3l6 : (r2'=r2+1) + (1-p_r2_t3l6) : (r2'=r2) & (r2retry_t3l6' = r2retry_t3l6+1);
  [r2dot3l6] r2=6 & r2retry_t3l6 >= r2_maxRetry_t3l6 -> 1:(r2'=r2Fail);
  [r2movel9] r2=7-> 1:(r2'=7+1);
  [r2dot3l9Retry] r2=8 & r2retry_t3l9 < r2_maxRetry_t3l9 -> p_r2_t3l9 : (r2'=r2+1) + (1-p_r2_t3l9) : (r2'=r2) & (r2retry_t3l9' = r2retry_t3l9+1);
  [r2dot3l9] r2=8 & r2retry_t3l9 >= r2_maxRetry_t3l9 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..3];
  worker1retry_t1l1 : [0..worker1_maxRetry_t1l1] init 0;

  [worker1dot1l1Retry] worker1=0 & worker1retry_t1l1 < worker1_maxRetry_t1l1 -> p_worker1_t1l1 : (worker1'=worker1+1) + (1-p_worker1_t1l1) : (worker1'=worker1) & (worker1retry_t1l1' = worker1retry_t1l1+1);
  [worker1dot1l1] worker1=0 & worker1retry_t1l1 >= worker1_maxRetry_t1l1 -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [worker2movel2] true:1;
  [worker2dot3l2] true:5;
  [worker2dot3l2Retry] true:5;
  [worker2movel3] true:1;
  [worker2dot1l3] true:3;
  [worker2dot1l3Retry] true:3;
  [r1movel4] true:1;
  [r1dot3l4b] true:1;
  [r1dot3l4bRetry] true:1;
  [r1dot3l4a] true:1;
  [r1dot3l4aRetry] true:1;
  [r1movel7] true:1;
  [r1dot2l7] true:1;
  [r1dot2l7Retry] true:1;
  [r1movel8] true:1;
  [r1dot3l8] true:1;
  [r1dot3l8Retry] true:1;
  [r1movel5] true:1;
  [r1dot2l5] true:1;
  [r1dot2l5Retry] true:1;
  [r2movel2] true:1;
  [r2movel3] true:1;
  [r2dot3l3a] true:1;
  [r2dot3l3aRetry] true:1;
  [r2dot3l3b] true:1;
  [r2dot3l3bRetry] true:1;
  [r2dot2l3] true:1;
  [r2dot2l3Retry] true:1;
  [r2movel6] true:1;
  [r2dot3l6] true:1;
  [r2dot3l6Retry] true:1;
  [r2movel9] true:1;
  [r2dot3l9] true:1;
  [r2dot3l9Retry] true:1;
  [worker1dot1l1] true:3;
  [worker1dot1l1Retry] true:3;
endrewards