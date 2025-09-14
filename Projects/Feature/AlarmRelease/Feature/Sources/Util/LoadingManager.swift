//
//  LoadingManager.swift
//  AlarmRelease
//
//  Created by choijunios on 9/14/25.
//

import UIKit

final class LoadingManager {
    static let shared = LoadingManager()
    
    private var loadingView: FortuneLoadingView?
    
    private init() {}
    
    func show() {
        // 이미 로딩이 표시되고 있다면 무시
        guard loadingView == nil else { return }
        
        // 키윈도우 찾기
        guard let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return }
        
        // 로딩뷰 생성 및 키윈도우에 직접 추가
        let loading = FortuneLoadingView()
        keyWindow.addSubview(loading)
        loading.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 참조 저장
        loadingView = loading
        
        // 애니메이션 시작
        loading.play()
    }
    
    func hide() {
        guard let loading = loadingView else { return }
        
        // 애니메이션 정지
        loading.stop()
        
        // 뷰 제거
        loading.removeFromSuperview()
        
        // 참조 제거
        loadingView = nil
    }
}
