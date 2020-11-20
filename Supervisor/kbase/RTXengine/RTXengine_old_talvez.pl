:- use_module(library(occurs)).
:- ensure_loaded('RTXutil').
/*
:- use_module('RTXutil').
*/

:-op(900, fy,  defrule).
:-op(800, xfx, pri).
:-op(700, xfx, desc).
:-op(600, xfx, if). % iProlog has "if" predefined
:-op(500, xfx, then).
:-op(400, xfx, else).
:-op(300, xfy, or).
:-op(200, xfy, and).

%:-op(100, fx,  nott).


:-multifile (defrule)/1.
:-dynamic debug_info/0.
:-multifile debug_info/0.

:-retractall(debug_info).
%:-assert(debug_info).

/*
:-dynamic do/1.       % do(Action)
:-dynamic goal/1.     % goal(Goal)
:-dynamic done/1.     % done(Goal)
:-dynamic diagnose/1. % diagnose(Goal).
:-dynamic action/1.

:-dynamic failure/4.  % failure(ID,Severity,  goal(Goal), Description).
*/


defrule sequence_not_empty
   if sequence(ID,Type,[(PreCond,Goal)|Sequence]) and dynamize_conditions(PreCond) and PreCond
   then [
       dynamize_conclusion(Goal),
       Goal,
       retract( sequence(ID,_, _)),
       assert(sequence(ID,Type,Sequence))
       %format('sequence_non_empty ~w type:~w  cond:~w goal:~w~n',[ID, Type, PreCond, Goal]),
   ].

defrule sequence_empty
   if sequence(ID,_,[])
   then [
      retract(sequence(ID,_,[]))
      %  ,   writeln(sequence_empty)
   ].



forward:-
    findall( (Name, Priority),
             (
                 pick_a_rule(Name,  Conditions,  Conclusions,ElseConc, Priority,_Description),
                 dynamize_conditions(Conditions),
                 dynamize_conclusions(Conclusions),
                 dynamize_conclusions(ElseConc)
             ),
             L),
    sort(2, @>=, L, SortedRules),

    %assert_new_diagnoses,  % catch all the goal(Goal) and create diagnose(Goal).

    do_forward(SortedRules,[]).

    %retract_old_diagnoses. % for each done(Goal)     retract diagnose(Goal) facts



do_forward(SortedRules,PreviousFiredRules):-
    forward_step(SortedRules,PreviousFiredRules,NewFiredRule),
    !,
    do_forward(SortedRules,[NewFiredRule|PreviousFiredRules])
    ;
    true.

forward_step(SortedRules, PreviousFiredRules,NewFiredRule):-
    member( (Name, Priority), SortedRules),

    pick_a_rule(Name,  Conditions,  Conclusions,ElseConc, Priority, _Description),

    %test conditions
    (
       (   Conditions,

           \+ member((Name, Conditions), PreviousFiredRules),
           perform_conclusions(Name,Conclusions),
           print_fired_rule(Name, Conditions, Conclusions),
           NewFiredRule=(Name, Conditions)
       )
       ;
       (
           length(ElseConc, Len),
           Len>0,
           NotConditions = not(Conditions),
           NotConditions,
           \+ member((Name,NotConditions ), PreviousFiredRules),
           perform_conclusions(Name, ElseConc),
           print_fired_rule(Name,NotConditions , ElseConc),
           NewFiredRule=(not(Name), NotConditions )
       )
    ).


print_fired_rule(Name, Conditions, Conclusions):-
    debug_info,
    format('Executed: ~w~n       conditions: ~w~n       conclusions: ~w~n',[Name, Conditions, Conclusions]).

print_fired_rule(_Name, _Conditions, _Conclusions):-
    \+ debug_info.




pick_a_rule(Name,  Conditions,  Conclusions,[], Priority,Description):-
    defrule Name pri Priority desc Description if Conditions then Concl,
    _ else _ \=Concl,
    atom(Name),
    number(Priority),
    atom(Description),
    (      is_list(Concl),  Conclusions =  Concl;
        \+ is_list(Concl),  Conclusions = [Concl]
    ).
    %!.

pick_a_rule(Name,  Conditions,  Conclusions,[], Priority,''):-
    defrule Name pri Priority if Conditions then Concl,
    _ else _ \=Concl,
    atom(Name),
    number(Priority),
    (      is_list(Concl),  Conclusions =  Concl;
        \+ is_list(Concl),  Conclusions = [Concl]
    ).
    %!.

pick_a_rule(Name,  Conditions,  Conclusions,[], 0,Description):-
    defrule Name desc Description if Conditions then Concl,
    _ else _ \=Concl,
    atom(Name),
    atom(Description),
    (      is_list(Concl),  Conclusions =  Concl;
        \+ is_list(Concl),  Conclusions = [Concl]
    ).
   % !.



pick_a_rule(Name,  Conditions,  Conclusions,[], 0,''):-
    defrule Name if Conditions then Concl,
    _ else _ \=Concl,
    atom(Name),
    (      is_list(Concl),  Conclusions =  Concl;
        \+ is_list(Concl),  Conclusions = [Concl]
    ).

/*******************/

pick_a_rule(Name,  Conditions,  Conclusions,ElseConcl, Priority,Description):-
    defrule Name pri Priority desc Description if Conditions then Concl else ElseConcl,
    atom(Name),
    number(Priority),
    atom(Description),
    (      is_list(Concl),  Conclusions =  Concl;
        \+ is_list(Concl),  Conclusions = [Concl]
    ).
    %!.

pick_a_rule(Name,  Conditions,  Conclusions,ElseConcl, Priority,''):-
    defrule Name pri Priority if Conditions then Concl else ElseConcl,
    atom(Name),
    number(Priority),
    (      is_list(Concl),  Conclusions =  Concl;
        \+ is_list(Concl),  Conclusions = [Concl]
    ).
    %!.

pick_a_rule(Name,  Conditions,  Conclusions,ElseConcl, 0,Description):-
    defrule Name desc Description if Conditions then Concl else ElseConcl,
    atom(Name),
    atom(Description),
    (      is_list(Concl),  Conclusions =  Concl;
        \+ is_list(Concl),  Conclusions = [Concl]
    ).
   % !.



pick_a_rule(Name,  Conditions,  Conclusions,ElseConcl, 0,''):-
    defrule Name if Conditions then Concl else ElseConcl,
    atom(Name),
    (      is_list(Concl),  Conclusions =  Concl;
        \+ is_list(Concl),  Conclusions = [Concl]
    ).


dynamize_conditions(Conditions):-
    %writeln(Conditions),
    findall( (Name, Arity),
            (
                sub_term(SubTerm, Conditions),
                (   compound(SubTerm); ground(SubTerm)),
                functor(SubTerm, Name, Arity),
                atom(Name)
             ),
           L),
    %format('Cond=~w,                     L=~w~n',[Conditions, L]),
    dyna_conditions(L).

dyna_conditions([]).
dyna_conditions([(Name,Arity)|L]):-
    try_dynamize_it(Name, Arity),
    dyna_conditions(L).



dynamize_conclusions([]).
dynamize_conclusions([Conc|Conclusions]):-
    dynamize_conclusion(Conc),
    dynamize_conclusions(Conclusions).


dynamize_conclusion(assert(Conc)):-
    compound(Conc),
    functor(Conc, Name, Arity),
    predicate_property(Name/Arity, static),
    dynamic(Name/Arity),!.

dynamize_conclusion(asserta(Conc)):-
    compound(Conc),
    functor(Conc, Name, Arity),
    predicate_property(Name/Arity, static),
    dynamic(Name/Arity),!.

dynamize_conclusion(assertz(Conc)):-
    compound(Conc),
    functor(Conc, Name, Arity),
    predicate_property(Name/Arity, static),
    dynamic(Name/Arity),!.

dynamize_conclusion(retract(Conc)):-
    compound(Conc),
    functor(Conc, Name, Arity),
    predicate_property(Name/Arity, static),
    dynamic(Name/Arity),!.

dynamize_conclusion(retractall(Conc)):-
    compound(Conc),
    functor(Conc, Name, Arity),
    predicate_property(Name/Arity, static),
    dynamic(Name/Arity),!.

dynamize_conclusion(_).


perform_conclusions(_,[]).

perform_conclusions(RuleName, [Conc|Conclusions]):-
    %dinamize_conclusion(Conc),
    %format('executing goal: ~w~n',[Conc]),
    (   ((Conc) -> true);
        format('FATAL: rule ~w failed in conclusion term ~w~n',[RuleName, Conc])
    ),
    perform_conclusions(RuleName,Conclusions).



and(A,B):-
   A,B.


or(A,B):-
   A,!; B.


%BACKWARD chaining inference

backward(Goal):-
    backward_2(Goal,_,_).

backward(Goal, ListRules):-
    backward_2(Goal,[Goal],ListRules).


backward_2(Goal, PreviousRules, FiredRules):-
    %pick_a_rule(Name,  Conditions,  Conclusions, _Priority, _Description),
    pick_a_rule(Name,  Conditions,  Conclusions,_ElseConc, _Priority, _Description),
    Name\=sequence_not_empty,
    Name\=sequence_empty,
    has_goal(Goal, Conclusions),
    RuleTerm=..[Name,Goal],
    backward_condition(Conditions, [RuleTerm|PreviousRules], FiredRules).



backward_2(Goal,FiredRules,[Goal|FiredRules]):-
    !,
    dynamize_conditions(Goal),
    Goal.

has_goal(Goal, Conclusions):-
    member(assert(Goal), Conclusions).

has_goal(Goal, Conclusions):-
    member(asserta(Goal), Conclusions).

has_goal(Goal, Conclusions):-
    member(assertz(Goal), Conclusions).

has_goal(Goal, Conclusions):-
    member(assert_once(Goal), Conclusions).



backward_condition(Cond1 and Cond2,PreviousRules, FiredRules):-
    !,
    backward_2(Cond1,PreviousRules, FiredRules_11),
    backward_2(Cond2,FiredRules_11, FiredRules).


backward_condition(Cond1 or Cond2,PreviousRules, FiredRules):-
    !,
    (
       backward_2(Cond1,PreviousRules, FiredRules)
      ;
       backward_2(Cond2,PreviousRules, FiredRules)
    ).


backward_condition(Condition, PreviousRules, FiredRules):-
    backward_2(Condition, PreviousRules, FiredRules).



/***************** Utilities *********************/

check_rules(Repetitions):-
        findall( Name,
             pick_a_rule(Name,  _Conditions,  _Conclusions,_ElseCon, _Priority,_Description),
             L),
        find_duplicates(L, Repetitions).

find_duplicates([],[]).

find_duplicates([X|Tail],[X|Duplicates]):-
    member(X, Tail),
    !,

    find_duplicates(Tail, Duplicates).

find_duplicates([X|Tail],Duplicates):-
    \+ member(X, Tail),
    find_duplicates(Tail, Duplicates).


