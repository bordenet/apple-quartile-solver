package main

import (
	"io"
	"os"
	"strings"
	"testing"
)

func TestTrieNode_Insert(t *testing.T) {
	trie := NewTrieNode()
	
	// Test basic insertion
	trie.Insert("hello")
	if !trie.Search("hello") {
		t.Error("Expected 'hello' to be found in trie")
	}
	
	// Test empty string
	trie.Insert("")
	if !trie.Search("") {
		t.Error("Expected empty string to be found in trie")
	}
	
	// Test unicode characters
	trie.Insert("café")
	if !trie.Search("café") {
		t.Error("Expected 'café' to be found in trie")
	}
}

func TestTrieNode_Search(t *testing.T) {
	trie := NewTrieNode()
	trie.Insert("test")
	trie.Insert("testing")
	
	// Test exact matches
	if !trie.Search("test") {
		t.Error("Expected 'test' to be found")
	}
	if !trie.Search("testing") {
		t.Error("Expected 'testing' to be found")
	}
	
	// Test non-existent words
	if trie.Search("tes") {
		t.Error("Expected 'tes' to not be found")
	}
	if trie.Search("testings") {
		t.Error("Expected 'testings' to not be found")
	}
	if trie.Search("nothere") {
		t.Error("Expected 'nothere' to not be found")
	}
}

func TestLoadDictionary(t *testing.T) {
	// Create a temporary dictionary file
	content := `s(100000001,1,'dog',n,1,6).
s(100000002,1,'cat',n,1,3).
s(100000003,1,'run',v,1,3).
s(100000004,1,'PROPER',n,1,6).
s(100000005,1,'test word',n,1,9).`
	
	tmpfile, err := os.CreateTemp("", "test_dict*.pl")
	if err != nil {
		t.Fatal(err)
	}
	defer os.Remove(tmpfile.Name())
	
	if _, err := tmpfile.Write([]byte(content)); err != nil {
		t.Fatal(err)
	}
	if err := tmpfile.Close(); err != nil {
		t.Fatal(err)
	}
	
	// Test loading dictionary
	trie := NewTrieNode()
	wordCount, err := loadDictionary(tmpfile.Name(), trie, false)
	if err != nil {
		t.Fatalf("loadDictionary failed: %v", err)
	}
	
	// Should load: dog, dogs, cat, cats, run, runed, runing
	// Should skip: PROPER (capitalized), "test word" (contains space)
	expectedWords := []string{"dog", "dogs", "cat", "cats", "run", "runed", "runing"}
	for _, word := range expectedWords {
		if !trie.Search(word) {
			t.Errorf("Expected word '%s' to be in trie", word)
		}
	}
	
	// Should not contain capitalized words
	if trie.Search("proper") {
		t.Error("Expected 'proper' to not be in trie (was capitalized)")
	}
	
	// The actual count is higher due to verb forms - let's verify it's at least what we expect
	if wordCount < 7 {
		t.Errorf("Expected word count to be at least 7, got %d", wordCount)
	}
}

func TestLoadDictionary_FileNotFound(t *testing.T) {
	trie := NewTrieNode()
	_, err := loadDictionary("nonexistent.pl", trie, false)
	if err == nil {
		t.Error("Expected error when loading non-existent file")
	}
}

func TestLoadDictionary_MalformedLines(t *testing.T) {
	content := `this is not a valid line
s(invalid format
s(100000001,1,'valid',n,1,5).
another invalid line`
	
	tmpfile, err := os.CreateTemp("", "test_dict*.pl")
	if err != nil {
		t.Fatal(err)
	}
	defer os.Remove(tmpfile.Name())
	
	if _, err := tmpfile.Write([]byte(content)); err != nil {
		t.Fatal(err)
	}
	if err := tmpfile.Close(); err != nil {
		t.Fatal(err)
	}
	
	trie := NewTrieNode()
	wordCount, err := loadDictionary(tmpfile.Name(), trie, false)
	if err != nil {
		t.Fatalf("loadDictionary failed: %v", err)
	}
	
	// Should only load the valid line: "valid" and "valids"
	if wordCount != 2 {
		t.Errorf("Expected word count to be 2, got %d", wordCount)
	}
	
	if !trie.Search("valid") {
		t.Error("Expected 'valid' to be in trie")
	}
	if !trie.Search("valids") {
		t.Error("Expected 'valids' to be in trie")
	}
}

func TestGeneratePermutations(t *testing.T) {
	lines := []string{"a", "b", "c"}
	
	// Test with maxLines = 1
	perms := generatePermutations(lines, 1)
	expected := []string{"a", "b", "c"}
	if len(perms) != len(expected) {
		t.Errorf("Expected %d permutations, got %d", len(expected), len(perms))
	}
	for i, perm := range perms {
		if perm != expected[i] {
			t.Errorf("Expected permutation %d to be '%s', got '%s'", i, expected[i], perm)
		}
	}
	
	// Test with maxLines = 2
	perms = generatePermutations(lines, 2)
	expectedLen := 3 + 3 // 1-letter + 2-letter combinations
	if len(perms) != expectedLen {
		t.Errorf("Expected %d permutations, got %d", expectedLen, len(perms))
	}
	
	// Check that "ab", "ac", "bc" are in the results
	permSet := make(map[string]bool)
	for _, perm := range perms {
		permSet[perm] = true
	}
	expectedTwoLetter := []string{"ab", "ac", "bc"}
	for _, expected := range expectedTwoLetter {
		if !permSet[expected] {
			t.Errorf("Expected permutation '%s' to be in results", expected)
		}
	}
}

func TestGeneratePermutations_EmptyInput(t *testing.T) {
	lines := []string{}
	perms := generatePermutations(lines, 1)
	if len(perms) != 0 {
		t.Errorf("Expected 0 permutations for empty input, got %d", len(perms))
	}
}

func TestCombinations(t *testing.T) {
	arr := []string{"a", "b", "c"}
	
	// Test r = 1
	combos := combinations(arr, 1)
	if len(combos) != 3 {
		t.Errorf("Expected 3 combinations for r=1, got %d", len(combos))
	}
	
	// Test r = 2
	combos = combinations(arr, 2)
	if len(combos) != 3 {
		t.Errorf("Expected 3 combinations for r=2, got %d", len(combos))
	}
	
	// Test r = 3
	combos = combinations(arr, 3)
	if len(combos) != 1 {
		t.Errorf("Expected 1 combination for r=3, got %d", len(combos))
	}
	
	// Test r > len(arr)
	combos = combinations(arr, 4)
	if len(combos) != 0 {
		t.Errorf("Expected 0 combinations for r>len(arr), got %d", len(combos))
	}
}

func TestCheckInTrie(t *testing.T) {
	trie := NewTrieNode()
	trie.Insert("hello")
	trie.Insert("world")
	
	permutations := []string{"hello", "world", "notfound", "hello"}
	
	// Redirect stdout to capture output
	oldStdout := os.Stdout
	r, w, _ := os.Pipe()
	os.Stdout = w
	
	checkInTrie(trie, permutations, false)
	
	w.Close()
	os.Stdout = oldStdout
	
	buf, _ := io.ReadAll(r)
	output := string(buf)
	
	// Should contain "hello" and "world" but not "notfound"
	if !strings.Contains(output, "hello") {
		t.Error("Expected output to contain 'hello'")
	}
	if !strings.Contains(output, "world") {
		t.Error("Expected output to contain 'world'")
	}
	if strings.Contains(output, "notfound") {
		t.Error("Expected output to not contain 'notfound'")
	}
}

// Benchmark tests
func BenchmarkTrieInsert(b *testing.B) {
	trie := NewTrieNode()
	words := []string{"hello", "world", "test", "benchmark", "performance"}
	
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		for _, word := range words {
			trie.Insert(word)
		}
	}
}

func BenchmarkTrieSearch(b *testing.B) {
	trie := NewTrieNode()
	words := []string{"hello", "world", "test", "benchmark", "performance"}
	
	// Pre-populate the trie
	for _, word := range words {
		trie.Insert(word)
	}
	
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		for _, word := range words {
			trie.Search(word)
		}
	}
}

func TestImprovedPluralAndVerbForms(t *testing.T) {
	// Test improved plural and verb form generation
	content := `s(100000001,1,'box',n,1,3).
s(100000002,1,'fly',n,1,3).
s(100000003,1,'make',v,1,4).
s(100000004,1,'run',v,1,3).`
	
	tmpfile, err := os.CreateTemp("", "test_dict*.pl")
	if err != nil {
		t.Fatal(err)
	}
	defer os.Remove(tmpfile.Name())
	
	if _, err := tmpfile.Write([]byte(content)); err != nil {
		t.Fatal(err)
	}
	if err := tmpfile.Close(); err != nil {
		t.Fatal(err)
	}
	
	trie := NewTrieNode()
	_, err = loadDictionary(tmpfile.Name(), trie, false)
	if err != nil {
		t.Fatalf("loadDictionary failed: %v", err)
	}
	
	// Test improved plural rules
	if !trie.Search("boxes") { // box -> boxes (ends with x)
		t.Error("Expected 'boxes' to be in trie")
	}
	if !trie.Search("flies") { // fly -> flies (ends with y after consonant)
		t.Error("Expected 'flies' to be in trie")
	}
	
	// Test improved verb forms
	if !trie.Search("maked") { // make -> maked (remove e, add ed -> d)
		t.Error("Expected 'maked' to be in trie")
	}
	if !trie.Search("making") { // make -> making (remove e, add ing)
		t.Error("Expected 'making' to be in trie")
	}
	if !trie.Search("runed") { // run -> runed
		t.Error("Expected 'runed' to be in trie")
	}
	if !trie.Search("runing") { // run -> runing
		t.Error("Expected 'runing' to be in trie")
	}
}

func TestRegexParsing(t *testing.T) {
	// Test potential edge cases in regex parsing
	content := `s(100000001,1,'test',n,1,4).
s(100000002,2,'test',v,1,4).
s(100000003,1,'test-word',n,1,9).
s(100000004,1,'test_word',n,1,9).
invalid line without proper format
s(100000005,1,'valid',a,1,5).`
	
	tmpfile, err := os.CreateTemp("", "test_regex*.pl")
	if err != nil {
		t.Fatal(err)
	}
	defer os.Remove(tmpfile.Name())
	
	if _, err := tmpfile.Write([]byte(content)); err != nil {
		t.Fatal(err)
	}
	if err := tmpfile.Close(); err != nil {
		t.Fatal(err)
	}
	
	trie := NewTrieNode()
	wordCount, err := loadDictionary(tmpfile.Name(), trie, false)
	if err != nil {
		t.Fatalf("loadDictionary failed: %v", err)
	}
	
	// Should handle basic words
	if !trie.Search("test") {
		t.Error("Expected 'test' to be in trie")
	}
	
	// Should handle words with hyphens and underscores
	if !trie.Search("test-word") {
		t.Error("Expected 'test-word' to be in trie")
	}
	
	// Should handle adjectives (part of speech 'a')
	if !trie.Search("valid") {
		t.Error("Expected 'valid' to be in trie")
	}
	
	// Word count should be reasonable (accounting for duplicates and generated forms)
	if wordCount < 3 {
		t.Errorf("Expected at least 3 words, got %d", wordCount)
	}
}

func BenchmarkGeneratePermutations(b *testing.B) {
	lines := []string{"a", "b", "c", "d"}
	
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		generatePermutations(lines, 3)
	}
}