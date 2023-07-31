from flask import Flask, jsonify, request
import numpy as np
import joblib
# https://www.tutorialspoint.com/flask
import flask
app = Flask(__name__)

@app.route('/search')
def index():
    return flask.render_template('index.html')


@app.route('/search/predict', methods=['POST'])
def predict():
    lr = joblib.load('model.pkl')
    to_predict_list = request.form.to_dict()
    to_predict_list = list(to_predict_list.values())
    to_predict_list = np.array(list(map(float, to_predict_list))).reshape(1, -1)
    print(to_predict_list)
    prediction = lr.predict(to_predict_list)
    return jsonify({'prediction': list(prediction)})


if __name__ == '__main__':
    
    app.run(host="0.0.0.0" , port = 5000)
#     from waitress import serve
#     serve(app, host="0.0.0.0", port=5000)
