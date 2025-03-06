dtmc
evolve int r1_maxRetry_t2l1 [1..10];
evolve int r1_maxRetry_t3l4 [1..10];
evolve int r1_maxRetry_t2l7 [1..10];
evolve int r1_maxRetry_t2l8 [1..10];
evolve int worker1_maxRetry_t1l1 [1..5];
evolve int worker1_maxRetry_t1l2 [1..5];
evolve int worker1_maxRetry_t1l3a [1..5];
evolve int worker1_maxRetry_t1l3b [1..5];
evolve int worker2_maxRetry_t1l4 [1..5];
evolve int worker2_maxRetry_t3l5 [1..5];
evolve int worker2_maxRetry_t3l6 [1..5];
evolve int worker2_maxRetry_t1l9 [1..5];

const double p_r1_t2l1=0.99;
const double p_r1_t3l4=0.97;
const double p_r1_t2l7=0.99;
const double p_r1_t2l8=0.99;
const double p_worker1_t1l1=1.0;
const double p_worker1_t1l2=1.0;
const double p_worker1_t1l3a=1.0;
const double p_worker1_t1l3b=1.0;
const double p_worker2_t1l4=1.0;
const double p_worker2_t3l5=0.99;
const double p_worker2_t3l6=0.99;
const double p_worker2_t1l9=1.0;
const int r1Final = 7;
const int r1Fail = 8;
const int worker1Final = 6;
const int worker1Fail = 7;
const int worker2Final = 8;
const int worker2Fail = 9;

module _r1
  r1 : [0..9];
  r1retry_t2l1 : [0..r1_maxRetry_t2l1] init 0;
  r1retry_t3l4 : [0..r1_maxRetry_t3l4] init 0;
  r1retry_t2l7 : [0..r1_maxRetry_t2l7] init 0;
  r1retry_t2l8 : [0..r1_maxRetry_t2l8] init 0;

  [r1dot2l1Retry] r1=0 & r1retry_t2l1 < r1_maxRetry_t2l1 -> p_r1_t2l1 : (r1'=r1+1) + (1-p_r1_t2l1) : (r1'=r1) & (r1retry_t2l1' = r1retry_t2l1+1);
  [r1dot2l1] r1=0 & r1retry_t2l1 >= r1_maxRetry_t2l1 -> 1:(r1'=r1Fail);
  [r1movel4] r1=1-> 1:(r1'=1+1);
  [r1dot3l4Retry] r1=2 & r1retry_t3l4 < r1_maxRetry_t3l4 -> p_r1_t3l4 : (r1'=r1+1) + (1-p_r1_t3l4) : (r1'=r1) & (r1retry_t3l4' = r1retry_t3l4+1);
  [r1dot3l4] r1=2 & r1retry_t3l4 >= r1_maxRetry_t3l4 -> 1:(r1'=r1Fail);
  [r1movel7] r1=3-> 1:(r1'=3+1);
  [r1dot2l7Retry] r1=4 & r1retry_t2l7 < r1_maxRetry_t2l7 -> p_r1_t2l7 : (r1'=r1+1) + (1-p_r1_t2l7) : (r1'=r1) & (r1retry_t2l7' = r1retry_t2l7+1);
  [r1dot2l7] r1=4 & r1retry_t2l7 >= r1_maxRetry_t2l7 -> 1:(r1'=r1Fail);
  [r1movel8] r1=5-> 1:(r1'=5+1);
  [r1dot2l8Retry] r1=6 & r1retry_t2l8 < r1_maxRetry_t2l8 -> p_r1_t2l8 : (r1'=r1+1) + (1-p_r1_t2l8) : (r1'=r1) & (r1retry_t2l8' = r1retry_t2l8+1);
  [r1dot2l8] r1=6 & r1retry_t2l8 >= r1_maxRetry_t2l8 -> 1:(r1'=r1Fail);
endmodule

module _worker1
  worker1 : [0..8];
  worker1retry_t1l1 : [0..worker1_maxRetry_t1l1] init 0;
  worker1retry_t1l2 : [0..worker1_maxRetry_t1l2] init 0;
  worker1retry_t1l3a : [0..worker1_maxRetry_t1l3a] init 0;
  worker1retry_t1l3b : [0..worker1_maxRetry_t1l3b] init 0;

  [worker1dot1l1Retry] worker1=0 & worker1retry_t1l1 < worker1_maxRetry_t1l1 -> p_worker1_t1l1 : (worker1'=worker1+1) + (1-p_worker1_t1l1) : (worker1'=worker1) & (worker1retry_t1l1' = worker1retry_t1l1+1);
  [worker1dot1l1] worker1=0 & worker1retry_t1l1 >= worker1_maxRetry_t1l1 -> 1:(worker1'=worker1Fail);
  [worker1movel2] worker1=1-> 1:(worker1'=1+1);
  [worker1dot1l2Retry] worker1=2 & worker1retry_t1l2 < worker1_maxRetry_t1l2 -> p_worker1_t1l2 : (worker1'=worker1+1) + (1-p_worker1_t1l2) : (worker1'=worker1) & (worker1retry_t1l2' = worker1retry_t1l2+1);
  [worker1dot1l2] worker1=2 & worker1retry_t1l2 >= worker1_maxRetry_t1l2 -> 1:(worker1'=worker1Fail);
  [worker1movel3] worker1=3-> 1:(worker1'=3+1);
  [worker1dot1l3aRetry] worker1=4 & worker1retry_t1l3a < worker1_maxRetry_t1l3a -> p_worker1_t1l3a : (worker1'=worker1+1) + (1-p_worker1_t1l3a) : (worker1'=worker1) & (worker1retry_t1l3a' = worker1retry_t1l3a+1);
  [worker1dot1l3a] worker1=4 & worker1retry_t1l3a >= worker1_maxRetry_t1l3a -> 1:(worker1'=worker1Fail);
  [worker1dot1l3bRetry] worker1=5 & worker1retry_t1l3b < worker1_maxRetry_t1l3b -> p_worker1_t1l3b : (worker1'=worker1+1) + (1-p_worker1_t1l3b) : (worker1'=worker1) & (worker1retry_t1l3b' = worker1retry_t1l3b+1);
  [worker1dot1l3b] worker1=5 & worker1retry_t1l3b >= worker1_maxRetry_t1l3b -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..10];
  worker2retry_t1l4 : [0..worker2_maxRetry_t1l4] init 0;
  worker2retry_t3l5 : [0..worker2_maxRetry_t3l5] init 0;
  worker2retry_t3l6 : [0..worker2_maxRetry_t3l6] init 0;
  worker2retry_t1l9 : [0..worker2_maxRetry_t1l9] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l4Retry] worker2=1 & worker2retry_t1l4 < worker2_maxRetry_t1l4 -> p_worker2_t1l4 : (worker2'=worker2+1) + (1-p_worker2_t1l4) : (worker2'=worker2) & (worker2retry_t1l4' = worker2retry_t1l4+1);
  [worker2dot1l4] worker2=1 & worker2retry_t1l4 >= worker2_maxRetry_t1l4 -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=2-> 1:(worker2'=2+1);
  [worker2dot3l5Retry] worker2=3 & worker2retry_t3l5 < worker2_maxRetry_t3l5 -> p_worker2_t3l5 : (worker2'=worker2+1) + (1-p_worker2_t3l5) : (worker2'=worker2) & (worker2retry_t3l5' = worker2retry_t3l5+1);
  [worker2dot3l5] worker2=3 & worker2retry_t3l5 >= worker2_maxRetry_t3l5 -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=4-> 1:(worker2'=4+1);
  [worker2dot3l6Retry] worker2=5 & worker2retry_t3l6 < worker2_maxRetry_t3l6 -> p_worker2_t3l6 : (worker2'=worker2+1) + (1-p_worker2_t3l6) : (worker2'=worker2) & (worker2retry_t3l6' = worker2retry_t3l6+1);
  [worker2dot3l6] worker2=5 & worker2retry_t3l6 >= worker2_maxRetry_t3l6 -> 1:(worker2'=worker2Fail);
  [worker2movel9] worker2=6-> 1:(worker2'=6+1);
  [worker2dot1l9Retry] worker2=7 & worker2retry_t1l9 < worker2_maxRetry_t1l9 -> p_worker2_t1l9 : (worker2'=worker2+1) + (1-p_worker2_t1l9) : (worker2'=worker2) & (worker2retry_t1l9' = worker2retry_t1l9+1);
  [worker2dot1l9] worker2=7 & worker2retry_t1l9 >= worker2_maxRetry_t1l9 -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r1dot2l1] true:1;
  [r1dot2l1Retry] true:1;
  [r1movel4] true:1;
  [r1dot3l4] true:1;
  [r1dot3l4Retry] true:1;
  [r1movel7] true:1;
  [r1dot2l7] true:1;
  [r1dot2l7Retry] true:1;
  [r1movel8] true:1;
  [r1dot2l8] true:1;
  [r1dot2l8Retry] true:1;
  [worker1dot1l1] true:3;
  [worker1dot1l1Retry] true:3;
  [worker1movel2] true:1;
  [worker1dot1l2] true:3;
  [worker1dot1l2Retry] true:3;
  [worker1movel3] true:1;
  [worker1dot1l3a] true:3;
  [worker1dot1l3aRetry] true:3;
  [worker1dot1l3b] true:3;
  [worker1dot1l3bRetry] true:3;
  [worker2movel4] true:1;
  [worker2dot1l4] true:3;
  [worker2dot1l4Retry] true:3;
  [worker2movel5] true:1;
  [worker2dot3l5] true:5;
  [worker2dot3l5Retry] true:5;
  [worker2movel6] true:1;
  [worker2dot3l6] true:5;
  [worker2dot3l6Retry] true:5;
  [worker2movel9] true:1;
  [worker2dot1l9] true:3;
  [worker2dot1l9Retry] true:3;
endrewards