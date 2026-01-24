.PHONY: all

all:
	@echo "Regenerating parser from Flex/Bison sources..."
	@echo "Expected warnings: 12 shift/reduce conflicts (see GRAMMAR_NOTES.md)"
	@echo ""
	flex -o ../lex.yy.cpp --header-file=../include/lex.yy.hpp ado.fl
	bison -d -Wall -b ado ado.ypp
	@echo ""
	@echo "If you see exactly 12 shift/reduce conflicts, the build is correct."
	@echo "For details on these conflicts, see GRAMMAR_NOTES.md"
	mv location.hh position.hh stack.hh ado.tab.hpp ../include
	mv ado.tab.cpp ..

