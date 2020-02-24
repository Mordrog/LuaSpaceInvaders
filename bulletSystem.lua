BulletSystem = {}

BulletSystem.new = function()
	local self = self or {}
	self.bullets = {}
	
	self.insert = function(bullet)
		self.bullets[bullet] = bullet
	end
	
	self.remove = function(bullet)
		self.bullets[bullet] = nil
	end
	
	self.clear = function()
		for bullet,_ in pairs(self.bullets) do
			self.bullets[bullet] = nil
		end
	end
	
	self.draw = function(dt)
		for bullet,_ in pairs(self.bullets) do
			bullet.draw()
		end
	end
	
	self.update = function(dt)
		for bullet,_ in pairs(self.bullets) do
			bullet.update(dt)
			if world.out_of_bounds(bullet:bbox()) then
				self.remove(bullet)
			end
		end
	end
	
	return self
end