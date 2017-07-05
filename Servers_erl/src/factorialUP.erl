%% @author isha1_000
%% @doc @todo Add description to factorialUP.



-module(factorialUP).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0, loop/0, stop/0, factorial/1, calcFac/1]).

start() -> register(factorial, spawn(?MODULE, loop, [])).


stop() -> factorial ! {stop}.

calcFac(N) -> factorial ! {facto, N, self()},
			  receive
				  {ok, Res} -> Res
		  end.	
factorial(0) -> 1;
factorial(N) -> N * ?MODULE:factorial(N-1).	

loop() ->
	receive
		{facto, Num, Remitente} -> 
			Res = factorial(Num), 
			Remitente ! {ok, Res}, ?MODULE:loop();
		{stop} -> ok
	end.
