from flask import Flask, request, redirect, jsonify
import string
import random

app = Flask(__name__)

url_db = {}

def generate_code(length=6):
    characters = string.ascii_letters + string.digits
    return ''.join(random.choice(characters) for _ in range(length))

@app.route('/shorten', methods=['POST'])
def shorten_url():
    original_url = request.json['url']
    short_code = generate_code()
    url_db[short_code] = original_url
    return jsonify({"short_url": f"http://localhost:5000/{short_code}"})

@app.route('/<short_code>')
def redirect_url(short_code):
    original_url = url_db.get(short_code)
    if original_url:
        return redirect(original_url)
    return "URL Not Found", 404

if __name__ == '__main__':
    app.run(debug=True)
