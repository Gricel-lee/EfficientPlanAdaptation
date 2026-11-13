dtmc
evolve int human1_maxRetry_Harvest_Row1 [1..3];
evolve int human1_maxRetry_Deliver_Box1_CP [1..3];
evolve int human1_maxRetry_Harvest_Row3 [1..3];
evolve int human1_maxRetry_Deliver_Box3_HP [1..3];
evolve int human1_maxRetry_Harvest_Row2 [1..3];
evolve int human1_maxRetry_Deliver_Box2_CP [1..3];
evolve int human1_maxRetry_Harvest_Row4 [1..3];
evolve int human1_maxRetry_Deliver_Box4_HP [1..3];
evolve int tractor1_maxRetry_Tractor_Final [1..3];

const double p_human1_Harvest_Row1_ORIGINAL=1;
const double p_human1_Deliver_Box1_CP_ORIGINAL=1;
const double p_human1_Harvest_Row3_ORIGINAL=1;
const double p_human1_Deliver_Box3_HP_ORIGINAL=1;
const double p_human1_Harvest_Row2_ORIGINAL=1;
const double p_human1_Deliver_Box2_CP_ORIGINAL=1;
const double p_human1_Harvest_Row4_ORIGINAL=1;
const double p_human1_Deliver_Box4_HP_ORIGINAL=1;
const double p_tractor1_Tractor_Final_ORIGINAL=1;

const double e = 2.718281828459045;
const double steepnesshuman1_Harvest_Row1 = 1.0;
const double steepnesshuman1_Deliver_Box1_CP = 1.0;
const double steepnesshuman1_Harvest_Row3 = 1.0;
const double steepnesshuman1_Deliver_Box3_HP = 1.0;
const double steepnesshuman1_Harvest_Row2 = 1.0;
const double steepnesshuman1_Deliver_Box2_CP = 1.0;
const double steepnesshuman1_Harvest_Row4 = 1.0;
const double steepnesshuman1_Deliver_Box4_HP = 1.0;
const double steepnesstractor1_Tractor_Final = 1.0;

formula p_human1_Harvest_Row1 = 2 * (1 - p_human1_Harvest_Row1_ORIGINAL) * (1 / (1 + 1/pow(e,(human1retry_Harvest_Row1 * steepnesshuman1_Harvest_Row1)))) + (2 * p_human1_Harvest_Row1_ORIGINAL - 1);
formula p_human1_Deliver_Box1_CP = 2 * (1 - p_human1_Deliver_Box1_CP_ORIGINAL) * (1 / (1 + 1/pow(e,(human1retry_Deliver_Box1_CP * steepnesshuman1_Deliver_Box1_CP)))) + (2 * p_human1_Deliver_Box1_CP_ORIGINAL - 1);
formula p_human1_Harvest_Row3 = 2 * (1 - p_human1_Harvest_Row3_ORIGINAL) * (1 / (1 + 1/pow(e,(human1retry_Harvest_Row3 * steepnesshuman1_Harvest_Row3)))) + (2 * p_human1_Harvest_Row3_ORIGINAL - 1);
formula p_human1_Deliver_Box3_HP = 2 * (1 - p_human1_Deliver_Box3_HP_ORIGINAL) * (1 / (1 + 1/pow(e,(human1retry_Deliver_Box3_HP * steepnesshuman1_Deliver_Box3_HP)))) + (2 * p_human1_Deliver_Box3_HP_ORIGINAL - 1);
formula p_human1_Harvest_Row2 = 2 * (1 - p_human1_Harvest_Row2_ORIGINAL) * (1 / (1 + 1/pow(e,(human1retry_Harvest_Row2 * steepnesshuman1_Harvest_Row2)))) + (2 * p_human1_Harvest_Row2_ORIGINAL - 1);
formula p_human1_Deliver_Box2_CP = 2 * (1 - p_human1_Deliver_Box2_CP_ORIGINAL) * (1 / (1 + 1/pow(e,(human1retry_Deliver_Box2_CP * steepnesshuman1_Deliver_Box2_CP)))) + (2 * p_human1_Deliver_Box2_CP_ORIGINAL - 1);
formula p_human1_Harvest_Row4 = 2 * (1 - p_human1_Harvest_Row4_ORIGINAL) * (1 / (1 + 1/pow(e,(human1retry_Harvest_Row4 * steepnesshuman1_Harvest_Row4)))) + (2 * p_human1_Harvest_Row4_ORIGINAL - 1);
formula p_human1_Deliver_Box4_HP = 2 * (1 - p_human1_Deliver_Box4_HP_ORIGINAL) * (1 / (1 + 1/pow(e,(human1retry_Deliver_Box4_HP * steepnesshuman1_Deliver_Box4_HP)))) + (2 * p_human1_Deliver_Box4_HP_ORIGINAL - 1);
formula p_tractor1_Tractor_Final = 2 * (1 - p_tractor1_Tractor_Final_ORIGINAL) * (1 / (1 + 1/pow(e,(tractor1retry_Tractor_Final * steepnesstractor1_Tractor_Final)))) + (2 * p_tractor1_Tractor_Final_ORIGINAL - 1);

const int human1Final = 14;
const int human1Fail = 15;
const int tractor1Final = 1;
const int tractor1Fail = 2;

module _human1
  human1 : [0..16];
  human1retry_Harvest_Row1 : [0..human1_maxRetry_Harvest_Row1] init 0;
  human1retry_Deliver_Box1_CP : [0..human1_maxRetry_Deliver_Box1_CP] init 0;
  human1retry_Harvest_Row3 : [0..human1_maxRetry_Harvest_Row3] init 0;
  human1retry_Deliver_Box3_HP : [0..human1_maxRetry_Deliver_Box3_HP] init 0;
  human1retry_Harvest_Row2 : [0..human1_maxRetry_Harvest_Row2] init 0;
  human1retry_Deliver_Box2_CP : [0..human1_maxRetry_Deliver_Box2_CP] init 0;
  human1retry_Harvest_Row4 : [0..human1_maxRetry_Harvest_Row4] init 0;
  human1retry_Deliver_Box4_HP : [0..human1_maxRetry_Deliver_Box4_HP] init 0;

  [human1movel1] human1=0-> 1:(human1'=0+1);
  [human1doHarvest_Row1Retry] human1=1 & human1retry_Harvest_Row1 < human1_maxRetry_Harvest_Row1 -> p_human1_Harvest_Row1 : (human1'=human1+1) + (1-p_human1_Harvest_Row1) : (human1'=human1) & (human1retry_Harvest_Row1' = human1retry_Harvest_Row1+1);
  [human1doHarvest_Row1] human1=1 & human1retry_Harvest_Row1 >= human1_maxRetry_Harvest_Row1 -> 1:(human1'=human1Fail);
  [human1doDeliver_Box1_CPRetry] human1=2 & human1retry_Deliver_Box1_CP < human1_maxRetry_Deliver_Box1_CP -> p_human1_Deliver_Box1_CP : (human1'=human1+1) + (1-p_human1_Deliver_Box1_CP) : (human1'=human1) & (human1retry_Deliver_Box1_CP' = human1retry_Deliver_Box1_CP+1);
  [human1doDeliver_Box1_CP] human1=2 & human1retry_Deliver_Box1_CP >= human1_maxRetry_Deliver_Box1_CP -> 1:(human1'=human1Fail);
  [human1movel6] human1=3-> 1:(human1'=3+1);
  [human1movel5] human1=4-> 1:(human1'=4+1);
  [human1doHarvest_Row3Retry] human1=5 & human1retry_Harvest_Row3 < human1_maxRetry_Harvest_Row3 -> p_human1_Harvest_Row3 : (human1'=human1+1) + (1-p_human1_Harvest_Row3) : (human1'=human1) & (human1retry_Harvest_Row3' = human1retry_Harvest_Row3+1);
  [human1doHarvest_Row3] human1=5 & human1retry_Harvest_Row3 >= human1_maxRetry_Harvest_Row3 -> 1:(human1'=human1Fail);
  [human1doDeliver_Box3_HPRetry] human1=6 & human1retry_Deliver_Box3_HP < human1_maxRetry_Deliver_Box3_HP -> p_human1_Deliver_Box3_HP : (human1'=human1+1) + (1-p_human1_Deliver_Box3_HP) : (human1'=human1) & (human1retry_Deliver_Box3_HP' = human1retry_Deliver_Box3_HP+1);
  [human1doDeliver_Box3_HP] human1=6 & human1retry_Deliver_Box3_HP >= human1_maxRetry_Deliver_Box3_HP -> 1:(human1'=human1Fail);
  [human1movel3] human1=7-> 1:(human1'=7+1);
  [human1doHarvest_Row2Retry] human1=8 & human1retry_Harvest_Row2 < human1_maxRetry_Harvest_Row2 -> p_human1_Harvest_Row2 : (human1'=human1+1) + (1-p_human1_Harvest_Row2) : (human1'=human1) & (human1retry_Harvest_Row2' = human1retry_Harvest_Row2+1);
  [human1doHarvest_Row2] human1=8 & human1retry_Harvest_Row2 >= human1_maxRetry_Harvest_Row2 -> 1:(human1'=human1Fail);
  [human1doDeliver_Box2_CPRetry] human1=9 & human1retry_Deliver_Box2_CP < human1_maxRetry_Deliver_Box2_CP -> p_human1_Deliver_Box2_CP : (human1'=human1+1) + (1-p_human1_Deliver_Box2_CP) : (human1'=human1) & (human1retry_Deliver_Box2_CP' = human1retry_Deliver_Box2_CP+1);
  [human1doDeliver_Box2_CP] human1=9 & human1retry_Deliver_Box2_CP >= human1_maxRetry_Deliver_Box2_CP -> 1:(human1'=human1Fail);
  [human1movel8] human1=10-> 1:(human1'=10+1);
  [human1doHarvest_Row4Retry] human1=11 & human1retry_Harvest_Row4 < human1_maxRetry_Harvest_Row4 -> p_human1_Harvest_Row4 : (human1'=human1+1) + (1-p_human1_Harvest_Row4) : (human1'=human1) & (human1retry_Harvest_Row4' = human1retry_Harvest_Row4+1);
  [human1doHarvest_Row4] human1=11 & human1retry_Harvest_Row4 >= human1_maxRetry_Harvest_Row4 -> 1:(human1'=human1Fail);
  [human1movel8] human1=12-> 1:(human1'=12+1);
  [human1doDeliver_Box4_HPRetry] human1=13 & human1retry_Deliver_Box4_HP < human1_maxRetry_Deliver_Box4_HP -> p_human1_Deliver_Box4_HP : (human1'=human1+1) + (1-p_human1_Deliver_Box4_HP) : (human1'=human1) & (human1retry_Deliver_Box4_HP' = human1retry_Deliver_Box4_HP+1);
  [human1doDeliver_Box4_HP] human1=13 & human1retry_Deliver_Box4_HP >= human1_maxRetry_Deliver_Box4_HP -> 1:(human1'=human1Fail);
endmodule

module _tractor1
  tractor1 : [0..3];
  tractor1retry_Tractor_Final : [0..tractor1_maxRetry_Tractor_Final] init 0;

  [tractor1doTractor_FinalRetry] tractor1=0 & tractor1retry_Tractor_Final < tractor1_maxRetry_Tractor_Final -> p_tractor1_Tractor_Final : (tractor1'=tractor1+1) + (1-p_tractor1_Tractor_Final) : (tractor1'=tractor1) & (tractor1retry_Tractor_Final' = tractor1retry_Tractor_Final+1);
  [tractor1doTractor_Final] tractor1=0 & tractor1retry_Tractor_Final >= tractor1_maxRetry_Tractor_Final -> 1:(tractor1'=tractor1Fail);
endmodule

formula r_human1_Harvest_Row1_ORIGINAL = 3;
formula r_human1_Harvest_Row1 = r_human1_Harvest_Row1_ORIGINAL * (human1retry_Harvest_Row1+1);
formula r_human1_Deliver_Box1_CP_ORIGINAL = 1;
formula r_human1_Deliver_Box1_CP = r_human1_Deliver_Box1_CP_ORIGINAL * (human1retry_Deliver_Box1_CP+1);
formula r_human1_Harvest_Row3_ORIGINAL = 3;
formula r_human1_Harvest_Row3 = r_human1_Harvest_Row3_ORIGINAL * (human1retry_Harvest_Row3+1);
formula r_human1_Deliver_Box3_HP_ORIGINAL = 1;
formula r_human1_Deliver_Box3_HP = r_human1_Deliver_Box3_HP_ORIGINAL * (human1retry_Deliver_Box3_HP+1);
formula r_human1_Harvest_Row2_ORIGINAL = 3;
formula r_human1_Harvest_Row2 = r_human1_Harvest_Row2_ORIGINAL * (human1retry_Harvest_Row2+1);
formula r_human1_Deliver_Box2_CP_ORIGINAL = 1;
formula r_human1_Deliver_Box2_CP = r_human1_Deliver_Box2_CP_ORIGINAL * (human1retry_Deliver_Box2_CP+1);
formula r_human1_Harvest_Row4_ORIGINAL = 3;
formula r_human1_Harvest_Row4 = r_human1_Harvest_Row4_ORIGINAL * (human1retry_Harvest_Row4+1);
formula r_human1_Deliver_Box4_HP_ORIGINAL = 1;
formula r_human1_Deliver_Box4_HP = r_human1_Deliver_Box4_HP_ORIGINAL * (human1retry_Deliver_Box4_HP+1);
formula r_tractor1_Tractor_Final_ORIGINAL = 0;
formula r_tractor1_Tractor_Final = r_tractor1_Tractor_Final_ORIGINAL * (tractor1retry_Tractor_Final+1);


rewards "cost"
  [human1movel1] true:1;
  [human1doHarvest_Row1] true:3;
  [human1doHarvest_Row1Retry] true:3;
  [human1doDeliver_Box1_CP] true:1;
  [human1doDeliver_Box1_CPRetry] true:1;
  [human1movel6] true:1;
  [human1movel5] true:1;
  [human1doHarvest_Row3] true:3;
  [human1doHarvest_Row3Retry] true:3;
  [human1doDeliver_Box3_HP] true:1;
  [human1doDeliver_Box3_HPRetry] true:1;
  [human1movel3] true:1;
  [human1doHarvest_Row2] true:3;
  [human1doHarvest_Row2Retry] true:3;
  [human1doDeliver_Box2_CP] true:1;
  [human1doDeliver_Box2_CPRetry] true:1;
  [human1movel8] true:1;
  [human1doHarvest_Row4] true:3;
  [human1doHarvest_Row4Retry] true:3;
  [human1movel8] true:1;
  [human1doDeliver_Box4_HP] true:1;
  [human1doDeliver_Box4_HPRetry] true:1;
  [tractor1doTractor_Final] true:0;
  [tractor1doTractor_FinalRetry] true:0;
endrewards