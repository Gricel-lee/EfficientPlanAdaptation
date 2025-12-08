dtmc
evolve int worker2_maxRetry_t1l3 [1..5];
evolve int worker2_maxRetry_t1l6a [1..5];
evolve int worker2_maxRetry_t1l6b [1..5];
evolve int worker2_maxRetry_t3l9 [1..5];
evolve int r1_maxRetry_t3l7a [1..10];
evolve int r1_maxRetry_t2l7b [1..10];
evolve int r1_maxRetry_t3l7b [1..10];
evolve int r1_maxRetry_t2l7a [1..10];
evolve int r2_maxRetry_t2l1c [1..10];
evolve int r2_maxRetry_t2l1b [1..10];
evolve int r2_maxRetry_t2l1a [1..10];
evolve int worker1_maxRetry_t1l4b [1..5];
evolve int worker1_maxRetry_t1l4a [1..5];

const double p_worker2_t1l3=1.0;
const double p_worker2_t1l6a=1.0;
const double p_worker2_t1l6b=1.0;
const double p_worker2_t3l9=0.99;
const double p_r1_t3l7a=0.97;
const double p_r1_t2l7b=0.99;
const double p_r1_t3l7b=0.97;
const double p_r1_t2l7a=0.99;
const double p_r2_t2l1c=0.99;
const double p_r2_t2l1b=0.99;
const double p_r2_t2l1a=0.99;
const double p_worker1_t1l4b=1.0;
const double p_worker1_t1l4a=1.0;
const int worker2Final = 8;
const int worker2Fail = 9;
const int r1Final = 6;
const int r1Fail = 7;
const int r2Final = 3;
const int r2Fail = 4;
const int worker1Final = 3;
const int worker1Fail = 4;

module _worker2
  worker2 : [0..10];
  worker2retry_t1l3 : [0..worker2_maxRetry_t1l3] init 0;
  worker2retry_t1l6a : [0..worker2_maxRetry_t1l6a] init 0;
  worker2retry_t1l6b : [0..worker2_maxRetry_t1l6b] init 0;
  worker2retry_t3l9 : [0..worker2_maxRetry_t3l9] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2movel3] worker2=1-> 1:(worker2'=1+1);
  [worker2dot1l3Retry] worker2=2 & worker2retry_t1l3 < worker2_maxRetry_t1l3 -> p_worker2_t1l3 : (worker2'=worker2+1) + (1-p_worker2_t1l3) : (worker2'=worker2) & (worker2retry_t1l3' = worker2retry_t1l3+1);
  [worker2dot1l3] worker2=2 & worker2retry_t1l3 >= worker2_maxRetry_t1l3 -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=3-> 1:(worker2'=3+1);
  [worker2dot1l6aRetry] worker2=4 & worker2retry_t1l6a < worker2_maxRetry_t1l6a -> p_worker2_t1l6a : (worker2'=worker2+1) + (1-p_worker2_t1l6a) : (worker2'=worker2) & (worker2retry_t1l6a' = worker2retry_t1l6a+1);
  [worker2dot1l6a] worker2=4 & worker2retry_t1l6a >= worker2_maxRetry_t1l6a -> 1:(worker2'=worker2Fail);
  [worker2dot1l6bRetry] worker2=5 & worker2retry_t1l6b < worker2_maxRetry_t1l6b -> p_worker2_t1l6b : (worker2'=worker2+1) + (1-p_worker2_t1l6b) : (worker2'=worker2) & (worker2retry_t1l6b' = worker2retry_t1l6b+1);
  [worker2dot1l6b] worker2=5 & worker2retry_t1l6b >= worker2_maxRetry_t1l6b -> 1:(worker2'=worker2Fail);
  [worker2movel9] worker2=6-> 1:(worker2'=6+1);
  [worker2dot3l9Retry] worker2=7 & worker2retry_t3l9 < worker2_maxRetry_t3l9 -> p_worker2_t3l9 : (worker2'=worker2+1) + (1-p_worker2_t3l9) : (worker2'=worker2) & (worker2retry_t3l9' = worker2retry_t3l9+1);
  [worker2dot3l9] worker2=7 & worker2retry_t3l9 >= worker2_maxRetry_t3l9 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..8];
  r1retry_t3l7a : [0..r1_maxRetry_t3l7a] init 0;
  r1retry_t2l7b : [0..r1_maxRetry_t2l7b] init 0;
  r1retry_t3l7b : [0..r1_maxRetry_t3l7b] init 0;
  r1retry_t2l7a : [0..r1_maxRetry_t2l7a] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1movel7] r1=1-> 1:(r1'=1+1);
  [r1dot3l7aRetry] r1=2 & r1retry_t3l7a < r1_maxRetry_t3l7a -> p_r1_t3l7a : (r1'=r1+1) + (1-p_r1_t3l7a) : (r1'=r1) & (r1retry_t3l7a' = r1retry_t3l7a+1);
  [r1dot3l7a] r1=2 & r1retry_t3l7a >= r1_maxRetry_t3l7a -> 1:(r1'=r1Fail);
  [r1dot2l7bRetry] r1=3 & r1retry_t2l7b < r1_maxRetry_t2l7b -> p_r1_t2l7b : (r1'=r1+1) + (1-p_r1_t2l7b) : (r1'=r1) & (r1retry_t2l7b' = r1retry_t2l7b+1);
  [r1dot2l7b] r1=3 & r1retry_t2l7b >= r1_maxRetry_t2l7b -> 1:(r1'=r1Fail);
  [r1dot3l7bRetry] r1=4 & r1retry_t3l7b < r1_maxRetry_t3l7b -> p_r1_t3l7b : (r1'=r1+1) + (1-p_r1_t3l7b) : (r1'=r1) & (r1retry_t3l7b' = r1retry_t3l7b+1);
  [r1dot3l7b] r1=4 & r1retry_t3l7b >= r1_maxRetry_t3l7b -> 1:(r1'=r1Fail);
  [r1dot2l7aRetry] r1=5 & r1retry_t2l7a < r1_maxRetry_t2l7a -> p_r1_t2l7a : (r1'=r1+1) + (1-p_r1_t2l7a) : (r1'=r1) & (r1retry_t2l7a' = r1retry_t2l7a+1);
  [r1dot2l7a] r1=5 & r1retry_t2l7a >= r1_maxRetry_t2l7a -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..5];
  r2retry_t2l1c : [0..r2_maxRetry_t2l1c] init 0;
  r2retry_t2l1b : [0..r2_maxRetry_t2l1b] init 0;
  r2retry_t2l1a : [0..r2_maxRetry_t2l1a] init 0;

  [r2dot2l1cRetry] r2=0 & r2retry_t2l1c < r2_maxRetry_t2l1c -> p_r2_t2l1c : (r2'=r2+1) + (1-p_r2_t2l1c) : (r2'=r2) & (r2retry_t2l1c' = r2retry_t2l1c+1);
  [r2dot2l1c] r2=0 & r2retry_t2l1c >= r2_maxRetry_t2l1c -> 1:(r2'=r2Fail);
  [r2dot2l1bRetry] r2=1 & r2retry_t2l1b < r2_maxRetry_t2l1b -> p_r2_t2l1b : (r2'=r2+1) + (1-p_r2_t2l1b) : (r2'=r2) & (r2retry_t2l1b' = r2retry_t2l1b+1);
  [r2dot2l1b] r2=1 & r2retry_t2l1b >= r2_maxRetry_t2l1b -> 1:(r2'=r2Fail);
  [r2dot2l1aRetry] r2=2 & r2retry_t2l1a < r2_maxRetry_t2l1a -> p_r2_t2l1a : (r2'=r2+1) + (1-p_r2_t2l1a) : (r2'=r2) & (r2retry_t2l1a' = r2retry_t2l1a+1);
  [r2dot2l1a] r2=2 & r2retry_t2l1a >= r2_maxRetry_t2l1a -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..5];
  worker1retry_t1l4b : [0..worker1_maxRetry_t1l4b] init 0;
  worker1retry_t1l4a : [0..worker1_maxRetry_t1l4a] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l4bRetry] worker1=1 & worker1retry_t1l4b < worker1_maxRetry_t1l4b -> p_worker1_t1l4b : (worker1'=worker1+1) + (1-p_worker1_t1l4b) : (worker1'=worker1) & (worker1retry_t1l4b' = worker1retry_t1l4b+1);
  [worker1dot1l4b] worker1=1 & worker1retry_t1l4b >= worker1_maxRetry_t1l4b -> 1:(worker1'=worker1Fail);
  [worker1dot1l4aRetry] worker1=2 & worker1retry_t1l4a < worker1_maxRetry_t1l4a -> p_worker1_t1l4a : (worker1'=worker1+1) + (1-p_worker1_t1l4a) : (worker1'=worker1) & (worker1retry_t1l4a' = worker1retry_t1l4a+1);
  [worker1dot1l4a] worker1=2 & worker1retry_t1l4a >= worker1_maxRetry_t1l4a -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [worker2movel2] true:1;
  [worker2movel3] true:1;
  [worker2dot1l3] true:3;
  [worker2dot1l3Retry] true:3;
  [worker2movel6] true:1;
  [worker2dot1l6a] true:3;
  [worker2dot1l6aRetry] true:3;
  [worker2dot1l6b] true:3;
  [worker2dot1l6bRetry] true:3;
  [worker2movel9] true:1;
  [worker2dot3l9] true:5;
  [worker2dot3l9Retry] true:5;
  [r1movel4] true:1;
  [r1movel7] true:1;
  [r1dot3l7a] true:1;
  [r1dot3l7aRetry] true:1;
  [r1dot2l7b] true:1;
  [r1dot2l7bRetry] true:1;
  [r1dot3l7b] true:1;
  [r1dot3l7bRetry] true:1;
  [r1dot2l7a] true:1;
  [r1dot2l7aRetry] true:1;
  [r2dot2l1c] true:1;
  [r2dot2l1cRetry] true:1;
  [r2dot2l1b] true:1;
  [r2dot2l1bRetry] true:1;
  [r2dot2l1a] true:1;
  [r2dot2l1aRetry] true:1;
  [worker1movel4] true:1;
  [worker1dot1l4b] true:3;
  [worker1dot1l4bRetry] true:3;
  [worker1dot1l4a] true:3;
  [worker1dot1l4aRetry] true:3;
endrewards