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
        ExprNode *node1 = new ExprNode("ado_compound_cmd");
        ExprNode *node2 = new ExprNode("ado_main_cmd");
        ExprNode *node3 = new ExprNode("ado_main_cmd");

        node1->prependChild("foo", node2);
        node1->prependChild("bar", node3);

        expect_false(node1->isDummy());
        expect_true(node1->nChildren() == 2);
        expect_true(node1->as_R_object().size() > 0);

        expect_true(node1->getChildrenNames()[0] == "bar");
        expect_true(node1->getChildrenNames()[1] == "foo");

        expect_true(node1->pop_at_index(0) == node3);
        expect_true(node1->pop_at_index(0) == node2);
    }

    test_that("Prepending a nameless child works") {
        ExprNode *node1 = new ExprNode("ado_compound_cmd");
        ExprNode *node2 = new ExprNode("ado_main_cmd");
        ExprNode *node3 = new ExprNode("ado_main_cmd");

        node1->prependChild(node2);
        node1->prependChild(node3);

        expect_false(node1->isDummy());
        expect_true(node1->nChildren() == 2);
        expect_true(node1->as_R_object().size() > 0);

        expect_true(node1->getChildrenNames()[0] == "");
        expect_true(node1->getChildrenNames()[1] == "");

        expect_true(node1->pop_at_index(0) == node3);
        expect_true(node1->pop_at_index(0) == node2);
    }

    test_that("Appending a named child works") {
        ExprNode *node1 = new ExprNode("ado_compound_cmd");
        ExprNode *node2 = new ExprNode("ado_main_cmd");
        ExprNode *node3 = new ExprNode("ado_main_cmd");

        node1->appendChild("foo", node2);
        node1->appendChild("bar", node3);

        expect_false(node1->isDummy());
        expect_true(node1->nChildren() == 2);
        expect_true(node1->as_R_object().size() > 0);

        expect_true(node1->getChildrenNames()[0] == "foo");
        expect_true(node1->getChildrenNames()[1] == "bar");

        expect_true(node1->pop_at_index(0) == node2);
        expect_true(node1->pop_at_index(0) == node3);
    }

    test_that("Appending a nameless child works") {
        ExprNode *node1 = new ExprNode("ado_compound_cmd");
        ExprNode *node2 = new ExprNode("ado_main_cmd");
        ExprNode *node3 = new ExprNode("ado_main_cmd");

        node1->appendChild(node2);
        node1->appendChild(node3);

        expect_false(node1->isDummy());
        expect_true(node1->nChildren() == 2);
        expect_true(node1->as_R_object().size() > 0);

        expect_true(node1->getChildrenNames()[0] == "");
        expect_true(node1->getChildrenNames()[1] == "");

        expect_true(node1->pop_at_index(0) == node2);
        expect_true(node1->pop_at_index(0) == node3);
    }

    test_that("Setting named children works") {
        ExprNode *node1 = new ExprNode("ado_compound_cmd");
        std::vector<ExprNode*> children;
        std::vector<std::string> names;
        int i;

        i = 0;
        while(i < 10)
        {
            children.push_back(new ExprNode("ado_main_cmd"));
            i++;
        }

        expect_error(node1->setChildren(names, children));

        i = 0;
        while(i < 10)
        {
            names.push_back(std::to_string(i));
            i++;
        }

        node1->setChildren(names, children);

        expect_false(node1->isDummy());
        expect_true(node1->nChildren() == 10);
        expect_true(node1->as_R_object().size() > 0);

        i = 0;
        while(i < 10)
        {
            expect_true(node1->getChildrenNames()[i] == std::to_string(i));
            i++;
        }
    }

    test_that("Setting nameless children works") {
        ExprNode *node1 = new ExprNode("ado_compound_cmd");
        std::vector<ExprNode*> lst;
        int i;

        i = 0;
        while(i < 10)
        {
            lst.push_back(new ExprNode("ado_main_cmd"));
            i++;
        }

        node1->setChildren(lst);

        expect_false(node1->isDummy());
        expect_true(node1->nChildren() == 10);
        expect_true(node1->as_R_object().size() > 0);

        i = 0;
        while(i < 10)
        {
            expect_true(node1->getChildrenNames()[i] == "");
            i++;
        }
    }

    test_that("Adding data works") {
        ExprNode *node1 = new ExprNode("ado_compound_cmd");
        std::map<std::string,std::string> mp;
        int i = 0;

        while(i < 10)
        {
            node1->addData(std::to_string(i), std::to_string(i+1));
            i++;
        }

        i = 0;
        mp = node1->getData();
        for (std::map<std::string,std::string>::iterator it = mp.begin(); it != mp.end(); it++)
        {
            expect_true(it->first == std::to_string(i));
            expect_true(it->second == std::to_string(i+1));

            i++;
        }
    }
}
