# TextFilter Service

This service is used for profanity detection and requires an [Perspective API](https://perspectiveapi.com/) key which is **FREE**.

## Methods

### GET `/v1/get-text-filtered`

This endpoint uses the Comment Analyzer Service to detect profanity.

#### Request Parameters

- **`text`**: The text to be analyzed. **[REQUIRED]**

#### Response

JSON object with these fields:

- **`isFiltered`**: A value indicating whether the text was detected as profanity.
- **`detectedLanguages`**: A list of languages detected in the text.
- **`languages`**: A list of languages used during the analysis.

##### Example Response

```json
{
  "isFiltered": true,
  "detectedLanguages": ["en"],
  "languages": ["en"]
}