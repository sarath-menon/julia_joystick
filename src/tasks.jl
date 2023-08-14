

# function joystick_read()

@async begin

    while (joystick_read_toggle.active[])

        # get axis values
        axis_vals = GLFW.GetJoystickAxes(js.device)
        axis_obs[] = Point2f(axis_vals[1], -axis_vals[2])

        sleep(0.01)
    end

    println("Joystick disabled")
end

# end

on(joystick_read_toggle.active) do state
    if state == true
        joystick_read()
    end

end