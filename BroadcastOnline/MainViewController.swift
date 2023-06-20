//
//  MainViewController.swift
//  BroadcastOnline
//
//  Created by Artyom on 08.09.2022.
//

import UIKit
import SkeletonView
import SnapKit
import Reachability


class MainViewController: UIViewController, MainViewInput {
    func showLoader() {
        
    }
    
    func hideLoader() {
        
    }
    private weak var noConnectionVC: NoConnectionViewController?
    var contentIsLoaded: Bool = false
     weak var tournamentsCollection: CyberSportTournamentsCollection!
    public var presenter: MainPresenter!
    private weak var gamesCollection: CyberSportGamesCollection!
    private weak var filtersCollection: CyberSportFiltersCollection!
    private weak var placeholderContainerView: UIView!
    @IBOutlet var segmentedController: UISegmentedControl!
    private weak var placeholderView: CyberSportPlaceholderView!
    
    private var reachability: Reachability!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        releaseScenario()
        presenter = MainPresenter(view: self)
        setupGamesCollection()
     
        setupFilterCollection()
        
        setupTournamentsCollection()
        tournamentsCollection.setLoading()
        gamesCollection.setLoading()
        filtersCollection.setLoading()
     
        
        bindFiltersCollection()
   
        
        bindTournamentCollection()
        setupPlaceholderView()
        let label = UILabel()
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8686360744)
        let cyberSportTitle = NSLocalizedString("CyberSportTitle", comment: "CyberSportTitle Main")
        label.text = cyberSportTitle
        label.font = R.font.robotoBold(size: 24)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        setupNoConnection()

        
    }
    
    private var windowInterfaceOrientation: UIInterfaceOrientation? {
        let windowInterfaceOrientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        return windowInterfaceOrientation
       
       
    }
    
    
    func setSelectedStakes(model: [String : Set<String>], reload: Bool) {
        DispatchQueue.main.async {
            self.tournamentsCollection.setSelectedStakes(model, reload: reload)
        }
    }
    
    private func setupNoConnection() {
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(reachabilityChanged(note:)),
                name: NSNotification.Name.reachabilityChanged,
                object: nil
            )
        
        reachability = try! Reachability()
        
        do
        {
            try reachability.startNotifier()
        }
        catch
        {
            print( "ERROR: Could not start reachability notifier." )
        }
    }
    
    
    @objc func reachabilityChanged(note: Notification) {
        guard let reachability = note.object as? Reachability else { return }
        switch reachability.connection {
        case .cellular, .wifi:
            self.noConnectionVC?.dismiss(animated: false, completion: nil)
            self.noConnectionVC = nil
      
        case .none, .unavailable:
            if self.noConnectionVC != nil { return }
            let vc = NoConnectionViewController()
            vc.modalPresentationStyle = .fullScreen
            
            self.present(vc, animated: false, completion: nil)
            self.noConnectionVC = vc
        }
    }
    
    func setupPlaceholderView() {
        let container = UIView()
        container.isHidden = true
        
        placeholderContainerView = container
        view.addSubview(placeholderContainerView)
        placeholderContainerView.snp.makeConstraints {
            $0.edges.equalTo(tournamentsCollection.snp.edges)
        }
        
        let placeholder = CyberSportPlaceholderView()
        
        placeholderView = placeholder
        placeholderContainerView.addSubview(placeholderView)
        placeholderView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-40)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

//        tournamentsCollection.collectionViewLayout.invalidateLayout()
//        tournamentsCollection.layoutIfNeeded()
    }
    

    func bindTournamentCollection() {
        tournamentsCollection.willSelectTournament = { [weak self] tournament in
            guard let self = self else { return }
            self.presenter?.tapTournament(tournament)
        }
        tournamentsCollection.didSelectMatch = { [weak self] match in
            guard let self = self else { return }
          
            if let _ = match.stream {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let broadcastVC = storyboard.instantiateViewController(withIdentifier: "Broadcast") as! BroadcastViewController
                broadcastVC.modalPresentationStyle = .overFullScreen
                broadcastVC.match = match
                self.present(broadcastVC, animated: true)
            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let makeBetVC = storyboard.instantiateViewController(withIdentifier: "MakeBetVIewController") as! MakeBetVIewController
                makeBetVC.modalPresentationStyle = .overCurrentContext
                self.present(makeBetVC, animated: true)
            }
          
        }
        
        tournamentsCollection.willSelectStake = { [weak self] match, stake in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let makeBetVC = storyboard.instantiateViewController(withIdentifier: "MakeBetVIewController") as! MakeBetVIewController
            makeBetVC.modalPresentationStyle = .overCurrentContext
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
        
        collection.isSkeletonable = true
        
        filtersCollection = collection
        view.addSubview(filtersCollection)
        filtersCollection.snp.makeConstraints {
            $0.top.equalTo(gamesCollection.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
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
            $0.top.equalToSuperview().offset(0)
            $0.leading.trailing.equalToSuperview()
//            $0.height.equalTo(83)
//            $0.height.equalTo(130)
            $0.height.equalTo(192)
        }
        
        gamesCollection.layer.cornerRadius = 16
        gamesCollection.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        gamesCollection.allowDelegates()
        
        gamesCollection.willSelect = { [weak self] game in
            guard let self = self else { return }
            self.tournamentsCollection.clear()
            self.tournamentsCollection.setLoading()
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
//            $0.leading.ч>.bottom.equalToSuperview()
            $0.left.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.bottom.equalToSuperview()
        }
    }
    

    func hideGameFilterSkeleton() {
        gamesCollection.hideSkeleton()
    }
    
    func hideFilterSkeleton() {
        
        self.filtersCollection.hideSkeleton()
    }
    
    func setTournaments(model: [CSTournament]) {
        DispatchQueue.main.async {
            self.placeholderState(active: false)
//
    
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
            self.placeholderState(active: true)
            if !self.contentIsLoaded {
                self.stopSkeletonState()
                self.contentIsLoaded = true
            }
        }
    }
    
    func placeholderState(active: Bool) {
        if active {
            placeholderContainerView.isHidden = false
            tournamentsCollection.isHidden = true
            placeholderView.play()
        } else {
            placeholderContainerView.isHidden = true
            tournamentsCollection.isHidden = false
            placeholderView.pause()
        }
    }

    func releaseScenario() {
        let releaseEndpoints: (first: AppConfigEndpoint, second: AppConfigEndpoint) = (.google, .yandex)
        requestAppConfig(endpoints: (.yandex, .google)) { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case let .success(result):
                AppDataStore.shared.appConfig.configure(result, with: nil)
                self.presenter.viewDidLoad()

            case .failure:
                print("Неизвестная техническая ошибка")
                
            }
        }
    }
    
    func requestAppConfig(
        endpoints: (first: AppConfigEndpoint, second: AppConfigEndpoint),
        completion: @escaping (_ result: AppConfigRequestResult) -> Void
    ) {
        getAppConfig(endpoint: endpoints.first) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success:
                completion(response)
            case .failure:
                self.getAppConfig(endpoint: endpoints.second, completion: completion)
            }
        }
    }
    
    func getAppConfig(endpoint: AppConfigEndpoint, completion: @escaping (_ result: AppConfigRequestResult) -> Void) {
        CheckUpdate.shared.getAppConfig(endpoint: endpoint) { response, error in
            if let result = response {
                completion(.success(result))
            } else {
                completion(.failure)
            }
        }
    }
    
    enum AppConfigRequestResult {
        case success(Bb_IosConfig)
        case failure
    }


}
