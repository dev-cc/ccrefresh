
# import "CCRefreshBaseView.h"

#define kBundleName @"ccrefresh.bundle"
#define kSrcName(file) [kBundleName stringByAppendingPathComponent:file]

@interface CCRefreshBaseView ()

- (CGFloat)validY;
- (int)viewType;

@end

@implementation CCRefreshBaseView

@synthesize scrollView = _scrollView;
@synthesize delegate = _delegate;
@synthesize beginRefreshingBlock = _beginRefreshingBlock;
@synthesize lastUpdateTimeLabel = _lastUpdateTimeLabel, statusLabel = _statusLabel, arrowImage = _arrowImage, activityView = _activityView;
@synthesize refreshing;

- (void)dealloc {
    [_lastUpdateTimeLabel release];
    [_statusLabel release];
    [_arrowImage release];
    [_activityView release];
    [super dealloc];
}

- (id)initWithScrollView:(UIScrollView *)scrollView {
    if (self = [super init]) {
        _scrollView = scrollView;
    }
    return self;
}

- (void)initial {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
    
    [self addTime];
    [self addStatus];
    [self addArrow];
    [self addActivity];
    
    // 默认状态
    [self setState:RefreshStateNormale];
    
#ifdef NeedAudio
    // 7.加载音频
    _pullId = [self loadId:@"pull.wav"];
    _normalId = [self loadId:@"normal.wav"];
    _refreshingId = [self loadId:@"refreshing.wav"];
    _endRefreshId = [self loadId:@"end_refreshing.wav"];
#endif
}

- (void)free {}

- (void)setState:(RefreshState)state {
    switch (state) {
        case RefreshStateNormale:
            _arrowImage.hidden = NO;
            [_activityView stopAnimating];
            break;
        case RefreshStatePulling:
            break;
        case RefreshStateRefreshing:
            [_activityView startAnimating];
            _activityView.hidden = YES;
            _arrowImage.transform = CGAffineTransformIdentity;
            
            if ([_delegate respondsToSelector:@selector(refreshViewBeginRefrehing:)]) {
                [_delegate refreshViewBeginRefrehing:self];
            }
            
            if (_beginRefreshingBlock) {
                _beginRefreshingBlock(self);
            }
            
            break;
        default:
            break;
    }
}

- (void)setFrame:(CGRect)frame {
    frame.size.height = kViewHeight;
    [super setFrame:frame];
    
    CGFloat statusY = 5;
    CGFloat width = frame.size.width;
    
    if (width == 0 || _statusLabel.frame.origin.y == statusY)
        return;
    
    {
        CGFloat statusX = 0;
        CGFloat statusHeight = 20;
        CGFloat statusWidth = width;
        _statusLabel.frame = CGRectMake(statusX, statusY, statusWidth, statusHeight);

        CGFloat lastUpdateY = statusY + statusHeight + 5;
        _lastUpdateTimeLabel.frame = CGRectMake(statusX, lastUpdateY, statusWidth, statusHeight);
    }

    
    {
        CGFloat arrowX = width * 0.5 - 100;
        _arrowImage.center = CGPointMake(arrowX, frame.size.height * 0.5);
    }
    
    {
        _activityView.center = _arrowImage.center;
    }
}

- (void)setScrollView:(UIScrollView *)scrollView {
    [_scrollView removeObserver:@"contentOffset" forKeyPath:nil];
    _scrollView = scrollView;
    [_scrollView addSubview:self];
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeFromSuperview {
    [self.superview removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [super removeFromSuperview];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
    }
}


- (void)beginRefreshing {
    [self setState:RefreshStateRefreshing];
}

- (void)endRefreshing {
    [self setState:RefreshStateNormale];
}

// 是否正在刷新
- (BOOL)isRefreshing {
    return RefreshStateRefreshing == _state;
}

- (void)addTime {
    _lastUpdateTimeLabel = [[UILabel alloc] init];
    _lastUpdateTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _lastUpdateTimeLabel.font = [UIFont boldSystemFontOfSize:12];
    _lastUpdateTimeLabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    _lastUpdateTimeLabel.backgroundColor = [UIColor clearColor];
    _lastUpdateTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_lastUpdateTimeLabel];
}

- (void)addStatus {
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _statusLabel.font = [UIFont boldSystemFontOfSize:13];
    _statusLabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_statusLabel];

}

- (void)addArrow {
    _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kSrcName(@"arrow.png")]];
    _arrowImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:_arrowImage];
}

- (void)addActivity {
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.bounds = _arrowImage.bounds;
    _activityView.autoresizingMask = _arrowImage.autoresizingMask;
    [self addSubview:_activityView];
}

#ifdef NeedAudio
- (SystemSoundID)loadId:(NSString *)filename
{
    SystemSoundID ID;
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *url = [bundle URLForResource:kSrcName(filename) withExtension:nil];
    AudioServicesCreateSystemSoundID((CFURLRef)(url), &ID);
    return ID;
}
#endif

// 子类实现
- (CGFloat)validY {
    return 0.0;
}
- (int)viewType {
    return 0;
}

@end