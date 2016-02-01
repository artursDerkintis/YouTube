//
//  CD_ModalFadeTransition.m
//  Zoomatron
//
//  Created by Rob Stearn on 22/12/2013.
//  Copyright (c) 2013 Cocoadelica. All rights reserved.
//

#import "CD_ModalFadeTransition.h"
#import <UIKit/UIKit.h>

@interface CD_ModalFadeTransition ()
@property (nonatomic, strong) UIView *blurredView;
- (void)animatePresentation;
- (void)animateDismissal;
@end

//This function was written by Eric Allam http://www.initwithfunk.com
static UIImage *snapshotView(UIView *view){
  CGSize size = CGSizeMake(CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
  UIGraphicsBeginImageContextWithOptions(size, YES, 0);
  CGRect boundsToDrawIn = CGRectInset(view.bounds, 5, 5);
  [view drawViewHierarchyInRect:boundsToDrawIn afterScreenUpdates:NO];
  UIImage *i = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return i;
}

@implementation CD_ModalFadeTransition

#pragma mark - Transitioning Delegate methods

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  self.context = transitionContext;
  if (self.isPresenting) {
    [self animatePresentation];
  }
  else {
    [self animateDismissal];
  }
}

#pragma mark - Private implementation methods
//Parts of these methods written by Eric Allam http://www.initwithfunk.com

- (void)animatePresentation {
  UIViewController *fromVC = [self.context viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toVC = [self.context viewControllerForKey:UITransitionContextToViewControllerKey];
  UIView *containerView = [self.context containerView];
  UIView *toView = toVC.view;
  CGRect originalFrame = toView.frame;
  UIImage *blurredSnapshot = [snapshotView(fromVC.view) applyBlurWithRadius:3.0
                                                                  tintColor:[UIColor colorWithWhite:0.0 alpha:0.5]
                                                      saturationDeltaFactor:0.1
                                                                  maskImage:nil];
  self.blurredView.frame = CGRectInset(containerView.bounds, -25, -25);
  self.blurredView = [[UIImageView alloc] initWithImage:blurredSnapshot];

  
  [containerView addSubview:self.blurredView];
  fromVC.view.alpha = 0;
  
  toView.frame = self.originalRect;
  [containerView addSubview:toView];
  
  [UIView animateWithDuration:0.4
                        delay:0
       usingSpringWithDamping:0.5
        initialSpringVelocity:0.4
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                     CGFloat containerHeight = CGRectGetHeight(self.context.containerView.frame);
                     CGFloat originalHeight = CGRectGetHeight(originalFrame);
                     CGFloat coordinateY = (containerHeight / 2) - (originalHeight / 2);
                     toView.frame = CGRectMake(0, coordinateY, CGRectGetWidth(originalFrame), CGRectGetHeight(originalFrame));
                     self.blurredView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
                   }
                   completion:^(BOOL finished) {
                     [self.context completeTransition:YES];
                   }];
}

- (void)animateDismissal {
  UIViewController *fromVC = [self.context
                              viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toVC = [self.context
                            viewControllerForKey:UITransitionContextToViewControllerKey];
  [UIView animateWithDuration:0.2
                        delay:0
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     fromVC.view.frame = self.originalRect;
                     self.blurredView.transform = CGAffineTransformIdentity;
                     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                   }
                   completion:^(BOOL finished) {
                     toVC.view.alpha = 100;
                     [self.context completeTransition:YES];
                   }];
}

@end