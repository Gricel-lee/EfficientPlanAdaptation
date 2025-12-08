dtmc
evolve int worker1_maxRetry_t3l4 [1..5];
evolve int worker1_maxRetry_t1l5 [1..5];
evolve int worker1_maxRetry_t1l6 [1..5];
evolve int worker1_maxRetry_t1l9 [1..5];
evolve int worker2_maxRetry_t3l7 [1..5];
evolve int worker2_maxRetry_t1l7 [1..5];
evolve int r1_maxRetry_t2l5 [1..10];
evolve int r1_maxRetry_t2l2 [1..10];
evolve int r1_maxRetry_t3l3b [1..10];
evolve int r1_maxRetry_t2l3 [1..10];
evolve int r1_maxRetry_t3l3a [1..10];

const double p_worker1_t3l4=0.99;
const double p_worker1_t1l5=1.0;
const double p_worker1_t1l6=1.0;
const double p_worker1_t1l9=1.0;
const double p_worker2_t3l7=0.99;
const double p_worker2_t1l7=1.0;
const double p_r1_t2l5=0.99;
const double p_r1_t2l2=0.99;
const double p_r1_t3l3b=0.97;
const double p_r1_t2l3=0.99;
const double p_r1_t3l3a=0.97;
const int worker1Final = 8;
const int worker1Fail = 9;
const int worker2Final = 4;
const int worker2Fail = 5;
const int r1Final = 9;
const int r1Fail = 10;

module _worker1
  worker1 : [0..10];
  worker1retry_t3l4 : [0..worker1_maxRetry_t3l4] init 0;
  worker1retry_t1l5 : [0..worker1_maxRetry_t1l5] init 0;
  worker1retry_t1l6 : [0..worker1_maxRetry_t1l6] init 0;
  worker1retry_t1l9 : [0..worker1_maxRetry_t1l9] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot3l4Retry] worker1=1 & worker1retry_t3l4 < worker1_maxRetry_t3l4 -> p_worker1_t3l4 : (worker1'=worker1+1) + (1-p_worker1_t3l4) : (worker1'=worker1) & (worker1retry_t3l4' = worker1retry_t3l4+1);
  [worker1dot3l4] worker1=1 & worker1retry_t3l4 >= worker1_maxRetry_t3l4 -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=2-> 1:(worker1'=2+1);
  [worker1dot1l5Retry] worker1=3 & worker1retry_t1l5 < worker1_maxRetry_t1l5 -> p_worker1_t1l5 : (worker1'=worker1+1) + (1-p_worker1_t1l5) : (worker1'=worker1) & (worker1retry_t1l5' = worker1retry_t1l5+1);
  [worker1dot1l5] worker1=3 & worker1retry_t1l5 >= worker1_maxRetry_t1l5 -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=4-> 1:(worker1'=4+1);
  [worker1dot1l6Retry] worker1=5 & worker1retry_t1l6 < worker1_maxRetry_t1l6 -> p_worker1_t1l6 : (worker1'=worker1+1) + (1-p_worker1_t1l6) : (worker1'=worker1) & (worker1retry_t1l6' = worker1retry_t1l6+1);
  [worker1dot1l6] worker1=5 & worker1retry_t1l6 >= worker1_maxRetry_t1l6 -> 1:(worker1'=worker1Fail);
  [worker1movel9] worker1=6-> 1:(worker1'=6+1);
  [worker1dot1l9Retry] worker1=7 & worker1retry_t1l9 < worker1_maxRetry_t1l9 -> p_worker1_t1l9 : (worker1'=worker1+1) + (1-p_worker1_t1l9) : (worker1'=worker1) & (worker1retry_t1l9' = worker1retry_t1l9+1);
  [worker1dot1l9] worker1=7 & worker1retry_t1l9 >= worker1_maxRetry_t1l9 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..6];
  worker2retry_t3l7 : [0..worker2_maxRetry_t3l7] init 0;
  worker2retry_t1l7 : [0..worker2_maxRetry_t1l7] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2movel7] worker2=1-> 1:(worker2'=1+1);
  [worker2dot3l7Retry] worker2=2 & worker2retry_t3l7 < worker2_maxRetry_t3l7 -> p_worker2_t3l7 : (worker2'=worker2+1) + (1-p_worker2_t3l7) : (worker2'=worker2) & (worker2retry_t3l7' = worker2retry_t3l7+1);
  [worker2dot3l7] worker2=2 & worker2retry_t3l7 >= worker2_maxRetry_t3l7 -> 1:(worker2'=worker2Fail);
  [worker2dot1l7Retry] worker2=3 & worker2retry_t1l7 < worker2_maxRetry_t1l7 -> p_worker2_t1l7 : (worker2'=worker2+1) + (1-p_worker2_t1l7) : (worker2'=worker2) & (worker2retry_t1l7' = worker2retry_t1l7+1);
  [worker2dot1l7] worker2=3 & worker2retry_t1l7 >= worker2_maxRetry_t1l7 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..11];
  r1retry_t2l5 : [0..r1_maxRetry_t2l5] init 0;
  r1retry_t2l2 : [0..r1_maxRetry_t2l2] init 0;
  r1retry_t3l3b : [0..r1_maxRetry_t3l3b] init 0;
  r1retry_t2l3 : [0..r1_maxRetry_t2l3] init 0;
  r1retry_t3l3a : [0..r1_maxRetry_t3l3a] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1movel5] r1=1-> 1:(r1'=1+1);
  [r1dot2l5Retry] r1=2 & r1retry_t2l5 < r1_maxRetry_t2l5 -> p_r1_t2l5 : (r1'=r1+1) + (1-p_r1_t2l5) : (r1'=r1) & (r1retry_t2l5' = r1retry_t2l5+1);
  [r1dot2l5] r1=2 & r1retry_t2l5 >= r1_maxRetry_t2l5 -> 1:(r1'=r1Fail);
  [r1movel2] r1=3-> 1:(r1'=3+1);
  [r1dot2l2Retry] r1=4 & r1retry_t2l2 < r1_maxRetry_t2l2 -> p_r1_t2l2 : (r1'=r1+1) + (1-p_r1_t2l2) : (r1'=r1) & (r1retry_t2l2' = r1retry_t2l2+1);
  [r1dot2l2] r1=4 & r1retry_t2l2 >= r1_maxRetry_t2l2 -> 1:(r1'=r1Fail);
  [r1movel3] r1=5-> 1:(r1'=5+1);
  [r1dot3l3bRetry] r1=6 & r1retry_t3l3b < r1_maxRetry_t3l3b -> p_r1_t3l3b : (r1'=r1+1) + (1-p_r1_t3l3b) : (r1'=r1) & (r1retry_t3l3b' = r1retry_t3l3b+1);
  [r1dot3l3b] r1=6 & r1retry_t3l3b >= r1_maxRetry_t3l3b -> 1:(r1'=r1Fail);
  [r1dot2l3Retry] r1=7 & r1retry_t2l3 < r1_maxRetry_t2l3 -> p_r1_t2l3 : (r1'=r1+1) + (1-p_r1_t2l3) : (r1'=r1) & (r1retry_t2l3' = r1retry_t2l3+1);
  [r1dot2l3] r1=7 & r1retry_t2l3 >= r1_maxRetry_t2l3 -> 1:(r1'=r1Fail);
  [r1dot3l3aRetry] r1=8 & r1retry_t3l3a < r1_maxRetry_t3l3a -> p_r1_t3l3a : (r1'=r1+1) + (1-p_r1_t3l3a) : (r1'=r1) & (r1retry_t3l3a' = r1retry_t3l3a+1);
  [r1dot3l3a] r1=8 & r1retry_t3l3a >= r1_maxRetry_t3l3a -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [worker1movel4] true:1;
  [worker1dot3l4] true:5;
  [worker1dot3l4Retry] true:5;
  [worker1movel5] true:1;
  [worker1dot1l5] true:3;
  [worker1dot1l5Retry] true:3;
  [worker1movel6] true:1;
  [worker1dot1l6] true:3;
  [worker1dot1l6Retry] true:3;
  [worker1movel9] true:1;
  [worker1dot1l9] true:3;
  [worker1dot1l9Retry] true:3;
  [worker2movel4] true:1;
  [worker2movel7] true:1;
  [worker2dot3l7] true:5;
  [worker2dot3l7Retry] true:5;
  [worker2dot1l7] true:3;
  [worker2dot1l7Retry] true:3;
  [r1movel2] true:1;
  [r1movel5] true:1;
  [r1dot2l5] true:1;
  [r1dot2l5Retry] true:1;
  [r1movel2] true:1;
  [r1dot2l2] true:1;
  [r1dot2l2Retry] true:1;
  [r1movel3] true:1;
  [r1dot3l3b] true:1;
  [r1dot3l3bRetry] true:1;
  [r1dot2l3] true:1;
  [r1dot2l3Retry] true:1;
  [r1dot3l3a] true:1;
  [r1dot3l3aRetry] true:1;
endrewards