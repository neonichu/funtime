!SLIDE bullets transition=toss incremental

# Fortgeschrittene Nutzung

* Higher Order Messaging
* libextobjc


!SLIDE center transition=fade

![](hom.jpg)

# Higher order messaging

Using a message as an argument to another message.

!SLIDE code small

# Ziel

    @@@ c

	NSArray* strings = @[ @"foo", @"candy" ];
    NSLog(@"%@", [[strings collect] 
        stringByAppendingString:@"bar"]);

    ( "foobar", "candybar" )


!SLIDE code smaller

# Implementierung, Teil 1

    @@@ c

    @implementation HOM

    -(void)forwardInvocation:(NSInvocation*)anInvocation {
	   id result = [xxTarget performSelector:xxSelector 
	       withObject:anInvocation];
	   [anInvocation setReturnValue:&result];
    }

    -methodSignatureForSelector:(SEL)aSelector {
	   return [[xxTarget objectAtIndex:0] 
	       methodSignatureForSelector:aSelector];
    }

    -xxinitWithTarget:aTarget selector:(SEL)newSelector {
	   xxTarget = aTarget;
	   xxSelector = newSelector;
	   return self;
    }


!SLIDE code smaller

# Implementierung, Teil 2

    @@@ c

    @implementation NSArray(hom)

    -(NSArray*)collect:(NSInvocation*)anInvocation {
        NSMutableArray *resultArray = [NSMutableArray array];

        for (id obj in self ) {
            id resultObject;
            [anInvocation invokeWithTarget:obj];
            [anInvocation getReturnValue:&resultObject];
            [resultArray addObject:resultObject];
        }
        
        return resultArray;
    }

    -collect {
        return [HOM homWithTarget:self 
            selector:@selector(collect:)];
    }


!SLIDE bullets smaller incremental transition=fade

# libextobjc

* _EXTAnnotation_ (associative references)
* _EXTDispatchObject_ (message forwarding)
* _EXTMultimethod_ (introspection)
* _EXTNil_ (message forwarding)
* _EXTSafeCategory_ (dynamic new functionality)
* ... und viele mehr

