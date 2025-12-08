dtmc
evolve int r1_maxRetry_t3l7b [1..10];
evolve int r1_maxRetry_t2l7 [1..10];
evolve int r1_maxRetry_t3l7a [1..10];
evolve int r1_maxRetry_t2l8 [1..10];
evolve int r2_maxRetry_t2l3 [1..10];
evolve int worker1_maxRetry_t3l4 [1..5];
evolve int worker1_maxRetry_t1l7 [1..5];
evolve int worker2_maxRetry_t1l3 [1..5];
evolve int worker2_maxRetry_t3l3 [1..5];
evolve int worker2_maxRetry_t1l5 [1..5];
evolve int worker2_maxRetry_t1l9a [1..5];
evolve int worker2_maxRetry_t1l9b [1..5];

const double p_r1_t3l7b=0.97;
const double p_r1_t2l7=0.99;
const double p_r1_t3l7a=0.97;
const double p_r1_t2l8=0.99;
const double p_r2_t2l3=0.99;
const double p_worker1_t3l4=0.99;
const double p_worker1_t1l7=1.0;
const double p_worker2_t1l3=1.0;
const double p_worker2_t3l3=0.99;
const double p_worker2_t1l5=1.0;
const double p_worker2_t1l9a=1.0;
const double p_worker2_t1l9b=1.0;
const int r1Final = 7;
const int r1Fail = 8;
const int r2Final = 3;
const int r2Fail = 4;
const int worker1Final = 4;
const int worker1Fail = 5;
const int worker2Final = 11;
const int worker2Fail = 12;

module _r1
  r1 : [0..9];
  r1retry_t3l7b : [0..r1_maxRetry_t3l7b] init 0;
  r1retry_t2l7 : [0..r1_maxRetry_t2l7] init 0;
  r1retry_t3l7a : [0..r1_maxRetry_t3l7a] init 0;
  r1retry_t2l8 : [0..r1_maxRetry_t2l8] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1movel7] r1=1-> 1:(r1'=1+1);
  [r1dot3l7bRetry] r1=2 & r1retry_t3l7b < r1_maxRetry_t3l7b -> p_r1_t3l7b : (r1'=r1+1) + (1-p_r1_t3l7b) : (r1'=r1) & (r1retry_t3l7b' = r1retry_t3l7b+1);
  [r1dot3l7b] r1=2 & r1retry_t3l7b >= r1_maxRetry_t3l7b -> 1:(r1'=r1Fail);
  [r1dot2l7Retry] r1=3 & r1retry_t2l7 < r1_maxRetry_t2l7 -> p_r1_t2l7 : (r1'=r1+1) + (1-p_r1_t2l7) : (r1'=r1) & (r1retry_t2l7' = r1retry_t2l7+1);
  [r1dot2l7] r1=3 & r1retry_t2l7 >= r1_maxRetry_t2l7 -> 1:(r1'=r1Fail);
  [r1dot3l7aRetry] r1=4 & r1retry_t3l7a < r1_maxRetry_t3l7a -> p_r1_t3l7a : (r1'=r1+1) + (1-p_r1_t3l7a) : (r1'=r1) & (r1retry_t3l7a' = r1retry_t3l7a+1);
  [r1dot3l7a] r1=4 & r1retry_t3l7a >= r1_maxRetry_t3l7a -> 1:(r1'=r1Fail);
  [r1movel8] r1=5-> 1:(r1'=5+1);
  [r1dot2l8Retry] r1=6 & r1retry_t2l8 < r1_maxRetry_t2l8 -> p_r1_t2l8 : (r1'=r1+1) + (1-p_r1_t2l8) : (r1'=r1) & (r1retry_t2l8' = r1retry_t2l8+1);
  [r1dot2l8] r1=6 & r1retry_t2l8 >= r1_maxRetry_t2l8 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..5];
  r2retry_t2l3 : [0..r2_maxRetry_t2l3] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2movel3] r2=1-> 1:(r2'=1+1);
  [r2dot2l3Retry] r2=2 & r2retry_t2l3 < r2_maxRetry_t2l3 -> p_r2_t2l3 : (r2'=r2+1) + (1-p_r2_t2l3) : (r2'=r2) & (r2retry_t2l3' = r2retry_t2l3+1);
  [r2dot2l3] r2=2 & r2retry_t2l3 >= r2_maxRetry_t2l3 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..6];
  worker1retry_t3l4 : [0..worker1_maxRetry_t3l4] init 0;
  worker1retry_t1l7 : [0..worker1_maxRetry_t1l7] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot3l4Retry] worker1=1 & worker1retry_t3l4 < worker1_maxRetry_t3l4 -> p_worker1_t3l4 : (worker1'=worker1+1) + (1-p_worker1_t3l4) : (worker1'=worker1) & (worker1retry_t3l4' = worker1retry_t3l4+1);
  [worker1dot3l4] worker1=1 & worker1retry_t3l4 >= worker1_maxRetry_t3l4 -> 1:(worker1'=worker1Fail);
  [worker1movel7] worker1=2-> 1:(worker1'=2+1);
  [worker1dot1l7Retry] worker1=3 & worker1retry_t1l7 < worker1_maxRetry_t1l7 -> p_worker1_t1l7 : (worker1'=worker1+1) + (1-p_worker1_t1l7) : (worker1'=worker1) & (worker1retry_t1l7' = worker1retry_t1l7+1);
  [worker1dot1l7] worker1=3 & worker1retry_t1l7 >= worker1_maxRetry_t1l7 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..13];
  worker2retry_t1l3 : [0..worker2_maxRetry_t1l3] init 0;
  worker2retry_t3l3 : [0..worker2_maxRetry_t3l3] init 0;
  worker2retry_t1l5 : [0..worker2_maxRetry_t1l5] init 0;
  worker2retry_t1l9a : [0..worker2_maxRetry_t1l9a] init 0;
  worker2retry_t1l9b : [0..worker2_maxRetry_t1l9b] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2movel3] worker2=1-> 1:(worker2'=1+1);
  [worker2dot1l3Retry] worker2=2 & worker2retry_t1l3 < worker2_maxRetry_t1l3 -> p_worker2_t1l3 : (worker2'=worker2+1) + (1-p_worker2_t1l3) : (worker2'=worker2) & (worker2retry_t1l3' = worker2retry_t1l3+1);
  [worker2dot1l3] worker2=2 & worker2retry_t1l3 >= worker2_maxRetry_t1l3 -> 1:(worker2'=worker2Fail);
  [worker2dot3l3Retry] worker2=3 & worker2retry_t3l3 < worker2_maxRetry_t3l3 -> p_worker2_t3l3 : (worker2'=worker2+1) + (1-p_worker2_t3l3) : (worker2'=worker2) & (worker2retry_t3l3' = worker2retry_t3l3+1);
  [worker2dot3l3] worker2=3 & worker2retry_t3l3 >= worker2_maxRetry_t3l3 -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=4-> 1:(worker2'=4+1);
  [worker2movel5] worker2=5-> 1:(worker2'=5+1);
  [worker2dot1l5Retry] worker2=6 & worker2retry_t1l5 < worker2_maxRetry_t1l5 -> p_worker2_t1l5 : (worker2'=worker2+1) + (1-p_worker2_t1l5) : (worker2'=worker2) & (worker2retry_t1l5' = worker2retry_t1l5+1);
  [worker2dot1l5] worker2=6 & worker2retry_t1l5 >= worker2_maxRetry_t1l5 -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=7-> 1:(worker2'=7+1);
  [worker2movel9] worker2=8-> 1:(worker2'=8+1);
  [worker2dot1l9aRetry] worker2=9 & worker2retry_t1l9a < worker2_maxRetry_t1l9a -> p_worker2_t1l9a : (worker2'=worker2+1) + (1-p_worker2_t1l9a) : (worker2'=worker2) & (worker2retry_t1l9a' = worker2retry_t1l9a+1);
  [worker2dot1l9a] worker2=9 & worker2retry_t1l9a >= worker2_maxRetry_t1l9a -> 1:(worker2'=worker2Fail);
  [worker2dot1l9bRetry] worker2=10 & worker2retry_t1l9b < worker2_maxRetry_t1l9b -> p_worker2_t1l9b : (worker2'=worker2+1) + (1-p_worker2_t1l9b) : (worker2'=worker2) & (worker2retry_t1l9b' = worker2retry_t1l9b+1);
  [worker2dot1l9b] worker2=10 & worker2retry_t1l9b >= worker2_maxRetry_t1l9b -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r1movel4] true:1;
  [r1movel7] true:1;
  [r1dot3l7b] true:1;
  [r1dot3l7bRetry] true:1;
  [r1dot2l7] true:1;
  [r1dot2l7Retry] true:1;
  [r1dot3l7a] true:1;
  [r1dot3l7aRetry] true:1;
  [r1movel8] true:1;
  [r1dot2l8] true:1;
  [r1dot2l8Retry] true:1;
  [r2movel2] true:1;
  [r2movel3] true:1;
  [r2dot2l3] true:1;
  [r2dot2l3Retry] true:1;
  [worker1movel4] true:1;
  [worker1dot3l4] true:5;
  [worker1dot3l4Retry] true:5;
  [worker1movel7] true:1;
  [worker1dot1l7] true:3;
  [worker1dot1l7Retry] true:3;
  [worker2movel2] true:1;
  [worker2movel3] true:1;
  [worker2dot1l3] true:3;
  [worker2dot1l3Retry] true:3;
  [worker2dot3l3] true:5;
  [worker2dot3l3Retry] true:5;
  [worker2movel6] true:1;
  [worker2movel5] true:1;
  [worker2dot1l5] true:3;
  [worker2dot1l5Retry] true:3;
  [worker2movel6] true:1;
  [worker2movel9] true:1;
  [worker2dot1l9a] true:3;
  [worker2dot1l9aRetry] true:3;
  [worker2dot1l9b] true:3;
  [worker2dot1l9bRetry] true:3;
endrewards