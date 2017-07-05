%% @author karla
%% @doc @todo Add description to myring.


-module(myring).

%% ====================================================================
%% API functions
%% ====================================================================
-compile([export_all]).

start(Num) -> 
	start_proc(Num, self()).

start_proc(0, Pid) -> 
	Pid ! ok; 

start_proc(Num, Pid) -> 
	NPid = spawn(?MODULE, start_proc, [Num-1, Pid]), 
	NPid ! ok, 
	receive ok -> ok end. 
