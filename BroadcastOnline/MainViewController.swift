//
//  MainViewController.swift
//  BroadcastOnline
//
//  Created by Artyom on 08.09.2022.
//

import UIKit
import SkeletonView
import SnapKit

class MainViewController: UIViewController, MainViewInput {
    func showLoader() {
        
    }
    
    func hideLoader() {
        
    }
    var contentIsLoaded: Bool = false
    private weak var tournamentsCollection: CyberSportTournamentsCollection!
    public var presenter: MainPresenter!
    private weak var gamesCollection: CyberSportGamesCollection!
    private weak var filtersCollection: CyberSportFiltersCollection!

    @IBOutlet var segmentedController: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MainPresenter(view: self)
        setupGamesCollection()
   
        setupFilterCollection()
//        setupSegmentedControll()
        setupTournamentsCollection()
        presenter.viewDidLoad()
        bindFiltersCollection()
        bindTournamentCollection()

        let label = UILabel()
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8686360744)
        
        label.text = "Киберспорт"
        label.font = R.font.robotoBold(size: 24)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
      
        
    }
    
    func setupSegmentedControll() {
        view.addSubview(segmentedController)
        segmentedController.snp.makeConstraints {
            $0.top.equalTo(gamesCollection.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       
       AppUtility.lockOrientation(.portrait)
  
   }


    func bindTournamentCollection() {
        tournamentsCollection.willSelectTournament = { [weak self] tournament in
            guard let self = self else { return }
            self.presenter?.tapTournament(tournament)
        }
        tournamentsCollection.didSelectMatch = { [weak self] match in
            guard let self = self else { return }
          
            if let stream = match.stream {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let broadcastVC = storyboard.instantiateViewController(withIdentifier: "Broadcast") as! BroadcastViewController
                broadcastVC.modalPresentationStyle = .overFullScreen
                broadcastVC.match = match
                self.present(broadcastVC, animated: true)
            }
          
        }
        
        tournamentsCollection.willSelectStake = { [weak self] match, stake in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let makeBetVC = storyboard.instantiateViewController(withIdentifier: "MakeBetVIewController") as! MakeBetVIewController
            
            self?.present(makeBetVC, animated: true)
        }

  
    }
    
    func updateTournament(model: CSTournament, scroll: Bool) {
        DispatchQueue.main.async {
            self.tournamentsCollection.updateTournament(model, scroll: scroll)
        }
    }
    
    func bindFiltersCollection() {
        filtersCollection.willSelect = { [weak self] filter in
            guard let self = self else { return }
            
            self.tournamentsCollection.clear()
            self.tournamentsCollection.setLoading()
            self.presenter.changeCurrentFilter(filter)
        }
    }
    
    func setSports(model: [CSSportInfo], id: String?) {
        DispatchQueue.main.async {
            self.gamesCollection.set(model, with: id)
//            if let id = id { self.changeGameColorForIndicatorLine(with: id) }
        }
    }
    
    func setSelectedFilter(_ filter: CSFilter) {
        DispatchQueue.main.async {
            self.filtersCollection.updateSelected(filter)
        }
    }
    
    func setupFilterCollection() {
        let collection = CyberSportFiltersCollection()
        collection.backgroundColor = .black
        collection.isSkeletonable = true
        
        filtersCollection = collection
        view.addSubview(filtersCollection)
        filtersCollection.snp.makeConstraints {
            $0.top.equalTo(gamesCollection.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
    }
    
    
    func setupGamesCollection() {
        let collection = CyberSportGamesCollection()
        collection.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1411764706, blue: 0.2, alpha: 1)
        collection.isSkeletonable = true
        
        gamesCollection = collection
        view.addSubview(gamesCollection)
        gamesCollection.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
//            $0.height.equalTo(83)
            $0.height.equalTo(192)
        }
        
        gamesCollection.layer.cornerRadius = 16
        gamesCollection.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        gamesCollection.allowDelegates()
        
        gamesCollection.willSelect = { [weak self] game in
            guard let self = self else { return }

            self.presenter.changeCurrentSport(id: game.id)
        }
    }
    
    func setSelectedSport(_ id: String, scrollToCenter: Bool) {
        DispatchQueue.main.async {
            self.gamesCollection.select(id, scrollToCenter: scrollToCenter)
            
        }
    }
    
    func setupTournamentsCollection() {
        let collection = CyberSportTournamentsCollection()
        collection.backgroundColor = .clear
        collection.isSkeletonable = true
        
        tournamentsCollection = collection
        view.addSubview(tournamentsCollection)
        tournamentsCollection.snp.makeConstraints {
            $0.top.equalTo(filtersCollection.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setTournaments(model: [CSTournament]) {
        DispatchQueue.main.async {
            
            self.tournamentsCollection.set(model)
            if !self.contentIsLoaded {
                self.stopSkeletonState()
                self.contentIsLoaded = true
            }
        }
    }
    
    func updateTournaments(model: [CSTournament]) {
        DispatchQueue.main.async {
            self.tournamentsCollection.update(model)
        }
    }

    func updateSports(model: [CSSportInfo]) {
        DispatchQueue.main.async {
            self.gamesCollection.update(model)
        }
    }
    
    func stopSkeletonState() {
        view.hideSkeleton()
    }
    
    func setTournamentsPlaceholder(model: String) {
        DispatchQueue.main.async {
            
            if !self.contentIsLoaded {
                self.stopSkeletonState()
                self.contentIsLoaded = true
            }
        }
    }

    @IBAction func didTapSegmentedControll(_ sender: UISegmentedControl) {
    }
    

}
