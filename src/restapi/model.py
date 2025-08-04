# Pydantic base models for the REST API
# Created by Gricel

from datetime import datetime
from typing import Literal
from pydantic import BaseModel, Field

class Problem2Create(BaseModel):
    """
    Model for creating a new problem.
    """
    description: str = Field(..., example="My Planning Problem", description="The description of the problem.")
    json_file: str = Field(..., example='../assets/planningProblem/example.json', description="The file path for the JSON structured problem.")

class Problem(Problem2Create):
    """
    Model for a planning problem in the database.
    """
    id: str = Field(..., example="a1b2c3d4e5f67890a1b2c3d4e5f67890", description="Unique identifier for the problem.")
    date_creation: datetime = Field(..., description="The date and time the problem was created.")
    status: str = Field("created", description="The current status of the problem processing. Possible values: 'created', 'processing', 'completed', 'failed'.")

class ProblemStatusUpdate(BaseModel):
    """
    Ensure the status is one of the allowed values.
    """
    status: Literal['created', 'processing', 'completed', 'failed']
