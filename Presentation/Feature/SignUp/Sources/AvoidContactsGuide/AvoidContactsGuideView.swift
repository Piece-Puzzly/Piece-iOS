//
//  AvoidContactsGuideView.swift
//  SignUp
//
//  Created by eunseou on 1/17/25.
//

import SwiftUI
import DesignSystem
import UseCases
import Router
import UseCases

struct AvoidContactsGuideView: View {
  private enum Constant {
    static let accepetButtonText = "아는사람 차단하기"
    static let denyButtonText = "다음에 할래요"
    static let toastText = "지인 차단 완료"
  }
  
  @State var viewModel: AvoidContactsGuideViewModel
  @State private var path = NavigationPath()
  @Environment(Router.self) private var router: Router
  
  init(
    requestContactsPermissionUseCase: RequestContactsPermissionUseCase,
    fetchContactsUseCase: FetchContactsUseCase,
    blockContactsUseCase: BlockContactsUseCase
  ) {
    _viewModel = .init(
      wrappedValue: .init(
        requestContactsPermissionUseCase: requestContactsPermissionUseCase,
        fetchContactsUseCase: fetchContactsUseCase,
        blockContactsUseCase: blockContactsUseCase
      )
    )
  }
  
  var body: some View {
    ZStack {
      VStack {
        NavigationBar(
          title: "",
          leftButtonTap: { router.pop() }
        )
        VStack {
          title
          
          DesignSystemAsset.Images.imgBlock.swiftUIImage
            .resizable()
            .frame(width: 300, height: 300)
          
          Spacer()
          
          denyButton
          
          acceptButton
        }
        .padding([.horizontal, .top], 20)
        .padding(.bottom, 10)
        .alert("연락처 권한 요청", isPresented: $viewModel.isPresentedAlert) {
          Button("설정으로 이동") {
            viewModel.handleAction(.showShettingAlert)
          }
          Button("취소", role: .cancel) {
            viewModel.handleAction(.cancelAlert)
          }
        } message: {
          Text("연락처 권한이 필요합니다. 설정에서 권한을 허용해주세요.")
        }
      }
      
      toast
        .opacity(viewModel.showToast ? 1 : 0)
        .animation(.easeInOut(duration: 0.3), value: viewModel.showToast)
    }
    .toolbar(.hidden)
    .onChange(of: viewModel.moveToCompleteSignUp) { _, newValue in
      router.push(to: .completeSignUp)
    }
  }
  
  private var title: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("아는 사람")
        .foregroundStyle(Color.primaryDefault) +
      Text("에게는\n프로필이 노출되지 않아요")
      
      Text("연락처에 등록된 번호로 가입한 사용자는\n매칭 대상에서 제외되어, 개인정보가 보호됩니다.")
        .pretendard(.body_S_M)
        .foregroundStyle(Color.grayscaleDark3)
    }
    .pretendard(.heading_L_SB)
    .foregroundStyle(Color.grayscaleBlack)
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.bottom, 60)
  }
  
  private var denyButton: some View {
    PCTextButton(content: Constant.denyButtonText)
      .onTapGesture {
        router.push(to: .completeSignUp)
      }
      .padding(.bottom, 20)
  }
  
  private var acceptButton: some View {
    RoundedButton(
      type: .solid,
      buttonText: Constant.acceptButtonText,
      width: .maxWidth,
      action: {
        viewModel.handleAction(.tapAcceptButton)
      }
    )
  }
  
  private var toast: some View {
    VStack(spacing: 16) {
      DesignSystemAsset.Icons.check80.swiftUIImage
        .renderingMode(.template)
      
      Text(Constant.toastText)
        .pretendard(.heading_M_SB)
    }
    .foregroundStyle(Color.grayscaleWhite)
    .background(
      Rectangle()
        .fill(Color.grayscaleDark2)
        .cornerRadius(20)
        .frame(width: 200, height: 200)
    )
  }
}

//#Preview {
//  AvoidContactsGuideView(
//    viewModel: AvoidContactsGuideViewModel(
//      contactsPermissionUseCase: MockContactsPermissionUseCase()
//    )
//  )
//}
//
//private class MockContactsPermissionUseCase: ContactsPermissionUseCase {
//  func execute() async throws -> Bool { return true }
//}
//
