AlienHive = {}

AlienHive.new = function()
	local self = self or {}
	self.aliens = {}
	self.speed = 100
	self.direction = 1
	self.chanceToShoot = 1
	
	self.insert = function(alien)
		self.aliens[alien] = alien
		self.aliens[alien].shootDelay = 0
		self.aliens[alien].animationDelay = 0
	end
	
	self.remove = function(alien)
		colliderSystem:remove(self.aliens[alien])
		self.aliens[alien] = nil
		self.levelUpSpeed(1)
		score = score + 10
	end
	
	self.clear = function()
		for alien,_ in pairs(self.aliens) do
			colliderSystem:remove(self.aliens[alien])
			self.aliens[alien] = nil
		end
	end
	
	self.draw = function(dt)
		for alien,_ in pairs(self.aliens) do
			alien.draw()
		end
	end
	
	self.resetSpeed = function()
		self.speed = 100
	end
	
	self.resetShootChance = function()
		self.chanceToShoot = 1
	end
	
	self.levelUpSpeed = function(levels)
		for level = 0, levels do
			self.speed = self.speed + 5
		end
	end
	
	self.levelUpShootChance = function(levels)
		for level = 0, levels do
			self.chanceToShoot = self.chanceToShoot + 2
		end
	end
	
	self.update = function(dt)
		local goDown = false
		
		for alien,_ in pairs(self.aliens) do
			alien.moveSide(self.speed * self.direction * dt)
			
			if alien.animationDelay < 0 then
				alien.animate()
				alien.animationDelay = 25/self.speed
			else
				alien.animationDelay = alien.animationDelay - dt
			end
			
			if alien.shootDelay < 0 and self.chanceToShoot >= love.math.random(1, 100000) then
				alien.shoot(200)
				alien.shootDelay = 3
			else
				alien.shootDelay = alien.shootDelay - dt
			end
			
			if self.speed * self.direction < 0 and collidesWithLeftWall(alien) or self.speed * self.direction > 0 and collidesWithRightWall(alien) then
				goDown = true
			end
		end
		
		if goDown then
			self.direction = -self.direction
			for alien,_ in pairs(self.aliens) do
				alien.moveDown(15)
			end
		end
	end
	
	return self
end