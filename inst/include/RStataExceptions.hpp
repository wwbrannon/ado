#ifndef RSTATA_EXCEPTION_H
#define RSTATA_EXCEPTION_H

#include <exception>

class BadCommandException : std::exception
{
    const char *what() const noexcept
    {
        return "Parse error or semantic error\n";
    }
};

class EvalErrorException : std::exception
{
    const char *what() const noexcept
    {
        return "Runtime error in evaluation\n";
    }
};

#endif /* RSTATA_EXCEPTION_H */
