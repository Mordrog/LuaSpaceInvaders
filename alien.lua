Alien = {}

Alien.new = function(x,y)
	image = love.graphics.newImage('assets/alien.png')
	image2 = love.graphics.newImage('assets/alien2.png')
	local self = colliderSystem:rectangle(x, y, image:getWidth(), image:getHeight())
	self.image = image
	self.image2 = image2
	self.bullet = love.graphics.newImage('assets/bomb.png')
	self.currentImage = self.image
	self.layer = collisionLayer.Enemy
	
	self.draw = function()
		x,y = self:bbox()
		love.graphics.draw(self.currentImage, x, y)
	end
	
	self.animate = function()
		if self.currentImage == self.image then
			self.currentImage = self.image2
		else
			self.currentImage = self.image
		end
	end
	
	self.moveSide = function(speed)
		self:move(speed, 0)
	end
	
	self.moveDown = function(speed)
		self:move(0, speed)
	end
	
	self.shoot = function(speed)
		x,y = self:center()
		local bullet = Bullet.new(x - 2, y + 10, 0, speed, collisionLayer.Player, self.bullet)
		bulletSystem.insert(bullet)
	end
	
	self.get_hit = function()
		alienHive.remove(self)
	end

	return self
end