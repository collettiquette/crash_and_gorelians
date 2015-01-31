require 'lib.gorelian'
require 'lib.map'

alice = Gorelian:new(100, 100, 50)
bob = Gorelian:new(120, 100, 30)
print(Map.distance_between(self, alice, bob))
