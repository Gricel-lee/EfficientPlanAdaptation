dtmc
evolve int worker1_maxRetry_t1l4 [1..5];
evolve int worker1_maxRetry_t3l4 [1..5];
evolve int r3_maxRetry_t3l7 [1..10];
evolve int r3_maxRetry_t2l8a [1..2];
evolve int r3_maxRetry_t2l5 [1..2];

const double p_worker1_t1l4_ORIGINAL=1.0;
const double p_worker1_t3l4_ORIGINAL=0.99;
const double p_r3_t3l7_ORIGINAL=0.97;
const double p_r3_t2l8a_ORIGINAL=0.99;
const double p_r3_t2l5_ORIGINAL=0.99;

const double e = 2.718281828459045;
const double steepnessworker1_t1l4 = 3;
const double steepnessworker1_t3l4 = 3;
const double steepnessr3_t3l7 = 0.1;
const double steepnessr3_t2l8a = 0.1;
const double steepnessr3_t2l5 = 0.1;

formula p_worker1_t1l4 = 2 * (1 - p_worker1_t1l4_ORIGINAL) * (1 / (1 + 1/pow(e,(worker1retry_t1l4 * steepnessworker1_t1l4)))) + (2 * p_worker1_t1l4_ORIGINAL - 1);
formula p_worker1_t3l4 = 2 * (1 - p_worker1_t3l4_ORIGINAL) * (1 / (1 + 1/pow(e,(worker1retry_t3l4 * steepnessworker1_t3l4)))) + (2 * p_worker1_t3l4_ORIGINAL - 1);
formula p_r3_t3l7 = 2 * (1 - p_r3_t3l7_ORIGINAL) * (1 / (1 + 1/pow(e,(r3retry_t3l7 * steepnessr3_t3l7)))) + (2 * p_r3_t3l7_ORIGINAL - 1);
formula p_r3_t2l8a = 2 * (1 - p_r3_t2l8a_ORIGINAL) * (1 / (1 + 1/pow(e,(r3retry_t2l8a * steepnessr3_t2l8a)))) + (2 * p_r3_t2l8a_ORIGINAL - 1);
formula p_r3_t2l5 = 2 * (1 - p_r3_t2l5_ORIGINAL) * (1 / (1 + 1/pow(e,(r3retry_t2l5 * steepnessr3_t2l5)))) + (2 * p_r3_t2l5_ORIGINAL - 1);

const int worker1Final = 3;
const int worker1Fail = 4;
const int r3Final = 7;
const int r3Fail = 8;

module _worker1
  worker1 : [0..5];
  worker1retry_t1l4 : [0..worker1_maxRetry_t1l4] init 0;
  worker1retry_t3l4 : [0..worker1_maxRetry_t3l4] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot1l4Retry] worker1=1 & worker1retry_t1l4 < worker1_maxRetry_t1l4 -> p_worker1_t1l4 : (worker1'=worker1+1) + (1-p_worker1_t1l4) : (worker1'=worker1) & (worker1retry_t1l4' = worker1retry_t1l4+1);
  [worker1dot1l4] worker1=1 & worker1retry_t1l4 >= worker1_maxRetry_t1l4 -> 1:(worker1'=worker1Fail);
  [worker1dot3l4Retry] worker1=2 & worker1retry_t3l4 < worker1_maxRetry_t3l4 -> p_worker1_t3l4 : (worker1'=worker1+1) + (1-p_worker1_t3l4) : (worker1'=worker1) & (worker1retry_t3l4' = worker1retry_t3l4+1);
  [worker1dot3l4] worker1=2 & worker1retry_t3l4 >= worker1_maxRetry_t3l4 -> 1:(worker1'=worker1Fail);
endmodule

module _r3
  r3 : [0..9];
  r3retry_t3l7 : [0..r3_maxRetry_t3l7] init 0;
  r3retry_t2l8a : [0..r3_maxRetry_t2l8a] init 0;
  r3retry_t2l5 : [0..r3_maxRetry_t2l5] init 0;

  [r3movel4] r3=0-> 1:(r3'=0+1);
  [r3movel7] r3=1-> 1:(r3'=1+1);
  [r3dot3l7Retry] r3=2 & r3retry_t3l7 < r3_maxRetry_t3l7 -> p_r3_t3l7 : (r3'=r3+1) + (1-p_r3_t3l7) : (r3'=r3) & (r3retry_t3l7' = r3retry_t3l7+1);
  [r3dot3l7] r3=2 & r3retry_t3l7 >= r3_maxRetry_t3l7 -> 1:(r3'=r3Fail);
  [r3movel8] r3=3-> 1:(r3'=3+1);
  [r3dot2l8aRetry] r3=4 & r3retry_t2l8a < r3_maxRetry_t2l8a -> p_r3_t2l8a : (r3'=r3+1) + (1-p_r3_t2l8a) : (r3'=r3) & (r3retry_t2l8a' = r3retry_t2l8a+1);
  [r3dot2l8a] r3=4 & r3retry_t2l8a >= r3_maxRetry_t2l8a -> 1:(r3'=r3Fail);
  [r3movel5] r3=5-> 1:(r3'=5+1);
  [r3dot2l5Retry] r3=6 & r3retry_t2l5 < r3_maxRetry_t2l5 -> p_r3_t2l5 : (r3'=r3+1) + (1-p_r3_t2l5) : (r3'=r3) & (r3retry_t2l5' = r3retry_t2l5+1);
  [r3dot2l5] r3=6 & r3retry_t2l5 >= r3_maxRetry_t2l5 -> 1:(r3'=r3Fail);
endmodule

formula r_worker1_t1l4_ORIGINAL = 3;
formula r_worker1_t1l4 = r_worker1_t1l4_ORIGINAL * (worker1retry_t1l4+1);
formula r_worker1_t3l4_ORIGINAL = 5;
formula r_worker1_t3l4 = r_worker1_t3l4_ORIGINAL * (worker1retry_t3l4+1);
formula r_r3_t3l7_ORIGINAL = 1;
formula r_r3_t3l7 = r_r3_t3l7_ORIGINAL * (r3retry_t3l7+1);
formula r_r3_t2l8a_ORIGINAL = 1;
formula r_r3_t2l8a = r_r3_t2l8a_ORIGINAL * (r3retry_t2l8a+1);
formula r_r3_t2l5_ORIGINAL = 1;
formula r_r3_t2l5 = r_r3_t2l5_ORIGINAL * (r3retry_t2l5+1);


rewards "cost"
  [worker1movel4] true:1;
  [worker1dot1l4] true:3;
  [worker1dot1l4Retry] true:3;
  [worker1dot3l4] true:5;
  [worker1dot3l4Retry] true:5;
  [r3movel4] true:1;
  [r3movel7] true:1;
  [r3dot3l7] true:1;
  [r3dot3l7Retry] true:1;
  [r3movel8] true:1;
  [r3dot2l8a] true:1;
  [r3dot2l8aRetry] true:1;
  [r3movel5] true:1;
  [r3dot2l5] true:1;
  [r3dot2l5Retry] true:1;
endrewards