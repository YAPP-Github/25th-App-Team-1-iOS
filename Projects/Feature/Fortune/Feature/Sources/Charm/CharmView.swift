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
    }
    
    enum State {
        case user(UserInfo)
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
        }
    }
    
    private let decoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let charmImageView = UIImageView()
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
    
    private lazy var selectedImage: UIImage? = {
        return charmImages.randomElement()
    }()
    
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
            listener?.action(.done)
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
            $0.image = selectedImage
            $0.contentMode = .scaleAspectFit
        }
        
        saveButton.do {
            $0.update(title: "앨범에 저장")
            $0.buttonAction = { [weak self] in
                self?.saveImage()
            }
        }
        
        doneButton.do {
            $0.update(title: "완료")
            $0.buttonAction = { [weak self] in
                self?.listener?.action(.done)
            }
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 12
        }
        
        [doneButton, saveButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        [decoImageView, titleLabel, charmImageView, buttonStackView].forEach {
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
        buttonStackView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-12)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}

