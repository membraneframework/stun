%%%-------------------------------------------------------------------
%%% @author Evgeniy Khramtsov <ekhramtsov@process-one.net>
%%% @copyright (C) 2013, Evgeniy Khramtsov
%%% @doc
%%%
%%% @end
%%% Created :  2 May 2013 by Evgeniy Khramtsov <ekhramtsov@process-one.net>
%%%-------------------------------------------------------------------
-module(stun_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the supervisor
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a supervisor is started using supervisor:start_link/[2,3],
%% this function is called by the new process to find out about
%% restart strategy, maximum restart frequency and child
%% specifications.
%%
%% @spec init(Args) -> {ok, {SupFlags, [ChildSpec]}} |
%%                     ignore |
%%                     {error, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    StunTmpSup = {stun_tmp_sup, {stun_tmp_sup, start_link, []},
		  permanent, infinity, supervisor, [stun_tmp_sup]},
    TurnTmpSup = {turn_tmp_sup, {turn_tmp_sup, start_link, []},
		  permanent, infinity, supervisor, [turn_tmp_sup]},
    TurnSM = {turn_sm, {turn_sm, start_link, []},
	      permanent, 2000, worker, [turn_sm]},
    {ok, {{one_for_one, 10, 1}, [TurnSM, StunTmpSup, TurnTmpSup]}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
