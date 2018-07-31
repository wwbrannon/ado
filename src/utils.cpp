#include <sstream>
#include <string>
#include <vector>

std::vector<std::string> &
split(const std::string &s, char delim, std::vector<std::string> &elems) {
    std::stringstream ss(s);
    std::string item;
    while (std::getline(ss, item, delim)) {
        elems.push_back(item);
    }
    return elems;
}

std::vector<std::string>
split(const std::string &s, char delim) {
    std::vector<std::string> elems;
    split(s, delim, elems);
    return elems;
}

std::string
trim(const std::string& str, const std::string& what)
{
    size_t start = str.find_first_not_of(what);
    size_t end = str.find_last_not_of(what);
    size_t len = end - start + 1;

    if (start == std::string::npos)
        return "";

    return str.substr(start, len);
}

