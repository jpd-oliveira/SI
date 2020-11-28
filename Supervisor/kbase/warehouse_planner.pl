:-ensure_loaded('RTXEngine/RTXstrips_planner').
:-ensure_loaded('dispatcher.pl').


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


