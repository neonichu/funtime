# Demos

## class-dump

    $ brew install class-dump
    $ class-dump -H -o $HOME/Desktop/UIKit/ `xcode-select --print-path`/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk/System/Library/Frameworks/UIKit.framework
    $ vi -c '/recursiveDesc' $HOME/Desktop/UIKit/UIView.h

## Replacing methods

    IMP myIMP = imp_implementationWithBlock(^(id sself, SEL action, id sender) {
        if (action == @selector(comment:) && action == @selector(highlight:)) {
            return YES;
        }
        if (action == @selector(mail:) && [MFMailComposeViewController canSendMail]) {
            return YES;
        }
        
        return NO;
    });
    Method m = class_getInstanceMethod([JLTextView class], @selector(canPerformAction:withSender:));
    method_setImplementation(m, myIMP);

## Adding methods

    myIMP = imp_implementationWithBlock(^(id sself, id sender) {
        [self mail:sender];
    });
    class_addMethod([JLTextView class], @selector(mail:), myIMP, @encode(id));