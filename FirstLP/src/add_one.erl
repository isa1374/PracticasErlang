%% @author karla
%% @doc @todo Add description to add_one.


-module(add_one).

%% ====================================================================
%% API functions
%% ====================================================================
-compile([export_all]).

start() -> 
	register(add_one, spawn_link(add_one, loop, [])).

request(Int) -> 
	add_one ! {request, self(), Int}, 
	receive 
		{result, Result} -> Result 
	after 1000 -> timeout 
	end. 

loop() -> 
	receive 
		{request, Pid, Msg} -> 
			Pid ! {result, Msg+1}
	end, 
	loop(). 
