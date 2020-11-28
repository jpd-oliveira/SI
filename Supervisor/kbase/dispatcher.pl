:-ensure_loaded('RTXengine/RTXengine.pl').
:-ensure_loaded('RTXengine/RTXutil.pl').

defrule gotox_right
    if goto_x(Xf) and x_is_at(Xi) and (Xi<Xf) and x_moving(0) and y_is_at(2) and  y_moving(0)
    then [
        assert_once( action(move_x_right))
    ].

defrule gotox_left
    if goto_x(Xf) and x_is_at(Xi) and (Xi>Xf) and x_moving(0) and  y_is_at(2) and y_moving(0)
    then [
        assert_once( action(move_x_left))
    ].

defrule gotox_finish
   if goto_x(Xf) and x_is_at(Xf)
   then[
       assert_once( action(stop_x)),
       retract(goto_x(Xf))
   ].

defrule gotoy_inside
   if goto_y(Yf) and y_is_at(Yi) and (Yi<Yf) and y_moving(0)
   then [
       assert_once( action(move_y_inside))
   ].

defrule gotoy_outside
   if goto_y(Yf) and y_is_at(Yi) and (Yi>Yf) and y_moving(0)
   then [
       assert_once( action(move_y_outside))
   ].

defrule gotoy_finish
   if goto_y(Yf) and y_is_at(Yf)
   then [
       assert_once( action(stop_y)),
       retract(goto_y(Yf))
   ].

defrule gotoz_up
   if goto_z(Zf) and z_is_at(Zi) and (Zi<Zf) and  z_moving(0)
   then [
       new_id(ID),
       Seq = [
               ( true,                    assert_once(action(move_z_up))),
               ( z_is_at(Zf)            , assert_once(action(stop_z))  )
             ],
       assert_once(sequence(ID, gotoz_up_seq,Seq)),
       retract(goto_z(Zf))
   ].

defrule gotoz_down
   if goto_z(Zf) and z_is_at(Zi) and (Zi>Zf) and  z_moving(0)
   then [
       new_id(ID),
       Seq = [
               ( true,                    assert(action(move_z_down))),
               ( z_is_at(Zf)            , assert(action(stop_z))  )
             ],
       assert_once(sequence(ID, gotoz_down_seq,Seq)),
       retract(goto_z(Zf))
   ].


defrule goto_xz
   if goto_xz(X,Z)
   then [
      assert_once(goto_x(X)),
      assert_once(goto_z(Z)), 
      retract(goto_xz(X,Z))   
   ].