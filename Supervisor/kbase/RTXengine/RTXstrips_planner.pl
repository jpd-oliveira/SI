:-ensure_loaded('RTXmodule').

:-op(900, fy,  act).

:-op(700, xfx, pre).
:-op(600, xfx, add).
:-op(500, xfx, del).
:-op(400, xfx, endcond).


:-dynamic debug_strips/0.

%:-assert(debug_strips).
%:-debug_strips(false).

preclist(Action, Plist):-
    %strips_rule(Action, Plist, _,_).
    act Action pre Plist add _AddList del _DelList;
    act Action pre Plist add _AddList del _DelList endcond _EndCond.

prec(Action, Cond):-
    preclist(Action, Plist),
    member(Cond, Plist).


addlist(Action, Alist):-
    %strips_rule(Action, _, Alist, _)
    act Action pre _Precondlist add Alist del _DelList;
    act Action pre _Precondlist add Alist del _DelList endcond _EndCond.

/*
adds(Action, Cond):-
    addlist(Action, Alist),
    member(Cond, Alist).
*/

find_action(State, CondList, Action, PrecondList, AddList, DelList, End):-

    act Action pre PrecondList add AddList del DelList endcond End,

    sublist(CondList, AddList),
    %fake_sub_set(AddList, State),
    evaluate_pre_condition(AddList, CondList),
    fake_sub_set(PrecondList, State),
    fake_sub_set(DelList, State).

get_the_action(State, Action, PrecondList, AddList, DelList, EndCond):-
    act Action pre PrecondList add AddList del DelList endcond EndCond,
    fake_sub_set(PrecondList, State),
    fake_sub_set(DelList, State).


sort_the_best_action(State, Cond, SortedActions):-
    findall( (Act, Score), (
             find_action(State,Cond, Act, Prec, Add, Del, _EndCond),
             join_in_a_list(  Act, Prec, Add, Del, LLL),
             count_grounds(LLL, G,NG),
             Score is G / (G+NG)
    ),L),
    %SortedActions=L,
    sort(1, @<, L, SortedActions).





dellist(Action,Dlist):-
    %strips_rule(Action, _,_,Dlist).
    act Action pre _Precondlist add _Addlist del Dlist;
    act Action pre _Precondlist add _Addlist del Dlist endcond _END.

dels(Action, Cond):-dellist(Action, Dlist), member(Cond, Dlist).


endCond(Action, EndCond):-
    act Action pre _Precondlist add _Addlist del _Dlist endcond EndCond,
    !.
endCond(_Action, []).


apply_rule(Ac, AddList, DelList, State, NewState):-
    (   debug_strips, write('doing '),writeln(Ac),!; true),
    subtract(State, DelList, TmpState),
    union(AddList, TmpState, NewState).


strips(IniState, GoalList, Plan):-
    %get_time(Time),
    strips(IniState, GoalList, Plan,10).


strips( IniState, GoalList, Plan,MaxIteration):-
    %get_time(Time),
    strips1(0,MaxIteration,  IniState, GoalList,[], [], _, ReversedPlan),
    test_ground(ReversedPlan),
    reverse(ReversedPlan, Plan).



strips1(_,_,State, GoalList,Plan,  _, State, Plan):-
    %subset(GoalList, State).
    evaluate_pre_condition(State, GoalList),
    !.


strips1(Iteration, MaxIteration,  State, GoalList,Plan,  ForbbiddenActions, NewState, NewPlan):-
    Iteration <MaxIteration,
    Iteration2 is Iteration +1,
    %get_time(Time2),
    %Dif is (Time2 - Time)*1000,
    %Dif \== 1000.1233,
    %\+ evaluate_pre_condition(State, GoalList),

    %member(Goal, GoalList),

    sublist(Goal, GoalList),
    Goal\==[],
    \+ sublist(Goal,State),

    % not(member(Goal, State)),           % find unsatisfied goal

    %adds(Action, Goal),                 % find an operator that achieves it
    %find_action(State, Goal, Action, PrecList, AddList, DelList),
    sort_the_best_action(State, Goal, SortedActions),
    member( (Action, _Score), SortedActions),

    get_the_action(State,  Action, PrecList, AddList, DelList, _ENDCOND),
    %act Action pre PrecList add AddList del DelList,


    %can be removed, infinite loop
    not( member(Action, ForbbiddenActions)),
    %preclist(Action, PrecList),              % find its preconditions


    % achieve preconditions

    strips1(Iteration2, MaxIteration,  State, PrecList, Plan, [Action|ForbbiddenActions], TmpState1, TmpPlan1),
    apply_rule(Action, AddList, DelList, TmpState1, TmpState2),
   % get_time(Time3),
    strips1(Iteration2, MaxIteration,  TmpState2, GoalList,[Action|TmpPlan1], ForbbiddenActions, NewState, NewPlan).




is_list_unground(List):-
    forall( member(Term, List),     \+ ground(Term)).

fake_sub_set([],_).

fake_sub_set([Term|List], State):-
    member(Term, State),
    fake_sub_set(List, State),
    !.
fake_sub_set([_Term|List], State):-
    fake_sub_set(List, State),
    !.


count_grounds([],0,0).

count_grounds([Term|List], Grounds, NotGrounds):-
    ground(Term),
    count_grounds(List, G2, NotGrounds),
    Grounds    is G2 +1.

count_grounds([Term|List], Grounds, NotGrounds):-
    \+ ground(Term),
    count_grounds(List, Grounds, NotG2),
    NotGrounds    is NotG2 +1.


join_in_a_list(Action, Pre, Add, Dell, List):-
    append([ [Action], Pre, Add, Dell], List),
    !.


test_ground([]).
test_ground([Term|List]):-
    ground(Term),
    test_ground(List).




debug_strips(true):-
    retractall(debug_strips),
    assert(debug_strips).


debug_strips(false):-
    retractall(debug_strips).



debug_action(Ac):-
    debug_strips,
    nl, write('doing '), write(Ac), ttyflush,
    !.
debug_action(_).


min_plan([Plan|AllPlans], BestPlan):-
    min_plan(AllPlans, Plan, BestPlan).


min_plan([], Plan, Plan).

min_plan([Plan|AllPlans], CurrentBestPlan, BestPlan):-
    length(Plan, LenPlan),
    length(CurrentBestPlan, LenCurrBest),
    (   LenPlan<LenCurrBest ->
                  min_plan(AllPlans, Plan, BestPlan);
                  min_plan(AllPlans, CurrentBestPlan, BestPlan)).


list_to_string_term([],'').
list_to_string_term([Cond|List], StringTerm):-
    list_to_string_term(List, StringTerm2),
    term_string(Cond, SCond),
    (   StringTerm2\=='',
        atom_concat( SCond, ',' , ST3)
        ;
        StringTerm2=='',
        ST3  = SCond
    ),
    atom_concat(ST3, StringTerm2, StringTerm).
    %atom_concat( SCond, ',' , ST3),
    %atom_concat(ST3, StringTerm2, StringTerm).



list_to_term(List, Term):-
    list_to_string_term(List, StringTerm),
    %atom_concat(StringTerm,true, ST2), %because of extra comma
    %term_string(Term, ST2).
    (   StringTerm == '', %empty string
        Term = true
        ;
        StringTerm \== '',
        term_string(Term, StringTerm)
    ).


term_to_list(Term, List):-
    findall(SubTerm, arg(_N, Term, SubTerm), List_aux),
    delete(List_aux, true, List).



prepare_the_plan(States, Plan, Sequence):-
   get_end_conditions(States,Plan, EndConditions),
   EndConditions2 = [true| EndConditions],
   create_sequence(States,Plan, EndConditions2, Sequence),
   !.


get_end_conditions(_,[],[]).
get_end_conditions(States, [Action|PlanList],[Condition|ConditionList]):-
    %get_the_action(States,Action, _, _, _, ENDCOND),
    act Action pre _PrecondList add _AddList del _DelList endcond EndCond,
    list_to_term(EndCond,Condition),
    get_end_conditions(States,PlanList,ConditionList).


create_sequence(_,[],_,[]).

create_sequence(States,[Action|ActionList],[ Condition|ConditionList],
                [ (Condition, assert(Action)),(true,retract_states(DelList)), (true, assert_states(AddList))|Sequence]):-
    get_the_action(States,Action, _Pre, AddList, DelList, _ENDCOND),
    apply_rule(Action, AddList, DelList, States, States_2),
    create_sequence(States_2, ActionList, ConditionList, Sequence).



launch_sequence(Sequence, ID):-
    new_id(ID),
    assert(sequence(ID, plan_execution, Sequence)).


is_system_state(Fact):-
    % verifies if it is a sensor state
    % COMPLETE THIS LIST WITH ALL YOUR SENSOR FACTS
    member(Fact, [x_is_at(_), x_moving(_), y_is_at(_), cage ]).

% retract just the facts that are not sensors
retract_states([]).
retract_states([Fact|List]):-
    (  \+ is_system_state(Fact),  retract(Fact), !
       ;
       true
    ),
    retract_states(List).

% assert just the facts that are not sensors
assert_states([]).
assert_states([Fact|List]):-
    (  \+ is_system_state(Fact),  assert(Fact), write('Fact='), writeln(Fact),!
       ;
       true
    ),
    assert_states(List).
