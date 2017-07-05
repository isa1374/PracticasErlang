%% @author isha1_000
%% @doc @todo Add description to subscription.



-module(subscription).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0, loop/1, loop2/0]).


start() -> register(server, spawn(subscription, loop, [[]])).

loop(DB) ->
	io:format("~w~n", [DB]),
   receive
		{subscribe, Topic, Pid} ->
			Pids = dict:find(Topic,DB),
			case Pids of 
				error -> DB1=dict:store(Topic, [Pid], DB), reply(Pid,ok), loop(DB1);
				{ok, Value} -> 
					case lists:member(Pid, Value) of
						false -> DB1 = dict:append(Topic,Pid, DB), reply(Pid,ok), loop(DB1);
						true -> loop(DB)
					end
			end;
		{send, Topic, Msg} -> 
			Pids = dict:find(Topic,DB),
			case Pids of
				error -> loop(DB);
				{ok, Value} -> lists:foreach(fun (Pid) -> Pid ! {Topic, Msg} end , Value), loop(DB)
			end
   end.	


loop2() ->
	receive
		{subscribe, Topic, Pid} -> server ! {subscribe, Topic, Pid};
		{send, Topic, Msg} -> server ! {send, Topic, Msg};
		Msg -> io:format("~w~w~n", [Msg, self()])
    end, loop2().	
	
%% ====================================================================
%% Internal functions
%% ====================================================================

reply(Pid, Msg) -> Pid ! Msg.

find_and_append([],Topic, Pid) -> [{Topic, [Pid]}];
find_and_append([{Topic, Lst}| T],Topic, Pid) -> [{Topic, [Pid | Lst]}| T];
find_and_append([H | T],Topic, Pid) -> [H | find_and_append(T,Topic, Pid)].


