////
////  DiaryAddContentView.swift
////  BootCamping
////
////  Created by 차소민 on 2023/02/08.
////
//
//import SwiftUI
//import Firebase
//
//// 키보드 다음 버튼 눌렀을 때 다음 텍스트 필드로 넘어가기 위해 필요해요
//
//
//struct DiaryAddContentView: View {
//    
//    // 탭 했을 때 작성하기 버튼 숨기기 위해서
//    @State var isTapTextField = false
//    
//    @State private var diaryTitle: String = ""
//    @Binding var locationInfo: String
//    @Binding var visitDate: String
//    @Binding var diaryIsPrivate: Bool   //false가 공개
//    @State private var diaryContent: String = ""
//    
//    @EnvironmentObject var diaryStore: DiaryStore
//    @EnvironmentObject var wholeAuthStore: WholeAuthStore
//    @Environment(\.dismiss) private var dismiss
//    
//    //키보드 dismiss 변수
//    @FocusState private var inputFocused: Bool
//    
//    //글 작성 유저 닉네임 변수
//    var userNickName: String? {
//        get {
//            for user in wholeAuthStore.userList {
//                if user.id == Auth.auth().currentUser?.uid {
//                    return user.nickName
//                }
//            }
//            return nil
//        }
//    }
//    
//    //MARK: - DatePicker 변수
//    @Binding var selectedDate: Date
//    
//    //이미지 피커
//    @Binding var diaryImages: [Data]?         // selectedImages를 [Data] 타입으로 저장
//    
//    var body: some View {
//        VStack(alignment: .leading){
//            addViewTitle
//            addViewDiaryContent
//            Spacer()
//            
//            if isTapTextField == false{
//                addViewAddButton
//                    .animation(.none/*, value: isTapTextField*/) // 이거 추가하면 애니메이션 다시 생김;;;;
//            }
//        }
//        .disableAutocorrection(true) //자동 수정 비활성화
//        .textInputAutocapitalization(.never) //첫 글자 대문자 비활성화
//        .padding(.horizontal, UIScreen.screenWidth*0.03)
//        .navigationTitle(Text("캠핑 일기 쓰기"))
//        .toolbar {
//            ToolbarItemGroup(placement: .keyboard) {
//                Spacer()
//                Button {
//                    submit()
//                    isTapTextField = false
//                } label: {
//                    Image(systemName: "keyboard.chevron.compact.down")
//                }
//            }
//        }
//        .navigationBarBackButtonHidden(true)     // 전 페이지 이름 나오는 백버튼은 지우고
//        .navigationBarItems(leading: backButton) // 새로 만든 기호만 있는 백버튼 추가
//    }
//}
//
//extension DiaryAddContentView {
//    // MARK: 제목
//    var addViewTitle: some View {
//        Section {
//            TextField("제목을 입력해주세요(최대 20자)", text: $diaryTitle)
//                .font(.title3)
//                .padding(.vertical)
//                .submitLabel(.next)
//                .onChange(of: diaryTitle) { newValue in             // 제목 20글자까지 가능
//                    if newValue.count > 20 {
//                        diaryTitle = String(newValue.prefix(20))
//                    }
//                }
//        }
//        .focused($inputFocused)
//        .onSubmit{
//            activeState = .field2
//        }
//        .onTapGesture {
//            isTapTextField = true
//        }
//    }
//    
//    //MARK: - 일기 작성 뷰
//    var addViewDiaryContent: some View {
//        VStack {
//            
//            TextField("일기를 작성해주세요", text: $diaryContent, axis: .vertical)
//                .focused($inputFocused)
//                .onTapGesture {
//                    isTapTextField = true
//                }
//                .focused($activeState, equals: .field2)
//        }
//    }
//    //TODO: 글 안쓰면 버튼 비활성화
//    //MARK: - 추가버튼
//    var addViewAddButton: some View {
//        HStack {
//            Spacer()
//            Button {
//                diaryStore.createDiaryCombine(diary: Diary(id: UUID().uuidString, uid: Auth.auth().currentUser?.uid ?? "", diaryUserNickName: userNickName ?? "닉네임", diaryTitle: diaryTitle, diaryAddress: locationInfo, diaryContent: diaryContent, diaryImageNames: [], diaryImageURLs: [], diaryCreatedDate: Timestamp(), diaryVisitedDate: selectedDate, diaryLike: [], diaryIsPrivate: diaryIsPrivate), images: diaryImages ?? [Data()])
//            } label: {
//                Text(diaryTitle.isEmpty || diaryContent.isEmpty ? "내용을 작성해주세요" : "일기 쓰기")
//                    .frame(width: UIScreen.screenWidth * 0.9, height: UIScreen.screenHeight * 0.07) // 이거 밖에 있으면 글씨 부분만 버튼 적용됨
//            }
//            .font(.headline)
//            .foregroundColor(.white)
//            .background(diaryTitle.isEmpty || diaryContent.isEmpty ? .secondary : Color.bcGreen)
//            .cornerRadius(10)
//            .disabled(diaryTitle.isEmpty || diaryContent.isEmpty)
//            Spacer()
//            
//        }
//        .padding(.bottom, 10)
//        
//    }
//    
//    //네비게이션 타고 오면 전 페이지 타이틀이 백버튼으로 나와서 글씨 지우고 싶어서 백버튼 만들었어요
//    var backButton: some View{
//        Button {
//            dismiss()
//        } label: {
//            Image(systemName: "chevron.left")
//                .font(.headline)
//        }
//    }
//    
//    //MARK: - 키보드 dismiss 함수입니다.
//    func submit() {
//        resignKeyboard()
//    }
//    //iOS 15 아래버전은 유킷연동 함수 사용
//    func resignKeyboard() {
//        if #available(iOS 15, *) {
//            inputFocused = false
//        } else {
//            dismissKeyboard()
//        }
//    }
//}
//
////struct DiaryAddContentView_Previews: PreviewProvider {
////    static var previews: some View {
////        DiaryAddContentView(locationInfo: <#Binding<String>#>, visitDate: <#Binding<String>#>, diaryIsPrivate: <#Binding<Bool>#>, selectedDate: <#Binding<Date>#>, imagePickerPresented: <#Binding<Bool>#>, selectedImages: <#Binding<[UIImage]?>#>, diaryImages: <#Binding<[Data]?>#>)
////    }
////}