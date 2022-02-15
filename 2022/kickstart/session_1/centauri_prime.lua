inputFile = io.open('centauri_prime_input.txt', 'r')
io.input(inputFile)

numberOfCases = io.read('n')
io.read() -- finish reading line

for i=1, numberOfCases, 1
do
  local line = io.read()
  local king = 'Bob'
  if (string.match(line, '^.*[aeiouAEIOU]$') ~= nil)
  then
    king = 'Alice'
  elseif (string.match(line, '^.*[yY]$') ~= nil)
  then
    king = 'nobody'
  end
  print('Case #' .. i .. ': ' .. line .. ' is ruled by ' .. king .. '.')
end

io.close(inputFile)
