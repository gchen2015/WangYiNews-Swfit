
import UIKit
class NewsShowCell: UITableViewCell {
    var photoView:EGOImageView?
    var titleLabel:UILabel?
    var digestLabel:UILabel?
    
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
        self.photoView = EGOImageView(frame:CGRectMake(10, 10, 80, 60))
        self.photoView!.backgroundColor = UIColor.redColor()
        self.contentView!.addSubview(self.photoView)

        self.titleLabel = UILabel(frame:CGRectMake(100, 10, 210, 30))
        self.titleLabel!.font = UIFont.systemFontOfSize(15)
        self.contentView!.addSubview(self.titleLabel)
        
        self.digestLabel = UILabel(frame:CGRectMake(100, 40, 210, 30))
        self.digestLabel!.font = UIFont.systemFontOfSize(10)
        self.digestLabel!.textColor = UIColor.lightGrayColor()
        self.digestLabel!.numberOfLines = 0
        self.contentView!.addSubview(self.digestLabel)
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
