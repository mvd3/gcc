inputFile = io.open('h_index_input.txt', 'r')
io.input(inputFile)

numberOfCases = io.read('n')
io.read() -- finish reading line

function calculateHIndex(citations, size)
  local index = 0
  for key, value in ipairs(citations)
  do
    if (index < value)
    then
      index = index + 1
    end
  end
  return index
end

function checkHIndexes(citationsString)
  local citations = {}
  string.gsub(citationsString, '%d+', function (num) table.insert(citations, tonumber(num)) end)
  local currentCitations = {}
  local currentIndexes = ''
  local length = 0
  for key, value in ipairs(citations)
  do
    table.insert(currentCitations, value)
    table.sort(currentCitations, function(a, b) return a > b end)
    length = length + 1
    currentIndexes = currentIndexes .. ' ' .. calculateHIndex(currentCitations, length)
  end

  return currentIndexes
end

for i = 1, numberOfCases, 1
do
  local numberOfPapers = io.read('n')
  io.read() -- finish reading line
  local result = checkHIndexes(io.read())
  print('Case #' .. i .. ': ' .. result)
end

io.close(inputFile)
