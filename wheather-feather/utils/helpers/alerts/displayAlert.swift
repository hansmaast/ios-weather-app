//
//  displayAlert.swift
//  wheather-feather
//
//  Created by Hans Maast on 05/11/2020.
//

import UIKit

func displayAlert(_ err: Error, to parent: UIViewController) {
    
    let msg = err.localizedDescription
    let alertController = UIAlertController(title: "🚧 Hold up! 🚧", message: msg, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(alertAction)
    
    print("💥💥💥💥")
    print(err)
    
    DispatchQueue.main.async {
        parent.present(alertController, animated: true, completion: nil)
    }
    
}
