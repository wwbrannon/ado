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
	mkdir -p include

	flex -o lex.yy.cpp --header-file=include/lex.yy.hpp ado.fl

	bison -d -Wall -b ado ado.ypp
	mv location.hh position.hh stack.hh include
	mv ado.tab.hpp include

clean:
	rm -rf build
	rm -f parser.a
