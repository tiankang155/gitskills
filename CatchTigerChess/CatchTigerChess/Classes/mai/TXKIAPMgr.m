//
//  CSGIAPMgr.m
//  CSGMobileGameSDK
//
//  Created by 9377 on 2018/9/12.
//  Copyright © 2018年 9377. All rights reserved.
//

#import "TXKIAPMgr.h"

#import "txkProgressHUD.h"
#import <StoreKit/StoreKit.h>

#define CSGLocalizedStringForKey(str,msg) [NSString stringWithFormat:@"%@", str]
#define CSLog(...) NSLog(__VA_ARGS__)

#define kStringIsEmpty(str)     ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

typedef void (^IAPcheckReceiptCompleteResponseBlock)(NSString* response,NSError* error);

@interface TXKIAPMgr()<NSURLConnectionDataDelegate>
@property (nonatomic,copy) IAPcheckReceiptCompleteResponseBlock checkReceiptCompleteBlock;

@property (nonatomic,assign) BOOL isProcessing;
@property (nonatomic,strong) NSMutableData* receiptRequestData;
@property (nonatomic,copy) IAPResultBlock resultBlock;

@end

@implementation TXKIAPMgr

@synthesize iapProduts;

+(TXKIAPMgr *)sharedInstance{
    static TXKIAPMgr *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TXKIAPMgr alloc] init];
        [instance initialize];
    });
    return instance;
}


- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}


-(void) initialize{
    iapProduts = [NSArray array];
}


- (void)reqProductWithProID:(NSString *)productID  extInfo:(NSString *)extInfo result:(IAPResultBlock)result
{
    self.resultBlock = result;
    
    [txkProgressHUD show:@"请求中..."];
    tmpExtInfo = extInfo;
    NSMutableArray *productIdArray = [NSMutableArray array];
    [productIdArray addObject:productID];
    
    if (productIdArray.count == 0) return;
    // 去苹果服务器请求可卖的商品
    NSSet *productIdSet = [NSSet setWithArray:productIdArray];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdSet];
    request.delegate = self;
    
    [request start];
}


#pragma mark SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    if (!self.iapProduts) {
        self.iapProduts = [NSArray array];
    }
    
    // 展示商品
    self.iapProduts = [response.products sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(SKProduct *obj1, SKProduct *obj2) {
        return [obj1.price compare:obj2.price];
    }];
    
    CSLog(@"..APP STORE CONNECT 产品信息........%@", self.iapProduts);
    
    if(self.iapProduts.count > 0){
        SKProduct *pro = [self.iapProduts objectAtIndex:0];
        pro.extInfo = tmpExtInfo;
        [self buyProduct:pro.productIdentifier];
    }else{
//        [txkProgressHUD showError:@"连接失败..." Interaction:YES];
        [txkProgressHUD dismiss];
        // 苹果ZF失败回调实体
        self.resultBlock(NO);
        NSLog(@"苹果ZF失败回调实体");
//        CSIAPCallBackInfo *userInfo = [[CSIAPCallBackInfo alloc]init];
//        userInfo.status = 0;
//        userInfo.errorMsg = CSGLocalizedStringForKey(@"CSG_IAP_CanFindProduct", nil);
//        [NotificationUtil postNotification:CSGIAPFailed object:userInfo userinfo:nil];
    }
    
}


#pragma mark SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    /*
     SKPaymentTransactionStatePurchasing,    正在购买
     SKPaymentTransactionStatePurchased,     已经购买(购买成功)
     SKPaymentTransactionStateFailed,        购买失败
     SKPaymentTransactionStateRestored,      恢复购买
     SKPaymentTransactionStateDeferred       未决定
     */
    for (SKPaymentTransaction *transation in transactions) {
    
        switch (transation.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                CSLog(@"用户正在购买");
                
                break;
                
            case SKPaymentTransactionStatePurchased:
                CSLog(@"购买成功,将对应的商品给用户");
                [self restore];
                [self verifyPruchase:transation];
                // 将交易从交易队列中移除
                [self finishTransactions:transation];
                
                break;
                
            case SKPaymentTransactionStateFailed:{
                CSLog(@"购买失败,告诉用户没有付钱成功");
                // 将交易从交易队列中移除
//                [txkProgressHUD showError:@"购买失败..."];
                [txkProgressHUD dismiss];
                [self finishTransactions:transation];
                self.resultBlock(NO);
//                CSLog(@"未找到产品信息");
                // 苹果ZF失败回调实体
//                CSIAPCallBackInfo *userInfo = [[CSIAPCallBackInfo alloc]init];
//                userInfo.status = 0;
//                userInfo.errorMsg = @"未找到产品信息";
//                [NotificationUtil postNotification:CSGIAPFailed object:userInfo userinfo:nil];
            }
                break;
                
            case SKPaymentTransactionStateRestored:
                CSLog(@"恢复商品,将对应的商品给用户");
//                [txkProgressHUD showError:@"恢复连接..."];
                [txkProgressHUD dismiss];
                // 将交易从交易队列中移除
                [self finishTransactions:transation];
                break;
                
            case SKPaymentTransactionStateDeferred:
                CSLog(@"未决定");
//                [txkProgressHUD showError:@"连接失败..."];
                [txkProgressHUD dismiss];
                self.resultBlock(NO);
                break;
            default:
//                [txkProgressHUD showError:@"连接失败..."];
                self.resultBlock(NO);
                break;
        }
    }
}

#pragma mark - 恢复购买
- (void)restore {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)finishTransactions:(SKPaymentTransaction *)transaction
{
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark - 购买商品
- (void)buyProduct:(NSString *)productId
{
    if (!hasAddObserver) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        hasAddObserver=YES;
    }
    CSLog(@"productId %@", productId);
    for (int i = 0; i < self.iapProduts.count; i++) {
        // 1.创建产品
        SKProduct *product = self.iapProduts[i];
        CSLog(@"productId %@", product.productIdentifier);
        if ([product.productIdentifier isEqualToString:productId]) {
            // 2.创建票据
            SKPayment *buyProduct = [SKPayment paymentWithProduct:product];
            // 3.将票据加入到交易队列中
            [[SKPaymentQueue defaultQueue] addPayment:buyProduct];
            CSLog(@"开始交易……");
            return;
        }
    }
    
}

#pragma mark - 购买商品
- (void)directBuyProduct:(SKProduct *)product
{
    if (!hasAddObserver) {
        CSLog(@"添加监听");
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        hasAddObserver=YES;
    }
    
    // 2.创建票据
    SKPayment *buyProduct = [SKPayment paymentWithProduct:product];
    // 3.将票据加入到交易队列中
    [[SKPaymentQueue defaultQueue] addPayment:buyProduct];
}

#pragma mark 验证购买凭据
- (void)verifyPruchase:(SKPaymentTransaction *)transaction
{
    [txkProgressHUD dismiss];
    self.resultBlock(YES);
    
//    CSLog(@"开启验证凭证......");
//    SKProduct *product = nil;
//    SKPayment *buyProduct = transaction.payment;
//    NSString *productid = buyProduct.productIdentifier;
//    for (int i = 0; i < self.iapProduts.count; i++) {
//        SKProduct *pro = self.iapProduts[i];
//        if ([pro.productIdentifier isEqualToString:productid]) {
//            product = pro;
//        }
//    }
//    if(!product){
//        CSLog(@"未找到对应产品.....");
//        return;
//    }
//
//    CSLog(@"发起后台验证.............");
//    // 后端验证凭证
//    NSString *ext = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
//    if (!kStringIsEmpty(product.extInfo)) {
//        ext = product.extInfo;
//    }
//    [[CSGYDSDKMgr sharedInstance] verifyZFPGProduct:product withSKPaymentTransaction:transaction extrainStr:ext];
}


- (void)checkReceipt:(NSString*)url withData:(NSData*)receiptData onCompletion:(IAPcheckReceiptCompleteResponseBlock)completion
{
    self.checkReceiptCompleteBlock = completion;
    NSURL* requestURL = [NSURL URLWithString:url];
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:receiptData];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if(conn) {
        self.receiptRequestData = [[NSMutableData alloc] init];
    } else {
        NSError* error = nil;
        NSMutableDictionary* errorDetail = [[NSMutableDictionary alloc] init];
        [errorDetail setValue:@"Can't create connection" forKey:NSLocalizedDescriptionKey];
        error = [NSError errorWithDomain:@"IAPManagerError" code:100 userInfo:errorDetail];
        if(self.checkReceiptCompleteBlock) {
            self.checkReceiptCompleteBlock(nil,error);
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"[IAP] Cannot transmit receipt data. %@",[error localizedDescription]);
    if(self.checkReceiptCompleteBlock) {
        self.checkReceiptCompleteBlock(nil,error);
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.receiptRequestData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receiptRequestData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *response = [[NSString alloc] initWithData:self.receiptRequestData encoding:NSUTF8StringEncoding];
    if(self.checkReceiptCompleteBlock) {
        self.checkReceiptCompleteBlock(response,nil);
    }
}

- (void)iapRemoveObserver{
    hasAddObserver=NO;
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

//收据的环境判断；
-(NSString * )environmentForReceipt:(NSString * )str{
    str= [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    str=[str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str=[str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSArray * arr=[str componentsSeparatedByString:@";"];
    //存储收据环境的变量
    NSString * environment=arr[2];
    return environment;
}



@end
