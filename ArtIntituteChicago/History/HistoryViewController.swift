//
//  HistoryViewController.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 8/04/22.
//

import UIKit

protocol HistoryViewControllerProtocol: AnyObject {
    func reloadTable()
    func goToArtDetailsViewController()
}

class HistoryViewController: UIViewController {
    struct  Constants{
        static let cellIdentifier = "seenArtworkCell"
        static let segueToArtDetails = "toArtDetails"
    }
    
    let brain: HistoryBrainProtocol = HistoryBrain()
    
    @IBOutlet weak var historyTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        brain.setController(controller: self)
        historyTableView.delegate = self
        historyTableView.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        brain.processViewDidAppear()
    }
}

extension HistoryViewController: HistoryViewControllerProtocol {
    func goToArtDetailsViewController(){
        performSegue(withIdentifier: Constants.segueToArtDetails, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ArtDetailViewController {
            let idToSend = brain.getIdForDetails()
            destination.setHistoryDisplay()
            destination.receiveID(id: idToSend)
        }
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brain.getNumberOfRows()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        let cellInfo = brain.getArtWork(for: indexPath.row)
        cell.detailTextLabel?.text = cellInfo.artist
        cell.textLabel?.text = cellInfo.title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        brain.artWorkWasSelected(at: indexPath.row)
    }
    func reloadTable(){
        historyTableView.reloadData()
    }
}
