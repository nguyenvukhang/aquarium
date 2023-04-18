//
//  ViewController.swift
//  Aquarium
//
//  Created by Quan Teng Foong on 18/4/23.
//

import UIKit
import Engine

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Engine()
        // Do any additional setup after loading the view.
        let link = "https://aquarium2.vercel.app/api/get?id="
        let id = "MDo4LDM0MCw5OTA="
        let url = URL(string: link + id)
        // let (data, _, _) = URLSession.synchrosynchronousDataTask(with: url)
    }


}

