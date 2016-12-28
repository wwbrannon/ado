#include <cstdio>
#include <Rcpp.h>
#include <testthat.h>
#include "Ado.hpp"

context("Unit tests for ExprNode") {
    test_that("Dummy objects behave correctly") {
        ExprNode *node = new ExprNode();

        expect_true(node->isDummy());
        expect_true(node->nChildren() == 0);
        expect_true(node->nData() == 0);
        expect_true(node->as_R_object().size() == 0);

        delete node;
    }

    test_that("Prepending a named child works") {
        
    }

    test_that("Prepending a nameless child works") {

    }
    
    test_that("Appending a named child works") {

    }
    
    test_that("Appending a nameless child works") {

    }
    
    test_that("Setting named children works") {

    }
    
    test_that("Setting nameless children works") {

    }

    test_that("Adding data works") {

    }

    test_that("pop_at_index works") {

    }
}

