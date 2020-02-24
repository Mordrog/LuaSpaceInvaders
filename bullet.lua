Bullet = {}

Bullet.new = function(x,y,velocity_x,velocity_y, target_layer, image)
	local self = colliderSystem:rectangle(x, y, image:getWidth(), image:getHeight())
	self.image = image
	self.velocity = {}
	self.velocity.x = velocity_x
	self.velocity.y = velocity_y

	self.layer = collisionLayer.Bullet
	self.target_layer = target_layer
	
	self.draw = function()
		x,y = self:bbox()
		love.graphics.draw(self.image, x, y)
	end
	
	self.update = function(dt)
		self:move(self.velocity.x * dt, self.velocity.y * dt)
		
		local collisions = colliderSystem:collisions(self)
		
		for other, separating_vector in pairs(collisions) do
			if self.target_layer == other.layer then
				other.get_hit()
				bulletSystem.remove(self)
			end
		end
	end
	
	return self
end