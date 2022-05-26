//
//  ListArtsViewController.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 8/04/22.
//

import UIKit

protocol ListArtsViewControllerProtocol: AnyObject {
    func alertDownloadedFailed()
    func setLastSeenTitle(_ title: String)
    func setLastSeenArtist(_ artist: String)
    func setLastSeenDate(_ date: String)
    func hideLastSeenInfoBox()
    func showLastSeenInfoBox()
    func reloadTable()
    func goToArtDetailsViewController()
    func startSpinner()
    func stopSpinner()
}

class ListArtsViewController: UIViewController {
    struct Constants {
        static let segueToArtDetails = "ToArtDetail"
        static let alertDownloadedFailedTitle = "Error"
        static let alertDownloadedFailedMessage = "Download Failed"
        static let okTitle = "OK"
        static let cellIdentifier = "ArtworkCell"
        static let distanceFromBottom = 200.0
    }
    
    private let brain: ListArtsBrainProtocol = ListArtBrainBuilder.build()
    
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var artWorkTableView: UITableView!
    @IBOutlet private weak var lastSeenInfoBox: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var lastVisitedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brain.setController(controller: self)
        artWorkTableView.delegate = self
        artWorkTableView.dataSource = self
        brain.processDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
       // brain.processViewDidAppear()
    }
}

extension ListArtsViewController: ListArtsViewControllerProtocol {
    func startSpinner(){
        spinner.startAnimating()
    }
    func stopSpinner(){
        spinner.stopAnimating()
    }
    func alertDownloadedFailed(){
        let alert = UIAlertController(title: Constants.alertDownloadedFailedTitle, message: Constants.alertDownloadedFailedMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.okTitle, style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    func setLastSeenTitle(_ title: String) {
        self.titleLabel.text = title
    }
    func setLastSeenArtist(_ artist: String) {
        self.artistLabel.text = artist
    }
    func setLastSeenDate(_ date: String) {
        self.lastVisitedLabel.text = date
    }
    func hideLastSeenInfoBox(){
        self.lastSeenInfoBox.isHidden = true
    }
    func showLastSeenInfoBox(){
        self.lastSeenInfoBox.isHidden = false
    }
    func goToArtDetailsViewController(){
        performSegue(withIdentifier: Constants.segueToArtDetails, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ArtDetailViewController {
            let idToSend = brain.getIdForDetails()
            destination.receiveID(id: idToSend)
        }
    }
}

extension ListArtsViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brain.getNumberOfRows()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = artWorkTableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        let cellInfo = brain.getArtWork(for: indexPath.row)
        cell.detailTextLabel?.text = cellInfo.artist
        cell.textLabel?.text = cellInfo.title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        brain.artWorkWasSelected(at: indexPath.row)
    }
    
    private func minimumHeightForScrollReload(_ scrollView: UIScrollView) -> Double {
        let tableViewContentHeight = artWorkTableView.contentSize.height
        let scrollviewFrameHeight = scrollView.frame.size.height
        return tableViewContentHeight - Constants.distanceFromBottom - scrollviewFrameHeight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > minimumHeightForScrollReload(scrollView) {
            brain.downloadMoreData()
        }
    }
    func reloadTable(){
        artWorkTableView.reloadData()
    }
}
