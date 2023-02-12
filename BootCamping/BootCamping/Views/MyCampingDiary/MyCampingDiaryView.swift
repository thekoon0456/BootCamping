//
//  MyCampingDiary.swift
//  BootCamping
//
//  Created by Deokhun KIM on 2023/01/17.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct MyCampingDiaryView: View {
    
    @State var isNavigationGoFirstView = false

    @EnvironmentObject var diaryStore: DiaryStore
    @EnvironmentObject var faceId: FaceId
//    @EnvironmentObject var commentStore: CommentStore
    
    @StateObject var diaryLikeStore: DiaryLikeStore = DiaryLikeStore()
    @StateObject var commentStore: CommentStore = CommentStore()
    
    
    
    @AppStorage("faceId") var usingFaceId: Bool? //페이스id 설정 사용하는지
    //faceId.isLocked // 페이스 아이디가 잠겨있는지.
    
    var body: some View {
        ZStack {
            VStack {
                if usingFaceId ?? true && faceId.islocked {
                    DiaryLockedView()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            ForEach(diaryStore.myDiaryUserInfoDiaryList.indices, id: \.self) { index in
                                DiaryCellView(item: diaryStore.myDiaryUserInfoDiaryList[index])
                                    .task {
                                        if index == diaryStore.myDiaryUserInfoDiaryList.count - 1 {
                                            Task {
                                                diaryStore.nextGetMyDiaryCombine()
                                            }
                                        }
                                    }
                                
                            }
                        }
                    }
                    .refreshable {
                        diaryStore.firstGetMyDiaryCombine()
                    }
                    .padding(.top)
                    .padding(.bottom, 1)
                }
                
            }
            .background(Color.bcWhite)
            //다이어리 비어있을때 추가 화면
            DiaryEmptyView().zIndex(-1)
        }
        .onAppear {
            if usingFaceId == true {
                faceId.authenticate()
            }
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                Text("My Camping Diary")
                    .font(.title.bold())
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink (destination:DiaryAddView(isNavigationGoFirstView: $isNavigationGoFirstView), isActive: $isNavigationGoFirstView)
                 {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct MyCampingDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        MyCampingDiaryView()
            .environmentObject(DiaryStore())
            .environmentObject(FaceId())
    }
}


