#ifndef RSTATA_EXCEPTION_H
#define RSTATA_EXCEPTION_H

#include <exception>

class BadCommandException : public std::exception
{
    const char *what() const noexcept
    {
        return "Semantic error\n";
    }
};

class EvalErrorException : public std::exception
{
    const char *what() const noexcept
    {
        return "Runtime error in evaluation\n";
    }
};

class ExitRequestedException : public std::exception
{
  const char *what() const noexcept
  {
    return "Exit requested\n";
  }
};

#endif /* RSTATA_EXCEPTION_H */
