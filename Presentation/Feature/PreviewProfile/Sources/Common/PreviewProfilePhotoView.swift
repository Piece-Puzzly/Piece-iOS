//
//  PreviewProfilePhotoView.swift
//  PreviewProfile
//
//  Created by summercat on 1/30/25.
//

import DesignSystem
import SwiftUI
import PCAmplitude

struct PreviewProfilePhotoView: View {
  private let uri: String
  @Environment(\.dismiss) private var dismiss
  
  init(uri: String) {
    self.uri = uri
  }
  
  var body: some View {
    content
      .background(
        Dimmer()
          .ignoresSafeArea()
      )
      .trackScreen(trackable: DefaultProgress.previewSelfPhoto)
  }
  
  private var content: some View {
    VStack(alignment: .center) {
      NavigationBar(
        title: "",
        titleColor: .grayscaleWhite,
        rightButton: Button { dismiss()
        } label: { DesignSystemAsset.Icons.close32.swiftUIImage }
      )
      
      Spacer()
      
      AsyncImage(url: URL(string: uri)) { image in
        image.image?
          .resizable()
          .scaledToFill()
      }
      .frame(width: 180, height: 180)
      .clipShape(Circle())
      
      Spacer()
    }
  }
}

#Preview {
  let uri = "https://www.thesprucepets.com/thmb/AyzHgPQM_X8OKhXEd8XTVIa-UT0=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/GettyImages-145577979-d97e955b5d8043fd96747447451f78b7.jpg"
  PreviewProfilePhotoView(uri: uri)
}
