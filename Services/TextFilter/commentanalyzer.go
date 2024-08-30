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

func AnalyzeComment(comment string) (*commentanalyzer.AnalyzeCommentResponse, error) {
	analyzeReq := &commentanalyzer.AnalyzeCommentRequest{
		Comment: &commentanalyzer.TextEntry{
			Text: comment,
		},
		RequestedAttributes: map[string]commentanalyzer.AttributeParameters{
			"TOXICITY":          {ScoreThreshold: 0.35},
			"SEVERE_TOXICITY":   {ScoreThreshold: 0.35},
			"IDENTITY_ATTACK":   {ScoreThreshold: 0.35},
			"INSULT":            {ScoreThreshold: 0.35},
			"PROFANITY":         {ScoreThreshold: 0.35},
			"THREAT":            {ScoreThreshold: 0.35},
			"SEXUALLY_EXPLICIT": {ScoreThreshold: 0.35},
			"FLIRTATION":        {ScoreThreshold: 0.35},
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
