:- use_module(library(settings)).
:- use_module(library(http/http_unix_daemon)).

user:file_search_path(swish, '.').

% :- use_module(swish(lib/logging)).
% :- set_setting_default(http:logfile, 'log/httpd.log').

:- multifile
        swish_config:config/2,                  % Name, Value
	swish_config:source_alias/2,		% Alias, Options
	swish_config:verify_write_access/3.	% Request, File, Options

swish_config:config(show_beware,        false).

:- initialization http_daemon.

:- [swish(swish)].
:- use_module(swish(lib/authenticate)).
:- use_module(swish:swish(lib/swish_debug)).
