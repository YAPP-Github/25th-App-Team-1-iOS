//
//  CreateAlarmSoundOptionView.swift
//  FeatureAlarm
//
//  Created by ever on 1/26/25.
//

import UIKit
import SnapKit
import Then
import FeatureResources
import FeatureDesignSystem
import FeatureCommonDependencies

protocol CreateAlarmSoundOptionViewListener: AnyObject {
    func action(_ action: CreateAlarmSoundOptionView.Action)
}

final class CreateAlarmSoundOptionView: UIView {
    enum Action {
        case isVibrateOnChanged(Bool)
        case isSoundOnChanged(Bool)
        case volumeChanged(Float)
        case soundSelected(String)
        case doneButtonTapped
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal
    weak var listener: CreateAlarmSoundOptionViewListener?
    
    func updateOption(option: SoundOption) {
        isSoundOn = option.isSoundOn
        
        vibrateOnOffSwitch.isOn = option.isVibrationOn
        soundOnOffSwitch.isOn = option.isSoundOn
        soundSlider.value = option.volume
        
        soundSlider.tintColor = option.isSoundOn ? R.Color.main100 : R.Color.gray500
            
        self.selectedSound = option.selectedSound
        soundListTableView.reloadData()
    }
    
    private var isSoundOn: Bool = true
    
    private var selectedSound: String? {
        didSet {
            soundListTableView.reloadData()
        }
    }
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let vibrateLabel = UILabel()
    private let vibrateOnOffSwitch = UISwitch()
    private let divider = UIView()
    private let soundLabel = UILabel()
    private let soundOnOffSwitch = UISwitch()
    private let soundImageView = UIImageView()
    private let soundSlider = UISlider()
    
    private let soundListTableView = UITableView()
    
    private let doneButton = DSDefaultCTAButton(initialState: .active, style: .init(type: .secondary))
    
    @objc
    private func onOffSwitchChanged(toggle: UISwitch) {
        toggle.thumbTintColor = toggle.isOn ? R.Color.gray800 : R.Color.gray300
        switch toggle {
            case vibrateOnOffSwitch:
            listener?.action(.isVibrateOnChanged(toggle.isOn))
        case soundOnOffSwitch:
            listener?.action(.isSoundOnChanged(toggle.isOn))
        default:
            break
        }
    }
    
    @objc
    private func volumeChanged(slider: UISlider) {
        if slider.value < 0.1 {
            slider.value = 0.1
        }
        listener?.action(.volumeChanged(slider.value))
    }
}

private extension CreateAlarmSoundOptionView {
    func setupUI() {
        backgroundColor = R.Color.gray900.withAlphaComponent(0.8)
        containerView.do {
            $0.backgroundColor = R.Color.gray800
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.layer.cornerRadius = 28
            $0.layer.masksToBounds = true
        }
        
        titleLabel.do {
            $0.displayText = "사운드".displayText(font: .heading2SemiBold, color: R.Color.white100)
        }
        
        vibrateLabel.do {
            $0.displayText = "진동".displayText(font: .headline2Medium, color: R.Color.gray50)
        }
        
        vibrateOnOffSwitch.do {
            $0.onTintColor = R.Color.main100
            $0.tintColor = R.Color.gray600
            $0.thumbTintColor = R.Color.gray800
            $0.addTarget(self, action: #selector(onOffSwitchChanged), for: .valueChanged)
            $0.isOn = true
        }
        
        divider.do {
            $0.backgroundColor = R.Color.gray700
        }
        
        soundLabel.do {
            $0.displayText = "알림음".displayText(font: .headline2Medium, color: R.Color.gray50)
        }
        
        soundOnOffSwitch.do {
            $0.onTintColor = R.Color.main100
            $0.tintColor = R.Color.gray600
            $0.thumbTintColor = R.Color.gray800
            $0.addTarget(self, action: #selector(onOffSwitchChanged), for: .valueChanged)
            $0.isOn = true
        }
        
        soundImageView.do {
            $0.image = FeatureResourcesAsset.svgIcoSound.image
            $0.contentMode = .scaleAspectFit
        }
        
        soundSlider.do {
            $0.thumbTintColor = R.Color.white100
            $0.tintColor = R.Color.main100
            $0.addTarget(self, action: #selector(volumeChanged), for: .valueChanged)
        }
        
        soundListTableView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.separatorStyle = .none
            $0.backgroundColor = .clear
            $0.register(SoundOptionItemCell.self, forCellReuseIdentifier: "SoundOptionItemCell")
        }
        
        doneButton.do {
            $0.update(title: "완료")
            $0.buttonAction = { [weak self] in
                self?.listener?.action(.doneButtonTapped)
            }
        }
        addSubview(containerView)
        [
            titleLabel,
            soundLabel, soundOnOffSwitch,
            divider,
            vibrateLabel, vibrateOnOffSwitch,
            soundImageView, soundSlider,
            soundListTableView,
            doneButton
        ].forEach {
            containerView.addSubview($0)
        }
    }
    
    func layout() {
        containerView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(52)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(26)
            $0.leading.equalTo(24)
        }
        
        vibrateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(29)
            $0.leading.equalTo(24)
        }
        
        vibrateOnOffSwitch.snp.makeConstraints {
            $0.centerY.equalTo(vibrateLabel)
            $0.trailing.equalTo(-24)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(vibrateLabel.snp.bottom).offset(21)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(1)
        }
        
        
        soundLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(21)
            $0.leading.equalTo(24)
        }
        
        soundOnOffSwitch.snp.makeConstraints {
            $0.centerY.equalTo(soundLabel)
            $0.trailing.equalTo(-24)
        }
        
        soundImageView.snp.makeConstraints {
            $0.top.equalTo(soundLabel.snp.bottom).offset(20)
            $0.leading.equalTo(24)
            $0.size.equalTo(28)
        }
        
        soundSlider.snp.makeConstraints {
            $0.leading.equalTo(soundImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(-24)
            $0.centerY.equalTo(soundImageView)
        }
        
        soundListTableView.snp.makeConstraints {
            $0.top.equalTo(soundSlider.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
        }
        
        doneButton.snp.makeConstraints {
            $0.top.equalTo(soundListTableView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}

extension CreateAlarmSoundOptionView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return R.AlarmSound.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SoundOptionItemCell") as? SoundOptionItemCell else { return .init() }
        let currentSound = R.AlarmSound.allCases[indexPath.row]
        cell.configure(title: currentSound.title, isSelected: selectedSound == currentSound.title)
        cell.setButtonState(isSoundOn)
        return cell
    }
}

extension CreateAlarmSoundOptionView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSound = R.AlarmSound.allCases[indexPath.row].title
        self.selectedSound = selectedSound
        listener?.action(.soundSelected(selectedSound))
    }
}
