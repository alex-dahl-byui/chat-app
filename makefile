ERLC=erlc
ERL=erl
MODS=$(wildcard src/*.erl)

all: compile

compile:
	$(ERLC) -o ebin $(MODS)

clean:
	rm -rf ebin/*.beam