//
//  TapMissionWorkingView.swift
//  AlarmMission
//
//  Created by choijunios on 3/4/25.
//

import UIKit

import FeatureUIDependencies

import Lottie

protocol TapMissionWorkingViewListener: AnyObject {
    func action(_ action: TapMissionWorkingView.Action)
}

final class TapMissionWorkingView: UIView {
    // Listener
    weak var listener: TapMissionWorkingViewListener?
    
    
    // Sub views
    private let exitButton: ExitButton = .init()
    private let missionProgressView: MissionProgressView = .init(percent: 0.0)

    // Letter
    private let letterViewContainer = UIView()
    private let letterView = LottieAnimationView()
    
    // - Label
    private let labelStackView: UIStackView = .init().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }
    private let titleLabel: UILabel = .init()
    private let shakeCountLabel: UILabel = .init()
    
    // - Background
    private let backgroundView = MissionWorkingBackgroundView()
    
    // Mission start & complete view
    private var startMissionView: StartMissionView?
    private var missionCompleteView: MissionCompleteView?
    
    // Preview mode UI
    private let previewExitButton = UIButton(type: .system)
    
    
    // Gesture
    private let tapLetterGesture = UITapGestureRecognizer()
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
        setupGesture()
    }
    required init?(coder: NSCoder) { nil }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}


// MARK: Public interface
extension TapMissionWorkingView {
    enum Action {
        case letterIsTapped
        case exitButtonClicked
        case missionGuideAnimationCompleted
        case missionSuccessAnimationCompleted
        case previewExitButtonTapped
    }
    
    enum MissionFlow {
        case guide
        case working
        case success
    }
    
    enum Update {
        case missionFlow(MissionFlow)
        case titleText(String)
        case countText(String)
        case missionProgress(Double)
        case playTapAnim
        case previewMode(Bool)
    }
    
    @discardableResult
    func update(_ update: Update) -> Self {
        switch update {
        case .missionFlow(let missionState):
            handleMissionFlow(missionState)
        case .titleText(let text):
            titleLabel.displayText = text.displayText(
                font: .heading2SemiBold,
                color: R.Color.white100
            )
        case .countText(let text):
            shakeCountLabel.displayText = text.displayText(
                font: .displaySemiBold,
                color: R.Color.white100
            )
        case .missionProgress(let progress):
            missionProgressView.update(progress: progress)
        case .playTapAnim:
            startTappingLetterAnim()
        case .previewMode(let isPreview):
            setupPreviewMode(isPreview)
        }
        return self
    }
    
    private func handleMissionFlow(_ flow: MissionFlow) {
        switch flow {
        case .guide:
            let startMissionView = StartMissionView()
                .update(titleText: "누르기 시작!")
            addSubview(startMissionView)
            startMissionView.snp.makeConstraints({ $0.edges.equalToSuperview() })
            self.startMissionView = startMissionView
            
            startMissionView.startShowUpAnimation() { [weak self] in
                guard let self else { return }
                finishGuide()
            }
        case .working:
            missionProgressView.alpha = 1
            labelStackView.alpha = 1
        case .success:
            tapLetterGesture.isEnabled = false
            startMissionCompleteAnim()
            let missionCompleteView = MissionCompleteView()
            addSubview(missionCompleteView)
            missionCompleteView.layer.zPosition = 500
            missionCompleteView.snp.makeConstraints({ $0.edges.equalToSuperview() })
            self.missionCompleteView = missionCompleteView
            
            missionCompleteView.startShowUpAnimation(centeringView: letterView) { [weak self] in
                guard let self else { return }
                listener?.action(.missionSuccessAnimationCompleted)
            }
        }
    }
}


// MARK: Animation
private extension TapMissionWorkingView {
    func finishGuide() {
        startMissionView?.removeFromSuperview()
        startMissionView = nil
        listener?.action(.missionGuideAnimationCompleted)
    }
    
    
    func startTappingLetterAnim() {
        letterView.loopMode = .playOnce
        letterView.play()
    }
    
    
    func startMissionCompleteAnim() {
        let animFilePath = Bundle.resources.path(forResource: "letter_open_motion", ofType: "json")!
        letterView.animation = .filepath(animFilePath)
        letterView.loopMode = .playOnce
        letterView.play()
    }
}


// MARK: Setup
private extension TapMissionWorkingView {
    func setupUI() {
        // backgroundView
        addSubview(backgroundView)
        
        
        // letterView
        let animFilePath = Bundle.resources.path(forResource: "letter_tap_motion", ofType: "json")!
        letterView.animation = .filepath(animFilePath)
        letterView.contentMode = .scaleAspectFit
        letterViewContainer.addSubview(letterView)
        
        
        // letterViewContainer
        addSubview(letterViewContainer)
        
        
        // exitButton
        exitButton.buttonAction = { [weak self] in
            guard let self else { return }
            listener?.action(.exitButtonClicked)
        }
        addSubview(exitButton)
        
        
        // missionProgressView
        missionProgressView.alpha = 0
        addSubview(missionProgressView)
        
        
        // labelStackView
        labelStackView.alpha = 0
        [titleLabel,shakeCountLabel].forEach({labelStackView.addArrangedSubview($0)})
        addSubview(labelStackView)
        
        // previewExitButton
        previewExitButton.do {
            $0.setAttributedTitle("미리보기 종료".displayText(font: .body1SemiBold, color: R.Color.gray900), for: .normal)
            $0.backgroundColor = R.Color.white100
            $0.layer.cornerRadius = 24
            $0.layer.cornerCurve = .continuous
            $0.isHidden = true
            $0.addTarget(self, action: #selector(previewExitButtonTapped), for: .touchUpInside)
        }
        addSubview(previewExitButton)
        
    }
    
    func setupLayout() {
        // backgroundView
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        
        // exitButton
        exitButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(11)
            make.right.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        
        // missionProgressView
        missionProgressView.snp.makeConstraints { make in
            make.top.equalTo(exitButton.snp.bottom).offset(19)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        
        // labelStackView
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(missionProgressView.snp.bottom).offset(48)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        
        
        // letterViewContainer
        letterViewContainer.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        
        // letterView
        letterView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        // previewExitButton
        previewExitButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-27)
            make.width.equalTo(156)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
        }
    }
    
    func setupGesture() {
        // tapLetterGesture
        tapLetterGesture.addTarget(self, action: #selector(onTapLetter(_:)))
        letterView.addGestureRecognizer(tapLetterGesture)
    }
    
    @objc
    func onTapLetter(_ sender: UITapGestureRecognizer) {
        listener?.action(.letterIsTapped)
    }
    
    @objc
    private func previewExitButtonTapped() {
        listener?.action(.previewExitButtonTapped)
    }
    
    private func setupPreviewMode(_ isPreview: Bool) {
        exitButton.isHidden = isPreview
        previewExitButton.isHidden = !isPreview
    }
}
