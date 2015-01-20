//
//  SKStateChart.m
//  Pods
//
//  Created by Shaheen Ghiassy on 1/19/15.
//
//

#import "SKStateChart.h"

@interface SKStateChart ()

@property (nonatomic, copy) NSDictionary *stateChart;

@property (nonatomic, copy) NSString *currentStateName;
@property (nonatomic, strong) NSDictionary *currentStateTree;

@end

static NSString *kDefaultRootState = @"root";


@implementation SKStateChart

- (instancetype)initWithStateChart:(NSDictionary *)stateChart {
    self = [super init];

    if (self) {
        _currentStateName = kDefaultRootState;
        _currentStateTree = [stateChart objectForKey:_currentStateName];
        NSAssert(_currentStateTree != nil, @"The stateChart you input does not have a root state");
        [self didEnterState:_currentStateTree];
        _stateChart = _currentStateTree;
    }

    return self;
}

#pragma mark - Messages

- (void)sendMessage:(NSString *)message {
    NSDictionary *currentStateMessages = [self.currentStateTree objectForKey:@"messages"];
    MessageBlock messageBlock = [currentStateMessages objectForKey:message];

    if (messageBlock) {
        messageBlock(self);
    }
}

- (void)goToState:(NSString *)goToState {
    NSDictionary *newState = [self.currentStateTree objectForKey:goToState];

    if (newState != nil) {
        self.currentStateTree = newState;
        self.currentStateName = goToState;
        [self didEnterState:self.currentStateTree];
    }
}

#pragma mark - Traveral Methods

- (BOOL)traverseTreeToState {
}

- (void)didEnterState:(NSDictionary *)state {
    MessageBlock rootBlock = [state objectForKey:@"enterState"];

    if (rootBlock) {
        rootBlock(self);
    }
}

#pragma mark - Getters

- (NSString *)currentState {
    return [self.currentStateName copy];
}

@end
