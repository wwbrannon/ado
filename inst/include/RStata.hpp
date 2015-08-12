#ifndef RSTATA_H
#define RSTATA_H

#include <cstdio>
#include <Rcpp.h>

void raise_condition(const std::string& msg, const std::string& type);

// The main class of node in the AST the parser generates
class ExprNode
{
    public:
        // ctor and dtor
        ExprNode(std::string _type);
        ExprNode(std::initializer_list<std::string> _types);
        virtual ~ExprNode();
        
        // the method to return an R object (atomic vectors are length-1 lists)
        Rcpp::List as_R_object() const;
        
        // methods to add node-specific data
        void addData(std::string _name, std::string value);

        // methods to add children
        void appendChild(std::string _name, ExprNode *_child); // one named child
        void appendChild(ExprNode *_child); // one nameless child
        
        void setChildren(std::initializer_list<ExprNode *> _children); // lots of nameless children
        void setChildren(std::vector<std::string> _names, std::vector<ExprNode *> _children); // lots of named children
        
        // accessor methods
        size_t nChildren();
        size_t nData();

        ExprNode *pop_at_index(unsigned int index);

    private:
        // the node's own data
        std::vector<std::string> types;
        std::map<std::string, std::string> data;
        
        // pointers to the node's children with optional names
        //     o) collisions on "" means it can't be a map
        //     o) children[i] corresponds to names[i] for all i
        std::vector<ExprNode*> children;
        std::vector<std::string> names;
};

#endif /* RSTATA_H */

