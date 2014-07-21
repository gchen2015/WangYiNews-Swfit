
import UIKit

class NewsImageShowCell: UITableViewCell {
    var titleLabel:UILabel?
    var firstImageView:EGOImageView?
    var secondImageView:EGOImageView?
    var thirdImageView:EGOImageView?

    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
        self.titleLabel = UILabel(frame:CGRectMake(10, 5, 230, 30))
        self.titleLabel!.font = UIFont.systemFontOfSize(15)
        self.contentView.addSubview(self.titleLabel)
        
        self.firstImageView = EGOImageView(frame:CGRectMake(10, 37, 95, 60))
        self.contentView.addSubview(self.firstImageView)
        
        self.secondImageView = EGOImageView(frame:CGRectMake(112, 37, 95, 60))
        self.contentView.addSubview(self.secondImageView)
        
        self.thirdImageView = EGOImageView(frame:CGRectMake(215, 37, 95, 60))
        self.contentView.addSubview(self.thirdImageView)

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
