# png

curl \
-X POST \
-SsL \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
"https://us-west1-aiplatform.googleapis.com/v1/projects/${PROJECT_ID}/locations/us-west1/endpoints/${SD_ENDPOINT_ID}:predict" \
-d @- << JSON | jq -r '.predictions[0]' | base64 -d
{
  "instances": [
    "generate a beautiful mountain vista"
  ]
}
JSON
