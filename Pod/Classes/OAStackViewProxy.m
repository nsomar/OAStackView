//
//  OAStackViewProxy.m
//  Pods
//
//  Created by Natan Rolnik on 8/5/15.
//
//

#import "OAStackView.h"
#import "OAStackViewProxy.h"

@interface OAStackViewProxy()

@property (nonatomic, strong) UIView *stackView;
@property (nonatomic, strong) NSArray<UIView *> *initialArrangedSubviews;

@property (nonatomic, strong) UIStackView *nativeStackView;
@property (nonatomic, strong) OAStackView *backwardsCompatibleStackView;

@end

@implementation OAStackViewProxy

+ (BOOL)nativeStackViewAvailable
{
    return NSClassFromString(@"UIStackView") != nil;
}

#pragma mark - Initializers

- (instancetype)init
{
    self = [self initWithArrangedSubviews:nil];
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithCoder:(nonnull NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithArrangedSubviews:(NSArray *)arrangedSubviews
{
    self = [super initWithFrame:CGRectZero];
    
    self.initialArrangedSubviews = arrangedSubviews;
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    [self createStackView];
    [self addSubview:self.stackView];
}

- (void)createStackView
{
    if (!self.stackView) {
        if ([OAStackViewProxy nativeStackViewAvailable]) {
            self.nativeStackView = [[UIStackView alloc] initWithArrangedSubviews:self.initialArrangedSubviews];
            self.stackView = self.nativeStackView;
        }
        else {
            self.backwardsCompatibleStackView = [[OAStackView alloc] initWithArrangedSubviews:self.initialArrangedSubviews];
            self.stackView = self.backwardsCompatibleStackView;
        }
    }
}

#pragma mark - Runtime

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    
    if (!signature) {
        signature = [self.stackView methodSignatureForSelector:selector];
    }
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self.stackView respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:self.stackView];
    }
    else {
        [super forwardInvocation:anInvocation];
    }
}

#pragma mark - Setters

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.stackView.frame = self.bounds;
}

- (void)setAxis:(UILayoutConstraintAxis)axis
{
    _axis = axis;
    
    self.nativeStackView.axis = axis;
    self.backwardsCompatibleStackView.axis = axis;
}

- (void)setDistribution:(UIStackViewDistribution)distribution
{
    _distribution = distribution;
    
    self.nativeStackView.distribution = distribution;
    self.backwardsCompatibleStackView.distribution = distribution;
}

- (void)setAlignment:(UIStackViewAlignment)alignment
{
    _alignment = alignment;
    
    self.nativeStackView.alignment = alignment;
    self.backwardsCompatibleStackView.alignment = alignment;
}

- (void)setSpacing:(CGFloat)spacing
{
    _spacing = spacing;
    
    self.nativeStackView.spacing = spacing;
    self.backwardsCompatibleStackView.spacing = spacing;
}

- (void)setBaselineRelativeArrangement:(BOOL)baselineRelativeArrangement
{
    _baselineRelativeArrangement = baselineRelativeArrangement;
    
    self.nativeStackView.baselineRelativeArrangement = baselineRelativeArrangement;
}

- (void)setLayoutMarginsRelativeArrangement:(BOOL)layoutMarginsRelativeArrangement
{
    _layoutMarginsRelativeArrangement = layoutMarginsRelativeArrangement;
    
    self.nativeStackView.layoutMarginsRelativeArrangement = layoutMarginsRelativeArrangement;
}

@end
