% https://www.swi-prolog.org/howto/http/

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_path)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_open)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_client)).
:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).


%https://www.swi-prolog.org/pldoc/man?section=jsonsupport
:- use_module(library(http/http_json)).


:- use_module(library(http/http_error)).
:- use_module(library(debug)).



:- http_handler(root(list_modules       ), list_modules       , []).
:- http_handler(root(echo_request       ), http_echo_request  , []).
:- http_handler(root(echo_post          ), http_echo_post     , []).
:- http_handler(root(hello_world        ), hello_world            , []).


%:-[variables].



% :- http_handler('/favicon.ico', http_reply_file('favicon.ico', []),




server(Port) :-						% (2)
        http_server(http_dispatch, [port(Port)]).

% ?- tspy(say_hi/1).
hello_world(_Request) :-					% (3)
        %format('Content-type: text/plain~n~n'),
        format('Content-type: text/html~n~n'),
        %debug(hello, 'About to say hello', []),
        format('<H2>Hi there, are you ready?</H2>~n').


list_modules(_Request) :-
        findall(M, current_module(M), List),
        sort(List, Modules),
        reply_html_page(title('Loaded Prolog modules'),
                        [ h1('Loaded Prolog modules'),
                          table([ \header	    % rule-invocation
                                | \modules(Modules) % rule-invocation
                                ])
                        ]).
header -->
        html(tr([th('Module'), th('File')])).

modules([]) -->	[].
modules([H|T]) --> module(H), modules(T).

module(Module) -->
        { module_property(Module, file(Path)) }, !,
        html(tr([td(Module), td(Path)])).

module(Module) -->
        html(tr([td(Module), td(-)])).



http_echo_request(Request):-
        format('Content-type: text/plain~n~n'),
        %debug(hello, 'About to say hello', []),
        member(search(List), Request),
        portray_clause(List),
        %writeln(List),
        nl.



http_echo_post(Request) :-
%    If the POST is initiated from a browser, content-type is generally
%    either application/x-www-form-urlencoded or multipart/form-data.
        member(method(post), Request), !,
        http_read_data(Request, Data, []),

        % execute some service
        % and reply with answer

        format('Content-type: text/plain~n~n', []),
        portray_clause(Data).





