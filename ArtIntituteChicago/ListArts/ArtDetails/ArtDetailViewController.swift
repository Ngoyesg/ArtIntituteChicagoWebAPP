//
//  ArtDetailViewController.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 8/04/22.
//

import UIKit

protocol ArtDetailViewControllerProtocol: AnyObject {
    func alertDownloadedFailed(error message: Error)
    func setTitle(with title: String?)
    func setArtist(with artistName: String?)
    func setArtistBirthdate(with date: Int?)
    func setArtistDateOfDeath(with date: Int?)
    func setArtID(with id: Int?)
    func setImage(with image: UIImage?)
    func displayInfoBox()
    func startSpinner()
    func stopSpinner()
}

class ArtDetailViewController: UIViewController {
    struct Constants {
        static let alertDownloadedFailedTitle = "Error"
        static let okTitle = "OK"
        static let infoNonFound = "Information not found"
    }
    
    private let brain: ArtDetailBrainProtocol = ArtDetailBrain()
    
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var infoToDisplayView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var artistBirthdate: UILabel!
    @IBOutlet private weak var artistDateOfDeath: UILabel!
    @IBOutlet private weak var artworkIDLabel: UILabel!
    @IBOutlet private weak var artImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brain.setController(controller: self)
        brain.processViewDidLoad()
    }
}

extension ArtDetailViewController: ArtDetailViewControllerProtocol {
    func startSpinner(){
        spinner.startAnimating()
    }
    func stopSpinner(){
        spinner.isHidden = true
        spinner.stopAnimating()
    }
    func setHistoryDisplay(){
        brain.setComingFromHistory()
    }
    func displayInfoBox(){
        self.infoToDisplayView.isHidden = false
    }
    func receiveID(id: Int){
        brain.setIDToFetch(id: id)
    }
    func alertDownloadedFailed(error message: Error){
        let alert = UIAlertController(title: Constants.alertDownloadedFailedTitle, message: message.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.okTitle, style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    func setTitle(with title: String?) {
        titleLabel.text = title ?? Constants.infoNonFound
    }
    func setArtist(with artistName: String?) {
        artistLabel.text = "Artist: \(artistName ?? Constants.infoNonFound)"
    }
    func setArtistBirthdate(with date: Int?) {
        artistBirthdate.text = "Date of birth: \( date == nil ? Constants.infoNonFound : String(date!) )"
    }
    func setArtistDateOfDeath(with date: Int?) {
        artistDateOfDeath.text = "Date of death: \( date == nil ? Constants.infoNonFound : String(date!) )"
    }
    func setArtID(with id: Int?) {
        artworkIDLabel.text = "Artwork ID: \( id == nil ? Constants.infoNonFound : String(id!))"
    }
    
    func setImage(with image: UIImage?){
        artImage.image = image ?? UIImage(named: "imageNotFound")
    }
}
