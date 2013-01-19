//
//  MetronomeViewController.m
//  MetronomeApp
//
//  Created by Paul Stefan Ort on 1/10/13.
//  Copyright (c) 2013 Paul Stefan Ort. All rights reserved.
//

#import "MetronomeViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CFNetwork/CFNetwork.h>

@interface MetronomeViewController ()
@property bool beating;
@property int bpm;
@property CGFloat beatDelay;
@property (strong) NSString *path;
@property (strong) NSString *filePath;
@property SystemSoundID sound1;
@property SystemSoundID sound2;
@property int alternate;
@end

@implementation MetronomeViewController

@synthesize beating, bpm, beatDelay, path, filePath, sound1, sound2;
@synthesize bpmLabel, toggleButton, slider;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        bpm = 80;
        beatDelay = 60.0 / bpm;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.07 blue:0.008 alpha:1.0]];
    [slider setThumbTintColor:[UIColor colorWithRed:0.16 green:0.07 blue:0.008 alpha:1.0]];
    [slider setBackgroundColor:[UIColor colorWithRed:0.16 green:0.07 blue:0.008 alpha:1.0]];
    [toggleButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9]];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        path = [[NSBundle mainBundle] pathForResource:@"MetronomeSound1" ofType:@"mp3"];
        filePath = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &sound1);
        path = [[NSBundle mainBundle] pathForResource:@"MetronomeSound2" ofType:@"mp3"];
        filePath = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &sound2);
        self.alternate = 2;
    });
}

- (void) flashButton:(UIButton *)button {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [button setBackgroundColor:[UIColor colorWithRed:0.16 green:0.07 blue:0.008 alpha:0.2]];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [button setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9]];
    [UIView commitAnimations];
}

- (IBAction)sliderChanged:(UISlider *)sender {
    NSNumber *bpmNumber = [[NSNumber alloc] initWithFloat:sender.value];
    bpm = [bpmNumber intValue];
    beatDelay = 60.0 / bpm;
    bpmLabel.text = [NSString stringWithFormat:@"%d", bpm];
}

- (IBAction)toggleButtonPressed:(id)sender {
    [self performSelector:@selector(flashButton:) withObject:sender];
    if (beating) {
        beating = false;
        [toggleButton setTitle:@"Start" forState:UIControlStateNormal];
    } else {
        beating = true;
        [toggleButton setTitle:@"Stop" forState:UIControlStateNormal];
        beatDelay = 60.0 / bpm;
        [self performSelector:@selector(beat) withObject:nil afterDelay:(beatDelay)];
    }
}

- (void) beat {
    if (beating) {
        AudioServicesPlaySystemSound(sound1);
        /*
         TODO: Implement alternate beat options.
        if (self.alternate == 1) {
            AudioServicesPlaySystemSound(sound1);
            self.alternate = 2;
        } else {
            AudioServicesPlaySystemSound(sound2);
            self.alternate = 1;
        }
         */
        [self performSelector:@selector(beat) withObject:nil afterDelay:(beatDelay)];
    }
}

@end
