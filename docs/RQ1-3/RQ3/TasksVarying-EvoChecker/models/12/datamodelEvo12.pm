dtmc
evolve int r1_maxRetry_t2l2 [1..10];
evolve int r1_maxRetry_t2l5 [1..10];
evolve int r1_maxRetry_t3l6b [1..10];
evolve int r1_maxRetry_t3l6c [1..10];
evolve int r1_maxRetry_t2l3 [1..10];
evolve int r2_maxRetry_t2l4 [1..10];
evolve int r2_maxRetry_t3l7 [1..10];
evolve int worker1_maxRetry_t1l5a [1..5];
evolve int worker1_maxRetry_t1l5b [1..5];
evolve int worker1_maxRetry_t3l6a [1..5];
evolve int worker1_maxRetry_t3l9 [1..5];
evolve int worker1_maxRetry_t1l9 [1..5];

const double p_r1_t2l2=0.99;
const double p_r1_t2l5=0.99;
const double p_r1_t3l6b=0.97;
const double p_r1_t3l6c=0.97;
const double p_r1_t2l3=0.99;
const double p_r2_t2l4=0.99;
const double p_r2_t3l7=0.97;
const double p_worker1_t1l5a=1.0;
const double p_worker1_t1l5b=1.0;
const double p_worker1_t3l6a=0.99;
const double p_worker1_t3l9=0.99;
const double p_worker1_t1l9=1.0;
const int r1Final = 9;
const int r1Fail = 10;
const int r2Final = 4;
const int r2Fail = 5;
const int worker1Final = 9;
const int worker1Fail = 10;

module _r1
  r1 : [0..11];
  r1retry_t2l2 : [0..r1_maxRetry_t2l2] init 0;
  r1retry_t2l5 : [0..r1_maxRetry_t2l5] init 0;
  r1retry_t3l6b : [0..r1_maxRetry_t3l6b] init 0;
  r1retry_t3l6c : [0..r1_maxRetry_t3l6c] init 0;
  r1retry_t2l3 : [0..r1_maxRetry_t2l3] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1dot2l2Retry] r1=1 & r1retry_t2l2 < r1_maxRetry_t2l2 -> p_r1_t2l2 : (r1'=r1+1) + (1-p_r1_t2l2) : (r1'=r1) & (r1retry_t2l2' = r1retry_t2l2+1);
  [r1dot2l2] r1=1 & r1retry_t2l2 >= r1_maxRetry_t2l2 -> 1:(r1'=r1Fail);
  [r1movel5] r1=2-> 1:(r1'=2+1);
  [r1dot2l5Retry] r1=3 & r1retry_t2l5 < r1_maxRetry_t2l5 -> p_r1_t2l5 : (r1'=r1+1) + (1-p_r1_t2l5) : (r1'=r1) & (r1retry_t2l5' = r1retry_t2l5+1);
  [r1dot2l5] r1=3 & r1retry_t2l5 >= r1_maxRetry_t2l5 -> 1:(r1'=r1Fail);
  [r1movel6] r1=4-> 1:(r1'=4+1);
  [r1dot3l6bRetry] r1=5 & r1retry_t3l6b < r1_maxRetry_t3l6b -> p_r1_t3l6b : (r1'=r1+1) + (1-p_r1_t3l6b) : (r1'=r1) & (r1retry_t3l6b' = r1retry_t3l6b+1);
  [r1dot3l6b] r1=5 & r1retry_t3l6b >= r1_maxRetry_t3l6b -> 1:(r1'=r1Fail);
  [r1dot3l6cRetry] r1=6 & r1retry_t3l6c < r1_maxRetry_t3l6c -> p_r1_t3l6c : (r1'=r1+1) + (1-p_r1_t3l6c) : (r1'=r1) & (r1retry_t3l6c' = r1retry_t3l6c+1);
  [r1dot3l6c] r1=6 & r1retry_t3l6c >= r1_maxRetry_t3l6c -> 1:(r1'=r1Fail);
  [r1movel3] r1=7-> 1:(r1'=7+1);
  [r1dot2l3Retry] r1=8 & r1retry_t2l3 < r1_maxRetry_t2l3 -> p_r1_t2l3 : (r1'=r1+1) + (1-p_r1_t2l3) : (r1'=r1) & (r1retry_t2l3' = r1retry_t2l3+1);
  [r1dot2l3] r1=8 & r1retry_t2l3 >= r1_maxRetry_t2l3 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..6];
  r2retry_t2l4 : [0..r2_maxRetry_t2l4] init 0;
  r2retry_t3l7 : [0..r2_maxRetry_t3l7] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2dot2l4Retry] r2=1 & r2retry_t2l4 < r2_maxRetry_t2l4 -> p_r2_t2l4 : (r2'=r2+1) + (1-p_r2_t2l4) : (r2'=r2) & (r2retry_t2l4' = r2retry_t2l4+1);
  [r2dot2l4] r2=1 & r2retry_t2l4 >= r2_maxRetry_t2l4 -> 1:(r2'=r2Fail);
  [r2movel7] r2=2-> 1:(r2'=2+1);
  [r2dot3l7Retry] r2=3 & r2retry_t3l7 < r2_maxRetry_t3l7 -> p_r2_t3l7 : (r2'=r2+1) + (1-p_r2_t3l7) : (r2'=r2) & (r2retry_t3l7' = r2retry_t3l7+1);
  [r2dot3l7] r2=3 & r2retry_t3l7 >= r2_maxRetry_t3l7 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..11];
  worker1retry_t1l5a : [0..worker1_maxRetry_t1l5a] init 0;
  worker1retry_t1l5b : [0..worker1_maxRetry_t1l5b] init 0;
  worker1retry_t3l6a : [0..worker1_maxRetry_t3l6a] init 0;
  worker1retry_t3l9 : [0..worker1_maxRetry_t3l9] init 0;
  worker1retry_t1l9 : [0..worker1_maxRetry_t1l9] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1movel5] worker1=1-> 1:(worker1'=1+1);
  [worker1dot1l5aRetry] worker1=2 & worker1retry_t1l5a < worker1_maxRetry_t1l5a -> p_worker1_t1l5a : (worker1'=worker1+1) + (1-p_worker1_t1l5a) : (worker1'=worker1) & (worker1retry_t1l5a' = worker1retry_t1l5a+1);
  [worker1dot1l5a] worker1=2 & worker1retry_t1l5a >= worker1_maxRetry_t1l5a -> 1:(worker1'=worker1Fail);
  [worker1dot1l5bRetry] worker1=3 & worker1retry_t1l5b < worker1_maxRetry_t1l5b -> p_worker1_t1l5b : (worker1'=worker1+1) + (1-p_worker1_t1l5b) : (worker1'=worker1) & (worker1retry_t1l5b' = worker1retry_t1l5b+1);
  [worker1dot1l5b] worker1=3 & worker1retry_t1l5b >= worker1_maxRetry_t1l5b -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=4-> 1:(worker1'=4+1);
  [worker1dot3l6aRetry] worker1=5 & worker1retry_t3l6a < worker1_maxRetry_t3l6a -> p_worker1_t3l6a : (worker1'=worker1+1) + (1-p_worker1_t3l6a) : (worker1'=worker1) & (worker1retry_t3l6a' = worker1retry_t3l6a+1);
  [worker1dot3l6a] worker1=5 & worker1retry_t3l6a >= worker1_maxRetry_t3l6a -> 1:(worker1'=worker1Fail);
  [worker1movel9] worker1=6-> 1:(worker1'=6+1);
  [worker1dot3l9Retry] worker1=7 & worker1retry_t3l9 < worker1_maxRetry_t3l9 -> p_worker1_t3l9 : (worker1'=worker1+1) + (1-p_worker1_t3l9) : (worker1'=worker1) & (worker1retry_t3l9' = worker1retry_t3l9+1);
  [worker1dot3l9] worker1=7 & worker1retry_t3l9 >= worker1_maxRetry_t3l9 -> 1:(worker1'=worker1Fail);
  [worker1dot1l9Retry] worker1=8 & worker1retry_t1l9 < worker1_maxRetry_t1l9 -> p_worker1_t1l9 : (worker1'=worker1+1) + (1-p_worker1_t1l9) : (worker1'=worker1) & (worker1retry_t1l9' = worker1retry_t1l9+1);
  [worker1dot1l9] worker1=8 & worker1retry_t1l9 >= worker1_maxRetry_t1l9 -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [r1movel2] true:1;
  [r1dot2l2] true:1;
  [r1dot2l2Retry] true:1;
  [r1movel5] true:1;
  [r1dot2l5] true:1;
  [r1dot2l5Retry] true:1;
  [r1movel6] true:1;
  [r1dot3l6b] true:1;
  [r1dot3l6bRetry] true:1;
  [r1dot3l6c] true:1;
  [r1dot3l6cRetry] true:1;
  [r1movel3] true:1;
  [r1dot2l3] true:1;
  [r1dot2l3Retry] true:1;
  [r2movel4] true:1;
  [r2dot2l4] true:1;
  [r2dot2l4Retry] true:1;
  [r2movel7] true:1;
  [r2dot3l7] true:1;
  [r2dot3l7Retry] true:1;
  [worker1movel4] true:1;
  [worker1movel5] true:1;
  [worker1dot1l5a] true:3;
  [worker1dot1l5aRetry] true:3;
  [worker1dot1l5b] true:3;
  [worker1dot1l5bRetry] true:3;
  [worker1movel6] true:1;
  [worker1dot3l6a] true:5;
  [worker1dot3l6aRetry] true:5;
  [worker1movel9] true:1;
  [worker1dot3l9] true:5;
  [worker1dot3l9Retry] true:5;
  [worker1dot1l9] true:3;
  [worker1dot1l9Retry] true:3;
endrewards