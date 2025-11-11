TARGET    := pollardsrho-hip
HIPCC     := hipcc
ROCM_HOME ?= /opt/rocm
INCLUDES  := -I$(ROCM_HOME)/include
CXXFLAGS  := -O3 -march=native -Wall -std=c++14 -pthread $(INCLUDES)
LDFLAGS   := -L$(ROCM_HOME)/lib
LDLIBS    := -lamdhip64 -lpthread

# Source files (converted from CUDA) - excluding arch.hip.cpp
SRC_HIP   := pollardsrho.hip.cpp secp256k1.hip.cpp
OBJ       := $(SRC_HIP:.cpp=.o)

# GPU Architecture - gfx1201 for AMD Radeon RX 9070
GPU_ARCH ?= gfx1201

$(info Building for GPU architecture: $(GPU_ARCH))

# HIP compiler flags
HIPCCFLAGS = -O3 -g \
             -std=c++14 \
             --offload-arch=$(GPU_ARCH) \
             -pthread \
             -fgpu-rdc \
             $(INCLUDES)

.PHONY: all clean help

all: $(TARGET)

%.o: %.cpp secp256k1.hip.h
	$(HIPCC) $(HIPCCFLAGS) -c $< -o $@

$(TARGET): $(OBJ)
	$(HIPCC) $(HIPCCFLAGS) $(OBJ) -o $@ $(LDFLAGS) $(LDLIBS)

clean:
	rm -f $(TARGET) $(OBJ)

help:
	@echo "Pollard's Rho HIP Makefile"
	@echo "Building for: AMD Radeon RX 9070 (gfx1201)"
	@echo ""
	@echo "Usage:"
	@echo "  make -f Makefile.hip        - Build"
	@echo "  make -f Makefile.hip clean  - Clean"
