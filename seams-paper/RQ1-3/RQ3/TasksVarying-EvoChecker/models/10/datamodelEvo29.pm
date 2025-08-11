dtmc
evolve int worker1_maxRetry_t1l3 [1..5];
evolve int worker2_maxRetry_t1l4b [1..5];
evolve int worker2_maxRetry_t1l4a [1..5];
evolve int worker2_maxRetry_t1l5 [1..5];
evolve int worker2_maxRetry_t1l8a [1..5];
evolve int worker2_maxRetry_t1l8b [1..5];
evolve int r1_maxRetry_t2l3 [1..10];
evolve int r1_maxRetry_t3l6 [1..10];
evolve int r1_maxRetry_t2l6 [1..10];
evolve int r1_maxRetry_t2l9 [1..10];

const double p_worker1_t1l3=1.0;
const double p_worker2_t1l4b=1.0;
const double p_worker2_t1l4a=1.0;
const double p_worker2_t1l5=1.0;
const double p_worker2_t1l8a=1.0;
const double p_worker2_t1l8b=1.0;
const double p_r1_t2l3=0.99;
const double p_r1_t3l6=0.97;
const double p_r1_t2l6=0.99;
const double p_r1_t2l9=0.99;
const int worker1Final = 3;
const int worker1Fail = 4;
const int worker2Final = 8;
const int worker2Fail = 9;
const int r1Final = 8;
const int r1Fail = 9;

module _worker1
  worker1 : [0..5];
  worker1retry_t1l3 : [0..worker1_maxRetry_t1l3] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1movel3] worker1=1-> 1:(worker1'=1+1);
  [worker1dot1l3Retry] worker1=2 & worker1retry_t1l3 < worker1_maxRetry_t1l3 -> p_worker1_t1l3 : (worker1'=worker1+1) + (1-p_worker1_t1l3) : (worker1'=worker1) & (worker1retry_t1l3' = worker1retry_t1l3+1);
  [worker1dot1l3] worker1=2 & worker1retry_t1l3 >= worker1_maxRetry_t1l3 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..10];
  worker2retry_t1l4b : [0..worker2_maxRetry_t1l4b] init 0;
  worker2retry_t1l4a : [0..worker2_maxRetry_t1l4a] init 0;
  worker2retry_t1l5 : [0..worker2_maxRetry_t1l5] init 0;
  worker2retry_t1l8a : [0..worker2_maxRetry_t1l8a] init 0;
  worker2retry_t1l8b : [0..worker2_maxRetry_t1l8b] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l4bRetry] worker2=1 & worker2retry_t1l4b < worker2_maxRetry_t1l4b -> p_worker2_t1l4b : (worker2'=worker2+1) + (1-p_worker2_t1l4b) : (worker2'=worker2) & (worker2retry_t1l4b' = worker2retry_t1l4b+1);
  [worker2dot1l4b] worker2=1 & worker2retry_t1l4b >= worker2_maxRetry_t1l4b -> 1:(worker2'=worker2Fail);
  [worker2dot1l4aRetry] worker2=2 & worker2retry_t1l4a < worker2_maxRetry_t1l4a -> p_worker2_t1l4a : (worker2'=worker2+1) + (1-p_worker2_t1l4a) : (worker2'=worker2) & (worker2retry_t1l4a' = worker2retry_t1l4a+1);
  [worker2dot1l4a] worker2=2 & worker2retry_t1l4a >= worker2_maxRetry_t1l4a -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=3-> 1:(worker2'=3+1);
  [worker2dot1l5Retry] worker2=4 & worker2retry_t1l5 < worker2_maxRetry_t1l5 -> p_worker2_t1l5 : (worker2'=worker2+1) + (1-p_worker2_t1l5) : (worker2'=worker2) & (worker2retry_t1l5' = worker2retry_t1l5+1);
  [worker2dot1l5] worker2=4 & worker2retry_t1l5 >= worker2_maxRetry_t1l5 -> 1:(worker2'=worker2Fail);
  [worker2movel8] worker2=5-> 1:(worker2'=5+1);
  [worker2dot1l8aRetry] worker2=6 & worker2retry_t1l8a < worker2_maxRetry_t1l8a -> p_worker2_t1l8a : (worker2'=worker2+1) + (1-p_worker2_t1l8a) : (worker2'=worker2) & (worker2retry_t1l8a' = worker2retry_t1l8a+1);
  [worker2dot1l8a] worker2=6 & worker2retry_t1l8a >= worker2_maxRetry_t1l8a -> 1:(worker2'=worker2Fail);
  [worker2dot1l8bRetry] worker2=7 & worker2retry_t1l8b < worker2_maxRetry_t1l8b -> p_worker2_t1l8b : (worker2'=worker2+1) + (1-p_worker2_t1l8b) : (worker2'=worker2) & (worker2retry_t1l8b' = worker2retry_t1l8b+1);
  [worker2dot1l8b] worker2=7 & worker2retry_t1l8b >= worker2_maxRetry_t1l8b -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..10];
  r1retry_t2l3 : [0..r1_maxRetry_t2l3] init 0;
  r1retry_t3l6 : [0..r1_maxRetry_t3l6] init 0;
  r1retry_t2l6 : [0..r1_maxRetry_t2l6] init 0;
  r1retry_t2l9 : [0..r1_maxRetry_t2l9] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1movel3] r1=1-> 1:(r1'=1+1);
  [r1dot2l3Retry] r1=2 & r1retry_t2l3 < r1_maxRetry_t2l3 -> p_r1_t2l3 : (r1'=r1+1) + (1-p_r1_t2l3) : (r1'=r1) & (r1retry_t2l3' = r1retry_t2l3+1);
  [r1dot2l3] r1=2 & r1retry_t2l3 >= r1_maxRetry_t2l3 -> 1:(r1'=r1Fail);
  [r1movel6] r1=3-> 1:(r1'=3+1);
  [r1dot3l6Retry] r1=4 & r1retry_t3l6 < r1_maxRetry_t3l6 -> p_r1_t3l6 : (r1'=r1+1) + (1-p_r1_t3l6) : (r1'=r1) & (r1retry_t3l6' = r1retry_t3l6+1);
  [r1dot3l6] r1=4 & r1retry_t3l6 >= r1_maxRetry_t3l6 -> 1:(r1'=r1Fail);
  [r1dot2l6Retry] r1=5 & r1retry_t2l6 < r1_maxRetry_t2l6 -> p_r1_t2l6 : (r1'=r1+1) + (1-p_r1_t2l6) : (r1'=r1) & (r1retry_t2l6' = r1retry_t2l6+1);
  [r1dot2l6] r1=5 & r1retry_t2l6 >= r1_maxRetry_t2l6 -> 1:(r1'=r1Fail);
  [r1movel9] r1=6-> 1:(r1'=6+1);
  [r1dot2l9Retry] r1=7 & r1retry_t2l9 < r1_maxRetry_t2l9 -> p_r1_t2l9 : (r1'=r1+1) + (1-p_r1_t2l9) : (r1'=r1) & (r1retry_t2l9' = r1retry_t2l9+1);
  [r1dot2l9] r1=7 & r1retry_t2l9 >= r1_maxRetry_t2l9 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [worker1movel2] true:1;
  [worker1movel3] true:1;
  [worker1dot1l3] true:3;
  [worker1dot1l3Retry] true:3;
  [worker2movel4] true:1;
  [worker2dot1l4b] true:3;
  [worker2dot1l4bRetry] true:3;
  [worker2dot1l4a] true:3;
  [worker2dot1l4aRetry] true:3;
  [worker2movel5] true:1;
  [worker2dot1l5] true:3;
  [worker2dot1l5Retry] true:3;
  [worker2movel8] true:1;
  [worker2dot1l8a] true:3;
  [worker2dot1l8aRetry] true:3;
  [worker2dot1l8b] true:3;
  [worker2dot1l8bRetry] true:3;
  [r1movel2] true:1;
  [r1movel3] true:1;
  [r1dot2l3] true:1;
  [r1dot2l3Retry] true:1;
  [r1movel6] true:1;
  [r1dot3l6] true:1;
  [r1dot3l6Retry] true:1;
  [r1dot2l6] true:1;
  [r1dot2l6Retry] true:1;
  [r1movel9] true:1;
  [r1dot2l9] true:1;
  [r1dot2l9Retry] true:1;
endrewards