#ifndef ADO_H
#define ADO_H

#include <exception>
#include <string>
#include <vector>

#include <Rcpp.h>

/*
 * Utilities
 */

void raise_condition(const std::string& msg, const std::string& type);

std::vector<std::string> split(const std::string &s, char delim);
std::vector<std::string> &split(const std::string &s, char delim,
                                std::vector<std::string> &elems);
std::string trim(const std::string& str, const std::string& what = " ");

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

/*
 * Exceptions
 */

class BadCommandException : public std::exception
{
  public:
    explicit BadCommandException()
    {
      msg = "Unspecified semantic error";
    }
    
    explicit BadCommandException(const std::string& what_arg)
    {
      msg = what_arg;
    }
    explicit BadCommandException(const char *what_arg)
    {
      msg = std::string(what_arg);
    }
    
    const char *what() const noexcept
    {
      return msg.c_str();
    }
    
  private:
    std::string msg;
};

class EvalErrorException : public std::exception
{
  public:
    explicit EvalErrorException()
    {
      msg = "Unknown runtime error in evaluation";
    }
    
    explicit EvalErrorException(const std::string& what_arg)
    {
      msg = what_arg;
    }
    explicit EvalErrorException(const char *what_arg)
    {
      msg = std::string(what_arg);
    }
    
    const char *what() const noexcept
    {
        return msg.c_str();
    }
  
  private:
    std::string msg;
};

class ExitRequestedException : public std::exception
{
  public:
    explicit ExitRequestedException()
    {
      msg = "Exit requested";
    }
    
    explicit ExitRequestedException(const std::string& what_arg)
    {
      msg = what_arg;
    }
    explicit ExitRequestedException(const char *what_arg)
    {
      msg = std::string(what_arg);
    }
    
    const char *what() const noexcept
    {
      return msg.c_str();
    }

  private:
    std::string msg;
};

class ContinueException : public std::exception
{
  public:
    explicit ContinueException()
    {
      msg = "Statement can only be used within a loop";
    }
    
    explicit ContinueException(const std::string& what_arg)
    {
      msg = what_arg;
    }
    explicit ContinueException(const char *what_arg)
    {
      msg = std::string(what_arg);
    }
    
    const char *what() const noexcept
    {
      return msg.c_str();
    }

  private:
    std::string msg;
};

class BreakException : public std::exception
{
  public:
    explicit BreakException()
    {
      msg = "Statement can only be used within a loop";
    }
    
    explicit BreakException(const std::string& what_arg )
    {
      msg = what_arg;
    }
    explicit BreakException(const char* what_arg )
    {
      msg = std::string(what_arg);
    }
    
    const char *what() const noexcept
    {
      return msg.c_str();
    }

  private:
    std::string msg;
};

#endif /* ADO_H */

