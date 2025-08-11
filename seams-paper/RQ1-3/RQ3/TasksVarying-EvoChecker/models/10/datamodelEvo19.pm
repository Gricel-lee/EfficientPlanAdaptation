dtmc
evolve int worker2_maxRetry_t1l7 [1..5];
evolve int worker2_maxRetry_t1l8 [1..5];
evolve int worker2_maxRetry_t3l8 [1..5];
evolve int worker2_maxRetry_t1l5 [1..5];
evolve int r1_maxRetry_t2l4b [1..10];
evolve int r1_maxRetry_t2l4a [1..10];
evolve int r1_maxRetry_t2l6 [1..10];
evolve int r1_maxRetry_t3l6 [1..10];
evolve int r1_maxRetry_t3l9 [1..10];
evolve int r2_maxRetry_t2l1 [1..10];

const double p_worker2_t1l7=1.0;
const double p_worker2_t1l8=1.0;
const double p_worker2_t3l8=0.99;
const double p_worker2_t1l5=1.0;
const double p_r1_t2l4b=0.99;
const double p_r1_t2l4a=0.99;
const double p_r1_t2l6=0.99;
const double p_r1_t3l6=0.97;
const double p_r1_t3l9=0.97;
const double p_r2_t2l1=0.99;
const int worker2Final = 8;
const int worker2Fail = 9;
const int r1Final = 9;
const int r1Fail = 10;
const int r2Final = 1;
const int r2Fail = 2;

module _worker2
  worker2 : [0..10];
  worker2retry_t1l7 : [0..worker2_maxRetry_t1l7] init 0;
  worker2retry_t1l8 : [0..worker2_maxRetry_t1l8] init 0;
  worker2retry_t3l8 : [0..worker2_maxRetry_t3l8] init 0;
  worker2retry_t1l5 : [0..worker2_maxRetry_t1l5] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2movel7] worker2=1-> 1:(worker2'=1+1);
  [worker2dot1l7Retry] worker2=2 & worker2retry_t1l7 < worker2_maxRetry_t1l7 -> p_worker2_t1l7 : (worker2'=worker2+1) + (1-p_worker2_t1l7) : (worker2'=worker2) & (worker2retry_t1l7' = worker2retry_t1l7+1);
  [worker2dot1l7] worker2=2 & worker2retry_t1l7 >= worker2_maxRetry_t1l7 -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=3-> 1:(worker2'=3+1);
  [worker2dot1l8Retry] worker2=4 & worker2retry_t1l8 < worker2_maxRetry_t1l8 -> p_worker2_t1l8 : (worker2'=worker2+1) + (1-p_worker2_t1l8) : (worker2'=worker2) & (worker2retry_t1l8' = worker2retry_t1l8+1);
  [worker2dot1l8] worker2=4 & worker2retry_t1l8 >= worker2_maxRetry_t1l8 -> 1:(worker2'=worker2Fail);
  [worker2dot3l8Retry] worker2=5 & worker2retry_t3l8 < worker2_maxRetry_t3l8 -> p_worker2_t3l8 : (worker2'=worker2+1) + (1-p_worker2_t3l8) : (worker2'=worker2) & (worker2retry_t3l8' = worker2retry_t3l8+1);
  [worker2dot3l8] worker2=5 & worker2retry_t3l8 >= worker2_maxRetry_t3l8 -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=6-> 1:(worker2'=6+1);
  [worker2dot1l5Retry] worker2=7 & worker2retry_t1l5 < worker2_maxRetry_t1l5 -> p_worker2_t1l5 : (worker2'=worker2+1) + (1-p_worker2_t1l5) : (worker2'=worker2) & (worker2retry_t1l5' = worker2retry_t1l5+1);
  [worker2dot1l5] worker2=7 & worker2retry_t1l5 >= worker2_maxRetry_t1l5 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..11];
  r1retry_t2l4b : [0..r1_maxRetry_t2l4b] init 0;
  r1retry_t2l4a : [0..r1_maxRetry_t2l4a] init 0;
  r1retry_t2l6 : [0..r1_maxRetry_t2l6] init 0;
  r1retry_t3l6 : [0..r1_maxRetry_t3l6] init 0;
  r1retry_t3l9 : [0..r1_maxRetry_t3l9] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1dot2l4bRetry] r1=1 & r1retry_t2l4b < r1_maxRetry_t2l4b -> p_r1_t2l4b : (r1'=r1+1) + (1-p_r1_t2l4b) : (r1'=r1) & (r1retry_t2l4b' = r1retry_t2l4b+1);
  [r1dot2l4b] r1=1 & r1retry_t2l4b >= r1_maxRetry_t2l4b -> 1:(r1'=r1Fail);
  [r1dot2l4aRetry] r1=2 & r1retry_t2l4a < r1_maxRetry_t2l4a -> p_r1_t2l4a : (r1'=r1+1) + (1-p_r1_t2l4a) : (r1'=r1) & (r1retry_t2l4a' = r1retry_t2l4a+1);
  [r1dot2l4a] r1=2 & r1retry_t2l4a >= r1_maxRetry_t2l4a -> 1:(r1'=r1Fail);
  [r1movel5] r1=3-> 1:(r1'=3+1);
  [r1movel6] r1=4-> 1:(r1'=4+1);
  [r1dot2l6Retry] r1=5 & r1retry_t2l6 < r1_maxRetry_t2l6 -> p_r1_t2l6 : (r1'=r1+1) + (1-p_r1_t2l6) : (r1'=r1) & (r1retry_t2l6' = r1retry_t2l6+1);
  [r1dot2l6] r1=5 & r1retry_t2l6 >= r1_maxRetry_t2l6 -> 1:(r1'=r1Fail);
  [r1dot3l6Retry] r1=6 & r1retry_t3l6 < r1_maxRetry_t3l6 -> p_r1_t3l6 : (r1'=r1+1) + (1-p_r1_t3l6) : (r1'=r1) & (r1retry_t3l6' = r1retry_t3l6+1);
  [r1dot3l6] r1=6 & r1retry_t3l6 >= r1_maxRetry_t3l6 -> 1:(r1'=r1Fail);
  [r1movel9] r1=7-> 1:(r1'=7+1);
  [r1dot3l9Retry] r1=8 & r1retry_t3l9 < r1_maxRetry_t3l9 -> p_r1_t3l9 : (r1'=r1+1) + (1-p_r1_t3l9) : (r1'=r1) & (r1retry_t3l9' = r1retry_t3l9+1);
  [r1dot3l9] r1=8 & r1retry_t3l9 >= r1_maxRetry_t3l9 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..3];
  r2retry_t2l1 : [0..r2_maxRetry_t2l1] init 0;

  [r2dot2l1Retry] r2=0 & r2retry_t2l1 < r2_maxRetry_t2l1 -> p_r2_t2l1 : (r2'=r2+1) + (1-p_r2_t2l1) : (r2'=r2) & (r2retry_t2l1' = r2retry_t2l1+1);
  [r2dot2l1] r2=0 & r2retry_t2l1 >= r2_maxRetry_t2l1 -> 1:(r2'=r2Fail);
endmodule

rewards "cost"
  [worker2movel4] true:1;
  [worker2movel7] true:1;
  [worker2dot1l7] true:3;
  [worker2dot1l7Retry] true:3;
  [worker2movel8] true:1;
  [worker2dot1l8] true:3;
  [worker2dot1l8Retry] true:3;
  [worker2dot3l8] true:5;
  [worker2dot3l8Retry] true:5;
  [worker2movel5] true:1;
  [worker2dot1l5] true:3;
  [worker2dot1l5Retry] true:3;
  [r1movel4] true:1;
  [r1dot2l4b] true:1;
  [r1dot2l4bRetry] true:1;
  [r1dot2l4a] true:1;
  [r1dot2l4aRetry] true:1;
  [r1movel5] true:1;
  [r1movel6] true:1;
  [r1dot2l6] true:1;
  [r1dot2l6Retry] true:1;
  [r1dot3l6] true:1;
  [r1dot3l6Retry] true:1;
  [r1movel9] true:1;
  [r1dot3l9] true:1;
  [r1dot3l9Retry] true:1;
  [r2dot2l1] true:1;
  [r2dot2l1Retry] true:1;
endrewards