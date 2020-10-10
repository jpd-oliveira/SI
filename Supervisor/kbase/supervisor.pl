:-ensure_loaded('web_services').
:-ensure_loaded('monitoring').
:-ensure_loaded('rules').


%http://www.pathwayslms.com/swipltuts/html/index.html
%https://www.swi-prolog.org/pldoc/doc_for?object=section(%27packages/http.html%27)


:- http_handler(root(monitoring_req       ), monitoring_req          , []).
:- http_handler(root(monitoring_req_xhr   ), monitoring_req_xhr      , []).
:- http_handler(root(execute_remote_query ), execute_remote_query    , []).


assert_variables([]).
assert_variables([variable=ParamsString|Variables]):-
    term_string(ParamsTerm, ParamsString),
    assert_params(ParamsTerm),
    assert_variables(Variables).

assert_params(Params):-
    member(name   : Name,   Params),
    findall( _, (
                 member( Param : Value, Params),
                 Term =.. [Name, Param,   Value],
                 assert_single( Term)
             ), _).


/*  member(value  : Value,  Params),
    member(time   : Time,   Params),
    member(min_ref: Min_ref,Params),
    member(max_ref: Max_ref,Params),
    T1 =.. [Name, value,   Value],    assert_single( T1),
    T2 =.. [Name, max_ref, Max_ref],  assert_single( T2),
    T3 =.. [Name, min_ref, Min_ref],  assert_single( T3),
    T4 =.. [Name, time   , Time],     assert_single( T4).
*/

monitoring_req(Request):-
        %debug(hello, 'About to say hello', []),
        member(search(List), Request),
        format('Content-type: text/plain~n~n'),
        assert_variables(List),
        forward,
        findall(event(A,B,C),  event(A,B,C), Events),
        portray_clause(List),
        portray_clause(Events),
        nl.



main(_):-
	start_server(8083).


start_server(Port):-
    server(Port),
    writeln('server started...').

:- json_object
    event(variable:atom, condition:atom, value:integer) + [type=event].


monitoring_req_xhr(Request):-
        format('Content-type: application/json~n~n', []),
        member(search(List), Request),
        assert_variables(List),
        forward,
        findall(Status,
        (
           event(A,B,C),
           Status = event(A,B,C)
        ), Events),
        prolog_to_json(Events, JSON_EVENTS),
        json_write(current_output,JSON_EVENTS ).


monitoring_post_xhr(Request):-
        format('Content-type: application/json~n~n', []),
        member(method(post), Request), !,
        http_read_data(Request, List, []),
        assert_variables(List),
        forward, % call KB forward inference rules engine
        findall(Status,
        (
           event(A,B,C),
           Status = event(A,B,C)
        ), Events),
        prolog_to_json(Events, JSON_EVENTS),
        json_write(current_output,JSON_EVENTS).


execute_query([query=QueryString]):-
    term_string(QueryTerm, QueryString),
    %current_input(CurrentInput),
    %current_output(CurrentOutput),
    %set_prolog_IO(CurrentInput, CurrentOutput, CurrentOutput),
    %with_output_to(current_error, QueryTerm).
    assert_once(res_sult(no)),
    QueryTerm,
    assert_once(res_sult(true)).

%:-findall(Y, ( member(X,[1,2,3,4]), Y is X*2), L), write(L).
execute_remote_query(Request):-
        %debug(hello, 'About to say hello', []),
        %tell('c:/temp/lixo.pl'),
        %writeln(Request),
        %Told,
        member(search(List), Request),
        format('Content-type: text/plain~n~n'),
        %findall(event(A,B,C),  event(A,B,C), Events),
        %portray_clause(List),
        execute_query(List),
        res_sult(Res),
        nl,writeln(Res),
        nl.







