from flask import Flask, request, jsonify
import subprocess
import os

app = Flask(__name__)

@app.route("/marina")
def run_marina():
    laza = request.args.get("laza")
    if not laza:
        return jsonify({"error": "Paramètre 'laza' manquant"}), 400

    try:
        result = subprocess.run(
            ["./marina", laza],
            capture_output=True,
            text=True,
            check=True
        )
        return jsonify({"output": result.stdout.strip()})
    except subprocess.CalledProcessError as e:
        return jsonify({"error": e.stderr.strip()}), 500

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)