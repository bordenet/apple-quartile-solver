# apple-quartile-solver
Simple Go app to solve Apple News "Quartile" puzzles

`go mod init applequartile`
`curl -O https://wordnetcode.princeton.edu/3.0/WNprolog-3.0.tar.gz`
`tar -xvzf WNprolog-3.0.tar.gz`

Sample:
`clear && go build -o applequartile && ./applequartile --dictionary ./prolog/wn_s.pl --puzzle ./puzzle2.txt`

