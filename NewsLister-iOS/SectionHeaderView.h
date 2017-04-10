#import <UIKit/UIKit.h>

@interface BSSectionHeaderView : UITableViewHeaderFooterView

    @property (weak, nonatomic) IBOutlet UILabel *titleLabel;

    //@property (nonatomic, weak) IBOutlet id <SectionHeaderViewDelegate> delegate;

    @property (nonatomic) NSInteger section;

@end
