local dir = 1
local con = 2
local pul = 4
local x = 8
local y = 16
local homx = 32
local homy = 64
local homz = 128
local out = "back"
local inp = "right"

-- Movimientos eje X --
function fwxc()
    rs.setBundledOutput(out, 0)
    os.sleep(5)
    repeat
        os.sleep(1)
    until rs.getBundledInput(inp) == 224
    rs.setBundledOutput(out, colors.subtract(con))
end
function fwxp()
    rs.setBundledOutput(out, colors.subtract(colors.combine(con, pul)))
    os.sleep(0.5)
    rs.setBundledOutput(out, colors.subtract(con))
end
function rwxc()
    rs.setBundledOutput(out, dir)
    os.sleep(5)
    repeat
        os.sleep(1)
    until rs.getBundledInput(inp) == 224
    rs.setBundledOutput(out, colors.subtract(con))
end
function rwxp()
    rs.setBundledOutput(out, colors.subtract(colors.combine(con, dir, pul)))
    os.sleep(0.5)
    rs.setBundledOutput(out, colors.subtract(colors.combine(con, dir)))
end
-- Fin movimientos eje X --
-- Movimientos eje Y --
function fwyc()
    rs.setBundledOutput(out, x)
    os.sleep(5)
    repeat
        os.sleep(1)
    until rs.getBundledInput(inp) == 224
    rs.setBundledOutput(out, colors.subtract(con))
end
function fwyp()
    rs.setBundledOutput(out, colors.subtract(colors.combine(con, pul, x)))
    os.sleep(0.5)
    rs.setBundledOutput(out, colors.subtract(colors.combine(con, x)))
end
function rwyc()
    rs.setBundledOutput(out, colors.combine(dir, x))
    os.sleep(5)
    repeat
        os.sleep(1)
    until rs.getBundledInput(inp) == 224
    rs.setBundledOutput(out, colors.subtract(con))
end
function rwyp()
    rs.setBundledOutput(out, colors.subtract(colors.combine(con, dir, pul, x)))
    os.sleep(0.5)
    rs.setBundledOutput(out, colors.subtract(colors.combine(con, dir, x)))
end
-- Fin movimientos eje Y --
-- Movimientos eje Z --
function fwz()
    rs.setBundledOutput(out, colors.combine(y, x, dir))
    os.sleep(5)
    rs.setBundledOutput(out, colors.subtract(con))
end
function rwz()
    rs.setBundledOutput(out, colors.combine(y, x))
    repeat
        os.sleep(1)
    until rs.getBundledInput(inp) == 224
    rs.setBundledOutput(out, colors.subtract(con))
end
-- Fin movimientos eje Z --
-- Debug area --
--os.sleep(10)
--fwxc()
--os.sleep(10)
--fwyc()
--os.sleep(10)
--fwz()
os.sleep(10)
rwz()
os.sleep(10)
rwyc()
os.sleep(10)
rwxc()
