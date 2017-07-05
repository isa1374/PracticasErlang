%% @author karla
%% @doc @todo Add description to rec.


-module(rec).

%% ====================================================================
%% API functions
%% ====================================================================
-compile([export_all]).
-record(person,{name, age, phone}).
-record(person1,{name = "black charro", age, phone}).
-record(name,{first,last}).

fun1(0) ->
 Per = #person{name = "john",age = 5,phone="4455667744"}, Per;
fun1(1) ->
 Per = fun1(0), io:format("~s~n",[Per#person.name]);
fun1(2) ->
 Per = fun1(0), Per1 = Per#person{name="Alice"},
 io:format("~s~n",[Per1#person.name]);
fun1(Per = #person{age = Age}) ->
 Per#person{age = Age + 1};
fun1(3) ->
 #person1{name = #name{first = "Samantha", last ="Luna"}}. 