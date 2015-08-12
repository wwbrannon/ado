CXFLAGS += -std=c++11 -c -g -O3 -fPIC -Wall -pedantic
CPFLAGS += "-I/usr/share/R/include"
CPFLAGS += "-I/usr/local/lib/R/site-library/Rcpp/include"
CPFLAGS += "-I../../inst/include/"
CPFLAGS += "-I./build"

all: parse.o lex.o
	ar -rcs ado.a build/parse.o build/lex.o \
			build/GeneralStataCmd.o build/MakeGeneralStataCmd.o \
			build/EmbeddedRCmd.o build/RStataDriver.o \
			build/ExprNode.o

parse.o: infra
	g++ $(CPFLAGS) $(CXFLAGS) build/ado.tab.cpp -o build/parse.o 

lex.o: infra
	g++ $(CPFLAGS) $(CXFLAGS) build/lex.yy.cpp -o build/lex.o 

infra: generate
	g++ $(CPFLAGS) $(CXFLAGS) ExprNode.cpp -o build/ExprNode.o
	g++ $(CPFLAGS) $(CXFLAGS) GeneralStataCmd.cpp -o build/GeneralStataCmd.o
	g++ $(CPFLAGS) $(CXFLAGS) MakeGeneralStataCmd.cpp -o build/MakeGeneralStataCmd.o
	g++ $(CPFLAGS) $(CXFLAGS) EmbeddedRCmd.cpp -o build/EmbeddedRCmd.o
	g++ $(CPFLAGS) $(CXFLAGS) RStataDriver.cpp -o build/RStataDriver.o

generate:
	mkdir -p build
	flex -o build/lex.yy.cpp --header-file=build/lex.yy.hpp ado.fl
	bison -d -Wall -b build/ado ado.ypp

clean:
	rm -rf build
	rm -f ado.a

.PHONY: all

