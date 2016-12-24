CXFLAGS = -c -fPIC -pedantic -std=c++11
CPFLAGS = "-I/usr/share/R/include" \
		  "-I/usr/local/lib/R/site-library/Rcpp/include" \
		  "-I../../inst/include/" "-I./build" "-I./include"

all: infra lex.o parse.o
	ar -rcs parser.a build/parse.o build/lex.o \
			build/AdoDriver.o build/ExprNode.o

parse.o: dir ado.tab.cpp
	g++ $(CPFLAGS) $(CXFLAGS) ado.tab.cpp -o build/parse.o

lex.o: dir lex.yy.cpp
	g++ $(CPFLAGS) $(CXFLAGS) lex.yy.cpp -o build/lex.o

infra: dir
	g++ $(CPFLAGS) $(CXFLAGS) ExprNode.cpp -o build/ExprNode.o
	g++ $(CPFLAGS) $(CXFLAGS) AdoDriver.cpp -o build/AdoDriver.o

dir:
	mkdir -p build

regenerate:
	mkdir -p include
	
	flex -o lex.yy.cpp --header-file=include/lex.yy.hpp ado.fl
	
	bison -d -Wall -b ado ado.ypp
	mv location.hh position.hh stack.hh include
	mv ado.tab.hpp include

clean:
	rm -rf build
	rm -f parser.a

.PHONY: all

