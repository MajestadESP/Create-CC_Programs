local start = 512
local stop = 256
local out = "back"
local inp = "right"
local xp = 10
local yp = 10
local dir = 1
local con = 2
local pul = 4
local xi = 8
local yi = 16
local homx = 32
local homy = 64
local homz = 128
Pos = {true, true, true}
--local cin = 1024
--[[local function setBundledOutput(side, colour, on)
    if on then
      rs.setBundledOutput(side, colors.combine(colour, rs.getBundledOutput(side)))
    else
      rs.setBundledOutput(side, colors.subtract(colour, rs.getBundledOutput(side)))
    end
  end]]
-- Movimientos eje X --
local function Fwxp()
    rs.setBundledOutput(out, colors.subtract(colors.combine(con, pul)))
    sleep(0.5)
    rs.setBundledOutput(out, colors.subtract(con))
    sleep(2.5)
end
local function Rwxc()
    rs.setBundledOutput(out, dir)
    repeat
        sleep(1)
    until homx+homy+homz == rs.getBundledInput(inp)
    rs.setBundledOutput(out, colors.subtract(con))
end
local function Rwxp()
    rs.setBundledOutput(out, colors.subtract(colors.combine(con, dir, pul)))
    sleep(0.5)
    rs.setBundledOutput(out, colors.subtract(colors.combine(con, dir)))
    sleep(2.5)
end
-- Fin movimientos eje X --
-- Movimientos eje Y --
local function Fwyp()
    rs.setBundledOutput(out, colors.subtract(colors.combine(con, pul, xi)))
    sleep(0.5)
    rs.setBundledOutput(out, colors.subtract(colors.combine(con, xi)))
    sleep(2.5)
end
local function Rwyc()
    rs.setBundledOutput(out, colors.combine(dir, xi))
    repeat
        sleep(1)
    until homx+homy+homz == rs.getBundledInput(inp) or homy+homz == rs.getBundledInput(inp)
    rs.setBundledOutput(out, colors.subtract(con))
end
local function Rwyp()
    rs.setBundledOutput(out, colors.subtract(colors.combine(con, dir, pul, xi)))
    sleep(0.5)
    rs.setBundledOutput(out, colors.subtract(colors.combine(con, dir, xi)))
    sleep(2.5)
end
-- Fin movimientos eje Y --
-- Movimientos eje Z --
local function Fwz()
    rs.setBundledOutput(out, colors.subtract(colors.combine(yi, xi, dir)))
    sleep(1)
    repeat
        sleep(1)
    until rs.getBundledInput(inp) == homz or rs.getBundledInput(inp) == homz+homy or rs.getBundledInput(inp) == homz+homy+homx
    rs.setBundledOutput(out, colors.subtract(con))
end
local function Rwz()
    rs.setBundledOutput(out, colors.subtract(colors.combine(yi, xi)))
    sleep(1)
    repeat
        sleep(1)
    until homx+homy+homz == rs.getBundledInput(inp) or homy+homz == rs.getBundledInput(inp) or homz == rs.getBundledInput(inp)
    rs.setBundledOutput(out, colors.subtract(con))
end
-- Fin movimientos eje Z --
-- Movimientos de la cinta de transporte --
-- WIP--
-- Fin movimientos de la cinta de transporte --
-- Movimientos compuestos --
local function Home(x, y, z)
    if x==false and y==false and z==true  then
        Rwz()
    elseif (x==false and y==true and z==false) then
        Rwyc()
    elseif (x==true and y==false and z==false) then
        Rwxc()
    elseif (x==false and y==true and z==true) then
        Rwz()
        Rwyc()
    elseif (x==true and y==false and z==true) then
        Rwz()
        Rwxc()
    elseif (x==true and y==true and z==false) then
        Rwyc()
        Rwxc()
    elseif (x==true and y==true and z==true) then
        Rwz()
        Rwyc()
        Rwxc()
    end
end
local function PosX(int, bol)
    for i = 1, int, 1 do
        if bol == true then
            Fwxp()
        else
            Rwxp()
        end
    end
end
local function PosY(int, bol)
    for i = 1, int, 1 do
        if bol == true then
            Fwyp()
        else
            Rwyp()
        end
    end
end
local function Mov1(var1, var2)
    PosX(var1, true)
    PosY(var2, true)
    Fwz()
end
-- Fin movimientos compuestos --
-- Funciones internas --
local function PosAll()
    if rs.getBundledInput(inp)-128 == (homx+homy) then
        Pos[0] = false
        Pos[1] = false
        Pos[2] = true
    else
        if rs.getBundledInput(inp)-128 == homx then -- solo eje Y
            Pos[0] = false
            Pos[1] = true
            Pos[2] = true
        elseif rs.getBundledInput(inp)-128 == homy then -- solo eje X
            Pos[0] = true
            Pos[1] = false
            Pos[2] = true
        else                    -- todos los ejes
            Pos[0] = true
            Pos[1] = true
            Pos[2] = true
        end
    end
end
-- Fin funciones internas --
--[[local ex
repeat

until ex > 99]]
-- Debug area --
print(homz+homy)
print(rs.getBundledInput(inp))
PosAll()
print(Pos[0],Pos[1],Pos[2])
Home(Pos[0],Pos[1],Pos[2])
repeat
        print(xp, yp)
        Mov1(xp,yp)
        PosAll()
        Home(Pos[0],Pos[1],Pos[2])
        sleep(30)
        if yp == 0 then
            xp = xp - 1
            yp = 10
        else
            yp = yp - 1
        end
until xp == 0
--[[PosAll()
Home(Pos[0],Pos[1],Pos[2])
Mov1(10,0)]]