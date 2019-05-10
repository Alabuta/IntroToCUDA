#include <iostream>
#include <vector>
#include <cmath>

//#include <thrust/host_vector.h>
#include <thrust/device_vector.h>


__global__
void add(unsigned int N, float *a, float *b)
{
    auto index = blockIdx.x * blockDim.x + threadIdx.x;
    auto stride = blockDim.x * gridDim.x;

    for (auto i = index; i < N; i += stride)
        a[i] += b[i];
}

//__global__
//void add2(thrust::device_vector<float> &a, thrust::device_vector<float> &b)
//{
//    thrust::transform(a.begin(), a.end(), b.begin(), b.begin(), [] (auto a, auto b)
//    {
//        return a + b;
//    });
//}

void wrapper()
{
    auto constexpr N = 1'048'576u;

    auto constexpr kBLOCK_DIM = 256;
    auto constexpr kGRID_DIM = (N + kBLOCK_DIM - 1) / kBLOCK_DIM;

    /*thrust::device_vector<float> _a(N, 1.f);
    thrust::device_vector<float> _b(N, 2.f);

    add2(_a, _b);*/

    float *a, *b;

    cudaMallocManaged(&a, N * sizeof(float));
    cudaMallocManaged(&b, N * sizeof(float));

    for (auto i = 0u; i < N; ++i) {
        a[i] = 1.f;
        b[i] = 2.f;
    }

    add<<<kGRID_DIM, kBLOCK_DIM>>>(N, a, b);

    cudaDeviceSynchronize();

    auto maxError = 0.f;

    for (auto i = 0u; i < N; ++i)
        maxError = std::fmax(maxError, std::fabs(a[i] - 3.f));

    std::cout << "Max error: " << maxError << std::endl;

    cudaFree(b);
    cudaFree(a);
}
