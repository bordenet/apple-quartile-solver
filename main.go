// Package main implements the Apple Quartile Solver CLI.
// It solves Apple News Quartile puzzles by finding valid English words
// from letter tile combinations using the WordNet dictionary.
package main

import (
	"bufio"
	"errors"
	"flag"
	"fmt"
	"io"
	"os"
	"regexp"
	"strings"
	"time"
)

// Sentinel errors for common failure cases.
var (
	ErrEmptyPuzzle = errors.New("puzzle file is empty")
)

// ANSI color codes for terminal output
const (
	Reset = "\033[0m"
	Gray  = "\033[90m"
	Green = "\033[32m"
	Red   = "\033[31m"
)

// TrieNode represents a node in the trie data structure for efficient word lookup.
type TrieNode struct {
	Children map[rune]*TrieNode
	IsEnd    bool
}

// NewTrieNode creates and initializes a new trie node.
func NewTrieNode() *TrieNode {
	return &TrieNode{
		Children: make(map[rune]*TrieNode),
		IsEnd:    false,
	}
}

// Insert adds a word to the trie.
func (t *TrieNode) Insert(word string) {
	node := t
	for _, char := range word {
		if _, exists := node.Children[char]; !exists {
			node.Children[char] = NewTrieNode()
		}
		node = node.Children[char]
	}
	node.IsEnd = true
}

// Search returns true if the word exists in the trie.
func (t *TrieNode) Search(word string) bool {
	node := t
	for _, char := range word {
		if _, exists := node.Children[char]; !exists {
			return false
		}
		node = node.Children[char]
	}
	return node.IsEnd
}

// generatePlural generates the plural form of a noun using basic English rules.
func generatePlural(word string) string {
	if strings.HasSuffix(word, "s") || strings.HasSuffix(word, "sh") ||
		strings.HasSuffix(word, "ch") || strings.HasSuffix(word, "x") ||
		strings.HasSuffix(word, "z") {
		return word + "es"
	}
	if strings.HasSuffix(word, "y") && len(word) > 1 &&
		!strings.Contains("aeiou", string(word[len(word)-2])) {
		return word[:len(word)-1] + "ies"
	}
	return word + "s"
}

// generateVerbForms generates past tense and present participle forms of a verb.
func generateVerbForms(word string) (past, participle string) {
	// Past tense
	if strings.HasSuffix(word, "e") {
		past = word + "d"
	} else {
		past = word + "ed"
	}

	// Present participle
	if strings.HasSuffix(word, "e") && len(word) > 1 {
		participle = word[:len(word)-1] + "ing"
	} else {
		participle = word + "ing"
	}

	return past, participle
}

// loadDictionary loads words from a WordNet Prolog file into the trie.
// It parses the WordNet synset format and generates common word forms
// (plurals for nouns, past tense and participles for verbs).
//
// Parameters:
//   - dictionaryPath: path to the WordNet Prolog dictionary file (wn_s.pl)
//   - trie: the trie data structure to populate with words
//   - debug: if true, prints verbose parsing information
//
// Returns the number of words loaded and any error encountered.
func loadDictionary(dictionaryPath string, trie *TrieNode, debug bool) (int, error) {
	dictionaryFile, err := os.Open(dictionaryPath)
	if err != nil {
		return 0, fmt.Errorf("opening dictionary file: %w", err)
	}
	defer dictionaryFile.Close()

	scanner := bufio.NewScanner(dictionaryFile)
	wordCount := 0

	// WordNet format: s(synset_id,w_num,'word',pos,sense_num,tag_count).
	re := regexp.MustCompile(`s\(\d+,\d+,'([^']+)',([nvasr]),\d+,\d+\)\.?`)

	for scanner.Scan() {
		line := scanner.Text()
		if debug {
			fmt.Printf(Gray+"Reading line: %s"+Reset+"\n", line)
		}

		matches := re.FindStringSubmatch(line)
		if len(matches) != 3 {
			if debug {
				fmt.Printf(Gray+"Failed to parse line: %s"+Reset+"\n", line)
			}
			continue
		}

		word := strings.TrimSpace(matches[1])
		partOfSpeech := matches[2]

		// Skip capitalized words (proper nouns)
		if len(word) > 0 && word[0] >= 'A' && word[0] <= 'Z' {
			continue
		}

		word = strings.ToLower(word)

		// Insert the base word
		trie.Insert(word)
		wordCount++

		// Generate and insert plural forms for nouns
		if partOfSpeech == "n" {
			plural := generatePlural(word)
			trie.Insert(plural)
			wordCount++
		}

		// Generate and insert verb forms
		if partOfSpeech == "v" {
			past, participle := generateVerbForms(word)
			trie.Insert(past)
			trie.Insert(participle)
			wordCount += 2
		}
	}

	if err := scanner.Err(); err != nil {
		return 0, fmt.Errorf("scanning dictionary file: %w", err)
	}

	return wordCount, nil
}

// generatePermutations generates all possible word combinations from puzzle tiles.
// It creates combinations of 1 to maxLines tiles, then generates all permutations
// of each combination.
func generatePermutations(lines []string, maxLines int) []string {
	var results []string

	for i := 1; i <= maxLines; i++ {
		combinations := combinations(lines, i)
		for _, combo := range combinations {
			perms := permutations(combo)
			for _, perm := range perms {
				results = append(results, strings.Join(perm, ""))
			}
		}
	}
	return results
}

// permutations generates all permutations of a slice of strings.
func permutations(arr []string) [][]string {
	var result [][]string

	if len(arr) == 0 {
		return result
	}

	if len(arr) == 1 {
		return [][]string{arr}
	}

	for i := 0; i < len(arr); i++ {
		current := arr[i]
		remaining := append(append([]string{}, arr[:i]...), arr[i+1:]...)
		subPerms := permutations(remaining)
		for _, subPerm := range subPerms {
			result = append(result, append([]string{current}, subPerm...))
		}
	}

	return result
}

// combinations generates all combinations of r elements from arr.
func combinations(arr []string, r int) [][]string {
	var result [][]string
	var f func([]string, int, []string)
	f = func(arr []string, n int, temp []string) {
		if len(temp) == r {
			result = append(result, append([]string{}, temp...))
			return
		}
		for i := n; i < len(arr); i++ {
			f(arr, i+1, append(temp, arr[i]))
		}
	}
	f(arr, 0, []string{})
	return result
}

// checkInTrie validates permutations against the dictionary and prints valid words.
func checkInTrie(trie *TrieNode, permutations []string, debug bool) {
	count := 0
	for _, perm := range permutations {
		if trie.Search(perm) {
			count++
			fmt.Printf(Gray+"%2d. "+Green+"%s"+Reset+"\n", count, perm)
		} else if debug {
			fmt.Printf(Red+"Not found in trie: %s"+Reset+"\n", perm)
		}
	}
}

// printHelp displays usage information.
func printHelp() {
	fmt.Println("Apple Quartile Solver")
	fmt.Println("Solves Apple News Quartile puzzles using WordNet dictionary.")
	fmt.Println()
	fmt.Println("Usage:")
	fmt.Printf("  %s [OPTIONS]\n", os.Args[0])
	fmt.Println()
	fmt.Println("Options:")
	fmt.Println("  --dictionary PATH    Path to WordNet dictionary file (wn_s.pl)")
	fmt.Println("  --puzzle PATH        Path to puzzle file with letter combinations")
	fmt.Println("  --debug              Enable debug mode for verbose output")
	fmt.Println("  --help               Show this help message")
	fmt.Println()
	fmt.Println("Examples:")
	fmt.Printf("  %s --dictionary ./prolog/wn_s.pl --puzzle ./samples/puzzle1.txt\n", os.Args[0])
	fmt.Printf("  %s --debug --dictionary ./prolog/wn_s.pl --puzzle ./samples/puzzle2.txt\n", os.Args[0])
	fmt.Println()
	fmt.Println("Setup:")
	fmt.Println("  curl -O https://wordnetcode.princeton.edu/3.0/WNprolog-3.0.tar.gz")
	fmt.Println("  tar -xzf WNprolog-3.0.tar.gz")
}

// run executes the main application logic with the given parameters.
// It returns an error if any step fails, allowing for testable error handling.
func run(dictionaryPath, puzzlePath string, debug bool, w io.Writer) error {
	// Validate input files exist
	if _, err := os.Stat(dictionaryPath); os.IsNotExist(err) {
		return fmt.Errorf("dictionary file not found: %s", dictionaryPath)
	}

	if _, err := os.Stat(puzzlePath); os.IsNotExist(err) {
		return fmt.Errorf("puzzle file not found: %s", puzzlePath)
	}

	startTime := time.Now()

	if !debug {
		fmt.Fprintln(w, "Loading dictionary from:", dictionaryPath)
	}

	trie := NewTrieNode()
	wordCount, err := loadDictionary(dictionaryPath, trie, debug)
	if err != nil {
		return fmt.Errorf("loading dictionary from %s: %w", dictionaryPath, err)
	}

	if debug {
		loadDuration := time.Since(startTime)
		fmt.Fprintf(w, "Loaded %d words into trie in %v\n", wordCount, loadDuration)
	}

	// Read puzzle file
	puzzleFile, err := os.Open(puzzlePath)
	if err != nil {
		return fmt.Errorf("opening puzzle file %s: %w", puzzlePath, err)
	}
	defer puzzleFile.Close()

	var tiles []string
	scanner := bufio.NewScanner(puzzleFile)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line != "" {
			tiles = append(tiles, line)
		}
	}

	if err := scanner.Err(); err != nil {
		return fmt.Errorf("reading puzzle file %s: %w", puzzlePath, err)
	}

	if len(tiles) == 0 {
		return fmt.Errorf("puzzle file %s is empty", puzzlePath)
	}

	// Generate all permutations and validate against dictionary
	perms := generatePermutations(tiles, 4)
	checkInTrie(trie, perms, debug)

	return nil
}

func main() {
	debug := flag.Bool("debug", false, "Enable debug mode")
	dictionaryPath := flag.String("dictionary", "", "Path to the dictionary file")
	puzzlePath := flag.String("puzzle", "", "Path to the puzzle text file")
	help := flag.Bool("help", false, "Show usage information")
	flag.Parse()

	if *help {
		printHelp()
		return
	}

	if *dictionaryPath == "" || *puzzlePath == "" {
		fmt.Fprintf(os.Stderr, "Error: Both --dictionary and --puzzle are required\n")
		fmt.Fprintf(os.Stderr, "Run with --help for usage information\n")
		os.Exit(1)
	}

	if err := run(*dictionaryPath, *puzzlePath, *debug, os.Stdout); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
}
