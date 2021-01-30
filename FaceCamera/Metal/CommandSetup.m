//
//  CommandSetup.m
//  FaceCamera
//
//  Created by tigerfly on 2021/1/29.
//  Copyright © 2021 tigerfly. All rights reserved.
//

#import "CommandSetup.h"

@interface CommandSetup ()

@end

@implementation CommandSetup

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
#pragma mark -- Setting Up a Command Structure
    
    /**
     Discover how Metal executes commands on a GPU.

     To get the GPU to perform work on your behalf, you send
     commands to it. A command performs the drawing, parallel
     computation, or resource management work your app requires.
     The relationship between Metal apps and a GPU is that of
     a client-server pattern:

     •  Your Metal app is the client.
     •  The GPU is the server.
     •  You make requests by sending commands to the GPU.
     •  After processing the commands, the GPU can notify your app
        when it's ready for more work.
     
     Figure 1 Client-server usage pattern when using Metal.
     file:///Users/tigerfly/Desktop/FaceCamera/FaceCamera/Metal/6411df7f-4f5c-46d6-9573-c2c6dd10fffb.png

     To send commands to a GPU, you add them to a command buffer
     using a command encoder object. You add the command buffer
     to a command queue and then commit the command buffer when
     you're ready for Metal to execute the command buffer's
     commands. The order that you place commands in command buffers,
     enqueue and commit command buffers, is important because it
     effects the perceived order in which Metal promises to
     execute your commands.

     The following sections cover the steps to set up a working
     command structure, ordered in the way you create objects
     to interact with Metal.
     */
    
    /**
     Make Initialization-Time Objects

     You create some Metal objects at initialization and normally
     keep them around indefinitely. Those are the command queue,
     and pipeline objects. You create them once because they're
     expensive to set up, but once initialized, they're fast to
     reuse.
     */
    
    /**
     Make a Command Queue
     
     To make a command queue, call the device's newCommandQueue function:
     ====================================================
     commandQueue = device.makeCommandQueue()
     ====================================================
     Because you typically reuse the command queue, make a
     strong reference to it. You use the command queue to
     hold command buffers, as seen here:

     Figure 2 Your app's command queue.
     file:///Users/tigerfly/Desktop/FaceCamera/FaceCamera/Metal/27dc137c-d852-461e-aff2-e93ab71f44e9.png
     */
    
    
    /**
     Make One or More Pipeline Objects

     A pipeline object tells Metal how to process your commands.
     The pipeline object encapsulates functions that you write
     in the Metal shading language. Here's how pipelines fit
     into your Metal workflow:
     •  You write Metal shader functions that process your data.
     •  Create a pipeline object that contains your shaders.
     •  When you're ready to use it, enable the pipeline.
     •  Make draw, compute, or blit calls.
     
     Metal doesn't perform your draw, compute, or blit calls
     immediately; instead, you use an encoder object to insert
     commands that encapsulate those calls into your command
     buffer. After you commit the command buffer, Metal sends
     it to the GPU and uses the active pipeline object to
     process its commands.

     Figure 3 The active pipeline on the GPU containing your
     custom shader code that processes commands.
     file:///Users/tigerfly/Desktop/FaceCamera/FaceCamera/Metal/9e68fba0-6dd4-4bc6-92a9-da1646f742d4.png
     */
    
    
    /**
     Issue Commands to the GPU
     
     With your command queue and pipeline(s) set up, it's time
     for you to issue commands to the GPU. Here's the process
     you follow:
     1. Create a command buffer.
     2. Fill the buffer with commands.
     3. Commit the command buffer to the GPU.

     If you're performing animation as part of a rendering loop,
     you do this for every frame of the animation. You also
     follow this process to execute one-off image processing,
     or machine learning tasks.

     The following subsections walk you through these steps in
     detail.
     */
    
    /**
     Create a Command Buffer

     Create a command buffer by calling commandBuffer on
     the command queue:
     ====================================================
     Listing 2 Creating a command buffer.
     guard let commandBuffer = commandQueue.makeCommandBuffer() else {
         return
     }
     ====================================================
     For single-threaded apps, you create a single command buffer.
     Figure 4 shows the relationship between commands and their
     command buffer:
     
     Figure 4 A command buffer's relationship to the commands it contains.
     file:///Users/tigerfly/Desktop/FaceCamera/FaceCamera/Metal/5b88782f-d94e-45a2-833c-c8570dbb7b84.png
     */
    
    /**
     Add Commands to the Command Buffer

     When you call task-specific functions on an encoder object–like
     draws, compute or blit operations–the encoder places commands
     corresponding to those calls in the command buffer. The encoder
     encodes the commands to include everything the GPU needs to
     process the task at runtime. Figure 5 shows the workflow:
     
     Figure 5 Command encoder inserting commands into a command
     buffer as the result of a draw.
     file:///Users/tigerfly/Desktop/FaceCamera/FaceCamera/Metal/cef5cd2d-1e3a-4fd8-b114-2ee84324d157.png
     
     You encode actual commands with concrete subclasses of
     MTLCommandEncoder, depending on your task:
     •  Use MTLRenderCommandEncoder to issue render commands.
     •  Use MTLComputeCommandEncoder to issue parallel computation commands.
     •  Use MTLBlitCommandEncoder to issue resource management commands.
     
     See Using a Render Pipeline to Render Primitives for a complete
     rendering example. See Processing a Texture in a Compute Function
     for a complete parallel processing example.
     */
    
    
    /**
     Commit a Command Buffer
     
     To enable your commands to run, you commit the command buffer
     to the GPU:
     =========================================================
     commandBuffer.commit()
     =========================================================
     
     Committing a command buffer doesn't run its commands
     immediately. Instead, Metal schedules the buffer's commands
     to run only after you commit prior command buffers that
     are waiting in the queue. If you haven't explicitly enqueued
     a command buffer, Metal does that for you once you commit
     the buffer.

     You don't reuse a buffer after it's committed, but you can
     opt into notification of its scheduling, completion, or
     query its status.

     The promise upheld by Metal is that the perceived order
     in which commands are executed is the same as the way you
     ordered them. While Metal might reorder some of your
     commands before processing them, this normally only occurs
     when there's a performance gain and no other perceivable
     impact.
     */
    
    
    
#pragma mark -- Preparing Your Metal App to Run in the Background
    
    /**
     Prepare your app to move into the background by pausing
     future GPU use and ensuring previous work is scheduled.

     iOS and tvOS restrict a background app's access to the
     GPU, to guarantee foreground app performance. If a Metal
     command queue tries to schedule command buffers after
     the app moves in the background, the system prevents
     those commands from executing. When UIKit notifies you
     that your app is being suspended or moved into the
     background, your app must restrict its use of Metal.

     For more information on the UIKit app life cycle, see
     Preparing Your UI to Run in the Background.
     */
    
    /**
     Disable Code that Commits New Command Buffers

     When your app is deactivated, stop sending work to
     Metal. Enable that code only after your app is reactivated.

     After the system notifies your app that it is being
     deactivated, you have some time before the system
     restricts your app from using Metal. You can schedule
     additional commands if that work is critical to prepare
     your app to be in the background state. Similarly, if
     your app was already in the middle of encoding commands,
     your app can typically finish the current task before
     disabling further work. For example, if your app renders
     frames of animation to the screen, and you receive the
     notification while you're encoding commands for a new
     frame, you can finish encoding that frame before
     disabling your rendering code.
     */
    
    /**
     Ensure All Previous Work is Scheduled for Execution

     When UIKit calls your app delegate's
     applicationDidEnterBackground: method, make sure Metal
     has scheduled all command buffers you've already
     committed before your app returns control to the system.
     On each command queue, if the last command buffer you
     queued isn't already scheduled or complete, call
     waitUntilScheduled to force it to be scheduled.

     If you're in the middle of encoding a new command
     buffer, you can combine these steps. Finish encoding
     commands to render the frame and commit the command
     buffer, then call waitUntilScheduled.

     After your app moves into the background, if Metal
     sees a new command buffer from your app, it returns
     an error, rather than scheduling the command buffer.
     You can test for this error by adding a completion
     handler (addCompletedHandler:). Inside your completion
     handler, check the status and error properties.
     */
    
    
#pragma mark -- MTLCommandQueue
    
    /**
     A queue that organizes command buffers for the GPU to
     execute.

     A MTLCommandQueue object queues an ordered list of command
     buffers for a MTLDevice to execute. Command queues are
     thread-safe and allow multiple outstanding command buffers
     to be encoded simultaneously.

     You don't define classes that implement this protocol.
     To create a command queue, call the newCommandQueue or
     newCommandQueueWithMaxCommandBufferCount: method of a
     MTLDevice object. The queue returned by
     newCommandQueueWithMaxCommandBufferCount: method restricts
     the number of uncompleted command buffers. Typically,
     you create one or more command queues when your app
     launches and then keep those queues around throughout
     the lifetime of your app.

     To render images or execute compute operations, use
     the command queue to create one or more command buffer
     objects, then encode commands into those objects and
     commit them to the queue. There are two methods to
     create MTLCommandBuffer objects: commandBuffer and
     commandBufferWithUnretainedReferences. In most cases,
     you use the commandBuffer method, because it creates
     a command buffer that holds a strong reference to
     any objects that Metal needs to finish executing the
     commands encoded in the command buffer. In very rare
     situations, you use the commandBufferWithUnretainedReferences
     method to create a command buffer that doesn’t keep
     strong references to these objects. In this case, you’re
     responsible for keeping these objects alive until the
     commands encoded in the command buffer have finished
     executing.
     */
    
    /**
     Creating Command Buffers
     
     - commandBuffer
     Creates a command buffer.
     Required.
     
     - commandBufferWithUnretainedReferences
     Creates a command buffer that doesn't hold strong references
     to any objects required to execute the command buffer.
     Required.
     
     - commandBufferWithDescriptor:
     Creates a command buffer using the specified description.
     Required.
     */
    
    /**
     Identifying the Command Queue

     device
     The device from which the command queue was created.
     Required.
     
     label
     A string that identifies the command queue.
     Required.
     */

  
#pragma mark -- MTLCommandBuffer
    
    /**
     A container that stores encoded commands for the
     GPU to execute.

     Don't implement this protocol yourself; instead,
     create command buffer objects by calling a
     MTLCommandQueue object’s commandBuffer method.
     The command buffer can only be committed for
     execution on the command queue that created it.
     All command buffers sent to a single command queue
     are guaranteed to execute in the order in which
     the command buffers were enqueued.

     After creating a command buffer, you create encoder
     objects to fill the buffer with commands. The
     MTLCommandBuffer protocol has methods to create
     specific types of command encoders:
     MTLRenderCommandEncoder, MTLComputeCommandEncoder,
     MTLBlitCommandEncoder, and MTLParallelRenderCommandEncoder.
     At any given time, only a single encoder may be active
     for a particular command buffer. You create an encoder,
     use it to add commands to the buffer, and then end the
     encoding process. After you finish with an encoder,
     you can create another encoder and continue to add
     commands to the same buffer. When you are ready to
     execute the set of encoded commands, call the command
     buffer’s commit method to schedule the buffer for
     execution.

     After a command buffer has been committed for
     execution, the only valid operations on the command
     buffer are to wait for it to be scheduled or
     completed (using synchronous calls or handler blocks)
     and to check the status of the command buffer
     execution. When used, scheduled and completed handlers
     are blocks that are invoked in execution order. These
     handlers should perform quickly; if expensive or
     blocking work needs to be scheduled, defer that work
     to another thread.

     In a multithreaded app, it’s advisable to break your
     overall task into subtasks that can be encoded
     separately. Create a command buffer for each chunk of
     work, then call the enqueue method on these command
     buffer objects to establish the order of execution.
     Fill each buffer object (using multiple threads) and
     commit them. The command queue automatically schedules
     and executes these command buffers as they become
     available.
     */
    
    /**
     Creating Command Encoders
     
     - renderCommandEncoderWithDescriptor:
     Creates an object from a descriptor to encode a rendering
     pass into the command buffer.
     Required.
     
     - parallelRenderCommandEncoderWithDescriptor:
     Creates an object that can split the work of encoding
     commands for a single render pass.
     Required.
     
     - computeCommandEncoderWithDescriptor:
     Creates an object from a descriptor to encode a compute
     pass into the command buffer.
     Required.
     
     - computeCommandEncoderWithDispatchType:
     Creates an object to encode a compute pass into the
     command buffer.
     Required.
     
     - computeCommandEncoder
     Creates an object to encode a sequential compute pass
     into the command buffer.
     Required.
     
     - blitCommandEncoder
     Creates an object to encode a block information transfer
     (blit) pass into the command buffer.
     Required.
     
     - blitCommandEncoderWithDescriptor:
     Creates an object from a descriptor to encode a block
     information transfer (blit) pass into the command buffer.
     Required.
     
     - resourceStateCommandEncoder
     Creates an object to encode a resource state pass into
     the command buffer.
     Required.
     
     - resourceStateCommandEncoderWithDescriptor:
     Creates an object from a descriptor to encode resource
     state pass into the command buffer.
     Required.
     
     - accelerationStructureCommandEncoder
     Creates an object to encode an acceleration structure
     pass into the command buffer.
     Required.
     
     MTLDispatchType
     Constants indicating how the compute command encoder's
     commands are dispatched.
     */
    
    /**
     Identifying the Command Buffer

     device
     The device from which this command buffer was created.
     Required.
     
     commandQueue
     The command queue that created the command buffer.
     Required.
     
     label
     A string that identifies this object.
     Required.
     */
    
    /**
     Scheduling and Executing Commands

     - enqueue
     Reserves a place for the command buffer on the associated
     command queue.
     Required.
     
     - commit
     Commits the command buffer for execution.
     Required.
     
     - addScheduledHandler:
     Registers a block of code that Metal calls immediately
     after it schedules the command buffer for execution on the GPU.
     
     Required.
     - addCompletedHandler:
     Registers a block of code that Metal calls immediately after
     the GPU finishes executing the commands in the command buffer.
     Required.
     
     - waitUntilScheduled
     Blocks execution of the current thread until the command
     buffer is scheduled.
     Required.
     
     - waitUntilCompleted
     Blocks execution of the current thread until execution of
     the command buffer is completed.
     Required.
     
     MTLCommandBufferHandler
     A block of code invoked when a command buffer is scheduled
     for execution or has completed execution.
     */
    
    /**
     Grouping Commands in a GPU Frame Capture

     - pushDebugGroup:
     A string that identifies this object.
     Required.
     
     - popDebugGroup
     A string that identifies this object.
     Required.
     */

    /**
     Presenting a Drawable

     - presentDrawable:
     Registers a drawable presentation to occur as soon as possible.
     Required.
     
     - presentDrawable:afterMinimumDuration:
     Registers a drawable presentation to occur after waiting
     for the previous drawable to meet the minimum display time.
     Required.
     
     - presentDrawable:atTime:
     Registers a drawable presentation to occur at a specific host time.
     Required.
     */
    
    /**
     Checking Execution Status

     status
     The current stage in the lifetime of the command buffer.
     Required.
     
     errorOptions
     Settings that determine what and how the command buffer
     records information about execution errors.
     Required.
     
     error
     The error that occurred when the command buffer was executed.
     Required.
     */

    
    /**
     Reading Logged Execution Messages
     
     logs
     Logged messages that were recorded when the queue executed
     the command buffer.
     Required.
     
     MTLLogContainer
     A collection of logged messages, created when a Metal device
     object executes a command buffer.
     
     MTLFunctionLog
     A log entry generated when the Metal device object executed
     a command buffer.
     */
    
    /**
     Obtaining CPU and GPU Execution Timestamps
     
     kernelStartTime
     The host time, in seconds, when the CPU began scheduling
     this command buffer for execution.
     Required.
     
     kernelEndTime
     The host time, in seconds, when the CPU finished
     scheduling this command buffer for execution.
     Required.
     
     GPUStartTime
     The host time, in seconds, when the GPU began executing
     this command buffer.
     Required.
     
     GPUEndTime
     The host time, in seconds, when the GPU finished executing
     this command buffer.
     Required.
     */
    
    
    /**
     Synchronizing Events

     - encodeSignalEvent:value:
     Encodes a command that signals the given event, updating
     it to a new value.
     Required.
     
     - encodeWaitForEvent:value:
     Encodes a command that blocks the execution of the command
     buffer until the given event reaches the given value.
     Required.
     */
    
    /**
     Determining Whether to Keep Strong References
     
     retainedReferences
     A Boolean value that indicates whether the command buffer
     maintains strong references to associated resource objects
     (textures, buffers) necessary to complete execution of
     any encoded commands.
     Required.
     */
    
    
#pragma mark -- MTLCommandEncoder
    
    /**
     An encoder that writes GPU commands into a command buffer.

     Don't implement this protocol yourself; instead you call
     methods on a MTLCommandBuffer object to create command
     encoders. Command encoder objects are lightweight objects
     that you re-create every time you need to send commands to
     the GPU.

     There are many different kinds of command encoders, each
     providing a different set of commands that can be encoded
     into the buffer. A command encoder implements the
     MTLCommandEncoder protocol and an additional protocol specific
     to the kind of encoder being created. Table 1 lists command
     encoders and the protocols they implement.
     file:///Users/tigerfly/Desktop/FaceCamera/FaceCamera/Metal/截屏2021-01-30.png
     
     While a command encoder is active, it has the exclusive right
     to append commands to its command buffer. Once you finish
     encoding commands, call the endEncoding method to finish
     encoding the commands. To write further commands into the
     same command buffer, create a new command encoder.

     You can call the insertDebugSignpost:, pushDebugGroup:,
     and popDebugGroup methods to put debug strings into the
     command buffer and to push or pop string labels used to
     identify groups of encoded commands. These methods don't
     change the rendering or compute behavior of your app;
     the Xcode debugger uses them to organize your app’s
     rendering commands in a format that may provide insight
     into how your app works.
     */
    
    /**
     Ending Command Encoding

     - endEncoding
     Declares that all command generation from the encoder is completed.
     Required.
     */
    
    /**
     Annotating the Command Buffer with Debug Information
     
     - insertDebugSignpost:
     Inserts a debug string into the captured frame data.
     Required.
     
     - pushDebugGroup:
     Pushes a specific string onto a stack of debug group
     strings for the command encoder.
     Required.
     
     - popDebugGroup
     Pops the latest string off of a stack of debug group
     strings for the command encoder.
     Required.
     */
    
    /**
     Identifying the Command Encoder

     device
     The Metal device from which the command encoder was created.
     Required.
     
     label
     A string that labels the command encoder.
     Required.
     */
    
    
#pragma mark -- Counter Sampling

    /**
     Retrieve information about how the GPU executed your commands.
     */
    
    /**
     Sample Buffers
     
     MTLCounterSampleBufferDescriptor
     A description of how to create a counter sample buffer.
     
     MTLCounterSampleBuffer
     An object that stores counter samples.
     
     MTLCounterDontSample
     A value that indicates that you want a sample to be omitted.
     */
    
    /**
     Counters and Counter Sets

     MTLCommonCounter
     Names of common counters.
     
     MTLCommonCounterSet
     Options for specifying commonly used sets of counters.
     
     MTLCounterSet
     A set of counters to sample.
     
     MTLCounter
     A descriptor for a single counter.
     */
    
    /**
     Sample Results

     MTLCounterResultStageUtilization
     The result from sampling a stage-utilization counter set.
     
     MTLCounterResultStatistic
     The result from sampling a statistics counter set.
     
     MTLCounterResultTimestamp
     The result from sampling a timestamp counter set.
     */
    
    /**
     Error Handling

     MTLCounterSampleBufferError
     Constants for error codes returned by Metal for counter
     sampling errors.
     
     MTLCounterErrorDomain
     The error domain for counter errors.
     
     MTLCounterErrorValue
     A value in a counter sample that indicates that the counter
     does not contain valid information.
     */
    
    
    
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
