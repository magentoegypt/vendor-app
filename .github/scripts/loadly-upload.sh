#!/usr/bin/env bash
# Uploads an .apk or .ipa to Loadly and adds the download link to the job
# summary. Usage: loadly-upload.sh <file> <label>
# Reads LOADLY_API_KEY and, optionally, NOTES (shown to testers) from the env.
set -eu

file=$1
label=$2

# --form-string keeps notes starting with @ or < from being read as files.
if ! response=$(curl -sS --fail-with-body --max-time 900 \
    --form-string "_api_key=$LOADLY_API_KEY" \
    --form-string "buildUpdateDescription=${NOTES:-}" \
    -F "file=@$file" \
    https://api.loadly.io/apiv2/app/upload); then
  echo "::error::Loadly upload request failed: $response"
  exit 1
fi

build_key=$(jq -r '.data.buildKey // empty' <<<"$response" 2>/dev/null || true)
if [ -z "$build_key" ]; then
  echo "::error::Loadly rejected the upload: $response"
  exit 1
fi

{
  echo "### $label build on Loadly"
  echo "- Download page: https://loadly.io/$build_key"
  echo "- Version: $(jq -r '.data.buildVersion' <<<"$response") ($(jq -r '.data.buildVersionNo' <<<"$response"))"
  qr=$(jq -r '.data.buildQRCodeURL // empty' <<<"$response")
  if [ -n "$qr" ]; then echo "- QR code: $qr"; fi
} >> "$GITHUB_STEP_SUMMARY"
echo "Uploaded $label: https://loadly.io/$build_key"
