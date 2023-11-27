# IDEA

I had been on a roll of completing [CS50](https://pll.harvard.edu/course/cs50-introduction-computer-science)'s courses on the [edX](https://www.edx.org/) platform, and had picked up skills<br>in a variety of programming concepts, languages and applications. That is when I came across [CS50G - CS50’s
Introduction to Game Development](https://cs50.harvard.edu/games/2018/).<br>Like a lot of people, I do enjoy gaming here and there, but I had never really thought of peeking behind the curtain of what made games run underneath the hood.<br>This course and its teachers absolutely BLEW my mind.

The first week of this course covered [Pong](https://en.wikipedia.org/wiki/Pong), the famous 1972 arcade game. We were introduced to [Lua](https://www.lua.org/) and [LÖVE](https://love2d.org/), and a whole host of concepts<br>that are important to game development. The first assignment tasked us with making either of the paddles, or both, a "computer-controlled" paddle.<br>Upon completing [this assignment](https://github.com/ItsVaibhavK/CS50G-2023/blob/main/pong/main.lua) successfully, I was left wanting... more. And so I decided I would tinker around with the game's base code that was provided to us<br>and make my own variants of [Pong](https://en.wikipedia.org/wiki/Pong).

My first attempt resulted in what you're looking at right now: `Dong - Death Pong`.

The idea was simple. Using what we had learned so far in the first week, I would introduce a second ball into the game. Since we hadn't learnt how to add colors to sprites,<br>I differentiated this second ball by turning it into an *outline* of a ball, instead of the regular filled-in ball. This ball was the DEATH BALL.

A regular game of [Pong](https://en.wikipedia.org/wiki/Pong) ends when a player gets to the target score first. Players score when their opponents miss the ball.<br>However, if a player made contact with the DEATH BALL, they would lose the game instantly via "sudden death."<br>Here's how I turned that logic into code.

# EXECUTION

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
And there it was! My first attempt at experimenting and modifying a game to execute my own ideas!<br>*What a RUSH.*

# NOTES
The `main.lua` and `Death.lua` files for `Dong` do not contain comments explaining what the rest of the code is doing, only comments pointing out the parts I had added for my idea.<br>This is by design, to keep the code as neat as possible. If you're interested in the fully commented version of the code, or if you'd like to watch the lecture<br>that explains the code in depth, allow me to point you in the right direction:<br>
1. [Pong code with comments](https://github.com/ItsVaibhavK/CS50G-2023/blob/main/pong/main.lua)
2. [Lecture](https://cs50.harvard.edu/games/2018/weeks/0/)

# CREDITS
As always, I cannot begin to express my gratitude for the people behind all the [CS50](https://pll.harvard.edu/course/cs50-introduction-computer-science) courses.<br>In less than a year, I have gone from knowing nothing about programming to being able to write my own programs, web apps, create my own databases, and now - GAMES!

Thank you, [Colton Ogden](https://www.linkedin.com/in/colton-ogden-0514029b), for taking us through this course, and all the staff members at [CS50](https://pll.harvard.edu/course/cs50-introduction-computer-science), for instilling the love of programming in us!
