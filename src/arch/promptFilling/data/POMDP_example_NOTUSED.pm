pomdp

observables step,attentionPred,underPred endobservables

const int s_total = 6;
formula done = step = s_total;

module Turn
 step:[0..s_total] init 0;
 [observeUserAttention]   step=0 -> 1:(step'=1);
 [observeUserUnderstand] step=1 -> 1:(step'=2);
 [select_prompt_a1] step=2 -> 1:(step'=3);
 [select_prompt_a2] step=2 -> 1:(step'=3);
 [select_prompt_b1] step=3 -> 1:(step'=4);
 [select_prompt_b2] step=3 -> 1:(step'=4);
 [select_prompt_c1] step=4 -> 1:(step'=5);
 [select_prompt_c2] step=4 -> 1:(step'=5);
 [select_prompt_c3] step=4 -> 1:(step'=5);

 [end]step=5 ->1:(step'=s_total);
endmodule

const int user_instance=1;  // non_expert, planning_expert or case_study_expert
const int profile = user_instance;
// Note: One profile required in this model as the user profile (non-expert, AI expert or domain expert) is instantiated from information from the frontend.
// In the paper, all users are defined in the same model and the profile is selected within the model.


const int low = 0;
const int high = 1;


const int max_prompt_inputs=3;

const double pHH=0.4;
const double pHL=0.1;
const double pLH=0.05;
const double pLL=1-pHH-pHL-pLH;
const double pHH_u=0.2;
const double pHL_u=0.05;
const double pLH_u=0.15;
const double pLL_u=1-pHH_u-pHL_u-pLH_u;


module HumanBehavioralModel
 attention:[0..1] init high;
 attentionPred:[0..1] init high;
 under:[0..1] init high;
 underPred:[0..1] init high;

 [observeUserAttention] profile=user_instance & step=0 -> pHH:(attention'=high)&(attentionPred'=high)+
            pHL:(attention'=high)&(attentionPred'=low)+
            pLH:(attention'=low)&(attentionPred'=high)+
            pLL:(attention'=low)&(attentionPred'=low);
 [observeUserUnderstand] profile=user_instance & step=1 -> pHH_u:(under'=high)&(underPred'=high)+
            pHL_u:(under'=high)&(underPred'=low)+
            pLH_u:(under'=low)&(underPred'=high)+
            pLL_u:(under'=low)&(underPred'=low);
endmodule

const int prompt_accepted_a1 = 5;
const int prompt_rejected_a1 = 4;
const int prompt_accepted_a2 = 10;
const int prompt_rejected_a2 = 1;
const int prompt_accepted_b1 = 2;
const int prompt_rejected_b1 = 7;
const int prompt_accepted_b2 = 15;
const int prompt_rejected_b2 = 3;
const int prompt_accepted_c1 = 23;
const int prompt_rejected_c1 = 6;
const int prompt_accepted_c2 = 1;
const int prompt_rejected_c2 = 12;
const int prompt_accepted_c3 = 14;
const int prompt_rejected_c3 = 13;


const double alpha0 = 1;
const double beta0 = 1;
const double b_min = 5;
const double b_max = 20;
const double kappa_okay = 0.75;
const double kappa_mismatch = 0.5;

const double alpha_user_instance = 0.88;

formula r_non_a1 = (prompt_accepted_a1 + alpha0) / (prompt_accepted_a1 + prompt_rejected_a1 + alpha0 + beta0);
formula utility_non_a1_match = b_min + (b_max - b_min) * pow(r_non_a1, alpha_user_instance);
formula utility_non_a1_okay = b_min + kappa_okay * (b_max - b_min) * pow(r_non_a1, alpha_user_instance);
formula utility_non_a1_mismatch = b_min + kappa_mismatch * (b_max - b_min) * pow(r_non_a1, alpha_user_instance);

formula r_non_a2 = (prompt_accepted_a2 + alpha0) / (prompt_accepted_a2 + prompt_rejected_a2 + alpha0 + beta0);
formula utility_non_a2_match = b_min + (b_max - b_min) * pow(r_non_a2, alpha_user_instance);
formula utility_non_a2_okay = b_min + kappa_okay * (b_max - b_min) * pow(r_non_a2, alpha_user_instance);
formula utility_non_a2_mismatch = b_min + kappa_mismatch * (b_max - b_min) * pow(r_non_a2, alpha_user_instance);

formula r_non_b1 = (prompt_accepted_b1 + alpha0) / (prompt_accepted_b1 + prompt_rejected_b1 + alpha0 + beta0);
formula utility_non_b1_match = b_min + (b_max - b_min) * pow(r_non_b1, alpha_user_instance);
formula utility_non_b1_okay = b_min + kappa_okay * (b_max - b_min) * pow(r_non_b1, alpha_user_instance);
formula utility_non_b1_mismatch = b_min + kappa_mismatch * (b_max - b_min) * pow(r_non_b1, alpha_user_instance);

formula r_non_b2 = (prompt_accepted_b2 + alpha0) / (prompt_accepted_b2 + prompt_rejected_b2 + alpha0 + beta0);
formula utility_non_b2_match = b_min + (b_max - b_min) * pow(r_non_b2, alpha_user_instance);
formula utility_non_b2_okay = b_min + kappa_okay * (b_max - b_min) * pow(r_non_b2, alpha_user_instance);
formula utility_non_b2_mismatch = b_min + kappa_mismatch * (b_max - b_min) * pow(r_non_b2, alpha_user_instance);

formula r_non_c1 = (prompt_accepted_c1 + alpha0) / (prompt_accepted_c1 + prompt_rejected_c1 + alpha0 + beta0);
formula utility_non_c1_match = b_min + (b_max - b_min) * pow(r_non_c1, alpha_user_instance);
formula utility_non_c1_okay = b_min + kappa_okay * (b_max - b_min) * pow(r_non_c1, alpha_user_instance);
formula utility_non_c1_mismatch = b_min + kappa_mismatch * (b_max - b_min) * pow(r_non_c1, alpha_user_instance);

formula r_non_c2 = (prompt_accepted_c2 + alpha0) / (prompt_accepted_c2 + prompt_rejected_c2 + alpha0 + beta0);
formula utility_non_c2_match = b_min + (b_max - b_min) * pow(r_non_c2, alpha_user_instance);
formula utility_non_c2_okay = b_min + kappa_okay * (b_max - b_min) * pow(r_non_c2, alpha_user_instance);
formula utility_non_c2_mismatch = b_min + kappa_mismatch * (b_max - b_min) * pow(r_non_c2, alpha_user_instance);

formula r_non_c3 = (prompt_accepted_c3 + alpha0) / (prompt_accepted_c3 + prompt_rejected_c3 + alpha0 + beta0);
formula utility_non_c3_match = b_min + (b_max - b_min) * pow(r_non_c3, alpha_user_instance);
formula utility_non_c3_okay = b_min + kappa_okay * (b_max - b_min) * pow(r_non_c3, alpha_user_instance);
formula utility_non_c3_mismatch = b_min + kappa_mismatch * (b_max - b_min) * pow(r_non_c3, alpha_user_instance);


rewards "acceptance"
[select_prompt_a1] profile=user_instance & attention=high & under=high: utility_non_a1_match;
[select_prompt_a1] profile=user_instance & attention=high & under=low: utility_non_a1_match;
[select_prompt_a1] profile=user_instance & attention=low & under=high: utility_non_a1_mismatch;
[select_prompt_a1] profile=user_instance & attention=low & under=low: utility_non_a1_mismatch;
[select_prompt_a2] profile=user_instance & attention=high & under=high: utility_non_a2_okay;
[select_prompt_a2] profile=user_instance & attention=high & under=low: utility_non_a2_okay;
[select_prompt_a2] profile=user_instance & attention=low & under=high: utility_non_a2_match;
[select_prompt_a2] profile=user_instance & attention=low & under=low: utility_non_a2_match;
[select_prompt_b1] profile=user_instance & attention=high & under=high: utility_non_b1_okay;
[select_prompt_b1] profile=user_instance & attention=high & under=low: utility_non_b1_mismatch;
[select_prompt_b1] profile=user_instance & attention=low & under=high: utility_non_b1_okay;
[select_prompt_b1] profile=user_instance & attention=low & under=low: utility_non_b1_mismatch;
[select_prompt_b2] profile=user_instance & attention=high & under=high: utility_non_b2_match;
[select_prompt_b2] profile=user_instance & attention=high & under=low: utility_non_b2_match;
[select_prompt_b2] profile=user_instance & attention=low & under=high: utility_non_b2_okay;
[select_prompt_b2] profile=user_instance & attention=low & under=low: utility_non_b2_okay;
[select_prompt_c1] profile=user_instance & attention=high & under=high: utility_non_c1_match;
[select_prompt_c1] profile=user_instance & attention=high & under=low: utility_non_c1_match;
[select_prompt_c1] profile=user_instance & attention=low & under=high: utility_non_c1_mismatch;
[select_prompt_c1] profile=user_instance & attention=low & under=low: utility_non_c1_mismatch;
[select_prompt_c2] profile=user_instance & attention=high & under=high: utility_non_c2_mismatch;
[select_prompt_c2] profile=user_instance & attention=high & under=low: utility_non_c2_mismatch;
[select_prompt_c2] profile=user_instance & attention=low & under=high: utility_non_c2_okay;
[select_prompt_c2] profile=user_instance & attention=low & under=low: utility_non_c2_match;
[select_prompt_c3] profile=user_instance & attention=high & under=high: utility_non_c3_match;
[select_prompt_c3] profile=user_instance & attention=high & under=low: utility_non_c3_okay;
[select_prompt_c3] profile=user_instance & attention=low & under=high: utility_non_c3_match;
[select_prompt_c3] profile=user_instance & attention=low & under=low: utility_non_c3_okay;
endrewards