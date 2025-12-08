dtmc
evolve int worker1_maxRetry_t1l3 [1..5];
evolve int worker1_maxRetry_t3l3 [1..5];
evolve int worker1_maxRetry_t1l6 [1..5];
evolve int r1_maxRetry_t3l4 [1..10];
evolve int r1_maxRetry_t2l7 [1..10];
evolve int r1_maxRetry_t3l7 [1..10];
evolve int r2_maxRetry_t3l1 [1..10];
evolve int r2_maxRetry_t2l2 [1..10];
evolve int r2_maxRetry_t2l6a [1..10];
evolve int r2_maxRetry_t2l6b [1..10];

const double p_worker1_t1l3=1.0;
const double p_worker1_t3l3=0.99;
const double p_worker1_t1l6=1.0;
const double p_r1_t3l4=0.97;
const double p_r1_t2l7=0.99;
const double p_r1_t3l7=0.97;
const double p_r2_t3l1=0.97;
const double p_r2_t2l2=0.99;
const double p_r2_t2l6a=0.99;
const double p_r2_t2l6b=0.99;
const int worker1Final = 7;
const int worker1Fail = 8;
const int r1Final = 5;
const int r1Fail = 6;
const int r2Final = 7;
const int r2Fail = 8;

module _worker1
  worker1 : [0..9];
  worker1retry_t1l3 : [0..worker1_maxRetry_t1l3] init 0;
  worker1retry_t3l3 : [0..worker1_maxRetry_t3l3] init 0;
  worker1retry_t1l6 : [0..worker1_maxRetry_t1l6] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1movel3] worker1=1-> 1:(worker1'=1+1);
  [worker1dot1l3Retry] worker1=2 & worker1retry_t1l3 < worker1_maxRetry_t1l3 -> p_worker1_t1l3 : (worker1'=worker1+1) + (1-p_worker1_t1l3) : (worker1'=worker1) & (worker1retry_t1l3' = worker1retry_t1l3+1);
  [worker1dot1l3] worker1=2 & worker1retry_t1l3 >= worker1_maxRetry_t1l3 -> 1:(worker1'=worker1Fail);
  [worker1dot3l3Retry] worker1=3 & worker1retry_t3l3 < worker1_maxRetry_t3l3 -> p_worker1_t3l3 : (worker1'=worker1+1) + (1-p_worker1_t3l3) : (worker1'=worker1) & (worker1retry_t3l3' = worker1retry_t3l3+1);
  [worker1dot3l3] worker1=3 & worker1retry_t3l3 >= worker1_maxRetry_t3l3 -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=4-> 1:(worker1'=4+1);
  [worker1dot1l6Retry] worker1=5 & worker1retry_t1l6 < worker1_maxRetry_t1l6 -> p_worker1_t1l6 : (worker1'=worker1+1) + (1-p_worker1_t1l6) : (worker1'=worker1) & (worker1retry_t1l6' = worker1retry_t1l6+1);
  [worker1dot1l6] worker1=5 & worker1retry_t1l6 >= worker1_maxRetry_t1l6 -> 1:(worker1'=worker1Fail);
  [worker1movel3] worker1=6-> 1:(worker1'=6+1);
endmodule

module _r1
  r1 : [0..7];
  r1retry_t3l4 : [0..r1_maxRetry_t3l4] init 0;
  r1retry_t2l7 : [0..r1_maxRetry_t2l7] init 0;
  r1retry_t3l7 : [0..r1_maxRetry_t3l7] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1dot3l4Retry] r1=1 & r1retry_t3l4 < r1_maxRetry_t3l4 -> p_r1_t3l4 : (r1'=r1+1) + (1-p_r1_t3l4) : (r1'=r1) & (r1retry_t3l4' = r1retry_t3l4+1);
  [r1dot3l4] r1=1 & r1retry_t3l4 >= r1_maxRetry_t3l4 -> 1:(r1'=r1Fail);
  [r1movel7] r1=2-> 1:(r1'=2+1);
  [r1dot2l7Retry] r1=3 & r1retry_t2l7 < r1_maxRetry_t2l7 -> p_r1_t2l7 : (r1'=r1+1) + (1-p_r1_t2l7) : (r1'=r1) & (r1retry_t2l7' = r1retry_t2l7+1);
  [r1dot2l7] r1=3 & r1retry_t2l7 >= r1_maxRetry_t2l7 -> 1:(r1'=r1Fail);
  [r1dot3l7Retry] r1=4 & r1retry_t3l7 < r1_maxRetry_t3l7 -> p_r1_t3l7 : (r1'=r1+1) + (1-p_r1_t3l7) : (r1'=r1) & (r1retry_t3l7' = r1retry_t3l7+1);
  [r1dot3l7] r1=4 & r1retry_t3l7 >= r1_maxRetry_t3l7 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..9];
  r2retry_t3l1 : [0..r2_maxRetry_t3l1] init 0;
  r2retry_t2l2 : [0..r2_maxRetry_t2l2] init 0;
  r2retry_t2l6a : [0..r2_maxRetry_t2l6a] init 0;
  r2retry_t2l6b : [0..r2_maxRetry_t2l6b] init 0;

  [r2dot3l1Retry] r2=0 & r2retry_t3l1 < r2_maxRetry_t3l1 -> p_r2_t3l1 : (r2'=r2+1) + (1-p_r2_t3l1) : (r2'=r2) & (r2retry_t3l1' = r2retry_t3l1+1);
  [r2dot3l1] r2=0 & r2retry_t3l1 >= r2_maxRetry_t3l1 -> 1:(r2'=r2Fail);
  [r2movel2] r2=1-> 1:(r2'=1+1);
  [r2dot2l2Retry] r2=2 & r2retry_t2l2 < r2_maxRetry_t2l2 -> p_r2_t2l2 : (r2'=r2+1) + (1-p_r2_t2l2) : (r2'=r2) & (r2retry_t2l2' = r2retry_t2l2+1);
  [r2dot2l2] r2=2 & r2retry_t2l2 >= r2_maxRetry_t2l2 -> 1:(r2'=r2Fail);
  [r2movel5] r2=3-> 1:(r2'=3+1);
  [r2movel6] r2=4-> 1:(r2'=4+1);
  [r2dot2l6aRetry] r2=5 & r2retry_t2l6a < r2_maxRetry_t2l6a -> p_r2_t2l6a : (r2'=r2+1) + (1-p_r2_t2l6a) : (r2'=r2) & (r2retry_t2l6a' = r2retry_t2l6a+1);
  [r2dot2l6a] r2=5 & r2retry_t2l6a >= r2_maxRetry_t2l6a -> 1:(r2'=r2Fail);
  [r2dot2l6bRetry] r2=6 & r2retry_t2l6b < r2_maxRetry_t2l6b -> p_r2_t2l6b : (r2'=r2+1) + (1-p_r2_t2l6b) : (r2'=r2) & (r2retry_t2l6b' = r2retry_t2l6b+1);
  [r2dot2l6b] r2=6 & r2retry_t2l6b >= r2_maxRetry_t2l6b -> 1:(r2'=r2Fail);
endmodule

rewards "cost"
  [worker1movel2] true:1;
  [worker1movel3] true:1;
  [worker1dot1l3] true:3;
  [worker1dot1l3Retry] true:3;
  [worker1dot3l3] true:5;
  [worker1dot3l3Retry] true:5;
  [worker1movel6] true:1;
  [worker1dot1l6] true:3;
  [worker1dot1l6Retry] true:3;
  [worker1movel3] true:1;
  [r1movel4] true:1;
  [r1dot3l4] true:1;
  [r1dot3l4Retry] true:1;
  [r1movel7] true:1;
  [r1dot2l7] true:1;
  [r1dot2l7Retry] true:1;
  [r1dot3l7] true:1;
  [r1dot3l7Retry] true:1;
  [r2dot3l1] true:1;
  [r2dot3l1Retry] true:1;
  [r2movel2] true:1;
  [r2dot2l2] true:1;
  [r2dot2l2Retry] true:1;
  [r2movel5] true:1;
  [r2movel6] true:1;
  [r2dot2l6a] true:1;
  [r2dot2l6aRetry] true:1;
  [r2dot2l6b] true:1;
  [r2dot2l6bRetry] true:1;
endrewards