from arch.promptFilling.prompt_filling import PromptFilling

def get_explan_params_POMDP_policy(problem_id, user_role):
    # TODO
    # prompt_filling_problem = PromptFilling(user_role)
    # return prompt_filling_problem.prompt_filling_vals

    explanation_vars = {
            "tone": "precise",
            "format": "bullet",
            "detail": "high"
        }

    return explanation_vars