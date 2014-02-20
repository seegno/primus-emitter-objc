//
//  Primus_EmitterTest.m
//  Primus-EmitterTests
//
//  Created by Nuno Sousa on 19/02/14.
//  Copyright (c) 2014 Seegno. All rights reserved.
//

#import <Primus/Primus.h>

#import "PrimusEmitter.h"

SpecBegin(PrimusEmitter)

describe(@"Primus-Emitter", ^{
    __block Primus *primus;
    __block PrimusEmitter *emitter;

    setAsyncSpecTimeout(1.0);

    beforeEach(^{
        NSURL *url = [NSURL URLWithString:@"http://127.0.0.1"];
        PrimusConnectOptions *options = [[PrimusConnectOptions alloc] init];

        options.manual = YES;
        options.plugins = @{ @"emitter": PrimusEmitter.class };

        primus = [[Primus alloc] initWithURL:url options:options];

        primus.transformer = mockObjectAndProtocol([NSObject class], @protocol(TransformerProtocol));

        [primus open];

        emitter = primus.plugins[@"emitter"];
    });

    it(@"should emit event", ^AsyncBlock {
        [primus on:@"news" listener:^(id data) {
            expect(data).to.equal(@"hello");

            done();
        }];

        [primus emit:@"incoming::data", @{
            @"type": @(kPrimusPacketTypeEvent),
            @"data": @[@"news", @"hello"]
        }];
    });

    it(@"should emit object", ^AsyncBlock {
        NSDictionary *object = @{ @"hi": @"hello", @"num": @(123456) };

        [primus on:@"news" listener:^(id data) {
            expect(data).to.equal(object);

            done();
        }];

        [primus emit:@"incoming::data", @{
            @"type": @(kPrimusPacketTypeEvent),
            @"data": @[@"news", object]
        }];
    });

    it(@"should support ack", ^AsyncBlock {
        NSDictionary *object = @{ @"hi": @"hello", @"num": @(123456) };

        [primus on:@"news" listener:^(id data, AckBlock ack) {
            expect(data).to.equal(object);

            ack();
        }];

        [primus emit:@"incoming::data", @{
            @"id": @1,
            @"type": @(kPrimusPacketTypeEvent),
            @"data": @[@"news", object, ^{
                done();
            }]
        }];
    });
});

SpecEnd