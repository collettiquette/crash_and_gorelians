Gorelian = {
  x = 0,
  y = 0,
  radio_range = 0
}

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

function Gorelian:reach(other)

end

