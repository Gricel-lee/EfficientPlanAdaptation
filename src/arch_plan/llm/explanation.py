class Explanation:
    def __init__(self):
        self.role = ""
        # Attributes for explanation customisation
        self.explanation_format = ""
        self.explanation_levelDetail = ""
        self.explanation_tone = ""
        # The actual explanation text
        self.explanation = ""
        
    
    # == Set functions ==
    def set_format(self, explanation_format: str):
        self.explanation_format = explanation_format
    
    def set_levelDetail(self, explanation_levelDetail: str):
        self.explanation_levelDetail = explanation_levelDetail

    def set_tone(self, explanation_tone: str):
        self.explanation_tone = explanation_tone
    
    def set_explanation(self, explanation: str):
        self.explanation = explanation
        
    # == Get functions ==
    def get_format(self) -> str:
        return self.explanation_format
    
    def get_levelDetail(self) -> str:
        return self.explanation_levelDetail

    def get_tone(self) -> str:
        return self.explanation_tone
    
    def get_explanation(self) -> str:
        return self.explanation