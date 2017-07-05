%% @author isha1_000
%% @doc @todo Add description to bt.


-module(bt).

%% ====================================================================
%% API functions
%% ====================================================================
-export([]).

crea0(Val)->#nodo{valor=Val, izq=undefined, der=undefined}.

insertar(Val, Arbol) when Val == Arbol#nodo.valor ->
	#nodo{valor = Val, der=Arbol#nodo.der, izq=Arbol#nodo.izq};
insertar(Val, Arbol) when Val > Arbol#nodo.valor ->	
	#nodo{valor = Val, der=insertar(Val, Arbol#nodo.der), izq= Arbol#nodo.izq};
insertar(Val, Arbol) when Val < Arbol#nodo.valor ->	
	#nodo{valor = Val, der= Arbol#nodo.der , izq = insertar(Val, Arbol#nodo.izq) };
insertar(Val, Arbol) when Val > Arbol#nodo.valor, Arbol#nodo.der == undefined ->	
	#nodo{valor = Val, der=#nodo{valor=Val, der=undefined, izq=undefined}, izq= Arbol#nodo.izq};
insertar(Val, Arbol) when Val < Arbol#nodo.valor, Arbol#nodo.izq == undefined ->	
	#nodo{valor = Val, der=Arbol#nodo.der, izq=#nodo{valor=Val, der=undefined, izq=undefined}};
insertar(Val, Arbol) when Arbol==undefined ->	
	#nodo{valor = Val, der=undefined, izq=undefined

%% ====================================================================
%% Internal functions
%% ====================================================================


