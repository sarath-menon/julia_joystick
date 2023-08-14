using Joysticks
using GLMakie
using Makie
using GLFW

GLMakie.activate!(inline=false)

## 

# Plotting
fig = Figure()

# grid layouts
g_plot = fig[1, 1] = GridLayout()
g_ui = fig[2, 1] = GridLayout()

ax = Axis(g_plot[1, 1], xlabel="x label", ylabel="y label",
    title="Title")

# add buttons
start_read_btn = Button(g_ui[1, 1], label="start reading", tellwidth=false)
# stop_read_btn = Button(g_ui[1, 2], label="stop reading", tellwidth=false)

joystick_plot_toggle = Toggle(fig, active=false, height=30, width=80)
label = Label(fig, lift(x -> x ? "Joytick enabled" : "Joytick disabled", joystick_read_toggle.active))

g_ui[1, 2] = grid!(hcat(joystick_plot_toggle, label), tellwidth=false, tellheight=false)

##

# joystick
const js = open_joystick()
const jsaxes = JSState()
const jsbuttons = JSButtonState()

# async_read!(js, jsaxes, jsbuttons)

# println(jsaxes)

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


## joystick axes Plotting
axis_obs = Observable(Point2f(0.0, 0.0))

scatter!(ax, axis_obs, markersize=50, color=:black)

axis_obs[] = Point2f(0.0, 0.0)



