local Class1 = {}
-- local Class1_mt = { __index = Class1 }
function Class1:new(n)
  return setmetatable({ n = n }, { __index = Class1 })
end

function Class1:add()
  self.n = self.n + 1
end

local class1 = Class1:new(3)
class1:add()
class1:add()
print(class1.n) -- expected 5
local class2 = Class1:new(1)
class2:add()
class2:add()
print(class2.n) -- expected 3
