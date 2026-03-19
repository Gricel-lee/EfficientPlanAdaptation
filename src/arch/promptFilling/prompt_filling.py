"""
This file generated the PRISM POMDP model to obtain the prompt filling options to generate an explanation.
"""
from arch.config.config import PROBLEM_OUTPUT_JSON, ACCEPTANCE_RATES_FILE, COGNITIVE_STATE_FILE

import os
import json
from arch.config.config import ACCEPTANCE_RATES_FILE, COGNITIVE_STATE_FILE


class PromptFilling:
    def __init__(self,user):
        self.user_role = user
        # Files with values to fill in the POMDP model
        self.acceptance_rates = open_file(ACCEPTANCE_RATES_FILE)
        self.cognitive_state_pred = open_file(COGNITIVE_STATE_FILE)
        # POMDP blueprint and props files
        files_dir = os.path.join(os.path.dirname(__file__), "data")
        self.props = open_file(os.path.join(files_dir, "prop.props"))
        self.pomdp_blueprint = open_file(os.path.join(files_dir, "pomdp_blueprint.pm"))
        # ---- Workflow ----
        # 1) Read user data (cognitive and acceptance rates)
        self.user_cognitive_data = self.read_user_cognitive_pred()
        self.user_acceptance_data = self.read_acceptance_rates()
        # 2) Create POMDP instance
        self.pomdp = self.create_POMDP_instance()
        # save in 
        temp = "/home/gnvf500/Gricel-Documents/GithubGris/EfficientPlanAdaptation/src/arch/promptFilling/data/temp"
        save_file(temp, self.pomdp)

        ## --- I AM HERE!!!
        
        # 3) Generate POMDP policy (run PRISM)
        self.generate_POMDP_policy()
        self.prompt_filling_vals = self.map_policy_to_explanation_params()
        # TODO: Map policy to selected level_of_detail, tone, format
        # TODO: Return to front end
        # TODO: Pass workflow to explanation_service
        

    def read_user_cognitive_pred(self):
        data = json.loads(self.cognitive_state_pred)
        entry = self._check_user_in_data(data["users"], "cognitive_state")
        if entry is not None:
            return {
                "attention": entry["attention"],
                "understanding": entry["understanding"]
            }
        return None

    def read_acceptance_rates(self):
        data = json.loads(self.acceptance_rates)
        entry = self._check_user_in_data(data["users"], "acceptance_rates")
        if entry is not None:
            return {
                "level_of_detail": entry["level_of_detail"],
                "tone": entry["tone"],
                "format": entry["format"]
            }
        return None

    def _check_user_in_data(self, users_list, source_name):
        """Returns the user entry matching self.user_role, or prints an error and returns None."""
        for entry in users_list:
            if entry.get("role") == self.user_role:
                return entry
        print(f"Error: User role '{self.user_role}' not found in {source_name}.")
        return None

    def create_POMDP_instance(self):
        if self.user_cognitive_data is None or self.user_acceptance_data is None:
            print("Error: Cannot create POMDP instance — missing user data.")
            return None

        # -- Flatten acceptance rate lists into {option: {acceptance, rejection}} dicts --
        def flatten_options(options_list):
            merged = {}
            for item in options_list:
                merged.update(item)
            return merged

        lod     = flatten_options(self.user_acceptance_data["level_of_detail"])
        tone    = flatten_options(self.user_acceptance_data["tone"])
        fmt     = flatten_options(self.user_acceptance_data["format"])
        att     = self.user_cognitive_data["attention"]
        und     = self.user_cognitive_data["understanding"]

        replacements = {
            # Cognitive state
            "{attention_high_high}":    str(att["high_high"]),
            "{attention_high_low}":     str(att["high_low"]),
            "{attention_low_high}":     str(att["low_high"]),
            "{attention_low_low}":      str(att["low_low"]),
            "{understanding_high_high}": str(und["high_high"]),
            "{understanding_high_low}":  str(und["high_low"]),
            "{understanding_low_high}":  str(und["low_high"]),
            "{understanding_low_low}":   str(und["low_low"]),
            # Acceptance/rejection rates
            "{high_detail_acceptance}": str(lod["high_detail"]["acceptance"]),
            "{high_detail_rejection}":  str(lod["high_detail"]["rejection"]),
            "{summary_acceptance}":     str(lod["summary"]["acceptance"]),
            "{summary_rejection}":      str(lod["summary"]["rejection"]),
            "{precise_acceptance}":     str(tone["precise"]["acceptance"]),
            "{precise_rejection}":      str(tone["precise"]["rejection"]),
            "{casual_acceptance}":      str(tone["casual"]["acceptance"]),
            "{casual_rejection}":       str(tone["casual"]["rejection"]),
            "{list_acceptance}":        str(fmt["list"]["acceptance"]),
            "{list_rejection}":         str(fmt["list"]["rejection"]),
            "{paragraph_acceptance}":   str(fmt["paragraph"]["acceptance"]),
            "{paragraph_rejection}":    str(fmt["paragraph"]["rejection"]),
            "{bullet_acceptance}":      str(fmt["bullet"]["acceptance"]),
            "{bullet_rejection}":       str(fmt["bullet"]["rejection"]),
        }

        instance = self.pomdp_blueprint
        for placeholder, value in replacements.items():
            instance = instance.replace(placeholder, value)
        return instance
    
    def generate_POMDP_policy(self):
        # TODO
        pass
    
    def map_policy_to_explanation_params(self):
        # TODO
        return {
            "tone": ("tone", "ERROR_TONE_NOT_FOUND"),
            "format": ("format", "ERROR_FORMAT_NOT_FOUND"),
            "detail": ("detail", "ERROR_DETAIL_NOT_FOUND")
        }







# ----- Auxiliary function -------
def replace_string(new_string, old_string, content):
    content = content.replace(old_string, new_string)
    return content


def save_file(filedir, content):
    with open(filedir, "w", encoding="utf-8") as file:
        file.write(content)

def open_file(filedir):
    if not os.path.exists(filedir):
        print(f"Error: Required file missing:\n - {filedir}")
        return None
    with open(filedir, "r", encoding="utf-8") as file:
        return file.read()
    
    
