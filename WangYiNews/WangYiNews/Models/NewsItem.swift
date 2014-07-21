

import UIKit

class NewsItem: NSObject {
    var title : NSString
    var digest : NSString
    var imagesrc : NSString
    var imagesrc1 : NSString
    var imagesrc2 : NSString
    var flag : Int
    init(dic : NSDictionary) {
        self.title = dic["title"] as NSString
        self.digest = dic["digest"] as NSString
        self.imagesrc = dic["imgsrc"] as NSString
        self.flag = 0;
        self.imagesrc1 = ""
        self.imagesrc2 = ""
        
        if (dic["imgextra"]) {
            self.flag = 1;
            let imgextra = dic["imgextra"] as NSArray
            let imageDic1 = imgextra[0] as NSDictionary
            let imageDic2 = imgextra[1] as NSDictionary
            self.imagesrc1 = imageDic1["imgsrc"] as NSString
            self.imagesrc2 = imageDic2["imgsrc"] as NSString
        }
    }
}
