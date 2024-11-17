# apple-quartile-solver
Simple Go app to solve Apple News "Quartile" puzzles

`go mod init applequartile`

`curl -O https://wordnetcode.princeton.edu/3.0/WNprolog-3.0.tar.gz`

`tar -xvzf WNprolog-3.0.tar.gz`

Sample 1:
`clear && go build -o applequartile && ./applequartile --dictionary ./prolog/wn_s.pl --puzzle ./puzzle1.txt`

Sample 2:
`clear && go build -o applequartile && ./applequartile --debug --dictionary ./prolog/wn_s.pl --puzzle ./puzzle2.txt`

![image](https://github.com/user-attachments/assets/76c7617c-4eb6-4822-a9ea-f578a1cad161)
