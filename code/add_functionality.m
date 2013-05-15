#import <Foundation/Foundation.h>
#import <objc/runtime.h>

int main(int argc, char *argv[]) {
	@autoreleasepool {
		Method method = class_getInstanceMethod([NSDateFormatter class], @selector(stringForObjectValue:));
		IMP originalIMP = method_getImplementation(method);
		class_addMethod([NSDateFormatter class], @selector(thingy:), originalIMP, @encode(id));
		
		IMP myIMP = imp_implementationWithBlock(^(id sself, id object) {
			NSString* str = originalIMP(sself, @selector(stringForObjectValue:), object);
			return [str stringByAppendingString:@" changed"];
		});
		
		method_setImplementation(method, myIMP);
		
		NSDate* date = [NSDate new];
		NSLog(@"%@", [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle 
						timeStyle:NSDateFormatterShortStyle]);
	}
}