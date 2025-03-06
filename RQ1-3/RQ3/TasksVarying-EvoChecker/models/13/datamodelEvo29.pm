dtmc
evolve int worker2_maxRetry_t1l2 [1..5];
evolve int r1_maxRetry_t3l6 [1..10];
evolve int r1_maxRetry_t2l6 [1..10];
evolve int r1_maxRetry_t2l9 [1..10];
evolve int r1_maxRetry_t2l7b [1..10];
evolve int r1_maxRetry_t3l7 [1..10];
evolve int r1_maxRetry_t2l7a [1..10];
evolve int r2_maxRetry_t2l1b [1..10];
evolve int r2_maxRetry_t3l1 [1..10];
evolve int r2_maxRetry_t2l1a [1..10];
evolve int worker1_maxRetry_t1l4 [1..5];
evolve int worker1_maxRetry_t1l6 [1..5];
evolve int worker1_maxRetry_t1l9 [1..5];

const double p_worker2_t1l2=1.0;
const double p_r1_t3l6=0.97;
const double p_r1_t2l6=0.99;
const double p_r1_t2l9=0.99;
const double p_r1_t2l7b=0.99;
const double p_r1_t3l7=0.97;
const double p_r1_t2l7a=0.99;
const double p_r2_t2l1b=0.99;
const double p_r2_t3l1=0.97;
const double p_r2_t2l1a=0.99;
const double p_worker1_t1l4=1.0;
const double p_worker1_t1l6=1.0;
const double p_worker1_t1l9=1.0;
const int worker2Final = 2;
const int worker2Fail = 3;
const int r1Final = 12;
const int r1Fail = 13;
const int r2Final = 3;
const int r2Fail = 4;
const int worker1Final = 7;
const int worker1Fail = 8;

module _worker2
  worker2 : [0..4];
  worker2retry_t1l2 : [0..worker2_maxRetry_t1l2] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l2Retry] worker2=1 & worker2retry_t1l2 < worker2_maxRetry_t1l2 -> p_worker2_t1l2 : (worker2'=worker2+1) + (1-p_worker2_t1l2) : (worker2'=worker2) & (worker2retry_t1l2' = worker2retry_t1l2+1);
  [worker2dot1l2] worker2=1 & worker2retry_t1l2 >= worker2_maxRetry_t1l2 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..14];
  r1retry_t3l6 : [0..r1_maxRetry_t3l6] init 0;
  r1retry_t2l6 : [0..r1_maxRetry_t2l6] init 0;
  r1retry_t2l9 : [0..r1_maxRetry_t2l9] init 0;
  r1retry_t2l7b : [0..r1_maxRetry_t2l7b] init 0;
  r1retry_t3l7 : [0..r1_maxRetry_t3l7] init 0;
  r1retry_t2l7a : [0..r1_maxRetry_t2l7a] init 0;

  [r1movel2] r1=0-> 1:(r1'=0+1);
  [r1movel3] r1=1-> 1:(r1'=1+1);
  [r1movel6] r1=2-> 1:(r1'=2+1);
  [r1dot3l6Retry] r1=3 & r1retry_t3l6 < r1_maxRetry_t3l6 -> p_r1_t3l6 : (r1'=r1+1) + (1-p_r1_t3l6) : (r1'=r1) & (r1retry_t3l6' = r1retry_t3l6+1);
  [r1dot3l6] r1=3 & r1retry_t3l6 >= r1_maxRetry_t3l6 -> 1:(r1'=r1Fail);
  [r1dot2l6Retry] r1=4 & r1retry_t2l6 < r1_maxRetry_t2l6 -> p_r1_t2l6 : (r1'=r1+1) + (1-p_r1_t2l6) : (r1'=r1) & (r1retry_t2l6' = r1retry_t2l6+1);
  [r1dot2l6] r1=4 & r1retry_t2l6 >= r1_maxRetry_t2l6 -> 1:(r1'=r1Fail);
  [r1movel9] r1=5-> 1:(r1'=5+1);
  [r1dot2l9Retry] r1=6 & r1retry_t2l9 < r1_maxRetry_t2l9 -> p_r1_t2l9 : (r1'=r1+1) + (1-p_r1_t2l9) : (r1'=r1) & (r1retry_t2l9' = r1retry_t2l9+1);
  [r1dot2l9] r1=6 & r1retry_t2l9 >= r1_maxRetry_t2l9 -> 1:(r1'=r1Fail);
  [r1movel8] r1=7-> 1:(r1'=7+1);
  [r1movel7] r1=8-> 1:(r1'=8+1);
  [r1dot2l7bRetry] r1=9 & r1retry_t2l7b < r1_maxRetry_t2l7b -> p_r1_t2l7b : (r1'=r1+1) + (1-p_r1_t2l7b) : (r1'=r1) & (r1retry_t2l7b' = r1retry_t2l7b+1);
  [r1dot2l7b] r1=9 & r1retry_t2l7b >= r1_maxRetry_t2l7b -> 1:(r1'=r1Fail);
  [r1dot3l7Retry] r1=10 & r1retry_t3l7 < r1_maxRetry_t3l7 -> p_r1_t3l7 : (r1'=r1+1) + (1-p_r1_t3l7) : (r1'=r1) & (r1retry_t3l7' = r1retry_t3l7+1);
  [r1dot3l7] r1=10 & r1retry_t3l7 >= r1_maxRetry_t3l7 -> 1:(r1'=r1Fail);
  [r1dot2l7aRetry] r1=11 & r1retry_t2l7a < r1_maxRetry_t2l7a -> p_r1_t2l7a : (r1'=r1+1) + (1-p_r1_t2l7a) : (r1'=r1) & (r1retry_t2l7a' = r1retry_t2l7a+1);
  [r1dot2l7a] r1=11 & r1retry_t2l7a >= r1_maxRetry_t2l7a -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..5];
  r2retry_t2l1b : [0..r2_maxRetry_t2l1b] init 0;
  r2retry_t3l1 : [0..r2_maxRetry_t3l1] init 0;
  r2retry_t2l1a : [0..r2_maxRetry_t2l1a] init 0;

  [r2dot2l1bRetry] r2=0 & r2retry_t2l1b < r2_maxRetry_t2l1b -> p_r2_t2l1b : (r2'=r2+1) + (1-p_r2_t2l1b) : (r2'=r2) & (r2retry_t2l1b' = r2retry_t2l1b+1);
  [r2dot2l1b] r2=0 & r2retry_t2l1b >= r2_maxRetry_t2l1b -> 1:(r2'=r2Fail);
  [r2dot3l1Retry] r2=1 & r2retry_t3l1 < r2_maxRetry_t3l1 -> p_r2_t3l1 : (r2'=r2+1) + (1-p_r2_t3l1) : (r2'=r2) & (r2retry_t3l1' = r2retry_t3l1+1);
  [r2dot3l1] r2=1 & r2retry_t3l1 >= r2_maxRetry_t3l1 -> 1:(r2'=r2Fail);
  [r2dot2l1aRetry] r2=2 & r2retry_t2l1a < r2_maxRetry_t2l1a -> p_r2_t2l1a : (r2'=r2+1) + (1-p_r2_t2l1a) : (r2'=r2) & (r2retry_t2l1a' = r2retry_t2l1a+1);
  [r2dot2l1a] r2=2 & r2retry_t2l1a >= r2_maxRetry_t2l1a -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..9];
  worker1retry_t1l4 : [0..worker1_maxRetry_t1l4] init 0;
  worker1retry_t1l6 : [0..worker1_maxRetry_t1l6] init 0;
  worker1retry_t1l9 : [0..worker1_maxRetry_t1l9] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l4Retry] worker1=1 & worker1retry_t1l4 < worker1_maxRetry_t1l4 -> p_worker1_t1l4 : (worker1'=worker1+1) + (1-p_worker1_t1l4) : (worker1'=worker1) & (worker1retry_t1l4' = worker1retry_t1l4+1);
  [worker1dot1l4] worker1=1 & worker1retry_t1l4 >= worker1_maxRetry_t1l4 -> 1:(worker1'=worker1Fail);
  [worker1movel5] worker1=2-> 1:(worker1'=2+1);
  [worker1movel6] worker1=3-> 1:(worker1'=3+1);
  [worker1dot1l6Retry] worker1=4 & worker1retry_t1l6 < worker1_maxRetry_t1l6 -> p_worker1_t1l6 : (worker1'=worker1+1) + (1-p_worker1_t1l6) : (worker1'=worker1) & (worker1retry_t1l6' = worker1retry_t1l6+1);
  [worker1dot1l6] worker1=4 & worker1retry_t1l6 >= worker1_maxRetry_t1l6 -> 1:(worker1'=worker1Fail);
  [worker1movel9] worker1=5-> 1:(worker1'=5+1);
  [worker1dot1l9Retry] worker1=6 & worker1retry_t1l9 < worker1_maxRetry_t1l9 -> p_worker1_t1l9 : (worker1'=worker1+1) + (1-p_worker1_t1l9) : (worker1'=worker1) & (worker1retry_t1l9' = worker1retry_t1l9+1);
  [worker1dot1l9] worker1=6 & worker1retry_t1l9 >= worker1_maxRetry_t1l9 -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [worker2movel2] true:1;
  [worker2dot1l2] true:3;
  [worker2dot1l2Retry] true:3;
  [r1movel2] true:1;
  [r1movel3] true:1;
  [r1movel6] true:1;
  [r1dot3l6] true:1;
  [r1dot3l6Retry] true:1;
  [r1dot2l6] true:1;
  [r1dot2l6Retry] true:1;
  [r1movel9] true:1;
  [r1dot2l9] true:1;
  [r1dot2l9Retry] true:1;
  [r1movel8] true:1;
  [r1movel7] true:1;
  [r1dot2l7b] true:1;
  [r1dot2l7bRetry] true:1;
  [r1dot3l7] true:1;
  [r1dot3l7Retry] true:1;
  [r1dot2l7a] true:1;
  [r1dot2l7aRetry] true:1;
  [r2dot2l1b] true:1;
  [r2dot2l1bRetry] true:1;
  [r2dot3l1] true:1;
  [r2dot3l1Retry] true:1;
  [r2dot2l1a] true:1;
  [r2dot2l1aRetry] true:1;
  [worker1movel4] true:1;
  [worker1dot1l4] true:3;
  [worker1dot1l4Retry] true:3;
  [worker1movel5] true:1;
  [worker1movel6] true:1;
  [worker1dot1l6] true:3;
  [worker1dot1l6Retry] true:3;
  [worker1movel9] true:1;
  [worker1dot1l9] true:3;
  [worker1dot1l9Retry] true:3;
endrewards