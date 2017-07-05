%% @author isha1_000
-module(tarea).
-compile(export_all).

%%max con cps 
max_cps(Lst)->max_cps(Lst, fun(H)-> H end).
max_cps([],A)->A(0);
max_cps([H|T],A)->max_cps(T,fun(X)-> A(erlang:max(X, H)) end).

%%Sum con cps
sum_cps(Lst)-> sum_cps(Lst, fun(X)->X end). 
sum_cps([], A)-> A(0); 
sum_cps([H|T], A)-> sum_cps(T, fun(X)->A(X+H)end).

%%last normal 
last(List) -> last(0,List).
last(Res,[]) -> Res;
last(Res,[H|T]) -> last(H,T).

%%last con cps 
last_cps(Lst)-> last_cps(Lst, fun(T)->T end). 
last_cps([], A)-> A([]); 
last_cps([H|T], A)-> last_cps(H, fun(X)-> A(X ++[T])end ).

%%reverse con cps
reverse_cps(Lst)-> reverse_cps(Lst, fun(X)->X end).
reverse_cps([], A)-> A([]);
reverse_cps([H|T], A)->reverse_cps(T, fun(X)-> A(X ++ [H]) end).




