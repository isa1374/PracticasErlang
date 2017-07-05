%% @author karla
%% @doc @todo Add description to echo3.


-module(echo3).

%% ====================================================================
%% API functions
%% ====================================================================
-compile([export_all]).

go()-> 
	register(echo, spawn(echo3, loop, [])),
	echo ! {self(), hellp}, 
	receive 
		{_Pid, Msg}-> 
			io:format("~w~n", [Msg])
	end. 

loop()-> 
	receive 
		{From, Msg}-> 
			From ! {self(), Msg}, 
			loop(); 
		stop->
			true
	end.
