//
//  SKProduct.m
//  CSGMobileGameSDK
//
//  Created by 9377 on 2018/9/13.
//  Copyright © 2018年 9377. All rights reserved.
//

#import "SKProduct+TXKProduct.h"
#import <objc/runtime.h>
static const char * CSG_PRODUCT = "cg_product";
@implementation SKProduct (TXKProduct)

- (void)setExtInfo:(NSString *)ext{
    objc_setAssociatedObject(self, CSG_PRODUCT, ext, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (NSString *)extInfo{
    return objc_getAssociatedObject(self, CSG_PRODUCT);
}



@end

