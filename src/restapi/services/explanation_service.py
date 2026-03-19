from arch.promptFilling.prompt_filling import PromptFilling

def get_explan_params_POMDP_policy(problem_id, user_role):
    ''' Generate explanation parameters using POMDP policy
    Returns explanation vars, e.g.: {'detail': 'high_detail', 'tone': 'casual', 'format': 'bullet'}'''

    prompt_filling = PromptFilling(user_role)
    return prompt_filling.prompt_filling_vals