dtmc
evolve int worker1_maxRetry_t1l1 [1..5];
evolve int worker1_maxRetry_t3l1 [1..5];
evolve int worker1_maxRetry_t1l4 [1..5];
evolve int worker2_maxRetry_t3l3 [1..5];
evolve int worker2_maxRetry_t3l6b [1..5];
evolve int worker2_maxRetry_t3l6a [1..5];
evolve int worker2_maxRetry_t1l9 [1..5];
evolve int r1_maxRetry_t2l1 [1..10];
evolve int r2_maxRetry_t2l4 [1..10];
evolve int r2_maxRetry_t2l7 [1..10];

const double p_worker1_t1l1=1.0;
const double p_worker1_t3l1=0.99;
const double p_worker1_t1l4=1.0;
const double p_worker2_t3l3=0.99;
const double p_worker2_t3l6b=0.99;
const double p_worker2_t3l6a=0.99;
const double p_worker2_t1l9=1.0;
const double p_r1_t2l1=0.99;
const double p_r2_t2l4=0.99;
const double p_r2_t2l7=0.99;
const int worker1Final = 4;
const int worker1Fail = 5;
const int worker2Final = 8;
const int worker2Fail = 9;
const int r1Final = 1;
const int r1Fail = 2;
const int r2Final = 4;
const int r2Fail = 5;

module _worker1
  worker1 : [0..6];
  worker1retry_t1l1 : [0..worker1_maxRetry_t1l1] init 0;
  worker1retry_t3l1 : [0..worker1_maxRetry_t3l1] init 0;
  worker1retry_t1l4 : [0..worker1_maxRetry_t1l4] init 0;

  [worker1dot1l1Retry] worker1=0 & worker1retry_t1l1 < worker1_maxRetry_t1l1 -> p_worker1_t1l1 : (worker1'=worker1+1) + (1-p_worker1_t1l1) : (worker1'=worker1) & (worker1retry_t1l1' = worker1retry_t1l1+1);
  [worker1dot1l1] worker1=0 & worker1retry_t1l1 >= worker1_maxRetry_t1l1 -> 1:(worker1'=worker1Fail);
  [worker1dot3l1Retry] worker1=1 & worker1retry_t3l1 < worker1_maxRetry_t3l1 -> p_worker1_t3l1 : (worker1'=worker1+1) + (1-p_worker1_t3l1) : (worker1'=worker1) & (worker1retry_t3l1' = worker1retry_t3l1+1);
  [worker1dot3l1] worker1=1 & worker1retry_t3l1 >= worker1_maxRetry_t3l1 -> 1:(worker1'=worker1Fail);
  [worker1movel4] worker1=2-> 1:(worker1'=2+1);
  [worker1dot1l4Retry] worker1=3 & worker1retry_t1l4 < worker1_maxRetry_t1l4 -> p_worker1_t1l4 : (worker1'=worker1+1) + (1-p_worker1_t1l4) : (worker1'=worker1) & (worker1retry_t1l4' = worker1retry_t1l4+1);
  [worker1dot1l4] worker1=3 & worker1retry_t1l4 >= worker1_maxRetry_t1l4 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..10];
  worker2retry_t3l3 : [0..worker2_maxRetry_t3l3] init 0;
  worker2retry_t3l6b : [0..worker2_maxRetry_t3l6b] init 0;
  worker2retry_t3l6a : [0..worker2_maxRetry_t3l6a] init 0;
  worker2retry_t1l9 : [0..worker2_maxRetry_t1l9] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2movel3] worker2=1-> 1:(worker2'=1+1);
  [worker2dot3l3Retry] worker2=2 & worker2retry_t3l3 < worker2_maxRetry_t3l3 -> p_worker2_t3l3 : (worker2'=worker2+1) + (1-p_worker2_t3l3) : (worker2'=worker2) & (worker2retry_t3l3' = worker2retry_t3l3+1);
  [worker2dot3l3] worker2=2 & worker2retry_t3l3 >= worker2_maxRetry_t3l3 -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=3-> 1:(worker2'=3+1);
  [worker2dot3l6bRetry] worker2=4 & worker2retry_t3l6b < worker2_maxRetry_t3l6b -> p_worker2_t3l6b : (worker2'=worker2+1) + (1-p_worker2_t3l6b) : (worker2'=worker2) & (worker2retry_t3l6b' = worker2retry_t3l6b+1);
  [worker2dot3l6b] worker2=4 & worker2retry_t3l6b >= worker2_maxRetry_t3l6b -> 1:(worker2'=worker2Fail);
  [worker2dot3l6aRetry] worker2=5 & worker2retry_t3l6a < worker2_maxRetry_t3l6a -> p_worker2_t3l6a : (worker2'=worker2+1) + (1-p_worker2_t3l6a) : (worker2'=worker2) & (worker2retry_t3l6a' = worker2retry_t3l6a+1);
  [worker2dot3l6a] worker2=5 & worker2retry_t3l6a >= worker2_maxRetry_t3l6a -> 1:(worker2'=worker2Fail);
  [worker2movel9] worker2=6-> 1:(worker2'=6+1);
  [worker2dot1l9Retry] worker2=7 & worker2retry_t1l9 < worker2_maxRetry_t1l9 -> p_worker2_t1l9 : (worker2'=worker2+1) + (1-p_worker2_t1l9) : (worker2'=worker2) & (worker2retry_t1l9' = worker2retry_t1l9+1);
  [worker2dot1l9] worker2=7 & worker2retry_t1l9 >= worker2_maxRetry_t1l9 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..3];
  r1retry_t2l1 : [0..r1_maxRetry_t2l1] init 0;

  [r1dot2l1Retry] r1=0 & r1retry_t2l1 < r1_maxRetry_t2l1 -> p_r1_t2l1 : (r1'=r1+1) + (1-p_r1_t2l1) : (r1'=r1) & (r1retry_t2l1' = r1retry_t2l1+1);
  [r1dot2l1] r1=0 & r1retry_t2l1 >= r1_maxRetry_t2l1 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..6];
  r2retry_t2l4 : [0..r2_maxRetry_t2l4] init 0;
  r2retry_t2l7 : [0..r2_maxRetry_t2l7] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2dot2l4Retry] r2=1 & r2retry_t2l4 < r2_maxRetry_t2l4 -> p_r2_t2l4 : (r2'=r2+1) + (1-p_r2_t2l4) : (r2'=r2) & (r2retry_t2l4' = r2retry_t2l4+1);
  [r2dot2l4] r2=1 & r2retry_t2l4 >= r2_maxRetry_t2l4 -> 1:(r2'=r2Fail);
  [r2movel7] r2=2-> 1:(r2'=2+1);
  [r2dot2l7Retry] r2=3 & r2retry_t2l7 < r2_maxRetry_t2l7 -> p_r2_t2l7 : (r2'=r2+1) + (1-p_r2_t2l7) : (r2'=r2) & (r2retry_t2l7' = r2retry_t2l7+1);
  [r2dot2l7] r2=3 & r2retry_t2l7 >= r2_maxRetry_t2l7 -> 1:(r2'=r2Fail);
endmodule

rewards "cost"
  [worker1dot1l1] true:3;
  [worker1dot1l1Retry] true:3;
  [worker1dot3l1] true:5;
  [worker1dot3l1Retry] true:5;
  [worker1movel4] true:1;
  [worker1dot1l4] true:3;
  [worker1dot1l4Retry] true:3;
  [worker2movel2] true:1;
  [worker2movel3] true:1;
  [worker2dot3l3] true:5;
  [worker2dot3l3Retry] true:5;
  [worker2movel6] true:1;
  [worker2dot3l6b] true:5;
  [worker2dot3l6bRetry] true:5;
  [worker2dot3l6a] true:5;
  [worker2dot3l6aRetry] true:5;
  [worker2movel9] true:1;
  [worker2dot1l9] true:3;
  [worker2dot1l9Retry] true:3;
  [r1dot2l1] true:1;
  [r1dot2l1Retry] true:1;
  [r2movel4] true:1;
  [r2dot2l4] true:1;
  [r2dot2l4Retry] true:1;
  [r2movel7] true:1;
  [r2dot2l7] true:1;
  [r2dot2l7Retry] true:1;
endrewards