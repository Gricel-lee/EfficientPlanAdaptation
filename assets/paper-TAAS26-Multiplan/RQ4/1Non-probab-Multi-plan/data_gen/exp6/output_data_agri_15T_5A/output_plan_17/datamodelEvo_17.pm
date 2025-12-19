dtmc
evolve int r5_maxRetry_t2l5 [1..10];
evolve int r5_maxRetry_t3l8b [1..10];
evolve int r5_maxRetry_t2l8b [1..10];
evolve int r5_maxRetry_t2l8a [1..10];
evolve int r5_maxRetry_t3l8 [1..10];
evolve int r5_maxRetry_t2l8c [1..10];
evolve int r5_maxRetry_t2l8d [1..10];
evolve int worker2_maxRetry_t3l4 [1..5];
evolve int worker2_maxRetry_t1l4 [1..5];
evolve int worker2_maxRetry_t3l7 [1..5];
evolve int worker2_maxRetry_t1l6a [1..5];
evolve int worker2_maxRetry_t3l9 [1..5];
evolve int worker2_maxRetry_t3l9b [1..5];
evolve int worker2_maxRetry_t1l6b [1..5];
evolve int worker1_maxRetry_t1l7 [1..5];

const double p_r5_t2l5_ORIGINAL=0.99;
const double p_r5_t3l8b_ORIGINAL=0.97;
const double p_r5_t2l8b_ORIGINAL=0.99;
const double p_r5_t2l8a_ORIGINAL=0.99;
const double p_r5_t3l8_ORIGINAL=0.97;
const double p_r5_t2l8c_ORIGINAL=0.99;
const double p_r5_t2l8d_ORIGINAL=0.99;
const double p_worker2_t3l4_ORIGINAL=0.99;
const double p_worker2_t1l4_ORIGINAL=1.0;
const double p_worker2_t3l7_ORIGINAL=0.99;
const double p_worker2_t1l6a_ORIGINAL=1.0;
const double p_worker2_t3l9_ORIGINAL=0.99;
const double p_worker2_t3l9b_ORIGINAL=0.99;
const double p_worker2_t1l6b_ORIGINAL=1.0;
const double p_worker1_t1l7_ORIGINAL=1.0;

const double e = 2.718281828459045;
const double steepnessr5_t2l5 = 0.1;
const double steepnessr5_t3l8b = 0.1;
const double steepnessr5_t2l8b = 0.1;
const double steepnessr5_t2l8a = 0.1;
const double steepnessr5_t3l8 = 0.1;
const double steepnessr5_t2l8c = 0.1;
const double steepnessr5_t2l8d = 0.1;
const double steepnessworker2_t3l4 = 3;
const double steepnessworker2_t1l4 = 3;
const double steepnessworker2_t3l7 = 3;
const double steepnessworker2_t1l6a = 3;
const double steepnessworker2_t3l9 = 3;
const double steepnessworker2_t3l9b = 3;
const double steepnessworker2_t1l6b = 3;
const double steepnessworker1_t1l7 = 1.0;

formula p_r5_t2l5 = 2 * (1 - p_r5_t2l5_ORIGINAL) * (1 / (1 + 1/pow(e,(r5retry_t2l5 * steepnessr5_t2l5)))) + (2 * p_r5_t2l5_ORIGINAL - 1);
formula p_r5_t3l8b = 2 * (1 - p_r5_t3l8b_ORIGINAL) * (1 / (1 + 1/pow(e,(r5retry_t3l8b * steepnessr5_t3l8b)))) + (2 * p_r5_t3l8b_ORIGINAL - 1);
formula p_r5_t2l8b = 2 * (1 - p_r5_t2l8b_ORIGINAL) * (1 / (1 + 1/pow(e,(r5retry_t2l8b * steepnessr5_t2l8b)))) + (2 * p_r5_t2l8b_ORIGINAL - 1);
formula p_r5_t2l8a = 2 * (1 - p_r5_t2l8a_ORIGINAL) * (1 / (1 + 1/pow(e,(r5retry_t2l8a * steepnessr5_t2l8a)))) + (2 * p_r5_t2l8a_ORIGINAL - 1);
formula p_r5_t3l8 = 2 * (1 - p_r5_t3l8_ORIGINAL) * (1 / (1 + 1/pow(e,(r5retry_t3l8 * steepnessr5_t3l8)))) + (2 * p_r5_t3l8_ORIGINAL - 1);
formula p_r5_t2l8c = 2 * (1 - p_r5_t2l8c_ORIGINAL) * (1 / (1 + 1/pow(e,(r5retry_t2l8c * steepnessr5_t2l8c)))) + (2 * p_r5_t2l8c_ORIGINAL - 1);
formula p_r5_t2l8d = 2 * (1 - p_r5_t2l8d_ORIGINAL) * (1 / (1 + 1/pow(e,(r5retry_t2l8d * steepnessr5_t2l8d)))) + (2 * p_r5_t2l8d_ORIGINAL - 1);
formula p_worker2_t3l4 = 2 * (1 - p_worker2_t3l4_ORIGINAL) * (1 / (1 + 1/pow(e,(worker2retry_t3l4 * steepnessworker2_t3l4)))) + (2 * p_worker2_t3l4_ORIGINAL - 1);
formula p_worker2_t1l4 = 2 * (1 - p_worker2_t1l4_ORIGINAL) * (1 / (1 + 1/pow(e,(worker2retry_t1l4 * steepnessworker2_t1l4)))) + (2 * p_worker2_t1l4_ORIGINAL - 1);
formula p_worker2_t3l7 = 2 * (1 - p_worker2_t3l7_ORIGINAL) * (1 / (1 + 1/pow(e,(worker2retry_t3l7 * steepnessworker2_t3l7)))) + (2 * p_worker2_t3l7_ORIGINAL - 1);
formula p_worker2_t1l6a = 2 * (1 - p_worker2_t1l6a_ORIGINAL) * (1 / (1 + 1/pow(e,(worker2retry_t1l6a * steepnessworker2_t1l6a)))) + (2 * p_worker2_t1l6a_ORIGINAL - 1);
formula p_worker2_t3l9 = 2 * (1 - p_worker2_t3l9_ORIGINAL) * (1 / (1 + 1/pow(e,(worker2retry_t3l9 * steepnessworker2_t3l9)))) + (2 * p_worker2_t3l9_ORIGINAL - 1);
formula p_worker2_t3l9b = 2 * (1 - p_worker2_t3l9b_ORIGINAL) * (1 / (1 + 1/pow(e,(worker2retry_t3l9b * steepnessworker2_t3l9b)))) + (2 * p_worker2_t3l9b_ORIGINAL - 1);
formula p_worker2_t1l6b = 2 * (1 - p_worker2_t1l6b_ORIGINAL) * (1 / (1 + 1/pow(e,(worker2retry_t1l6b * steepnessworker2_t1l6b)))) + (2 * p_worker2_t1l6b_ORIGINAL - 1);
formula p_worker1_t1l7 = 2 * (1 - p_worker1_t1l7_ORIGINAL) * (1 / (1 + 1/pow(e,(worker1retry_t1l7 * steepnessworker1_t1l7)))) + (2 * p_worker1_t1l7_ORIGINAL - 1);

const int r5Final = 10;
const int r5Fail = 11;
const int worker2Final = 14;
const int worker2Fail = 15;
const int worker1Final = 3;
const int worker1Fail = 4;
const int r4Final = 1;
const int r4Fail = 2;

module _r5
  r5 : [0..12];
  r5retry_t2l5 : [0..r5_maxRetry_t2l5] init 0;
  r5retry_t3l8b : [0..r5_maxRetry_t3l8b] init 0;
  r5retry_t2l8b : [0..r5_maxRetry_t2l8b] init 0;
  r5retry_t2l8a : [0..r5_maxRetry_t2l8a] init 0;
  r5retry_t3l8 : [0..r5_maxRetry_t3l8] init 0;
  r5retry_t2l8c : [0..r5_maxRetry_t2l8c] init 0;
  r5retry_t2l8d : [0..r5_maxRetry_t2l8d] init 0;

  [r5movel2] r5=0-> 1:(r5'=0+1);
  [r5movel5] r5=1-> 1:(r5'=1+1);
  [r5dot2l5Retry] r5=2 & r5retry_t2l5 < r5_maxRetry_t2l5 -> p_r5_t2l5 : (r5'=r5+1) + (1-p_r5_t2l5) : (r5'=r5) & (r5retry_t2l5' = r5retry_t2l5+1);
  [r5dot2l5] r5=2 & r5retry_t2l5 >= r5_maxRetry_t2l5 -> 1:(r5'=r5Fail);
  [r5movel8] r5=3-> 1:(r5'=3+1);
  [r5dot3l8bRetry] r5=4 & r5retry_t3l8b < r5_maxRetry_t3l8b -> p_r5_t3l8b : (r5'=r5+1) + (1-p_r5_t3l8b) : (r5'=r5) & (r5retry_t3l8b' = r5retry_t3l8b+1);
  [r5dot3l8b] r5=4 & r5retry_t3l8b >= r5_maxRetry_t3l8b -> 1:(r5'=r5Fail);
  [r5dot2l8bRetry] r5=5 & r5retry_t2l8b < r5_maxRetry_t2l8b -> p_r5_t2l8b : (r5'=r5+1) + (1-p_r5_t2l8b) : (r5'=r5) & (r5retry_t2l8b' = r5retry_t2l8b+1);
  [r5dot2l8b] r5=5 & r5retry_t2l8b >= r5_maxRetry_t2l8b -> 1:(r5'=r5Fail);
  [r5dot2l8aRetry] r5=6 & r5retry_t2l8a < r5_maxRetry_t2l8a -> p_r5_t2l8a : (r5'=r5+1) + (1-p_r5_t2l8a) : (r5'=r5) & (r5retry_t2l8a' = r5retry_t2l8a+1);
  [r5dot2l8a] r5=6 & r5retry_t2l8a >= r5_maxRetry_t2l8a -> 1:(r5'=r5Fail);
  [r5dot3l8Retry] r5=7 & r5retry_t3l8 < r5_maxRetry_t3l8 -> p_r5_t3l8 : (r5'=r5+1) + (1-p_r5_t3l8) : (r5'=r5) & (r5retry_t3l8' = r5retry_t3l8+1);
  [r5dot3l8] r5=7 & r5retry_t3l8 >= r5_maxRetry_t3l8 -> 1:(r5'=r5Fail);
  [r5dot2l8cRetry] r5=8 & r5retry_t2l8c < r5_maxRetry_t2l8c -> p_r5_t2l8c : (r5'=r5+1) + (1-p_r5_t2l8c) : (r5'=r5) & (r5retry_t2l8c' = r5retry_t2l8c+1);
  [r5dot2l8c] r5=8 & r5retry_t2l8c >= r5_maxRetry_t2l8c -> 1:(r5'=r5Fail);
  [r5dot2l8dRetry] r5=9 & r5retry_t2l8d < r5_maxRetry_t2l8d -> p_r5_t2l8d : (r5'=r5+1) + (1-p_r5_t2l8d) : (r5'=r5) & (r5retry_t2l8d' = r5retry_t2l8d+1);
  [r5dot2l8d] r5=9 & r5retry_t2l8d >= r5_maxRetry_t2l8d -> 1:(r5'=r5Fail);
endmodule

module _worker2
  worker2 : [0..16];
  worker2retry_t3l4 : [0..worker2_maxRetry_t3l4] init 0;
  worker2retry_t1l4 : [0..worker2_maxRetry_t1l4] init 0;
  worker2retry_t3l7 : [0..worker2_maxRetry_t3l7] init 0;
  worker2retry_t1l6a : [0..worker2_maxRetry_t1l6a] init 0;
  worker2retry_t3l9 : [0..worker2_maxRetry_t3l9] init 0;
  worker2retry_t3l9b : [0..worker2_maxRetry_t3l9b] init 0;
  worker2retry_t1l6b : [0..worker2_maxRetry_t1l6b] init 0;

  [worker2movel4] worker2=0-> 1:(worker2'=0+1);
  [worker2dot3l4Retry] worker2=1 & worker2retry_t3l4 < worker2_maxRetry_t3l4 -> p_worker2_t3l4 : (worker2'=worker2+1) + (1-p_worker2_t3l4) : (worker2'=worker2) & (worker2retry_t3l4' = worker2retry_t3l4+1);
  [worker2dot3l4] worker2=1 & worker2retry_t3l4 >= worker2_maxRetry_t3l4 -> 1:(worker2'=worker2Fail);
  [worker2dot1l4Retry] worker2=2 & worker2retry_t1l4 < worker2_maxRetry_t1l4 -> p_worker2_t1l4 : (worker2'=worker2+1) + (1-p_worker2_t1l4) : (worker2'=worker2) & (worker2retry_t1l4' = worker2retry_t1l4+1);
  [worker2dot1l4] worker2=2 & worker2retry_t1l4 >= worker2_maxRetry_t1l4 -> 1:(worker2'=worker2Fail);
  [worker2movel7] worker2=3-> 1:(worker2'=3+1);
  [worker2dot3l7Retry] worker2=4 & worker2retry_t3l7 < worker2_maxRetry_t3l7 -> p_worker2_t3l7 : (worker2'=worker2+1) + (1-p_worker2_t3l7) : (worker2'=worker2) & (worker2retry_t3l7' = worker2retry_t3l7+1);
  [worker2dot3l7] worker2=4 & worker2retry_t3l7 >= worker2_maxRetry_t3l7 -> 1:(worker2'=worker2Fail);
  [worker2movel4] worker2=5-> 1:(worker2'=5+1);
  [worker2movel5] worker2=6-> 1:(worker2'=6+1);
  [worker2movel6] worker2=7-> 1:(worker2'=7+1);
  [worker2dot1l6aRetry] worker2=8 & worker2retry_t1l6a < worker2_maxRetry_t1l6a -> p_worker2_t1l6a : (worker2'=worker2+1) + (1-p_worker2_t1l6a) : (worker2'=worker2) & (worker2retry_t1l6a' = worker2retry_t1l6a+1);
  [worker2dot1l6a] worker2=8 & worker2retry_t1l6a >= worker2_maxRetry_t1l6a -> 1:(worker2'=worker2Fail);
  [worker2movel9] worker2=9-> 1:(worker2'=9+1);
  [worker2dot3l9Retry] worker2=10 & worker2retry_t3l9 < worker2_maxRetry_t3l9 -> p_worker2_t3l9 : (worker2'=worker2+1) + (1-p_worker2_t3l9) : (worker2'=worker2) & (worker2retry_t3l9' = worker2retry_t3l9+1);
  [worker2dot3l9] worker2=10 & worker2retry_t3l9 >= worker2_maxRetry_t3l9 -> 1:(worker2'=worker2Fail);
  [worker2dot3l9bRetry] worker2=11 & worker2retry_t3l9b < worker2_maxRetry_t3l9b -> p_worker2_t3l9b : (worker2'=worker2+1) + (1-p_worker2_t3l9b) : (worker2'=worker2) & (worker2retry_t3l9b' = worker2retry_t3l9b+1);
  [worker2dot3l9b] worker2=11 & worker2retry_t3l9b >= worker2_maxRetry_t3l9b -> 1:(worker2'=worker2Fail);
  [worker2movel6] worker2=12-> 1:(worker2'=12+1);
  [worker2dot1l6bRetry] worker2=13 & worker2retry_t1l6b < worker2_maxRetry_t1l6b -> p_worker2_t1l6b : (worker2'=worker2+1) + (1-p_worker2_t1l6b) : (worker2'=worker2) & (worker2retry_t1l6b' = worker2retry_t1l6b+1);
  [worker2dot1l6b] worker2=13 & worker2retry_t1l6b >= worker2_maxRetry_t1l6b -> 1:(worker2'=worker2Fail);
endmodule

module _worker1
  worker1 : [0..5];
  worker1retry_t1l7 : [0..worker1_maxRetry_t1l7] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1movel7] worker1=1-> 1:(worker1'=1+1);
  [worker1dot1l7Retry] worker1=2 & worker1retry_t1l7 < worker1_maxRetry_t1l7 -> p_worker1_t1l7 : (worker1'=worker1+1) + (1-p_worker1_t1l7) : (worker1'=worker1) & (worker1retry_t1l7' = worker1retry_t1l7+1);
  [worker1dot1l7] worker1=2 & worker1retry_t1l7 >= worker1_maxRetry_t1l7 -> 1:(worker1'=worker1Fail);
endmodule

module _r4
  r4 : [0..3];

  [r4movel2] r4=0-> 1:(r4'=0+1);
endmodule

formula r_r5_t2l5_ORIGINAL = 1;
formula r_r5_t2l5 = r_r5_t2l5_ORIGINAL * (r5retry_t2l5+1);
formula r_r5_t3l8b_ORIGINAL = 1;
formula r_r5_t3l8b = r_r5_t3l8b_ORIGINAL * (r5retry_t3l8b+1);
formula r_r5_t2l8b_ORIGINAL = 1;
formula r_r5_t2l8b = r_r5_t2l8b_ORIGINAL * (r5retry_t2l8b+1);
formula r_r5_t2l8a_ORIGINAL = 1;
formula r_r5_t2l8a = r_r5_t2l8a_ORIGINAL * (r5retry_t2l8a+1);
formula r_r5_t3l8_ORIGINAL = 1;
formula r_r5_t3l8 = r_r5_t3l8_ORIGINAL * (r5retry_t3l8+1);
formula r_r5_t2l8c_ORIGINAL = 1;
formula r_r5_t2l8c = r_r5_t2l8c_ORIGINAL * (r5retry_t2l8c+1);
formula r_r5_t2l8d_ORIGINAL = 1;
formula r_r5_t2l8d = r_r5_t2l8d_ORIGINAL * (r5retry_t2l8d+1);
formula r_worker2_t3l4_ORIGINAL = 5;
formula r_worker2_t3l4 = r_worker2_t3l4_ORIGINAL * (worker2retry_t3l4+1);
formula r_worker2_t1l4_ORIGINAL = 3;
formula r_worker2_t1l4 = r_worker2_t1l4_ORIGINAL * (worker2retry_t1l4+1);
formula r_worker2_t3l7_ORIGINAL = 5;
formula r_worker2_t3l7 = r_worker2_t3l7_ORIGINAL * (worker2retry_t3l7+1);
formula r_worker2_t1l6a_ORIGINAL = 3;
formula r_worker2_t1l6a = r_worker2_t1l6a_ORIGINAL * (worker2retry_t1l6a+1);
formula r_worker2_t3l9_ORIGINAL = 5;
formula r_worker2_t3l9 = r_worker2_t3l9_ORIGINAL * (worker2retry_t3l9+1);
formula r_worker2_t3l9b_ORIGINAL = 5;
formula r_worker2_t3l9b = r_worker2_t3l9b_ORIGINAL * (worker2retry_t3l9b+1);
formula r_worker2_t1l6b_ORIGINAL = 3;
formula r_worker2_t1l6b = r_worker2_t1l6b_ORIGINAL * (worker2retry_t1l6b+1);
formula r_worker1_t1l7_ORIGINAL = 3;
formula r_worker1_t1l7 = r_worker1_t1l7_ORIGINAL * (worker1retry_t1l7+1);


rewards "cost"
  [r5movel2] true:1;
  [r5movel5] true:1;
  [r5dot2l5] true:1;
  [r5dot2l5Retry] true:1;
  [r5movel8] true:1;
  [r5dot3l8b] true:1;
  [r5dot3l8bRetry] true:1;
  [r5dot2l8b] true:1;
  [r5dot2l8bRetry] true:1;
  [r5dot2l8a] true:1;
  [r5dot2l8aRetry] true:1;
  [r5dot3l8] true:1;
  [r5dot3l8Retry] true:1;
  [r5dot2l8c] true:1;
  [r5dot2l8cRetry] true:1;
  [r5dot2l8d] true:1;
  [r5dot2l8dRetry] true:1;
  [worker2movel4] true:1;
  [worker2dot3l4] true:5;
  [worker2dot3l4Retry] true:5;
  [worker2dot1l4] true:3;
  [worker2dot1l4Retry] true:3;
  [worker2movel7] true:1;
  [worker2dot3l7] true:5;
  [worker2dot3l7Retry] true:5;
  [worker2movel4] true:1;
  [worker2movel5] true:1;
  [worker2movel6] true:1;
  [worker2dot1l6a] true:3;
  [worker2dot1l6aRetry] true:3;
  [worker2movel9] true:1;
  [worker2dot3l9] true:5;
  [worker2dot3l9Retry] true:5;
  [worker2dot3l9b] true:5;
  [worker2dot3l9bRetry] true:5;
  [worker2movel6] true:1;
  [worker2dot1l6b] true:3;
  [worker2dot1l6bRetry] true:3;
  [worker1movel4] true:1;
  [worker1movel7] true:1;
  [worker1dot1l7] true:3;
  [worker1dot1l7Retry] true:3;
  [r4movel2] true:1;
endrewards