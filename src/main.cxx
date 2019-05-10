#include "main.hxx"

extern void gpgpuWrapper();

void add(std::vector<float> &a, std::vector<float> &b)
{
    std::transform(std::execution::par_unseq, std::begin(a), std::end(a), std::begin(b), std::begin(b), [] (auto a, auto b)
    {
        return a + b;
    });
}

int main()
{
    auto constexpr N = 1'000'000u;

    std::vector<float> a(N, 1.f);
    std::vector<float> b(N, 2.f);

    add(a, b);

    auto differs = std::any_of(std::execution::par_unseq, std::begin(b), std::end(b), [] (auto number)
    {
        auto const expected_value = 3.f;
        auto const max_error = 0.f;

        return std::max(max_error, std::abs(number - expected_value)) != max_error;
    });

    std::cout << std::boolalpha << "Range is different: "s << differs << '\n';

    gpgpuWrapper();
}
