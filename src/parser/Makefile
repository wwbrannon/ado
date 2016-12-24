CXFLAGS = -std=c++11 -c -g -O3 -fPIC -Wall -pedantic
CPFLAGS = "-I/usr/share/R/include" \
		  "-I/usr/local/lib/R/site-library/Rcpp/include" \
		  "-I../../inst/include/" "-I./build"

all: infra lex.o parse.o
	ar -rcs parser.a build/parse.o build/lex.o \
			build/AdoDriver.o build/ExprNode.o

parse.o: generate
	g++ $(CPFLAGS) $(CXFLAGS) build/ado.tab.cpp -o build/parse.o

lex.o: generate
	g++ $(CPFLAGS) $(CXFLAGS) build/lex.yy.cpp -o build/lex.o

infra: generate
	g++ $(CPFLAGS) $(CXFLAGS) ExprNode.cpp -o build/ExprNode.o
	g++ $(CPFLAGS) $(CXFLAGS) AdoDriver.cpp -o build/AdoDriver.o

generate:
	mkdir -p build
	flex -o build/lex.yy.cpp --header-file=build/lex.yy.hpp ado.fl
	bison -d -Wall -b build/ado ado.ypp

clean:
	rm -rf build
	rm -f parser.a

.PHONY: all

