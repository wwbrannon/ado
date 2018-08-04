#ifndef ADO_H
#define ADO_H

#include <exception>
#include <string>
#include <vector>

#include <Rcpp.h>

// flags you can bitwise OR to enable debugging features
#define DEBUG_PARSE_TRACE       4
#define DEBUG_MATCH_CALL        8
#define DEBUG_VERBOSE_ERROR     16
#define DEBUG_NO_PARSE_ERROR    32
#define DEBUG_NO_CALLBACKS      64

/*
 * The main class of node in the AST the parser generates
 */

class ExprNode
{
    public:
        // ctor and dtor
        ExprNode();
        ExprNode(std::string _type);
        ExprNode(std::initializer_list<std::string> _types);
        virtual ~ExprNode();

        // the method to return an R object (atomic vectors are length-1 lists)
        Rcpp::List as_R_object() const;

        // methods to add node-specific data
        void addData(std::string _name, std::string value);

        // methods to add children
        void prependChild(std::string _name, ExprNode *_child); // one named child
        void prependChild(ExprNode *_child); // one nameless child
        void appendChild(std::string _name, ExprNode *_child); // one named child
        void appendChild(ExprNode *_child); // one nameless child

        void setChildren(std::vector<ExprNode *> _children); // lots of nameless children
        void setChildren(std::vector<std::string> _names, std::vector<ExprNode *> _children); // lots of named children

        // accessor methods
        bool   isDummy();
        size_t nChildren();
        size_t nData();

        std::vector<ExprNode*> getChildren();
        std::vector<std::string> getChildrenNames();
        std::map<std::string, std::string> getData();

        ExprNode *pop_at_index(unsigned int index);

    private:
        ExprNode(const ExprNode& that); // no copy ctor
        ExprNode& operator=(ExprNode const &); // no assignment

        bool dummy; // is this a "dummy" node we need to simplify the parser?

        // the node's own data
        std::vector<std::string> types;
        std::map<std::string, std::string> data;

        // pointers to the node's children with optional names
        //     o) collisions on "" means it can't be a map
        //     o) children[i] corresponds to names[i] for all i
        std::vector<ExprNode*> children;
        std::vector<std::string> names;
};

class ParseDriver
{
    public:
        ParseDriver(std::string text, Rcpp::Environment context,
                    int debug_level, int echo);
        ~ParseDriver();

        Rcpp::Environment context;

        int error_seen;
        int debug_level;
        int echo;

        int parse();

        void set_ast(ExprNode *node);
        Rcpp::List get_ast();

        void wrap_cmd_action(ExprNode *node);
        std::string get_macro_value(std::string name);
        void push_echo_text(std::string echo_text);

        void error(int lineno, int col, const std::string& m);
        void error(const std::string& m);

    private:
        ParseDriver(const ParseDriver& that); // no copy ctor
        ParseDriver& operator=(ParseDriver const&); // no assignment

        ExprNode *ast;
        std::string text;
        std::string echo_text_buffer;
};

#endif /* ADO_H */

