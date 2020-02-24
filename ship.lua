require('engine')

Ship = {}

Ship.new = function(x, y)
	image = love.graphics.newImage('assets/ship.png')
	local self = colliderSystem:rectangle(x, y, image:getWidth(), image:getHeight())
	self.image = image
	self.bullet = love.graphics.newImage('assets/laser.png')
	self.engineLeft = Engine.new(0.15)
	self.engineRight = Engine.new(0.15)
	self.layer = collisionLayer.Player
	self.lives = 5
	
	self.draw = function()
		x,y = self:bbox()
		self.engineLeft.draw(x,y + 36)
		self.engineRight.draw(x + image:getWidth()*2 - 12,y + 36)
		love.graphics.draw(self.image, x, y)
	end
	
	self.update = function(dt)
		self.engineLeft.update(dt)
		self.engineRight.update(dt)
	end
	
	self.moveLeft = function(speed)
		self:move(-speed, 0)
	end
	
	self.moveRight = function(speed)
		self:move(speed, 0)
	end
	
	self.shoot = function(speed)
		x,y = self:center()
		local bullet = Bullet.new(x - 2, y - 10, 0, -speed, collisionLayer.Enemy, self.bullet)
		bulletSystem.insert(bullet)
	end
	
	self.get_hit = function()
		self.lives = self.lives - 1
	end
	
	return self
end