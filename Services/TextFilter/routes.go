package main

import (
	"encoding/json"
	"fmt"
	"net/http"
)

type FilterResponse struct {
	IsFiltered        bool     `json:"isFiltered"`
	DetectedLanguages []string `json:"detectedLanguages"`
	Languages         []string `json:"languages"`
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
		IsFiltered:        filtered,
		DetectedLanguages: resp.DetectedLanguages,
		Languages:         resp.Languages,
	}

	json.NewEncoder(w).Encode(response)
}
