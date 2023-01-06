//
//  FileModel.swift
//  iosdt-4hw
//
//  Created by Aleksey on 07.01.2023.
//

import Foundation
import UIKit

protocol FileManagerServiceProtocol {
    
    func contentsOfDirectory(_ url: URL) -> [String]
    func createDirectory(_ url: URL, complition: () -> Void)
    func copyFile(from url: URL, to destination: URL, complition: () -> Void)
    func removeContent(_ url: URL, complition: () -> Void)
}

class FileManagerService: FileManagerServiceProtocol{

    let documentsDirectoryUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)

    func contentsOfDirectory(_ url: URL) -> [String]{
        var content: [String] = []

        do {
            let URLs = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [], options: .skipsHiddenFiles)

            for url in URLs {
                content.append(url.lastPathComponent)
            }

            return content
            
        } catch {
            print(error)
        }

        return []
    }

    func createDirectory(_ url: URL, complition: () -> Void) {
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false)
            complition()
        } catch {
            print(error)
        }
    }

    func copyFile(from url: URL, to destination: URL, complition: () -> Void) {
        do {
            try FileManager.default.copyItem(at: url, to: destination)
            complition()
        } catch {
            print(error)
        }
    }

    func removeContent(_ url: URL, complition: () -> Void) {
        do {
            try FileManager.default.removeItem(at: url)
            complition()
        } catch {
            print(error)
        }
    }

    func checkDirectory(_ url : URL) -> Bool {
        url.isDirectory
    }

}

extension URL {
    var isDirectory: Bool {
        (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}

extension UIViewController {
    
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))

        self.present(alert, animated: true, completion: nil)
    }
}
