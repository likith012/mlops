import warnings

warnings.filterwarnings("ignore")

import tensorflow as tf
from tensorflow.keras.preprocessing.sequence import pad_sequences
from tensorflow.keras.preprocessing.text import tokenizer_from_json

from flask import Flask, request, render_template
import os


app = Flask(__name__)

SAVE_PATH = os.path.join(os.getcwd(), "checkpoints")
MAX_LEN = 150


def inference(sentence):
    """Predict the ham score of a sentence.
    Parameters
    ----------
    sentence : str
        The sentence to be predicted.

    Returns
    -------
    float
        The predicted ham probability.

    """

    with open(os.path.join(SAVE_PATH, "tokenizer.json")) as json_file:
        tokenizer_config = json_file.read()
    tokenizer = tokenizer_from_json(tokenizer_config)

    with open(os.path.join(SAVE_PATH, "model_config.json")) as json_file:
        model_config = json_file.read()

    model = tf.keras.models.model_from_json(model_config)
    model.load_weights(os.path.join(SAVE_PATH, "best_weights.h5"))

    text = [str(sentence)]

    text_seq = tokenizer.texts_to_sequences(text)
    text_pad = pad_sequences(text_seq, maxlen=150, truncating="post")

    return model.predict(text_pad)[0][0]


@app.route("/")
def root():
    # return f'Tool for SMS spam detection'
    return f"Tool for SMS spam detection"


@app.route("/predict", methods=["GET", "POST"])
def predict():
    """To classify the spam of a sentence."""

    if request.method == "POST":
        sentence = request.args.get("sentence")
        positive_prediction = inference(sentence)
        negative_prediction = 1 - positive_prediction
        response = {}
        response["response"] = {
            "positive": str(positive_prediction),
            "negative": str(negative_prediction),
            "sentence": str(sentence),
        }
        return flask.jsonify(response)
    else:
        return "Make a POST request"
