//
//  ProfileFormService.swift
//  UkrZoloto
//
//  Created by Mykola on 07.09.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import PKHUD


struct ProfileFormDTO {
  let name: String?
  let surname: String?
  let email: String?
  let birthday: Date?
  let gender: Gender?
}

class ProfileFormService {
  
  static let shared = ProfileFormService()
  
  private var presentedViewController: UIViewController?
  private var policyWebViewController: UIViewController?
  
  @discardableResult func displayProfileDataIfNeeded(context: UIViewController) -> Bool {
    
    guard ProfileService.shared.shouldShowForm else { return false }
    
    presentFormViewController(context: context)
    trackUserOpenedForm()
    
    ProfileService.shared.shouldShowForm.toggle()
    
    return true
  }
}

//MARK: - FormViewController output
extension ProfileFormService: ProfileFormViewControllerOutput {
  
  func profileFormTappedSkip(_ viewController: UIViewController) {
    
    viewController.dismiss(animated: true, completion: nil)
    presentedViewController = nil
    
    trackUserSkippedForm()
  }
  
  func profileFormTappedPolicy(_ viewController: UIViewController) {
    
    presentPolicyViewController()
  }
  
  func profileFormTappedSave(_ viewConroller: ProfileFormViewController, formDTO: ProfileFormDTO) {
    
    HUD.showProgress()
    
    ProfileService.shared.updateUser(name: formDTO.name,
                                     surname: formDTO.surname,
                                     email: formDTO.email,
                                     birthday: formDTO.birthday,
                                     gender: formDTO.gender) { [weak self] result in
      
      DispatchQueue.main.async {
        HUD.hide()
        guard let self = self else { return }

        switch result {
        case .success:
          self.presentSuccessViewController()
        case .failure(let error):
          viewConroller.handleError(error)
        }
      }
    }
  }
}

//MARK: - Success ViewController output
extension ProfileFormService: ProfileFormSavedViewControllerDelegate {
  
  func profileFormSavedViewControllerTappedClose() {
    
    presentedViewController?.dismiss(animated: true, completion: nil)
    presentedViewController = nil
  }
  
  func profileFormSavedViewControllerTappedProceed() {
    presentedViewController?.dismiss(animated: true, completion: nil)
    presentedViewController = nil
  }
}

//MARK: - Internal Routes
fileprivate extension ProfileFormService {
  
  func presentFormViewController(context: UIViewController) {
    
    let viewController = ProfileFormViewController.createInstance()
    viewController.output = self
    
    context.present(viewController, animated: true, completion: nil)
    
    presentedViewController = viewController
  }
  
  func presentSuccessViewController() {
    
    guard let context = presentedViewController else { return }
    
    let vc = ProfileFormSavedViewController.createInstance()
    vc.output = self
    
    let initialRect = CGRect(origin: CGPoint(x: 0.0, y: UIScreen.main.bounds.height),
                             size: context.view.frame.size)
    vc.view.frame = initialRect
    
    context.addChild(vc)
    context.view.addSubview(vc.view)
    
    let destinationRect = CGRect(origin: .zero, size: context.view.frame.size)
    
    UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseInOut]) {
      vc.view.frame = destinationRect
    }
  }
}

//MARK: - User Agreement
extension ProfileFormService: WebViewControllerOutput {
  func back(from: WebViewController) {
    
    from.dismiss(animated: true, completion: nil)
  }
  
  func successRedirect(from: WebViewController) { }
  
  
  func presentPolicyViewController() {
    guard let webVC = ViewControllersFactory.webViewVC(
            ofType: .agreement,
            keyLocalizator: KeyLocalizator(key: "Пользовательское соглашение")) else { return }
    webVC.output = self
    
    presentedViewController?.present(webVC, animated: true, completion: nil)
  }
}

//MARK: - Interaction Tracking

fileprivate extension ProfileFormService {
  
  func trackUserSavedForm() {
    EventService.shared.trackProfileFormSaved()
  }
  
  func trackUserOpenedForm() {
    EventService.shared.trackProfileFormOpened()
  }
  
  func trackUserSkippedForm() {
    EventService.shared.trackProfileFormClosed()
  }
}
