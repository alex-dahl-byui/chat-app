-module(server).
-behaviour(gen_server).

-export([start/0, stop/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
    gen_server:cast(?MODULE, stop).

init([]) ->
    {ok, []}.

handle_call({register, ClientId}, From, State) ->
    NewState = [{ClientId, From} | State],
    {reply, ok, NewState};

handle_call({send_message, ToClientId, Message}, _From, State) ->
    io:format("Handling send_message call~n", []),
    io:format("ToClientId: ~p~n", [ToClientId]),
    io:format("Message: ~p~n", [Message]),
    case lists:keyfind(ToClientId, 1, State) of
        false ->
            {reply, {error, not_found}, State};
        {ToClientId, {ToPid, _AliasRef}} -> % Extract ToPid from the tuple
            gen_server:cast(ToPid, {send_message, Message}),
            {reply, ok, State}
    end.

handle_cast(stop, State) ->
    {stop, normal, ok, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.