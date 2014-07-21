
import UIKit

class NewsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView:UITableView?
    var refreshControl:UIRefreshControl?
    var refreshControl1:UIActivityIndicatorView?
    var timer:NSTimer?
    var pageIndex:Int?
    let hackerNewsApiUrl = "http://c.m.163.com/nc/article/headline/T1348647853363/0-20.html"
    
    var dataSource = NSMutableArray()
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
        self.pageIndex = 0
    }
    func requestData() {
        var newsStr = "http://c.m.163.com/nc/article/headline/T1348647853363/\(self.pageIndex!)-20.html"
        var url = NSURL.URLWithString(newsStr)
        var request = NSURLRequest(URL:url)
        var queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: { response, data, error in
            self.refreshControl?.endRefreshing()
            if error {
                println(error)
            } else {
                let json = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                let newsDataSource = json["T1348647853363"] as NSArray
                if self.pageIndex == 0 {
                    self.dataSource.removeAllObjects()
                }
                for dic1 : AnyObject in newsDataSource {
                    let newDic = dic1 as NSDictionary
                    let newsItem = NewsItem(dic: dic1 as NSDictionary)
                    self.dataSource.addObject(newsItem)
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.refreshControl?.endRefreshing()
                    if self.timer {
                        self.timer!.invalidate()
                    }
                    if self.refreshControl1 && self.refreshControl1!.isAnimating() {
                        self.refreshControl1!.stopAnimating()
                    }
                    self.tableView!.reloadData()
                })
            }
            })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "网易新闻"
        self.navigationController.navigationBar.barTintColor = UIColor.redColor()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.redColor();
        self.layoutTableView()
        self.requestData()
        self.layoutRefreshViewHeaderView()
    }
    func layoutRefreshViewHeaderView() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "下拉刷新")
        self.refreshControl!.addTarget(self, action: "loadDataSource", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView?.addSubview(self.refreshControl)
    }
    func loadDataSource() {
        self.refreshControl?.beginRefreshing()
        self.pageIndex = 0
        self.requestData() //请求网络信息
    }
    func layoutTableView() {
        self.tableView = UITableView(frame:self.view.bounds, style:.Plain)
        self.tableView!.registerClass(NewsShowCell.self, forCellReuseIdentifier: "reuse1")
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuse3")
        self.tableView!.registerClass(NewsImageShowCell.self, forCellReuseIdentifier: "reuse2")
        self.tableView!.dataSource = self;
        self.tableView!.delegate = self;
        self.view.addSubview(self.tableView)
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource.count == 0 {
            return 0
        } else {
            return self.dataSource.count + 1
        }
    }
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        if indexPath.row == self.dataSource.count {
            var cell = tableView.dequeueReusableCellWithIdentifier("reuse3",  forIndexPath:indexPath) as UITableViewCell
            self.refreshControl1 = UIActivityIndicatorView(activityIndicatorStyle:.Gray)
            self.refreshControl1!.frame = CGRectMake(85,0,30,30)
            cell.contentView.addSubview(self.refreshControl1)
            
            let showLabel = UILabel(frame:CGRectMake(125, 0, 100,30))
            showLabel.font = UIFont.systemFontOfSize(15)
            showLabel.text = "正在刷新...."
            showLabel.textColor = UIColor.lightGrayColor()
            cell.contentView.addSubview(showLabel)
            return cell
        } else {
            let newsItem = self.dataSource.objectAtIndex(indexPath.row) as NewsItem
            if newsItem.flag == 0 {
                var cell = tableView.dequeueReusableCellWithIdentifier("reuse1",  forIndexPath:indexPath) as NewsShowCell
                cell.titleLabel!.text = newsItem.title
                cell.digestLabel!.text = newsItem.digest
                cell.photoView!.imageURL = NSURL.URLWithString(newsItem.imagesrc)
                return cell;
            } else {
                var cell = tableView.dequeueReusableCellWithIdentifier("reuse2",  forIndexPath:indexPath) as NewsImageShowCell
                cell.titleLabel!.text = newsItem.title
                cell.firstImageView!.imageURL = NSURL.URLWithString(newsItem.imagesrc)
                cell.secondImageView!.imageURL = NSURL.URLWithString(newsItem.imagesrc1)
                cell.thirdImageView!.imageURL = NSURL.URLWithString(newsItem.imagesrc2)
                return cell;
            }
        }
    }
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!) {
        if indexPath.row == self.dataSource.count {
            self.refreshControl1!.startAnimating()
            self.pageIndex = self.pageIndex! + 20;
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "requestData", userInfo: nil, repeats: true)
        }
    }
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var detailVC:NewsDetailViewController = NewsDetailViewController(nibName: nil, bundle: nil)
        self.navigationController.pushViewController(detailVC, animated: true)
    }
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if indexPath.row != self.dataSource.count {
            let newsItem = self.dataSource.objectAtIndex(indexPath.row) as NewsItem
            if newsItem.flag == 0 {
                return 80
            } else {
                return 110
            }
        } else {
            return 30
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
