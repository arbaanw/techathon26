from google import genai
from dotenv import load_dotenv
from pydantic import BaseModel
import os
import base64

load_dotenv()
key = os.getenv("GEMINI_API_KEY")

from pydantic import BaseModel, Field
from typing import List


class Course(BaseModel):
    course_name: str = Field(description="Name of the course")
    course_code: str = Field(description="Course Code")


class Course_Outcome(BaseModel):
    outcome_number: str = Field(description="Course outcome code, e.g. CO1")
    description: str = Field(description="Description of the course outcome")


class Program_Outcome(BaseModel):
    outcome_number: str = Field(description="Program outcome code, e.g. PO1")
    description: str = Field(description="Description of the program outcome")


class Topic(BaseModel):
    topic: str = Field(description="Name of the topic")
    co: List[str] = Field(description="Course outcome codes mapped to this topic, e.g. CO1, CO2")
    po: List[str] = Field(description="Program outcome codes mapped to this topic, e.g. PO1, PO2")
    blooms_levels: List[str] = Field(
        description="Bloom's Taxonomy levels applicable to this topic, e.g. Remember, Understand, Apply"
    )


class Unit(BaseModel):
    unit_number: int = Field(description="Unit number")
    unit_title: str = Field(description="Title of the unit")
    topics: List[Topic] = Field(description="Topics covered in this unit")


class Json(BaseModel):
    course_details: Course
    course_outcomes: List[Course_Outcome]
    program_outcomes: List[Program_Outcome]
    units: List[Unit]
    
prompt = """
Analyze the attached syllabus PDF and convert it into the required structured format.

Extract:
1. Course name and course code.
2. All Course Outcomes (COs) and their descriptions.
3. All Program Outcomes (POs) and their descriptions, if they are present in the syllabus.
4. Every unit, including its unit number and title.
5. Every topic listed under each unit.
6. For each topic, determine the applicable CO(s), PO(s), and Bloom's Taxonomy level(s).

Rules:
- Follow the provided response schema exactly.
- Do not add information that is not supported by the syllabus.
- Preserve the wording of course and program outcomes as closely as possible.
- CO and PO mappings should use the outcome codes defined in the syllabus.
- Determine Bloom's Taxonomy levels based on the topic's expected cognitive level.
- A topic may map to multiple COs, POs, and Bloom's levels.
- Return only the structured JSON. Do not include explanations or markdown.
"""
client = genai.Client(api_key = key)

with open('doc/AIE-2102-syllabus.pdf', 'rb') as f:
    pdf_bytes = f.read()

interaction = client.interactions.create(
    model="gemini-3.1-flash-lite",
    input=[
        {
            "type": "document",
            "data": base64.b64encode(pdf_bytes).decode('utf-8'),
            "mime_type": "application/pdf"
        },
        {"type": "text", "text": prompt}
    ],
    response_format={
        "type": "text",
        "mime_type": "application/json",
        "schema": Json.model_json_schema()
        },
    )
json = Json.model_validate_json(interaction.output_text)
print(json)
