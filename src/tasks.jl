
struct JoystickState3
    horizontal_axis::Float64
    vertical_axis::Float64
end

JoystickState = JoystickState3


function get_joystick_state(js)
    # get axis values
    axis_vals = GLFW.GetJoystickAxes(js.device)

    roll_val = axis_vals[1]
    pitch_val = -axis_vals[2]

    js_state = JoystickState(roll_val, pitch_val)

    return js_state
end

function joystick_plot(js, axis_obs)

    while (joystick_plot_toggle.active[])

        # get axis values
        # axis_vals = GLFW.GetJoystickAxes(js.device)
        js_state = get_joystick_state(js)

        axis_obs[] = Point2f(js_state.horizontal_axis, js_state.vertical_axis)

        sleep(0.01)
    end

    println("Joystick disabled")
end


function joystick_calibrate(js)

end



on(joystick_plot_toggle.active) do state
    if state == true
        @async begin
            joystick_plot(js, axis_obs)
        end
    end

end