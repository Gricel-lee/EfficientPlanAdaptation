from typing import Dict
from restapi.models import Problem

# --------------------------
# -- Simple in-memory database
PROBLEM_DATABASE: Dict[str, Problem] = {}

# # -- User explanation paramaters defined after the POMDP policy is computed.
# # key is the user role (AI expert, Domain expert, Non-expert)
# # values are "tone", "format", "detail"
# USER_SELECTED_EXPLANATION: str = ""


USER_MAPPING = {
    "AI expert": "AI expert",
    "Domain expert": "Domain expert",
    "Non-expert": "Non-expert"
}

DETAIL_MAPPING = {
    "high": "high-level",
    "summary": "summary"
}

TONE_MAPPING = {
    "formal": "formal",
    "casual": "casual"
}

FORMAT_MAPPING = {
    "list": "list",
    "paragraph": "paragraph",
    "bullets": "bullets"
}

