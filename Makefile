NAME=couch_jwt_auth
ERLANG_VERSION=$(shell erl -eval 'erlang:display(erlang:system_info(version)), halt().' -noshell | sed 's/"//g')
COUCHDB_VERSION=$(shell erl -eval 'erlang:display(couch_server:get_version(short)), halt().' -noshell | sed 's/"//g')
VERSION=1.0.2
PLUGIN_DIRS=ebin priv
PLUGIN_VERSION_SLUG=$(NAME)-$(VERSION)_$(ERLANG_VERSION)_$(COUCHDB_VERSION)
PLUGIN_DIST=$(PLUGIN_VERSION_SLUG)

all: compile

compile:
	rebar compile

plugin: compile
	mkdir -p $(PLUGIN_DIST)
	cp -r $(PLUGIN_DIRS) $(PLUGIN_DIST)
	tar czf $(PLUGIN_VERSION_SLUG).tar.gz $(PLUGIN_DIST)
	erl -eval 'File = "$(PLUGIN_VERSION_SLUG).tar.gz", {ok, Data} = file:read_file(File),io:format("~s: ~s~n", [File, base64:encode(crypto:sha(Data))]),halt()' -noshell

clean:
	rm -rf $(PLUGIN_DIST) $(PLUGIN_VERSION_SLUG) ebin /priv/*.so deps
