using Joysticks, Observables
using GLMakie

const js = open_joystick()

const jsaxes = JSState()
const jsbuttons = JSButtonState()

async_read!(js, jsaxes)
async_read!(js, nothing, jsbuttons)

println(jsaxes)


on(jsbuttons.btn1) do val
    if val
        println("Button 1 pressed!")
    end
end


on(jsbuttons.btn2) do val
    if val
        println("Button 2 pressed!")
    end
end
on(jsbuttons.btn3) do val
    if val
        println("Button 3 pressed!")
    end
end
on(jsbuttons.btn4) do val
    if val
        println("Button 4 pressed!")
    end
end
on(jsbuttons.btn5) do val
    if val
        println("Button 5 pressed!")
    end
end
on(jsbuttons.btn6) do val
    if val
        println("Button 6 pressed!")
    end
end

on(jsbuttons.btn7) do val
    if val
        println("Button 7 pressed!")
    end
end

on(jsbuttons.btn8) do val
    if val
        println("Button 8 pressed!")
    end
end

on(jsbuttons.btn9) do val
    if val
        println("Button 9 pressed!")
    end
end

on(jsbuttons.btn10) do val
    if val
        println("Button 10 pressed!")
    end
end

on(jsbuttons.btn11) do val
    if val
        println("Button 11 pressed!")
    end
end

on(jsbuttons.btn12) do val
    if val
        println("Button 12 pressed!")
    end
end