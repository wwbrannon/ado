.PHONY: all

all:
	flex -o ../lex.yy.cpp --header-file=../include/lex.yy.hpp ado.fl
	bison -d -Wall -b ado ado.ypp
	mv location.hh position.hh stack.hh ado.tab.hpp ../include
	mv ado.tab.cpp ..

