/* Implementation based on https://cnugteren.github.io/tutorial/pages/page3.html
   This kernel appears in a different file from main */
__kernel void myGEMM1(const int M, const int N, const int P,
                      const __global float* A,
                      const __global float* B,
                      __global float* C) {
    
    // Thread identifiers
    const int globalRow = get_global_id(0); // Row ID of C (0..M)
    const int globalCol = get_global_id(1); // Col ID of C (0..N)

    // Compute a single element (loop over K)
    float acc = 0.0f;
    for (int k=0; k<P; k++) {
        acc += A[k*M + globalRow] * B[globalCol*P + k];
    }

    // Store the result
    C[globalCol*M + globalRow] = acc;
}

void main() {

  // Define the matrix dimensions
  const int M = 2000;
  const int N = 3000;
  const int P = 4000;

  // Define OpenCL variables
  cl_int err;
  cl_platform_id platform = 0;
  cl_device_id device = 0;
  cl_device_id devices[MAX_NUM_DEVICES];
  cl_uint numDevices = 0;
  cl_context_properties props[3] = {CL_CONTEXT_PLATFORM, 0, 0};
  cl_context context = 0;
  cl_command_queue queue = 0;
  cl_event event = NULL;
  cl_program program = NULL;
  char deviceName[MAX_DEVICE_NAME];

  // Configure the OpenCL environment
  err = clGetPlatformIDs(1, &platform, NULL);
  err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, 0, NULL, &numDevices);
  err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, numDevices, devices, NULL);
  device = devices[CURRENT_DEVICE];
  props[1] = (cl_context_properties)platform;
  context = clCreateContext(props, 1, &device, NULL, NULL, &err);
  queue = clCreateCommandQueue(context, device, 0, &err);
  err = clGetDeviceInfo(device, CL_DEVICE_NAME, MAX_DEVICE_NAME, deviceName, NULL);
  checkError(err,__LINE__);

  // Read the kernel file from disk
  long sizeHeader, sizeSource;
  char* header = readKernelFile(CL_INCLUDE_FILE, &sizeHeader);
  char* source = readKernelFile(CL_KERNEL_FILE, &sizeSource);
  long size = 2 + sizeHeader + sizeSource;
  char* code = (char*)malloc(size*sizeof(char));
  for (int c=0; c<size; c++) { code[c] = '\0'; }
  strcat(code, header);
  strcat(code, source);
  const char* constCode = code;
  free(header);
  free(source);

  // Compile the kernel file
  program = clCreateProgramWithSource(context, 1, &constCode, NULL, &err);
  checkError(err,__LINE__);
  err = clBuildProgram(program, 0, NULL, COMPILER_OPTIONS, NULL, NULL);

  // Check for compilation errors
  size_t logSize;
  err = clGetProgramBuildInfo(program, device, CL_PROGRAM_BUILD_LOG, 0, NULL, &logSize);
  checkError(err,__LINE__);
  char* messages = (char*)malloc((1+logSize)*sizeof(char));
  err = clGetProgramBuildInfo(program, device, CL_PROGRAM_BUILD_LOG, logSize, messages, NULL);
  checkError(err,__LINE__);
  messages[logSize] = '\0';
  //if (logSize > 10) { printf("## Compiler message: %s\n", messages); }
  free(messages);

  // Retrieve the PTX code from the OpenCL compiler and output it to disk
  size_t binSize;
  err = clGetProgramInfo(program, CL_PROGRAM_BINARY_SIZES, sizeof(size_t), &binSize, NULL);
  checkError(err,__LINE__);
  unsigned char *bin = (unsigned char *)malloc(binSize);
  err = clGetProgramInfo(program, CL_PROGRAM_BINARIES, sizeof(unsigned char *), &bin, NULL);
  checkError(err,__LINE__);
  FILE* file = fopen(CL_PTX_FILE, "wb");
  fwrite(bin, sizeof(char), binSize, file);
  fclose(file);
  free(bin);

  // Prepare OpenCL memory objects
  cl_mem bufA    = clCreateBuffer(context, CL_MEM_READ_ONLY,  M*P*sizeof(*A), NULL, &err);
  cl_mem bufB    = clCreateBuffer(context, CL_MEM_READ_ONLY,  P*N*sizeof(*B), NULL, &err);
  cl_mem bufB_TR = clCreateBuffer(context, CL_MEM_READ_ONLY,  N*P*sizeof(*B), NULL, &err);
  cl_mem bufC    = clCreateBuffer(context, CL_MEM_READ_WRITE, M*N*sizeof(*C), NULL, &err);
  checkError(err,__LINE__);

  // Copy matrices to the GPU (also C to erase the results of the previous run)
  err = clEnqueueWriteBuffer(queue, bufA, CL_TRUE, 0, M*P*sizeof(*A), A, 0, NULL, NULL);
  err = clEnqueueWriteBuffer(queue, bufB, CL_TRUE, 0, P*N*sizeof(*B), B, 0, NULL, NULL);
  err = clEnqueueWriteBuffer(queue, bufC, CL_TRUE, 0, M*N*sizeof(*C), C, 0, NULL, NULL);
  checkError(err,__LINE__);

  // Configure the myGEMM kernel
  char kernelname[100] = "myGEMM1";
  cl_kernel kernel1 = clCreateKernel(program, kernelname, &err);
  checkError(err,__LINE__);

  // Set the kernel arguments
  err = clSetKernelArg(kernel1, 0, sizeof(int), (void*)&M);
  err = clSetKernelArg(kernel1, 1, sizeof(int), (void*)&N);
  err = clSetKernelArg(kernel1, 2, sizeof(int), (void*)&P);
  err = clSetKernelArg(kernel1, 3, sizeof(cl_mem), (void*)&bufA);
  err = clSetKernelArg(kernel1, 4, sizeof(cl_mem), (void*)&bufB);
  err = clSetKernelArg(kernel1, 5, sizeof(cl_mem), (void*)&bufC);

  // Configure the thread/work-group dimensions of the myGEMM kernel
  const size_t local[2] = { TS, TS };
  const size_t global[2] = { (size_t)M, (size_t)N };

  // Run the myGEMM kernel
  err = clEnqueueNDRangeKernel(queue, kernel1, 2, NULL, global, local, 0, NULL, &event);

  // Copy the output matrix C back to the CPU memory
  err = clEnqueueReadBuffer(queue, bufC, CL_TRUE, 0, M*N*sizeof(*C), C, 0, NULL, NULL);
  checkError(err,__LINE__);

  // Free the memory objects
  free(code);
  clReleaseMemObject(bufA);
  clReleaseMemObject(bufB);
  clReleaseMemObject(bufB_TR);
  clReleaseMemObject(bufC);
  clReleaseMemObject(bufA_XL);
  clReleaseMemObject(bufB_TR_XL);
  clReleaseMemObject(bufC_XL);

  // Clean-up OpenCL 
  clReleaseCommandQueue(queue);
  clReleaseContext(context);
  clReleaseProgram(program);
  clReleaseKernel(kernel1);
}

