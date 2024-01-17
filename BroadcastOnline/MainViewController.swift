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
import InAppStorySDK

class MainViewController: UIViewController, MainViewInput, SessionServiceDependency {
    func showLoader() {
        
    }
    
    func hideLoader() {
        
    }
    
    weak var storyView: StoryView!
    private weak var noConnectionVC: NoConnectionViewController?
    var contentIsLoaded: Bool = false
     weak var tournamentsCollection: CyberSportTournamentsCollection!
    public var presenter: MainPresenter!
    private weak var gamesCollection: CyberSportGamesCollection!
    private weak var filtersCollection: CyberSportFiltersCollection!
    private weak var placeholderContainerView: UIView!
    private weak var placeholderView: CyberSportPlaceholderView!
    private weak var topView: UIView!
    
    @IBOutlet var segmentedController: UISegmentedControl!
 
    var loginLabel = UILabel()
    private var reachability: Reachability!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopView()
        setupInAppStory()
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
        
        
  
        loginLabel.textColor = #colorLiteral(red: 0.5843137255, green: 0.7176470588, blue: 1, alpha: 1)
        let loginSportTitle = NSLocalizedString("LoginSportTitle", comment: "LoginSportTitle Main")
//        loginLabel.text = loginSportTitle
        loginLabel.font = R.font.robotoBold(size: 16)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        loginLabel.addGestureRecognizer(gesture)
        loginLabel.isUserInteractionEnabled = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: loginLabel)
        
        setupNoConnection()
    }
    
  
    
    @objc func tap() {
        if session.hasToken {
            session.removeToken()
            loginLabel.text = "Войти"
        }else{
            let vc = storyboard?.instantiateViewController(identifier: "AuthViewController") as! AuthViewController
            navigationController?.pushViewController(vc, animated: true)
        }
     
    }
    
    private func setupTopView() {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        topView = view
        self.view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(236)
        }
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
        
        loginLabel.text = session.hasToken ? "Выйти" : "Войти"
        self.navigationItem.rightBarButtonItem?.title = title
  
   }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let firstColor = #colorLiteral(red: 0.09411764706, green: 0.1137254902, blue: 0.1607843137, alpha: 1)
        let secondColor = #colorLiteral(red: 0.1764705882, green: 0.2117647059, blue: 0.3019607843, alpha: 1)
        topView.applyGradient(isVertical: true, colorArray: [firstColor, secondColor])
    }
    
    
    func setInAppStories(id: String, tags: [String]) {
        if tags.isEmpty {
            topView.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(100)
            }
        }else{
            DispatchQueue.main.async {
                InAppStory.shared.settings = Settings(userID: id, tags: tags)
                
                InAppStory.shared.showOnboardings(from: self, delegate: self) { item in
                    print("intem ", item)
                }
                
    //            self.stopStorySkeletonState()
                self.storyView.create()
                self.storyView.refresh()
            }
        }

    }
    
    
    func setupInAppStory() {
        InAppStory.shared.cellBorderColor = BBTheme.isNight() ? Color.electricYellow : Color.carmineRed
        InAppStory.shared.cellFont = R.font.lato_BBRegular(size: 12)!
        
        let story = StoryView()
        story.backgroundColor = .clear
        story.target = self
        story.storiesDelegate = self
//        story.deleagateFlowLayout = self
        
        storyView = story
        topView.addSubview(storyView)
        storyView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.leading.trailing.equalToSuperview()
            
            $0.height.equalTo(124)
        }
    }
    
    
    func updateInAppStories(_ model: (id: String, tags: [String])?) {
        DispatchQueue.main.async {
            if let model = model {
                InAppStory.shared.settings = Settings(userID: model.id, tags: model.tags)
                
                self.storyView.refresh()
                
            }
        }
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
        collection.backgroundColor = .clear
        collection.isSkeletonable = true
        
        gamesCollection = collection
        view.addSubview(gamesCollection)
        gamesCollection.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()

            $0.height.equalTo(72)
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

extension MainViewController: InAppStoryDelegate {
    func storiesDidUpdated(isContent: Bool, from storyType: StoriesType) {
    }
    
    func storyReaderDidClose(with storyType: InAppStorySDK.StoriesType) {
        presenter?.isNeedToUpdateStories = true
        storyView.refresh()
    }
    
    func storyReader(actionWith target: String, for type: ActionType, from storyType: StoriesType) {
        if type == .deeplink {
//            presenter?.inAppStoryAction(action: type, for: target)
            presenter?.isNeedToUpdateStories = true
        } else {
            InAppStory.shared.closeReader {
//                self.presenter?.inAppStoryAction(action: type, for: target)
            }
        }
    }
}

extension MainViewController: StoryViewDelegateFlowLayout {
    func sizeForItem() -> CGSize {
        return CGSize(width: 96.0, height: 104.0)
    }
    
    func insetForSection() -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 16, bottom: 10.0, right: 16.0)
    }
    
    func minimumLineSpacingForSection() -> CGFloat {
        return 2.0
    }
    
    func minimumInteritemSpacingForSection() -> CGFloat {
        return 2.0
    }
}
