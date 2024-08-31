package main

import (
	"encoding/json"
	"net/http"

	commentanalyzer "google.golang.org/api/commentanalyzer/v1alpha1"
)

type LanguageInfo struct {
	DetectedLanguages []string `json:"detectedLanguages"`
	LanguagesUsed     []string `json:"languagesUsed"`
}

type FilterResponse struct {
	FilteredText string                                  `json:"filteredText"`
	IsFiltered   bool                                    `json:"isFiltered"`
	Languages    LanguageInfo                            `json:"languages"`
	AnalyzerResp *commentanalyzer.AnalyzeCommentResponse `json:"analyzerResponse"` // helps debug thresholds
}

func GetTextFilteredUnstableRoute(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	text := r.URL.Query().Get("text")
	if text == "" {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"message": "Invalid Request"})
		return
	}

	threshold := 0.6 // TODO: fine-tune this and score thresholds before integration
	filteredText, isFiltered, detectedLanguages, usedLanguages, analyzerResp := FilterText(text, threshold)

	response := FilterResponse{
		FilteredText: filteredText,
		IsFiltered:   isFiltered,
		Languages: LanguageInfo{
			DetectedLanguages: detectedLanguages,
			LanguagesUsed:     usedLanguages,
		},
		AnalyzerResp: analyzerResp,
	}

	json.NewEncoder(w).Encode(response)
}
