dtmc
evolve int r2_maxRetry_t2l4 [1..10];
evolve int r2_maxRetry_t2l5 [1..10];
evolve int r2_maxRetry_t2l6 [1..10];
evolve int r2_maxRetry_t3l6 [1..10];
evolve int worker1_maxRetry_t1l1 [1..5];
evolve int worker1_maxRetry_t3l4 [1..5];
evolve int worker1_maxRetry_t1l4a [1..5];
evolve int worker1_maxRetry_t1l4b [1..5];
evolve int worker1_maxRetry_t1l7 [1..5];
evolve int worker2_maxRetry_t1l3 [1..5];
evolve int r1_maxRetry_t3l1 [1..10];

const double p_r2_t2l4=0.99;
const double p_r2_t2l5=0.99;
const double p_r2_t2l6=0.99;
const double p_r2_t3l6=0.97;
const double p_worker1_t1l1=1.0;
const double p_worker1_t3l4=0.99;
const double p_worker1_t1l4a=1.0;
const double p_worker1_t1l4b=1.0;
const double p_worker1_t1l7=1.0;
const double p_worker2_t1l3=1.0;
const double p_r1_t3l1=0.97;
const int r2Final = 7;
const int r2Fail = 8;
const int worker1Final = 7;
const int worker1Fail = 8;
const int worker2Final = 3;
const int worker2Fail = 4;
const int r1Final = 1;
const int r1Fail = 2;

module _r2
  r2 : [0..9];
  r2retry_t2l4 : [0..r2_maxRetry_t2l4] init 0;
  r2retry_t2l5 : [0..r2_maxRetry_t2l5] init 0;
  r2retry_t2l6 : [0..r2_maxRetry_t2l6] init 0;
  r2retry_t3l6 : [0..r2_maxRetry_t3l6] init 0;

  [r2movel4] r2=0-> 1:(r2'=0+1);
  [r2dot2l4Retry] r2=1 & r2retry_t2l4 < r2_maxRetry_t2l4 -> p_r2_t2l4 : (r2'=r2+1) + (1-p_r2_t2l4) : (r2'=r2) & (r2retry_t2l4' = r2retry_t2l4+1);
  [r2dot2l4] r2=1 & r2retry_t2l4 >= r2_maxRetry_t2l4 -> 1:(r2'=r2Fail);
  [r2movel5] r2=2-> 1:(r2'=2+1);
  [r2dot2l5Retry] r2=3 & r2retry_t2l5 < r2_maxRetry_t2l5 -> p_r2_t2l5 : (r2'=r2+1) + (1-p_r2_t2l5) : (r2'=r2) & (r2retry_t2l5' = r2retry_t2l5+1);
  [r2dot2l5] r2=3 & r2retry_t2l5 >= r2_maxRetry_t2l5 -> 1:(r2'=r2Fail);
  [r2movel6] r2=4-> 1:(r2'=4+1);
  [r2dot2l6Retry] r2=5 & r2retry_t2l6 < r2_maxRetry_t2l6 -> p_r2_t2l6 : (r2'=r2+1) + (1-p_r2_t2l6) : (r2'=r2) & (r2retry_t2l6' = r2retry_t2l6+1);
  [r2dot2l6] r2=5 & r2retry_t2l6 >= r2_maxRetry_t2l6 -> 1:(r2'=r2Fail);
  [r2dot3l6Retry] r2=6 & r2retry_t3l6 < r2_maxRetry_t3l6 -> p_r2_t3l6 : (r2'=r2+1) + (1-p_r2_t3l6) : (r2'=r2) & (r2retry_t3l6' = r2retry_t3l6+1);
  [r2dot3l6] r2=6 & r2retry_t3l6 >= r2_maxRetry_t3l6 -> 1:(r2'=r2Fail);
endmodule

module _worker1
  worker1 : [0..9];
  worker1retry_t1l1 : [0..worker1_maxRetry_t1l1] init 0;
  worker1retry_t3l4 : [0..worker1_maxRetry_t3l4] init 0;
  worker1retry_t1l4a : [0..worker1_maxRetry_t1l4a] init 0;
  worker1retry_t1l4b : [0..worker1_maxRetry_t1l4b] init 0;
  worker1retry_t1l7 : [0..worker1_maxRetry_t1l7] init 0;

  [worker1dot1l1Retry] worker1=0 & worker1retry_t1l1 < worker1_maxRetry_t1l1 -> p_worker1_t1l1 : (worker1'=worker1+1) + (1-p_worker1_t1l1) : (worker1'=worker1) & (worker1retry_t1l1' = worker1retry_t1l1+1);
  [worker1dot1l1] worker1=0 & worker1retry_t1l1 >= worker1_maxRetry_t1l1 -> 1:(worker1'=worker1Fail);
  [worker1movel4] worker1=1-> 1:(worker1'=1+1);
  [worker1dot3l4Retry] worker1=2 & worker1retry_t3l4 < worker1_maxRetry_t3l4 -> p_worker1_t3l4 : (worker1'=worker1+1) + (1-p_worker1_t3l4) : (worker1'=worker1) & (worker1retry_t3l4' = worker1retry_t3l4+1);
  [worker1dot3l4] worker1=2 & worker1retry_t3l4 >= worker1_maxRetry_t3l4 -> 1:(worker1'=worker1Fail);
  [worker1dot1l4aRetry] worker1=3 & worker1retry_t1l4a < worker1_maxRetry_t1l4a -> p_worker1_t1l4a : (worker1'=worker1+1) + (1-p_worker1_t1l4a) : (worker1'=worker1) & (worker1retry_t1l4a' = worker1retry_t1l4a+1);
  [worker1dot1l4a] worker1=3 & worker1retry_t1l4a >= worker1_maxRetry_t1l4a -> 1:(worker1'=worker1Fail);
  [worker1dot1l4bRetry] worker1=4 & worker1retry_t1l4b < worker1_maxRetry_t1l4b -> p_worker1_t1l4b : (worker1'=worker1+1) + (1-p_worker1_t1l4b) : (worker1'=worker1) & (worker1retry_t1l4b' = worker1retry_t1l4b+1);
  [worker1dot1l4b] worker1=4 & worker1retry_t1l4b >= worker1_maxRetry_t1l4b -> 1:(worker1'=worker1Fail);
  [worker1movel7] worker1=5-> 1:(worker1'=5+1);
  [worker1dot1l7Retry] worker1=6 & worker1retry_t1l7 < worker1_maxRetry_t1l7 -> p_worker1_t1l7 : (worker1'=worker1+1) + (1-p_worker1_t1l7) : (worker1'=worker1) & (worker1retry_t1l7' = worker1retry_t1l7+1);
  [worker1dot1l7] worker1=6 & worker1retry_t1l7 >= worker1_maxRetry_t1l7 -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..5];
  worker2retry_t1l3 : [0..worker2_maxRetry_t1l3] init 0;

  [worker2movel2] worker2=0-> 1:(worker2'=0+1);
  [worker2movel3] worker2=1-> 1:(worker2'=1+1);
  [worker2dot1l3Retry] worker2=2 & worker2retry_t1l3 < worker2_maxRetry_t1l3 -> p_worker2_t1l3 : (worker2'=worker2+1) + (1-p_worker2_t1l3) : (worker2'=worker2) & (worker2retry_t1l3' = worker2retry_t1l3+1);
  [worker2dot1l3] worker2=2 & worker2retry_t1l3 >= worker2_maxRetry_t1l3 -> 1:(worker2'=worker2Fail);
endmodule

module _r1
  r1 : [0..3];
  r1retry_t3l1 : [0..r1_maxRetry_t3l1] init 0;

  [r1dot3l1Retry] r1=0 & r1retry_t3l1 < r1_maxRetry_t3l1 -> p_r1_t3l1 : (r1'=r1+1) + (1-p_r1_t3l1) : (r1'=r1) & (r1retry_t3l1' = r1retry_t3l1+1);
  [r1dot3l1] r1=0 & r1retry_t3l1 >= r1_maxRetry_t3l1 -> 1:(r1'=r1Fail);
endmodule

rewards "cost"
  [r2movel4] true:1;
  [r2dot2l4] true:1;
  [r2dot2l4Retry] true:1;
  [r2movel5] true:1;
  [r2dot2l5] true:1;
  [r2dot2l5Retry] true:1;
  [r2movel6] true:1;
  [r2dot2l6] true:1;
  [r2dot2l6Retry] true:1;
  [r2dot3l6] true:1;
  [r2dot3l6Retry] true:1;
  [worker1dot1l1] true:3;
  [worker1dot1l1Retry] true:3;
  [worker1movel4] true:1;
  [worker1dot3l4] true:5;
  [worker1dot3l4Retry] true:5;
  [worker1dot1l4a] true:3;
  [worker1dot1l4aRetry] true:3;
  [worker1dot1l4b] true:3;
  [worker1dot1l4bRetry] true:3;
  [worker1movel7] true:1;
  [worker1dot1l7] true:3;
  [worker1dot1l7Retry] true:3;
  [worker2movel2] true:1;
  [worker2movel3] true:1;
  [worker2dot1l3] true:3;
  [worker2dot1l3Retry] true:3;
  [r1dot3l1] true:1;
  [r1dot3l1Retry] true:1;
endrewards