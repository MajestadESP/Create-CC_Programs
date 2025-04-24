-- Variables de configuración --
local configFile = "conf.ini"
local config = {}
local workFile = "work.ini"
local start = 512
local stop = 256
local xp
local yp
local out
local inp
local dir
local con
local pul
local xi
local yi
local homx
local homy
local homz
local head
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
local function PosX(int, bol)
    for i = 1, int, 1 do
        if bol == true then
            rs.setBundledOutput(out, colors.combine(pul))
            sleep(1.5)
            rs.setBundledOutput(out, 0)
            sleep(2.5)
        else
            rs.setBundledOutput(out, colors.combine(dir, pul))
            sleep(1.5)
            rs.setBundledOutput(out, 0)
            sleep(2.5)
        end
    end
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
local function PosY(int, bol)
    for i = 1, int, 1 do
        if bol == true then
            rs.setBundledOutput(out, colors.combine(colors.combine(dir, pul, xi)))
            sleep(1.5)
            rs.setBundledOutput(out, 0)
            sleep(2.5)
        else
            rs.setBundledOutput(out, colors.combine(colors.combine(pul, xi)))
            sleep(1.5)
            rs.setBundledOutput(out, 0)
            sleep(2.5)
        end
    end
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
    until rs.getBundledInput(inp) == head or rs.getBundledInput(inp) == head + homy or rs.getBundledInput(inp) == head + homy + homx or rs.getBundledInput(inp) == head + homx
    rs.setBundledOutput(out, 0)
end
local function Rwz()
    rs.setBundledOutput(out, colors.combine(yi, xi, con, dir))
    sleep(1)
    repeat
        sleep(1)
    until homx + homy + homz + head == rs.getBundledInput(inp) or homy + homz + head == rs.getBundledInput(inp) or homz + head == rs.getBundledInput(inp) or homx + homz + head == rs.getBundledInput(inp)
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
local function Mov1(var1, var2)
    PosX(var1, true)
    PosY(var2, true)
    Fwz()
end
-- Fin movimientos compuestos --
-- Funciones internas --
local function loadConfig()
    if fs.exists(configFile) then
        local file = fs.open(configFile, "r")
        for line in file.readLine and file.readLine or file.readLines and file.readLines or function() return nil end do
            local key, value = line:match("([^=]+)=([^=]+)")
            if key and value then
                config[key] = tonumber(value) or value
            end
        end
        file.close()
        inp = config.inp
        out = config.out
        dir = config.dir
        con = config.con
        pul = config.pul
        xi = config.xi
        yi = config.yi
        homx = config.homx
        homy = config.homy
        homz = config.homz
        head = config.head
    else
        print("El archivo de configuraci\xF3n no existe. Por favor, configure el programa usando la opci\xF3n 3 en el men\xF3A.")
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
    -- Load xp and yp from work.ini at the start of trabajo
    if fs.exists("work.ini") then
        local workFile = fs.open("work.ini", "r")
        for line in workFile.readLine and workFile.readLine or workFile.readLines and workFile.readLines or function() return nil end do
            local key, value = line:match("([^=]+)=([^=]+)")
            if key == "x" then
                xp = tonumber(value)
            elseif key == "y" then
                yp = tonumber(value)
            end
        end
        workFile.close()
    end

    term.clear()  -- Clear the screen
    term.setCursorPos(1, 1)  -- Set cursor position to the top left corner
    print("Iniciando trabajo...") -- Welcome message
    PosAll()
    Home(Pos[0], Pos[1], Pos[2])
    repeat
        print(xp, yp)
        Mov1(xp, yp)
        PosAll()
        Home(Pos[0], Pos[1], Pos[2])
        repeat
        sleep(1)
        until rs.getBundledInput('top') > 1
        if yp <= 0 then
            xp = xp - 1
            yp = 5
            -- Save updated xp and yp to work.ini
            local workFile = fs.open("work.ini", "w")
            workFile.writeLine("x=" .. tostring(xp))
            workFile.writeLine("y=" .. tostring(yp))
            workFile.close()
        else
            yp = yp - 1
            -- Save updated xp and yp to work.ini
            local workFile = fs.open("work.ini", "w")
            workFile.writeLine("x=" .. tostring(xp))
            workFile.writeLine("y=" .. tostring(yp))
            workFile.close()
        end
    until xp <= 0 and yp <= 0
    print("Trabajo terminado...")
end
local function checkWork()
    if fs.exists(workFile) then
        local fileHandle = fs.open(workFile, "r")
        local newX, newY
        local line = fileHandle.readLine()
        while line do
            local key, value = line:match("([^=]+)=([^=]+)")
            if key == "x" then
                newX = tonumber(value)
            elseif key == "y" then
                newY = tonumber(value)
            end
            line = fileHandle.readLine()
        end
        fileHandle.close()

        if newX and newY then
            xp = newX
            yp = newY
        end
        print("El trabajo anterior no se ha completado. \xBFDesea continuar? (s/n)")
        local response = read()
        if response:lower() ~= "s" then
            print("\xBFDesea iniciar un trabajo nuevo? (s/n)")
            local newResponse = read()
            if newResponse:lower() == "s" then
                print("Iniciando nuevo trabajo...")  -- Placeholder for starting a new job
                -- Ask user for new coordinates X and Y and save to work.ini
                print("Ingrese la nueva coordenada X:")
                local newX = tonumber(read())
                print("Ingrese la nueva coordenada Y:")
                local newY = tonumber(read())

                local fileHandle = fs.open(workFile, "w")
                fileHandle.writeLine("x=" .. tostring(newX))
                fileHandle.writeLine("y=" .. tostring(newY))
                fileHandle.close()
                print("Coordenadas guardadas en work.ini")
                -- Here you would reset the work state or delete the work file if needed
                -- fs.delete(workFile)  -- Commented out to keep the file after saving
            else
                print("Saliendo del programa...")  -- Exit message
            end
            return
        else
            print("Continuando con el trabajo anterior...")
        end
    else
        print("No hay trabajo anterior guardado.")
        print("Iniciando nuevo trabajo...")  -- Placeholder for starting a new job
        -- Ask user for new coordinates X and Y and save to work.ini
        print("Ingrese la nueva coordenada X:")
        local newX = tonumber(read())
        print("Ingrese la nueva coordenada Y:")
        local newY = tonumber(read())

        local fileHandle = fs.open(workFile, "w")
        fileHandle.writeLine("x=" .. tostring(newX))
        fileHandle.writeLine("y=" .. tostring(newY))
        fileHandle.close()
        print("Coordenadas guardadas en work.ini")
    end
end
local function createConf()
    print("Creando configuraci\xF3n...")
        print("Ingrese el color de direcci\xF3n:")
        local a1 = read()
        if Color[a1] then
            config.dir = Color[a1]
        else
            print("Color no encontrado.")
        end

        print("Ingrese el color de pulsos:")
        a1 = read()
        if Color[a1] then
            config.pul = Color[a1]
        else
            print("Color no encontrado.")
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
        local c1 = read()
        if Cara[c1] then
            config.out = Cara[c1]
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
        c1 = read()
        if Cara[c1] then
            config.inp = Cara[c1]
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
        print("Configuraci\xF3n guardada en " .. configFile)
        sleep(2)  -- Wait for a moment before returning to the menu
end
local function iniciar()
    print("Configuraci\xF3n inicial. Por favor, configure el programa.")
    sleep(2)  -- Wait for a moment before exiting
    print("Instrucciones:")
    print("1. Ingrese los colores de las conexiones y la cara de salida.")
    print("2. Confirme la carga de la configuraci\xF3n.")
    print("4. Movimientos de prueva.")
    print("5. Inicializar un trabajo. (opci\xF3n 2 en el men\xFA)")
    print(" ")
    print("NOTA: Despues del proceso de configuraci\xF3n, el programa se ejecutara unas coordenadas aleatorias para el correcto funcionamiento.")
    print("Presione Enter para continuar...")
    read()  -- Wait for user to press Enter
    term.clear()  -- Clear the screen
    term.setCursorPos(1, 1)  -- Set cursor position to the top left corner
    createConf()  -- Call function to create a new config file
    loadConfig()  -- Load the configuration
    xp = math.random(1, 10)  -- Random X coordinate
    yp = math.random(1, 10)  -- Random Y coordinate
    PosAll()  -- Get the current position
    Home(Pos[0], Pos[1], Pos[2])  -- Move to the home position
    Mov1(xp, yp)  -- Call function to move to the random coordinates
    print("Movimientos de prueba realizados.")
    print("Presione Enter para continuar...")
    read()  -- Wait for user to press Enter
end
-- Fin funciones internas --
-- Menus --
local function configuracion()
    term.clear()  -- Clear the screen
    term.setCursorPos(1, 1)  -- Set cursor position to the top left corner
    print("Configuraci\xF3n de la Quarry v1.0.") -- Welcome message
    print(" ") -- Empty line for spacing
    print("Por favor, seleccione una opci\xF3n:")
    print("1. Crear configuraci\xF3n")
    print("2. Modificar configuraci\xF3n")
    print("3. Cargar configuraci\xF3n")
    print("4. Salir")
    print(" ")
    local choice = read()  -- Get user input
    if choice == "1" then
        fs.delete("conf.ini")  -- Delete existing config file if it exists
        createConf()  -- Call function to create a new config file
        configuracion()  -- Call configuration function again to allow for changes
    elseif choice == "2" then
        print("Cargando valores...")
        local file = fs.open(configFile, "r")
        for line in file.readLine and file.readLine or file.readLines and file.readLines or function() return nil end do
            local key, value = line:match("([^=]+)=([^=]+)")
            if key and value then
                config[key] = tonumber(value) or value
            end
        end
        file.close()
        -- Prompt user to change a specific option
        print("Opciones de configuraci\xF3n disponibles:")
        for key in pairs(config) do
            print(key .. ": " .. tostring(config[key]))
        end
        print("Ingrese el nombre de la opci\xF3n que desea cambiar:")
        local option = read()
        if config[option] ~= nil then
            print("Ingrese el nuevo valor para " .. option .. ":")
            local newValue = read()
            -- Check if the option is a color key
            if Color[newValue] then
                config[option] = Color[newValue]
            elseif Cara[newValue] then
                config[option] = Cara[newValue]
            else
                -- Try to convert to number, else keep as string
                config[option] = tonumber(newValue) or newValue
            end
            -- Save the updated configuration
            local file = fs.open(configFile, "w")
            for key, value in pairs(config) do
                file.writeLine(key .. "=" .. tostring(value))
            end
            file.close()
            print("Configuraci\xF3n actualizada en " .. configFile)
            print("Volviedo atras...")
            sleep(2)  -- Wait for a moment before returning to the menu
            configuracion()  -- Call configuration function again to allow for changes
        else
            print("Volviendo atras...")
            sleep(2)  -- Wait for a moment before returning to the menu
            configuracion()  -- Call configuration function again to allow for changes
        end
    elseif choice == "3" then
        print("Cargando la configuraci\xF3n...")
        sleep(2)  -- Wait for a moment before returning to the menu
        loadConfig()  -- Load the configuration
        print("Configuraci\xF3n cargada.")
        configuracion()  -- Return to the configuration menu
    elseif choice == "4" then
        print("Saliendo de la configuraci\xF3n...")
        sleep(2)  -- Wait for a moment before returning to the menu
        return  -- Exit the configuration menu
    else
        print("Opci\xF3n no válida, por favor intente de nuevo.")
        sleep(2)  -- Wait for a moment before returning to the menu
        configuracion()  -- Call configuration function again to allow for changes
    end
end
local function menu()
    loadConfig()
    while true do
        term.clear()  -- Clear the screen
        term.setCursorPos(1, 1)  -- Set cursor position to the top left corner
        print("Men\xFA de control de la Quarry v1.0.") -- Welcome message
        print(" ") -- Empty line for spacing
        print("Por favor, seleccione una opci\xF3n:")
        print("1. Estado trabajo anterior")
        print("2. Iniciar Trabajo")
        print("3. Configuraci\xF3n")
        print("4. Salir")
        print(" ")
        local choice = read()  -- Get user input
        if choice == "1" then
            print("Estado trabajo anterior: No implementado a\xFAn.") -- Inform user that status check is not implemented
            print("Funcionalidad de estado en desarrollo.") -- Placeholder for future implementation
            read()  -- Wait for user to press Enter
        elseif choice == "2" then
            checkWork()  -- Check if a previous job exists
            trabajo()  -- Start work
        elseif choice == "3" then
            print("Accediendo a la configuraci\xF3n.")  -- Placeholder for configuration
            sleep(2)  -- Wait for a moment before entering configuration
            configuracion()  -- Call configuration function
        elseif choice == "4" then
            print("Saliendo...")
            break  -- Exit the loop
        else
            print("Opci\xF3n no válida, por favor intente de nuevo.")
        end
    end
end
-- Fin Menus --
-- Assign config variables after loading configuration
loadConfig()
inp = config.inp
out = config.out
dir = config.dir
con = config.con
pul = config.pul
xi = config.xi
yi = config.yi
homx = config.homx
homy = config.homy
homz = config.homz
head = config.head
-- End of debug area --
-- Programa Principal no modificar nada de aqui para abajo --
-- Inicia el programa principal --
if fs.exists(configFile) == false then
    print(fs.exists(configFile))  -- Check if the config file exists
    sleep(5)  -- Wait for a moment before proceeding
    iniciar()  -- Load the configuration if it exists
    menu()
else
    menu()  -- Call function to create a new config file if it doesn't exist
end
-- Fin del programa principal --
