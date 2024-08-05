from flask import Flask, request, jsonify
import pickle
import pandas as pd
from flask_swagger_ui import get_swaggerui_blueprint

# Flask uygulaması
app = Flask(__name__)

# Modeli yükleme
with open('best_rf_pipeline.pkl', 'rb') as model_file:
    model = pickle.load(model_file)

"""
instances:[{"Pregnancies":10.0,"Glucose":101.0,"BloodPressure":76.0,"SkinThickness":48.0,"Insulin":180.0,"BMI":32.9,"DiabetesPedigreeFunction":0.171,"Age":63.0},
{"Pregnancies":10.0,"Glucose":101.0,"BloodPressure":76.0,"SkinThickness":48.0,"Insulin":180.0,"BMI":32.9,"DiabetesPedigreeFunction":0.171,"Age":63.0}]
"""

# Swagger config
SWAGGER_URL = '/docs'
API_URL = '/swagger.json'
swaggerui_blueprint = get_swaggerui_blueprint(
    SWAGGER_URL,
    API_URL,
    config={
        'app_name': "Diabetes Prediction API"
    }
)

app.register_blueprint(swaggerui_blueprint, url_prefix=SWAGGER_URL)


@app.route("/swagger.json")
def swagger_json():
    domain = request.host # Get the host of the current request
    return jsonify({
    "swagger": "2.0",
    "info": {
      "description": "This is the API documentation for the Diabetes Prediction model. Use proper scheme [https, http] to test api.",
      "version": "1.0.0",
      "title": "Diabetes Prediction API"
    },
    "host": domain,

    "basePath": "/",

    "tags": [
      {
        "name": "predict",
        "description": "Operations related to Diabetes prediction"
      }
    ],
    "schemes": [
      "https","http"
    ],
    "paths": {
      "/": {
        "get": {
          "tags": ["predict"],
          "summary": "A welcome message to test the API",
          "responses": {
            "200": {
              "description": "A welcome message",
              "schema": {
                "type": "object",
                "properties": {
                  "message": {
                    "type": "string",
                    "example": "Hello from api."
                  }
                }
              }
            }
          }
        }
      },
      "/predict": {
        "post": {
          "tags": ["predict"],
          "summary": "Predict Diabetes",
          "parameters": [
            {
              "in": "body",
              "name": "body",
              "description": "JSON object containing the input data",
              "schema": {
                "type": "array",
                "items": {
                  "type": "object",
                  "properties": {
                    "Pregnancies": {
                      "type": "number",
                      "example": 10.0
                    },
                    "Glucose": {
                      "type": "number",
                      "example": 101.0
                    },
                    "BloodPressure": {
                      "type": "number",
                      "example": 76.0
                    },
                    "SkinThickness": {
                      "type": "number",
                      "example": 48.0
                    },
                    "Insulin": {
                      "type": "number",
                      "example": 180.0
                    },
                    "BMI": {
                      "type": "number",
                      "example": 32.9
                    },
                    "DiabetesPedigreeFunction": {
                      "type": "number",
                      "example": 0.171
                    },
                    "Age": {
                      "type": "number",
                      "example": 63.0
                    }
                  }
                }
              }
            }
          ],
          "responses": {
            "200": {
              "description": "Predicted class",
              "schema": {
                "type": "array",
                "items": {
                  "type": "number",
                  "example": 1
                }
              }
            }
          }
        }
      }
    }
  }
  )

@app.route('/', methods=["GET", 'OPTIONS'])
def salute():
    domain = request.host_url.rstrip('/') 
    return {"message":f"Hello, welcome to the acd-diabetes api! You can visit {domain}/docs for API docs."}


@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json(force=True)
    df = pd.DataFrame(data)
    prediction = model.predict(df)
    prediction = prediction.tolist()
    return jsonify(prediction)

if __name__ == '__main__':
    app.run(debug=True,host="127.0.0.1",port=4000)
