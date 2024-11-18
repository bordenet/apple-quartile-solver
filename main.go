package main

import (
    "bufio"
    "flag"
    "fmt"
    "os"
    "regexp"
    "strings"
    "time"
)

// ANSI color codes
const (
    Reset = "\033[0m"
    Gray  = "\033[90m"
    Green = "\033[32m"
    Red   = "\033[31m"
)

type TrieNode struct {
    Children map[rune]*TrieNode
    IsEnd    bool
}

func NewTrieNode() *TrieNode {
    return &TrieNode{
        Children: make(map[rune]*TrieNode),
        IsEnd:    false,
    }
}

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

func loadDictionary(dictionaryPath string, trie *TrieNode, debug bool) (int, error) {
    dictionaryFile, err := os.Open(dictionaryPath)
    if err != nil {
        return 0, err
    }
    defer dictionaryFile.Close()

    scanner := bufio.NewScanner(dictionaryFile)
    wordCount := 0

    for scanner.Scan() {
        line := scanner.Text()
        if debug {
            fmt.Printf(Gray+"Reading line: %s"+Reset+"\n", line)
        }

        // Use regex to extract the relevant parts from the input format
        re := regexp.MustCompile(`s\(\d+,\d+,'([^']+)',([nv]),\d+,\d+\)\.`)
        matches := re.FindStringSubmatch(line)
        if len(matches) == 3 {
            word := strings.ToLower(strings.TrimSpace(matches[1]))
            partOfSpeech := matches[2]

            // Skip capitalized words
            if len(word) > 0 && word[0] >= 'A' && word[0] <= 'Z' {
                continue
            }

            // Insert the original word into the trie
            trie.Insert(word)
            wordCount++

            // Handle plural nouns
            if partOfSpeech == "n" {
                plural := word + "s"
                trie.Insert(plural)
                wordCount++
            }

            // Handle verb forms
            if partOfSpeech == "v" {
                // Add common verb forms
                past := word + "ed"
                presentParticiple := word + "ing"
                trie.Insert(past)
                trie.Insert(presentParticiple)
                wordCount += 2 // Count both forms
            }
        } else {
            if debug {
                fmt.Printf(Gray+"Failed to parse line: %s"+Reset+"\n", line)
            }
        }
    }

    if err := scanner.Err(); err != nil {
        return 0, err
    }

    return wordCount, nil
}

func generatePermutations(lines []string, maxLines int) []string {
    var results []string

    for i := 1; i <= maxLines; i++ {
        combinations := combinations(lines, i)
        for _, combo := range combinations {
            results = append(results, strings.Join(combo, ""))
        }
    }
    return results
}

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

func checkInTrie(trie *TrieNode, permutations []string, debug bool) {
    var i int = 0
    for _, perm := range permutations {
        if trie.Search(perm) {
            i++
            fmt.Printf(Gray+"%2d. " + Green + "%s"+Reset+"\n", i, perm)
            } else if debug {
            fmt.Printf(Red+"Not found in trie: %s"+Reset+"\n", perm)
        }
    }
}

func main() {
    debug := flag.Bool("debug", false, "Enable debug mode")
    dictionaryPath := flag.String("dictionary", "", "Path to the dictionary file")
    puzzlePath := flag.String("puzzle", "", "Path to the puzzle text file")
    flag.Parse()

    startTime := time.Now()

    if *dictionaryPath == "" || *puzzlePath == "" {
        fmt.Println("Usage: applequartile [--debug] --dictionary <path> --puzzle <path>")
        return
    }

    fmt.Println("Loading dictionary from:", *dictionaryPath)

    trie := NewTrieNode()
    wordCount, err := loadDictionary(*dictionaryPath, trie, *debug)
    if err != nil {
        fmt.Println("Error loading dictionary:", err)
        return
    }

    loadDuration := time.Since(startTime)
    if *debug {
        fmt.Printf("Parsed words into trie: %d\n", wordCount)
        fmt.Printf("Loaded words into the trie in %v\n", loadDuration)
    }

    // Read puzzle file
    puzzleFile, err := os.Open(*puzzlePath)
    if err != nil {
        fmt.Println("Error reading puzzle file:", err)
        return
    }
    defer puzzleFile.Close()

    var lines []string
    scanner := bufio.NewScanner(puzzleFile)
    for scanner.Scan() {
        line := strings.TrimSpace(scanner.Text())
        if line != "" {
            lines = append(lines, line)
        }
    }

    if err := scanner.Err(); err != nil {
        fmt.Println("Error reading puzzle file:", err)
        return
    }

    // Generate permutations and check in trie
    permutations := generatePermutations(lines, 4)
    checkInTrie(trie, permutations, *debug)
}
