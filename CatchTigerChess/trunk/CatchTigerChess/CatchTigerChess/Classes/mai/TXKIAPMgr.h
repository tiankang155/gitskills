//
//  CSGIAPMgr.h
//  CSGMobileGameSDK
//
//  Created by 9377 on 2018/9/12.
//  Copyright © 2018年 9377. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "SKProduct+TXKProduct.h"

typedef void(^IAPResultBlock)(BOOL isSuccessed);

@interface TXKIAPMgr : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver>{
    BOOL hasAddObserver;
    id requestProList;
    NSString *tmpExtInfo;
}
// 服务器产品列表
@property (strong, nonatomic) NSArray *serviceProducts;
// 苹果内ZF产品列表
@property (strong, nonatomic) NSArray *iapProduts;

+ (TXKIAPMgr*) sharedInstance;
 
// 向苹果服务器请求产品
- (void)reqProductWithProID:(NSString *)productID  extInfo:(NSString *)extInfo result:(IAPResultBlock)result;
// 根据产品ID购买产品
- (void)buyProduct:(NSString *)productId;
// 直接购买
- (void)directBuyProduct:(SKProduct *)product;
// 移除监听
- (void)iapRemoveObserver;
@end
