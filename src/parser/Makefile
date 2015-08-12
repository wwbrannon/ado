.PHONY: all

CXX = g++

CXXFLAGS += -c -g -O3 -Wall -fPIC -pedantic -pipe -Wno-unused

CPPFLAGS += -I/usr/share/R/include
CPPFLAGS += -I/usr/local/lib/R/site-library/Rcpp/include 
CPPFLAGS += -I../../inst/include/ -Ibuild

all: parse.o lex.o
	ar -rcs ado.a build/parse.o build/lex.o build/GeneralStataCmd.o build/MakeGeneralStataCmd.o build/StataExpr.o

parse.o: infra
	bison -d -Wall -b build/ado ado.ypp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) build/ado.tab.cpp -o build/parse.o 

lex.o: infra
	flex -o build/lex.yy.cpp --header-file=build/lex.yy.hpp ado.fl
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) build/lex.yy.cpp -o build/lex.o 

infra:
	mkdir -p build
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) GeneralStataCmd.cpp -o build/GeneralStataCmd.o
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) MakeGeneralStataCmd.cpp -o build/MakeGeneralStataCmd.o
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) StataExpr.cpp -o build/StataExpr.o

clean:
	rm -rf build
	rm -f ado.a

