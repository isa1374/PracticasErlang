%% @author karla
%% @doc @todo Add description to echo.


-module(echo).

%% ====================================================================
%% API functions
%% ====================================================================
-compile([export_all]).

go()-> 
	Pid = spawn(echo, loop, []), 
	Pid !{self(), hola}, 
	receive 
		{Pid, Msg}-> 
			io:format ("~s~n" ,[Msg])
	end, 
	Pid ! stop.

loop()->
	receive 
		{From, Msg}-> 
			Msg1 = "Del otro proceso" ++atom_to_list(Msg), 
			From ! {self(), Msg1},
			loop();
		stop->
			true
	end. 
