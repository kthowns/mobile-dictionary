from flask import Flask, request, jsonify
import whisper
import os

# Flask 앱 생성
app = Flask(__name__)

# Whisper 모델 로드
model = whisper.load_model("tiny.en")

# API 엔드포인트: 음성 파일을 업로드하고 텍스트로 변환하는 엔드포인트
@app.route('/transcribe', methods=['POST'])
def transcribe():
    if 'file' not in request.files:
        return jsonify({"error": "No file part"}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    # 음성 파일 저장
    audio_path = os.path.join('uploads', file.filename)
    os.makedirs('uploads', exist_ok=True)
    file.save(audio_path)

    # Whisper 모델을 사용해 음성을 텍스트로 변환
    try:
        # 음성 파일을 텍스트로 변환
        result = model.transcribe(audio_path)
        text = result['text']
        return jsonify({"transcription": text}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# 서버 실행
if __name__ == '__main__':
    app.run(debug=True)
