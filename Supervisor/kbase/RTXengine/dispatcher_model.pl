
:-ensure_loaded('RTXengine').
:-ensure_loaded('RTXutil.pl').

/*
:- use_module('RTXengine').
:- use_module('RTXutil').
*/

defrule gotox_right
   if goto_x(Xf)  and x_is_at(Xi) and (Xi<Xf) and x_moving(0)
   then [
       assert( action(move_x_right))
   ].


defrule gotox_left
   if goto_x(Xf)  and x_is_at(Xi) and (Xi>Xf) and x_moving(0)
   then [
       assert( action(move_x_left))
   ].


defrule gotox_finish
   if goto_x(Xf) and x_is_at(Xf)
   then [
       assert( action(stop_x)),
       retract(goto_x(Xf))
   ].


defrule gotoz_up
     if goto_z(Zf) and z_is_at(Zi) and (Zi<Zf) and z_moving(0)
     then [
         new_id(ID),
         Seq = [
                 ( true,          assert(action(move_z_up))                          ),
                 ( z_is_at(Zf),   assert(action(stop_z)), retract_safe(goto_z(Zf))   )
               ],
         assert(sequence(ID, gotoz_up_seq,Seq))
     ].


defrule gotoz_down
     if goto_z(Zf) and z_is_at(Zi) and (Zi>Zf) and z_moving(0)
     then [
         new_id(ID),
         assert(sequence(ID, gotoz_down_seq,
                    [
                       ( true,         assert(action(move_z_down))       ),
                       ( z_is_at(Zf),  assert(action(stop_z))     )
                    ]))
     ].

defrule gotoz_finish
     if goto_z(Zf) and z_is_at(Zf)
     then [
         retract_safe(goto_z(Zf))
     ].


defrule goto_xz
    if  goto_xz(X,Z) and not(goto_x(_)) and not(goto_z(_)) %deixa fazer goto_xz(X,Z) simultaneaos
    then [
       assert_once(goto_x(X)),
       assert_once(goto_z(Z)),
       retract(goto_xz(X,Z))
    ].



/*
defrule rule_dance_square1
    if square_dance then [
       assert( goto_xz(1,1)),
       Quadrado = [
           (   ((x_is_at(1),z_is_at(1))), assert(goto_xz(4,1))      )  ,
           (   ((x_is_at(4),z_is_at(1))), assert(goto_xz(4,4))      )  ,
           (   ((x_is_at(4),z_is_at(4))), assert(goto_xz(1,4))      )  ,
           (   ((x_is_at(1),z_is_at(4))), assert(goto_xz(1,1))      )
       ],
       append(Quadrado, Quadrado,DancaDois),
       new_id(ID),
       assert( sequence(ID, square_dance_seq, DancaDois)),
       retract(dance_square_path)
    ].
*/

defrule rule_dance_square2
    if square_dance then [
       assert( goto_xz(1,1)),
       Quadrado = [
           (   (x_is_at(1),z_is_at(1)), assert(goto_xz(4,1))      )  ,
           (   (x_is_at(4),z_is_at(1)), assert(goto_xz(4,4))      )  ,
           (   (x_is_at(4),z_is_at(4)), assert(goto_xz(1,4))      )  ,
           (   (x_is_at(1),z_is_at(4)), assert(goto_xz(1,1))      )
       ],
       new_id(ID1),new_id(ID2),new_id(ID3),
       assert( sequence(ID1, square_dance_seq, [
                            ((x_is_at(1),z_is_at(1)) , assert(sequence(ID2, quadrado_seq, Quadrado)))  ,
                            ((x_is_at(1),z_is_at(2)) , writeln('Launching second sequence...')),
                            ((x_is_at(1),z_is_at(1)) , assert(sequence(ID3, quadrado_seq, Quadrado)))
                      ])
      ),
      retract(square_dance)
    ].







