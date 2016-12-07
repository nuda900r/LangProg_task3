-module(atm_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link(atm_sup, []).

init(_) ->     
    Atm = {'atm_server',
	   {atm_server, start_link, []},
	   'permanent',
	   3600,
	   'worker',
	   [atm_server]},
    
    TransactionsServer = {'transactions_server',
			  {transactions_server, start_link, []},
                          'permanent',
			   3600,
			   'worker',
			   [transactions_server]},
    Settings = {'one_for_one', 100, 60},
    
    {'ok', {Settings, [Atm, TransactionsServer]}}.
