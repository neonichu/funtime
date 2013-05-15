#import <Foundation/Foundation.h>
#import <objc/runtime.h>

int main(int argc, char *argv[]) {
	@autoreleasepool {
		unsigned int methodCount;
		Method* methods = class_copyMethodList([NSObject class], &methodCount);
		
		for (int i = 0; i < methodCount; i++) {
			SEL selector = method_getName(methods[i]);
			char returnType[255];
			method_getReturnType(methods[i], returnType, 255);
			NSLog(@"%s %@", returnType, NSStringFromSelector(selector));
		}
	}
}