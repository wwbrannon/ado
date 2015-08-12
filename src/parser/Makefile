.PHONY: all

CPPFLAGS += -I/usr/share/R/include
CPPFLAGS += -I/usr/local/lib/R/site-library/Rcpp/include 
CPPFLAGS += -I../../inst/include/ -Ibuild

CXXFLAGS += -c -g -O3 -Wall -fPIC -pedantic -pipe -Wno-unused

all: parse.o lex.o
	ar -rcs ado.a build/parse.o build/lex.o

parse.o:
	mkdir -p build
	bison -d -b build/ado ado.ypp
	g++ $(CPPFLAGS) $(CXXFLAGS) build/ado.tab.cpp -o build/parse.o 

lex.o:
	mkdir -p build
	flex -o build/lex.yy.cpp --header-file=build/lex.yy.hpp ado.fl
	g++ $(CPPFLAGS) $(CXXFLAGS) build/lex.yy.cpp -o build/lex.o 

clean:
	rm -rf build
	rm -f ado.a

