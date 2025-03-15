//
//  CharmView.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import UIKit
import FeatureUIDependencies
import FeatureThirdPartyDependencies
import FeatureCommonDependencies

protocol CharmViewListener: AnyObject {
    func action(_ action: CharmView.Action)
}

final class CharmView: UIView {
    enum Action {
        case done
        case charmSelected(Int)
    }
    
    enum State {
        case user(UserInfo)
        case charm(FortuneSaveInfo)
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var listener: CharmViewListener?
    
    func update(_ state: State) {
        switch state {
        case let .user(userInfo):
            titleLabel.displayText = """
            \(userInfo.name),
            부적을 가지고 있으면
            행운이 찾아올거야
            """.displayText(font: .ownglyphPHD_H1, color: R.Color.white100)
        case let .charm(fortuneInfo):
            if let index = fortuneInfo.charmIndex {
                self.selectedImage = charmImages[index]
            } else {
                let (image, index) = getRandomCharmImage()
                self.selectedImage = image
                listener?.action(.charmSelected(index))
            }
        }
    }
    
    private let decoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let charmImageView = UIImageView()
    private let shadowImageView = UIImageView()
    private let buttonStackView = UIStackView()
    private let doneButton = DSDefaultCTAButton(style: .init(type: .secondary))
    private let saveButton = DSDefaultCTAButton()
    
    private let charmImages: [UIImage] = [
        FeatureResourcesAsset.imgCharm1.image,
        FeatureResourcesAsset.imgCharm2.image,
        FeatureResourcesAsset.imgCharm3.image,
        FeatureResourcesAsset.imgCharm4.image,
        FeatureResourcesAsset.imgCharm5.image
    ]
    
    private var selectedImage: UIImage? {
        didSet {
            self.charmImageView.image = selectedImage
        }
    }
    
    private func getRandomCharmImage() -> (image: UIImage, index: Int) {
        let randomIndex = Int.random(in: 0..<charmImages.count)
        let image = charmImages[randomIndex]
        return (image, randomIndex)
    }
    
    private func saveImage() {
        guard let selectedImage else { return }
        saveImageToAlbum(image: selectedImage)
    }
    
    private func saveImageToAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSavedToAlbum), nil)
    }

    @objc func imageSavedToAlbum(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // 저장 실패
            print("이미지 저장 실패: \(error.localizedDescription)")
        } else {
            // 저장 성공
            let snackBar = DSSnackBar(config: .init(status: .success, titleText: "앨범에 저장되었습니다."))
            snackBar.layer.zPosition = 1000
            addSubview(snackBar)
            snackBar.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.bottom.equalTo(safeAreaLayoutGuide).inset(78)
            }
            snackBar.play()
        }
    }
}

private extension CharmView {
    func setupUI() {
        backgroundColor = .init(red: 72/255, green: 145/255, blue: 240/255, alpha: 1)
        decoImageView.do {
            $0.image = FeatureResourcesAsset.imgDecoFortune.image
            $0.contentMode = .scaleAspectFill
        }
        titleLabel.do {
            $0.numberOfLines = 0
        }
        
        charmImageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        shadowImageView.do {
            $0.image = FeatureResourcesAsset.imgCharmShadow.image
            $0.contentMode = .scaleAspectFill
        }
        
        saveButton.do {
            $0.update(title: "앨범에 저장")
            $0.buttonAction = { [weak self] in
                self?.saveImage()
            }
            
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
            $0.setContentHuggingPriority(.required, for: .vertical)
        }
        
        doneButton.do {
            $0.update(title: "완료")
            $0.buttonAction = { [weak self] in
                self?.listener?.action(.done)
            }
            
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
            $0.setContentHuggingPriority(.required, for: .vertical)
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 12
        }
        
        [titleLabel, shadowImageView].forEach {
            $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
            $0.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        }
        
        charmImageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        charmImageView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        [doneButton, saveButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        [decoImageView, titleLabel, charmImageView, shadowImageView, buttonStackView].forEach {
            addSubview($0)
        }
        
    }
    func layout() {
        decoImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(30)
        }
        charmImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(37)
            $0.centerX.equalToSuperview()
        }
        
        shadowImageView.snp.makeConstraints {
            $0.top.equalTo(charmImageView.snp.bottom).offset(29)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(240)
            $0.height.equalTo(22)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(shadowImageView.snp.bottom).offset(41)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-12)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}

