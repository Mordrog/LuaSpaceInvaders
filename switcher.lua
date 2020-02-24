Switcher = {}

Switcher.new = function(timeSpan)
	local self = self or {}
	self.switch = false
	self.timeSpan = timeSpan
	self.switchDelay = 0
	
	
	self.update = function(dt)
		if self.switchDelay < 0 then
			self.switchDelay = self.timeSpan
			self.switch = not self.switch
		else
			self.switchDelay = self.switchDelay - dt
		end
	end
	
	return self
end