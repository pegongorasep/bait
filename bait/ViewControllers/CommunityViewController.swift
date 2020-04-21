//
//  FirstViewController.swift
//  bait
//
//  Created by Pedro Antonio Góngora Sepúlveda on 21/04/20.
//  Copyright © 2020 Pedro Antonio Góngora Sepúlveda. All rights reserved.
//

import UIKit

class CommunityViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
            
    private lazy var summaryViewController: TicketsViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "TicketsViewController") as! TicketsViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var sessionsViewController: AnouncementsViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "AnouncementsViewController") as! AnouncementsViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
        
    static func viewController() -> CommunityViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SegementedView") as! CommunityViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        navigationItem.title = "Comunidad"
        
        let title = NSMutableAttributedString(string: "Crear ticket de ayuda", attributes:[
            .font: UIFont.systemFont(ofSize: 10.0) ])
        let firstLabel = UILabel()
        firstLabel.attributedText = title
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(userSettings))
        firstLabel.addGestureRecognizer(tap)
        firstLabel.isUserInteractionEnabled = true
        
        let addTicket = UIBarButtonItem(customView: firstLabel)
        navigationItem.rightBarButtonItem  = addTicket
    }
        
    @objc func userSettings(){
        print("clicked")
        
        let CreateTicketVC = self.storyboard!.instantiateViewController(withIdentifier: "TicketsViewController") as! TicketsViewController
        CreateTicketVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(CreateTicketVC, animated: true)
    }
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        updateView()
    }
    
        
    private func add(asChildViewController viewController: UIViewController) {
        
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
        
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
        
    private func updateView() {
        if segmentControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: sessionsViewController)
            add(asChildViewController: summaryViewController)
        } else {
            remove(asChildViewController: summaryViewController)
            add(asChildViewController: sessionsViewController)
        }
    }
    
    
    func setupView() {
//        setupSegmentedControl()
        
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
