dtmc
evolve int r1_maxRetry_t2l1 [1..10];
evolve int r2_maxRetry_t2l2 [1..10];
evolve int r2_maxRetry_t2l3 [1..10];
evolve int worker1_maxRetry_t1l4b [1..5];
evolve int worker1_maxRetry_t3l7 [1..5];
evolve int worker1_maxRetry_t1l7 [1..5];
evolve int worker2_maxRetry_t1l4a [1..5];
evolve int worker2_maxRetry_t3l5b [1..5];
evolve int worker2_maxRetry_t3l5a [1..5];
evolve int worker2_maxRetry_t1l6 [1..5];
evolve int worker2_maxRetry_t3l6 [1..5];
evolve int worker2_maxRetry_t3l9 [1..5];

const double p_r1_t2l1=0.99;
const double p_r2_t2l2=0.99;
const double p_r2_t2l3=0.99;
const double p_worker1_t1l4b=1.0;
const double p_worker1_t3l7=0.99;
const double p_worker1_t1l7=1.0;
const double p_worker2_t1l4a=1.0;
const double p_worker2_t3l5b=0.99;
const double p_worker2_t3l5a=0.99;
const double p_worker2_t1l6=1.0;
const double p_worker2_t3l6=0.99;
const double p_worker2_t3l9=0.99;
const int r1Final = 1;
const int r1Fail = 2;
const int r2Final = 4;
const int r2Fail = 5;
const int worker1Final = 5;
const int worker1Fail = 6;
const int worker2Final = 10;
const int worker2Fail = 11;

module _r1
  r1 : [0..3];
  r1retry_t2l1 : [0..r1_maxRetry_t2l1] init 0;

  [r1dot2l1Retry] r1=0 & r1retry_t2l1 < r1_maxRetry_t2l1 -> p_r1_t2l1 : (r1'=r1+1) + (1-p_r1_t2l1) : (r1'=r1) & (r1retry_t2l1' = r1retry_t2l1+1);
  [r1dot2l1] r1=0 & r1retry_t2l1 >= r1_maxRetry_t2l1 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..6];
  r2retry_t2l2 : [0..r2_maxRetry_t2l2] init 0;
  r2retry_t2l3 : [0..r2_maxRetry_t2l3] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2dot2l2Retry] r2=1 & r2retry_t2l2 < r2_maxRetry_t2l2 -> p_r2_t2l2 : (r2'=r2+1) + (1-p_r2_t2l2) : (r2'=r2) & (r2retry_t2l2' = r2retry_t2l2+1);
  [r2dot2l2] r2=1 & r2retry_t2l2 >= r2_maxRetry_t2l2 -> 1:(r2'=r2Fail);
  [r2movel3] r2=2-> 1:(r2'=2+1);
  [r2dot2l3Retry] r2=3 & r2retry_t2l3 < r2_maxRetry_t2l3 -> p_r2_t2l3 : (r2'=r2+1) + (1-p_r2_t2l3) : (r2'=r2) & (r2retry_t2l3' = r2retry_t2l3+1);
  [r2dot2l3] r2=3 & r2retry_t2l3 >= r2_maxRetry_t2l3 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..7];
  worker1retry_t1l4b : [0..worker1_maxRetry_t1l4b] init 0;
  worker1retry_t3l7 : [0..worker1_maxRetry_t3l7] init 0;
  worker1retry_t1l7 : [0..worker1_maxRetry_t1l7] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l4bRetry] worker1=1 & worker1retry_t1l4b < worker1_maxRetry_t1l4b -> p_worker1_t1l4b : (worker1'=worker1+1) + (1-p_worker1_t1l4b) : (worker1'=worker1) & (worker1retry_t1l4b' = worker1retry_t1l4b+1);
  [worker1dot1l4b] worker1=1 & worker1retry_t1l4b >= worker1_maxRetry_t1l4b -> 1:(worker1'=worker1Fail);
  [worker1movel7] worker1=2-> 1:(worker1'=2+1);
  [worker1dot3l7Retry] worker1=3 & worker1retry_t3l7 < worker1_maxRetry_t3l7 -> p_worker1_t3l7 : (worker1'=worker1+1) + (1-p_worker1_t3l7) : (worker1'=worker1) & (worker1retry_t3l7' = worker1retry_t3l7+1);
  [worker1dot3l7] worker1=3 & worker1retry_t3l7 >= worker1_maxRetry_t3l7 -> 1:(worker1'=worker1Fail);
  [worker1dot1l7Retry] worker1=4 & worker1retry_t1l7 < worker1_maxRetry_t1l7 -> p_worker1_t1l7 : (worker1'=worker1+1) + (1-p_worker1_t1l7) : (worker1'=worker1) & (worker1retry_t1l7' = worker1retry_t1l7+1);
  [worker1dot1l7] worker1=4 & worker1retry_t1l7 >= worker1_maxRetry_t1l7 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..12];
  worker2retry_t1l4a : [0..worker2_maxRetry_t1l4a] init 0;
  worker2retry_t3l5b : [0..worker2_maxRetry_t3l5b] init 0;
  worker2retry_t3l5a : [0..worker2_maxRetry_t3l5a] init 0;
  worker2retry_t1l6 : [0..worker2_maxRetry_t1l6] init 0;
  worker2retry_t3l6 : [0..worker2_maxRetry_t3l6] init 0;
  worker2retry_t3l9 : [0..worker2_maxRetry_t3l9] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2dot1l4aRetry] worker2=1 & worker2retry_t1l4a < worker2_maxRetry_t1l4a -> p_worker2_t1l4a : (worker2'=worker2+1) + (1-p_worker2_t1l4a) : (worker2'=worker2) & (worker2retry_t1l4a' = worker2retry_t1l4a+1);
  [worker2dot1l4a] worker2=1 & worker2retry_t1l4a >= worker2_maxRetry_t1l4a -> 1:(worker2'=worker2Fail);
  [worker2movel5] worker2=2-> 1:(worker2'=2+1);
  [worker2dot3l5bRetry] worker2=3 & worker2retry_t3l5b < worker2_maxRetry_t3l5b -> p_worker2_t3l5b : (worker2'=worker2+1) + (1-p_worker2_t3l5b) : (worker2'=worker2) & (worker2retry_t3l5b' = worker2retry_t3l5b+1);
  [worker2dot3l5b] worker2=3 & worker2retry_t3l5b >= worker2_maxRetry_t3l5b -> 1:(worker2'=worker2Fail);
  [worker2dot3l5aRetry] worker2=4 & worker2retry_t3l5a < worker2_maxRetry_t3l5a -> p_worker2_t3l5a : (worker2'=worker2+1) + (1-p_worker2_t3l5a) : (worker2'=worker2) & (worker2retry_t3l5a' = worker2retry_t3l5a+1);
  [worker2dot3l5a] worker2=4 & worker2retry_t3l5a >= worker2_maxRetry_t3l5a -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=5-> 1:(worker2'=5+1);
  [worker2dot1l6Retry] worker2=6 & worker2retry_t1l6 < worker2_maxRetry_t1l6 -> p_worker2_t1l6 : (worker2'=worker2+1) + (1-p_worker2_t1l6) : (worker2'=worker2) & (worker2retry_t1l6' = worker2retry_t1l6+1);
  [worker2dot1l6] worker2=6 & worker2retry_t1l6 >= worker2_maxRetry_t1l6 -> 1:(worker2'=worker2Fail);
  [worker2dot3l6Retry] worker2=7 & worker2retry_t3l6 < worker2_maxRetry_t3l6 -> p_worker2_t3l6 : (worker2'=worker2+1) + (1-p_worker2_t3l6) : (worker2'=worker2) & (worker2retry_t3l6' = worker2retry_t3l6+1);
  [worker2dot3l6] worker2=7 & worker2retry_t3l6 >= worker2_maxRetry_t3l6 -> 1:(worker2'=worker2Fail);
  [worker2movel9] worker2=8-> 1:(worker2'=8+1);
  [worker2dot3l9Retry] worker2=9 & worker2retry_t3l9 < worker2_maxRetry_t3l9 -> p_worker2_t3l9 : (worker2'=worker2+1) + (1-p_worker2_t3l9) : (worker2'=worker2) & (worker2retry_t3l9' = worker2retry_t3l9+1);
  [worker2dot3l9] worker2=9 & worker2retry_t3l9 >= worker2_maxRetry_t3l9 -> 1:(worker2'=worker2Fail);
endmodule

rewards "cost"
  [r1dot2l1] true:1;
  [r1dot2l1Retry] true:1;
  [r2movel2] true:1;
  [r2dot2l2] true:1;
  [r2dot2l2Retry] true:1;
  [r2movel3] true:1;
  [r2dot2l3] true:1;
  [r2dot2l3Retry] true:1;
  [worker1movel4] true:1;
  [worker1dot1l4b] true:3;
  [worker1dot1l4bRetry] true:3;
  [worker1movel7] true:1;
  [worker1dot3l7] true:5;
  [worker1dot3l7Retry] true:5;
  [worker1dot1l7] true:3;
  [worker1dot1l7Retry] true:3;
  [worker2movel4] true:1;
  [worker2dot1l4a] true:3;
  [worker2dot1l4aRetry] true:3;
  [worker2movel5] true:1;
  [worker2dot3l5b] true:5;
  [worker2dot3l5bRetry] true:5;
  [worker2dot3l5a] true:5;
  [worker2dot3l5aRetry] true:5;
  [worker2movel6] true:1;
  [worker2dot1l6] true:3;
  [worker2dot1l6Retry] true:3;
  [worker2dot3l6] true:5;
  [worker2dot3l6Retry] true:5;
  [worker2movel9] true:1;
  [worker2dot3l9] true:5;
  [worker2dot3l9Retry] true:5;
endrewards