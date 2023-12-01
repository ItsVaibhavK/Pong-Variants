push = require 'push'
Class = require 'class'
require 'Paddle'
require 'Ball'
require 'Death'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243
PADDLE_SPEED = 200


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('DEAD WRONG')
    math.randomseed(os.time())
    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(smallFont)
    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
    deathball = Death(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    player1Score = 0
    player2Score = 0
    servingPlayer = 1
    winningPlayer = 0
    gameState = 'start'
end


function love.resize(w, h)
    push:resize(w, h)
end


function love.update(dt)
    if gameState == 'serve' then
        ball.dy = math.random(-50, 50)
        deathball.dy = math.random(-50, 50)
        deathball.dx = math.random(-200, 200)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end
    elseif gameState == 'play' then
        if ball:collides(player1) then
            deranged1 = math.random(0, 4)
            if deranged1 == 0 then
                player1CollisionBallMovement()
            elseif deranged1 == 1 then
                player1.height = 40
                player1CollisionBallMovement()
            elseif deranged1 == 2 then
                player2.height = 10
                player1CollisionBallMovement()
            else
                player1CollisionBallMovement()
            end
        end
        if ball:collides(player2) then
            deranged2 = math.random(0, 4)
            if deranged2 == 0 then
                player2CollisionBallMovement()
            elseif deranged2 == 1 then
                player2.height = 40
                player2CollisionBallMovement()
            elseif deranged2 == 2 then
                player1.height = 10
                player2CollisionBallMovement()
            else
                player2CollisionBallMovement()
            end            
        end
        if deathball:collides(player1) then
            player2Score = 10
            winningPlayer = 2
            sounds['score']:play()
            gameState = 'sudden death'
        end
        if deathball:collides(player2) then
            player1Score = 10
            winningPlayer = 1
            sounds['score']:play()
            gameState = 'sudden death'
        end

        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end
        if deathball.y <= 0 then
            deathball.y = 0
            deathball.dy = -deathball.dy
        end

        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end
        if deathball.y >= VIRTUAL_HEIGHT - 4 then
            deathball.y = VIRTUAL_HEIGHT - 4
            deathball.dy = -deathball.dy
        end

        if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            sounds['score']:play()

            if player2Score == 10 then
                winningPlayer = 2
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end
        if deathball.x <= 0 then
            deathball.x = 0
            deathball.dx = -deathball.dx
        end

        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1
            sounds['score']:play()

            if player1Score == 10 then
                winningPlayer = 1
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end
        if deathball.x >= VIRTUAL_WIDTH - 4 then
            deathball.x = VIRTUAL_WIDTH - 4
            deathball.dx = -deathball.dx
        end
    end
    if deranged2 == 3 then
        if love.keyboard.isDown('s') then
            player1.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('w') then
            player1.dy = PADDLE_SPEED
        else
            player1.dy = 0
        end
    elseif deranged2 == 4 then
        if love.keyboard.isDown('w') then
            player1.dy = -PADDLE_SPEED / 2
        elseif love.keyboard.isDown('s') then
            player1.dy = PADDLE_SPEED / 2
        else
            player1.dy = 0
        end
    else
        if love.keyboard.isDown('w') then
            player1.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('s') then
            player1.dy = PADDLE_SPEED
        else
            player1.dy = 0
        end
    end
    if deranged1 == 3 then
        if love.keyboard.isDown('down') then
            player2.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('up') then
            player2.dy = PADDLE_SPEED
        else
            player2.dy = 0
        end
    elseif deranged1 == 4 then
        if love.keyboard.isDown('up') then
            player2.dy = -PADDLE_SPEED / 2
        elseif love.keyboard.isDown('down') then
            player2.dy = PADDLE_SPEED / 2
        else
            player2.dy = 0
        end
    else
        if love.keyboard.isDown('up') then
            player2.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('down') then
            player2.dy = PADDLE_SPEED
        else
            player2.dy = 0
        end
    end

    if gameState == 'play' then
        ball:update(dt)
        deathball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' or gameState == 'sudden death' then
            gameState = 'serve'
            player1.height = 20
            player2.height = 20
            deranged1 = 0
            deranged2 = 0
            ball:reset()
            deathball:reset()

            player1Score = 0
            player2Score = 0

            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end


function love.draw()
    push:apply('start')

    love.graphics.clear(0, 0, 0, 1)
    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to DEAD WRONG!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'sudden death' then
        love.graphics.clear(1, 0, 0, 255/255)
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!',
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('SUDDEN DEATH',
            0, 30, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 50, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        -- no UI messages to display in play
    elseif gameState == 'done' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!',
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
    end

    displayScore()  
    player1:render()
    player2:render()
    ball:render()
    deathball:render()
    displayFPS()
    push:apply('end')
end


function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50,
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
end


function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function player1CollisionBallMovement()
    ball.dx = -ball.dx * 1.03
    ball.x = player1.x + 5
    if ball.dy < 0 then
        ball.dy = -math.random(10, 150)
    else
        ball.dy = math.random(10, 150)
    end
    sounds['paddle_hit']:play()
end


function player2CollisionBallMovement()
    ball.dx = -ball.dx * 1.03
    ball.x = player2.x - 4
    if ball.dy < 0 then
        ball.dy = -math.random(10, 150)
    else
        ball.dy = math.random(10, 150)
    end
    sounds['paddle_hit']:play()
end
