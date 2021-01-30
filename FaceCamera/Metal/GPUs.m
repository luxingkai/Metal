//
//  GPUs.m
//  FaceCamera
//
//  Created by tigerfly on 2021/1/29.
//  Copyright © 2021 tigerfly. All rights reserved.
//

#import "GPUs.h"
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

@interface GPUs ()

@end

@implementation GPUs

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
#pragma mark -- Getting the Default GPU
    
    /*
     Select the system's default GPU device on which to
     run your Metal code.
     
     To use the Metal framework, you start by getting a GPU
     device. All of the objects your app needs to interact
     with Metal come from a MTLDevice that you acquire at
     runtime. iOS and tvOS devices have only one GPU that
     you access by calling MTLCreateSystemDefaultDevice:
     =========================================================
     guard let device = MTLCreateSystemDefaultDevice() else {
     fatalError( "Failed to get the system's default Metal device." )
     }
     =========================================================
     
     On macOS devices that are built with multiple GPUs, like
     Macbook, the system default is the discrete GPU.
     */
    
    
    
#pragma mark -- MTLDevice
    
    /**
     The Metal interface to a GPU that you use to draw
     graphics or do parallel computation.
     
     
     The MTLDevice protocol defines the interface to a GPU.
     You can query a MTLDevice for the unique capabilities it
     offers your Metal app, and use the MTLDevice to issue all
     of your Metal commands. Don't implement this protocol
     yourself; instead, request a GPU from the system at runtime
     using MTLCreateSystemDefaultDevice in iOS or tvOS, and in
     macOS, get a list of available MTLDevice objects using
     MTLCopyAllDevicesWithObserver(handler:). See Getting the
     Default GPU for a full discussion on choosing the right GPU(s).
     
     MTLDevice objects are your go-to object to do anything
     in Metal, so all of the Metal objects your app interacts
     with come from the MTLDevice instances you acquire at
     runtime. MTLDevice-created objects are expensive but
     persistent; many of them are designed to be initialized
     once and reused through the lifetime of your app. However,
     these objects are specific to the MTLDevice that issued them.
     If you use multiple MTLDevice instances or want to switch
     from one MTLDevice to another, you need to create a separate
     set of objects for each MTLDevice.
     */
    
    
    /**
     Acquiring Device Objects
     */
    id<MTLDevice>device = MTLCreateSystemDefaultDevice();
    
    
    /**
     Querying GPU Properties
     */
    NSLog(@"%@",device.name);
    NSLog(@"%@",device.registryID);
    
    
    /**
     Querying Feature Sets and GPU Families
     
     iOS GPU family 1 -> Apple A7 devices
     iOS GPU family 2 -> Apple A8 devices
     iOS GPU family 3 -> Apple A9 devices
     iOS GPU family 4 -> Apple A11 devices
     iOS GPU family 5 -> Apple A12 devices
     */
    BOOL support = [device supportsFamily:MTLGPUFamilyApple6];
    [device supportsFeatureSet:MTLFeatureSet_iOS_GPUFamily1_v1];
    
    
    /**
     Creating Other Metal Objects
     
     Use the device object to create most other objects
     associated with a specific GPU.
     
     Metal represents other GPU-related entities, like compiled
     shaders, memory buffers and textures, as objects. To
     create these GPU-specific objects, you call methods on
     a MTLDevice or you call methods on objects created by a
     MTLDevice. All objects created directly or indirectly by
     a device object are usable only with that device object.
     Apps that use multiple GPUs will use multiple device
     objects and create a similar hierarchy of Metal objects for each.
     
     
     Acceleration Structures for Ray Tracing
     - newAccelerationStructureWithDescriptor:
     Creates a new ray tracing acceleration structure.
     Required.
     
     - newAccelerationStructureWithSize:
     Creates a new acceleration structure with the specified sizes.
     Required.
     
     - accelerationStructureSizesWithDescriptor:
     Gets the minimum sizes for an acceleration structure matching the given descriptor.
     Required.
     
     
     Argument Buffer Encoders
     - newArgumentEncoderWithArguments:
     Creates an argument encoder for a specific array of arguments.
     Required.
     
     
     Binary Shader Archives
     - newBinaryArchiveWithDescriptor:error:
     Creates an object representing a binary archive.
     Required.
     
     
     Buffers
     maxBufferLength
     The maximum size of a buffer, in bytes.
     Required.
     
     - newBufferWithLength:options:
     Allocates a new zero-filled buffer of a given length.
     Required.
     
     - newBufferWithBytes:length:options:
     Allocates a new buffer of a given length and initializes its
     contents by copying existing data into it.
     Required.
     
     - newBufferWithBytesNoCopy:length:options:deallocator:
     Creates a buffer by wrapping an existing contiguous memory allocation.
     Required.
     
     
     Command Queues
     - newCommandQueue
     Creates a command submission queue.
     Required.
     
     - newCommandQueueWithMaxCommandBufferCount:
     Creates a command submission queue with a fixed maximum number
     of uncompleted command buffers.
     Required.
     
     
     Compute Pipelines
     - newComputePipelineStateWithDescriptor:options:completionHandler:
     Asynchronously creates a compute pipeline state object, and
     associated reflection information, using a compute pipeline descriptor.
     Required.
     
     - newComputePipelineStateWithFunction:completionHandler:
     Asynchronously creates a new compute pipeline state object
     using a function object.
     Required.
     
     - newComputePipelineStateWithFunction:options:completionHandler:
     Asynchronously creates a new compute pipeline state object,
     and associated reflection information, using a function object.
     Required.
     
     - newComputePipelineStateWithDescriptor:options:reflection:error:
     Synchronously creates a compute pipeline state object, and
     associated reflection information, using a compute pipeline descriptor.
     Required.
     
     - newComputePipelineStateWithFunction:error:
     Synchronously creates a new compute pipeline state object using a
     function object.
     Required.
     
     - newComputePipelineStateWithFunction:options:reflection:error:
     Synchronously creates a new compute pipeline state object, and
     associated reflection information, using a function object.
     Required.
     
     
     Counter Sample Buffers
     - newCounterSampleBufferWithDescriptor:error:
     Creates a counter sample buffer.
     Required.
     
     
     Depth and Stencil
     - newDepthStencilStateWithDescriptor:
     Creates a new object that contains depth and stencil test state.
     Required.
     
     
     Dynamic Shader Libraries
     - newDynamicLibrary:error:
     Converts a regular Metal library into a dynamic library.
     Required.
     
     - newDynamicLibraryWithURL:error:
     Creates an object representing a dynamic linked library of Metal shader code.
     Required.
     
     
     Events
     - newEvent
     Creates a new event whose use is limited to the device object.
     Required.
     
     - newSharedEvent
     Creates a shareable event.
     Required.
     
     - newSharedEventWithHandle:
     Re-creates a shareable event from a shareable event handle.
     Required.
     
     
     Fences
     - newFence
     Creates a new fence.
     Required.
     
     
     Indirect Command Buffers
     - newIndirectCommandBufferWithDescriptor:maxCommandCount:options:
     Creates an indirect command buffer.
     Required.
     
     
     Rasterization Rate Maps
     - supportsRasterizationRateMapWithLayerCount:
     Returns a Boolean value that indicates whether the device object
     supports the desired number of layers in a rasterization rate map.
     Required.
     
     - newRasterizationRateMapWithDescriptor:
     Creates a rasterization rate map.
     Required.

     
     Render Pipelines
     - newRenderPipelineStateWithDescriptor:completionHandler:
     Asynchronously creates a render pipeline state object.
     Required.
     
     - newRenderPipelineStateWithDescriptor:options:completionHandler:
     Asynchronously creates a render pipeline state object and
     associated reflection information.
     Required.
     
     - newRenderPipelineStateWithDescriptor:error:
     Synchronously creates a render pipeline state object.
     Required.
     
     - newRenderPipelineStateWithDescriptor:options:reflection:error:
     Synchronously creates a render pipeline state object and
     associated reflection information.
     Required.
     
     - newRenderPipelineStateWithTileDescriptor:options:completionHandler:
     Asynchronously creates a render pipeline state object, and
     associated reflection information, for a tile shader.
     Required.
     
     - newRenderPipelineStateWithTileDescriptor:options:reflection:error:
     Synchronously creates a render pipeline state object, and
     associated reflection information, for a tile shader.
     Required.
     
     
     Resource Heaps
     - newHeapWithDescriptor:
     Creates a heap.
     Required.
     
     - heapBufferSizeAndAlignWithLength:options:
     Returns the size and alignment, in bytes, of a buffer sub-allocated
     from a heap.
     Required.
     
     - heapTextureSizeAndAlignWithDescriptor:
     Returns the size and alignment, in bytes, of a texture sub-allocated
     from a heap.
     Required.
     
     
     Samplers
     - newSamplerStateWithDescriptor:
     Creates a sampler state object.
     Required.
     
     
     Shader Libraries
     - newDefaultLibrary
     Creates a library object containing the functions in the app’s
     default Metal library.
     Required.
     
     - newDefaultLibraryWithBundle:error:
     Creates a library object containing the functions stored
     in the default Metal library in the specified bundle.
     Required.
     
     - newLibraryWithFile:error:
     Creates a library object containing the functions in a Metal
     library file at a specified path.
     Required.
     
     - newLibraryWithURL:error:
     Creates a library object containing the functions in a Metal
     library file at a specified URL.
     Required.
     
     - newLibraryWithData:error:
     Creates a library object containing the functions stored in a
     binary data object created from a precompiled Metal library.
     Required.
     
     - newLibraryWithSource:options:completionHandler:
     Creates a library object asynchronously by compiling the
     functions stored in the specified source string.
     Required.
     
     - newLibraryWithSource:options:error:
     Creates a library object synchronously by compiling the
     functions stored in the specified source string.
     Required.

     
     Textures
     - newTextureWithDescriptor:
     Creates a texture.
     Required.
     
     - newTextureWithDescriptor:iosurface:plane:
     Creates a texture using an IOSurface to store the texture data.
     Required.
     
     - newSharedTextureWithDescriptor:
     Create a texture that can be shared across process boundaries.
     Required.
     
     - newSharedTextureWithHandle:
     Creates a texture referencing an existing shared texture.
     Required.
     */
    
    
    /**
     Managing GPU Memory

     currentAllocatedSize
     The current size, in bytes, of all resources allocated on this
     device for this process.
     Required.
     */
    NSLog(@"%lu",(unsigned long)device.currentAllocatedSize);
    
    
    /**
     Reading Timestamps

     - sampleTimestamps:gpuTimestamp:
     Samples the CPU and GPU timestamps.
     Required.
     */
    
    
    /**
     Working with Sparse Texture Tiles

     sparseTileSizeInBytes
     The size of sparse tiles created by this device object,
     measured in bytes.
     Required.
     
     - sparseTileSizeWithTextureType:pixelFormat:sampleCount:
     Returns the dimensions of a sparse tile for a specific texture.
     Required.
     
     - convertSparsePixelRegions:toTileRegions:withTileSize:alignmentMode:numRegions:
     Converts a list of regions, specified in pixel coordinates, to sparse tile units.
     
     - convertSparseTileRegions:toPixelRegions:withTileSize:numRegions:
     Converts a list of regions, specified in sparse tile coordinates, to pixel units.
     */
    NSLog(@"%d", device.sparseTileSizeInBytes);
//    device sparseTileSizeWithTextureType:<#(MTLTextureType)#> pixelFormat:<#(MTLPixelFormat)#> sampleCount:<#(NSUInteger)#>
//    device convertSparseTileRegions:<#(const MTLRegion * _Nonnull)#> toPixelRegions:<#(MTLRegion * _Nonnull)#> withTileSize:<#(MTLSize)#> numRegions:<#(NSUInteger)#>
//    device convertSparsePixelRegions:<#(const MTLRegion * _Nonnull)#> toTileRegions:<#(MTLRegion * _Nonnull)#> withTileSize:<#(MTLSize)#> alignmentMode:<#(MTLSparseTextureRegionAlignmentMode)#> numRegions:<#(NSUInteger)#>
    
    
    
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
