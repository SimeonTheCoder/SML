function lines_from(file)
  local lines = {}
  
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

local file = "main.sml"
local lines = lines_from(file)

local vars = {}

function parseLine(tokens)  
  if tokens[1] == "def" then
    if tokens[2] == "num" then
      vars[tokens[3]] = {tonumber(tokens[4]), "num"}
    end
    
    if tokens[2] == "str" then
      vars[tokens[3]] = {tokens[4], "str"}
    end
  end
  
  if tokens[1] == "out" then
    print(vars[tokens[2]][1])
  end
  
  if tokens[1] == "put" then
    if tokens[3] == "in" then
      if vars[tokens[2]][2] == "str" then
        vars[tokens[2]][1] = io.read()
      end
      
      if vars[tokens[2]][2] == "num" then
        vars[tokens[2]][1] = tonumber(io.read())
      end
    end
    
    if tokens[3] ~= "in" then
      if tokens[4] == nil then
        if vars[tokens[2]][2] == "str" then
          vars[tokens[2]][1] = tokens[3]
        end
        
        if vars[tokens[2]][2] == "num" then
          vars[tokens[2]][1] = tonumber(tokens[3])
        end
      end
      
      if tokens[4] ~= nil then
        if tokens[4] == ".." then
          vars[tokens[2]][1] = vars[tokens[3]][1]..vars[tokens[5]][1]
        end
        
        if tokens[4] == "+" then
          vars[tokens[2]][1] = vars[tokens[3]][1] + vars[tokens[5]][1]
        end
        
        if tokens[4] == "-" then
          vars[tokens[2]][1] = vars[tokens[3]][1] - vars[tokens[5]][1]
        end
        
        if tokens[4] == "*" then
          vars[tokens[2]][1] = vars[tokens[3]][1] * vars[tokens[5]][1]
        end
        
        if tokens[4] == "/" then
          vars[tokens[2]][1] = vars[tokens[3]][1] / vars[tokens[5]][1]
        end
        
        if tokens[4] == "%" then
          vars[tokens[2]][1] = vars[tokens[3]][1] % vars[tokens[5]][1]
        end
        
        if tokens[4] == "==" then          
          if vars[tokens[3]][1] == vars[tokens[5]][1] then
            vars[tokens[2]][1] = 1
          else
            vars[tokens[2]][1] = 0
          end
        end
        
        if tokens[4] == "!=" then
          if vars[tokens[3]][1] == vars[tokens[5]][1] then
            vars[tokens[2]][1] = 0
          else
            vars[tokens[2]][1] = 1
          end
        end
        
        if tokens[4] == "<" then
          if vars[tokens[3]][1] < vars[tokens[5]][1] then
            vars[tokens[2]][1] = 1
          else
            vars[tokens[2]][1] = 0
          end
        end
        
        if tokens[4] == ">" then
          if vars[tokens[3]][1] > vars[tokens[5]][1] then
            vars[tokens[2]][1] = 1
          else
            vars[tokens[2]][1] = 0
          end
        end
        
        if tokens[4] == "<=" then
          if vars[tokens[3]][1] <= vars[tokens[5]][1] then
            vars[tokens[2]][1] = 1
          else
            vars[tokens[2]][1] = 0
          end
        end
        
        if tokens[4] == ">=" then
          if vars[tokens[3]][1] >= vars[tokens[5]][1] then
            vars[tokens[2]][1] = 1
          else
            vars[tokens[2]][1] = 0
          end
        end
      end
    end
  end
  
  if tokens[1] == "for" then   
    for i = 3, 7, 1 do      
      if tonumber(tokens[i]) == nil and i > skip_to then
        tokens[i] = vars[tokens[i]][1]
      end
    end
    
    local i = tonumber(tokens[3])
    
    while i <= tonumber(tokens[4]) do
      vars[tokens[2]][1] = i
      
      local j = tonumber(tokens[6])
      
      while j <= tonumber(tokens[7]) do
        local ctokens = {}
        
        for token in string.gmatch(lines[j], "[^,%s]+") do
          table.insert(ctokens, token)
        end
        
        table.remove(ctokens, 1)
        
        if ctokens[1] == "goto" then j = tonumber(ctokens[2]) - 1 else parseLine(ctokens) end
        
        j = j + 1
      end
      
      i = i + tonumber(tokens[5])
    end
  end
  
  if tokens[1] == "if" then
    if vars[tokens[2]] == 1 then
      for j = tonumber(tokens[3]), tonumber(tokens[4]), 1 do
        local ctokens = {}
        
        for token in string.gmatch(lines[j], "[^,%s]+") do
          table.insert(ctokens, token)
        end
        
        table.remove(ctokens, 1)
        
        parseLine(ctokens)
      end
    end
  end
end

local k = 1

while(k ~= #lines) do
  line = lines[k]
  
  local tokens = {}
  
  for token in string.gmatch(line, "[^,%s]+") do
    table.insert(tokens, token)
  end
  
  table.remove(tokens, 1)
  
  if tokens[1] == "for" then
    k = tonumber(tokens[7])
  end
  
  if tokens[1] == "if" then
    k = tonumber(tokens[4])
  end
  
  if tokens[1] == "goto" then
    k = tonumber(tokens[2] - 1)
  end
  
  parseLine(tokens)
  
  k = k + 1
end