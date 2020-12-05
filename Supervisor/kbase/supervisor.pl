:-ensure_loaded('web_services').


:- http_handler(root(execute_remote_query ), execute_remote_query    , []).
:- http_handler(root(query_dispatcher_json), query_dispatcher_json   , []).

:- http_handler(root(query_forward),	     query_forward	     , []).


:-include('dispatcher.pl').  % usando o "consult" apaga as regras dos outros m�dulos
:-include('monitoring.pl').

:-dynamic res_sult/1.
:-dynamic action/1.

%http://www.pathwayslms.com/swipltuts/html/index.html
%https://www.swi-prolog.org/pldoc/doc_for?object=section(%27packages/http.html%27)

:- dynamic yy/1.


main:- start_server(8083).
main(_):-
	start_server(8083).


start_server(Port):-
    server(Port),
    writeln('server started...').



:- json_object
    dispatch(action_name:atom) + [type=dispatch].


%NOVA VERSAO
execute_query([query=QueryString],Result):-
    term_string(QueryTerm, QueryString),
    catch(
     findall(true, QueryTerm, L),
	 error(Err,_Context)
	 ,
	 (   format('Erro: ~w\n', [Err]), L=[false])
    ),
    [Result|_]=L,
    !.
execute_query(_,false).

%NOVA VERSAO
%:-findall(Y, ( member(X,[1,2,3,4]), Y is X*2), L), write(L).
execute_remote_query(Request):-
        current_output(Curr),
        set_output(user_output),
        member(search(List), Request),
        set_output(Curr),
        format('Content-type: text/plain~n~n',[]),
        execute_query(List, Result),
        nl,
        writeln(Result).




query_dispatcher_json(_Request):-
        current_output(Curr),
        set_output(user_output),
         findall( dispatch(Action),
        (
           action(Action)
        ), ListOfActions),
        retractall(action(_)),
        set_output(Curr),
        format('Content-type: application/json~n~n', []),
        prolog_to_json(ListOfActions, JSON_EVENTS),
        json_write(current_output,JSON_EVENTS ).


query_forward(_Request):-
        current_output(Curr),
        set_output(user_output),
        forward,
        set_output(Curr),
        format('Content-type: text/plain~n~n',[]),
        nl,writeln('ok'),
        nl.







