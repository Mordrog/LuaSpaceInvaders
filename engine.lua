Engine = {}

Engine.new = function(animationDelay)
	local self = self or {}
	self.image1 = love.graphics.newImage('assets/engine1.png')
	self.image2 = love.graphics.newImage('assets/engine2.png')
	self.image3 = love.graphics.newImage('assets/engine3.png')
	self.image4 = love.graphics.newImage('assets/engine4.png')
	self.currentImage = self.image1
	self.animationDelay = animationDelay
	self.animationCounter = 0
	
	self.draw = function(x, y)
		love.graphics.draw(self.currentImage, x, y)
	end
	
	
	self.update = function(dt)
		if self.animationCounter < 0 then
			if self.currentImage == self.image1 then
				self.currentImage = self.image2
			elseif self.currentImage == self.image2 then
				self.currentImage = self.image3
			elseif self.currentImage == self.image3 then
				self.currentImage = self.image4
			elseif self.currentImage == self.image4 then
				self.currentImage = self.image1
			end
			self.animationCounter = self.animationDelay
		else
			self.animationCounter  = self.animationCounter - dt
		end
	end

	return self
end