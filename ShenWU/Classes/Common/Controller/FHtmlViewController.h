//
//  FHtmlViewController.h
//  Fiesta
//
//  Created by Amy on 2024/6/17.
//

#import "FBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHtmlViewController : FBaseViewController
/** 本地h5路径 */
@property (nonatomic, copy) NSString *localHTMLParh;
@property (nonatomic, copy) NSString *webUrl;
@end

NS_ASSUME_NONNULL_END
