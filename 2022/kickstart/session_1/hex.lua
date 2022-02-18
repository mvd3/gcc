inputFile = io.open('hex_input.txt', 'r')
io.input(inputFile)

numberOfCases = io.read('n')
io.read() -- move to next line

blueWins = 'Blue wins'
redWins = 'Red wins'
nobodyWins = 'Nobody wins'
impossible = 'Impossible'
neighboursPositions = {
  {{0, 1}, {1, 0}},
  {{0, -1}, {-1, 0}},
  {{0, -1}, {1, -1}, {1, 0}},
  {{0, 1}, {-1, 1}, {-1, 0}},
  {{0, -1}, {1, -1}, {1, 0}, {0, 1}},
  {{-1, 0}, {-1, 1}, {0, 1}, {1, 0}},
  {{1, 0}, {1, -1}, {0, -1}, {-1, 0}},
  {{0, 1}, {-1, 1}, {-1, 0}, {0, -1}},
  {{1, 0}, {1, -1}, {0, -1}, {0, 1}, {-1, 0}, {-1, 1}}
}

function createTable(size)
  table = {}

  for i = 1, size, 1
  do
    table[i] = {}
    for j = 1, size, 1
    do
      table[i][j] = 0 -- 0 - empty, 1 - blue, 2 - red
    end
  end

  return table
end

function createNeighbourTable(size)
  local table = {}

  for i = 1, size, 1
  do
    table[i] = {}
    for j = 1, size, 1
    do
      if (i == 1 and j == 1) -- top left
      then
        table[i][j] = 1
      elseif (i == 1 and j == size) -- top right
      then
        table[i][j] = 3
      elseif (i == size and j == 1) -- bottom left
      then
        table[i][j] = 4
      elseif (i == size and j == size) -- bottom right
      then
        table[i][j] = 2
      elseif (i == 1) -- top side
      then
        table[i][j] = 5
      elseif (i == size) -- bottom side
      then
        table[i][j] = 8
      elseif (j == 1) -- left side
      then
        table[i][j] = 6
      elseif (j == size) -- right side
      then
        table[i][j] = 7
      else -- inner
        table[i][j] = 9
      end
    end
  end

  return table
end

function translateSymbol(symbol)
  local s = 0
  if (symbol == 'B')
  then
    s = 1
  elseif (symbol == 'R')
  then
    s = 2
  end
  return s
end

function removeElement(array, position)
  local newArray = array
  for i = position, #newArray - 1, 1
  do
    newArray[i] = newArray[i + 1]
  end
  newArray[#newArray] = nil
  return newArray
end

for i = 1, numberOfCases, 1
do
  local tableSize = io.read('n')
  io.read() -- move to next line

  if (tableSize == 1) --special case
  then
    local fieldValue = io.read()
    local winner = impossible
    if (fieldValue == 'B')
    then
      winner = blueWins
    elseif (fieldValue == 'R')
    then
      winner = redWins
    elseif (fieldValue == '.')
    then
      winner = nobodyWins
    end
    print('Case #' .. i .. ': ' .. winner)
  else
    -- Read table content
    local table = createTable(tableSize)
    local neighbourTable = createNeighbourTable(tableSize)
    local nodes = {{}, {}} -- blue and red
    local colorCount = {0, 0} -- blue and red
    for j = 1, tableSize, 1
    do
      for k = 1, tableSize, 1
      do
        table[j][k] = translateSymbol(io.read(1))
        if (table[j][k] > 0)
        then
          colorCount[table[j][k]] = colorCount[table[j][k]] + 1
          nodes[table[j][k]][#nodes[table[j][k]] + 1] = {j, k} -- add node
        end
      end
      io.read() -- finish line
    end

    --Check if there are regular number of colors
    if (math.abs(colorCount[1] - colorCount[2]) > 1) -- invalid
    then
      print('Case #' .. i .. ': ' .. impossible)
    else -- continue checking
      local regions = {{}, {}} -- blue and red
      for j = 1, #nodes, 1 -- color indicator
      do
        while (#nodes[j] > 0)
        do
          local nodesToCheck = {}
          local region = {}
          nodesToCheck[#nodesToCheck + 1] = nodes[j][1]
          nodes[j] = removeElement(nodes[j], 1)

          while (#nodesToCheck > 0) -- connect regions
          do
            local node = nodesToCheck[1]
            local neighbours = neighboursPositions[neighbourTable[node[1]][node[2]]]
            for k = 1, #neighbours, 1
            do
              if (table[node[1] + neighbours[k][1]][node[2] + neighbours[k][2]] == j) --matching color
              then
                for t = 1, #nodes[j], 1
                do
                  if (nodes[j][t][1] == node[1] + neighbours[k][1] and nodes[j][t][2] == node[2] + neighbours[k][2])
                  then
                    nodesToCheck[#nodesToCheck + 1] = nodes[j][t]
                    nodes[j] = removeElement(nodes[j], t)
                    break
                  end
                end
              end
            end
            region[#region + 1] = node
            nodesToCheck = removeElement(nodesToCheck, 1)
          end
          regions[j][#regions[j] + 1] = region
        end
      end

      local completeRegions = {0, 0} -- blue and red
      local regionToCheck = nil
      local sideTransition = {2, 1} -- blue goes horizontally, red vertically
      for j = 1, #completeRegions, 1
      do
        local zeroCheck = false
        local limitCheck = false
        for k = 1, #regions[j], 1
        do
          for t = 1, #regions[j][k], 1
          do
            if (regions[j][k][t][sideTransition[j]] == 1)
            then
              zeroCheck = true
            elseif (regions[j][k][t][sideTransition[j]] == tableSize)
            then
              limitCheck = true
            end
          end
          if (zeroCheck and limitCheck) -- check if matching region
          then
            regionToCheck = regions[j][k]
            completeRegions[j] = completeRegions[j] + 1
          end
        end
      end

      if (completeRegions[1] + completeRegions[2] == 0) -- not finished
      then
        print('Case #' .. i .. ': ' .. nobodyWins)
      elseif (completeRegions[1] + completeRegions[2] > 1) -- impossible
      then
        print('Case #' .. i .. ': ' .. impossible)
      else -- check minimum width
        local determined = false
        local winner = 1
        if (completeRegions[2] == 1)
        then
          winner = 2
        end
        for j = 1, tableSize, 1
        do
          local count = 0
          for k = 1, #regionToCheck, 1
          do
            if (winner == 1) -- blue
            then
              if (regionToCheck[k][2] == j)
              then
                count = count + 1
              end
            else -- red
              if (regionToCheck[k][1] == j)
              then
                count = count + 1
              end
            end
          end
          if (count == 1)
          then
            determined = true
          end
        end
        if (determined)
        then
          if (winner == 1)
          then
            print('Case #' .. i .. ': ' .. blueWins)
          else
            print('Case #' .. i .. ': ' .. redWins)
          end
        else
          print('Case #' .. i .. ': ' .. impossible)
        end
      end

    end
  end
end

io.close(inputFile)
