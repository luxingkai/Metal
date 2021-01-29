//
//  Essentials.m
//  FaceCamera
//
//  Created by tigerfly on 2021/1/29.
//  Copyright © 2021 tigerfly. All rights reserved.
//

#import "Essentials.h"
#import <MetalKit/MetalKit.h>
#import <Metal/Metal.h>
@interface Essentials ()

@end

@implementation Essentials
const unsigned int arrayLength = 1 << 24;
const unsigned int bufferSize = arrayLength * sizeof(float);

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
#pragma mark -- Performing Calculations on a GPU
    
    /*
     Use Metal to find GPUs and perform calculations on them.
     
     In this sample, you’ll learn essential tasks that are used
     in all Metal apps. You’ll see how to convert a simple function
     written in C to Metal Shading Language (MSL) so that it can
     be run on a GPU. You’ll find a GPU, prepare the MSL function
     to run on it by creating a pipeline, and create data objects
     accessible to the GPU. To execute the pipeline against your
     data, create a command buffer, write commands into it, and
     commit the buffer to a command queue. Metal sends the
     commands to the GPU to be executed.
     */
    
    /**
     Write a GPU Function to Perform Calculations

     To illustrate GPU programming, this app adds corresponding
     elements of two arrays together, writing the results to a
     third array. Listing 1 shows a function that performs this
     calculation on the CPU, written in C. It loops over the
     index, calculating one value per iteration of the loop.
     ========================================================
     Listing 1 Array addition, written in C

     void add_arrays(const float* inA,
                     const float* inB,
                     float* result,
                     int length)
     {
         for (int index = 0; index < length ; index++)
         {
             result[index] = inA[index] + inB[index];
         }
     }
     ========================================================

     Each value is calculated independently, so the values
     can be safely calculated concurrently. To perform the
     calculation on the GPU, you need to rewrite this function
     in Metal Shading Language (MSL). MSL is a variant of C++
     designed for GPU programming. In Metal, code that runs on
     GPUs is called a shader, because historically they were
     first used to calculate colors in 3D graphics. Listing 2
     shows a shader in MSL that performs the same calculation
     as Listing 1. The sample project defines this function in
     the add.metal file. Xcode builds all .metal files in the
     application target and creates a default Metal library,
     which it embeds in your app. You’ll see how to load the
     default library later in this sample.
     ========================================================
     Listing 2 Array addition, written in MSL

     kernel void add_arrays(device const float* inA,
                            device const float* inB,
                            device float* result,
                            uint index [[thread_position_in_grid]])
     {
         // the for-loop is replaced with a collection of threads, each of which
         // calls this function.
         result[index] = inA[index] + inB[index];
     }
     ========================================================
     
     Listing 1 and Listing 2 are similar, but there are some
     important differences in the MSL version. Take a closer
     look at Listing 2.

     First, the function adds the kernel keyword, which declares
     that the function is:
     •  A public GPU function. Public functions are the only functions
        that your app can see. Public functions also can’t be
        called by other shader functions.
     •  A compute function (also known as a compute kernel), which
        performs a parallel calculation using a grid of threads.

     The add_arrays function declares three of its arguments with
     the device keyword, which says that these pointers are in the
     device address space. MSL defines several disjoint address
     spaces for memory. Whenever you declare a pointer in MSL,
     you must supply a keyword to declare its address space. Use
     the device address space to declare persistent memory that
     the GPU can read from and write to.

     Listing 2 removes the for-loop from Listing 1, because the
     function is now going to be called by multiple threads in
     the compute grid. This sample creates a 1D grid of threads
     that exactly matches the array’s dimensions, so that each
     entry in the array is calculated by a different thread.

     To replace the index previously provided by the for-loop,
     the function takes a new index argument, with another MSL
     keyword, thread_position_in_grid, specified using C++
     attribute syntax. This keyword declares that Metal should
     calculate a unique index for each thread and pass that
     index in this argument. Because add_arrays uses a 1D grid,
     the index is defined as a scalar integer. Even though the
     loop was removed, Listing 1 and Listing 2 use the same
     line of code to add the two numbers together. If you want
     to convert similar code from C or C++ to MSL, replace the
     loop logic with a grid in the same way.
     */
    
    /**
     Find a GPU

     In your app, a MTLDevice object is a thin abstraction
     for a GPU; you use it to communicate with a GPU. Metal
     creates a MTLDevice for each GPU. You get the default
     device object by calling MTLCreateSystemDefaultDevice.
     In macOS, where a Mac can have multiple GPUs, Metal chooses
     one of the GPUs as the default and returns that GPU’s
     device object. In macOS, Metal provides other APIs that
     you can use to retrieve all of the device objects, but
     this sample just uses the default.
     */
    id<MTLDevice>device = MTLCreateSystemDefaultDevice();
    
    
    /**
     Get a Reference to the Metal Function

     The first thing the initializer does is load the function
     and prepare it to run on the GPU. When you build the app,
     Xcode compiles the add_arrays function and adds it to a
     default Metal library that it embeds in the app. You use
     MTLLibrary and MTLFunction objects to get information
     about Metal libraries and the functions contained in them.
     To get an object representing the add_arrays function,
     ask the MTLDevice to create a MTLLibrary object for the
     default library, and then ask the library for a MTLFunction
     object that represents the shader function.
     */
    id<MTLLibrary>defaultLibrary = [device newDefaultLibrary];
    if (defaultLibrary == nil) {
        return;
    }
    id<MTLFunction>addFunction = [defaultLibrary newFunctionWithName:@"add_arrays"];
    
    
    /**
     Prepare a Metal Pipeline
     
     The function object is a proxy for the MSL function, but
     it’s not executable code. You convert the function into
     executable code by creating a pipeline. A pipeline
     specifies the steps that the GPU performs to complete a
     specific task. In Metal, a pipeline is represented by a
     pipeline state object. Because this sample uses a compute
     function, the app creates a MTLComputePipelineState object.
     
     A compute pipeline runs a single compute function, optionally
     manipulating the input data before running the function, and
     the output data afterwards.

     When you create a pipeline state object, the device object
     finishes compiling the function for this specific GPU. This
     sample creates the pipeline state object synchronously and
     returns it directly to the app. Because compiling does take
     a while, avoid creating pipeline state objects synchronously
     in performance-sensitive code.
     */
    id<MTLComputePipelineState>addFunctionPSO = [device newComputePipelineStateWithFunction:addFunction error:nil];
    
    /**
     Create a Command Queue

     To send work to the GPU, you need a command queue. Metal
     uses command queues to schedule commands. Create a command
     queue by asking the MTLDevice for one.
     */
    id <MTLCommandQueue>commandQueue = [device newCommandQueue];
    
    /**
     Create Data Buffers and Load Data
     
     After initializing the basic Metal objects, you load data
     for the GPU to execute. This task is less performance
     critical, but still useful to do early in your app’s launch.

     A GPU can have its own dedicated memory, or it can share
     memory with the operating system. Metal and the operating
     system kernel need to perform additional work to let you
     store data in memory and make that data available to the
     GPU. Metal abstracts this memory management using resource
     objects. (MTLResource). A resource is an allocation of
     memory that the GPU can access when running commands. Use
     a MTLDevice to create resources for its GPU.

     The sample app creates three buffers and fills the first
     two with random data. The third buffer is where add_arrays
     will store its results.
     
     The resources in this sample are (MTLBuffer) objects,
     which are allocations of memory without a predefined
     format. Metal manages each buffer as an opaque collection
     of bytes. However, you specify the format when you use a
     buffer in a shader. This means that your shaders and your
     app need to agree on the format of any data being passed
     back and forth.

     When you allocate a buffer, you provide a storage mode
     to determine some of its performance characteristics and
     whether the CPU or GPU can access it. The sample app uses
     shared memory (MTLResourceStorageModeShared), which both
     the CPU and GPU can access.

     To fill a buffer with random data, the app gets a pointer
     to the buffer’s memory and writes data to it on the CPU.
     The add_arrays function in Listing 2 declared its arguments
     as arrays of floating-point numbers, so you provide buffers
     in the same format:
     */
    id <MTLBuffer>bufferA = [device newBufferWithLength:bufferSize options:MTLResourceStorageModeShared];
    id <MTLBuffer>bufferB = [device newBufferWithLength:bufferSize options:MTLResourceStorageModeShared];
    id <MTLBuffer>bufferResult = [device newBufferWithLength:bufferSize options:MTLResourceStorageModeShared];
    [self generateRandomFloatData:bufferA];
    [self generateRandomFloatData:bufferB];
    
    /**
     Create a Command Buffer

     Ask the command queue to create a command buffer.
     */
    id<MTLCommandBuffer>commandBuffer = [commandQueue commandBuffer];
    
    /**
     Create a Command Encoder
     
     To write commands into a command buffer, you use a command
     encoder for the specific kind of commands you want to code.
     This sample creates a compute command encoder, which encodes
     a compute pass. A compute pass holds a list of commands that
     execute compute pipelines. Each compute command causes the
     GPU to create a grid of threads to execute on the GPU.
     
     To encode a command, you make a series of method calls on
     the encoder. Some methods set state information, like the
     pipeline state object (PSO) or the arguments to be passed
     to the pipeline. After you make those state changes, you
     encode a command to execute the pipeline. The encoder writes
     all of the state changes and command parameters into the
     command buffer.
     file:///Users/tigerfly/Desktop/FaceCamera/FaceCamera/Metal/9e65eb88-9081-40fc-b2e4-4c72877bfcd4.png
     */
    id<MTLComputeCommandEncoder>computeEncoder = [commandBuffer computeCommandEncoder];
    
    
    /**
     Set Pipeline State and Argument Data
     
     Set the pipeline state object of the pipeline you want the
     command to execute. Then set data for any arguments that
     the pipeline needs to send into the add_arrays function.
     For this pipeline, that means providing references to
     three buffers. Metal automatically assigns indices for
     the buffer arguments in the order that the arguments appear
     in the function declaration in Listing 2, starting with 0.
     You provide arguments using the same indices.
     
     You also specify an offset for each argument. An offset of
     0 means the command will access the data from the beginning
     of a buffer. However, you could use one buffer to store
     multiple arguments, specifying an offset for each argument.

     You don’t specify any data for the index argument because
     the add_arrays function defined its values as being provided
     by the GPU.
     */
    [computeEncoder setComputePipelineState:addFunctionPSO];
    [computeEncoder setBuffer:bufferA offset:0 atIndex:0];
    [computeEncoder setBuffer:bufferB offset:0 atIndex:1];
    [computeEncoder setBuffer:bufferResult offset:0 atIndex:2];
    
    
    /**
     Specify Thread Count and Organization
     
     Next, decide how many threads to create and how to organize
     those threads. Metal can create 1D, 2D, or 3D grids. The
     add_arrays function uses a 1D array, so the sample creates
     a 1D grid of size (dataSize x 1 x 1), from which Metal
     generates indices between 0 and dataSize-1.
     */
    MTLSize gridSize = MTLSizeMake(arrayLength, 1, 1);
    
    /**
     Specify Threadgroup Size
     
     Metal subdivides the grid into smaller grids called
     threadgroups. Each threadgroup is calculated separately.
     Metal can dispatch threadgroups to different processing
     elements on the GPU to speed up processing. You also need
     to decide how large to make the threadgroups for your command.
     */
    NSUInteger threadGroupSize = addFunctionPSO.maxTotalThreadsPerThreadgroup;
    if (threadGroupSize > arrayLength)
    {
        threadGroupSize = arrayLength;
    }
    MTLSize threadgroupSize = MTLSizeMake(threadGroupSize, 1, 1);
    
    
    /**
     Encode the Compute Command to Execute the Threads
     
     Finally, encode the command to dispatch the grid of threads.

     When the GPU executes this command, it uses the state you
     previously set and the command’s parameters to dispatch
     threads to perform the computation.

     You can follow the same steps using the encoder to encode
     multiple compute commands into the compute pass without
     performing any redundant steps. For example, you might
     set the pipeline state object once, and then set arguments
     and encode a command for each collection of buffers to process.
     */
    [computeEncoder dispatchThreads:gridSize
              threadsPerThreadgroup:threadgroupSize];
    
    
    /**
     End the Compute Pass
     
     When you have no more commands to add to the compute pass,
     you end the encoding process to close out the compute pass.
     */
    [computeEncoder endEncoding];
    
    
    /**
     Commit the Command Buffer to Execute Its Commands
     
     Run the commands in the command buffer by committing
     the command buffer to the queue.

     The command queue created the command buffer, so committing
     the buffer always places it on that queue. After you commit
     the command buffer, Metal asynchronously prepares the commands
     for execution and then schedules the command buffer to execute
     on the GPU. After the GPU executes all the commands in the
     command buffer, Metal marks the command buffer as complete.
     */
    [commandBuffer commit];
    
    
    
    /**
     Wait for the Calculation to Complete
     
     Your app can do other work while the GPU is processing your
     commands. This sample doesn’t need to do any additional work,
     so it simply waits until the command buffer is complete.
     
     Alternatively, to be notified when Metal has processed all
     of the commands, add a completion handler to the command
     buffer (addCompletedHandler:), or check the status of a command
     buffer by reading its status property.
     */
    [commandBuffer waitUntilCompleted];
    
    
    /**
     Read the Results From the Buffer
     
     After the command buffer completes, the GPU’s calculations
     are stored in the output buffer and Metal performs any
     necessary steps to make sure the CPU can see them. In a real
     app, you would read the results from the buffer and do
     something with them, such as displaying the results onscreen
     or writing them to a file. Because the calculations are
     only used to illustrate the process of creating a Metal
     app, the sample reads the values stored in the output
     buffer and tests to make sure the CPU and the GPU
     calculated the same results.
     */
    float* a = bufferA.contents;
    float* b = bufferB.contents;
    float* result = bufferResult.contents;
    
    for (unsigned long index = 0; index < arrayLength; index++)
    {
        if (result[index] != (a[index] + b[index]))
        {
            printf("Compute ERROR: index=%lu result=%g vs %g=a+b\n",
                   index, result[index], a[index] + b[index]);
            assert(result[index] == (a[index] + b[index]));
        }
    }
    printf("Compute results as expected\n");
    
    
    
#pragma mark -- Using Metal to Draw a View’s Contents

    /**
     Create a MetalKit view and a render pass to draw the view’s
     contents.

     In this sample, you’ll learn the basics of rendering graphics
     content with Metal. You’ll use the MetalKit framework to create
     a view that uses Metal to draw the contents of the view. Then,
     you’ll encode commands for a render pass that erases the view
     to a background color.
     */
    
    /**
     Prepare a MetalKit View to Draw

     MetalKit provides a class called MTKView, which is a subclass
     of NSView (in macOS) or UIView (in iOS and tvOS). MTKView handles
     many of the details related to getting the content you draw with
     Metal onto the screen.

     An MTKView needs a reference to a Metal device object in order
     to create resources internally, so your first step is to set the
     view’s device property to an existing MTLDevice.
     */
    
    
}

- (void) generateRandomFloatData: (id<MTLBuffer>) buffer
{
    float* dataPtr = buffer.contents;
    
    for (unsigned long index = 0; index < arrayLength; index++)
    {
        dataPtr[index] = (float)rand()/(float)(RAND_MAX);
    }
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
