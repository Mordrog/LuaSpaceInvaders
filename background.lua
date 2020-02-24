Background = {}

Background.new = function(speed)
	local self = self or {}
	self.image1 = love.graphics.newImage('assets/background.png')
	self.image2 = love.graphics.newImage('assets/background.png')
	self.y1 = 0
	self.y2 = self.y1 - self.image2:getHeight()
	self.speed = speed
	
	self.draw = function()
		love.graphics.draw(self.image1, 0, self.y1)
		love.graphics.draw(self.image1, 0, self.y2)
	end
	
	
	self.update = function(dt)
		if self.y1 > self.image1:getHeight() then
			self.y1 = self.y2 - self.image1:getHeight()
		end
		if self.y2 > self.image2:getHeight() then
			self.y2 = self.y1 - self.image2:getHeight()
		end
		
		self.y1 = self.y1 + self.speed * dt
		self.y2 = self.y2 + self.speed * dt
	end

	return self
end