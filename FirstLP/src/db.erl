%% @author karla
%% @doc @todo Add description to db.


-module(db).

%% ====================================================================
%% API functions
%% ====================================================================
-compile([export_all]).
-vsn(1.1).

new()  -> dict:new().

write(Key, Data, Db) -> dict:store(Key, Data, Db).

read(Key, Db) ->
  case dict:find(Key, Db) of
    error      -> {error, instance};
    {ok, Data} -> {ok, Data}
  end.

delete(Key, Db) -> dict:erase(Key, Db).

destroy(_Db)    -> ok.
