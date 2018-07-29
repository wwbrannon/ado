.PHONY: all archive dir infra lex.o parse.o regenerate clean

all: archive

archive: dir infra lex.o parse.o
	$(AR) -rcs parser.a build/parse.o build/lex.o build/AdoDriver.o \
			   build/utils.o build/ExprNode.o

dir:
	mkdir -p build

infra: dir
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) ExprNode.cpp -o build/ExprNode.o
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) AdoDriver.cpp -o build/AdoDriver.o
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) utils.cpp -o build/utils.o

lex.o: dir lex.yy.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) lex.yy.cpp -o build/lex.o

parse.o: dir ado.tab.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) ado.tab.cpp -o build/parse.o

##
## Development-only targets
##

regenerate:
	flex -o lex.yy.cpp --header-file=../../inst/include/lex.yy.hpp ado.fl

	bison -d -Wall -b ado ado.ypp
	mv location.hh position.hh stack.hh ../../inst/include
	mv ado.tab.hpp ../../inst/include

clean:
	rm -f parser.a
	rm -rf build
