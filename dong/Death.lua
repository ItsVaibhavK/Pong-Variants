Death = Class{}

function Death:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
    self.dx = 0
end


function Death:collides(paddle)
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end 

    return true
end


function Death:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = 0
    self.dy = 0
end


function Death:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end


function Death:render()
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end