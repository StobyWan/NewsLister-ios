#import "SectionHeaderView.h"

@implementation BSSectionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (IBAction)toggleOpen:(id)sender {
    
    [self toggleOpenWithUserAction:YES];
}

- (void)toggleOpenWithUserAction:(BOOL)userAction {
    
    // toggle the disclosure button state
//    self.disclosureButton.selected = !self.disclosureButton.selected;
    
    // if this was a user action, send the delegate the appropriate message
    if (userAction) {
   
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [self.delegate sectionHeaderView:self sectionOpened:self.section];
            }
    }
    
}


@end
