!SLIDE bullets transition=toss incremental

# Was können wir damit machen?

* Introspection von Objekten und Methoden
* Dynamisch Funktionalität hinzufügen
* Dynamisch Instanzvariablen hinzufügen


!SLIDE small bullets incremental transition=fade

# Introspection von Objekten und Methoden

* Debugging
* Generische Implementierung von __NSCoding__
* Beispiel: [Mantle](https://github.com/github/Mantle)


!SLIDE code smaller

# Beispiel: Introspection

	@@@ c
    unsigned int methodCount;
	Method* methods = class_copyMethodList([NSObject class], 
		&methodCount);
		
	for (int i = 0; i < methodCount; i++) {
		SEL selector = method_getName(methods[i]);
		char returnType[255];
		method_getReturnType(methods[i], returnType, 255);
		NSLog(@"%s %@", returnType, 
			NSStringFromSelector(selector));
	}


!SLIDE

# Demo


!SLIDE bullets incremental transition=fade

# Dynamisch Funktionalität hinzufügen

* Debugging

* Key-Value Observation

* Subclassing einer Klasse, die nicht in jedem OS Release vorhanden ist


!SLIDE

# Demo


!SLIDE transition=fade bullets incremental

# Method swizzling

* Die Methode tut **beinahe** das Richtige

* also patchen wir sie.


!SLIDE code smaller

# Method swizzling

    @@@ c
    // Implementation by Mike Ash

    void Swizzle(Class c, SEL orig, SEL new) {
       Method origMethod = class_getInstanceMethod(c, orig);
       Method newMethod = class_getInstanceMethod(c, new);

       if (class_addMethod(c, orig, 
       	   method_getImplementation(newMethod), 
       	   method_getTypeEncoding(newMethod))) {
         class_replaceMethod(c, new, 
         	method_getImplementation(origMethod), 
         	method_getTypeEncoding(origMethod));
       } else {
         method_exchangeImplementations(origMethod, newMethod);
       } 
    }


!SLIDE code

# Achtung!

    @@@ c
    UITableView(Custom)
    
    -(void)myLayoutSubviews {
    	// [...] Implementation [...]

    	[self myLayoutSubviews];
    }


!SLIDE code smaller

# Aus *UIViewController.h*

    @@@ c

    - (void)attentionClassDumpUser:(id)arg1 
      yesItsUsAgain:(id)arg2 
      althoughSwizzlingAndOverridingPrivateMethodsIsFun:(id)arg3 
      itWasntMuchFunWhenYourAppStoppedWorking:(id)arg4 
      pleaseRefrainFromDoingSoInTheFutureOkayThanksBye:(id)arg5;

(Dank an *@steipete* für die Entdeckung)


!SLIDE code smaller transition=fade

# Beispiel: Rückgabewert verändern

    @@@ c
    Method method = class_getInstanceMethod(
    	[NSDateFormatter class], 
    	@selector(stringForObjectValue:));
	IMP originalIMP = method_getImplementation(method);
	class_addMethod([NSDateFormatter class], @selector(thingy:), 
		originalIMP, @encode(id));
		
	IMP myIMP = imp_implementationWithBlock(^(id sself, 
			id object) {
		NSString* str = originalIMP(sself, 
			@selector(stringForObjectValue:), object);
		return [str stringByAppendingString:@" changed"];
	});
		
	method_setImplementation(method, myIMP);
		
	NSDate* date = [NSDate new];
	NSLog(@"%@", [NSDateFormatter localizedStringFromDate:date 
		dateStyle:NSDateFormatterShortStyle 
		timeStyle:NSDateFormatterShortStyle]);


!SLIDE code small transition=fade

# Dynamisch Ivars hinzufügen

## Associative references

    void objc_setAssociatedObject(
    		id object, 
    		void *key, id value,
    		objc_AssociationPolicy policy);

    id objc_getAssociatedObject(id object, void *key);
    
