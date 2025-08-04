dtmc
evolve int worker1_maxRetry_t1l2 [1..5];
evolve int worker1_maxRetry_t1l3 [1..5];
evolve int worker1_maxRetry_t1l6 [1..5];
evolve int worker1_maxRetry_t3l6 [1..5];
evolve int worker2_maxRetry_t1l1b [1..5];
evolve int worker2_maxRetry_t1l1a [1..5];
evolve int worker2_maxRetry_t1l1c [1..5];
evolve int r1_maxRetry_t2l5 [1..10];
evolve int r1_maxRetry_t2l8 [1..10];
evolve int r1_maxRetry_t3l8 [1..10];
evolve int r1_maxRetry_t3l9 [1..10];

const double p_worker1_t1l2=1.0;
const double p_worker1_t1l3=1.0;
const double p_worker1_t1l6=1.0;
const double p_worker1_t3l6=0.99;
const double p_worker2_t1l1b=1.0;
const double p_worker2_t1l1a=1.0;
const double p_worker2_t1l1c=1.0;
const double p_r1_t2l5=0.99;
const double p_r1_t2l8=0.99;
const double p_r1_t3l8=0.97;
const double p_r1_t3l9=0.97;
const int worker1Final = 7;
const int worker1Fail = 8;
const int worker2Final = 3;
const int worker2Fail = 4;
const int r1Final = 8;
const int r1Fail = 9;

module _worker1
  worker1 : [0..9];
  worker1retry_t1l2 : [0..worker1_maxRetry_t1l2] init 0;
  worker1retry_t1l3 : [0..worker1_maxRetry_t1l3] init 0;
  worker1retry_t1l6 : [0..worker1_maxRetry_t1l6] init 0;
  worker1retry_t3l6 : [0..worker1_maxRetry_t3l6] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l2Retry] worker1=1 & worker1retry_t1l2 < worker1_maxRetry_t1l2 -> p_worker1_t1l2 : (worker1'=worker1+1) + (1-p_worker1_t1l2) : (worker1'=worker1) & (worker1retry_t1l2' = worker1retry_t1l2+1);
  [worker1dot1l2] worker1=1 & worker1retry_t1l2 >= worker1_maxRetry_t1l2 -> 1:(worker1'=worker1Fail);
  [worker1movel3] worker1=2-> 1:(worker1'=2+1);
  [worker1dot1l3Retry] worker1=3 & worker1retry_t1l3 < worker1_maxRetry_t1l3 -> p_worker1_t1l3 : (worker1'=worker1+1) + (1-p_worker1_t1l3) : (worker1'=worker1) & (worker1retry_t1l3' = worker1retry_t1l3+1);
  [worker1dot1l3] worker1=3 & worker1retry_t1l3 >= worker1_maxRetry_t1l3 -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=4-> 1:(worker1'=4+1);
  [worker1dot1l6Retry] worker1=5 & worker1retry_t1l6 < worker1_maxRetry_t1l6 -> p_worker1_t1l6 : (worker1'=worker1+1) + (1-p_worker1_t1l6) : (worker1'=worker1) & (worker1retry_t1l6' = worker1retry_t1l6+1);
  [worker1dot1l6] worker1=5 & worker1retry_t1l6 >= worker1_maxRetry_t1l6 -> 1:(worker1'=worker1Fail);
  [worker1dot3l6Retry] worker1=6 & worker1retry_t3l6 < worker1_maxRetry_t3l6 -> p_worker1_t3l6 : (worker1'=worker1+1) + (1-p_worker1_t3l6) : (worker1'=worker1) & (worker1retry_t3l6' = worker1retry_t3l6+1);
  [worker1dot3l6] worker1=6 & worker1retry_t3l6 >= worker1_maxRetry_t3l6 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..5];
  worker2retry_t1l1b : [0..worker2_maxRetry_t1l1b] init 0;
  worker2retry_t1l1a : [0..worker2_maxRetry_t1l1a] init 0;
  worker2retry_t1l1c : [0..worker2_maxRetry_t1l1c] init 0;

  [worker2dot1l1bRetry] worker2=0 & worker2retry_t1l1b < worker2_maxRetry_t1l1b -> p_worker2_t1l1b : (worker2'=worker2+1) + (1-p_worker2_t1l1b) : (worker2'=worker2) & (worker2retry_t1l1b' = worker2retry_t1l1b+1);
  [worker2dot1l1b] worker2=0 & worker2retry_t1l1b >= worker2_maxRetry_t1l1b -> 1:(worker2'=worker2Fail);
  [worker2dot1l1aRetry] worker2=1 & worker2retry_t1l1a < worker2_maxRetry_t1l1a -> p_worker2_t1l1a : (worker2'=worker2+1) + (1-p_worker2_t1l1a) : (worker2'=worker2) & (worker2retry_t1l1a' = worker2retry_t1l1a+1);
  [worker2dot1l1a] worker2=1 & worker2retry_t1l1a >= worker2_maxRetry_t1l1a -> 1:(worker2'=worker2Fail);
  [worker2dot1l1cRetry] worker2=2 & worker2retry_t1l1c < worker2_maxRetry_t1l1c -> p_worker2_t1l1c : (worker2'=worker2+1) + (1-p_worker2_t1l1c) : (worker2'=worker2) & (worker2retry_t1l1c' = worker2retry_t1l1c+1);
  [worker2dot1l1c] worker2=2 & worker2retry_t1l1c >= worker2_maxRetry_t1l1c -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..10];
  r1retry_t2l5 : [0..r1_maxRetry_t2l5] init 0;
  r1retry_t2l8 : [0..r1_maxRetry_t2l8] init 0;
  r1retry_t3l8 : [0..r1_maxRetry_t3l8] init 0;
  r1retry_t3l9 : [0..r1_maxRetry_t3l9] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1movel5] r1=1-> 1:(r1'=1+1);
  [r1dot2l5Retry] r1=2 & r1retry_t2l5 < r1_maxRetry_t2l5 -> p_r1_t2l5 : (r1'=r1+1) + (1-p_r1_t2l5) : (r1'=r1) & (r1retry_t2l5' = r1retry_t2l5+1);
  [r1dot2l5] r1=2 & r1retry_t2l5 >= r1_maxRetry_t2l5 -> 1:(r1'=r1Fail);
  [r1movel8] r1=3-> 1:(r1'=3+1);
  [r1dot2l8Retry] r1=4 & r1retry_t2l8 < r1_maxRetry_t2l8 -> p_r1_t2l8 : (r1'=r1+1) + (1-p_r1_t2l8) : (r1'=r1) & (r1retry_t2l8' = r1retry_t2l8+1);
  [r1dot2l8] r1=4 & r1retry_t2l8 >= r1_maxRetry_t2l8 -> 1:(r1'=r1Fail);
  [r1dot3l8Retry] r1=5 & r1retry_t3l8 < r1_maxRetry_t3l8 -> p_r1_t3l8 : (r1'=r1+1) + (1-p_r1_t3l8) : (r1'=r1) & (r1retry_t3l8' = r1retry_t3l8+1);
  [r1dot3l8] r1=5 & r1retry_t3l8 >= r1_maxRetry_t3l8 -> 1:(r1'=r1Fail);
  [r1movel9] r1=6-> 1:(r1'=6+1);
  [r1dot3l9Retry] r1=7 & r1retry_t3l9 < r1_maxRetry_t3l9 -> p_r1_t3l9 : (r1'=r1+1) + (1-p_r1_t3l9) : (r1'=r1) & (r1retry_t3l9' = r1retry_t3l9+1);
  [r1dot3l9] r1=7 & r1retry_t3l9 >= r1_maxRetry_t3l9 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [worker1movel2] true:1;
  [worker1dot1l2] true:3;
  [worker1dot1l2Retry] true:3;
  [worker1movel3] true:1;
  [worker1dot1l3] true:3;
  [worker1dot1l3Retry] true:3;
  [worker1movel6] true:1;
  [worker1dot1l6] true:3;
  [worker1dot1l6Retry] true:3;
  [worker1dot3l6] true:5;
  [worker1dot3l6Retry] true:5;
  [worker2dot1l1b] true:3;
  [worker2dot1l1bRetry] true:3;
  [worker2dot1l1a] true:3;
  [worker2dot1l1aRetry] true:3;
  [worker2dot1l1c] true:3;
  [worker2dot1l1cRetry] true:3;
  [r1movel4] true:1;
  [r1movel5] true:1;
  [r1dot2l5] true:1;
  [r1dot2l5Retry] true:1;
  [r1movel8] true:1;
  [r1dot2l8] true:1;
  [r1dot2l8Retry] true:1;
  [r1dot3l8] true:1;
  [r1dot3l8Retry] true:1;
  [r1movel9] true:1;
  [r1dot3l9] true:1;
  [r1dot3l9Retry] true:1;
endrewards