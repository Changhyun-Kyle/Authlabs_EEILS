//
//  StatusViewController.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/25/24.
//

import ARKit
import Foundation

final class StatusViewController: UIViewController {
  enum MessageType {
    case trackingStateEscalation
    case contentPlacement
    
    static var all: [MessageType] = [
      .trackingStateEscalation,
      .contentPlacement
    ]
  }
  
  private var messagePanel: UIVisualEffectView = .init()
  private var messageLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .footnote)
    return label
  }()
  private lazy var restartExperienceButton: UIButton = {
    let button = UIButton()
    let action = UIAction { _ in
      self.restartExperienceHandler()
    }
    button.addAction(action, for: .touchUpInside)
    return button
  }()
  var restartExperienceHandler: () -> Void = {}
  private let displayDuration: TimeInterval = 6
  private var messageHideTimer: Timer?
  private var timers: [MessageType: Timer] = [:]
  
  override func loadView() {
    super.loadView()
    setupConstraints()
  }
  
  func showMessage(_ text: String, autoHide: Bool = true) {
    messageHideTimer?.invalidate()
    messageLabel.text = text
    setMessageHidden(false, animated: true)
    
    if autoHide {
      messageHideTimer = Timer.scheduledTimer(
        withTimeInterval: displayDuration,
        repeats: false,
        block: { [weak self] _ in
          self?.setMessageHidden(true, animated: true)
        }
      )
    }
  }
  
  func scheduleMessage(_ text: String, inSeconds seconds: TimeInterval, messageType: MessageType) {
    cancelScheduledMessage(for: messageType)
    
    let timer = Timer.scheduledTimer(
      withTimeInterval: seconds,
      repeats: false,
      block: { [weak self] timer in
        self?.showMessage(text)
        timer.invalidate()
      }
    )
    
    timers[messageType] = timer
  }
  
  func cancelScheduledMessage(for messageType: MessageType) {
    timers[messageType]?.invalidate()
    timers[messageType] = nil
  }
  
  func cancelAllScheduledMessages() {
    for messageType in MessageType.all {
      cancelScheduledMessage(for: messageType)
    }
  }
  
  func showTrackingQualityInfo(for trackingState: ARCamera.TrackingState, autoHide: Bool) {
    showMessage(trackingState.presentationString, autoHide: autoHide)
  }
  
  func escalateFeedback(for trackingState: ARCamera.TrackingState, inSeconds seconds: TimeInterval) {
    cancelScheduledMessage(for: .trackingStateEscalation)
    
    let timer = Timer.scheduledTimer(
      withTimeInterval: seconds,
      repeats: false,
      block: { [weak self] _ in
        self?.cancelScheduledMessage(for: .trackingStateEscalation)
        
        var message = trackingState.presentationString
        if let recommendation = trackingState.recommendation {
          message.append(": \(recommendation)")
        }
        
        self?.showMessage(message, autoHide: false)
      }
    )
    
    timers[.trackingStateEscalation] = timer
  }
}

private extension StatusViewController {
  func setupConstraints() {
    view.addSubview(messagePanel)
    view.addSubview(messageLabel)
    view.addSubview(restartExperienceButton)
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    messagePanel.translatesAutoresizingMaskIntoConstraints = false
    restartExperienceButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate(
      [
        messagePanel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        messagePanel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        messagePanel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        messagePanel.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
        
        messageLabel.leadingAnchor.constraint(equalTo: messagePanel.leadingAnchor, constant: 16),
        messageLabel.trailingAnchor.constraint(equalTo: messagePanel.trailingAnchor, constant: -16),
        messageLabel.topAnchor.constraint(equalTo: messagePanel.topAnchor, constant: 8),
        messageLabel.bottomAnchor.constraint(equalTo: messagePanel.bottomAnchor, constant: -8),
        
        restartExperienceButton.leadingAnchor.constraint(greaterThanOrEqualTo: messagePanel.trailingAnchor, constant: 8),
        restartExperienceButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      ]
    )
  }
  
  func setMessageHidden(_ hide: Bool, animated: Bool) {
    messagePanel.isHidden = false
    
    guard
      animated
    else {
      messagePanel.alpha = hide ? 0 : 1
      return
    }
    
    UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState], animations: {
      self.messagePanel.alpha = hide ? 0 : 1
    })
  }
}

extension ARCamera.TrackingState {
  var presentationString: String {
    switch self {
    case .notAvailable:
      return "트래킹 비활성화"
    case .normal:
      return "트래킹 상태 - 양호"
    case .limited(.excessiveMotion):
      return "트래킹 제한\nExcessive motion"
    case .limited(.insufficientFeatures):
      return "트래킹 제한\nLow detail"
    case .limited(.initializing):
      return "ARSession 초기화 중"
    case .limited(.relocalizing):
      return "Recovering from session interruption"
    default:
      return "트래킹 비활성화"
    }
  }
  
  var recommendation: String? {
    switch self {
    case .limited(.excessiveMotion):
      return "Try slowing down your movement, or reset the session."
    case .limited(.insufficientFeatures):
      return "Try pointing at a flat surface, or reset the session."
    case .limited(.relocalizing):
      return "Try returning to where you were when the interruption began, or reset the session."
    default:
      return nil
    }
  }
}
