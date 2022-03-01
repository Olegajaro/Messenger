//
//  ChatsTableViewController.swift
//  Messenger
//
//  Created by Олег Федоров on 26.02.2022.
//

import UIKit

class ChatsTableViewController: UITableViewController {

    // MARK: - Variables
    var allRecents: [RecentChat] = []
    var filteredRecents: [RecentChat] = []
    
    let firebaseRecentChatListener = FirebaseRecentChatListener.shared
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 85
        setupSearchController()
        dowloadRecentChats()
    }
    
    // MARK: - Setup Views
    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search user"
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }
    
    // MARK: - Download Chats
    private func dowloadRecentChats() {
        firebaseRecentChatListener.downloadRecentChatsFromFirestore { [weak self] allRecents in
            self?.allRecents = allRecents
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Helpers
    private func filteredContentForSearchText(searchText: String) {
        
        filteredRecents = allRecents.filter { recentChat -> Bool in
            return recentChat.receiverName.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension ChatsTableViewController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredRecents.count : allRecents.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "chatCell", for: indexPath
        ) as! RecentTableViewCell
        
        let recentChat = searchController.isActive
        ? filteredRecents[indexPath.row]
        : allRecents[indexPath.row]
        
        cell.configure(recent: recentChat)

        return cell
    }
}

// MARK: - UISearchResultsUpdating
extension ChatsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
