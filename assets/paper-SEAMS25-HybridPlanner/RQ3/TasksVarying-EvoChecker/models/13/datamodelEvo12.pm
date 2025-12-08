dtmc
evolve int worker2_maxRetry_t1l1b [1..5];
evolve int worker2_maxRetry_t1l1a [1..5];
evolve int r1_maxRetry_t2l3 [1..10];
evolve int r2_maxRetry_t2l1a [1..10];
evolve int r2_maxRetry_t2l1b [1..10];
evolve int worker1_maxRetry_t1l3 [1..5];
evolve int worker1_maxRetry_t3l9 [1..5];
evolve int worker1_maxRetry_t3l8 [1..5];
evolve int worker1_maxRetry_t1l8 [1..5];
evolve int worker1_maxRetry_t1l5 [1..5];
evolve int worker1_maxRetry_t3l5 [1..5];
evolve int worker1_maxRetry_t1l4a [1..5];
evolve int worker1_maxRetry_t1l4b [1..5];

const double p_worker2_t1l1b=1.0;
const double p_worker2_t1l1a=1.0;
const double p_r1_t2l3=0.99;
const double p_r2_t2l1a=0.99;
const double p_r2_t2l1b=0.99;
const double p_worker1_t1l3=1.0;
const double p_worker1_t3l9=0.99;
const double p_worker1_t3l8=0.99;
const double p_worker1_t1l8=1.0;
const double p_worker1_t1l5=1.0;
const double p_worker1_t3l5=0.99;
const double p_worker1_t1l4a=1.0;
const double p_worker1_t1l4b=1.0;
const int worker2Final = 2;
const int worker2Fail = 3;
const int r1Final = 3;
const int r1Fail = 4;
const int r2Final = 2;
const int r2Fail = 3;
const int worker1Final = 15;
const int worker1Fail = 16;

module _worker2
  worker2 : [0..4];
  worker2retry_t1l1b : [0..worker2_maxRetry_t1l1b] init 0;
  worker2retry_t1l1a : [0..worker2_maxRetry_t1l1a] init 0;

  [worker2dot1l1bRetry] worker2=0 & worker2retry_t1l1b < worker2_maxRetry_t1l1b -> p_worker2_t1l1b : (worker2'=worker2+1) + (1-p_worker2_t1l1b) : (worker2'=worker2) & (worker2retry_t1l1b' = worker2retry_t1l1b+1);
  [worker2dot1l1b] worker2=0 & worker2retry_t1l1b >= worker2_maxRetry_t1l1b -> 1:(worker2'=worker2Fail);
  [worker2dot1l1aRetry] worker2=1 & worker2retry_t1l1a < worker2_maxRetry_t1l1a -> p_worker2_t1l1a : (worker2'=worker2+1) + (1-p_worker2_t1l1a) : (worker2'=worker2) & (worker2retry_t1l1a' = worker2retry_t1l1a+1);
  [worker2dot1l1a] worker2=1 & worker2retry_t1l1a >= worker2_maxRetry_t1l1a -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..5];
  r1retry_t2l3 : [0..r1_maxRetry_t2l3] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1movel3] r1=1-> 1:(r1'=1+1);
  [r1dot2l3Retry] r1=2 & r1retry_t2l3 < r1_maxRetry_t2l3 -> p_r1_t2l3 : (r1'=r1+1) + (1-p_r1_t2l3) : (r1'=r1) & (r1retry_t2l3' = r1retry_t2l3+1);
  [r1dot2l3] r1=2 & r1retry_t2l3 >= r1_maxRetry_t2l3 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..4];
  r2retry_t2l1a : [0..r2_maxRetry_t2l1a] init 0;
  r2retry_t2l1b : [0..r2_maxRetry_t2l1b] init 0;

  [r2dot2l1aRetry] r2=0 & r2retry_t2l1a < r2_maxRetry_t2l1a -> p_r2_t2l1a : (r2'=r2+1) + (1-p_r2_t2l1a) : (r2'=r2) & (r2retry_t2l1a' = r2retry_t2l1a+1);
  [r2dot2l1a] r2=0 & r2retry_t2l1a >= r2_maxRetry_t2l1a -> 1:(r2'=r2Fail);
  [r2dot2l1bRetry] r2=1 & r2retry_t2l1b < r2_maxRetry_t2l1b -> p_r2_t2l1b : (r2'=r2+1) + (1-p_r2_t2l1b) : (r2'=r2) & (r2retry_t2l1b' = r2retry_t2l1b+1);
  [r2dot2l1b] r2=1 & r2retry_t2l1b >= r2_maxRetry_t2l1b -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..17];
  worker1retry_t1l3 : [0..worker1_maxRetry_t1l3] init 0;
  worker1retry_t3l9 : [0..worker1_maxRetry_t3l9] init 0;
  worker1retry_t3l8 : [0..worker1_maxRetry_t3l8] init 0;
  worker1retry_t1l8 : [0..worker1_maxRetry_t1l8] init 0;
  worker1retry_t1l5 : [0..worker1_maxRetry_t1l5] init 0;
  worker1retry_t3l5 : [0..worker1_maxRetry_t3l5] init 0;
  worker1retry_t1l4a : [0..worker1_maxRetry_t1l4a] init 0;
  worker1retry_t1l4b : [0..worker1_maxRetry_t1l4b] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1movel3] worker1=1-> 1:(worker1'=1+1);
  [worker1dot1l3Retry] worker1=2 & worker1retry_t1l3 < worker1_maxRetry_t1l3 -> p_worker1_t1l3 : (worker1'=worker1+1) + (1-p_worker1_t1l3) : (worker1'=worker1) & (worker1retry_t1l3' = worker1retry_t1l3+1);
  [worker1dot1l3] worker1=2 & worker1retry_t1l3 >= worker1_maxRetry_t1l3 -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=3-> 1:(worker1'=3+1);
  [worker1movel9] worker1=4-> 1:(worker1'=4+1);
  [worker1dot3l9Retry] worker1=5 & worker1retry_t3l9 < worker1_maxRetry_t3l9 -> p_worker1_t3l9 : (worker1'=worker1+1) + (1-p_worker1_t3l9) : (worker1'=worker1) & (worker1retry_t3l9' = worker1retry_t3l9+1);
  [worker1dot3l9] worker1=5 & worker1retry_t3l9 >= worker1_maxRetry_t3l9 -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=6-> 1:(worker1'=6+1);
  [worker1dot3l8Retry] worker1=7 & worker1retry_t3l8 < worker1_maxRetry_t3l8 -> p_worker1_t3l8 : (worker1'=worker1+1) + (1-p_worker1_t3l8) : (worker1'=worker1) & (worker1retry_t3l8' = worker1retry_t3l8+1);
  [worker1dot3l8] worker1=7 & worker1retry_t3l8 >= worker1_maxRetry_t3l8 -> 1:(worker1'=worker1Fail);
  [worker1dot1l8Retry] worker1=8 & worker1retry_t1l8 < worker1_maxRetry_t1l8 -> p_worker1_t1l8 : (worker1'=worker1+1) + (1-p_worker1_t1l8) : (worker1'=worker1) & (worker1retry_t1l8' = worker1retry_t1l8+1);
  [worker1dot1l8] worker1=8 & worker1retry_t1l8 >= worker1_maxRetry_t1l8 -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=9-> 1:(worker1'=9+1);
  [worker1dot1l5Retry] worker1=10 & worker1retry_t1l5 < worker1_maxRetry_t1l5 -> p_worker1_t1l5 : (worker1'=worker1+1) + (1-p_worker1_t1l5) : (worker1'=worker1) & (worker1retry_t1l5' = worker1retry_t1l5+1);
  [worker1dot1l5] worker1=10 & worker1retry_t1l5 >= worker1_maxRetry_t1l5 -> 1:(worker1'=worker1Fail);
  [worker1dot3l5Retry] worker1=11 & worker1retry_t3l5 < worker1_maxRetry_t3l5 -> p_worker1_t3l5 : (worker1'=worker1+1) + (1-p_worker1_t3l5) : (worker1'=worker1) & (worker1retry_t3l5' = worker1retry_t3l5+1);
  [worker1dot3l5] worker1=11 & worker1retry_t3l5 >= worker1_maxRetry_t3l5 -> 1:(worker1'=worker1Fail);
  [worker1movel4] worker1=12-> 1:(worker1'=12+1);
  [worker1dot1l4aRetry] worker1=13 & worker1retry_t1l4a < worker1_maxRetry_t1l4a -> p_worker1_t1l4a : (worker1'=worker1+1) + (1-p_worker1_t1l4a) : (worker1'=worker1) & (worker1retry_t1l4a' = worker1retry_t1l4a+1);
  [worker1dot1l4a] worker1=13 & worker1retry_t1l4a >= worker1_maxRetry_t1l4a -> 1:(worker1'=worker1Fail);
  [worker1dot1l4bRetry] worker1=14 & worker1retry_t1l4b < worker1_maxRetry_t1l4b -> p_worker1_t1l4b : (worker1'=worker1+1) + (1-p_worker1_t1l4b) : (worker1'=worker1) & (worker1retry_t1l4b' = worker1retry_t1l4b+1);
  [worker1dot1l4b] worker1=14 & worker1retry_t1l4b >= worker1_maxRetry_t1l4b -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [worker2dot1l1b] true:3;
  [worker2dot1l1bRetry] true:3;
  [worker2dot1l1a] true:3;
  [worker2dot1l1aRetry] true:3;
  [r1movel2] true:1;
  [r1movel3] true:1;
  [r1dot2l3] true:1;
  [r1dot2l3Retry] true:1;
  [r2dot2l1a] true:1;
  [r2dot2l1aRetry] true:1;
  [r2dot2l1b] true:1;
  [r2dot2l1bRetry] true:1;
  [worker1movel2] true:1;
  [worker1movel3] true:1;
  [worker1dot1l3] true:3;
  [worker1dot1l3Retry] true:3;
  [worker1movel6] true:1;
  [worker1movel9] true:1;
  [worker1dot3l9] true:5;
  [worker1dot3l9Retry] true:5;
  [worker1movel8] true:1;
  [worker1dot3l8] true:5;
  [worker1dot3l8Retry] true:5;
  [worker1dot1l8] true:3;
  [worker1dot1l8Retry] true:3;
  [worker1movel5] true:1;
  [worker1dot1l5] true:3;
  [worker1dot1l5Retry] true:3;
  [worker1dot3l5] true:5;
  [worker1dot3l5Retry] true:5;
  [worker1movel4] true:1;
  [worker1dot1l4a] true:3;
  [worker1dot1l4aRetry] true:3;
  [worker1dot1l4b] true:3;
  [worker1dot1l4bRetry] true:3;
endrewards