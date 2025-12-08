dtmc
evolve int r2_maxRetry_t2l1 [1..10];
evolve int worker2_maxRetry_t1l4a [1..5];
evolve int worker2_maxRetry_t1l4b [1..5];
evolve int worker2_maxRetry_t1l5 [1..5];
evolve int worker2_maxRetry_t3l6b [1..5];
evolve int worker2_maxRetry_t3l6a [1..5];
evolve int worker2_maxRetry_t1l9 [1..5];
evolve int worker2_maxRetry_t3l7 [1..5];
evolve int r1_maxRetry_t2l5 [1..10];
evolve int r1_maxRetry_t2l6 [1..10];
evolve int r1_maxRetry_t3l3 [1..10];

const double p_r2_t2l1=0.99;
const double p_worker2_t1l4a=1.0;
const double p_worker2_t1l4b=1.0;
const double p_worker2_t1l5=1.0;
const double p_worker2_t3l6b=0.99;
const double p_worker2_t3l6a=0.99;
const double p_worker2_t1l9=1.0;
const double p_worker2_t3l7=0.99;
const double p_r1_t2l5=0.99;
const double p_r1_t2l6=0.99;
const double p_r1_t3l3=0.97;
const int r2Final = 1;
const int r2Fail = 2;
const int worker2Final = 13;
const int worker2Fail = 14;
const int r1Final = 7;
const int r1Fail = 8;

module _r2
  r2 : [0..3];
  r2retry_t2l1 : [0..r2_maxRetry_t2l1] init 0;

  [r2dot2l1Retry] r2=0 & r2retry_t2l1 < r2_maxRetry_t2l1 -> p_r2_t2l1 : (r2'=r2+1) + (1-p_r2_t2l1) : (r2'=r2) & (r2retry_t2l1' = r2retry_t2l1+1);
  [r2dot2l1] r2=0 & r2retry_t2l1 >= r2_maxRetry_t2l1 -> 1:(r2'=r2Fail);
endmodule

module _worker2
  worker2 : [0..15];
  worker2retry_t1l4a : [0..worker2_maxRetry_t1l4a] init 0;
  worker2retry_t1l4b : [0..worker2_maxRetry_t1l4b] init 0;
  worker2retry_t1l5 : [0..worker2_maxRetry_t1l5] init 0;
  worker2retry_t3l6b : [0..worker2_maxRetry_t3l6b] init 0;
  worker2retry_t3l6a : [0..worker2_maxRetry_t3l6a] init 0;
  worker2retry_t1l9 : [0..worker2_maxRetry_t1l9] init 0;
  worker2retry_t3l7 : [0..worker2_maxRetry_t3l7] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l4aRetry] worker2=1 & worker2retry_t1l4a < worker2_maxRetry_t1l4a -> p_worker2_t1l4a : (worker2'=worker2+1) + (1-p_worker2_t1l4a) : (worker2'=worker2) & (worker2retry_t1l4a' = worker2retry_t1l4a+1);
  [worker2dot1l4a] worker2=1 & worker2retry_t1l4a >= worker2_maxRetry_t1l4a -> 1:(worker2'=worker2Fail);
  [worker2dot1l4bRetry] worker2=2 & worker2retry_t1l4b < worker2_maxRetry_t1l4b -> p_worker2_t1l4b : (worker2'=worker2+1) + (1-p_worker2_t1l4b) : (worker2'=worker2) & (worker2retry_t1l4b' = worker2retry_t1l4b+1);
  [worker2dot1l4b] worker2=2 & worker2retry_t1l4b >= worker2_maxRetry_t1l4b -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=3-> 1:(worker2'=3+1);
  [worker2dot1l5Retry] worker2=4 & worker2retry_t1l5 < worker2_maxRetry_t1l5 -> p_worker2_t1l5 : (worker2'=worker2+1) + (1-p_worker2_t1l5) : (worker2'=worker2) & (worker2retry_t1l5' = worker2retry_t1l5+1);
  [worker2dot1l5] worker2=4 & worker2retry_t1l5 >= worker2_maxRetry_t1l5 -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=5-> 1:(worker2'=5+1);
  [worker2dot3l6bRetry] worker2=6 & worker2retry_t3l6b < worker2_maxRetry_t3l6b -> p_worker2_t3l6b : (worker2'=worker2+1) + (1-p_worker2_t3l6b) : (worker2'=worker2) & (worker2retry_t3l6b' = worker2retry_t3l6b+1);
  [worker2dot3l6b] worker2=6 & worker2retry_t3l6b >= worker2_maxRetry_t3l6b -> 1:(worker2'=worker2Fail);
  [worker2dot3l6aRetry] worker2=7 & worker2retry_t3l6a < worker2_maxRetry_t3l6a -> p_worker2_t3l6a : (worker2'=worker2+1) + (1-p_worker2_t3l6a) : (worker2'=worker2) & (worker2retry_t3l6a' = worker2retry_t3l6a+1);
  [worker2dot3l6a] worker2=7 & worker2retry_t3l6a >= worker2_maxRetry_t3l6a -> 1:(worker2'=worker2Fail);
  [worker2movel9] worker2=8-> 1:(worker2'=8+1);
  [worker2dot1l9Retry] worker2=9 & worker2retry_t1l9 < worker2_maxRetry_t1l9 -> p_worker2_t1l9 : (worker2'=worker2+1) + (1-p_worker2_t1l9) : (worker2'=worker2) & (worker2retry_t1l9' = worker2retry_t1l9+1);
  [worker2dot1l9] worker2=9 & worker2retry_t1l9 >= worker2_maxRetry_t1l9 -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=10-> 1:(worker2'=10+1);
  [worker2movel7] worker2=11-> 1:(worker2'=11+1);
  [worker2dot3l7Retry] worker2=12 & worker2retry_t3l7 < worker2_maxRetry_t3l7 -> p_worker2_t3l7 : (worker2'=worker2+1) + (1-p_worker2_t3l7) : (worker2'=worker2) & (worker2retry_t3l7' = worker2retry_t3l7+1);
  [worker2dot3l7] worker2=12 & worker2retry_t3l7 >= worker2_maxRetry_t3l7 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..9];
  r1retry_t2l5 : [0..r1_maxRetry_t2l5] init 0;
  r1retry_t2l6 : [0..r1_maxRetry_t2l6] init 0;
  r1retry_t3l3 : [0..r1_maxRetry_t3l3] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1movel5] r1=1-> 1:(r1'=1+1);
  [r1dot2l5Retry] r1=2 & r1retry_t2l5 < r1_maxRetry_t2l5 -> p_r1_t2l5 : (r1'=r1+1) + (1-p_r1_t2l5) : (r1'=r1) & (r1retry_t2l5' = r1retry_t2l5+1);
  [r1dot2l5] r1=2 & r1retry_t2l5 >= r1_maxRetry_t2l5 -> 1:(r1'=r1Fail);
  [r1movel6] r1=3-> 1:(r1'=3+1);
  [r1dot2l6Retry] r1=4 & r1retry_t2l6 < r1_maxRetry_t2l6 -> p_r1_t2l6 : (r1'=r1+1) + (1-p_r1_t2l6) : (r1'=r1) & (r1retry_t2l6' = r1retry_t2l6+1);
  [r1dot2l6] r1=4 & r1retry_t2l6 >= r1_maxRetry_t2l6 -> 1:(r1'=r1Fail);
  [r1movel3] r1=5-> 1:(r1'=5+1);
  [r1dot3l3Retry] r1=6 & r1retry_t3l3 < r1_maxRetry_t3l3 -> p_r1_t3l3 : (r1'=r1+1) + (1-p_r1_t3l3) : (r1'=r1) & (r1retry_t3l3' = r1retry_t3l3+1);
  [r1dot3l3] r1=6 & r1retry_t3l3 >= r1_maxRetry_t3l3 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [r2dot2l1] true:1;
  [r2dot2l1Retry] true:1;
  [worker2movel4] true:1;
  [worker2dot1l4a] true:3;
  [worker2dot1l4aRetry] true:3;
  [worker2dot1l4b] true:3;
  [worker2dot1l4bRetry] true:3;
  [worker2movel5] true:1;
  [worker2dot1l5] true:3;
  [worker2dot1l5Retry] true:3;
  [worker2movel6] true:1;
  [worker2dot3l6b] true:5;
  [worker2dot3l6bRetry] true:5;
  [worker2dot3l6a] true:5;
  [worker2dot3l6aRetry] true:5;
  [worker2movel9] true:1;
  [worker2dot1l9] true:3;
  [worker2dot1l9Retry] true:3;
  [worker2movel8] true:1;
  [worker2movel7] true:1;
  [worker2dot3l7] true:5;
  [worker2dot3l7Retry] true:5;
  [r1movel4] true:1;
  [r1movel5] true:1;
  [r1dot2l5] true:1;
  [r1dot2l5Retry] true:1;
  [r1movel6] true:1;
  [r1dot2l6] true:1;
  [r1dot2l6Retry] true:1;
  [r1movel3] true:1;
  [r1dot3l3] true:1;
  [r1dot3l3Retry] true:1;
endrewards