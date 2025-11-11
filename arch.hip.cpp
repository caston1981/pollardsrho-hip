#include <hip/hip_runtime.h>
#include <stdio.h>

int main() {
    int deviceCount = 0;
    hipGetDeviceCount(&deviceCount);

    if (deviceCount == 0) {
        printf("$(error no NVIDIA GPUs were detected!)\n");
        return 1;
    }

    hipDeviceProp_t prop;
    hipGetDeviceProperties(&prop, 0);

    printf("GPU_ARCH := %d%d\n", prop.major, prop.minor);
    return 0;
}