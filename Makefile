.PHONY: help build shell test check document coverage parser clean clean-build clean-parser

help:
	@echo "ado package development commands"
	@echo ""
	@echo "Docker-based development:"
	@echo "  make build      - Build the Docker development image"
	@echo "  make shell      - Start interactive R session in Docker"
	@echo "  make test       - Run all tests in Docker"
	@echo "  make check      - Run R CMD CHECK in Docker"
	@echo "  make document   - Generate documentation with roxygen2"
	@echo "  make coverage   - Generate code coverage report"
	@echo "  make parser     - Regenerate lexer and parser from Flex/Bison sources"
	@echo ""
	@echo "Cleanup:"
	@echo "  make clean       - Clean all generated files and build artifacts"
	@echo "  make clean-build - Clean R package build artifacts only"
	@echo "  make clean-parser - Clean generated parser files only"

build:
	docker compose build

shell:
	docker compose run --rm dev

test:
	docker compose run --rm dev R -e "devtools::load_all(); devtools::test()"

check:
	docker compose run --rm dev R -e "devtools::check()"

document:
	docker compose run --rm dev R -e "devtools::document()"

coverage:
	docker compose run --rm dev R -e "covr::package_coverage()"

parser:
	docker compose run --rm dev bash -c "cd src/parser && make"

clean-build:
	@echo "Cleaning R package build artifacts..."
	rm -f src/*.o src/*.so src/*.dll
	rm -rf src-*
	rm -rf *.Rcheck
	rm -f *.tar.gz
	rm -rf .Rproj.user
	@echo "Build artifacts cleaned"

clean-parser:
	@echo "Cleaning generated parser files..."
	rm -f src/parser/lex.yy.cpp
	rm -f src/parser/ado.tab.cpp
	rm -f src/parser/ado.tab.hpp
	rm -f src/parser/*.output
	@echo "Parser files cleaned"

clean: clean-build clean-parser
	@echo "Cleaning temporary files..."
	find . -type f -name '*~' -delete
	find . -type f -name '*.swp' -delete
	find . -type f -name '.DS_Store' -delete
	@echo "All generated files cleaned"
