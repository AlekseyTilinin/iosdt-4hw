//
//  FileViewController.swift
//  iosdt-4hw
//
//  Created by Aleksey on 07.01.2023.
//

import Foundation
import UIKit

class FileViewController: UIViewController, UITableViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var currentDirectory: URL = FileManagerService().documentsDirectoryUrl
    var content: [String] = []

    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "defaultTableCellIdentifier")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        content = FileManagerService().contentsOfDirectory(currentDirectory)

        let createFolderItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createFolder))
        let addPhotoItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addPhoto))
        navigationItem.rightBarButtonItems = [addPhotoItem, createFolderItem]
        
        
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc
    func createFolder() {
        showInputDialog(title: "Create a new folder", actionHandler:  { text in
            if let result = text {
                let url = self.currentDirectory.appendingPathComponent(result)

                FileManagerService().createDirectory(url) {
                    self.content = FileManagerService().contentsOfDirectory(self.currentDirectory)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }

    @objc
    func addPhoto() {
        present(imagePicker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        if let rawURL = info[.imageURL] {
            let stringURL = String(describing: rawURL)
            let url = URL(string: stringURL)

            if let url = url {
                let destination = currentDirectory.appendingPathComponent(url.lastPathComponent)

                FileManagerService().copyFile(from: url, to: destination) {
                    self.content = FileManagerService().contentsOfDirectory(self.currentDirectory)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }

                    imagePicker.dismiss(animated: true)
                }
            }
        }

    }
    
}

extension FileViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let URL = currentDirectory.appendingPathComponent(content[indexPath.row])

        if FileManagerService().checkDirectory(URL) {

            let viewController = FileViewController()
            viewController.currentDirectory = URL
            viewController.content = FileManagerService().contentsOfDirectory(viewController.currentDirectory)
            viewController.title = "\(content[indexPath.row])"
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let url = currentDirectory.appendingPathComponent(content[indexPath.row])

            FileManagerService().removeContent(url) {
                self.content = FileManagerService().contentsOfDirectory(self.currentDirectory)
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultTableCellIdentifier", for: indexPath)
        cell.textLabel?.text = content[indexPath.row]

        if FileManagerService().checkDirectory(currentDirectory.appendingPathComponent(content[indexPath.row])) {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
}
