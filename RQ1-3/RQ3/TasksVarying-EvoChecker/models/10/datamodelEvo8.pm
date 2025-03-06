dtmc
evolve int worker1_maxRetry_t3l2 [1..5];
evolve int worker1_maxRetry_t1l3 [1..5];
evolve int worker1_maxRetry_t3l5a [1..5];
evolve int worker1_maxRetry_t3l5b [1..5];
evolve int worker1_maxRetry_t1l6 [1..5];
evolve int worker1_maxRetry_t3l9 [1..5];
evolve int worker2_maxRetry_t3l4 [1..5];
evolve int worker2_maxRetry_t1l7 [1..5];
evolve int r1_maxRetry_t2l3a [1..10];
evolve int r1_maxRetry_t2l3b [1..10];

const double p_worker1_t3l2=0.99;
const double p_worker1_t1l3=1.0;
const double p_worker1_t3l5a=0.99;
const double p_worker1_t3l5b=0.99;
const double p_worker1_t1l6=1.0;
const double p_worker1_t3l9=0.99;
const double p_worker2_t3l4=0.99;
const double p_worker2_t1l7=1.0;
const double p_r1_t2l3a=0.99;
const double p_r1_t2l3b=0.99;
const int worker1Final = 12;
const int worker1Fail = 13;
const int worker2Final = 4;
const int worker2Fail = 5;
const int r1Final = 4;
const int r1Fail = 5;

module _worker1
  worker1 : [0..14];
  worker1retry_t3l2 : [0..worker1_maxRetry_t3l2] init 0;
  worker1retry_t1l3 : [0..worker1_maxRetry_t1l3] init 0;
  worker1retry_t3l5a : [0..worker1_maxRetry_t3l5a] init 0;
  worker1retry_t3l5b : [0..worker1_maxRetry_t3l5b] init 0;
  worker1retry_t1l6 : [0..worker1_maxRetry_t1l6] init 0;
  worker1retry_t3l9 : [0..worker1_maxRetry_t3l9] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1dot3l2Retry] worker1=1 & worker1retry_t3l2 < worker1_maxRetry_t3l2 -> p_worker1_t3l2 : (worker1'=worker1+1) + (1-p_worker1_t3l2) : (worker1'=worker1) & (worker1retry_t3l2' = worker1retry_t3l2+1);
  [worker1dot3l2] worker1=1 & worker1retry_t3l2 >= worker1_maxRetry_t3l2 -> 1:(worker1'=worker1Fail);
  [worker1movel3] worker1=2-> 1:(worker1'=2+1);
  [worker1dot1l3Retry] worker1=3 & worker1retry_t1l3 < worker1_maxRetry_t1l3 -> p_worker1_t1l3 : (worker1'=worker1+1) + (1-p_worker1_t1l3) : (worker1'=worker1) & (worker1retry_t1l3' = worker1retry_t1l3+1);
  [worker1dot1l3] worker1=3 & worker1retry_t1l3 >= worker1_maxRetry_t1l3 -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=4-> 1:(worker1'=4+1);
  [worker1movel5] worker1=5-> 1:(worker1'=5+1);
  [worker1dot3l5aRetry] worker1=6 & worker1retry_t3l5a < worker1_maxRetry_t3l5a -> p_worker1_t3l5a : (worker1'=worker1+1) + (1-p_worker1_t3l5a) : (worker1'=worker1) & (worker1retry_t3l5a' = worker1retry_t3l5a+1);
  [worker1dot3l5a] worker1=6 & worker1retry_t3l5a >= worker1_maxRetry_t3l5a -> 1:(worker1'=worker1Fail);
  [worker1dot3l5bRetry] worker1=7 & worker1retry_t3l5b < worker1_maxRetry_t3l5b -> p_worker1_t3l5b : (worker1'=worker1+1) + (1-p_worker1_t3l5b) : (worker1'=worker1) & (worker1retry_t3l5b' = worker1retry_t3l5b+1);
  [worker1dot3l5b] worker1=7 & worker1retry_t3l5b >= worker1_maxRetry_t3l5b -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=8-> 1:(worker1'=8+1);
  [worker1dot1l6Retry] worker1=9 & worker1retry_t1l6 < worker1_maxRetry_t1l6 -> p_worker1_t1l6 : (worker1'=worker1+1) + (1-p_worker1_t1l6) : (worker1'=worker1) & (worker1retry_t1l6' = worker1retry_t1l6+1);
  [worker1dot1l6] worker1=9 & worker1retry_t1l6 >= worker1_maxRetry_t1l6 -> 1:(worker1'=worker1Fail);
  [worker1movel9] worker1=10-> 1:(worker1'=10+1);
  [worker1dot3l9Retry] worker1=11 & worker1retry_t3l9 < worker1_maxRetry_t3l9 -> p_worker1_t3l9 : (worker1'=worker1+1) + (1-p_worker1_t3l9) : (worker1'=worker1) & (worker1retry_t3l9' = worker1retry_t3l9+1);
  [worker1dot3l9] worker1=11 & worker1retry_t3l9 >= worker1_maxRetry_t3l9 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..6];
  worker2retry_t3l4 : [0..worker2_maxRetry_t3l4] init 0;
  worker2retry_t1l7 : [0..worker2_maxRetry_t1l7] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2dot3l4Retry] worker2=1 & worker2retry_t3l4 < worker2_maxRetry_t3l4 -> p_worker2_t3l4 : (worker2'=worker2+1) + (1-p_worker2_t3l4) : (worker2'=worker2) & (worker2retry_t3l4' = worker2retry_t3l4+1);
  [worker2dot3l4] worker2=1 & worker2retry_t3l4 >= worker2_maxRetry_t3l4 -> 1:(worker2'=worker2Fail);
  [worker2movel7] worker2=2-> 1:(worker2'=2+1);
  [worker2dot1l7Retry] worker2=3 & worker2retry_t1l7 < worker2_maxRetry_t1l7 -> p_worker2_t1l7 : (worker2'=worker2+1) + (1-p_worker2_t1l7) : (worker2'=worker2) & (worker2retry_t1l7' = worker2retry_t1l7+1);
  [worker2dot1l7] worker2=3 & worker2retry_t1l7 >= worker2_maxRetry_t1l7 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..6];
  r1retry_t2l3a : [0..r1_maxRetry_t2l3a] init 0;
  r1retry_t2l3b : [0..r1_maxRetry_t2l3b] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1movel3] r1=1-> 1:(r1'=1+1);
  [r1dot2l3aRetry] r1=2 & r1retry_t2l3a < r1_maxRetry_t2l3a -> p_r1_t2l3a : (r1'=r1+1) + (1-p_r1_t2l3a) : (r1'=r1) & (r1retry_t2l3a' = r1retry_t2l3a+1);
  [r1dot2l3a] r1=2 & r1retry_t2l3a >= r1_maxRetry_t2l3a -> 1:(r1'=r1Fail);
  [r1dot2l3bRetry] r1=3 & r1retry_t2l3b < r1_maxRetry_t2l3b -> p_r1_t2l3b : (r1'=r1+1) + (1-p_r1_t2l3b) : (r1'=r1) & (r1retry_t2l3b' = r1retry_t2l3b+1);
  [r1dot2l3b] r1=3 & r1retry_t2l3b >= r1_maxRetry_t2l3b -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [worker1movel2] true:1;
  [worker1dot3l2] true:5;
  [worker1dot3l2Retry] true:5;
  [worker1movel3] true:1;
  [worker1dot1l3] true:3;
  [worker1dot1l3Retry] true:3;
  [worker1movel6] true:1;
  [worker1movel5] true:1;
  [worker1dot3l5a] true:5;
  [worker1dot3l5aRetry] true:5;
  [worker1dot3l5b] true:5;
  [worker1dot3l5bRetry] true:5;
  [worker1movel6] true:1;
  [worker1dot1l6] true:3;
  [worker1dot1l6Retry] true:3;
  [worker1movel9] true:1;
  [worker1dot3l9] true:5;
  [worker1dot3l9Retry] true:5;
  [worker2movel4] true:1;
  [worker2dot3l4] true:5;
  [worker2dot3l4Retry] true:5;
  [worker2movel7] true:1;
  [worker2dot1l7] true:3;
  [worker2dot1l7Retry] true:3;
  [r1movel2] true:1;
  [r1movel3] true:1;
  [r1dot2l3a] true:1;
  [r1dot2l3aRetry] true:1;
  [r1dot2l3b] true:1;
  [r1dot2l3bRetry] true:1;
endrewards