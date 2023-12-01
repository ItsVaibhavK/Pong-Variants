# PONG VARIANT DEMOS
1. [DONG - Demo video on YouTube](https://youtu.be/k3hmONNfAvk)
2. [WRONG - Demo video on YouTube](https://youtu.be/RISLevwBapw)
3. [DEAD WRONG - Demo video on YouTube](https://youtu.be/cNqA6Q7hTE4)

# PREFACE
I had been on a roll of completing [CS50](https://pll.harvard.edu/course/cs50-introduction-computer-science)'s courses on the [edX](https://www.edx.org/) platform, and had picked up skills in a variety of programming concepts, languages and applications.<br>That is when I came across [CS50G - CS50’s
Introduction to Game Development](https://cs50.harvard.edu/games/2018/).

Like a lot of people, I do enjoy gaming here and there, but I had never really thought of peeking behind the curtain of what made games run underneath the hood.<br>This course and its teachers absolutely BLEW my mind.

The first week of this course covered [Pong](https://en.wikipedia.org/wiki/Pong), the famous 1972 arcade game. We were introduced to [Lua](https://www.lua.org/) and [LÖVE](https://love2d.org/), and a whole host of concepts<br>that are important to game development. The first assignment tasked us with making either of the paddles, or both, a "computer-controlled" paddle.<br>Upon completing [this assignment](https://github.com/ItsVaibhavK/CS50G-2023/blob/main/pong/main.lua) successfully, I was left wanting... more. And so I decided I would tinker around with the game's base code that was provided to us<br>and make my own variants of [Pong](https://en.wikipedia.org/wiki/Pong).

My first attempt resulted in [Dong - Death Pong](https://github.com/ItsVaibhavK/Pong-Variants.git). My second attempt gave rise to [Wrong](https://github.com/ItsVaibhavK/Pong-Variants.git). Here's how I executed the two variants.

# DONG - DEATH PONG
The idea was simple. Using what we had learned so far in the first week, I would introduce a second ball into the game. Since we hadn't learnt how to add colors to sprites,<br>I differentiated this second ball by turning it into an *outline* of a ball, instead of the regular filled-in ball. This ball was the DEATH BALL.

A regular game of [Pong](https://en.wikipedia.org/wiki/Pong) ends when a player gets to the target score first. Players score when their opponents miss the ball.<br>However, if a player made contact with the DEATH BALL, they would lose the game instantly via "sudden death."<br>Here's how I turned that logic into code.

## EXECUTION
*Note: Players can control the paddles using W and S keys for Player 1, and the up and down arrow keys for Player 2.*

### APPEARANCE
I needed the DEATH BALL to be distinguishable from the regular ball. I achieved this by turning the DEATH BALL into its own class,<br>where I could then add the following to its render function to get an *outline* ball instead of a *fill-in* ball:<br>`love.graphics.rectangle('line', self.x, self.y, self.width, self.height)`

### WALL COLLISION
The regular ball only "bounced" back from the vertical edges, as if it went past the horizontal edges, that meant a point for one of the players.<br>I needed the DEATH BALL to keep bouncing around all 4 edges **until** it made contact with one of the players' paddles.<br>So I modified its collision behavior along the X axis using:
```
if deathball.x <= 0 then
    deathball.x = 0
    deathball.dx = -deathball.dx
end
```
for the left edge, and:
```
if deathball.x >= VIRTUAL_WIDTH - 4 then
    deathball.x = VIRTUAL_WIDTH - 4
    deathball.dx = -deathball.dx
end
```
for the right edge.

### SUDDEN DEATH
Now, for how the game would conclude via sudden death. The game could still end via the normal fashion if both players successfully avoided the DEATH BALL<br>throughout their playthrough and one of the player scored the game-ending 10 points.<br>But **if** one of the players made contact with the DEATH BALL, the opponent's score would instantly be set to 10, triggering the game-ending condition of a winning score.<br>
This was executed with the following block of code:
```
if deathball:collides(player1) then
    player2Score = 10
    winningPlayer = 2
    sounds['score']:play()
    gameState = 'sudden death'
end
```
and a similar code block from the other player's perspective.<br>I also wanted a different game-over screen if a player won via sudden death, compared to the regular game-over screen. That screen was accomplished using:
```
elseif gameState == 'sudden death' then
    love.graphics.clear(1, 0, 0, 255/255)
    love.graphics.setFont(largeFont)
    love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!',
        0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('SUDDEN DEATH',
        0, 30, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(smallFont)
    love.graphics.printf('Press Enter to restart!', 0, 50, VIRTUAL_WIDTH, 'center')
```

## CONCLUSION
And there it was! My first attempt at experimenting and modifying a game to execute my own ideas!<br>*What a RUSH.*

# WRONG
After successfully creating [Dong - Death Pong](https://github.com/ItsVaibhavK/Pong-Variants.git), I wanted to create a [Pong](https://en.wikipedia.org/wiki/Pong) variant whose gameplay would be... *unhinged*. The gameplay was so "broken",<br>I decided to name this variant [Wrong](https://github.com/ItsVaibhavK/Pong-Variants.git). Here's how it works:
1. There is only one ball in play.
2. The only sprites that get affected in this variant are the players' paddles.
3. When the ball makes contact with a player's paddle, it **MAY** trigger a random side effect.
4. The side effects can be either a positive effect on self, or a negative effect on the opponent.
5. The side effects are selected at random and cannot be chosen by the players.
6. All side effects are reset at the **END** of a game only.
7. It is not necessary that a side effect is triggered on every collision, gameplay may also proceed normally without side effects.
8. Side effects can stack (for example, paddle size gets halved **AND** paddle movement controls get inverted).
9. A side effect will continue as long as a new side effect is not triggered, or the game has not ended.

The side effects (or power-ups, whatever you'd like to call them) are:
1. Your own paddle becomes larger, twice the original height.
2. The opponent's paddle becomes smaller, half the original height.
3. The opponent's paddle controls are inverted (up becomes down, down becomes up).
4. The opponent's paddle speed is halved.

## EXECUTION
*Note: Players can control the paddles using W and S keys for Player 1, and the up and down arrow keys for Player 2.*

First, I abstracted away the logic behind how the ball moves after colliding with a paddle into two separate functions to avoid cluttering up `love.update(dt)`.
```
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
```
Next, I used `math.random(0, 4)` to decide what side effect needed to be triggered. I stored this result in two variables, `deranged1` and `deranged2`,<br>to have better control over side effects that were to be triggered on self, and side effects that were to be triggered on the opponent.
### PADDLE SIZE EFFECTS
Here's the code snippet of how paddle size changes were decided from the perspective of Player 1:
```
if ball:collides(player1) then
    deranged1 = math.random(0, 4)
    -- normal play
    if deranged1 == 0 then
        player1CollisionBallMovement()
    -- player1 gets large paddle
    elseif deranged1 == 1 then
        player1.height = 40
        player1CollisionBallMovement()
    -- player2 gets small paddle
    elseif deranged1 == 2 then
        player2.height = 10
        player1CollisionBallMovement()
    -- these effects are programmed into the paddle movement
    -- section of the code
    else
        player1CollisionBallMovement()
    end
end
```
* If `deranged1` == 0, gameplay was normal with no side effects.
* If `deranged1` == 1, then Player 1's paddle would become twice as large.
* If `deranged1` == 2, Player 2's paddle would become half its original size.
* If `deranged1` == 3 or 4, gameplay with respect to paddle size remained unchanged. This was used to change paddle movement.

A similar block of code controlled side effects from the perspective of Player 2.

### PADDLE MOVEMENT EFFECTS
Here's how paddle movement effects were decided, from the perspective of Player 1:
```
-- player1's controls get inverted
if deranged2 == 3 then
    if love.keyboard.isDown('s') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('w') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end
-- player1's paddle speed is halved
elseif deranged2 == 4 then
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED / 2
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED / 2
    else
        player1.dy = 0
    end
-- player1's movements are normal
else
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end
end
```
Notice how paddle movement effects for Player 1 were decided using Player 2's `deranged 2 = math.random(0, 4)` values.
* If `deranged2` == 3, Player 1's paddle controls were inverted (up is down, down is up).
* If `deranged2` == 4, Player 1's paddle speed was halved.
* For all other values, Player 1's paddle movement was left unchanged.

A similar block of code controlled side effects from the perspective of Player 2.

## CONCLUSION
This was only the first version of the variant [Wrong](https://github.com/ItsVaibhavK/Pong-Variants.git). I think it would truly make the game *intense* if I were to add in the DEATH BALL element to [Wrong](https://github.com/ItsVaibhavK/Pong-Variants.git)<br>from my first variant, [Dong - Death Pong](https://github.com/ItsVaibhavK/Pong-Variants.git). Just *imagine*.

*Update! I did finally make the variant I was talking about. Check it out in the section below!*

# DEAD WRONG

There is not much to explain for this variant, it combines the concepts and rules I came up with when I created [Dong - Death Pong](https://github.com/ItsVaibhavK/Pong-Variants.git) and [Wrong](https://github.com/ItsVaibhavK/Pong-Variants.git) (hence the name, [DEAD WRONG](https://github.com/ItsVaibhavK/Pong-Variants.git)).

To understand how [DEAD WRONG](https://github.com/ItsVaibhavK/Pong-Variants.git) works, you can read up on the mechanics that I've detailed above in the first two [Pong](https://en.wikipedia.org/wiki/Pong) variants I created.

The only change I made has to do with the DEATH BALL's appearance. I set its color to red using `love.graphics.setColor(1, 0, 0, 1)`,<br>and instead of it being an *outline* like it was in [Dong - Death Pong](https://github.com/ItsVaibhavK/Pong-Variants.git), I turned it into a *filled-out* ball using<br>`love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)`.<br>These changes are visible in the `Death.lua` file.

Now, *this* is a *frustratingly* fun game to mess about on!


# NOTES
The files for the variants do not contain comments explaining what the rest of the code is doing, only comments pointing out the parts I had added for my idea.<br>This is by design, to keep the code as neat as possible. If you're interested in the fully commented version of the code, or if you'd like to watch the lecture<br>that explains the original base code in depth, allow me to point you in the right direction:<br>
1. [Pong code with comments](https://github.com/ItsVaibhavK/CS50G-2023/blob/main/pong/main.lua)
2. [Lecture](https://cs50.harvard.edu/games/2018/weeks/0/)

# CREDITS
As always, I cannot begin to express my gratitude for the people behind all the [CS50](https://pll.harvard.edu/course/cs50-introduction-computer-science) courses.<br>In less than a year, I have gone from knowing nothing about programming to being able to write my own programs, web apps, create my own databases, and now - GAMES!

Thank you, [Colton Ogden](https://www.linkedin.com/in/colton-ogden-0514029b), for taking us through this course, and all the staff members at [CS50](https://pll.harvard.edu/course/cs50-introduction-computer-science), for instilling the love of programming in us!
