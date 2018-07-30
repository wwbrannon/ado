.PHONY: all regenerate clean

all: parser.a

parser.a: build ExprNode.o AdoDriver.o utils.o lex.o parse.o
	$(AR) -rcs parser.a build/parse.o build/lex.o build/AdoDriver.o \
			   build/utils.o build/ExprNode.o

build:
	mkdir -p build

ExprNode.o: build ExprNode.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) ExprNode.cpp -o build/ExprNode.o

AdoDriver.o: build AdoDriver.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) AdoDriver.cpp -o build/AdoDriver.o

utils.o: build utils.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) utils.cpp -o build/utils.o

lex.o: build lex.yy.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) lex.yy.cpp -o build/lex.o

parse.o: build ado.tab.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) ado.tab.cpp -o build/parse.o

##
## Development-only targets
##

regenerate:
	flex -o lex.yy.cpp --header-file=../../inst/include/lex.yy.hpp ado.fl
	bison -d -Wall -b ado ado.ypp
	mv location.hh position.hh stack.hh ado.tab.hpp ../../inst/include

clean:
	rm -f parser.a
	rm -rf build

