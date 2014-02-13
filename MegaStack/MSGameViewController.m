//
//  MSGameViewController.m
//  MegaStack
//
//  Created by FlyinGeek on 2/12/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "MSGameViewController.h"
#import "MSMegaStackGameBoard.h"
#import "MSMegaStackGamebrain.h"

@interface MSGameViewController ()

@property (weak, nonatomic) IBOutlet UIView *gameboardView;
@property (strong, nonatomic) MSMegaStackGamebrain *gameBrain;


@end

@implementation MSGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    MSMegaStackGameboard *gameboard = [[MSMegaStackGameboard alloc]initWithFrame:self.gameboardView.frame rows:11 columns:7 gameboardColor:[UIColor grayColor]];
    [self.view addSubview:gameboard];
    _gameBrain = [[MSMegaStackGamebrain alloc] initWithGameboard:gameboard];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)gameStartButtonPressed:(id)sender {
    [self.gameBrain startGame];
}

- (IBAction)resetButtonPressed:(id)sender {
    [self.gameBrain resetGame];
}


@end