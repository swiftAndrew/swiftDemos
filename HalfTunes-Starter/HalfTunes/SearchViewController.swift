//
//  SearchViewController.swift
//  HalfTunes
//
//  Created by Ken Toh on 13/7/15.
//  Copyright (c) 2015 Ken Toh. All rights reserved.
//

import UIKit
import MediaPlayer

class SearchViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
    
    let defaultSession=NSURLSession(configuration:NSURLSessionConfiguration.defaultSessionConfiguration());
    var dataTask:NSURLSessionDataTask?
    
    var activeDownloads = [String: Download]()
    
   
    
    lazy var downloadSession : NSURLSession = {
       // let configuration=NSURLSessionConfiguration.defaultSessionConfiguration();
        let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("bgSessionConfiguration")
        let session=NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil);
        return session;
    }()

  var searchResults = [Track]()
  
  lazy var tapRecognizer: UITapGestureRecognizer = {
    var recognizer = UITapGestureRecognizer(target:self, action: "dismissKeyboard")
    return recognizer
  }()
  
  // MARK: View controller methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
    
   
    
  
  }
  
    func trackIndexForDownloadTask(downloadTask:NSURLSessionDownloadTask)->Int?{
      
        if let url=downloadTask.originalRequest?.URL?.absoluteString{
            for (index,track) in searchResults.enumerate(){
                if(url == track.previewUrl){
                    return index;
                }
            }
        }
        return nil;
    }
  
  // MARK: Handling Search Results
  
  // This helper method helps parse response JSON NSData into an array of Track objects.
  func updateSearchResults(data: NSData?) {
    searchResults.removeAll()
    do {
      if let data = data, response = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue:0)) as? [String: AnyObject] {
        
        // Get the results array
        if let array: AnyObject = response["results"] {
          for trackDictonary in array as! [AnyObject] {
            if let trackDictonary = trackDictonary as? [String: AnyObject], previewUrl = trackDictonary["previewUrl"] as? String {
              // Parse the search result
              let name = trackDictonary["trackName"] as? String
              let artist = trackDictonary["artistName"] as? String
              searchResults.append(Track(name: name, artist: artist, previewUrl: previewUrl))
            } else {
              print("Not a dictionary")
            }
          }
        } else {
          print("Results key not found in dictionary")
        }
      } else {
        print("JSON Error")
      }
    } catch let error as NSError {
      print("Error parsing results: \(error.localizedDescription)")
    }
    
    dispatch_async(dispatch_get_main_queue()) {
      self.tableView.reloadData()
      self.tableView.setContentOffset(CGPointZero, animated: false)
    }
  }
  
  // MARK: Keyboard dismissal
  
  func dismissKeyboard() {
    searchBar.resignFirstResponder()
  }
  
  // MARK: Download methods
  
  // Called when the Download button for a track is tapped
  func startDownload(track: Track) {
    // TODO
    if let urlString=track.previewUrl ,let url=NSURL(string: urlString){
        let download=Download(url: urlString);
        download.downloadTask=downloadSession.downloadTaskWithURL(url);
        download.downloadTask!.resume();
        
        download.isDonwloading=true;
        activeDownloads[download.url]=download;
    }
    
  }
  
  // Called when the Pause button for a track is tapped
  func pauseDownload(track: Track) {
    // TODO
    
    if let urlString = track.previewUrl,download=activeDownloads[urlString]{
        if(download.isDonwloading){
         download.downloadTask?.cancelByProducingResumeData({ (data) -> Void in
            if(data != nil){
                download.resumeData=data;
            }
         })
            
            download.isDonwloading=false;
        }
    }
  }
  
  // Called when the Cancel button for a track is tapped
  func cancelDownload(track: Track) {
    // TODO
    if let urlString = track.previewUrl,download=activeDownloads[urlString]{
        download.downloadTask?.cancel();
        activeDownloads[urlString]=nil
    }
    
  }
  
  // Called when the Resume button for a track is tapped
  func resumeDownload(track: Track) {
    // TODO
    
    if let urlString=track.previewUrl,download=activeDownloads[urlString]{
        if let resumeData=download.resumeData{
         download.downloadTask=downloadSession.downloadTaskWithResumeData(resumeData)
            download.downloadTask!.resume()
            
            download.isDonwloading=true
            
        }else if let url = NSURL(string: download.url){
         download.downloadTask=downloadSession.downloadTaskWithURL(url)
            download.downloadTask!.resume()
            download.isDonwloading=true
            
        }
        
    }
  }
  
   // This method attempts to play the local file (if it exists) when the cell is tapped
  func playDownload(track: Track) {
    if let urlString = track.previewUrl, url = localFilePathForUrl(urlString) {
      let moviePlayer:MPMoviePlayerViewController! = MPMoviePlayerViewController(contentURL: url)
      presentMoviePlayerViewControllerAnimated(moviePlayer)
    }
  }
  
  // MARK: Download helper methods
  
  // This method generates a permanent local file path to save a track to by appending
  // the lastPathComponent of the URL (i.e. the file name and extension of the file)
  // to the path of the app’s Documents directory.
  func localFilePathForUrl(previewUrl: String) -> NSURL? {
    let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
    if let url = NSURL(string: previewUrl), lastPathComponent = url.lastPathComponent {
        let fullPath = documentsPath.stringByAppendingPathComponent(lastPathComponent)
        return NSURL(fileURLWithPath:fullPath)
    }
    return nil
  }
  
  // This method checks if the local file exists at the path generated by localFilePathForUrl(_:)
  func localFileExistsForTrack(track: Track) -> Bool {
    if let urlString = track.previewUrl, localUrl = localFilePathForUrl(urlString) {
      var isDir : ObjCBool = false
      if let path = localUrl.path {
        return NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDir)
      }
    }
    return false
  }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        dismissKeyboard()
        
        if !searchBar.text!.isEmpty {
            // 1
            if dataTask != nil {
                dataTask?.cancel()
            }
            // 2
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            // 3
            let expectedCharSet = NSCharacterSet.URLQueryAllowedCharacterSet()
            let searchTerm = searchBar.text!.stringByAddingPercentEncodingWithAllowedCharacters(expectedCharSet)!
            // 4
            let url = NSURL(string: "https://itunes.apple.com/search?media=music&entity=song&term=\(searchTerm)")
            // 5
            dataTask = defaultSession.dataTaskWithURL(url!) {
                data, response, error in
                // 6
                dispatch_async(dispatch_get_main_queue()) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
                // 7
                if let error = error {
                    print(error.localizedDescription)
                } else if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        self.updateSearchResults(data)
                    }
                }
            }
            // 8
            dataTask?.resume()
        }
    }
  func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
    return .TopAttached
  }
    
  func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    view.addGestureRecognizer(tapRecognizer)
  }
    
  func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    view.removeGestureRecognizer(tapRecognizer)
  }
}

// MARK: TrackCellDelegate

extension SearchViewController: TrackCellDelegate {
  func pauseTapped(cell: TrackCell) {
    if let indexPath = tableView.indexPathForCell(cell) {
      let track = searchResults[indexPath.row]
      pauseDownload(track)
      tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)], withRowAnimation: .None)
    }
  }
  
  func resumeTapped(cell: TrackCell) {
    if let indexPath = tableView.indexPathForCell(cell) {
      let track = searchResults[indexPath.row]
      resumeDownload(track)
      tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)], withRowAnimation: .None)
    }
  }
  
  func cancelTapped(cell: TrackCell) {
    if let indexPath = tableView.indexPathForCell(cell) {
      let track = searchResults[indexPath.row]
      cancelDownload(track)
      tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)], withRowAnimation: .None)
    }
  }
  
  func downloadTapped(cell: TrackCell) {
    if let indexPath = tableView.indexPathForCell(cell) {
      let track = searchResults[indexPath.row]
      startDownload(track)
      tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)], withRowAnimation: .None)
    }
  }
}

// MARK: UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchResults.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell", forIndexPath: indexPath) as!TrackCell
    
    // Delegate cell button tap events to this view controller
    cell.delegate = self
    
    let track = searchResults[indexPath.row]
    
    // Configure title and artist labels
    cell.titleLabel.text = track.name
    cell.artistLabel.text = track.artist
    
    var showDownloadControls=false;
    if let download=activeDownloads[track.previewUrl!]{
        showDownloadControls=true;
        
        cell.progressLabel.text=(download.isDonwloading) ? "Downloading..." : "Paused";
        cell.progressView.progress=download.progress;
        
        let title = (download.isDonwloading) ? "Pause" : "Resume"
        cell.pauseButton.setTitle(title, forState: UIControlState.Normal)
    }
    cell.progressView.hidden = !showDownloadControls
    cell.progressLabel.hidden = !showDownloadControls
    
    cell.pauseButton.hidden = !showDownloadControls
    cell.cancelButton.hidden = !showDownloadControls
    
    

    // If the track is already downloaded, enable cell selection and hide the Download button
    let downloaded = localFileExistsForTrack(track)
    cell.selectionStyle = downloaded ? UITableViewCellSelectionStyle.Gray : UITableViewCellSelectionStyle.None
    //cell.downloadButton.hidden = downloaded
    cell.downloadButton.hidden = downloaded || showDownloadControls
    return cell
  }
}

// MARK: - NSURLSessionDownload Delegate
extension SearchViewController: NSURLSessionDownloadDelegate {
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        print("Finished downloading.")
        
        if let originalURL=downloadTask.originalRequest?.URL?.absoluteString,destinationURL=localFilePathForUrl(originalURL){
            print(destinationURL);
            
            let fileManager=NSFileManager.defaultManager();
            do{
                try fileManager.removeItemAtURL(destinationURL);
            }catch{
             
            }
            
            do{
                try fileManager.copyItemAtURL(location, toURL: destinationURL);
            }catch let error as NSError{
              print("Could not copy file to disk: \(error.localizedDescription)")
            }
        }
        
        // 3
        if let url = downloadTask.originalRequest?.URL?.absoluteString {
            activeDownloads[url] = nil
            // 4
            if let trackIndex = trackIndexForDownloadTask(downloadTask) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: trackIndex, inSection: 0)], withRowAnimation: .None)
                })
            }
        }
    }
    
    
    /* Sent periodically to notify the delegate of download progress. */
    
     func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        if let downloadUrl=downloadTask.originalRequest?.URL?.absoluteString,download=activeDownloads[downloadUrl]{
            download.progress=Float(totalBytesWritten)/Float(totalBytesExpectedToWrite);
            let totalSize=NSByteCountFormatter.stringFromByteCount(totalBytesExpectedToWrite, countStyle: NSByteCountFormatterCountStyle.Binary);
            
            if let trackIndex=trackIndexForDownloadTask(downloadTask),let trackCell=tableView.cellForRowAtIndexPath(NSIndexPath(forRow: trackIndex, inSection: 0)) as? TrackCell{
             dispatch_async(dispatch_get_main_queue(), { () -> Void in
                trackCell.progressView.progress=download.progress;
                trackCell.progressLabel.text =  String(format: "%.1f%% of %@",  download.progress * 100, totalSize)
             });
             }
        }
    }
    
    /* Sent when a download has been resumed. If a download failed with an
    * error, the -userInfo dictionary of the error will contain an
    * NSURLSessionDownloadTaskResumeData key, whose value is the resume
    * data.
    */
    
     func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64){
        
    }
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        if let appDelegate=UIApplication.sharedApplication().delegate as? AppDelegate{
            
            if let completionHandler=appDelegate.backgroundSessionCompletionHandler{
                appDelegate.backgroundSessionCompletionHandler=nil
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler()
                })
            }
        }
    }
}


// MARK: UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 62.0
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let track = searchResults[indexPath.row]
    if localFileExistsForTrack(track) {
      playDownload(track)
    }
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
    

  

}

