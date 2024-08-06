from pydantic import BaseModel, ValidationError, Field, model_validator
from typing import Any, Dict, List, Optional, Literal, Union


class Exercise(BaseModel):
    exercise_id: int
    type: Literal[
        "comp-mcq",
        "comp-tf",
        "comp-listen",  # affects text
        "pronounce-rep",  # affects text
        "pronounce-deaf",  # affects text
        "speak-replace",  # affects text
        "speak-question",
        "interact",
    ]
    cefr: List[Literal["A1", "A2", "B1", "B2", "C1"]]
    skip_condition: Optional[Literal["if-not-voice", "if-not-audio"]] = None
    query: Optional[str] = None
    answer_options: Optional[List[str]] = None
    audio: Optional[Any] = None
    action: Optional[
        Literal["hide-text", "hide-audio", "emphasize-text", "hide-all"]
    ] = Field(default=None)
    affected_text: Optional[str] = Field(default=None)

    # TODO: Add hints for the speak and interact exercises
    # TODO: Continue adding checks for the values that should exist based on different things

    # Define a model validator to validate that the action associated with the exercise matches the exercise type
    @model_validator(mode="before")
    @classmethod
    def validate_action_based_on_type(cls, values: Dict[str, Any]) -> Dict[str, Any]:
        action = values.get("action")
        exercise_type = values.get("type")

        type_to_action = {
            "comp-listen": "hide-text",
            "pronounce-rep": "emphasize-text",
            "pronounce-deaf": "hide-audio",
            "speak-replace": "hide-all",
        }

        if exercise_type in type_to_action:
            expected_action = type_to_action[exercise_type]
            if action is not None and action != expected_action:
                raise ValueError(
                    f"Action for type '{exercise_type}' must be '{expected_action}', but '{action}' was provided."
                )
            values["action"] = expected_action

        return values


# Define a base model for common attributes
class ExerciseBlock(BaseModel):
    block_id: int
    block_type: Literal["exercise"] = "exercise"
    exercise_options: List[Exercise]


class StoryLine(BaseModel):
    line_id: int
    character: str  # The character who is speaking (eg. narrator, character name)
    text: str
    audio: Optional[Any] = None


class StoryBlock(BaseModel):
    block_id: int
    block_type: Literal["story"] = "story"
    lines: List[StoryLine]


class Chapter(BaseModel):
    chapter: int
    title: str
    summary: str  # A brief summary of the chapter
    blocks: List[Union[StoryBlock, ExerciseBlock]]


class Story(BaseModel):
    title: str
    description: str
    level: Literal["beginner", "intermediate", "advanced"]
    chapters: List[Chapter]
