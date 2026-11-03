package main

import "time"

type report struct {
	Version      int            `json:"version"`
	StartedAt    time.Time      `json:"startedAt"`
	FinishedAt   time.Time      `json:"finishedAt"`
	DryRun       bool           `json:"dryRun"`
	LedgerPath   string         `json:"ledgerPath"`
	OutputLedger string         `json:"outputLedger,omitempty"`
	RemoveTypes  []int          `json:"removeTypes"`
	Removed      []removedAsset `json:"removed,omitempty"`
	OrphanImages []uint32       `json:"orphanImages,omitempty"`
	Counts       map[string]int `json:"counts"`
	Ledger       ledgerReport   `json:"ledger"`
	Site         siteReport     `json:"site"`
	Files        fileReport     `json:"files"`
	Warnings     []string       `json:"warnings,omitempty"`
	Errors       []string       `json:"errors,omitempty"`
	Verification []string       `json:"verification,omitempty"`
}

type removedAsset struct {
	ID     uint32 `json:"id"`
	Type   int    `json:"type,omitempty"`
	Name   string `json:"name,omitempty"`
	Reason string `json:"reason"`
}

type ledgerReport struct {
	BalancesBefore        uint64         `json:"balancesBefore"`
	BalancesAfter         uint64         `json:"balancesAfter"`
	SourceCurrencyMoved   uint64         `json:"sourceCurrencyMoved"`
	PackageCurrencyBurned uint64         `json:"packageCurrencyBurned"`
	Transfers             int            `json:"transfers"`
	Counts                map[string]int `json:"counts,omitempty"`
}

type siteReport struct {
	Before    map[string]int `json:"before,omitempty"`
	After     map[string]int `json:"after,omitempty"`
	Committed bool           `json:"committed"`
	Skipped   bool           `json:"skipped"`
}

type fileReport struct {
	Planned []string `json:"planned,omitempty"`
	Deleted []string `json:"deleted,omitempty"`
	Missing []string `json:"missing,omitempty"`
	Skipped bool     `json:"skipped"`
	Errors  []string `json:"errors,omitempty"`
}
