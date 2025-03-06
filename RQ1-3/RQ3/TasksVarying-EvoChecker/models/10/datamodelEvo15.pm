dtmc
evolve int worker1_maxRetry_t3l1 [1..5];
evolve int worker2_maxRetry_t1l7 [1..5];
evolve int worker2_maxRetry_t3l7a [1..5];
evolve int worker2_maxRetry_t3l9 [1..5];
evolve int worker2_maxRetry_t1l6 [1..5];
evolve int r1_maxRetry_t3l5 [1..10];
evolve int r1_maxRetry_t2l6 [1..10];
evolve int r1_maxRetry_t2l3 [1..10];
evolve int r2_maxRetry_t2l7 [1..10];
evolve int r2_maxRetry_t3l7b [1..10];

const double p_worker1_t3l1=0.99;
const double p_worker2_t1l7=1.0;
const double p_worker2_t3l7a=0.99;
const double p_worker2_t3l9=0.99;
const double p_worker2_t1l6=1.0;
const double p_r1_t3l5=0.97;
const double p_r1_t2l6=0.99;
const double p_r1_t2l3=0.99;
const double p_r2_t2l7=0.99;
const double p_r2_t3l7b=0.97;
const int worker1Final = 1;
const int worker1Fail = 2;
const int worker2Final = 9;
const int worker2Fail = 10;
const int r1Final = 7;
const int r1Fail = 8;
const int r2Final = 4;
const int r2Fail = 5;

module _worker1
  worker1 : [0..3];
  worker1retry_t3l1 : [0..worker1_maxRetry_t3l1] init 0;

  [worker1dot3l1Retry] worker1=0 & worker1retry_t3l1 < worker1_maxRetry_t3l1 -> p_worker1_t3l1 : (worker1'=worker1+1) + (1-p_worker1_t3l1) : (worker1'=worker1) & (worker1retry_t3l1' = worker1retry_t3l1+1);
  [worker1dot3l1] worker1=0 & worker1retry_t3l1 >= worker1_maxRetry_t3l1 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..11];
  worker2retry_t1l7 : [0..worker2_maxRetry_t1l7] init 0;
  worker2retry_t3l7a : [0..worker2_maxRetry_t3l7a] init 0;
  worker2retry_t3l9 : [0..worker2_maxRetry_t3l9] init 0;
  worker2retry_t1l6 : [0..worker2_maxRetry_t1l6] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2movel7] worker2=1-> 1:(worker2'=1+1);
  [worker2dot1l7Retry] worker2=2 & worker2retry_t1l7 < worker2_maxRetry_t1l7 -> p_worker2_t1l7 : (worker2'=worker2+1) + (1-p_worker2_t1l7) : (worker2'=worker2) & (worker2retry_t1l7' = worker2retry_t1l7+1);
  [worker2dot1l7] worker2=2 & worker2retry_t1l7 >= worker2_maxRetry_t1l7 -> 1:(worker2'=worker2Fail);
  [worker2dot3l7aRetry] worker2=3 & worker2retry_t3l7a < worker2_maxRetry_t3l7a -> p_worker2_t3l7a : (worker2'=worker2+1) + (1-p_worker2_t3l7a) : (worker2'=worker2) & (worker2retry_t3l7a' = worker2retry_t3l7a+1);
  [worker2dot3l7a] worker2=3 & worker2retry_t3l7a >= worker2_maxRetry_t3l7a -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=4-> 1:(worker2'=4+1);
  [worker2movel9] worker2=5-> 1:(worker2'=5+1);
  [worker2dot3l9Retry] worker2=6 & worker2retry_t3l9 < worker2_maxRetry_t3l9 -> p_worker2_t3l9 : (worker2'=worker2+1) + (1-p_worker2_t3l9) : (worker2'=worker2) & (worker2retry_t3l9' = worker2retry_t3l9+1);
  [worker2dot3l9] worker2=6 & worker2retry_t3l9 >= worker2_maxRetry_t3l9 -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=7-> 1:(worker2'=7+1);
  [worker2dot1l6Retry] worker2=8 & worker2retry_t1l6 < worker2_maxRetry_t1l6 -> p_worker2_t1l6 : (worker2'=worker2+1) + (1-p_worker2_t1l6) : (worker2'=worker2) & (worker2retry_t1l6' = worker2retry_t1l6+1);
  [worker2dot1l6] worker2=8 & worker2retry_t1l6 >= worker2_maxRetry_t1l6 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..9];
  r1retry_t3l5 : [0..r1_maxRetry_t3l5] init 0;
  r1retry_t2l6 : [0..r1_maxRetry_t2l6] init 0;
  r1retry_t2l3 : [0..r1_maxRetry_t2l3] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1movel5] r1=1-> 1:(r1'=1+1);
  [r1dot3l5Retry] r1=2 & r1retry_t3l5 < r1_maxRetry_t3l5 -> p_r1_t3l5 : (r1'=r1+1) + (1-p_r1_t3l5) : (r1'=r1) & (r1retry_t3l5' = r1retry_t3l5+1);
  [r1dot3l5] r1=2 & r1retry_t3l5 >= r1_maxRetry_t3l5 -> 1:(r1'=r1Fail);
  [r1movel6] r1=3-> 1:(r1'=3+1);
  [r1dot2l6Retry] r1=4 & r1retry_t2l6 < r1_maxRetry_t2l6 -> p_r1_t2l6 : (r1'=r1+1) + (1-p_r1_t2l6) : (r1'=r1) & (r1retry_t2l6' = r1retry_t2l6+1);
  [r1dot2l6] r1=4 & r1retry_t2l6 >= r1_maxRetry_t2l6 -> 1:(r1'=r1Fail);
  [r1movel3] r1=5-> 1:(r1'=5+1);
  [r1dot2l3Retry] r1=6 & r1retry_t2l3 < r1_maxRetry_t2l3 -> p_r1_t2l3 : (r1'=r1+1) + (1-p_r1_t2l3) : (r1'=r1) & (r1retry_t2l3' = r1retry_t2l3+1);
  [r1dot2l3] r1=6 & r1retry_t2l3 >= r1_maxRetry_t2l3 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..6];
  r2retry_t2l7 : [0..r2_maxRetry_t2l7] init 0;
  r2retry_t3l7b : [0..r2_maxRetry_t3l7b] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2movel7] r2=1-> 1:(r2'=1+1);
  [r2dot2l7Retry] r2=2 & r2retry_t2l7 < r2_maxRetry_t2l7 -> p_r2_t2l7 : (r2'=r2+1) + (1-p_r2_t2l7) : (r2'=r2) & (r2retry_t2l7' = r2retry_t2l7+1);
  [r2dot2l7] r2=2 & r2retry_t2l7 >= r2_maxRetry_t2l7 -> 1:(r2'=r2Fail);
  [r2dot3l7bRetry] r2=3 & r2retry_t3l7b < r2_maxRetry_t3l7b -> p_r2_t3l7b : (r2'=r2+1) + (1-p_r2_t3l7b) : (r2'=r2) & (r2retry_t3l7b' = r2retry_t3l7b+1);
  [r2dot3l7b] r2=3 & r2retry_t3l7b >= r2_maxRetry_t3l7b -> 1:(r2'=r2Fail);
endmodule

rewards "cost"
  [worker1dot3l1] true:5;
  [worker1dot3l1Retry] true:5;
  [worker2movel4] true:1;
  [worker2movel7] true:1;
  [worker2dot1l7] true:3;
  [worker2dot1l7Retry] true:3;
  [worker2dot3l7a] true:5;
  [worker2dot3l7aRetry] true:5;
  [worker2movel8] true:1;
  [worker2movel9] true:1;
  [worker2dot3l9] true:5;
  [worker2dot3l9Retry] true:5;
  [worker2movel6] true:1;
  [worker2dot1l6] true:3;
  [worker2dot1l6Retry] true:3;
  [r1movel4] true:1;
  [r1movel5] true:1;
  [r1dot3l5] true:1;
  [r1dot3l5Retry] true:1;
  [r1movel6] true:1;
  [r1dot2l6] true:1;
  [r1dot2l6Retry] true:1;
  [r1movel3] true:1;
  [r1dot2l3] true:1;
  [r1dot2l3Retry] true:1;
  [r2movel4] true:1;
  [r2movel7] true:1;
  [r2dot2l7] true:1;
  [r2dot2l7Retry] true:1;
  [r2dot3l7b] true:1;
  [r2dot3l7bRetry] true:1;
endrewards