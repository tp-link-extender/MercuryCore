package main

import (
	"context"
	"fmt"
	"os"
	"sort"
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

func collectSpans(scores map[string]commentanalyzer.AttributeScores, threshold float64, text string) []struct{ start, end int } {
	var spans []struct{ start, end int }
	for _, attr := range scores {
		if attr.SummaryScore.Value <= threshold {
			continue
		}
		for _, span := range attr.SpanScores {
			if span.Score.Value > threshold {
				start, end := int(span.Begin), int(span.End)
				if start < len(text) {
					if end > len(text) {
						end = len(text)
					}
					spans = append(spans, struct{ start, end int }{start, end})
				}
			}
		}
	}
	return mergeIntervals(spans)
}

func mergeIntervals(intervals []struct{ start, end int }) []struct{ start, end int } {
	if len(intervals) == 0 {
		return nil
	}

	sort.Slice(intervals, func(i, j int) bool { return intervals[i].start < intervals[j].start })

	merged := []struct{ start, end int }{intervals[0]}

	for _, interval := range intervals[1:] {
		last := &merged[len(merged)-1]
		if interval.start <= last.end {
			if interval.end > last.end {
				last.end = interval.end
			}
		} else {
			merged = append(merged, interval)
		}
	}

	return merged
}

func FilterText(text string, threshold float64) (string, bool, []string, []string, *commentanalyzer.AnalyzeCommentResponse) {
	detectedLanguages, usedLanguages := []string{}, []string{}
	resp, err := AnalyzeComment(text)
	Assert(err, "Failed to analyze comment")

	detectedLanguages = appendUnique(detectedLanguages, resp.DetectedLanguages...)
	usedLanguages = appendUnique(usedLanguages, resp.Languages...)

	spans := collectSpans(resp.AttributeScores, threshold, text)
	filteredText := maskText(text, spans)
	return filteredText, filteredText != text, detectedLanguages, usedLanguages, resp
}

func maskText(text string, spans []struct{ start, end int }) string {
	var sb strings.Builder
	lastEnd := 0

	for _, span := range spans {
		if span.start > lastEnd {
			sb.WriteString(text[lastEnd:span.start])
		}
		sb.WriteString(strings.Repeat("#", span.end-span.start)) // TODO: should the character # be configureable
		lastEnd = span.end
	}

	if lastEnd < len(text) {
		sb.WriteString(text[lastEnd:])
	}

	return sb.String()
}

// TODO: make a library for stuff like this?
func appendUnique(slice []string, items ...string) []string {
	for _, item := range items {
		if !contains(slice, item) {
			slice = append(slice, item)
		}
	}
	return slice
}
func contains(slice []string, item string) bool {
	for _, s := range slice {
		if s == item {
			return true
		}
	}
	return false
}
