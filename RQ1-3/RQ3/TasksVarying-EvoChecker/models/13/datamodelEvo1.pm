dtmc
evolve int worker2_maxRetry_t1l2 [1..5];
evolve int worker2_maxRetry_t3l3 [1..5];
evolve int worker2_maxRetry_t1l3 [1..5];
evolve int worker2_maxRetry_t1l6 [1..5];
evolve int r1_maxRetry_t3l5 [1..10];
evolve int r1_maxRetry_t2l5 [1..10];
evolve int r1_maxRetry_t3l6 [1..10];
evolve int r1_maxRetry_t2l6b [1..10];
evolve int r1_maxRetry_t2l6a [1..10];
evolve int r1_maxRetry_t2l9 [1..10];
evolve int worker1_maxRetry_t1l4 [1..5];
evolve int worker1_maxRetry_t1l7b [1..5];
evolve int worker1_maxRetry_t1l7a [1..5];

const double p_worker2_t1l2=1.0;
const double p_worker2_t3l3=0.99;
const double p_worker2_t1l3=1.0;
const double p_worker2_t1l6=1.0;
const double p_r1_t3l5=0.97;
const double p_r1_t2l5=0.99;
const double p_r1_t3l6=0.97;
const double p_r1_t2l6b=0.99;
const double p_r1_t2l6a=0.99;
const double p_r1_t2l9=0.99;
const double p_worker1_t1l4=1.0;
const double p_worker1_t1l7b=1.0;
const double p_worker1_t1l7a=1.0;
const int worker2Final = 7;
const int worker2Fail = 8;
const int r1Final = 10;
const int r1Fail = 11;
const int worker1Final = 5;
const int worker1Fail = 6;

module _worker2
  worker2 : [0..9];
  worker2retry_t1l2 : [0..worker2_maxRetry_t1l2] init 0;
  worker2retry_t3l3 : [0..worker2_maxRetry_t3l3] init 0;
  worker2retry_t1l3 : [0..worker2_maxRetry_t1l3] init 0;
  worker2retry_t1l6 : [0..worker2_maxRetry_t1l6] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l2Retry] worker2=1 & worker2retry_t1l2 < worker2_maxRetry_t1l2 -> p_worker2_t1l2 : (worker2'=worker2+1) + (1-p_worker2_t1l2) : (worker2'=worker2) & (worker2retry_t1l2' = worker2retry_t1l2+1);
  [worker2dot1l2] worker2=1 & worker2retry_t1l2 >= worker2_maxRetry_t1l2 -> 1:(worker2'=worker2Fail);
  [worker2movel3] worker2=2-> 1:(worker2'=2+1);
  [worker2dot3l3Retry] worker2=3 & worker2retry_t3l3 < worker2_maxRetry_t3l3 -> p_worker2_t3l3 : (worker2'=worker2+1) + (1-p_worker2_t3l3) : (worker2'=worker2) & (worker2retry_t3l3' = worker2retry_t3l3+1);
  [worker2dot3l3] worker2=3 & worker2retry_t3l3 >= worker2_maxRetry_t3l3 -> 1:(worker2'=worker2Fail);
  [worker2dot1l3Retry] worker2=4 & worker2retry_t1l3 < worker2_maxRetry_t1l3 -> p_worker2_t1l3 : (worker2'=worker2+1) + (1-p_worker2_t1l3) : (worker2'=worker2) & (worker2retry_t1l3' = worker2retry_t1l3+1);
  [worker2dot1l3] worker2=4 & worker2retry_t1l3 >= worker2_maxRetry_t1l3 -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=5-> 1:(worker2'=5+1);
  [worker2dot1l6Retry] worker2=6 & worker2retry_t1l6 < worker2_maxRetry_t1l6 -> p_worker2_t1l6 : (worker2'=worker2+1) + (1-p_worker2_t1l6) : (worker2'=worker2) & (worker2retry_t1l6' = worker2retry_t1l6+1);
  [worker2dot1l6] worker2=6 & worker2retry_t1l6 >= worker2_maxRetry_t1l6 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..12];
  r1retry_t3l5 : [0..r1_maxRetry_t3l5] init 0;
  r1retry_t2l5 : [0..r1_maxRetry_t2l5] init 0;
  r1retry_t3l6 : [0..r1_maxRetry_t3l6] init 0;
  r1retry_t2l6b : [0..r1_maxRetry_t2l6b] init 0;
  r1retry_t2l6a : [0..r1_maxRetry_t2l6a] init 0;
  r1retry_t2l9 : [0..r1_maxRetry_t2l9] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1movel5] r1=1-> 1:(r1'=1+1);
  [r1dot3l5Retry] r1=2 & r1retry_t3l5 < r1_maxRetry_t3l5 -> p_r1_t3l5 : (r1'=r1+1) + (1-p_r1_t3l5) : (r1'=r1) & (r1retry_t3l5' = r1retry_t3l5+1);
  [r1dot3l5] r1=2 & r1retry_t3l5 >= r1_maxRetry_t3l5 -> 1:(r1'=r1Fail);
  [r1dot2l5Retry] r1=3 & r1retry_t2l5 < r1_maxRetry_t2l5 -> p_r1_t2l5 : (r1'=r1+1) + (1-p_r1_t2l5) : (r1'=r1) & (r1retry_t2l5' = r1retry_t2l5+1);
  [r1dot2l5] r1=3 & r1retry_t2l5 >= r1_maxRetry_t2l5 -> 1:(r1'=r1Fail);
  [r1movel6] r1=4-> 1:(r1'=4+1);
  [r1dot3l6Retry] r1=5 & r1retry_t3l6 < r1_maxRetry_t3l6 -> p_r1_t3l6 : (r1'=r1+1) + (1-p_r1_t3l6) : (r1'=r1) & (r1retry_t3l6' = r1retry_t3l6+1);
  [r1dot3l6] r1=5 & r1retry_t3l6 >= r1_maxRetry_t3l6 -> 1:(r1'=r1Fail);
  [r1dot2l6bRetry] r1=6 & r1retry_t2l6b < r1_maxRetry_t2l6b -> p_r1_t2l6b : (r1'=r1+1) + (1-p_r1_t2l6b) : (r1'=r1) & (r1retry_t2l6b' = r1retry_t2l6b+1);
  [r1dot2l6b] r1=6 & r1retry_t2l6b >= r1_maxRetry_t2l6b -> 1:(r1'=r1Fail);
  [r1dot2l6aRetry] r1=7 & r1retry_t2l6a < r1_maxRetry_t2l6a -> p_r1_t2l6a : (r1'=r1+1) + (1-p_r1_t2l6a) : (r1'=r1) & (r1retry_t2l6a' = r1retry_t2l6a+1);
  [r1dot2l6a] r1=7 & r1retry_t2l6a >= r1_maxRetry_t2l6a -> 1:(r1'=r1Fail);
  [r1movel9] r1=8-> 1:(r1'=8+1);
  [r1dot2l9Retry] r1=9 & r1retry_t2l9 < r1_maxRetry_t2l9 -> p_r1_t2l9 : (r1'=r1+1) + (1-p_r1_t2l9) : (r1'=r1) & (r1retry_t2l9' = r1retry_t2l9+1);
  [r1dot2l9] r1=9 & r1retry_t2l9 >= r1_maxRetry_t2l9 -> 1:(r1'=r1Fail);
endmodule

module _worker1
  worker1 : [0..7];
  worker1retry_t1l4 : [0..worker1_maxRetry_t1l4] init 0;
  worker1retry_t1l7b : [0..worker1_maxRetry_t1l7b] init 0;
  worker1retry_t1l7a : [0..worker1_maxRetry_t1l7a] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l4Retry] worker1=1 & worker1retry_t1l4 < worker1_maxRetry_t1l4 -> p_worker1_t1l4 : (worker1'=worker1+1) + (1-p_worker1_t1l4) : (worker1'=worker1) & (worker1retry_t1l4' = worker1retry_t1l4+1);
  [worker1dot1l4] worker1=1 & worker1retry_t1l4 >= worker1_maxRetry_t1l4 -> 1:(worker1'=worker1Fail);
  [worker1movel7] worker1=2-> 1:(worker1'=2+1);
  [worker1dot1l7bRetry] worker1=3 & worker1retry_t1l7b < worker1_maxRetry_t1l7b -> p_worker1_t1l7b : (worker1'=worker1+1) + (1-p_worker1_t1l7b) : (worker1'=worker1) & (worker1retry_t1l7b' = worker1retry_t1l7b+1);
  [worker1dot1l7b] worker1=3 & worker1retry_t1l7b >= worker1_maxRetry_t1l7b -> 1:(worker1'=worker1Fail);
  [worker1dot1l7aRetry] worker1=4 & worker1retry_t1l7a < worker1_maxRetry_t1l7a -> p_worker1_t1l7a : (worker1'=worker1+1) + (1-p_worker1_t1l7a) : (worker1'=worker1) & (worker1retry_t1l7a' = worker1retry_t1l7a+1);
  [worker1dot1l7a] worker1=4 & worker1retry_t1l7a >= worker1_maxRetry_t1l7a -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [worker2movel2] true:1;
  [worker2dot1l2] true:3;
  [worker2dot1l2Retry] true:3;
  [worker2movel3] true:1;
  [worker2dot3l3] true:5;
  [worker2dot3l3Retry] true:5;
  [worker2dot1l3] true:3;
  [worker2dot1l3Retry] true:3;
  [worker2movel6] true:1;
  [worker2dot1l6] true:3;
  [worker2dot1l6Retry] true:3;
  [r1movel4] true:1;
  [r1movel5] true:1;
  [r1dot3l5] true:1;
  [r1dot3l5Retry] true:1;
  [r1dot2l5] true:1;
  [r1dot2l5Retry] true:1;
  [r1movel6] true:1;
  [r1dot3l6] true:1;
  [r1dot3l6Retry] true:1;
  [r1dot2l6b] true:1;
  [r1dot2l6bRetry] true:1;
  [r1dot2l6a] true:1;
  [r1dot2l6aRetry] true:1;
  [r1movel9] true:1;
  [r1dot2l9] true:1;
  [r1dot2l9Retry] true:1;
  [worker1movel4] true:1;
  [worker1dot1l4] true:3;
  [worker1dot1l4Retry] true:3;
  [worker1movel7] true:1;
  [worker1dot1l7b] true:3;
  [worker1dot1l7bRetry] true:3;
  [worker1dot1l7a] true:3;
  [worker1dot1l7aRetry] true:3;
endrewards