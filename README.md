# Apple Quartile Solver 🧩🔤

A Go application that solves Apple News "Quartile" puzzles by finding valid English words from given letter combinations using WordNet dictionary data.

## Prerequisites

- Go 1.16 or later
- Internet connection to download WordNet data

## Setup Instructions

### 1. Initialize Go Module
```bash
go mod init applequartile
```

### 2. Download WordNet Dictionary Data
The application requires the WordNet Prolog database, specifically the `wn_s.pl` file which contains synset data.

```bash
# Download the WordNet Prolog tar file
curl -O https://wordnetcode.princeton.edu/3.0/WNprolog-3.0.tar.gz

# Extract the tar file - this will create a 'prolog' directory
tar -xvzf WNprolog-3.0.tar.gz
```

**Important**: After extraction, you'll find the required `wn_s.pl` file in the `prolog/` directory. This file contains the dictionary data that the solver uses to validate words.

### 3. Build the Application
```bash
go build -o applequartile
```

## Usage

The application requires two command-line arguments:
- `--dictionary`: Path to the WordNet `wn_s.pl` file
- `--puzzle`: Path to your puzzle file containing the letter combinations

### Basic Usage
```bash
./applequartile --dictionary ./prolog/wn_s.pl --puzzle ./puzzle1.txt
```

### Debug Mode
To see detailed processing information:
```bash
./applequartile --debug --dictionary ./prolog/wn_s.pl --puzzle ./puzzle2.txt
```

### Complete Build and Run Examples
```bash
# Example 1: Build and run with puzzle1.txt
clear && go build -o applequartile && ./applequartile --dictionary ./prolog/wn_s.pl --puzzle ./puzzle1.txt

# Example 2: Build and run with debug output
clear && go build -o applequartile && ./applequartile --debug --dictionary ./prolog/wn_s.pl --puzzle ./puzzle2.txt
```

## How It Works

The solver:
1. Loads the WordNet dictionary from `wn_s.pl` into a trie data structure
2. Processes various word forms (plurals, past tense, present participles)
3. Reads your puzzle file containing letter combinations
4. Generates all possible permutations of the letter combinations
5. Validates each permutation against the dictionary
6. Displays all valid English words found

![image](https://github.com/user-attachments/assets/76c7617c-4eb6-4822-a9ea-f578a1cad161)
