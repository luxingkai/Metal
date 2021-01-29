//
//  MetalViewController.m
//  FaceCamera
//
//  Created by tigerfly on 2021/1/29.
//  Copyright © 2021 tigerfly. All rights reserved.
//

#import "MetalViewController.h"

@interface MetalViewController ()

@end

@implementation MetalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    /**
     Render advanced 3D graphics and perform data-parallel
     computations using graphics processors.


     Graphics processors (GPUs) are designed to quickly render
     graphics and perform data-parallel calculations. Use the
     Metal framework when you need to communicate directly with
     the GPUs available on a device. Apps that render complex
     scenes or that perform advanced scientific calculations
     can use this power to achieve maximum performance. Such
     apps include:
     •  Games that render sophisticated 3D environments
     •  Video processing apps, like Final Cut Pro
     •  Data-crunching apps, such as those used to perform scientific
        research
     
     Metal works hand-in-hand with other frameworks that supplement
     its capability. Use MetalKit to simplify the task of getting
     your Metal content onscreen. Use Metal Performance Shaders
     to implement custom rendering functions or to take advantage
     of a large library of existing functions.

     Many high level Apple frameworks are built on top of Metal
     to take advantage of its performance, including Core Image,
     SpriteKit, and SceneKit. Using one of these high-level
     frameworks shields you from the details of GPU programming,
     but writing custom Metal code enables you to achieve the
     highest level of performance.
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
