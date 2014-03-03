Primus-Emitter-Objc is an implementation of the [Primus-Emitter](https://github.com/cayasso/primus-emitter) plugin for the [Primus](https://github.com/primus/primus) realtime framework.

The library is fully unit tested using [Specta](https://github.com/specta/specta), [Expecta](https://github.com/specta/expecta) and [OCMockito](https://github.com/jonreid/OCMockito).

[![Build Status](https://travis-ci.org/seegno/primus-emitter-objc.png)](https://travis-ci.org/seegno/primus-emitter-objc)

## Use it

```ruby
pod 'PrimusEmitter'
```

## Quick Start

```objective-c
#import <PrimusEmitter/PrimusEmitter.h>

- (void)start
{
	// By emitting an event on the server-side, the following listener will fire
	[primus on:@"custom:event:here", ^{
		NSLog(@"Received custom event");
	}];
	
	// The last parameter is a block that you can execute to acknowlege the event
	[primus on:@"another:example", ^(AckBlock ack) {
		NSLog(@"Received another event. Calling callback...");
		
		ack();
	}];
}
```
