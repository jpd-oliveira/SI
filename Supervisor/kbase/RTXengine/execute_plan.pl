:-ensure_loaded('RTXmodule').

:-ensure_loaded('RTXutil').


%DEVE-SE ADAPTAR AS REGRAS system_states e sensor_states_list para 
%os detalhes especificos de cada grupo/trabalho.

system_states(StatesList):- /* management and sensor states */
    ManagementStates = [ cell(_,_,_),
                         cage(_),
                         left_station(_),
                         right_station(_) /*, MORE  */ ],

    sensor_states_list(SensorStates),
    append(ManagementStates,SensorStates, SystemStates),
    dynamic(SystemStates),
    findall( State, (
                 member(State, SystemStates),
                 State),
                 StatesList).

sensor_states_list(List):-  /* only the sensor states */
    List=[x_is_at(_),
          x_moving(_),
          y_is_at(_),
          y_moving(_),
          z_is_at(_),
          z_moving(_),
          left_station_moving(_),
          right_station_moving(_),
          is_at_z_up,
          is_at_z_down,
          is_part_at_left_station,
          is_part_at_right_station,
          cage_has_part].


warehouse_states(StatesListAsString):-
    system_states(StatesList),
    list_to_string(StatesList,StatesListAsString).


:-dynamic running_plan_mutex/1.
execute_plan(Plan):-
    \+ running_plan_mutex(_),
    assert( running_plan_mutex(Plan) ),
    thread_create(thread_plan(Plan),_Id,[]),
    retractall( running_plan_mutex(_) ),
    !.

execute_plan(Plan):-
    format('~nCannot execute the new plan. Plan ~w is still running.~n',[Plan]).


thread_plan(Plan):-
    iterate_through_plan(Plan,[]),
    thread_exit(_).

iterate_through_plan([],_):-
    format('~nend_of_plan~n').

iterate_through_plan([Action|Plan], GoalsToAchieve):-
    execute_the_action(Action,  GoalsToAchieve,  GoalsToAchieveNext),
    iterate_through_plan(Plan,  GoalsToAchieveNext).

:-dynamic button_interrupt/0.

execute_the_action(Action, GoalsToAchieveNow, GoalsToAchieveNext):-
    repeat,
    sleep(0.010), % 10 milliseconds
    system_states(States),
    % format('states : ~w~n',[States]),
    get_the_action(States, Action, _PreconditionList, AddList, DelList),
    verify_pre_conditions(States, GoalsToAchieveNow),
    % Pre conditions will FAIL if the plans not consistent,
    % for instance, if action is goto_xz(2,2) and we
    % are already at (2,2) or we just  need goto_z(2)
    % ----->  verify_pre_conditions(States, PreconditionList),

    endCond(Action, EndConditions),  %
    determine_goals_to_achieve(Action, AddList, DelList, EndConditions, GoalsToAchieveNext),
    format('~nadd: ~w del: ~w, States: ~w', [AddList, DelList, States]),
    format('~n Doing action: ~w goals to be achieved: ~w Time: ',[Action, GoalsToAchieveNext]),
    show_time,
    nl,
    assert(Action),  % this really starts the action

    process_add_list(AddList),
    process_delete_list(DelList),

    retractall(goal(_)),
    assert(goal(Action)),
    !.

determine_goals_to_achieve(Action,AddList, DelList, EndConditions, GoalsToAchieveNext):-
    apply_rule(Action, AddList, DelList, [], ActionEffect),
    append(ActionEffect, EndConditions, GoalsToAchieveNext).


process_delete_list(DelList):-
    sensor_states_list(SensorStates),
    findall(_,
            (   member(Fact, DelList),
                \+ member(Fact, SensorStates),
                retract_safe(Fact)
            ),_).


process_add_list(AddList):-
    sensor_states_list(SensorStates),
    findall(_,
            (   member(Fact, AddList),
                \+ member(Fact, SensorStates),
                assert(Fact)
            ),_).


%https://www.tek-tips.com/viewthread.cfm?qid=1612213
show_time:-
    get_time(TS),
    stamp_date_time(TS,Date9,'local'),
    arg(4,Date9,H),
    arg(5,Date9,M),
    arg(6,Date9,S),
    format('~w:~w:~0f',[H,M,S]).
