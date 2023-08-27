module Joystick

using GLFW
using GLMakie
GLMakie.activate!(inline=false)

export JSDevice, JoystickState
export connect_joystick, get_joystick_state, joystick_plot, show
export create_visualizer

struct JSDevice1
    name::String
    device::GLFW.Joystick
    axis_count::Int32
    button_count::Int32

    JSDevice1(name; device, axis_count, button_count) = new(name, device, axis_count, button_count)
end

JSDevice = JSDevice1

struct JoystickState1
    horizontal_axis::Float64
    vertical_axis::Float64
    stick_rotate_axis::Float64
    knob_rotate_axis::Float64

    buttons::Vector{UInt8}

    JoystickState1(; horizontal_ax, vertical_ax, stick_rotate_ax, knob_rotate_ax, buttons) = new(horizontal_ax, vertical_ax, stick_rotate_ax, knob_rotate_ax, buttons)
end

JoystickState = JoystickState1


function connect_joystick(device=GLFW.JOYSTICK_1)
    if GLFW.JoystickPresent(device) == false
        println("Joytick not connected !")
    else
        axis_count = length(GLFW.GetJoystickAxes(device))
        button_count = length(GLFW.GetJoystickButtons(device))

        joystick = JSDevice1("logitech_flight_stick"; device=device, axis_count=axis_count, button_count=button_count)

        return joystick

    end
end

function get_joystick_state(js)
    # get axis values

    axis_vals = GLFW.GetJoystickAxes(js.device)
    buttons_state_uint8 = GLFW.GetJoystickButtons(js.device)

    vertical_ax_val = -axis_vals[2]
    horizontal_ax_val = axis_vals[1]

    stick_rotate_ax_val = -axis_vals[3]
    knob_rotate_ax_val = -axis_vals[4]

    js_state = JoystickState(horizontal_ax=horizontal_ax_val, vertical_ax=vertical_ax_val, stick_rotate_ax=stick_rotate_ax_val,
        knob_rotate_ax=knob_rotate_ax_val, buttons=buttons_state_uint8)

    return js_state
end

function Base.show(js_state::JoystickState)

    println("Horizontal axis: ", js_state.horizontal_axis)
    println("Vertical axis: ", js_state.vertical_axis)
    println("Stick rotate axis: ", js_state.stick_rotate_axis)
    println("Knob rotate axis: ", js_state.knob_rotate_axis)

end

function create_visualizer()
    # Plotting
    fig = Figure()
    display(fig)

    # grid layouts
    g_plot = fig[1, 1] = GridLayout()
    g_ui = fig[2, 1] = GridLayout()

    ax = Axis(g_plot[1, 1], xlabel="x label",
        title="Title")

    ax2 = Axis(g_plot[1, 2], xlabel="x label", xgridvisible=false, ygridvisible=false,
        title="Throttle")

    ax3 = Axis(g_plot[1, 3], xlabel="x label", xgridvisible=false, ygridvisible=false,
        title="yaw_val")

    # add buttons
    start_vis_btn = Button(g_ui[1, 1], label="Start Visualization", tellwidth=false)
    #stop_read_btn = Button(g_ui[1, 2], label="stop reading", tellwidth=false)

    joystick_plot_toggle = Toggle(fig, active=false, height=30, width=80)
    label = Label(fig, lift(x -> x ? "Joytick enabled" : "Joytick disabled", joystick_plot_toggle.active))

    g_ui[1, 2] = grid!(hcat(joystick_plot_toggle, label), tellwidth=false, tellheight=false)

    # axes size adjust 
    rowsize!(g_ui, 1, Auto(0.1))

    colsize!(g_plot, 2, Auto(0.1))
    colsize!(g_plot, 3, Auto(0.1))

    ## initial joystick axes Plotting
    horizontal_vertical_obs = Observable(Point2f(0.0, 0.0))
    stick_rotate_obs = Observable(Point2f(5.0, 0.0))
    knob_rotate_obs = Observable(Point2f(5.0, 0.0))

    scatter!(ax, horizontal_vertical_obs, markersize=50, color=:black)
    scatter!(ax2, stick_rotate_obs, markersize=60, color=:black)
    scatter!(ax3, knob_rotate_obs, markersize=60, color=:black)

    plot_elements = Dict()

    plot_elements[:fig] = fig
    plot_elements[:joystick_plot_toggle] = joystick_plot_toggle
    plot_elements[:start_vis_btn] = start_vis_btn

    plot_data = (; horizontal_vertical=horizontal_vertical_obs, stick_rotate=stick_rotate_obs, knob_rotate=knob_rotate_obs)

    return plot_elements, plot_data
end


function joystick_plot(js, plot_elements, plot_data, vis_flag)

    joystick_plot_toggle = plot_elements[:joystick_plot_toggle]

    while (joystick_plot_toggle.active[] && vis_flag == true)

        # get axis values
        js_state = get_joystick_state(js)

        plot_data.horizontal_vertical[] = Point2f(js_state.horizontal_axis, js_state.vertical_axis)
        plot_data.stick_rotate[] = Point2f(5, js_state.stick_rotate_axis)
        plot_data.knob_rotate[] = Point2f(5, js_state.knob_rotate_axis)

        sleep(0.01)
    end

    println("Joystick disabled")
end


function start_visualization(js, plot_elements, plot_data)

    start_vis_btn = plot_elements[:start_vis_btn]
    joystick_plot_toggle = plot_elements[:joystick_plot_toggle]

    vis_flag = false

    on(start_vis_btn.clicks) do click

        # start visualization if not already running
        if vis_flag == false && joystick_plot_toggle.active[]

            println("Vis started")

            @async begin
                # set flag
                vis_flag = true

                joystick_plot(js, plot_elements, plot_data, vis_flag)
            end
        end

        # stop visulization if already running
        vis_flag = false
    end
end


end