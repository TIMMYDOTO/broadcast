//
//  CSDefaultMatchCell.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 29.03.2022.
//

import UIKit
import SwiftTheme
import Kingfisher

class CSDefaultMatchCell: CSMatchBaseCell {
    
    // MARK: - Properties
    private var firstLogoDownloadTask: DownloadTask?
    private var secondLogoDownloadTask: DownloadTask?
    
    private weak var firstTeamFieldView: UIView!
        private weak var firstTeamLogo: UIImageView!
        private weak var firstTeamNameLabel: UILabel!
        private weak var firstTeamGameScoreLabel: UILabel!
        private weak var firstTeamMatchScoreLabel: UILabel!
    
    private weak var secondTeamFieldView: UIView!
        private weak var secondTeamLogo: UIImageView!
        private weak var secondTeamNameLabel: UILabel!
        private weak var secondTeamGameScoreLabel: UILabel!
        private weak var secondTeamMatchScoreLabel: UILabel!
    
    private weak var isLiveIcon: UIView!
    private weak var matchStatusLabel: UILabel!
    
    private weak var liveVideoIcon: UIImageView!
    private weak var liveInfoIcon: UIImageView!
    
    private weak var infoStackView: UIStackView!
        private weak var statusView: UIView!
    
    // MARK: - Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearImages()
    }
    
    override func configure(_ model: CSMatch, stakesOffset: CGFloat) {
        super.configure(model, stakesOffset: stakesOffset)
//        updateInfo(model)
    }
}

private extension CSDefaultMatchCell {
    // MARK: - Setups
    func setup() {
        setupFirstTeamLogo()
        
//        setupInfoStackView()
        
    }
    
    func setupFirstTeamLogo() {
        let firstLogo = UIImageView()
        firstTeamLogo = firstLogo
        contentView.addSubview(firstTeamLogo)
        firstTeamLogo.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(24)
            make.width.equalTo(24)
            make.top.equalToSuperview().offset(16)
        }
        firstTeamLogo.backgroundColor = .red
    }
    
    func setupInfoStackView() {
        let first = createTeamFieldView()
//        firstTeamFieldView = first.view
        firstTeamLogo = first.logo
        firstTeamNameLabel = first.team
//        firstTeamNameLabel.text = "firstTeamNameLabelfirstTeamNameLabel"
//        firstTeamGameScoreLabel = first.gameScore
//        firstTeamMatchScoreLabel = first.matchScore
        
        let second = createTeamFieldView()
//        secondTeamFieldView = second.view
        secondTeamLogo = second.logo
        secondTeamNameLabel = second.team
//        secondTeamGameScoreLabel = second.gameScore
//        secondTeamMatchScoreLabel = second.matchScore
        
        let status = createStatusStackView()
        let containerStatus = UIView()
        
        statusView = containerStatus
        containerStatus.addSubview(status)
        status.snp.makeConstraints { $0.leading.trailing.centerY.equalToSuperview() }
        
        let info = UIStackView(arrangedSubviews: [containerStatus])
        info.axis = .vertical
        info.spacing = 4
        
        infoStackView = info
        
        infoView.addSubview(info)
        info.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
    
    // MARK: - Others
    func updateInfo(_ model: CSMatch) {
        if model.type == .live {
//            firstTeamGameScoreLabel.isHidden = false
//            firstTeamMatchScoreLabel.isHidden = false
//            secondTeamGameScoreLabel.isHidden = model.teams.count == 1
//            secondTeamMatchScoreLabel.isHidden = model.teams.count == 1
            matchStatusLabel.text = model.matchStatus.isEmpty ? "Лайв" : model.matchStatus
        } else {
//            firstTeamGameScoreLabel.isHidden = true
//            firstTeamMatchScoreLabel.isHidden = true
//            secondTeamGameScoreLabel.isHidden = true
//            secondTeamMatchScoreLabel.isHidden = true
            matchStatusLabel.text = model.startDttm.getLocaleFormattedDate(format: "d MMMM HH:mm")
        }
        
        let home = model.teams.first(where: { $0.home }) ?? CSTeam()
        let away = model.teams.first(where: { !$0.home }) ?? CSTeam()
        firstTeamNameLabel.text = home.name
        firstTeamNameLabel.text = "firstTeamNameLabel.textfirstTeamNameLabel.text"
        secondTeamNameLabel.text = away.name
        secondTeamNameLabel.text = "secondTeamNameLabel.textsecondTeamNameLabel.text"
        configureScores(model)
        configureLogo(home: home, away: away)
        
//        isLiveIcon.isHidden = !(model.type == .live)
//        liveVideoIcon.isHidden = model.stream == nil
//        liveInfoIcon.isHidden = true
        
        infoStackView.layoutIfNeeded()
    }
    
    func configureScores(_ model: CSMatch) {
        //
        let home = model.teams.first(where: { $0.home })?.score ?? 0
        let away = model.teams.first(where: { !$0.home })?.score ?? 0
        
        let firstMatchScore = home
        let secondMatchScore = away
        let firstMatchScoreString = String(firstMatchScore)
        let secondMatchScoreString = String(secondMatchScore)
        
        let gameScoreWidth = max(
            firstMatchScoreString.width(withConstrainedHeight: 16, font: UIFont.systemFont(ofSize: 12)),
            secondMatchScoreString.width(withConstrainedHeight: 16, font: UIFont.systemFont(ofSize: 12))
        )
        let color = CSTypeProvider.getInfoVM(id: model.sportId).color
//        [firstTeamMatchScoreLabel!, secondTeamMatchScoreLabel!].forEach {
//            $0.snp.updateConstraints { $0.width.equalTo(gameScoreWidth + 4) }
//            $0.textColor = color
//        }
//        firstTeamMatchScoreLabel.text = firstMatchScoreString
//        secondTeamMatchScoreLabel.text = secondMatchScoreString
        
        //
        if let gameScores = model.scoreboard?.getGameScore() {
            let firstGameScoreString = String(gameScores.home)
            let secondGameScoreString = String(gameScores.away)
//            [firstTeamGameScoreLabel!, secondTeamGameScoreLabel!].forEach {
//                $0.snp.updateConstraints { $0.width.equalTo(gameScoreWidth + 8) }
//            }
//            firstTeamGameScoreLabel.text = firstGameScoreString
//            secondTeamGameScoreLabel.text = secondGameScoreString
//            firstTeamGameScoreLabel.isHidden = false
//            secondTeamGameScoreLabel.isHidden = false
        } else {
//            firstTeamGameScoreLabel.isHidden = true
//            secondTeamGameScoreLabel.isHidden = true
        }
        //
    }
    
    func configureLogo(home: CSTeam, away: CSTeam) {
        if let url = URL(string: home.image) {
            let resource = ImageResource(downloadURL: url)
            self.firstLogoDownloadTask = KingfisherManager.shared.retrieveImage(with: resource) { [weak self] result in
                guard let self = self, case let .success(response) = result else { return }
                self.firstTeamLogo.image = response.image
            }
        }
        if let url = URL(string: away.image) {
            let resource = ImageResource(downloadURL: url)
            self.secondLogoDownloadTask = KingfisherManager.shared.retrieveImage(with: resource) { [weak self] result in
                guard let self = self, case let .success(response) = result else { return }
                self.secondTeamLogo.image = response.image
            }
        }
    }
    
    func createStatusStackView() -> UIStackView {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 10)
        matchStatusLabel = label
        
        let liveIconContainer = UIView()
        
        let liveIcon = UIView()
        
        liveIcon.layer.cornerRadius = 4
        
        liveIconContainer.addSubview(liveIcon)
        liveIcon.snp.makeConstraints {
            $0.leading.trailing.centerY.equalToSuperview()
            $0.width.height.equalTo(8)
        }
        
        isLiveIcon = liveIconContainer
        
        let infoIcon = UIImageView(image: UIImage(named: "icLiveInfo"))
        infoIcon.contentMode = .scaleAspectFit
        infoIcon.isHidden = true
        liveInfoIcon = infoIcon
        liveInfoIcon.snp.makeConstraints { $0.width.equalTo(16) }
        
        let videoIcon = UIImageView(image: UIImage(named: "icLiveInfo"))
        videoIcon.contentMode = .scaleAspectFit
        videoIcon.isHidden = true
        liveVideoIcon = videoIcon
        liveVideoIcon.snp.makeConstraints { $0.width.equalTo(16) }
        
        let spaceView = UIView()
        
        let stack = UIStackView(arrangedSubviews: [isLiveIcon, matchStatusLabel, spaceView, liveVideoIcon, liveInfoIcon])
        stack.spacing = 8
        
        stack.snp.makeConstraints { $0.height.equalTo(16) }
        
        return stack
    }
    
    func createTeamFieldView() -> (logo: UIImageView, team: UILabel) {
        let logoContainer = UIView()
        logoContainer.backgroundColor = .clear
        logoContainer.snp.makeConstraints {
            $0.width.equalTo(20)
        }
        
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        logo.image = UIImage(named: "ic56CyberTeamPlaceholder")
        logo.theme_tintColor = ThemeColorPicker(colors: "#CCCCCC", "#A1A3AB")
        
        logoContainer.addSubview(logo)
        logo.snp.makeConstraints {
            $0.height.width.equalTo(20)
            $0.center.equalToSuperview()
        }
        
        let team = UILabel()
        team.textAlignment = .left
        team.numberOfLines = 1
        team.textColor = .white
        team.font = R.font.robotoMedium(size: 16)
        
        team.snp.contentHuggingHorizontalPriority = 250
        team.snp.contentCompressionResistanceHorizontalPriority = 749
        team.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        
//        let gameScore = UILabel()
//        gameScore.textAlignment = .right
//        gameScore.numberOfLines = 1
//        gameScore.theme_textColor = ThemeColorPicker(colors: "#FFFFFF", "#737373")
//        gameScore.font = R.font.lato_BBBold(size: 12)
//
//        gameScore.snp.contentHuggingHorizontalPriority = 251
//        gameScore.snp.contentCompressionResistanceHorizontalPriority = 750
//        gameScore.snp.makeConstraints {
//            $0.height.equalTo(24)
//            $0.width.equalTo(1)
//        }
        
//        let matchScore = UILabel()
//        matchScore.textAlignment = .right
//        matchScore.numberOfLines = 1
//        matchScore.font = R.font.lato_BBBold(size: 12)
//
//        matchScore.snp.contentHuggingHorizontalPriority = 251
//        matchScore.snp.contentCompressionResistanceHorizontalPriority = 750
//        matchScore.snp.makeConstraints {
//            $0.height.equalTo(24)
//            $0.width.equalTo(1)
//        }
        
        let stack = UIStackView(arrangedSubviews: [logoContainer, team])
        stack.spacing = 8
        
        stack.snp.makeConstraints { $0.height.equalTo(24) }
        
        return (logo, team)
    }
    
    func clearImages() {
        firstLogoDownloadTask?.cancel()
        firstLogoDownloadTask = nil
        secondLogoDownloadTask?.cancel()
        secondLogoDownloadTask = nil
        firstTeamLogo.image = R.image.ic56CyberTeamPlaceholder()
        secondTeamLogo.image = R.image.ic56CyberTeamPlaceholder()
    }
}
