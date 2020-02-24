World = {}

World.new = function(width, height)
	local self = self or {}
	self.width = width
	self.height = height
	self.center = {}
	self.center.x = self.width/2
	self.center.y = self.height/2
	
	self.out_of_bounds = function(x,y)
		return 	x < 0 or
				y < 0 or
				x > self.width or
				y > self.height
	end
	
	return self
end
