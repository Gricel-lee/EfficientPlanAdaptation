dtmc
evolve int r2_maxRetry_t3l1 [1..10];
evolve int worker1_maxRetry_t1l7b [1..5];
evolve int worker1_maxRetry_t1l7a [1..5];
evolve int worker2_maxRetry_t1l2 [1..5];
evolve int r1_maxRetry_t3l4a [1..10];
evolve int r1_maxRetry_t3l4b [1..10];
evolve int r1_maxRetry_t2l4 [1..10];
evolve int r1_maxRetry_t3l5 [1..10];
evolve int r1_maxRetry_t2l6 [1..10];
evolve int r1_maxRetry_t3l9 [1..10];
evolve int r1_maxRetry_t2l3 [1..10];

const double p_r2_t3l1=0.97;
const double p_worker1_t1l7b=1.0;
const double p_worker1_t1l7a=1.0;
const double p_worker2_t1l2=1.0;
const double p_r1_t3l4a=0.97;
const double p_r1_t3l4b=0.97;
const double p_r1_t2l4=0.99;
const double p_r1_t3l5=0.97;
const double p_r1_t2l6=0.99;
const double p_r1_t3l9=0.97;
const double p_r1_t2l3=0.99;
const int r2Final = 1;
const int r2Fail = 2;
const int worker1Final = 4;
const int worker1Fail = 5;
const int worker2Final = 2;
const int worker2Fail = 3;
const int r1Final = 13;
const int r1Fail = 14;

module _r2
  r2 : [0..3];
  r2retry_t3l1 : [0..r2_maxRetry_t3l1] init 0;

  [r2dot3l1Retry] r2=0 & r2retry_t3l1 < r2_maxRetry_t3l1 -> p_r2_t3l1 : (r2'=r2+1) + (1-p_r2_t3l1) : (r2'=r2) & (r2retry_t3l1' = r2retry_t3l1+1);
  [r2dot3l1] r2=0 & r2retry_t3l1 >= r2_maxRetry_t3l1 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..6];
  worker1retry_t1l7b : [0..worker1_maxRetry_t1l7b] init 0;
  worker1retry_t1l7a : [0..worker1_maxRetry_t1l7a] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1movel7] worker1=1-> 1:(worker1'=1+1);
  [worker1dot1l7bRetry] worker1=2 & worker1retry_t1l7b < worker1_maxRetry_t1l7b -> p_worker1_t1l7b : (worker1'=worker1+1) + (1-p_worker1_t1l7b) : (worker1'=worker1) & (worker1retry_t1l7b' = worker1retry_t1l7b+1);
  [worker1dot1l7b] worker1=2 & worker1retry_t1l7b >= worker1_maxRetry_t1l7b -> 1:(worker1'=worker1Fail);
  [worker1dot1l7aRetry] worker1=3 & worker1retry_t1l7a < worker1_maxRetry_t1l7a -> p_worker1_t1l7a : (worker1'=worker1+1) + (1-p_worker1_t1l7a) : (worker1'=worker1) & (worker1retry_t1l7a' = worker1retry_t1l7a+1);
  [worker1dot1l7a] worker1=3 & worker1retry_t1l7a >= worker1_maxRetry_t1l7a -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..4];
  worker2retry_t1l2 : [0..worker2_maxRetry_t1l2] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l2Retry] worker2=1 & worker2retry_t1l2 < worker2_maxRetry_t1l2 -> p_worker2_t1l2 : (worker2'=worker2+1) + (1-p_worker2_t1l2) : (worker2'=worker2) & (worker2retry_t1l2' = worker2retry_t1l2+1);
  [worker2dot1l2] worker2=1 & worker2retry_t1l2 >= worker2_maxRetry_t1l2 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..15];
  r1retry_t3l4a : [0..r1_maxRetry_t3l4a] init 0;
  r1retry_t3l4b : [0..r1_maxRetry_t3l4b] init 0;
  r1retry_t2l4 : [0..r1_maxRetry_t2l4] init 0;
  r1retry_t3l5 : [0..r1_maxRetry_t3l5] init 0;
  r1retry_t2l6 : [0..r1_maxRetry_t2l6] init 0;
  r1retry_t3l9 : [0..r1_maxRetry_t3l9] init 0;
  r1retry_t2l3 : [0..r1_maxRetry_t2l3] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1dot3l4aRetry] r1=1 & r1retry_t3l4a < r1_maxRetry_t3l4a -> p_r1_t3l4a : (r1'=r1+1) + (1-p_r1_t3l4a) : (r1'=r1) & (r1retry_t3l4a' = r1retry_t3l4a+1);
  [r1dot3l4a] r1=1 & r1retry_t3l4a >= r1_maxRetry_t3l4a -> 1:(r1'=r1Fail);
  [r1dot3l4bRetry] r1=2 & r1retry_t3l4b < r1_maxRetry_t3l4b -> p_r1_t3l4b : (r1'=r1+1) + (1-p_r1_t3l4b) : (r1'=r1) & (r1retry_t3l4b' = r1retry_t3l4b+1);
  [r1dot3l4b] r1=2 & r1retry_t3l4b >= r1_maxRetry_t3l4b -> 1:(r1'=r1Fail);
  [r1dot2l4Retry] r1=3 & r1retry_t2l4 < r1_maxRetry_t2l4 -> p_r1_t2l4 : (r1'=r1+1) + (1-p_r1_t2l4) : (r1'=r1) & (r1retry_t2l4' = r1retry_t2l4+1);
  [r1dot2l4] r1=3 & r1retry_t2l4 >= r1_maxRetry_t2l4 -> 1:(r1'=r1Fail);
  [r1movel5] r1=4-> 1:(r1'=4+1);
  [r1dot3l5Retry] r1=5 & r1retry_t3l5 < r1_maxRetry_t3l5 -> p_r1_t3l5 : (r1'=r1+1) + (1-p_r1_t3l5) : (r1'=r1) & (r1retry_t3l5' = r1retry_t3l5+1);
  [r1dot3l5] r1=5 & r1retry_t3l5 >= r1_maxRetry_t3l5 -> 1:(r1'=r1Fail);
  [r1movel6] r1=6-> 1:(r1'=6+1);
  [r1dot2l6Retry] r1=7 & r1retry_t2l6 < r1_maxRetry_t2l6 -> p_r1_t2l6 : (r1'=r1+1) + (1-p_r1_t2l6) : (r1'=r1) & (r1retry_t2l6' = r1retry_t2l6+1);
  [r1dot2l6] r1=7 & r1retry_t2l6 >= r1_maxRetry_t2l6 -> 1:(r1'=r1Fail);
  [r1movel9] r1=8-> 1:(r1'=8+1);
  [r1dot3l9Retry] r1=9 & r1retry_t3l9 < r1_maxRetry_t3l9 -> p_r1_t3l9 : (r1'=r1+1) + (1-p_r1_t3l9) : (r1'=r1) & (r1retry_t3l9' = r1retry_t3l9+1);
  [r1dot3l9] r1=9 & r1retry_t3l9 >= r1_maxRetry_t3l9 -> 1:(r1'=r1Fail);
  [r1movel6] r1=10-> 1:(r1'=10+1);
  [r1movel3] r1=11-> 1:(r1'=11+1);
  [r1dot2l3Retry] r1=12 & r1retry_t2l3 < r1_maxRetry_t2l3 -> p_r1_t2l3 : (r1'=r1+1) + (1-p_r1_t2l3) : (r1'=r1) & (r1retry_t2l3' = r1retry_t2l3+1);
  [r1dot2l3] r1=12 & r1retry_t2l3 >= r1_maxRetry_t2l3 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [r2dot3l1] true:1;
  [r2dot3l1Retry] true:1;
  [worker1movel4] true:1;
  [worker1movel7] true:1;
  [worker1dot1l7b] true:3;
  [worker1dot1l7bRetry] true:3;
  [worker1dot1l7a] true:3;
  [worker1dot1l7aRetry] true:3;
  [worker2movel2] true:1;
  [worker2dot1l2] true:3;
  [worker2dot1l2Retry] true:3;
  [r1movel4] true:1;
  [r1dot3l4a] true:1;
  [r1dot3l4aRetry] true:1;
  [r1dot3l4b] true:1;
  [r1dot3l4bRetry] true:1;
  [r1dot2l4] true:1;
  [r1dot2l4Retry] true:1;
  [r1movel5] true:1;
  [r1dot3l5] true:1;
  [r1dot3l5Retry] true:1;
  [r1movel6] true:1;
  [r1dot2l6] true:1;
  [r1dot2l6Retry] true:1;
  [r1movel9] true:1;
  [r1dot3l9] true:1;
  [r1dot3l9Retry] true:1;
  [r1movel6] true:1;
  [r1movel3] true:1;
  [r1dot2l3] true:1;
  [r1dot2l3Retry] true:1;
endrewards