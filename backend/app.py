import os
from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)

# This line tells the browser that requests from other origins are allowed.
CORS(app)

@app.route('/api/message')
def get_message():
    return jsonify({"message": "Hello from the backend!"})

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)