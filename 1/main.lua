-- Variables de configuración --
local start = 512
local stop = 256
local out = "back"
local inp = "right"
local xp = 5
local yp = 5
local dir = 1
local con = 2
local pul = 4
local xi = 8
local yi = 16
local homx = 1
local homy = 2
local homz = 4
local head = 8
Pos = { true, true, true }
local Color = {
    blanco = 1,
    naranja = 2,
    magenta = 4,
    azulclaro = 8,
    amarillo = 16,
    lima = 32,
    rosa = 64,
    gris = 128,
    grisclaro = 256,
    cian = 512,
    violeta = 1024,
    azul = 2048,
    marron = 4096,
    verde = 8192,
    rojo = 16384,
    negro = 32768
}
local Cara = {
    arriba = "top",
    abajo = "bottom",
    izquierda = "left",
    derecha = "right",
    delante = "front",
    atras = "back"
}

  -- Movimientos eje X --
local function Fwxp() -- Adelante eje X por pulsos --
    rs.setBundledOutput(out, colors.combine(pul))
    sleep(1.5)
    rs.setBundledOutput(out, 0)
    sleep(2.5)
end
local function Rwxc()
    rs.setBundledOutput(out, colors.combine(dir, con))
    repeat
        sleep(1)
    until (homx + homy + homz + head) == rs.getBundledInput(inp)
    rs.setBundledOutput(out, 0)
end
-- Fin movimientos eje X --

-- Movimientos eje Y --
local function Fwyp()
    rs.setBundledOutput(out, colors.combine(colors.combine(dir, pul, xi)))
    sleep(1.5)
    rs.setBundledOutput(out, 0)
    sleep(2.5)
end
local function Rwyc()
    rs.setBundledOutput(out, colors.combine(xi, con))
    repeat
        sleep(1)
    until homx + homy + homz + head == rs.getBundledInput(inp) or homy + homz + head == rs.getBundledInput(inp)
    rs.setBundledOutput(out, 0)
end
-- Fin movimientos eje Y --

-- Movimientos eje Z --
local function Fwz()
    rs.setBundledOutput(out, colors.combine(yi, xi, con))
    sleep(1)
    repeat
        sleep(1)
    until rs.getBundledInput(inp) == head or rs.getBundledInput(inp) == head + homy or rs.getBundledInput(inp) == head + homy + homx
    rs.setBundledOutput(out, 0)
end
local function Rwz()
    rs.setBundledOutput(out, colors.combine(yi, xi, con, dir))
    sleep(1)
    repeat
        sleep(1)
    until homx + homy + homz + head == rs.getBundledInput(inp) or homy + homz + head == rs.getBundledInput(inp) or homz + head == rs.getBundledInput(inp)
    rs.setBundledOutput(out, 0)
end
-- Fin movimientos eje Z --

-- Movimientos compuestos --
local function Home(x, y, z)
    if x == false and y == false and z == true then
        Rwz()
    elseif (x == false and y == true and z == false) then
        Rwyc()
    elseif (x == true and y == false and z == false) then
        Rwxc()
    elseif (x == false and y == true and z == true) then
        Rwz()
        Rwyc()
    elseif (x == true and y == false and z == true) then
        Rwz()
        Rwxc()
    elseif (x == true and y == true and z == false) then
        Rwyc()
        Rwxc()
    elseif (x == true and y == true and z == true) then
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
            --Rwxp()
        end
    end
end

local function PosY(int, bol)
    for i = 1, int, 1 do
        if bol == true then
            Fwyp()
        else
            --Rwyp()
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
local function configuracion()
    local configFile = "conf.ini"
    local config = {}

    -- Check if the configuration file exists
    if not fs.exists(configFile) then
        -- Create the configuration file and prompt for values
        print("El archivo de configuración no existe. Creando uno nuevo...")

        print("Ingrese el color de dirección:")
        a1 = read()
        if Color[a1] then
            config.dir = Color[a1]
        else
            print("Color no encontrado.")
        end

        print("Ingrese el color de pulsos:")
        a1 = read()
        if Color[a1] then
            config.dir = Color[a1]
        else
            print("Color no encontrado.")
        end
        config.pul = tonumber(read())

        print("Ingrese el color de continuo:")
        a1 = read()
        if Color[a1] then
            config.dir = Color[a1]
        else
            print("Color no encontrado.")
        end
        config.con = tonumber(read())

        print("Ingrese el color de dirección:")
        local a1 = read()
        if Color[a1] then
            config.dir = Color[a1]
        else
            print("Color no encontrado.")
            return
        end

        print("Ingrese el color de pulsos:")
        a1 = read()
        if Color[a1] then
            config.pul = Color[a1]
        else
            print("Color no encontrado.")
            return
        end

        print("Ingrese el color de continuo:")
        a1 = read()
        if Color[a1] then
            config.con = Color[a1]
        else
            print("Color no encontrado.")
            return
        end

        print("Ingrese el color del bloqueo de eje X:")
        a1 = read()
        if Color[a1] then
            config.xi = Color[a1]
        else
            print("Color no encontrado.")
            return
        end

        print("Ingrese el color del bloqueo de eje Y:")
        a1 = read()
        if Color[a1] then
            config.yi = Color[a1]
        else
            print("Color no encontrado.")
            return
        end

        print("Ingrese la cara donde estarán conectadas las salidas:")
        a1 = read()
        if Cara[a1] then
            config.out = Cara[a1]
        else
            print("Cara no disponible.")
            return
        end

        print("Ingrese el color de HomeX:")
        a1 = read()
        if Color[a1] then
            config.homx = Color[a1]
        else
            print("Color no encontrado.")
            return
        end

        print("Ingrese el color de HomeY:")
        a1 = read()
        if Color[a1] then
            config.homy = Color[a1]
        else
            print("Color no encontrado.")
            return
        end

        print("Ingrese el color de HomeZ:")
        a1 = read()
        if Color[a1] then
            config.homz = Color[a1]
        else
            print("Color no encontrado.")
            return
        end

        print("Ingrese el color de la Herramienta:")
        a1 = read()
        if Color[a1] then
            config.head = Color[a1]
        else
            print("Color no encontrado.")
            return
        end

        print("Ingrese la cara donde estarán conectadas las entradas:")
        a1 = read()
        if Cara[a1] then
            config.inp = Cara[a1]
        else
            print("Cara no disponible.")
            return
        end

        -- Save the configuration to the file
        local file = fs.open(configFile, "w")
        for key, value in pairs(config) do
            file.writeLine(key .. "=" .. tostring(value))
        end
        file.close()
        print("Configuración guardada en " .. configFile)
    else
        -- Read existing configuration
        print("El archivo de configuración ya existe. Cargando valores...")
        local file = fs.open(configFile, "r")
        for line in file.readLines() do
            local key, value = line:match("([^=]+)=([^=]+)")
            if key and value then
                config[key] = tonumber(value) or value
            end
        end
        file.close()

        -- Prompt user to change a specific option
        print("Opciones de configuración disponibles:")
        for key in pairs(config) do
            print(key .. ": " .. tostring(config[key]))
        end

        print("Ingrese el nombre de la opción que desea cambiar:")
        local option = read()
        if config[option] ~= nil then
            print("Ingrese el nuevo valor para " .. option .. ":")
            config[option] = tonumber(read()) or read()

            -- Save the updated configuration
            local file = fs.open(configFile, "w")
            for key, value in pairs(config) do
                file.writeLine(key .. "=" .. tostring(value))
            end
            file.close()
            print("Configuración actualizada en " .. configFile)
        else
            print("Opción no válida.")
        end
    end
end

local function PosAll()
    if rs.getBundledInput(inp) - 8 == (homx + homy) then
        Pos[0] = false
        Pos[1] = false
        Pos[2] = true
    else
        if rs.getBundledInput(inp) - 8 == homx then         -- solo eje Y
            Pos[0] = false
            Pos[1] = true
            Pos[2] = true
        elseif rs.getBundledInput(inp) - 8 == homy then     -- solo eje X
            Pos[0] = true
            Pos[1] = false
            Pos[2] = true
        else                                                -- los 3 ejes
            Pos[0] = true
            Pos[1] = true
            Pos[2] = true
        end
    end
end

local function trabajo()
    PosAll()
    Home(Pos[0], Pos[1], Pos[2])
    repeat
        print(xp, yp)
        Mov1(xp, yp)
        PosAll()
        Home(Pos[0], Pos[1], Pos[2])
        repeat
        sleep(1)
        until rs.getBundledInput("top") > 0
        if yp == 0 then
            xp = xp - 1
            yp = 5
        else
            yp = yp - 1
        end
    until xp == 0
end
-- Fin funciones internas --

-- Inicio Menu --

local function menu()
    while true do
        print("1. Estado trabajo aterior")
        print("2. Iniciar Trabajo")
        print("3. Configuración")
        print("4. Salir")
        local choice = read()  -- Get user input

        if choice == "1" then
            print("Estado trabajo aterior: [Implement status check here]") -- Placeholder for status check
        elseif choice == "2" then
            trabajo()  -- Start work
        elseif choice == "3" then
            print("Accediendo a la configuración.")  -- Placeholder for configuration
            configuracion()  -- Call configuration function
        elseif choice == "4" then
            print("Saliendo...")
            break  -- Exit the loop
        else
            print("Opción no válida, por favor intente de nuevo.")
        end
    end
end

-- Debug area --