dtmc
evolve int r3_maxRetry_t2l5 [1..10];
evolve int r3_maxRetry_t2l8b [1..10];
evolve int r3_maxRetry_t2l8a [1..10];
evolve int r3_maxRetry_t3l9 [1..10];
evolve int worker1_maxRetry_t1l6b [1..5];
evolve int worker1_maxRetry_t1l6a [1..5];
evolve int worker2_maxRetry_t3l4 [1..5];
evolve int worker2_maxRetry_t1l4 [1..5];
evolve int worker2_maxRetry_t3l7 [1..5];
evolve int worker2_maxRetry_t1l7 [1..5];

const double p_r3_t2l5_ORIGINAL=0.99;
const double p_r3_t2l8b_ORIGINAL=0.99;
const double p_r3_t2l8a_ORIGINAL=0.99;
const double p_r3_t3l9_ORIGINAL=0.97;
const double p_worker1_t1l6b_ORIGINAL=1.0;
const double p_worker1_t1l6a_ORIGINAL=1.0;
const double p_worker2_t3l4_ORIGINAL=0.99;
const double p_worker2_t1l4_ORIGINAL=1.0;
const double p_worker2_t3l7_ORIGINAL=0.99;
const double p_worker2_t1l7_ORIGINAL=1.0;

const double e = 2.718281828459045;
const double steepnessr3_t2l5 = 0.1;
const double steepnessr3_t2l8b = 0.1;
const double steepnessr3_t2l8a = 0.1;
const double steepnessr3_t3l9 = 0.1;
const double steepnessworker1_t1l6b = 3;
const double steepnessworker1_t1l6a = 3;
const double steepnessworker2_t3l4 = 3;
const double steepnessworker2_t1l4 = 3;
const double steepnessworker2_t3l7 = 3;
const double steepnessworker2_t1l7 = 3;

formula p_r3_t2l5 = 2 * (1 - p_r3_t2l5_ORIGINAL) * (1 / (1 + 1/pow(e,(r3retry_t2l5 * steepnessr3_t2l5)))) + (2 * p_r3_t2l5_ORIGINAL - 1);
formula p_r3_t2l8b = 2 * (1 - p_r3_t2l8b_ORIGINAL) * (1 / (1 + 1/pow(e,(r3retry_t2l8b * steepnessr3_t2l8b)))) + (2 * p_r3_t2l8b_ORIGINAL - 1);
formula p_r3_t2l8a = 2 * (1 - p_r3_t2l8a_ORIGINAL) * (1 / (1 + 1/pow(e,(r3retry_t2l8a * steepnessr3_t2l8a)))) + (2 * p_r3_t2l8a_ORIGINAL - 1);
formula p_r3_t3l9 = 2 * (1 - p_r3_t3l9_ORIGINAL) * (1 / (1 + 1/pow(e,(r3retry_t3l9 * steepnessr3_t3l9)))) + (2 * p_r3_t3l9_ORIGINAL - 1);
formula p_worker1_t1l6b = 2 * (1 - p_worker1_t1l6b_ORIGINAL) * (1 / (1 + 1/pow(e,(worker1retry_t1l6b * steepnessworker1_t1l6b)))) + (2 * p_worker1_t1l6b_ORIGINAL - 1);
formula p_worker1_t1l6a = 2 * (1 - p_worker1_t1l6a_ORIGINAL) * (1 / (1 + 1/pow(e,(worker1retry_t1l6a * steepnessworker1_t1l6a)))) + (2 * p_worker1_t1l6a_ORIGINAL - 1);
formula p_worker2_t3l4 = 2 * (1 - p_worker2_t3l4_ORIGINAL) * (1 / (1 + 1/pow(e,(worker2retry_t3l4 * steepnessworker2_t3l4)))) + (2 * p_worker2_t3l4_ORIGINAL - 1);
formula p_worker2_t1l4 = 2 * (1 - p_worker2_t1l4_ORIGINAL) * (1 / (1 + 1/pow(e,(worker2retry_t1l4 * steepnessworker2_t1l4)))) + (2 * p_worker2_t1l4_ORIGINAL - 1);
formula p_worker2_t3l7 = 2 * (1 - p_worker2_t3l7_ORIGINAL) * (1 / (1 + 1/pow(e,(worker2retry_t3l7 * steepnessworker2_t3l7)))) + (2 * p_worker2_t3l7_ORIGINAL - 1);
formula p_worker2_t1l7 = 2 * (1 - p_worker2_t1l7_ORIGINAL) * (1 / (1 + 1/pow(e,(worker2retry_t1l7 * steepnessworker2_t1l7)))) + (2 * p_worker2_t1l7_ORIGINAL - 1);

const int r3Final = 8;
const int r3Fail = 9;
const int worker1Final = 5;
const int worker1Fail = 6;
const int worker2Final = 6;
const int worker2Fail = 7;

module _r3
  r3 : [0..10];
  r3retry_t2l5 : [0..r3_maxRetry_t2l5] init 0;
  r3retry_t2l8b : [0..r3_maxRetry_t2l8b] init 0;
  r3retry_t2l8a : [0..r3_maxRetry_t2l8a] init 0;
  r3retry_t3l9 : [0..r3_maxRetry_t3l9] init 0;

  [r3movel2] r3=0-> 1:(r3'=0+1);
  [r3movel5] r3=1-> 1:(r3'=1+1);
  [r3dot2l5Retry] r3=2 & r3retry_t2l5 < r3_maxRetry_t2l5 -> p_r3_t2l5 : (r3'=r3+1) + (1-p_r3_t2l5) : (r3'=r3) & (r3retry_t2l5' = r3retry_t2l5+1);
  [r3dot2l5] r3=2 & r3retry_t2l5 >= r3_maxRetry_t2l5 -> 1:(r3'=r3Fail);
  [r3movel8] r3=3-> 1:(r3'=3+1);
  [r3dot2l8bRetry] r3=4 & r3retry_t2l8b < r3_maxRetry_t2l8b -> p_r3_t2l8b : (r3'=r3+1) + (1-p_r3_t2l8b) : (r3'=r3) & (r3retry_t2l8b' = r3retry_t2l8b+1);
  [r3dot2l8b] r3=4 & r3retry_t2l8b >= r3_maxRetry_t2l8b -> 1:(r3'=r3Fail);
  [r3dot2l8aRetry] r3=5 & r3retry_t2l8a < r3_maxRetry_t2l8a -> p_r3_t2l8a : (r3'=r3+1) + (1-p_r3_t2l8a) : (r3'=r3) & (r3retry_t2l8a' = r3retry_t2l8a+1);
  [r3dot2l8a] r3=5 & r3retry_t2l8a >= r3_maxRetry_t2l8a -> 1:(r3'=r3Fail);
  [r3movel9] r3=6-> 1:(r3'=6+1);
  [r3dot3l9Retry] r3=7 & r3retry_t3l9 < r3_maxRetry_t3l9 -> p_r3_t3l9 : (r3'=r3+1) + (1-p_r3_t3l9) : (r3'=r3) & (r3retry_t3l9' = r3retry_t3l9+1);
  [r3dot3l9] r3=7 & r3retry_t3l9 >= r3_maxRetry_t3l9 -> 1:(r3'=r3Fail);
endmodule

module _worker1
  worker1 : [0..7];
  worker1retry_t1l6b : [0..worker1_maxRetry_t1l6b] init 0;
  worker1retry_t1l6a : [0..worker1_maxRetry_t1l6a] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1movel5] worker1=1-> 1:(worker1'=1+1);
  [worker1movel6] worker1=2-> 1:(worker1'=2+1);
  [worker1dot1l6bRetry] worker1=3 & worker1retry_t1l6b < worker1_maxRetry_t1l6b -> p_worker1_t1l6b : (worker1'=worker1+1) + (1-p_worker1_t1l6b) : (worker1'=worker1) & (worker1retry_t1l6b' = worker1retry_t1l6b+1);
  [worker1dot1l6b] worker1=3 & worker1retry_t1l6b >= worker1_maxRetry_t1l6b -> 1:(worker1'=worker1Fail);
  [worker1dot1l6aRetry] worker1=4 & worker1retry_t1l6a < worker1_maxRetry_t1l6a -> p_worker1_t1l6a : (worker1'=worker1+1) + (1-p_worker1_t1l6a) : (worker1'=worker1) & (worker1retry_t1l6a' = worker1retry_t1l6a+1);
  [worker1dot1l6a] worker1=4 & worker1retry_t1l6a >= worker1_maxRetry_t1l6a -> 1:(worker1'=worker1Fail);
endmodule

module _worker2
  worker2 : [0..8];
  worker2retry_t3l4 : [0..worker2_maxRetry_t3l4] init 0;
  worker2retry_t1l4 : [0..worker2_maxRetry_t1l4] init 0;
  worker2retry_t3l7 : [0..worker2_maxRetry_t3l7] init 0;
  worker2retry_t1l7 : [0..worker2_maxRetry_t1l7] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2dot3l4Retry] worker2=1 & worker2retry_t3l4 < worker2_maxRetry_t3l4 -> p_worker2_t3l4 : (worker2'=worker2+1) + (1-p_worker2_t3l4) : (worker2'=worker2) & (worker2retry_t3l4' = worker2retry_t3l4+1);
  [worker2dot3l4] worker2=1 & worker2retry_t3l4 >= worker2_maxRetry_t3l4 -> 1:(worker2'=worker2Fail);
  [worker2dot1l4Retry] worker2=2 & worker2retry_t1l4 < worker2_maxRetry_t1l4 -> p_worker2_t1l4 : (worker2'=worker2+1) + (1-p_worker2_t1l4) : (worker2'=worker2) & (worker2retry_t1l4' = worker2retry_t1l4+1);
  [worker2dot1l4] worker2=2 & worker2retry_t1l4 >= worker2_maxRetry_t1l4 -> 1:(worker2'=worker2Fail);
  [worker2movel7] worker2=3-> 1:(worker2'=3+1);
  [worker2dot3l7Retry] worker2=4 & worker2retry_t3l7 < worker2_maxRetry_t3l7 -> p_worker2_t3l7 : (worker2'=worker2+1) + (1-p_worker2_t3l7) : (worker2'=worker2) & (worker2retry_t3l7' = worker2retry_t3l7+1);
  [worker2dot3l7] worker2=4 & worker2retry_t3l7 >= worker2_maxRetry_t3l7 -> 1:(worker2'=worker2Fail);
  [worker2dot1l7Retry] worker2=5 & worker2retry_t1l7 < worker2_maxRetry_t1l7 -> p_worker2_t1l7 : (worker2'=worker2+1) + (1-p_worker2_t1l7) : (worker2'=worker2) & (worker2retry_t1l7' = worker2retry_t1l7+1);
  [worker2dot1l7] worker2=5 & worker2retry_t1l7 >= worker2_maxRetry_t1l7 -> 1:(worker2'=worker2Fail);
endmodule

formula r_r3_t2l5_ORIGINAL = 1;
formula r_r3_t2l5 = r_r3_t2l5_ORIGINAL * (r3retry_t2l5+1);
formula r_r3_t2l8b_ORIGINAL = 1;
formula r_r3_t2l8b = r_r3_t2l8b_ORIGINAL * (r3retry_t2l8b+1);
formula r_r3_t2l8a_ORIGINAL = 1;
formula r_r3_t2l8a = r_r3_t2l8a_ORIGINAL * (r3retry_t2l8a+1);
formula r_r3_t3l9_ORIGINAL = 1;
formula r_r3_t3l9 = r_r3_t3l9_ORIGINAL * (r3retry_t3l9+1);
formula r_worker1_t1l6b_ORIGINAL = 3;
formula r_worker1_t1l6b = r_worker1_t1l6b_ORIGINAL * (worker1retry_t1l6b+1);
formula r_worker1_t1l6a_ORIGINAL = 3;
formula r_worker1_t1l6a = r_worker1_t1l6a_ORIGINAL * (worker1retry_t1l6a+1);
formula r_worker2_t3l4_ORIGINAL = 5;
formula r_worker2_t3l4 = r_worker2_t3l4_ORIGINAL * (worker2retry_t3l4+1);
formula r_worker2_t1l4_ORIGINAL = 3;
formula r_worker2_t1l4 = r_worker2_t1l4_ORIGINAL * (worker2retry_t1l4+1);
formula r_worker2_t3l7_ORIGINAL = 5;
formula r_worker2_t3l7 = r_worker2_t3l7_ORIGINAL * (worker2retry_t3l7+1);
formula r_worker2_t1l7_ORIGINAL = 3;
formula r_worker2_t1l7 = r_worker2_t1l7_ORIGINAL * (worker2retry_t1l7+1);


rewards "cost"
  [r3movel2] true:1;
  [r3movel5] true:1;
  [r3dot2l5] true:1;
  [r3dot2l5Retry] true:1;
  [r3movel8] true:1;
  [r3dot2l8b] true:1;
  [r3dot2l8bRetry] true:1;
  [r3dot2l8a] true:1;
  [r3dot2l8aRetry] true:1;
  [r3movel9] true:1;
  [r3dot3l9] true:1;
  [r3dot3l9Retry] true:1;
  [worker1movel4] true:1;
  [worker1movel5] true:1;
  [worker1movel6] true:1;
  [worker1dot1l6b] true:3;
  [worker1dot1l6bRetry] true:3;
  [worker1dot1l6a] true:3;
  [worker1dot1l6aRetry] true:3;
  [worker2movel4] true:1;
  [worker2dot3l4] true:5;
  [worker2dot3l4Retry] true:5;
  [worker2dot1l4] true:3;
  [worker2dot1l4Retry] true:3;
  [worker2movel7] true:1;
  [worker2dot3l7] true:5;
  [worker2dot3l7Retry] true:5;
  [worker2dot1l7] true:3;
  [worker2dot1l7Retry] true:3;
endrewards