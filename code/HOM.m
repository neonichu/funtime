#import <Foundation/Foundation.h>

@interface HOM : NSProxy {
  id xxTarget;
  SEL xxSelector;
}

@end

#pragma mark -

@implementation HOM

-(void)forwardInvocation:(NSInvocation*)anInvocation {
	id result = [xxTarget performSelector:xxSelector withObject:anInvocation];
	[anInvocation setReturnValue:&result];
}

-methodSignatureForSelector:(SEL)aSelector {
	return [[xxTarget objectAtIndex:0] methodSignatureForSelector:aSelector];
}

-xxinitWithTarget:aTarget selector:(SEL)newSelector {
	xxTarget = aTarget;
	xxSelector = newSelector;
	return self;
}

+homWithTarget:aTarget selector:(SEL)newSelector {
	return [[[self alloc] xxinitWithTarget:aTarget selector:newSelector] autorelease];
}

@end

#pragma mark -

@interface NSArray(hom)

-collect;

@end

#pragma mark -

@implementation NSArray(hom)

-(NSArray*)collect:(NSInvocation*)anInvocation {
	NSMutableArray *resultArray = [NSMutableArray array];
	
	for (id obj in self) {
		id resultObject;
		[anInvocation invokeWithTarget:obj];
		[anInvocation getReturnValue:&resultObject];
		[resultArray addObject:resultObject];
	}
	
	return resultArray;
}

-collect {
  return [HOM homWithTarget:self selector:@selector(collect:)];
}

@end

#pragma mark -

int main(int argc, char *argv[]) {
	@autoreleasepool {
		NSArray* strings = @[ @"foo", @"candy" ];
		NSLog(@"in: %@", strings);
		NSLog(@"out: %@", [[strings collect] stringByAppendingString:@"bar"]);
	}
}