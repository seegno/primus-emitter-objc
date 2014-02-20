//
//  Primus_Emitter.m
//  Primus-Emitter
//
//  Created by Nuno Sousa on 19/02/14.
//  Copyright (c) 2014 Seegno. All rights reserved.
//

#import "PrimusEmitter.h"

@implementation PrimusEmitter

- (id)initWithPrimus:(NSObject<PrimusProtocol> *)primus
{
    self = [super init];

    if (self) {
        _primus = primus;

        [self bindEvents];
    }

    return self;
}

- (void)bindEvents
{
    [_primus on:@"data" listener:^(NSDictionary *packet) {
        if (! [packet[@"type"] isKindOfClass:NSNumber.class]) {
            return;
        }

        if ([packet[@"type"] isEqualToNumber:@(kPrimusPacketTypeEvent)]) {
            [self onEvent:packet];
        }
    }];
}

- (void)onEvent:(NSDictionary *)packet
{
    NSString *name = [packet[@"data"] firstObject];
    NSMutableArray *args = [NSMutableArray arrayWithArray:[packet[@"data"] subarrayWithRange:NSMakeRange(1, [packet[@"data"] count] - 1)]];

    if (packet[@"id"]) {
        AckBlock ack = ^{
            [_primus write:@{
                @"id": packet[@"id"],
                @"type": @(kPrimusPacketTypeAck)
            }];
        };

        [args addObject:ack];
    }

    [_primus emit:name args:args];
}

@end
