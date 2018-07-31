#ifndef ADO_EXCEPTION_H
#define ADO_EXCEPTION_H

#include <exception>

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

#endif /* ADO_EXCEPTION_H */

