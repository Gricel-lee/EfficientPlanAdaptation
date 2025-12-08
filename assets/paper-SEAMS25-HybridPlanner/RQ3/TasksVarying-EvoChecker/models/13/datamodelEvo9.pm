dtmc
evolve int worker2_maxRetry_t1l2 [1..5];
evolve int r1_maxRetry_t2l2 [1..10];
evolve int r1_maxRetry_t2l6 [1..10];
evolve int r1_maxRetry_t3l8a [1..10];
evolve int r1_maxRetry_t2l8c [1..10];
evolve int r1_maxRetry_t2l8a [1..10];
evolve int r1_maxRetry_t2l8b [1..10];
evolve int r1_maxRetry_t3l8b [1..10];
evolve int worker1_maxRetry_t1l4 [1..5];
evolve int worker1_maxRetry_t3l5 [1..5];
evolve int worker1_maxRetry_t1l6a [1..5];
evolve int worker1_maxRetry_t1l6b [1..5];
evolve int worker1_maxRetry_t1l9 [1..5];

const double p_worker2_t1l2=1.0;
const double p_r1_t2l2=0.99;
const double p_r1_t2l6=0.99;
const double p_r1_t3l8a=0.97;
const double p_r1_t2l8c=0.99;
const double p_r1_t2l8a=0.99;
const double p_r1_t2l8b=0.99;
const double p_r1_t3l8b=0.97;
const double p_worker1_t1l4=1.0;
const double p_worker1_t3l5=0.99;
const double p_worker1_t1l6a=1.0;
const double p_worker1_t1l6b=1.0;
const double p_worker1_t1l9=1.0;
const int worker2Final = 2;
const int worker2Fail = 3;
const int r1Final = 12;
const int r1Fail = 13;
const int worker1Final = 9;
const int worker1Fail = 10;

module _worker2
  worker2 : [0..4];
  worker2retry_t1l2 : [0..worker2_maxRetry_t1l2] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l2Retry] worker2=1 & worker2retry_t1l2 < worker2_maxRetry_t1l2 -> p_worker2_t1l2 : (worker2'=worker2+1) + (1-p_worker2_t1l2) : (worker2'=worker2) & (worker2retry_t1l2' = worker2retry_t1l2+1);
  [worker2dot1l2] worker2=1 & worker2retry_t1l2 >= worker2_maxRetry_t1l2 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..14];
  r1retry_t2l2 : [0..r1_maxRetry_t2l2] init 0;
  r1retry_t2l6 : [0..r1_maxRetry_t2l6] init 0;
  r1retry_t3l8a : [0..r1_maxRetry_t3l8a] init 0;
  r1retry_t2l8c : [0..r1_maxRetry_t2l8c] init 0;
  r1retry_t2l8a : [0..r1_maxRetry_t2l8a] init 0;
  r1retry_t2l8b : [0..r1_maxRetry_t2l8b] init 0;
  r1retry_t3l8b : [0..r1_maxRetry_t3l8b] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1dot2l2Retry] r1=1 & r1retry_t2l2 < r1_maxRetry_t2l2 -> p_r1_t2l2 : (r1'=r1+1) + (1-p_r1_t2l2) : (r1'=r1) & (r1retry_t2l2' = r1retry_t2l2+1);
  [r1dot2l2] r1=1 & r1retry_t2l2 >= r1_maxRetry_t2l2 -> 1:(r1'=r1Fail);
  [r1movel5] r1=2-> 1:(r1'=2+1);
  [r1movel6] r1=3-> 1:(r1'=3+1);
  [r1dot2l6Retry] r1=4 & r1retry_t2l6 < r1_maxRetry_t2l6 -> p_r1_t2l6 : (r1'=r1+1) + (1-p_r1_t2l6) : (r1'=r1) & (r1retry_t2l6' = r1retry_t2l6+1);
  [r1dot2l6] r1=4 & r1retry_t2l6 >= r1_maxRetry_t2l6 -> 1:(r1'=r1Fail);
  [r1movel9] r1=5-> 1:(r1'=5+1);
  [r1movel8] r1=6-> 1:(r1'=6+1);
  [r1dot3l8aRetry] r1=7 & r1retry_t3l8a < r1_maxRetry_t3l8a -> p_r1_t3l8a : (r1'=r1+1) + (1-p_r1_t3l8a) : (r1'=r1) & (r1retry_t3l8a' = r1retry_t3l8a+1);
  [r1dot3l8a] r1=7 & r1retry_t3l8a >= r1_maxRetry_t3l8a -> 1:(r1'=r1Fail);
  [r1dot2l8cRetry] r1=8 & r1retry_t2l8c < r1_maxRetry_t2l8c -> p_r1_t2l8c : (r1'=r1+1) + (1-p_r1_t2l8c) : (r1'=r1) & (r1retry_t2l8c' = r1retry_t2l8c+1);
  [r1dot2l8c] r1=8 & r1retry_t2l8c >= r1_maxRetry_t2l8c -> 1:(r1'=r1Fail);
  [r1dot2l8aRetry] r1=9 & r1retry_t2l8a < r1_maxRetry_t2l8a -> p_r1_t2l8a : (r1'=r1+1) + (1-p_r1_t2l8a) : (r1'=r1) & (r1retry_t2l8a' = r1retry_t2l8a+1);
  [r1dot2l8a] r1=9 & r1retry_t2l8a >= r1_maxRetry_t2l8a -> 1:(r1'=r1Fail);
  [r1dot2l8bRetry] r1=10 & r1retry_t2l8b < r1_maxRetry_t2l8b -> p_r1_t2l8b : (r1'=r1+1) + (1-p_r1_t2l8b) : (r1'=r1) & (r1retry_t2l8b' = r1retry_t2l8b+1);
  [r1dot2l8b] r1=10 & r1retry_t2l8b >= r1_maxRetry_t2l8b -> 1:(r1'=r1Fail);
  [r1dot3l8bRetry] r1=11 & r1retry_t3l8b < r1_maxRetry_t3l8b -> p_r1_t3l8b : (r1'=r1+1) + (1-p_r1_t3l8b) : (r1'=r1) & (r1retry_t3l8b' = r1retry_t3l8b+1);
  [r1dot3l8b] r1=11 & r1retry_t3l8b >= r1_maxRetry_t3l8b -> 1:(r1'=r1Fail);
endmodule

module _worker1
  worker1 : [0..11];
  worker1retry_t1l4 : [0..worker1_maxRetry_t1l4] init 0;
  worker1retry_t3l5 : [0..worker1_maxRetry_t3l5] init 0;
  worker1retry_t1l6a : [0..worker1_maxRetry_t1l6a] init 0;
  worker1retry_t1l6b : [0..worker1_maxRetry_t1l6b] init 0;
  worker1retry_t1l9 : [0..worker1_maxRetry_t1l9] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l4Retry] worker1=1 & worker1retry_t1l4 < worker1_maxRetry_t1l4 -> p_worker1_t1l4 : (worker1'=worker1+1) + (1-p_worker1_t1l4) : (worker1'=worker1) & (worker1retry_t1l4' = worker1retry_t1l4+1);
  [worker1dot1l4] worker1=1 & worker1retry_t1l4 >= worker1_maxRetry_t1l4 -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=2-> 1:(worker1'=2+1);
  [worker1dot3l5Retry] worker1=3 & worker1retry_t3l5 < worker1_maxRetry_t3l5 -> p_worker1_t3l5 : (worker1'=worker1+1) + (1-p_worker1_t3l5) : (worker1'=worker1) & (worker1retry_t3l5' = worker1retry_t3l5+1);
  [worker1dot3l5] worker1=3 & worker1retry_t3l5 >= worker1_maxRetry_t3l5 -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=4-> 1:(worker1'=4+1);
  [worker1dot1l6aRetry] worker1=5 & worker1retry_t1l6a < worker1_maxRetry_t1l6a -> p_worker1_t1l6a : (worker1'=worker1+1) + (1-p_worker1_t1l6a) : (worker1'=worker1) & (worker1retry_t1l6a' = worker1retry_t1l6a+1);
  [worker1dot1l6a] worker1=5 & worker1retry_t1l6a >= worker1_maxRetry_t1l6a -> 1:(worker1'=worker1Fail);
  [worker1dot1l6bRetry] worker1=6 & worker1retry_t1l6b < worker1_maxRetry_t1l6b -> p_worker1_t1l6b : (worker1'=worker1+1) + (1-p_worker1_t1l6b) : (worker1'=worker1) & (worker1retry_t1l6b' = worker1retry_t1l6b+1);
  [worker1dot1l6b] worker1=6 & worker1retry_t1l6b >= worker1_maxRetry_t1l6b -> 1:(worker1'=worker1Fail);
  [worker1movel9] worker1=7-> 1:(worker1'=7+1);
  [worker1dot1l9Retry] worker1=8 & worker1retry_t1l9 < worker1_maxRetry_t1l9 -> p_worker1_t1l9 : (worker1'=worker1+1) + (1-p_worker1_t1l9) : (worker1'=worker1) & (worker1retry_t1l9' = worker1retry_t1l9+1);
  [worker1dot1l9] worker1=8 & worker1retry_t1l9 >= worker1_maxRetry_t1l9 -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [worker2movel2] true:1;
  [worker2dot1l2] true:3;
  [worker2dot1l2Retry] true:3;
  [r1movel2] true:1;
  [r1dot2l2] true:1;
  [r1dot2l2Retry] true:1;
  [r1movel5] true:1;
  [r1movel6] true:1;
  [r1dot2l6] true:1;
  [r1dot2l6Retry] true:1;
  [r1movel9] true:1;
  [r1movel8] true:1;
  [r1dot3l8a] true:1;
  [r1dot3l8aRetry] true:1;
  [r1dot2l8c] true:1;
  [r1dot2l8cRetry] true:1;
  [r1dot2l8a] true:1;
  [r1dot2l8aRetry] true:1;
  [r1dot2l8b] true:1;
  [r1dot2l8bRetry] true:1;
  [r1dot3l8b] true:1;
  [r1dot3l8bRetry] true:1;
  [worker1movel4] true:1;
  [worker1dot1l4] true:3;
  [worker1dot1l4Retry] true:3;
  [worker1movel5] true:1;
  [worker1dot3l5] true:5;
  [worker1dot3l5Retry] true:5;
  [worker1movel6] true:1;
  [worker1dot1l6a] true:3;
  [worker1dot1l6aRetry] true:3;
  [worker1dot1l6b] true:3;
  [worker1dot1l6bRetry] true:3;
  [worker1movel9] true:1;
  [worker1dot1l9] true:3;
  [worker1dot1l9Retry] true:3;
endrewards