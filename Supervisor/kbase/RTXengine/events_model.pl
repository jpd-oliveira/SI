:-ensure_loaded('RTXutil').


create_event(Name, Value):- %event is already defined
    Functor=..[Name, Value],
    dynamic(Name/1),
    Functor,
    !.


create_event(Name, Value):- %event as functor with 1 argument
    delete_event(Name, Value),
    Functor=..[Name, Value],
    assert(Functor).


create_event(Name):- %event is already defined
    Functor=..[Name],
    dynamic(Name/0),
    Functor,
    !.

create_event(Name):- %event as functor with 1 argument
    delete_event(Name),
    Functor=..[Name],
    assert(Functor).

delete_event(Name,  _):- %event as functor with 1 argument
    Functor=..[Name, _],
    dynamic(Name/1),
    retractall(Functor).

delete_event(Name):- %event as functor with 0 arguments
    Functor=..[Name],
    dynamic(Name/0),
    retractall(Functor).


% axis positions
update_event(Name, Value):-
    member(Name, [x_is_at, y_is_at, z_is_at]),
    (Value \== -1 -> create_event(Name,Value); delete_event(Name, Value)   ),
    !.

% parts placements
update_event(Name, Value):-
    member(Name, [is_at_z_up, is_at_z_down, cage_has_part, is_part_at_left_station, is_part_at_right_station]),
    (Value \== 0 -> create_event(Name) ; delete_event(Name)),
    !.

% movements
update_event(Name, Value):-
    member(Name, [x_moving, y_moving, z_moving, left_station_moving, right_station_moving]),
    create_event(Name, Value),
    !.

%unknown events
update_event(Name, Value):-
    format('Event: ~w with value ~w is unknown~n',[Name, Value]).







