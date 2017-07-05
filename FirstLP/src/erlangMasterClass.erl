%% @author David Manzanarez, Oscar Omana, Isabel Garcia, Ruben Zuzuarregui, Hector
%% @doc @todo Add description to erlangMasterClass.

-module(erlangMasterClass).

-compile(export_all).

%Video 1
%Language processes are very importnat
%Funcional languages can help us to understand this
%How do we process expressions for example?
% (2+(3*v)), we can evaluate expressions, if we give a 
%value to v
%we can compile expressions tu run on a machine

%Video 2: Representing structured data
%% The simplest possible representation would be a string
%% but this is a bad idea, but this doesn't represent a structure
%% it's just a sequence of characters, we humans derive structure.
%% A good form of representing this wpuld be a tree (e.g. parsing tree)
%% In Erlang this tree can be a tuple such as
%% {add{num,2}, {mult, {num,3},{num,4}}}
%% In general all expressions can be represented through type declarations
%% 
-type expr() :: {'num',integer()}
		  |  {'var',atom()}
		  |  {'add', expr(), expr()}
		  |  {'mul', expr(), expr()}.

%% 
%% This gives a clear definition of types
%% 
%% What else can we do with expressions?
%% Parsing-> convert strings to expressions
%% Printing-> structure to string

%% Video 3: pretty printing
%% Convert from expressions to strings
%% How to do this?
%% We have a tree, then from the bottom up we 
%% combine the string, the values flow up the tree
%% 
%% Pretty printing does it top-down:
%% (...+.......)
%% Then we get the values from each branch
%% and put them inside the previous strucutre
%% 
%% Turn an expression into a string:
-spec print(expr())->string().

print({num,N})->
	integer_to_list(N);
print({var,A})->
	atom_to_list(A);
print({add, E1, E2})->
	"("++print(E1)++"+"++print(E2)++")";
print({mul, E1, E2})->
	"("++print(E1)++"*"++print(E2)++")".

%this would correpsond to first
%performin the add evaluation for print, then
%the print for each nested expression and so on

%erlangMasterClass:print({add,{num,2},{mul,{num,3},{num,4}}})
%will print "(2+(3*4))"	

%Video 4: expression evaluation
%To evaluate an expression
%We can evaluate it directly, or first compile it into machine code
%and then execute it. Here we will do this directly.

-spec eval(expr())->integer().

eval({num,N})->
	N;
eval({add,E1,E2})->
	eval(E1)+eval(E2);
eval({mul,E1,E2})->
	eval(E1)*eval(E2).
%but what if we have a variable such as "a"
%in one of the leaves of my expression tree?
%then we need to add an environment whcih combines
%variables and integers, we need somewhere to lookup their values

%when we found the value that we are looking for
%we just return it, otherwise enter the recursion
%will fail with empty lists
-spec lookup(atom(), env())->integer().
lookup(A,[{A,V}|_])->
	V;
lookup(A,[_|Rest])->
	lookup(A,Rest).

%the second eval specifies what to do if we have a variable
%then we look up if it exists in the environment
%and pass it down the recursion
-type env() :: [{atom(),integer()}].
-spec eval(env(), expr()) -> integer().
eval(_Env, {num,N})->
	N;
eval(Env, {var,A})->
	lookup(A, Env);
eval(Env, {add, E1, E2})->
	eval(Env, E1) + eval(Env, E2);
eval(Env, {mult, E1, E2})->
	eval(Env, E1) * eval(Env, E2).

%Video 5: Compile and Run

%a vritual machine has a stack which is manipulated by machine instructions
%for example the push N instruction pushed the integer
%N onto the top of the stack, either literals or variables
%fetch: return the value of the variable
%add: pops top 2 values on the stack, adds them and pushes the result
%mul: does the same as add but with multiplication
%our virtual machine has these 4 instructions
%example: expresion (2+(3*a))
%PUSH2, PUSH3, FETCHA, MUL2, ADD2
%State of the stack after each operation ($ is the bottom of the stack
%PUSH 2: $,2
%PUSH 3: $,2,3
%FETCH a: $,2,3,4 (assuming a has a value of 4)
%MUL: $,2,12
%ADD: $,14

%% How do we implement this in Erlang
%% 1. How to model machine instructions
%% 2. How to model the running of the machine
%% 3. How to compile an expression into a sequence of instrucions
%% 
%% How to represent these things as types:

-type instr():: {'push', integer()}
		  | {'fetch', atom()}
		  |{'add2'}
		  |{'mul2'}.

%list of instructions represents a program
-type program() :: [instr()].

%list of integers to represent the stack
-type stack() :: [integer()].



%take a program and an environment to look up values
%and variables
%% -spec run(program(), env()) -> integer().

%Problem: when we run a complete program 
%it will run with an empty stack
%but in general, the stack wont be empty
%when it starts running, so we must put an 
%additional parameter that describes the state
%of the stack at that point in time
-spec run(program(), env(), stack())->integer().

%one instruction at a time

%match a push instruction
run([{push,N}|Continue], Env, Stack) ->
	run(Continue, Env, [N|Stack]);
run([{fetch,A}|Continue], Env, Stack) ->
	run(Continue, Env, [lookup(A,Env)|Stack]);
%there must be at least 2 values in the stack
run([{add2}|Continue], Env, [N1,N2|Stack]) ->
	run(Continue, Env, [(N1+N2)|Stack]);
%same for the multiplication
run([{mul2}|Continue], Env, [N1,N2|Stack]) ->
	run(Continue, Env, [(N1*N2)|Stack]);
%when there are no more instructions to run
%we just return the value
run([], _Env, [N]) ->
	N.
%the run function is a clear example of tail recursion
%like an imperative loop, running through the program
%one instruction a time, no jumpes

%Compilation

%Numbers and values of variables go on the stack
%To perform 
-spec compile(expr()) -> program().

%compile the code for the first expression
%assume it will put the number on the stack
compile({num,N})->
	[{push,N}];
compile({var,A})->
	[{fetch,A}];
compile({add, E1, E2})->
	compile(E1) ++ compile(E2) ++ [{add2}];
compile({mul, E1, E2})->
	compile(E1) ++ compile(E2) ++ [{mul2}].

%Video 6: Parsing 

%Parsing: taking a string that represents an expression an
%turning it to an expresion
%We must perform something like this parse("2") = {num,2}

%if we try to do something like this
%parse("2+(3*4)") we will get {num,2}, because we don't have parentheses!

%to solve this, we must use build a function that
%takes in {num,2} and then uses what is left of the string
%to parse it correctly in later matchings

-spec parse(string()) -> {expr(), string()}.

%Predictive top-down parsing

parse([$(|Rest]) -> %starts with a '('                           
	{E1,Rest1}     = parse(Rest),  %then an expression          
	[Op|Rest2]     = Rest1, %then an operator, '+' or '*'                 
	{E2,Rest3}     = parse(Rest2), %then another expression           
	[$)|RestFinal] = Rest3, %starts with a ')'                  
	{case Op of
		 $+ -> {add,E1,E2};
		 $* -> {mul,E1,E2}
	 end,
	 RestFinal};

%Other cases
%parse("-123)")=({num,-123}.")")
%parse("variable+3")=({var,variable},"+3")
%In both cases we want to recognise the longest sequence of
%digits or characters

%to recognize literals, strings of alphabetics, numbers
%any sort of initial segment of the list that has a type
parse([Ch|Rest])  when $a =< Ch andalso Ch =< $z ->
	{Succeeds,Remainder} = get_while(fun is_alpha/1,Rest),
	{{var, list_to_atom([Ch|Succeeds])}, Remainder}.

is_alpha(Ch) -> $a =< Ch andalso Ch =< $z.

%this function returns the longest segment of a list with a given
%property/type, we represent the property as a boolean
-spec get_while(fun((T) -> boolean()),[T]) -> {[T],[T]}.    

%polymorfic can use it with any type we like
get_while(P,[Ch|Rest]) ->
	case P(Ch) of
		true ->
			{Succeeds,Remainder} = get_while(P,Rest),
			{[Ch|Succeeds],Remainder};
		false ->
			{[],[Ch|Rest]}
	end;
%nothing to look for for empty lisk
get_while(_P,[]) ->
{[],[]}.


%Video 7: Simplification
%% For example, we have the following expression:
%% ((1*b)+(((2*b)+(1*b)*0)))
%% We can simplify by defining that anything mult by 0 is zero
%% and something added to 0 is that thing

zeroA({add, E, {num,0}})->
	E;
zeroA({add,{num,0},E})->
	E;
zeroA(E)->
	E.

mul0({mul,E,{num,1}})->
	E;
mul0({mul,{num,1},E})->
	E;
mul0(E)->
	E.
mulZ({mul,_,{num,0}})->
	{num,0};
mulZ({mul,{num,0},_})->
	{num,0};
mulZ(E)->
	E.

%we must make sure that the simplifications
%are performed throughout the tree and in a specfic order

compose([]) -> 
	fun(E) -> E end;
compose([Rule|Rules])->
	%apply rule then apply rest of the rules
	%called high order function, takes list of rules, returns a single rule as a result
	fun (E) -> 
			 (compose(Rules))(Rule(E)) 
	end.

%list of rules for examples
rules()->
	[fun zeroA/1, fun mul0/1, fun mulZ/1].

%we want to simplify the inner expressions first,
%only then we should apply simplifications to the upper levels
simp(F,{add,E1,E2})->
	F({add,simp(F,E1), simp(F,E2)});
simp(F,{mul,E1,E2})->
	F({mul,simp(F,E1), simp(F,E2)});
simp(_F,E)->
	E.

%we can add another simplification

simplify(E)->
	simp(compose(rules()), E).

%test1
test1() ->
    {add,{mul,{num,1},{var,b}},{mul,{add,{mul,{num,2},{var,b}},{mul,{num,1},{var,b}}},{num,0}}}.
%test2
test2()->
	{mul,{num,0},{add,{num,1},{num,0}}}.
