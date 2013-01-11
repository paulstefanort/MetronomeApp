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
/*  Life would be easier if we could have an array of SystemSoundIDs.
    The only alternative is to have an NSMutableArray property storing 
    objects with a property of SystemSoundID ... too complicated.
*/
@property SystemSoundID sound1;
@property SystemSoundID sound2;
@property int alternate;
@end

@implementation MetronomeViewController

@synthesize beating, bpm, beatDelay, path, filePath, sound1, sound2;
@synthesize bpmLabel, toggleButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        bpm = 80;
        beatDelay = 60.0 / bpm;
    }
    return self;
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

- (IBAction)sliderChanged:(UISlider *)sender {
    NSNumber *bpmNumber = [[NSNumber alloc] initWithFloat:sender.value];
    bpm = [bpmNumber intValue];
    beatDelay = 60.0 / bpm;
    bpmLabel.text = [NSString stringWithFormat:@"%d", bpm];
}

- (IBAction)toggleButtonPressed:(id)sender {
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
        if (self.alternate == 1)
        {
            AudioServicesPlaySystemSound(sound1);
            self.alternate = 2;
        }
        else
        {
            AudioServicesPlaySystemSound(sound2);
            self.alternate = 1;
        }
        [self performSelector:@selector(beat) withObject:nil afterDelay:(beatDelay)];
    }
}

@end
