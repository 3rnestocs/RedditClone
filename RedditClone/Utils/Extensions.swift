//
//  Extensions.swift
//  RedditClone
//
//  Created by Ernesto Jose Contreras Lopez on 15/5/23.
//

import Foundation
import UIKit

extension Dictionary {
    func objectVersion<T: Codable>(type: T.Type) -> T? {
        let data = try? JSONSerialization.data(withJSONObject: self)
        let decodedData = try? JSONDecoder().decode(type, from: data ?? Data())
        return decodedData
    }
}

extension Notification.Name {
    static let retrievePosts = Notification.Name("retrievePosts")
}

extension DateFormatter {
    static func unixToStringDate(_ unix: Double?, format: String = "MM/dd/yyyy") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let unix = unix {
            return dateFormatter.string(from: Date(timeIntervalSince1970: unix))
        } else {
            return nil 
        }
    }
}

extension UIViewController {
    enum ViewController: String {
        case detailVC = "DetailViewController"
    }
    
    func getVC(_ vc: ViewController) -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: vc.rawValue)
        return viewController
    }
}

extension UIColor {
    convenience init(hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

            if (cString.hasPrefix("#")) {
                cString.remove(at: cString.startIndex)
            }

            var rgbValue: UInt64 = 0
            Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: 1.0)
    }
}

extension UITableViewCell {
    func addIndicator() {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        activityIndicatorView.startAnimating()
    }
}
