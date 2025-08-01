from flask import Flask, request, jsonify
import subprocess

app = Flask(__name__)

@app.route("/marina")
def run_marina():
    laza = request.args.get("laza")
    if not laza:
        return jsonify({"error": "Paramètre 'laza' manquant"}), 400

    try:
        result = subprocess.run(
            ["./marina/marina", laza],
            capture_output=True,
            text=True,
            check=True
        )
        return jsonify({"output": result.stdout.strip()})
    except subprocess.CalledProcessError as e:
        return jsonify({"error": e.stderr.strip()}), 500

if __name__ == "__main__":
    app.run()