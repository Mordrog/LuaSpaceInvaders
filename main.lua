hardoncollider = require 'hardoncollider'
require("ship")
require("alien")
require("bullet")
require("bulletSystem")
require("world")
require("collisionLayer")
require("alienHive")
require("switcher")
require("background")

GameState = {START="START", GAME="GAME", CONTINUE="CONTINUE", GAMEOVER="GAMEOVER"}

function displayStartUI()
	center = world.center
	love.graphics.setNewFont("assets/arcade_fonts.ttf", 20)
	love.graphics.printf("Space invaders", 150, 50, 300, 'center')
	
	love.graphics.setNewFont("assets/arcade_fonts.ttf", 18)
	love.graphics.printf("Score", 150, 150, 300, 'center')
	love.graphics.printf(score, 150, 180, 300, 'center')
	love.graphics.setNewFont("assets/arcade_fonts.ttf", 12)
	love.graphics.printf("Stage Level", 150, 300, 300, 'center')
	love.graphics.printf(stageLevel, 150, 330, 300, 'center')
	
	if blinkingTextSwitcher.switch then
		love.graphics.setNewFont("assets/arcade_fonts.ttf", 10)
		love.graphics.printf("Press space to start!", 150, 430, 300, 'center')
	end
end

function displayGameUI()
	love.graphics.setNewFont("assets/arcade_fonts.ttf", 18)
	love.graphics.printf("Score: " .. tostring(score), 10, 10, 300, 'left')
	love.graphics.printf("Stage Level: " .. tostring(stageLevel), 290, 10, 300, 'right')
	
	for live = 1,player.lives do
		love.graphics.draw(liveImage, 590 - (live * liveImage:getWidth() * 1.1), 770)
	end
end

function displayContinueUI()
	center = world.center
	love.graphics.setNewFont("assets/arcade_fonts.ttf", 20)
	love.graphics.printf("Stage cleared!", 150, 50, 300, 'center')
	
	love.graphics.setNewFont("assets/arcade_fonts.ttf", 18)
	love.graphics.printf("Score", 150, 150, 300, 'center')
	love.graphics.printf(score, 150, 180, 300, 'center')
	love.graphics.setNewFont("assets/arcade_fonts.ttf", 12)
	love.graphics.printf("Stage Level", 150, 300, 300, 'center')
	love.graphics.printf(stageLevel, 150, 330, 300, 'center')
	
	if blinkingTextSwitcher.switch then
		love.graphics.setNewFont("assets/arcade_fonts.ttf", 10)
		love.graphics.printf("Press space to start!", 150, 430, 300, 'center')
	end
end

function displayGameoverUI()
	center = world.center
	love.graphics.setNewFont("assets/arcade_fonts.ttf", 20)
	love.graphics.printf("Gameover", 150, 50, 300, 'center')
	
	love.graphics.setNewFont("assets/arcade_fonts.ttf", 18)
	love.graphics.printf("Score", 150, 150, 300, 'center')
	love.graphics.printf(score, 150, 180, 300, 'center')
	love.graphics.setNewFont("assets/arcade_fonts.ttf", 12)
	love.graphics.printf("Stage Level", 150, 300, 300, 'center')
	love.graphics.printf(stageLevel, 150, 330, 300, 'center')
	
	love.graphics.setNewFont("assets/arcade_fonts.ttf", 10)
	love.graphics.printf("Press space to continue!", 150, 430, 300, 'center')
end

function stageWon()
	gameState = GameState.START
	score = score + 100
	stageLevel = stageLevel + 1
	bulletSystem.clear()
	respawnAliens()
	alienHive.levelUpShootChance(1)
	screenSwitchDelay = 1
end

function gameover()
	gameState = GameState.GAMEOVER
	alienHive.clear()
	bulletSystem.clear()
	respawnAliens()
	alienHive.resetShootChance()
	player.lives = 5
	screenSwitchDelay = 1
end

function collidesWithWall(rect)
	return rect:collidesWith(leftWall) or rect:collidesWith(rightWall)
end

function collidesWithLeftWall(rect)
	return rect:collidesWith(leftWall)
end

function collidesWithRightWall(rect)
	return rect:collidesWith(rightWall)
end

function respawnAliens()
	alienHive.resetSpeed()
	for row = 0, 5 do
		for column = 0, 7 do
			local alien = Alien.new(70 + column * 60, 70 + row * 40)
			alienHive.insert(alien)
		end
	end
end

function love.load()
	gameState = GameState.START
	liveImage = love.graphics.newImage('assets/live.png')
	love.window.setMode(600, 800, {resizable=false, vsync=false})
	world = World.new(600, 800)
	colliderSystem = hardoncollider.new(200)
	bulletSystem = BulletSystem.new()
	collisionLayer = CollisionLayer.new()
	background = Background.new(10)
	blinkingTextSwitcher = Switcher.new(0.5)
	screenSwitchDelay = 1
	
	stageLevel = 1
	score = 0
	player = Ship.new(300, 700)
	player.shootDelay = 0.5
	alienHive = AlienHive.new()
	leftWall = colliderSystem:rectangle(-100, 0, 100,800)
	rightWall = colliderSystem:rectangle(600, 0, 100,800)
	respawnAliens()
end

function love.draw()
	if gameState == GameState.START then
		displayStartUI()
	elseif gameState == GameState.GAME then
		background.draw()
		bulletSystem.draw()
		alienHive.draw()
		player:draw()
		displayGameUI()
	elseif gameState == GameState.START then
		displayContinueUI()
	elseif gameState == GameState.GAMEOVER then
		displayGameoverUI()
	end
end

function love.update(dt)
	if gameState == GameState.START or gameState == GameState.CONTINUE or gameState == GameState.GAMEOVER  then
		screenSwitchDelay = screenSwitchDelay - dt
		blinkingTextSwitcher.update(dt)
		return
	end
	
	background.update(dt)
	player.update(dt)

	if player.shootDelay > 0 then
		player.shootDelay = player.shootDelay - dt
	end
	
	if love.keyboard.isDown("a") and not collidesWithLeftWall(player) then player.moveLeft(400*dt) end
	if love.keyboard.isDown("d") and not collidesWithRightWall(player) then player.moveRight(400*dt) end
	
	bulletSystem.update(dt)
	alienHive.update(dt)
	
	if next(alienHive.aliens) == nil then
		stageWon()
	end
	
	if player.lives <= 0 then
		gameover()
	end
	
	for alien,_ in pairs(alienHive.aliens) do
		x,y = alien:bbox()
		if y >= 700 then
			gameover()
		end
	end
end

function love.keypressed(key)
	if gameState == GameState.START then
		if screenSwitchDelay <= 0 and key == "space" then
			gameState = GameState.GAME
		end
	end
	
	if gameState == GameState.CONTINUE then
		if screenSwitchDelay <= 0 and key == "space" then
			gameState = GameState.GAME
		end
	end

	if gameState == GameState.GAMEOVER then
		if screenSwitchDelay <= 0 and key == "space" then
			score = 0
			stageLevel = 1
			gameState = GameState.START
		end
	end
	
	if gameState == GameState.GAME then
		if player.shootDelay < 0 and key == "space" then
			player.shoot(400)
			player.shootDelay = 0.2
		end
	end

end