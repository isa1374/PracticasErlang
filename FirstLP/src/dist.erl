%% @author isha1_000
%% @doc @todo Add description to dist.


-module(dist).

%% ====================================================================
%% API functions
%% ====================================================================
-compile({export_all}).

t(From)-> From  ! node(). 
factorial(From, N)->From ! factorial2(N).

factorial2(1)-> 1;
factorial2(N)-> N*factorial2(N-1).

%%start()-> register(calculadora, spawn())


%% ====================================================================
%% Internal functions
%% ====================================================================


