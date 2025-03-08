import ollama
from ollama import chat
from pydantic import BaseModel
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

class Answer(BaseModel):
   number: int
   answer: str
   correct: bool

class Question(BaseModel):
  number: int
  question: str
  answer: list[Answer]

class QuestionList(BaseModel):
  questions: list[Question]

# Calls the ollama functions
def generate_response(topic):
    response = chat(
        messages=[
            {
            'role': 'user',
            'content': f'''
                Generate me 10 questions and answers based on the following topic {topic}. Each question must have 4 answers, of which only one is correct.
            ''',
            }
        ],
        model='llama3.2:1b',
        format=QuestionList.model_json_schema(),
    )

    questions = QuestionList.model_validate_json(response.message.content)
    print(questions.json())
    return questions.json()

# Receives rest api calls with the AI prompt in the 'question' key of the payload
# Returns the response back to the calling application
@app.route('/submit_topic', methods=['POST'])
def ask_question():
    print("Request received...")
    data = request.get_json()
    topic = data.get('topic')
    print(f"Question: {topic}")
    response = generate_response(topic)
    return response

if __name__ == '__main__':
    app.run(port = 10000)

