:-ensure_loaded('RTXengine/RTXengine.pl').
:-ensure_loaded('RTXengine/RTXutil.pl').

defrule gotox_right
    if goto_x(Xf) and x_is_at(Xi) and (Xi<Xf) and x_moving(0) and y_is_at(2) and y_moving(0)
    then [
        assert_once( action(move_x_right))
    ].

defrule gotox_left
    if goto_x(Xf) and x_is_at(Xi) and (Xi>Xf) and x_moving(0) and y_is_at(2) and y_moving(0)
    then [
        assert_once( action(move_x_left))
    ].

defrule gotox_finish
    if goto_x(Xf) and x_is_at(Xf)
    then [
        assert_once( action(stop_x)),
        retract(goto_x(Xf))
    ].