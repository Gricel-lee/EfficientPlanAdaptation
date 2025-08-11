dtmc
evolve int worker1_maxRetry_t1l3 [1..5];
evolve int worker1_maxRetry_t3l6 [1..5];
evolve int worker2_maxRetry_t1l1 [1..5];
evolve int worker2_maxRetry_t1l4 [1..5];
evolve int r1_maxRetry_t2l4 [1..10];
evolve int r1_maxRetry_t3l4 [1..10];
evolve int r2_maxRetry_t2l2b [1..10];
evolve int r2_maxRetry_t3l2 [1..10];
evolve int r2_maxRetry_t2l2a [1..10];
evolve int r2_maxRetry_t2l3 [1..10];

const double p_worker1_t1l3=1.0;
const double p_worker1_t3l6=0.99;
const double p_worker2_t1l1=1.0;
const double p_worker2_t1l4=1.0;
const double p_r1_t2l4=0.99;
const double p_r1_t3l4=0.97;
const double p_r2_t2l2b=0.99;
const double p_r2_t3l2=0.97;
const double p_r2_t2l2a=0.99;
const double p_r2_t2l3=0.99;
const int worker1Final = 5;
const int worker1Fail = 6;
const int worker2Final = 4;
const int worker2Fail = 5;
const int r1Final = 3;
const int r1Fail = 4;
const int r2Final = 6;
const int r2Fail = 7;

module _worker1
  worker1 : [0..7];
  worker1retry_t1l3 : [0..worker1_maxRetry_t1l3] init 0;
  worker1retry_t3l6 : [0..worker1_maxRetry_t3l6] init 0;

  [worker1movel2] worker1=0-> 1:(worker1'=0+1);
  [worker1movel3] worker1=1-> 1:(worker1'=1+1);
  [worker1dot1l3Retry] worker1=2 & worker1retry_t1l3 < worker1_maxRetry_t1l3 -> p_worker1_t1l3 : (worker1'=worker1+1) + (1-p_worker1_t1l3) : (worker1'=worker1) & (worker1retry_t1l3' = worker1retry_t1l3+1);
  [worker1dot1l3] worker1=2 & worker1retry_t1l3 >= worker1_maxRetry_t1l3 -> 1:(worker1'=worker1Fail);
  [worker1movel6] worker1=3-> 1:(worker1'=3+1);
  [worker1dot3l6Retry] worker1=4 & worker1retry_t3l6 < worker1_maxRetry_t3l6 -> p_worker1_t3l6 : (worker1'=worker1+1) + (1-p_worker1_t3l6) : (worker1'=worker1) & (worker1retry_t3l6' = worker1retry_t3l6+1);
  [worker1dot3l6] worker1=4 & worker1retry_t3l6 >= worker1_maxRetry_t3l6 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..6];
  worker2retry_t1l1 : [0..worker2_maxRetry_t1l1] init 0;
  worker2retry_t1l4 : [0..worker2_maxRetry_t1l4] init 0;

  [worker2dot1l1Retry] worker2=0 & worker2retry_t1l1 < worker2_maxRetry_t1l1 -> p_worker2_t1l1 : (worker2'=worker2+1) + (1-p_worker2_t1l1) : (worker2'=worker2) & (worker2retry_t1l1' = worker2retry_t1l1+1);
  [worker2dot1l1] worker2=0 & worker2retry_t1l1 >= worker2_maxRetry_t1l1 -> 1:(worker2'=worker2Fail);
  [worker2movel4] worker2=1-> 1:(worker2'=1+1);
  [worker2dot1l4Retry] worker2=2 & worker2retry_t1l4 < worker2_maxRetry_t1l4 -> p_worker2_t1l4 : (worker2'=worker2+1) + (1-p_worker2_t1l4) : (worker2'=worker2) & (worker2retry_t1l4' = worker2retry_t1l4+1);
  [worker2dot1l4] worker2=2 & worker2retry_t1l4 >= worker2_maxRetry_t1l4 -> 1:(worker2'=worker2Fail);
  [worker2movel7] worker2=3-> 1:(worker2'=3+1);
endmodule

module _r1
  r1 : [0..5];
  r1retry_t2l4 : [0..r1_maxRetry_t2l4] init 0;
  r1retry_t3l4 : [0..r1_maxRetry_t3l4] init 0;

  [r1movel4] r1=0-> 1:(r1'=0+1);
  [r1dot2l4Retry] r1=1 & r1retry_t2l4 < r1_maxRetry_t2l4 -> p_r1_t2l4 : (r1'=r1+1) + (1-p_r1_t2l4) : (r1'=r1) & (r1retry_t2l4' = r1retry_t2l4+1);
  [r1dot2l4] r1=1 & r1retry_t2l4 >= r1_maxRetry_t2l4 -> 1:(r1'=r1Fail);
  [r1dot3l4Retry] r1=2 & r1retry_t3l4 < r1_maxRetry_t3l4 -> p_r1_t3l4 : (r1'=r1+1) + (1-p_r1_t3l4) : (r1'=r1) & (r1retry_t3l4' = r1retry_t3l4+1);
  [r1dot3l4] r1=2 & r1retry_t3l4 >= r1_maxRetry_t3l4 -> 1:(r1'=r1Fail);
endmodule

module _r2
  r2 : [0..8];
  r2retry_t2l2b : [0..r2_maxRetry_t2l2b] init 0;
  r2retry_t3l2 : [0..r2_maxRetry_t3l2] init 0;
  r2retry_t2l2a : [0..r2_maxRetry_t2l2a] init 0;
  r2retry_t2l3 : [0..r2_maxRetry_t2l3] init 0;

  [r2movel2] r2=0-> 1:(r2'=0+1);
  [r2dot2l2bRetry] r2=1 & r2retry_t2l2b < r2_maxRetry_t2l2b -> p_r2_t2l2b : (r2'=r2+1) + (1-p_r2_t2l2b) : (r2'=r2) & (r2retry_t2l2b' = r2retry_t2l2b+1);
  [r2dot2l2b] r2=1 & r2retry_t2l2b >= r2_maxRetry_t2l2b -> 1:(r2'=r2Fail);
  [r2dot3l2Retry] r2=2 & r2retry_t3l2 < r2_maxRetry_t3l2 -> p_r2_t3l2 : (r2'=r2+1) + (1-p_r2_t3l2) : (r2'=r2) & (r2retry_t3l2' = r2retry_t3l2+1);
  [r2dot3l2] r2=2 & r2retry_t3l2 >= r2_maxRetry_t3l2 -> 1:(r2'=r2Fail);
  [r2dot2l2aRetry] r2=3 & r2retry_t2l2a < r2_maxRetry_t2l2a -> p_r2_t2l2a : (r2'=r2+1) + (1-p_r2_t2l2a) : (r2'=r2) & (r2retry_t2l2a' = r2retry_t2l2a+1);
  [r2dot2l2a] r2=3 & r2retry_t2l2a >= r2_maxRetry_t2l2a -> 1:(r2'=r2Fail);
  [r2movel3] r2=4-> 1:(r2'=4+1);
  [r2dot2l3Retry] r2=5 & r2retry_t2l3 < r2_maxRetry_t2l3 -> p_r2_t2l3 : (r2'=r2+1) + (1-p_r2_t2l3) : (r2'=r2) & (r2retry_t2l3' = r2retry_t2l3+1);
  [r2dot2l3] r2=5 & r2retry_t2l3 >= r2_maxRetry_t2l3 -> 1:(r2'=r2Fail);
endmodule

rewards "cost"
  [worker1movel2] true:1;
  [worker1movel3] true:1;
  [worker1dot1l3] true:3;
  [worker1dot1l3Retry] true:3;
  [worker1movel6] true:1;
  [worker1dot3l6] true:5;
  [worker1dot3l6Retry] true:5;
  [worker2dot1l1] true:3;
  [worker2dot1l1Retry] true:3;
  [worker2movel4] true:1;
  [worker2dot1l4] true:3;
  [worker2dot1l4Retry] true:3;
  [worker2movel7] true:1;
  [r1movel4] true:1;
  [r1dot2l4] true:1;
  [r1dot2l4Retry] true:1;
  [r1dot3l4] true:1;
  [r1dot3l4Retry] true:1;
  [r2movel2] true:1;
  [r2dot2l2b] true:1;
  [r2dot2l2bRetry] true:1;
  [r2dot3l2] true:1;
  [r2dot3l2Retry] true:1;
  [r2dot2l2a] true:1;
  [r2dot2l2aRetry] true:1;
  [r2movel3] true:1;
  [r2dot2l3] true:1;
  [r2dot2l3Retry] true:1;
endrewards