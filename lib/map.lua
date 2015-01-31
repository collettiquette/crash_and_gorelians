Map = {}

function Map:distance_between(g1, g2)
  return math.sqrt(((g2.x-g1.x)^2) + ((g2.y-g1.y)^2))
end

