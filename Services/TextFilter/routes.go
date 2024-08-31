package main

import (
	"encoding/json"
	"fmt"
	"net/http"
)

type LanguageInfo struct {
	DetectedLanguages []string `json:"detectedLanguages"`
	LanguagesUsed     []string `json:"languagesUsed"`
}

type FilterResponse struct {
	FilteredText string       `json:"filteredText"`
	IsFiltered   bool         `json:"isFiltered"`
	Languages    LanguageInfo `json:"languages"`
}

func GetTextFilteredRoute(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	text := r.URL.Query().Get("text")
	if text == "" {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"message": "Invalid Request"})
		return
	}

	resp, err := AnalyzeComment(text)
	if err != nil {
		http.Error(w, fmt.Sprintf("Failed to analyze comment: %v", err), http.StatusInternalServerError)
		return
	}

	threshold := 0.7 // TODO: fine-tune this before integration or find a better way!
	filtered := false

	for _, attr := range resp.AttributeScores {
		if attr.SummaryScore.Value > threshold {
			filtered = true
			break
		}
	}

	response := FilterResponse{
		IsFiltered: filtered,
		Languages: LanguageInfo{
			DetectedLanguages: resp.DetectedLanguages,
			LanguagesUsed:     resp.Languages,
		},
	}

	json.NewEncoder(w).Encode(response)
}

// "unstable" beause of the todo on FilterText
func GetTextFilteredUnstableRoute(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	text := r.URL.Query().Get("text")
	if text == "" {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"message": "Invalid Request"})
		return
	}

	threshold := 0.7 // TODO: fine-tune this before integration or find a better way!
	filteredText, isFiltered, detectedLanguages, usedLanguages := FilterText(text, threshold)

	response := FilterResponse{
		FilteredText: filteredText,
		IsFiltered:   isFiltered,
		Languages: LanguageInfo{
			DetectedLanguages: detectedLanguages,
			LanguagesUsed:     usedLanguages,
		},
	}

	json.NewEncoder(w).Encode(response)
}
