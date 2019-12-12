//
//  LobbyNameViewController.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 09/12/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import UIKit

class LobbyNameViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lobbyNameTextField: UITextField!
    var lobbyVC: LobbyViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        bgView.layer.cornerRadius = 20

        lobbyNameTextField.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        lobbyNameTextField.resignFirstResponder()
        return false
    }

    @objc func dismissKeyboard() {
        lobbyNameTextField.resignFirstResponder()
    }

    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func backBtnTapped(_ sender: UIButton) {
        lobbyVC?.navigationController?.popViewController(animated: true)
        dismissVC()
    }

    @IBAction func continueBtnTapped(_ sender: UIButton) {
        guard let lobbyName = lobbyNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            lobbyNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" else { return }
        lobbyVC?.lobbyName = lobbyName.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
        dismissVC()
    }

}
