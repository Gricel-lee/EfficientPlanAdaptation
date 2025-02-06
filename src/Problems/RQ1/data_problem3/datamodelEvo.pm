dtmc
evolve int worker1_maxRetry_t3l4 [1..5];
evolve int worker1_maxRetry_t3l7 [1..5];
evolve int worker1_maxRetry_t3l9 [1..5];

const double p_worker1_t3l4=0.99;
const double p_worker1_t3l7=0.99;
const double p_worker1_t3l9=0.99;
const int worker1Final = 7;
const int worker1Fail = 8;

module _worker1
  worker1 : [0..9];
  worker1retry_t3l4 : [0..worker1_maxRetry_t3l4] init 0;
  worker1retry_t3l7 : [0..worker1_maxRetry_t3l7] init 0;
  worker1retry_t3l9 : [0..worker1_maxRetry_t3l9] init 0;

  [worker1movel4] worker1=0-> 1:(worker1'=0+1);
  [worker1dot3l4Retry] worker1=1 & worker1retry_t3l4 < worker1_maxRetry_t3l4 -> p_worker1_t3l4 : (worker1'=worker1+1) + (1-p_worker1_t3l4) : (worker1'=worker1) & (worker1retry_t3l4' = worker1retry_t3l4+1);
  [worker1dot3l4] worker1=1 & worker1retry_t3l4 >= worker1_maxRetry_t3l4 -> 1:(worker1'=worker1Fail);
  [worker1movel7] worker1=2-> 1:(worker1'=2+1);
  [worker1dot3l7Retry] worker1=3 & worker1retry_t3l7 < worker1_maxRetry_t3l7 -> p_worker1_t3l7 : (worker1'=worker1+1) + (1-p_worker1_t3l7) : (worker1'=worker1) & (worker1retry_t3l7' = worker1retry_t3l7+1);
  [worker1dot3l7] worker1=3 & worker1retry_t3l7 >= worker1_maxRetry_t3l7 -> 1:(worker1'=worker1Fail);
  [worker1movel8] worker1=4-> 1:(worker1'=4+1);
  [worker1movel9] worker1=5-> 1:(worker1'=5+1);
  [worker1dot3l9Retry] worker1=6 & worker1retry_t3l9 < worker1_maxRetry_t3l9 -> p_worker1_t3l9 : (worker1'=worker1+1) + (1-p_worker1_t3l9) : (worker1'=worker1) & (worker1retry_t3l9' = worker1retry_t3l9+1);
  [worker1dot3l9] worker1=6 & worker1retry_t3l9 >= worker1_maxRetry_t3l9 -> 1:(worker1'=worker1Fail);
endmodule

rewards "cost"
  [worker1movel4] true:1;
  [worker1dot3l4] true:5;
  [worker1dot3l4Retry] true:5;
  [worker1movel7] true:1;
  [worker1dot3l7] true:5;
  [worker1dot3l7Retry] true:5;
  [worker1movel8] true:1;
  [worker1movel9] true:1;
  [worker1dot3l9] true:5;
  [worker1dot3l9Retry] true:5;
endrewards