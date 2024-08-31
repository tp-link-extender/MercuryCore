package main

import (
	"context"
	"fmt"
	"os"
	"strings"
	"time"

	commentanalyzer "google.golang.org/api/commentanalyzer/v1alpha1"
	"google.golang.org/api/googleapi"
	"google.golang.org/api/option"

	c "github.com/TwiN/go-color"
)

var commentanalyzerService *commentanalyzer.Service

func InitCommentAnalyzer() {
	fmt.Println(c.InYellow("Initializing Comment Analyzer..."))

	apiKey := os.Getenv("GOOGLE_API_KEY")
	if apiKey == "" {
		fmt.Println(c.InRed("GOOGLE_API_KEY environment variable must be set."))
		os.Exit(1)
	}

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	service, err := commentanalyzer.NewService(ctx, option.WithAPIKey(apiKey))
	Assert(err, "Failed to initialize Comment Analyzer")

	commentanalyzerService = service
	fmt.Println(c.InGreen("Comment Analyzer initialized successfully."))
}

// https://developers.perspectiveapi.com/s/about-the-api-score?language=en_US#:~:text=For%20social%20science%20researchers%20using,to%20typical%20moderation%20use%20cases.

func AnalyzeComment(comment string) (*commentanalyzer.AnalyzeCommentResponse, error) {
	analyzeReq := &commentanalyzer.AnalyzeCommentRequest{
		Comment: &commentanalyzer.TextEntry{
			Text: comment,
		}, // lower score thresholds = more sensitive
		RequestedAttributes: map[string]commentanalyzer.AttributeParameters{
			"TOXICITY":          {ScoreThreshold: 0.15},
			"SEVERE_TOXICITY":   {ScoreThreshold: 0.10},
			"IDENTITY_ATTACK":   {ScoreThreshold: 0.20},
			"INSULT":            {ScoreThreshold: 0.20},
			"PROFANITY":         {ScoreThreshold: 0.20},
			"THREAT":            {ScoreThreshold: 0.10},
			"SEXUALLY_EXPLICIT": {ScoreThreshold: 0.10},
			"FLIRTATION":        {ScoreThreshold: 0.10},
		},
	}

	// attempt at automatic language detection
	resp, err := commentanalyzerService.Comments.Analyze(analyzeReq).Do()
	if err == nil {
		return resp, nil
	}

	// most of the time the error will be the automatic language detection on perspectives side
	if apiError, ok := err.(*googleapi.Error); ok && apiError.Code == 400 {
		for _, detail := range apiError.Errors {
			if strings.Contains(detail.Message, "does not support request languages") {
				fmt.Println(c.InYellow("Automatic language detection failed. Fallback to English..."))

				analyzeReq.Languages = append(analyzeReq.Languages, "en")
				return commentanalyzerService.Comments.Analyze(analyzeReq).Do()
			}
		}
	}

	return nil, err
}

// TODO: perspectiveapi does not have an way to see what partions of words are profanity so this exists
// this is not good at all though because stuff like 'you are xxxx' may not be detected
func FilterText(text string, threshold float64) (string, bool, []string, []string) {
	words := strings.Fields(text)
	filtered := false

	detectedLanguages := []string{}
	usedLanguages := []string{}

	for i, word := range words {
		resp, err := AnalyzeComment(word)
		Assert(err, "Failed to analyze word")

		for _, lang := range resp.DetectedLanguages {
			if !contains(detectedLanguages, lang) {
				detectedLanguages = append(detectedLanguages, lang)
			}
		}
		for _, lang := range resp.Languages {
			if !contains(usedLanguages, lang) {
				usedLanguages = append(usedLanguages, lang)
			}
		}

		for _, attr := range resp.AttributeScores {
			if attr.SummaryScore.Value > threshold {
				words[i] = strings.Repeat("#", len(word)) // TODO: should the character # be configureable
				filtered = true
				break
			}
		}
	}

	return strings.Join(words, " "), filtered, detectedLanguages, usedLanguages
}

// TODO: make a library for stuff like this?
func contains(slice []string, item string) bool {
	for _, s := range slice {
		if s == item {
			return true
		}
	}
	return false
}
