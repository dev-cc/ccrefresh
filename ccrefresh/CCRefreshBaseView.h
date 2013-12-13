
# define NeedAudio    //如果定义这个宏， 说明需要音频  依赖 AVFoundation.framework 和 AudioToolbox.framework
# define kViewHeight 65.0

# import <UIKit/UIKit.h>
# import <AVFoundation/AVFoundation.h>

typedef enum {
    RefreshStatePulling = 1,
    RefreshStateNormale = 2,
    RefreshStateRefreshing = 3
} RefreshState;

typedef enum {
    RefreshViewTypeHeader = -1,
    RefreshViewTypeFooter = 1
} RefreshViewType;

@class CCRefreshBaseView;

typedef void(^BeginRefreshingBlock)(CCRefreshBaseView *refreshView);

@protocol CCRefreshBaseViewDelegate <NSObject>

@optional
- (void)refreshViewBeginRefrehing:(CCRefreshBaseView *)refreshView;
@end

@interface CCRefreshBaseView : UIView {
    
    // parent
    UIScrollView *_scrollView;
    
    id <CCRefreshBaseViewDelegate> _delegate;
    
    BeginRefreshingBlock _beginRefreshingBlock;
    
    //children
    
    UILabel *_lastUpdateTimeLabel;
    UILabel *_statusLabel;
    UIImageView *_arrowImage;
    UIActivityIndicatorView *_activityView;
    
    // status
    RefreshState _state;
    
#ifdef NeedAudio
    SystemSoundID _normalId;
    SystemSoundID _pullId;
    SystemSoundID _refreshingId;
    SystemSoundID _endRefreshId;
#endif
    
}

@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic, assign) id <CCRefreshBaseViewDelegate> delegate;
@property (nonatomic, copy) BeginRefreshingBlock beginRefreshingBlock;
@property (nonatomic, readonly) UILabel *lastUpdateTimeLabel, *statusLabel;
@property (nonatomic, readonly) UIImageView *arrowImage;
@property (nonatomic, readonly) UIActivityIndicatorView *activityView;
// 判断是否正在刷新
@property (nonatomic, readonly, getter = isRefreshing) BOOL refreshing;

- (id)initWithScrollView:(UIScrollView *)scrollView;

- (void)beginRefreshing;
- (void)endRefreshing;
- (void)free;

//子类实现
- (void)setState:(RefreshState)state;


































@end
