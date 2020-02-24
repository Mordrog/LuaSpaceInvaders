CollisionLayer = {}

CollisionLayer.new = function()
	local self = self or {}

	self.Player = 0x10000000
	self.Enemy = 0x0100000
	self.Bullet = 0x0010000
	
	return self
end