package main

import (
    "bufio"
    "flag"
    "fmt"
    "os"
    "strings"
    "time"
)

// ANSI color codes
const (
    Reset  = "\033[0m"
    Gray   = "\033[90m"
    Green  = "\033[32m"
    Red    = "\033[31m"
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

func (t *TrieNode) CountNodes() int {
    count := 1 // Count the current node
    for _, child := range t.Children {
        count += child.CountNodes()
    }
    return count
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

        // Extract the word from the Prolog format
        parts := strings.SplitN(line, "'", 3)
        if len(parts) >= 3 {
            word := parts[1]
            word = strings.ToLower(strings.TrimSpace(word))

            // Skip short words (e.g., less than 3 characters)
            if len(word) < 3 {
                if debug {
                    fmt.Printf(Gray+"Skipping short word: %s"+Reset+"\n", word)
                }
                continue
            }

            trie.Insert(word)
            if debug {
                fmt.Printf(Gray+"Inserted word into trie: %s"+Reset+"\n", word)
            }
            wordCount++
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

func readTextFile(path string) ([]string, error) {
    file, err := os.Open(path)
    if err != nil {
        return nil, err
    }
    defer file.Close()

    var lines []string
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        line := strings.TrimSpace(scanner.Text())
        if line != "" {
            lines = append(lines, line)
        }
    }

    if err := scanner.Err(); err != nil {
        return nil, err
    }

    return lines, nil
}

func generateConcatenatedPermutations(lines []string, maxLines int) []string {
    var results []string
//    n := len(lines)

    for i := 1; i <= maxLines; i++ {
        combinations := combinations(lines, i)
        for _, combo := range combinations {
            results = append(results, strings.Join(combo, ""))
        }
    }
    return results
}

func combinations(lines []string, r int) [][]string {
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
    f(lines, 0, []string{})
    return result
}

func checkInTrie(trie *TrieNode, permutations []string, debug bool) {
    for _, perm := range permutations {
        if trie.Search(perm) {
            fmt.Printf(Green+"Found in trie: %s"+Reset+"\n", perm)
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
        fmt.Println("Usage: applequartile [--debug] --dictionary <dictionary_path> --puzzle <text_file_path>")
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
        fmt.Printf("Number of nodes in trie: %d\n", trie.CountNodes())
        fmt.Printf("Loaded words into the trie in %v\n", loadDuration)
    }

    lines, err := readTextFile(*puzzlePath)
    if err != nil {
        fmt.Println("Error reading puzzle file:", err)
        return
    }

    permutations := generateConcatenatedPermutations(lines, 4)
    checkInTrie(trie, permutations, *debug)

    // Accept user input for up to 12 characters
    reader := bufio.NewReader(os.Stdin)
    fmt.Print("Enter up to 12 characters: ")
    input, _ := reader.ReadString('\n')
    input = strings.TrimSpace(strings.ToLower(input))

    if len(input) > 12 {
        fmt.Println("Input exceeds 12 characters.")
        return
    }

    searchStartTime := time.Now()
    if trie.Search(input) {
        fmt.Printf(Green+"%s is in the dictionary"+Reset+"\n", input)
    } else {
        fmt.Printf(Red+"%s is not in the dictionary"+Reset+"\n", input)
    }
    searchDuration := time.Since(searchStartTime)
    fmt.Printf("Search completed in %v\n", searchDuration)
}
