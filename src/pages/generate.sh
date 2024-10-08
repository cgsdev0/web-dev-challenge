# headers

if [[ "$REQUEST_METHOD" != "POST" ]]; then
  # only allow POST to this endpoint
  end_headers
  return $(status_code 405)
fi

RESULT="$(curl \
  -SsL \
  -X POST \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-8b:generateContent?key=${GEMINI_KEY}" \
  -H 'Content-Type: application/json' \
  -d @- <<JSON | jq -r '.candidates[] | .content.parts[] | .text'
{
  "contents": [
    {
      "role": "user",
      "parts": [
        {
          "text": "generate text for a thank you card with the following information:\n\nthe card is from ${FORM_DATA[sender_name]}\nthe card is to ${FORM_DATA[recipient_name]}\nthe reason for the thank you is \"${FORM_DATA[reason]}\"\n\nthe front_text should be a short greeting related to the reason for the thank you.\n\nthe image_description should be a prompt for the stable diffusion model to create a fun visual for the front of the card.\n\nthe inside text should be a paragraph expressing gratitude to the recipient.\n"
        }
      ]
    }
  ],
  "generationConfig": {
    "temperature": 2,
    "topK": 40,
    "topP": 0.95,
    "maxOutputTokens": 8192,
    "responseMimeType": "application/json",
    "responseSchema": {
      "type": "object",
      "properties": {
        "image_description": {
          "type": "string"
        },
        "front_text": {
          "type": "string"
        },
        "inside_text": {
          "type": "string"
        }
      },
      "required": [
        "image_description",
        "front_text",
        "inside_text"
      ]
    }
  }
}
JSON
)"

FRONT_TEXT="$(echo "$RESULT" | jq -r ".front_text")"
INSIDE_TEXT="$(echo "$RESULT" | jq -r ".inside_text")"
IMAGE_DESCRIPTION="$(echo "$RESULT" | jq -r ".image_description")"

CARD_ID="$(uuidgen)"
mkdir -p data/cards/${CARD_ID}
CARD_DIR=data/cards/${CARD_ID}
CARD_IMG="${CARD_DIR}/img.png"
mkdir -p "$CARD_DIR"

echo "$FRONT_TEXT" > "${CARD_DIR}/front"
echo "$INSIDE_TEXT" > "${CARD_DIR}/inside"
echo "${FORM_DATA[sender_name]}" > "${CARD_DIR}/from"

curl \
-X POST \
-SsL \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
"https://us-west1-aiplatform.googleapis.com/v1/projects/${PROJECT_ID}/locations/us-west1/endpoints/${SD_ENDPOINT_ID}:predict" \
-d @- << JSON | jq -r '.predictions[0]' | base64 -d > "${CARD_IMG}"
{
  "instances": [
    "${IMAGE_DESCRIPTION//$'"'/}"
  ]
}
JSON

convert "${CARD_DIR}/img.png" +dither -colors 5 -define histogram:unique-colors=true -format "%c" histogram:info: | head -n1 | grep -o "#[^ ]*" > "${CARD_DIR}/bg_color"

header Hx-Redirect "/card/${CARD_ID}/view"
end_headers
