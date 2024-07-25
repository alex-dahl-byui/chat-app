-module(client).
-export([start/1, send/2, receive_message/0, loop/0]).

start(ClientId) ->
    gen_server:call(server, {register, ClientId}),
    loop().

send(ToClientId, Message) ->
    gen_server:call(server, {send_message, ToClientId, Message}).

receive_message() ->
    receive
        {send_message, Message} ->
            io:format("Received message: ~p~n", [Message]),
            receive_message()
    end.

loop() ->
    receive_message().