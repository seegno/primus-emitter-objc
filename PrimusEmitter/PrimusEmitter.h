//
//  Primus_Emitter.h
//  Primus-Emitter
//
//  Created by Nuno Sousa on 19/02/14.
//  Copyright (c) 2014 Seegno. All rights reserved.
//

#import <Primus/PluginProtocol.h>

typedef void (^AckBlock)(void);

typedef NS_ENUM(NSInteger, PrimusPacketType) {
    kPrimusPacketTypeEvent,
    kPrimusPacketTypeAck
};

@interface Primus (Emitter)

- (void)send:(NSString *)event data:(id)data;

@end

@interface PrimusEmitter : NSObject<PluginProtocol>
{
    NSObject<PrimusProtocol> * __unsafe_unretained _primus;
}

@end
