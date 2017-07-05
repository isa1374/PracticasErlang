%% @author karla
%% @doc @todo Add description to tempo.


-module(tempo).

%% ====================================================================
%% API functions
%% ====================================================================
-compile([export_all]).

go()-> 
	register(center, spawn(tempo, loop, [5])).
	
loop(M) when M > 0 -> 
	receive 
		{msg, Msg} -> 
			io:format("Message: ~w~n", [Msg], loop(M-1))
	after
		1000->
			io:format("End of wait ~w~n", [M]), loop(M)
	end; 

loop(_) ->
	io:format("Exit ~n"). 
