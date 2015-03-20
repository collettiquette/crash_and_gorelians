----------------------------------------------
-- crash.lua by Kevin Collette for CSC 333  --
----------------------------------------------

----------------------------------------------
-- Gorelian                                 --
----------------------------------------------

Gorelian = {
  x = 0,
  y = 0,
  radio_range = 0
}

--class methods

function Gorelian.combine(group)
  pos = Map.average_position(group)
  return Gorelian:new(pos.x, pos.y, Map.combined_radio_range(group))
end

--instance methods

function Gorelian:new(dx, dy, range)
  --create instance using prototype
  obj = { x = dx, 
          y = dy, 
          radio_range = range 
        }
  setmetatable(obj, self)
  self.__index = self
  return obj
end

function Gorelian:eq(other)
  return self.x == other.x and 
         self.y == other.y and 
         self.radio_range == other.radio_range
end

function Gorelian:radio_area()
  return self.radio_range^2
end

function Gorelian:reach(other)
  return Map.distance_between(self, other) < self.radio_range
end

function Gorelian:can_meet(other)
  return self:reach(other) or other:reach(self)
end

----------------------------------------------
-- Map                                      --
----------------------------------------------

Map = {}

--class methods

function Map.distance_between(g1, g2)
  return math.sqrt(((g2.x-g1.x)^2) + ((g2.y-g1.y)^2))
end

function Map.average_position(gorelians)
  xs, ys, length = 0, 0, 0
  for i, gorelian in pairs(gorelians) do
    xs = xs + gorelian.x
    ys = ys + gorelian.y
    if i > length then length = i end
  end  
  return { x = (xs/length), y = (ys/length) }
end

function Map.combined_radio_range(gorelians)
  range = 0
  for i, gorelian in pairs(gorelians) do
    range = range + gorelian:radio_area()
  end
  return math.sqrt(range)
end

----------------------------------------------
-- Party                                    --
----------------------------------------------

Party = {
  gorelians = {},
  groups = {}
}

--class methods

function Party.meet(gorelian, group)
  to_combine = {gorelian}
  groups = {}

  for i,g in pairs(group) do
    if gorelian:can_meet(g) then
      table.insert(to_combine, g)
    else
      table.insert(groups, g)
    end
  end
  new_gorelian = Gorelian.combine(to_combine)

  if not(new_gorelian:eq(gorelian)) then
    return Party.meet(new_gorelian, groups)
  end
  table.insert(groups, new_gorelian)
  return groups
end

--instance methods

function Party:new(gorelian_party)
  --create instance using prototype
  obj = { gorelians = gorelian_party }
  setmetatable(obj, self)
  self.__index = self
  return obj
end

function Party:search()
  for i, gorelian in pairs(self.gorelians) do
    self.groups = Party.meet(gorelian, self.groups)
  end
  return self.groups
end

----------------------------------------------
-- Parties                                  --
----------------------------------------------

Parties = {
  gorelian_parties = {}
}

--instance methods

function Parties:new()
  --create instance using prototype
  obj = { gorelian_parties = {} }
  setmetatable(obj, self)
  self.__index = self
  return obj
end

function Parties:read_input()
  gorelian_num = io.read("*n")
  while gorelian_num ~= 0 do
    gorelians = {} 
    for i=1,gorelian_num do
      x, y, radio_range = io.read("*n","*n","*n")
      table.insert(gorelians, Gorelian:new(x, y, radio_range))
    end
    table.insert(self.gorelian_parties, Party:new(gorelians))
    gorelian_num = io.read("*n")
  end
end

function Parties:output()
  for i, party in pairs(self.gorelian_parties) do
    groups_left = party:search()
    size = 0
    for i, group in pairs(groups_left) do
      if i > size then size = i end
    end
    print(size)
  end
end

----------------------------------------------
-- Main                                     --
----------------------------------------------

p = Parties:new()
p:read_input()
p:output()
