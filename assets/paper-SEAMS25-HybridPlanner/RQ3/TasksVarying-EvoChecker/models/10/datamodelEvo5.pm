dtmc
evolve int worker1_maxRetry_t3l2 [1..5];
evolve int worker1_maxRetry_t1l3 [1..5];
evolve int worker1_maxRetry_t1l6 [1..5];
evolve int worker1_maxRetry_t3l5 [1..5];
evolve int worker1_maxRetry_t1l8 [1..5];
evolve int worker1_maxRetry_t3l9 [1..5];
evolve int worker2_maxRetry_t3l1b [1..5];
evolve int r1_maxRetry_t2l3 [1..10];
evolve int r2_maxRetry_t3l1a [1..10];
evolve int r2_maxRetry_t2l4 [1..10];

const double p_worker1_t3l2=0.99;
const double p_worker1_t1l3=1.0;
const double p_worker1_t1l6=1.0;
const double p_worker1_t3l5=0.99;
const double p_worker1_t1l8=1.0;
const double p_worker1_t3l9=0.99;
const double p_worker2_t3l1b=0.99;
const double p_r1_t2l3=0.99;
const double p_r2_t3l1a=0.97;
const double p_r2_t2l4=0.99;
const int worker1Final = 12;
const int worker1Fail = 13;
const int worker2Final = 1;
const int worker2Fail = 2;
const int r1Final = 3;
const int r1Fail = 4;
const int r2Final = 3;
const int r2Fail = 4;

module _worker1
  worker1 : [0..14];
  worker1retry_t3l2 : [0..worker1_maxRetry_t3l2] init 0;
  worker1retry_t1l3 : [0..worker1_maxRetry_t1l3] init 0;
  worker1retry_t1l6 : [0..worker1_maxRetry_t1l6] init 0;
  worker1retry_t3l5 : [0..worker1_maxRetry_t3l5] init 0;
  worker1retry_t1l8 : [0..worker1_maxRetry_t1l8] init 0;
  worker1retry_t3l9 : [0..worker1_maxRetry_t3l9] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1dot3l2Retry] worker1=1 & worker1retry_t3l2 < worker1_maxRetry_t3l2 -> p_worker1_t3l2 : (worker1'=worker1+1) + (1-p_worker1_t3l2) : (worker1'=worker1) & (worker1retry_t3l2' = worker1retry_t3l2+1);
  [worker1dot3l2] worker1=1 & worker1retry_t3l2 >= worker1_maxRetry_t3l2 -> 1:(worker1'=worker1Fail);
  [worker1movel3] worker1=2-> 1:(worker1'=2+1);
  [worker1dot1l3Retry] worker1=3 & worker1retry_t1l3 < worker1_maxRetry_t1l3 -> p_worker1_t1l3 : (worker1'=worker1+1) + (1-p_worker1_t1l3) : (worker1'=worker1) & (worker1retry_t1l3' = worker1retry_t1l3+1);
  [worker1dot1l3] worker1=3 & worker1retry_t1l3 >= worker1_maxRetry_t1l3 -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=4-> 1:(worker1'=4+1);
  [worker1dot1l6Retry] worker1=5 & worker1retry_t1l6 < worker1_maxRetry_t1l6 -> p_worker1_t1l6 : (worker1'=worker1+1) + (1-p_worker1_t1l6) : (worker1'=worker1) & (worker1retry_t1l6' = worker1retry_t1l6+1);
  [worker1dot1l6] worker1=5 & worker1retry_t1l6 >= worker1_maxRetry_t1l6 -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=6-> 1:(worker1'=6+1);
  [worker1dot3l5Retry] worker1=7 & worker1retry_t3l5 < worker1_maxRetry_t3l5 -> p_worker1_t3l5 : (worker1'=worker1+1) + (1-p_worker1_t3l5) : (worker1'=worker1) & (worker1retry_t3l5' = worker1retry_t3l5+1);
  [worker1dot3l5] worker1=7 & worker1retry_t3l5 >= worker1_maxRetry_t3l5 -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=8-> 1:(worker1'=8+1);
  [worker1dot1l8Retry] worker1=9 & worker1retry_t1l8 < worker1_maxRetry_t1l8 -> p_worker1_t1l8 : (worker1'=worker1+1) + (1-p_worker1_t1l8) : (worker1'=worker1) & (worker1retry_t1l8' = worker1retry_t1l8+1);
  [worker1dot1l8] worker1=9 & worker1retry_t1l8 >= worker1_maxRetry_t1l8 -> 1:(worker1'=worker1Fail);
  [worker1movel9] worker1=10-> 1:(worker1'=10+1);
  [worker1dot3l9Retry] worker1=11 & worker1retry_t3l9 < worker1_maxRetry_t3l9 -> p_worker1_t3l9 : (worker1'=worker1+1) + (1-p_worker1_t3l9) : (worker1'=worker1) & (worker1retry_t3l9' = worker1retry_t3l9+1);
  [worker1dot3l9] worker1=11 & worker1retry_t3l9 >= worker1_maxRetry_t3l9 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..3];
  worker2retry_t3l1b : [0..worker2_maxRetry_t3l1b] init 0;

  [worker2dot3l1bRetry] worker2=0 & worker2retry_t3l1b < worker2_maxRetry_t3l1b -> p_worker2_t3l1b : (worker2'=worker2+1) + (1-p_worker2_t3l1b) : (worker2'=worker2) & (worker2retry_t3l1b' = worker2retry_t3l1b+1);
  [worker2dot3l1b] worker2=0 & worker2retry_t3l1b >= worker2_maxRetry_t3l1b -> 1:(worker2'=worker2Fail);
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
  r2 : [0..5];
  r2retry_t3l1a : [0..r2_maxRetry_t3l1a] init 0;
  r2retry_t2l4 : [0..r2_maxRetry_t2l4] init 0;

  [r2dot3l1aRetry] r2=0 & r2retry_t3l1a < r2_maxRetry_t3l1a -> p_r2_t3l1a : (r2'=r2+1) + (1-p_r2_t3l1a) : (r2'=r2) & (r2retry_t3l1a' = r2retry_t3l1a+1);
  [r2dot3l1a] r2=0 & r2retry_t3l1a >= r2_maxRetry_t3l1a -> 1:(r2'=r2Fail);
  [r2movel4] r2=1-> 1:(r2'=1+1);
  [r2dot2l4Retry] r2=2 & r2retry_t2l4 < r2_maxRetry_t2l4 -> p_r2_t2l4 : (r2'=r2+1) + (1-p_r2_t2l4) : (r2'=r2) & (r2retry_t2l4' = r2retry_t2l4+1);
  [r2dot2l4] r2=2 & r2retry_t2l4 >= r2_maxRetry_t2l4 -> 1:(r2'=r2Fail);
endmodule

rewards "cost"
  [worker1movel2] true:1;
  [worker1dot3l2] true:5;
  [worker1dot3l2Retry] true:5;
  [worker1movel3] true:1;
  [worker1dot1l3] true:3;
  [worker1dot1l3Retry] true:3;
  [worker1movel6] true:1;
  [worker1dot1l6] true:3;
  [worker1dot1l6Retry] true:3;
  [worker1movel5] true:1;
  [worker1dot3l5] true:5;
  [worker1dot3l5Retry] true:5;
  [worker1movel8] true:1;
  [worker1dot1l8] true:3;
  [worker1dot1l8Retry] true:3;
  [worker1movel9] true:1;
  [worker1dot3l9] true:5;
  [worker1dot3l9Retry] true:5;
  [worker2dot3l1b] true:5;
  [worker2dot3l1bRetry] true:5;
  [r1movel2] true:1;
  [r1movel3] true:1;
  [r1dot2l3] true:1;
  [r1dot2l3Retry] true:1;
  [r2dot3l1a] true:1;
  [r2dot3l1aRetry] true:1;
  [r2movel4] true:1;
  [r2dot2l4] true:1;
  [r2dot2l4Retry] true:1;
endrewards