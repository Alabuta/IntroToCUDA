#include "main.hxx"

int main()
{
    auto [i, j, k] = std::tuple{0, 2, 4};

    glm::vec3 vec3{0, 1, 2};

    std::cout << "Hello CMake!!!! " << k << std::endl;
}
