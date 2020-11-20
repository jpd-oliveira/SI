:-ensure_loaded('RTXEngine/RTXstrips_planner').


act goto_xz(Xf, Zf)
       pre  [x_is_at(Xi), z_is_at(Zi), (Xi\==Xf, Zi\==Zf)]
       add [x_is_at(Xf), z_is_at(Zf)]
       del  [x_is_at(Xi), z_is_at(Zi)]
       endcond[x_is_at(Xf), z_is_at(Zf)].


act goto_x(Xf)
       pre  [x_is_at(Xi), (Xi\==Xf)]
       add [x_is_at(Xf)]
       del  [x_is_at(Xi)]
       endcond[x_is_at(Xf)].


act put_in_cell(X,Z,Block)
       pre  [cage(Block), x_is_at(X),z_is_at(Z), not(cell(X,Z,_))]
       add [cell(X,Z,Block)]
       del  [cage(Block)]
       endcond[not(cage),y_is_at(2)].

act goto_y(Yf)
   pre  [x_is_at(Yi), (Yi\==Yf)]
   add [x_is_at(Yf)]
   del  [x_is_at(Yi)]
   endcond[y_is_at(Yf)].


act goto_z(Zf)
   pre [z_is_at(Zi), (Zi\=Zf)]
   add [z_is_at(Zf)]
   del [z_is_at(Zi)]
   endcond[z_is_at(Zf)].

act take_part(X,Z)
   pre [not(cage(Block)), x_is_at(X),z_is_at(Z), cell(X,Z,_)]
   add [cage(Block)]
   del [cell(X,Z,Block)]
   endcond[cage(Block),y_is_at(2)].

act put_in_leftS(Block)
   pre [x_is_at(1),z_is_at(1),cage(Block)]
   add [leftS(Block)]
   del [cage(Block)]
   endcond[not(cage),y_is_at(2)].

act take_from_leftS(Block)
   pre [x_is_at(1),z_is_at(1), not(cage(_))]
   add [cage(Block)]
   del []
   endcond[].

act put_in_rightS(Block)
   pre [x_is_at(10),z_is_at(1),cage(Block)]
   add [rightS(Block)]
   del [cage(Block)]
   endcond[not(cage),y_is_at(2)].

act take_from_rightS(Block)
   pre [x_is_at(10),z_is_at(1), not(cage(_))]
   add [cage(Block)]
   del []
   endcond[].
