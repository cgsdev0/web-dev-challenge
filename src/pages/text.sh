curl \
-X POST \
-SsL \
-H "Content-Type: application/json; charset=utf-8" \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
"https://${API_ENDPOINT}/v1/projects/${PROJECT_NAME}/locations/${LOCATION_ID}/publishers/google/models/${MODEL_ID}:streamGenerateContent" -d @- << JSON | jq -c '.[] | .candidates[] | .content.parts[] | .text' | sed 's/\\n/<br>/g;s/"\(.*\)"/\1/' | tr -d '\n'
{
    "contents": [
        {
            "role": "user",
            "parts": [
              {
                "text": "hello computer, i am sarah"
              }
            ]
        }
    ],
    "generationConfig": {
        "temperature": 1
        ,"maxOutputTokens": 8192
        ,"topP": 0.95
        ,"seed": 0
    },
    "safetySettings": [
        {
            "category": "HARM_CATEGORY_HATE_SPEECH",
            "threshold": "OFF"
        },
        {
            "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
            "threshold": "OFF"
        },
        {
            "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
            "threshold": "OFF"
        },
        {
            "category": "HARM_CATEGORY_HARASSMENT",
            "threshold": "OFF"
        }
    ]
}
JSON
