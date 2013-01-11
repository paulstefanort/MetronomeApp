//
//  MetronomeViewController.h
//  MetronomeApp
//
//  Created by Paul Stefan Ort on 1/10/13.
//  Copyright (c) 2013 Paul Stefan Ort. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MetronomeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *bpmLabel;
@property (strong, nonatomic) IBOutlet UIButton *toggleButton;

@end
