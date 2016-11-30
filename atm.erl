-module(atm).
-export([withdraw/2]).

%Жадный алгоритм
%с нашим набором купюр всегда будет работать
calc(NeedAmount, Take, [RestMax | RestTail], NotUsed)->
    TestAmount = NeedAmount - RestMax,
    if TestAmount > 0 ->
	    calc(TestAmount, Take ++ [RestMax], RestTail, NotUsed); 
       TestAmount < 0 ->
	    calc(NeedAmount, Take, RestTail, NotUsed ++ [RestMax]);
       true -> {ok, Take ++ [RestMax], NotUsed ++ RestTail}
    end;
calc(NeedAmount, Take, [], NotUsed) ->
    {request_another_amount, [], Take ++ NotUsed}.

withdraw(Amount, Banknotes)->
       NumDecr = fun(A, B)->
			 A>=B
		 end,
       calc(Amount, [], lists:sort(NumDecr, Banknotes), []).
    

