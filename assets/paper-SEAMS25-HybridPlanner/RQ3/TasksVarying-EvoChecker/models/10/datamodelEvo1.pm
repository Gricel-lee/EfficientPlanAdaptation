dtmc
evolve int worker1_maxRetry_t1l4 [1..5];
evolve int worker1_maxRetry_t3l5 [1..5];
evolve int worker1_maxRetry_t3l6 [1..5];
evolve int worker1_maxRetry_t1l6 [1..5];
evolve int worker1_maxRetry_t3l3 [1..5];
evolve int worker2_maxRetry_t1l1 [1..5];
evolve int r2_maxRetry_t2l7 [1..10];
evolve int r2_maxRetry_t2l8 [1..10];
evolve int r2_maxRetry_t2l9b [1..10];
evolve int r2_maxRetry_t2l9a [1..10];

const double p_worker1_t1l4=1.0;
const double p_worker1_t3l5=0.99;
const double p_worker1_t3l6=0.99;
const double p_worker1_t1l6=1.0;
const double p_worker1_t3l3=0.99;
const double p_worker2_t1l1=1.0;
const double p_r2_t2l7=0.99;
const double p_r2_t2l8=0.99;
const double p_r2_t2l9b=0.99;
const double p_r2_t2l9a=0.99;
const int worker1Final = 9;
const int worker1Fail = 10;
const int worker2Final = 1;
const int worker2Fail = 2;
const int r2Final = 8;
const int r2Fail = 9;

module _worker1
  worker1 : [0..11];
  worker1retry_t1l4 : [0..worker1_maxRetry_t1l4] init 0;
  worker1retry_t3l5 : [0..worker1_maxRetry_t3l5] init 0;
  worker1retry_t3l6 : [0..worker1_maxRetry_t3l6] init 0;
  worker1retry_t1l6 : [0..worker1_maxRetry_t1l6] init 0;
  worker1retry_t3l3 : [0..worker1_maxRetry_t3l3] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l4Retry] worker1=1 & worker1retry_t1l4 < worker1_maxRetry_t1l4 -> p_worker1_t1l4 : (worker1'=worker1+1) + (1-p_worker1_t1l4) : (worker1'=worker1) & (worker1retry_t1l4' = worker1retry_t1l4+1);
  [worker1dot1l4] worker1=1 & worker1retry_t1l4 >= worker1_maxRetry_t1l4 -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=2-> 1:(worker1'=2+1);
  [worker1dot3l5Retry] worker1=3 & worker1retry_t3l5 < worker1_maxRetry_t3l5 -> p_worker1_t3l5 : (worker1'=worker1+1) + (1-p_worker1_t3l5) : (worker1'=worker1) & (worker1retry_t3l5' = worker1retry_t3l5+1);
  [worker1dot3l5] worker1=3 & worker1retry_t3l5 >= worker1_maxRetry_t3l5 -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=4-> 1:(worker1'=4+1);
  [worker1dot3l6Retry] worker1=5 & worker1retry_t3l6 < worker1_maxRetry_t3l6 -> p_worker1_t3l6 : (worker1'=worker1+1) + (1-p_worker1_t3l6) : (worker1'=worker1) & (worker1retry_t3l6' = worker1retry_t3l6+1);
  [worker1dot3l6] worker1=5 & worker1retry_t3l6 >= worker1_maxRetry_t3l6 -> 1:(worker1'=worker1Fail);
  [worker1dot1l6Retry] worker1=6 & worker1retry_t1l6 < worker1_maxRetry_t1l6 -> p_worker1_t1l6 : (worker1'=worker1+1) + (1-p_worker1_t1l6) : (worker1'=worker1) & (worker1retry_t1l6' = worker1retry_t1l6+1);
  [worker1dot1l6] worker1=6 & worker1retry_t1l6 >= worker1_maxRetry_t1l6 -> 1:(worker1'=worker1Fail);
  [worker1movel3] worker1=7-> 1:(worker1'=7+1);
  [worker1dot3l3Retry] worker1=8 & worker1retry_t3l3 < worker1_maxRetry_t3l3 -> p_worker1_t3l3 : (worker1'=worker1+1) + (1-p_worker1_t3l3) : (worker1'=worker1) & (worker1retry_t3l3' = worker1retry_t3l3+1);
  [worker1dot3l3] worker1=8 & worker1retry_t3l3 >= worker1_maxRetry_t3l3 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..3];
  worker2retry_t1l1 : [0..worker2_maxRetry_t1l1] init 0;

  [worker2dot1l1Retry] worker2=0 & worker2retry_t1l1 < worker2_maxRetry_t1l1 -> p_worker2_t1l1 : (worker2'=worker2+1) + (1-p_worker2_t1l1) : (worker2'=worker2) & (worker2retry_t1l1' = worker2retry_t1l1+1);
  [worker2dot1l1] worker2=0 & worker2retry_t1l1 >= worker2_maxRetry_t1l1 -> 1:(worker2'=worker2Fail);
endmodule

module _r2
  r2 : [0..10];
  r2retry_t2l7 : [0..r2_maxRetry_t2l7] init 0;
  r2retry_t2l8 : [0..r2_maxRetry_t2l8] init 0;
  r2retry_t2l9b : [0..r2_maxRetry_t2l9b] init 0;
  r2retry_t2l9a : [0..r2_maxRetry_t2l9a] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2movel7] r2=1-> 1:(r2'=1+1);
  [r2dot2l7Retry] r2=2 & r2retry_t2l7 < r2_maxRetry_t2l7 -> p_r2_t2l7 : (r2'=r2+1) + (1-p_r2_t2l7) : (r2'=r2) & (r2retry_t2l7' = r2retry_t2l7+1);
  [r2dot2l7] r2=2 & r2retry_t2l7 >= r2_maxRetry_t2l7 -> 1:(r2'=r2Fail);
  [r2movel8] r2=3-> 1:(r2'=3+1);
  [r2dot2l8Retry] r2=4 & r2retry_t2l8 < r2_maxRetry_t2l8 -> p_r2_t2l8 : (r2'=r2+1) + (1-p_r2_t2l8) : (r2'=r2) & (r2retry_t2l8' = r2retry_t2l8+1);
  [r2dot2l8] r2=4 & r2retry_t2l8 >= r2_maxRetry_t2l8 -> 1:(r2'=r2Fail);
  [r2movel9] r2=5-> 1:(r2'=5+1);
  [r2dot2l9bRetry] r2=6 & r2retry_t2l9b < r2_maxRetry_t2l9b -> p_r2_t2l9b : (r2'=r2+1) + (1-p_r2_t2l9b) : (r2'=r2) & (r2retry_t2l9b' = r2retry_t2l9b+1);
  [r2dot2l9b] r2=6 & r2retry_t2l9b >= r2_maxRetry_t2l9b -> 1:(r2'=r2Fail);
  [r2dot2l9aRetry] r2=7 & r2retry_t2l9a < r2_maxRetry_t2l9a -> p_r2_t2l9a : (r2'=r2+1) + (1-p_r2_t2l9a) : (r2'=r2) & (r2retry_t2l9a' = r2retry_t2l9a+1);
  [r2dot2l9a] r2=7 & r2retry_t2l9a >= r2_maxRetry_t2l9a -> 1:(r2'=r2Fail);
endmodule

rewards "cost"
  [worker1movel4] true:1;
  [worker1dot1l4] true:3;
  [worker1dot1l4Retry] true:3;
  [worker1movel5] true:1;
  [worker1dot3l5] true:5;
  [worker1dot3l5Retry] true:5;
  [worker1movel6] true:1;
  [worker1dot3l6] true:5;
  [worker1dot3l6Retry] true:5;
  [worker1dot1l6] true:3;
  [worker1dot1l6Retry] true:3;
  [worker1movel3] true:1;
  [worker1dot3l3] true:5;
  [worker1dot3l3Retry] true:5;
  [worker2dot1l1] true:3;
  [worker2dot1l1Retry] true:3;
  [r2movel4] true:1;
  [r2movel7] true:1;
  [r2dot2l7] true:1;
  [r2dot2l7Retry] true:1;
  [r2movel8] true:1;
  [r2dot2l8] true:1;
  [r2dot2l8Retry] true:1;
  [r2movel9] true:1;
  [r2dot2l9b] true:1;
  [r2dot2l9bRetry] true:1;
  [r2dot2l9a] true:1;
  [r2dot2l9aRetry] true:1;
endrewards