//
//  ViewController.swift
//  exampleapp
//
//  Created by Jin park on 29/9/22.
//

import UIKit
import SwiftUI

final class ViewModel: ObservableObject {
    @Published var text: String
    
    init(text: String) {
        self.text = text
    }
}

struct TextView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        Text(viewModel.text)
            .background(Color.green)
            .fixedSize()
    }
}

final class Cell: UITableViewCell {
    var viewModel: ViewModel?
    var view: UIView?
}

final class ViewController: UIViewController, UITableViewDataSource {

    private let data = [
        "asdljkfhaklsdjfhadjsklasdd",
        "asdjkfasdfadsfasdf",
        "asdflkjhasd",
        "asdkj",
        "asd",
        "asdflkjhasdjkfhasdljfkads",
        "asdfkjhasdjkfasdhjkfgkajdshfgadjshkfgjkadsf",
        "asdfklj",
        "asdfkljddasfasdfagg",
        "glkjlggd",
        "asdljkfhaklsdjfhadjsklasdd",
        "asdjkfasdfadsfasdf",
        "asdflkjhasd",
        "asdkj",
        "asd",
        "asdflkjhasdjkfhasdljfkads",
        "asdfkjhasdjkfasdhjkfgkajdshfgadjshkfgjkadsf",
        "asdfklj",
        "asdfkljddasfasdfagg",
        "glkjlggd",
        "asdljkfhaklsdjfhadjsklasdd",
        "asdjkfasdfadsfasdf",
        "asdflkjhasd",
        "asdkj",
        "asd",
        "asdflkjhasdjkfhasdljfkads",
        "asdfkjhasdjkfasdhjkfgkajdshfgadjshkfgjkadsf",
        "asdfklj",
        "asdfkljddasfasdfagg",
        "glkjlggd",
        "asdljkfhaklsdjfhadjsklasdd",
        "asdjkfasdfadsfasdf",
        "asdflkjhasd",
        "asdkj",
        "asd",
        "asdflkjhasdjkfhasdljfkads",
        "asdfkjhasdjkfasdhjkfgkajdshfgadjshkfgjkadsf",
        "asdfklj",
        "asdfkljddasfasdfagg",
        "glkjlggd",
        "asdljkfhaklsdjfhadjsklasdd",
        "asdjkfasdfadsfasdf",
        "asdflkjhasd",
        "asdkj",
        "asd",
        "asdflkjhasdjkfhasdljfkads",
        "asdfkjhasdjkfasdhjkfgkajdshfgadjshkfgjkadsf",
        "asdfklj",
        "asdfkljddasfasdfagg",
        "glkjlggd"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(Cell.self, forCellReuseIdentifier: "Identifier")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    /*
     This is the part you want to take a look at.
     Note that this only happens in actual device, not simulator. Didn't confirm iOS 16 yet.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Identifier") as! Cell
        
        // While filling up reusable queue, there is no problem...
        if cell.view == nil {
            let viewModel = ViewModel(text: data[indexPath.row])
            let controller = UIHostingController(rootView: TextView(viewModel: viewModel))
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            cell.view = controller.view
            cell.viewModel = viewModel
            cell.contentView.addSubview(controller.view)
            
            NSLayoutConstraint.activate([
                cell.contentView.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor),
                cell.contentView.topAnchor.constraint(equalTo: controller.view.topAnchor)
            ])
        } else {
            // But here, if we modify ObservableObject,
            cell.viewModel?.text = data[indexPath.row]
            
            // We need all three API calls. in exact same sequance, in order to reflect SwiftUI view's size to UIKit's view.
            cell.view?.setNeedsLayout()
            cell.view?.layoutIfNeeded()
            cell.view?.invalidateIntrinsicContentSize()
        }
        
        return cell
    }
}

