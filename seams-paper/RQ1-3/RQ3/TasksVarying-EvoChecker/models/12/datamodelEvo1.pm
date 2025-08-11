dtmc
evolve int r2_maxRetry_t3l8b [1..10];
evolve int r2_maxRetry_t3l8a [1..10];
evolve int r2_maxRetry_t2l8 [1..10];
evolve int r2_maxRetry_t2l6 [1..10];
evolve int worker1_maxRetry_t3l4a [1..5];
evolve int worker1_maxRetry_t3l4c [1..5];
evolve int worker1_maxRetry_t3l4b [1..5];
evolve int worker1_maxRetry_t1l5b [1..5];
evolve int worker1_maxRetry_t1l5a [1..5];
evolve int worker1_maxRetry_t1l6 [1..5];
evolve int worker1_maxRetry_t1l9 [1..5];
evolve int worker2_maxRetry_t1l7 [1..5];

const double p_r2_t3l8b=0.97;
const double p_r2_t3l8a=0.97;
const double p_r2_t2l8=0.99;
const double p_r2_t2l6=0.99;
const double p_worker1_t3l4a=0.99;
const double p_worker1_t3l4c=0.99;
const double p_worker1_t3l4b=0.99;
const double p_worker1_t1l5b=1.0;
const double p_worker1_t1l5a=1.0;
const double p_worker1_t1l6=1.0;
const double p_worker1_t1l9=1.0;
const double p_worker2_t1l7=1.0;
const int r2Final = 9;
const int r2Fail = 10;
const int worker1Final = 11;
const int worker1Fail = 12;
const int worker2Final = 3;
const int worker2Fail = 4;

module _r2
  r2 : [0..11];
  r2retry_t3l8b : [0..r2_maxRetry_t3l8b] init 0;
  r2retry_t3l8a : [0..r2_maxRetry_t3l8a] init 0;
  r2retry_t2l8 : [0..r2_maxRetry_t2l8] init 0;
  r2retry_t2l6 : [0..r2_maxRetry_t2l6] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2movel7] r2=1-> 1:(r2'=1+1);
  [r2movel8] r2=2-> 1:(r2'=2+1);
  [r2dot3l8bRetry] r2=3 & r2retry_t3l8b < r2_maxRetry_t3l8b -> p_r2_t3l8b : (r2'=r2+1) + (1-p_r2_t3l8b) : (r2'=r2) & (r2retry_t3l8b' = r2retry_t3l8b+1);
  [r2dot3l8b] r2=3 & r2retry_t3l8b >= r2_maxRetry_t3l8b -> 1:(r2'=r2Fail);
  [r2dot3l8aRetry] r2=4 & r2retry_t3l8a < r2_maxRetry_t3l8a -> p_r2_t3l8a : (r2'=r2+1) + (1-p_r2_t3l8a) : (r2'=r2) & (r2retry_t3l8a' = r2retry_t3l8a+1);
  [r2dot3l8a] r2=4 & r2retry_t3l8a >= r2_maxRetry_t3l8a -> 1:(r2'=r2Fail);
  [r2dot2l8Retry] r2=5 & r2retry_t2l8 < r2_maxRetry_t2l8 -> p_r2_t2l8 : (r2'=r2+1) + (1-p_r2_t2l8) : (r2'=r2) & (r2retry_t2l8' = r2retry_t2l8+1);
  [r2dot2l8] r2=5 & r2retry_t2l8 >= r2_maxRetry_t2l8 -> 1:(r2'=r2Fail);
  [r2movel5] r2=6-> 1:(r2'=6+1);
  [r2movel6] r2=7-> 1:(r2'=7+1);
  [r2dot2l6Retry] r2=8 & r2retry_t2l6 < r2_maxRetry_t2l6 -> p_r2_t2l6 : (r2'=r2+1) + (1-p_r2_t2l6) : (r2'=r2) & (r2retry_t2l6' = r2retry_t2l6+1);
  [r2dot2l6] r2=8 & r2retry_t2l6 >= r2_maxRetry_t2l6 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..13];
  worker1retry_t3l4a : [0..worker1_maxRetry_t3l4a] init 0;
  worker1retry_t3l4c : [0..worker1_maxRetry_t3l4c] init 0;
  worker1retry_t3l4b : [0..worker1_maxRetry_t3l4b] init 0;
  worker1retry_t1l5b : [0..worker1_maxRetry_t1l5b] init 0;
  worker1retry_t1l5a : [0..worker1_maxRetry_t1l5a] init 0;
  worker1retry_t1l6 : [0..worker1_maxRetry_t1l6] init 0;
  worker1retry_t1l9 : [0..worker1_maxRetry_t1l9] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot3l4aRetry] worker1=1 & worker1retry_t3l4a < worker1_maxRetry_t3l4a -> p_worker1_t3l4a : (worker1'=worker1+1) + (1-p_worker1_t3l4a) : (worker1'=worker1) & (worker1retry_t3l4a' = worker1retry_t3l4a+1);
  [worker1dot3l4a] worker1=1 & worker1retry_t3l4a >= worker1_maxRetry_t3l4a -> 1:(worker1'=worker1Fail);
  [worker1dot3l4cRetry] worker1=2 & worker1retry_t3l4c < worker1_maxRetry_t3l4c -> p_worker1_t3l4c : (worker1'=worker1+1) + (1-p_worker1_t3l4c) : (worker1'=worker1) & (worker1retry_t3l4c' = worker1retry_t3l4c+1);
  [worker1dot3l4c] worker1=2 & worker1retry_t3l4c >= worker1_maxRetry_t3l4c -> 1:(worker1'=worker1Fail);
  [worker1dot3l4bRetry] worker1=3 & worker1retry_t3l4b < worker1_maxRetry_t3l4b -> p_worker1_t3l4b : (worker1'=worker1+1) + (1-p_worker1_t3l4b) : (worker1'=worker1) & (worker1retry_t3l4b' = worker1retry_t3l4b+1);
  [worker1dot3l4b] worker1=3 & worker1retry_t3l4b >= worker1_maxRetry_t3l4b -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=4-> 1:(worker1'=4+1);
  [worker1dot1l5bRetry] worker1=5 & worker1retry_t1l5b < worker1_maxRetry_t1l5b -> p_worker1_t1l5b : (worker1'=worker1+1) + (1-p_worker1_t1l5b) : (worker1'=worker1) & (worker1retry_t1l5b' = worker1retry_t1l5b+1);
  [worker1dot1l5b] worker1=5 & worker1retry_t1l5b >= worker1_maxRetry_t1l5b -> 1:(worker1'=worker1Fail);
  [worker1dot1l5aRetry] worker1=6 & worker1retry_t1l5a < worker1_maxRetry_t1l5a -> p_worker1_t1l5a : (worker1'=worker1+1) + (1-p_worker1_t1l5a) : (worker1'=worker1) & (worker1retry_t1l5a' = worker1retry_t1l5a+1);
  [worker1dot1l5a] worker1=6 & worker1retry_t1l5a >= worker1_maxRetry_t1l5a -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=7-> 1:(worker1'=7+1);
  [worker1dot1l6Retry] worker1=8 & worker1retry_t1l6 < worker1_maxRetry_t1l6 -> p_worker1_t1l6 : (worker1'=worker1+1) + (1-p_worker1_t1l6) : (worker1'=worker1) & (worker1retry_t1l6' = worker1retry_t1l6+1);
  [worker1dot1l6] worker1=8 & worker1retry_t1l6 >= worker1_maxRetry_t1l6 -> 1:(worker1'=worker1Fail);
  [worker1movel9] worker1=9-> 1:(worker1'=9+1);
  [worker1dot1l9Retry] worker1=10 & worker1retry_t1l9 < worker1_maxRetry_t1l9 -> p_worker1_t1l9 : (worker1'=worker1+1) + (1-p_worker1_t1l9) : (worker1'=worker1) & (worker1retry_t1l9' = worker1retry_t1l9+1);
  [worker1dot1l9] worker1=10 & worker1retry_t1l9 >= worker1_maxRetry_t1l9 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..5];
  worker2retry_t1l7 : [0..worker2_maxRetry_t1l7] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2movel7] worker2=1-> 1:(worker2'=1+1);
  [worker2dot1l7Retry] worker2=2 & worker2retry_t1l7 < worker2_maxRetry_t1l7 -> p_worker2_t1l7 : (worker2'=worker2+1) + (1-p_worker2_t1l7) : (worker2'=worker2) & (worker2retry_t1l7' = worker2retry_t1l7+1);
  [worker2dot1l7] worker2=2 & worker2retry_t1l7 >= worker2_maxRetry_t1l7 -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r2movel4] true:1;
  [r2movel7] true:1;
  [r2movel8] true:1;
  [r2dot3l8b] true:1;
  [r2dot3l8bRetry] true:1;
  [r2dot3l8a] true:1;
  [r2dot3l8aRetry] true:1;
  [r2dot2l8] true:1;
  [r2dot2l8Retry] true:1;
  [r2movel5] true:1;
  [r2movel6] true:1;
  [r2dot2l6] true:1;
  [r2dot2l6Retry] true:1;
  [worker1movel4] true:1;
  [worker1dot3l4a] true:5;
  [worker1dot3l4aRetry] true:5;
  [worker1dot3l4c] true:5;
  [worker1dot3l4cRetry] true:5;
  [worker1dot3l4b] true:5;
  [worker1dot3l4bRetry] true:5;
  [worker1movel5] true:1;
  [worker1dot1l5b] true:3;
  [worker1dot1l5bRetry] true:3;
  [worker1dot1l5a] true:3;
  [worker1dot1l5aRetry] true:3;
  [worker1movel6] true:1;
  [worker1dot1l6] true:3;
  [worker1dot1l6Retry] true:3;
  [worker1movel9] true:1;
  [worker1dot1l9] true:3;
  [worker1dot1l9Retry] true:3;
  [worker2movel4] true:1;
  [worker2movel7] true:1;
  [worker2dot1l7] true:3;
  [worker2dot1l7Retry] true:3;
endrewards