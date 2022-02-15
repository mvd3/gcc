inputFile = io.open('sample_problem_input.txt', 'r')
io.input(inputFile)

numberOfCases = io.read('n')
io.read() -- read the rest of the line

for i = 1, numberOfCases, 1
do
  local numberOfCandyBags, numberOfChildren = io.read('n', 'n')
  io.read() -- read the rest of the line
  local candyBags = io.read()
  local totalCandy = 0
  string.gsub(candyBags, '%d+', function(number) totalCandy = totalCandy + number end)
  local remainingCandy = totalCandy % numberOfChildren
  print('Case #' .. i .. ': ' .. remainingCandy)
end

io.close(inputFile)
