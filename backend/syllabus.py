from dotenv import load_dotenv
import os
from google import genai
import base64

client = genai.Client()

with open('doc/AIE-2102-syllabus.pdf', 'rb') as f:
    pdf_bytes = f.read()

interaction = client.interactions.create(
    model="gemini-3.8-flash",
    input=[
        {
            "type": "document",
            "data": base64.b64encode(pdf_bytes).decode('utf-8'),
            "mime_type": "application/pdf"
        },
        {"type": "text", "text": """Analyze the provided syllabus and extract its academic structure.

Identify:
1. Course name and course details
2. Units/modules and their topics
3. Course Outcomes (COs)
4. Program Outcomes (POs), if provided
5. Map each topic to the most relevant CO(s)
6. Map each CO to the relevant PO(s)
7. Assign an appropriate Bloom's Taxonomy cognitive level to each topic/CO

Return the result as structured JSON.

Do not invent COs, POs, or syllabus content that is not present in the document. If something is missing, return null or an empty array."""}
    ]
)

print(interaction.output_text)
