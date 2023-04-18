//
//  ViewController.swift
//  Aquarium
//
//  Created by Quan Teng Foong on 18/4/23.
//

import UIKit
import Engine

class ViewController: UIViewController {

    @IBOutlet weak var urlTextField: UITextField!
    
    var board: Board!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.engine = Engine()
        
        /*
        let link = "https://aquarium2.vercel.app/api/get?id="
        let id = "MDo4LDM0MCw5OTA="
        let url = URL(string: link + id)
        
        let boardData = BoardData.create(from: url)
        let board = Board(from: boardData)
         */
    }
    
    @IBAction func solveButtonPressed(_ sender: Any) {
        guard let urlString = urlTextField.text else {
            return
        }
        let url = URL(string: urlString)
        let boardData = BoardData.create(from: url)
        let board = Board(from: boardData)
        self.board = board
        // engine.load(board)
        // engine.solve()
    }
}

