#ifndef STRING_UTIL_H
#define STRING_UTIL_H
#include <string>
#include <vector>

std::vector<std::string> split(const std::string &s, char delim);
std::vector<std::string> &split(const std::string &s, char delim, std::vector<std::string> &elems);
std::string trim(const std::string& str, const std::string& what = " ");

#endif /* STRING_UTIL_H */

