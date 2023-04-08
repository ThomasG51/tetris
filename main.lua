-- display logs in console during execution
io.stdout:setvbuf('no')

-- Pixel Art mode
love.graphics.setDefaultFilter("nearest")

-- use to active random value
math.randomseed(love.timer.getTime())

love.window.setMode(800, 600)
love.window.setTitle('Tetris')

WINDOW_WIDTH = love.graphics.getWidth()
WINDOW_HEIGHT = love.graphics.getHeight()

gameMode = ''
debugMode = false
fallLimit = false

soundMenu = nil
soundPlay = nil
soundGameOver = nil

score = 0
level = 1
line = 0

require("functions/initGrid")
require("functions/drawGrid")
require("functions/drawTetrominos")
require("functions/spawnTetrominos")
require("functions/collide")
require("functions/transfer")
require("functions/removeLine")
require("states/startGame")
require("states/startMenu")
require("states/startGameOver")

local tetrominos = require("entities/tetrominos")
local grid = require("entities/grid")

local currentTetrominos = {}
currentTetrominos.shape = 1
currentTetrominos.rotation = 1
currentTetrominos.positionX = 0
currentTetrominos.positionY = 0

local dropSpeed = 1
local dropTimer = 0
local sinus = 0




-- #        ####    ####   #####
-- #       #    #  #    #  #    #
-- #       #    #  ######  #    #
-- #       #    #  #    #  #    #
-- ######   ####   #    #  #####

function love.load()
  
  love.keyboard.setKeyRepeat(true)
  
  soundMenu = love.audio.newSource("assets/sounds/tetris-gameboy-01.mp3", "stream")
  soundMenu:setLooping(true)
  
  soundPlay = love.audio.newSource("assets/sounds/tetris-gameboy-02.mp3", "stream")
  soundPlay:setLooping(true)
  
  soundGameOver = love.audio.newSource("assets/sounds/tetris-gameboy-04.mp3", "stream")
  soundGameOver:setLooping(true)
  
  soundLine = love.audio.newSource("assets/sounds/line.wav", "static")
  
  soundLevelUp = love.audio.newSource("assets/sounds/levelup.wav", "static")
  
  fontMenu = love.graphics.newFont("assets/fonts/blocked.ttf", 50)
  fontPlay = love.graphics.newFont("assets/fonts/blocked.ttf", 20)
  
  initGrid(grid)
  
  startMenu()
  
end




-- #    #  #####   #####    ####   #####  ######
-- #    #  #    #  #    #  #    #    #    #
-- #    #  #####   #    #  ######    #    ###
-- #    #  #       #    #  #    #    #    #
--  ####   #       #####   #    #    #    ######

function love.update(dt)
  if gameMode == 'menu' then
    sinus = sinus + 60*4*dt
    
  elseif gameMode == 'play' then
    if love.keyboard.isDown("down") == false then
      fallLimit = false
    end
    
    dropTimer = dropTimer - dt
    
    if dropTimer <= 0 then
      currentTetrominos.positionY = currentTetrominos.positionY + 1
      dropTimer = dropSpeed
      
      if collide (tetrominos, currentTetrominos, grid) then
        currentTetrominos.positionY = currentTetrominos.positionY - 1
        transfer(tetrominos, currentTetrominos, grid)
        spawnTetrominos(tetrominos, currentTetrominos, dropTimer, dropSpeed, grid)
      end
    end
    
    local completeRow
    local nbRows = 0
    for row=1, grid.height do
      completeRow = true
      
      -- Pour chaque ligne on verifie si toutes les cellules sont complete
      for column=1, grid.width do
        if grid.cells[row][column] == 0 then
          completeRow = false
        end
      end
      
      if completeRow == true then
        removeLine(row, grid)
        soundLine:play()
        nbRows = nbRows + 1
      end
    end
    
    -- Nombre de lignes complete
    line = line + nbRows
    
    -- Score
    if nbRows == 1 then
      score = score + (100 * level)
    elseif nbRows == 2 then
      score = score + (300 * level)
    elseif nbRows == 3 then
      score = score + (500 * level)
    elseif nbRows == 4 then
      score = score + (800 * level)
    end
    
    local checklevelUp = math.floor(line / 10) + 1
    
    if checklevelUp > level then
      soundLevelUp:play()
      level = level + 1
      dropSpeed = dropSpeed - 0.08
    end
  end
end




-- #####   #####    ####   #     #
-- #    #  #    #  #    #  #     #
-- #    #  #####   ######  #  #  #
-- #    #  #   #   #    #  # # # #
-- #####   #    #  #    #   #   #

function love.draw()
  -- Draw Grid
  drawGrid(grid, tetrominos)
  
  if gameMode == 'menu' then
    
    local colorValue
    local tetrominosId = 1
    local string = "Tetris Lua"
    local stringHeight = fontMenu:getHeight(string)
    local stringWidth = fontMenu:getWidth(string)
    local letterX = (WINDOW_WIDTH - stringWidth) / 2
    local letterY = 0
    
    for letter=1, string:len() do
      colorValue = tetrominos[tetrominosId].color
      love.graphics.setColor(colorValue[1], colorValue[2], colorValue[3])
      local char = string.sub(string, letter, letter)
      
      letterY = math.sin((letterX + sinus)/50)*30
      
      love.graphics.print(char, letterX, letterY + (WINDOW_HEIGHT - stringHeight) / 2)
      
      letterX = letterX + fontMenu:getWidth(char)
            
      tetrominosId = tetrominosId + 1
      if tetrominosId > #tetrominos then
        tetrominosId = 1
      end
    end
    
  elseif gameMode == 'play' then
    -- Draw Tetrominos
    drawTetrominos(tetrominos[currentTetrominos.shape].shape[currentTetrominos.rotation], tetrominos[currentTetrominos.shape].color, grid, currentTetrominos.positionX, currentTetrominos.positionY)
    
    local stringLevel = "Level : "  .. level
    love.graphics.print(stringLevel, WINDOW_WIDTH - fontPlay:getWidth(stringLevel) - 30, fontPlay:getHeight(stringScore) + 30)
    
    local stringLines = "Lines : " .. line
    love.graphics.print(stringLines, 30, fontPlay:getHeight(stringScore) + 30)
    
    local stringScore = "Score : " .. score
    love.graphics.print(stringScore, 30, WINDOW_HEIGHT - fontPlay:getHeight(stringScore) - 30)
    
  elseif gameMode == 'gameover' then
    love.graphics.setColor(1,1,1)
    local gameOver = "GAME OVER"
    local gameOverHeight = fontMenu:getHeight(gameOver)
    local gameOverWidth = fontMenu:getWidth(gameOver)
    
    love.graphics.print(gameOver, (WINDOW_WIDTH - gameOverWidth) / 2, (WINDOW_HEIGHT - gameOverHeight) / 2)
    
  end
end




-- #    #  ######  #   #
-- #   #   #        # #
-- ####    ###       #
-- #   #   #         #
-- #    #  ######    #

function love.keypressed(key)
  if key == "return" then
    startGame(tetrominos, currentTetrominos, dropTimer, dropSpeed, grid)
  end
  
  if key == "escape" then
    startMenu()
  end
  
  if key == "g" then
    gameMode = 'gameover'
  end
  
  if gameMode == 'menu' then
  elseif gameMode == 'play' then
    local oldX = currentTetrominos.positionX
    local oldY = currentTetrominos.positionY
    local oldRotation = currentTetrominos.rotation
    
    if key == "space" then
      if currentTetrominos.rotation < #tetrominos[currentTetrominos.shape].shape then
        currentTetrominos.rotation = currentTetrominos.rotation + 1
      else
        currentTetrominos.rotation = 1
      end
    end
    
    if key == "right" then
      currentTetrominos.positionX = currentTetrominos.positionX + 1
    end
    
    if key == "left" then
      currentTetrominos.positionX = currentTetrominos.positionX - 1
    end
    
    if collide(tetrominos, currentTetrominos, grid) then
      currentTetrominos.positionX = oldX
      currentTetrominos.positionY = oldY
      currentTetrominos.rotation = oldRotation
    end
    
    if fallLimit == false then
      if key == "down" then
        currentTetrominos.positionY = currentTetrominos.positionY + 1
      end
      
      if collide (tetrominos, currentTetrominos, grid) then
        currentTetrominos.positionY = currentTetrominos.positionY - 1
        transfer(tetrominos, currentTetrominos, grid)
        spawnTetrominos(tetrominos, currentTetrominos, dropTimer, dropSpeed, grid)
      end
    end
  end
end