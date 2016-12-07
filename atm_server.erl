-module(atm_server).
-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link()->
    gen_server:start_link({global, atm_server}, atm_server, [], []).

terminate(_,_)->
    'ok'.

init([])->
    {'ok', [5000, 50, 50, 50, 1000, 5000, 1000, 500, 100]};
init(_Args)->
    {'ok', _Args}.

handle_call({widthdraw, _}, _, [])->
    %%денег нету, умираем
    {'stop', 'normal', []};
handle_call({widthdraw, Amount}, _, State)->
    {Answer, ReturnBanknotes, RestBanknotes} = atm:widthdraw(Amount, State),
    if Answer == 'ok'->
            %%пишем в лог
            gen_server:cast({global, transactions_server}, {widthdraw, Amount});
       true->
           'ok'
    end,
    {'reply', {Answer, ReturnBanknotes}, RestBanknotes};
handle_call(_,_,State)->
    {'reply', 'Unknown call', State}.

handle_cast(_, State)->   
    {'noreply', State}.

handle_info(_, State)->
    {'noreply', State}.

code_change(_, State, _)->
    {'ok', State}.
