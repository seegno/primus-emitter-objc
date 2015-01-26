//
//  Primus_Emitter.m
//  Primus-Emitter
//
//  Created by Nuno Sousa on 19/02/14.
//  Copyright (c) 2014 Seegno. All rights reserved.
//

#import <Primus/Primus.h>

#import "PrimusEmitter.h"

@implementation Primus (Emitter)

- (void)send:(NSString *)event data:(id)data
{
    [self write:@{
        @"type": @(kPrimusPacketTypeEvent),
        @"data": @[event, data]
    }];
}

@end

@implementation PrimusEmitter

- (id)initWithPrimus:(NSObject<PrimusProtocol> *)primus
{
    self = [super init];

    if (self) {
        _primus = primus;

        [_primus on:@"data" selector:@selector(onData:raw:) target:self];
    }

    return self;
}

- (void)onData:(NSDictionary *)packet raw:(id)raw
{
    if (![packet[@"type"] isKindOfClass:NSNumber.class]) {
        return;
    }

    if ([packet[@"type"] isEqualToNumber:@(kPrimusPacketTypeEvent)]) {
        [self onEvent:packet];
    }
}

- (void)onEvent:(NSDictionary *)packet
{
    NSArray *data = packet[@"data"];
    NSString *name = [data firstObject];
    NSMutableArray *args = [NSMutableArray arrayWithArray:[data subarrayWithRange:NSMakeRange(1, data.count - 1)]];

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
