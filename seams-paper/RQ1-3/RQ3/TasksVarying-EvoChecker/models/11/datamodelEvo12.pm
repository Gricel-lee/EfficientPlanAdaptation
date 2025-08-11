dtmc
evolve int r2_maxRetry_t3l5 [1..10];
evolve int r2_maxRetry_t2l8 [1..10];
evolve int r2_maxRetry_t3l8 [1..10];
evolve int r2_maxRetry_t2l6b [1..10];
evolve int r2_maxRetry_t2l6a [1..10];
evolve int worker1_maxRetry_t1l1 [1..5];
evolve int worker2_maxRetry_t3l3 [1..5];
evolve int worker2_maxRetry_t1l3 [1..5];
evolve int worker2_maxRetry_t1l6 [1..5];
evolve int worker2_maxRetry_t1l5 [1..5];
evolve int worker2_maxRetry_t1l8 [1..5];

const double p_r2_t3l5=0.97;
const double p_r2_t2l8=0.99;
const double p_r2_t3l8=0.97;
const double p_r2_t2l6b=0.99;
const double p_r2_t2l6a=0.99;
const double p_worker1_t1l1=1.0;
const double p_worker2_t3l3=0.99;
const double p_worker2_t1l3=1.0;
const double p_worker2_t1l6=1.0;
const double p_worker2_t1l5=1.0;
const double p_worker2_t1l8=1.0;
const int r2Final = 10;
const int r2Fail = 11;
const int worker1Final = 1;
const int worker1Fail = 2;
const int worker2Final = 10;
const int worker2Fail = 11;

module _r2
  r2 : [0..12];
  r2retry_t3l5 : [0..r2_maxRetry_t3l5] init 0;
  r2retry_t2l8 : [0..r2_maxRetry_t2l8] init 0;
  r2retry_t3l8 : [0..r2_maxRetry_t3l8] init 0;
  r2retry_t2l6b : [0..r2_maxRetry_t2l6b] init 0;
  r2retry_t2l6a : [0..r2_maxRetry_t2l6a] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2movel5] r2=1-> 1:(r2'=1+1);
  [r2dot3l5Retry] r2=2 & r2retry_t3l5 < r2_maxRetry_t3l5 -> p_r2_t3l5 : (r2'=r2+1) + (1-p_r2_t3l5) : (r2'=r2) & (r2retry_t3l5' = r2retry_t3l5+1);
  [r2dot3l5] r2=2 & r2retry_t3l5 >= r2_maxRetry_t3l5 -> 1:(r2'=r2Fail);
  [r2movel8] r2=3-> 1:(r2'=3+1);
  [r2dot2l8Retry] r2=4 & r2retry_t2l8 < r2_maxRetry_t2l8 -> p_r2_t2l8 : (r2'=r2+1) + (1-p_r2_t2l8) : (r2'=r2) & (r2retry_t2l8' = r2retry_t2l8+1);
  [r2dot2l8] r2=4 & r2retry_t2l8 >= r2_maxRetry_t2l8 -> 1:(r2'=r2Fail);
  [r2dot3l8Retry] r2=5 & r2retry_t3l8 < r2_maxRetry_t3l8 -> p_r2_t3l8 : (r2'=r2+1) + (1-p_r2_t3l8) : (r2'=r2) & (r2retry_t3l8' = r2retry_t3l8+1);
  [r2dot3l8] r2=5 & r2retry_t3l8 >= r2_maxRetry_t3l8 -> 1:(r2'=r2Fail);
  [r2movel9] r2=6-> 1:(r2'=6+1);
  [r2movel6] r2=7-> 1:(r2'=7+1);
  [r2dot2l6bRetry] r2=8 & r2retry_t2l6b < r2_maxRetry_t2l6b -> p_r2_t2l6b : (r2'=r2+1) + (1-p_r2_t2l6b) : (r2'=r2) & (r2retry_t2l6b' = r2retry_t2l6b+1);
  [r2dot2l6b] r2=8 & r2retry_t2l6b >= r2_maxRetry_t2l6b -> 1:(r2'=r2Fail);
  [r2dot2l6aRetry] r2=9 & r2retry_t2l6a < r2_maxRetry_t2l6a -> p_r2_t2l6a : (r2'=r2+1) + (1-p_r2_t2l6a) : (r2'=r2) & (r2retry_t2l6a' = r2retry_t2l6a+1);
  [r2dot2l6a] r2=9 & r2retry_t2l6a >= r2_maxRetry_t2l6a -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..3];
  worker1retry_t1l1 : [0..worker1_maxRetry_t1l1] init 0;

  [worker1dot1l1Retry] worker1=0 & worker1retry_t1l1 < worker1_maxRetry_t1l1 -> p_worker1_t1l1 : (worker1'=worker1+1) + (1-p_worker1_t1l1) : (worker1'=worker1) & (worker1retry_t1l1' = worker1retry_t1l1+1);
  [worker1dot1l1] worker1=0 & worker1retry_t1l1 >= worker1_maxRetry_t1l1 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..12];
  worker2retry_t3l3 : [0..worker2_maxRetry_t3l3] init 0;
  worker2retry_t1l3 : [0..worker2_maxRetry_t1l3] init 0;
  worker2retry_t1l6 : [0..worker2_maxRetry_t1l6] init 0;
  worker2retry_t1l5 : [0..worker2_maxRetry_t1l5] init 0;
  worker2retry_t1l8 : [0..worker2_maxRetry_t1l8] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2movel3] worker2=1-> 1:(worker2'=1+1);
  [worker2dot3l3Retry] worker2=2 & worker2retry_t3l3 < worker2_maxRetry_t3l3 -> p_worker2_t3l3 : (worker2'=worker2+1) + (1-p_worker2_t3l3) : (worker2'=worker2) & (worker2retry_t3l3' = worker2retry_t3l3+1);
  [worker2dot3l3] worker2=2 & worker2retry_t3l3 >= worker2_maxRetry_t3l3 -> 1:(worker2'=worker2Fail);
  [worker2dot1l3Retry] worker2=3 & worker2retry_t1l3 < worker2_maxRetry_t1l3 -> p_worker2_t1l3 : (worker2'=worker2+1) + (1-p_worker2_t1l3) : (worker2'=worker2) & (worker2retry_t1l3' = worker2retry_t1l3+1);
  [worker2dot1l3] worker2=3 & worker2retry_t1l3 >= worker2_maxRetry_t1l3 -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=4-> 1:(worker2'=4+1);
  [worker2dot1l6Retry] worker2=5 & worker2retry_t1l6 < worker2_maxRetry_t1l6 -> p_worker2_t1l6 : (worker2'=worker2+1) + (1-p_worker2_t1l6) : (worker2'=worker2) & (worker2retry_t1l6' = worker2retry_t1l6+1);
  [worker2dot1l6] worker2=5 & worker2retry_t1l6 >= worker2_maxRetry_t1l6 -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=6-> 1:(worker2'=6+1);
  [worker2dot1l5Retry] worker2=7 & worker2retry_t1l5 < worker2_maxRetry_t1l5 -> p_worker2_t1l5 : (worker2'=worker2+1) + (1-p_worker2_t1l5) : (worker2'=worker2) & (worker2retry_t1l5' = worker2retry_t1l5+1);
  [worker2dot1l5] worker2=7 & worker2retry_t1l5 >= worker2_maxRetry_t1l5 -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=8-> 1:(worker2'=8+1);
  [worker2dot1l8Retry] worker2=9 & worker2retry_t1l8 < worker2_maxRetry_t1l8 -> p_worker2_t1l8 : (worker2'=worker2+1) + (1-p_worker2_t1l8) : (worker2'=worker2) & (worker2retry_t1l8' = worker2retry_t1l8+1);
  [worker2dot1l8] worker2=9 & worker2retry_t1l8 >= worker2_maxRetry_t1l8 -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r2movel2] true:1;
  [r2movel5] true:1;
  [r2dot3l5] true:1;
  [r2dot3l5Retry] true:1;
  [r2movel8] true:1;
  [r2dot2l8] true:1;
  [r2dot2l8Retry] true:1;
  [r2dot3l8] true:1;
  [r2dot3l8Retry] true:1;
  [r2movel9] true:1;
  [r2movel6] true:1;
  [r2dot2l6b] true:1;
  [r2dot2l6bRetry] true:1;
  [r2dot2l6a] true:1;
  [r2dot2l6aRetry] true:1;
  [worker1dot1l1] true:3;
  [worker1dot1l1Retry] true:3;
  [worker2movel2] true:1;
  [worker2movel3] true:1;
  [worker2dot3l3] true:5;
  [worker2dot3l3Retry] true:5;
  [worker2dot1l3] true:3;
  [worker2dot1l3Retry] true:3;
  [worker2movel6] true:1;
  [worker2dot1l6] true:3;
  [worker2dot1l6Retry] true:3;
  [worker2movel5] true:1;
  [worker2dot1l5] true:3;
  [worker2dot1l5Retry] true:3;
  [worker2movel8] true:1;
  [worker2dot1l8] true:3;
  [worker2dot1l8Retry] true:3;
endrewards