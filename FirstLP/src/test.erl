%% @author karla
%% @doc @todo Add description to test.


-module(test).

%% ====================================================================
%% API functions
%% ====================================================================
-compile([export_all]).


len([]) -> 0;
len([_|T]) -> 1 + len(T). %% len(T) + 1.

len_cps(Lst) -> len_cps(Lst, fun (X) -> X end).

len_cps([], K) -> K(0);
len_cps([_H | T], K) -> len_cps(T, fun (X) -> K(1 + X) end).

len2(Lst) -> len2(Lst, 0).

len2([], Res) -> Res;
len2([_ | T], Res) -> len2(T, Res + 1).

max([A]) -> A;
max([H | T]) -> erlang:max(H, max(T)).

max2([H | T]) -> max2(H, T).

max2(X, []) -> X;
max2(X, [H | T]) -> max2(erlang:max(X,H), T).

factorial(0) -> 1;
factorial(X) -> X * factorial(X-1).

factorial_cps(X) -> factorial_cps(X, fun (X) -> X end).

factorial_cps(0, K) -> K(1);
factorial_cps(X,K) -> factorial_cps(X-1,fun (Z) -> K(Z*X) end).


factorial2(X) when X == 0 -> 1;
factorial2(X) -> X * lsts:factorial2(X-1).

cons(H,T) -> [H | T].

mas(A,B) -> A + B.

info() -> cons(1,cons(2,cons(3,[]))).
info1() -> mas(1,mas(2,mas(3,0))).

reduce(_F,LV, []) -> LV;
reduce(F, LV, [X | Xs]) -> F(X, reduce(F, LV, Xs)).

%%suma(Lst) -> reduce(fun (A,B) -> A + B end, 0, Lst).
multiplica(Lst) -> reduce(fun (A,B) -> A * B end, 1, Lst).

suma(A,B) -> A + B.
resta(A,B) -> A - B.
misterio(A) ->
	F = case A < 0 of
			true -> fun(X) -> 0 - X end;
			false -> fun(X) -> 0 + X end
		end,	
	F(A).

misterio2(A) ->
	F = case A < 0 of
			true -> fun lsts:resta/2;
			false -> fun lsts:suma/2
		end,	
	F(0,A).

mul(X) ->
      fun (Y) -> X * Y end.

filter([], _Predicate) -> [];
filter([H | T], Predicate) ->
	case Predicate(H) of
		true -> [H | filter(T, Predicate)];
		false -> filter(T, Predicate)
	end.

filter_tail(Lst, Predicate) -> filter_tail(Lst, Predicate,[]).

filter_tail([], _Predicate, Res) -> Res;
filter_tail([H | T], Predicate, Res) -> 
	case Predicate(H) of
		true -> filter_tail(T, Predicate, Res ++ [H]);
		false -> filter_tail(T, Predicate,  Res)
	end.


filter_reduce(Lst,Predicate) ->
	reduce(fun (H,T) -> case Predicate(H) of
							true -> cons(H,T);
							false -> T
						end end, [], Lst).


append_reduce(A,B) -> reduce(fun lsts:cons/2, B,A).

length_reduce(Lst) -> reduce(fun (_H,T) -> T + 1 end, 0, Lst).

%%encuentra(ListaDeSimbolos, Simbolo)

encuentra([], _) -> false;
encuentra([H | T], Atomo) -> 
	case is_list(H) of
		true -> 
			case encuentra(H, Atomo) of
				true -> true;
				false -> encuentra(T, Atomo)
			end;
		false -> 
			case H == Atomo of
				true -> true;
				false -> encuentra(T, Atomo)
			end
	end.

encuentra_cps(Lst, Atomo) -> encuentra_cps(Lst, Atomo, fun (X) -> X end).

encuentra_cps([], _Atomo, K) -> K(false);
encuentra_cps([H | T], Atomo, K) ->
	case is_list(H) of
		true -> 
			case encuentra_cps(H, Atomo, K) of
				true -> K(true);
				false -> encuentra_cps(T, Atomo,K)
			end;
		false ->
			case H == Atomo of
				true -> K(true);
				false -> encuentra_cps(T, Atomo, K)
			end
	end.

append([], Lst2) ->
	Lst2;
append([H | T], Lst2) ->
	[H | append(T, Lst2)].

append_cps(Lst1,Lst2) -> append_cps(Lst1, Lst2, fun(X) -> X end).

append_cps([], Lst2, K) -> K(Lst2);
append_cps([H | T], Lst2, K) -> append_cps(T, Lst2, fun (X) -> K([H | X]) end).

map(_Fun, []) -> [];
map(Fun, [H | T]) -> [Fun(H) | map(Fun, T)].

map_cps(Fun, Lst) -> map_cps(Fun, Lst, fun (X) -> X end).
map_cps(_Fun, [], K) -> K([]);
map_cps(Fun, [H | T], K) -> map_cps(Fun, T, fun (X) -> K([Fun(H) | X]) end).

map_reduce(Fun, Lst) ->
	reduce(fun (H,T) -> [Fun(H) | T] end, [], Lst).

pares(X) -> X rem 2 == 0.

%% F tiene dos parametros
curry2(F) -> fun (X) -> fun(Y) -> F(X,Y) end end.

compose(F,G) -> fun (X) -> F(G(X)) end.

%%encuentra3(Lst, Atomo) -> fun(Lst) -> tl(Lst)
encuentra3(Lst, Atomo) -> 
	Res = encuentra3b(Lst, Atomo) ++ ".",
	io:format("~s~n", [Res]),
	{_,F,_} = eval(Res,[]),
	F.
		
encuentra3b([], _Atomo) -> false;
encuentra3b([H | T], Atomo) ->
	case H == Atomo of
		true -> "fun erlang:hd/1";
		false -> 
			Temp = encuentra3b(T, Atomo),
			"lsts:compose(" ++ Temp ++ ", fun erlang:tl/1" ++ ")"
	end.

eval(S,Environ) ->
    {ok,Scanned,_} = erl_scan:string(S),
    {ok,Parsed} = erl_parse:parse_exprs(Scanned),
    erl_eval:exprs(Parsed,Environ).


