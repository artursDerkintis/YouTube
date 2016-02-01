//
//  CD_ModalFadeTransition.h
//  Zoomatron
//
//  Created by Rob Stearn on 22/12/2013.
//  Copyright (c) 2013 Cocoadelica. All rights reserved.
//

@import Foundation;

@interface CD_ModalFadeTransition : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, getter = isPresenting) BOOL presenting;
@property (nonatomic) CGRect originalRect;
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> context;
@end
