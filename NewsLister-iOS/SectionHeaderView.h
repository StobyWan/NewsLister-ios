#import <UIKit/UIKit.h>
@protocol SectionHeaderViewDelegate;
@interface BSSectionHeaderView : UITableViewHeaderFooterView

    @property (weak, nonatomic) IBOutlet UILabel *titleLabel;
    @property (nonatomic, weak) IBOutlet UIButton *disclosureButton;
    @property (nonatomic, weak) IBOutlet id <SectionHeaderViewDelegate> delegate;
    @property (nonatomic) NSInteger section;
    - (void)toggleOpenWithUserAction:(BOOL)userAction;
@end

#pragma mark -

/*
 Protocol to be adopted by the section header's delegate; the section header tells its delegate when the section should be opened and closed.
 */
@protocol SectionHeaderViewDelegate <NSObject>

@optional
- (void)sectionHeaderView:(BSSectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)section;

@end
