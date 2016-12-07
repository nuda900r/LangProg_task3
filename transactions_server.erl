-module(transactions_server).
-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link()->
    gen_server:start_link({global, transactions_server}, transactions_server, [], []).

terminate(_, {File, _})->
    dets:close(File).


init(_)->
    {'ok', readLog('history.log')}.

handle_call(history, _, {File, Log})->
    {'reply', Log, {File, Log}};

handle_call(_,_,State)->
    {'reply', 'Unknown call', State}.


handle_cast({widthdraw, Amount}, {File, Log}) ->
    dets:insert(File, {os:timestamp(), Amount}),
    {'noreply', {File, Log ++ [Amount]}};

handle_cast(clear, {File, _}) ->
    dets:delete_all_objects(File),
    {'noreply', {File, []}};

handle_cast(_, State)->   
    {'noreply', State}.


handle_info(_, State)->
    {'noreply', State}.
code_change(_, State, _)->
    {'ok', State}.


readLog(FileName)->
    {ok, File} = dets:open_file(FileName, []),
%%{File, []}.
    Data = dets:match(File, '$1'),
    SortedData = lists:sort(Data),
    FilterFunc = fun([{_, A}])-> 
			 A
		 end,
    {File, lists:map(FilterFunc, SortedData)}.




