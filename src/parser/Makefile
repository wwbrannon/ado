.PHONY: all

CXX = g++

CXXFLAGS += -std=c++11 -c -g -O3 -fPIC -Wall -pedantic

CPPFLAGS += -I/usr/share/R/include
CPPFLAGS += -I/usr/local/lib/R/site-library/Rcpp/include 
CPPFLAGS += -I../../inst/include/
CPPFLAGS += -Ibuild

all: parse.o lex.o
	ar -rcs ado.a build/parse.o build/lex.o \
			build/StataExpr.o build/OptionList.o build/StataOption.o \
			build/GeneralStataCmd.o build/MakeGeneralStataCmd.o \
			build/EmbeddedRCmd.o

parse.o: infra
	bison -d -Wall -b build/ado ado.ypp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) build/ado.tab.cpp -o build/parse.o 

lex.o: infra
	flex -o build/lex.yy.cpp --header-file=build/lex.yy.hpp ado.fl
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) build/lex.yy.cpp -o build/lex.o 

infra:
	mkdir -p build
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) StataExpr.cpp -o build/StataExpr.o
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) OptionList.cpp -o build/OptionList.o
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) StataOption.cpp -o build/StataOption.o
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) GeneralStataCmd.cpp -o build/GeneralStataCmd.o
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) MakeGeneralStataCmd.cpp -o build/MakeGeneralStataCmd.o
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) EmbeddedRCmd.cpp -o build/EmbeddedRCmd.o
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) ImmediateStataCmd.cpp -o build/ImmediateStataCmd.o

clean:
	rm -rf build
	rm -f ado.a

