//
//  ContentView.swift
//  Edutaiment
//
//  Created by Liko Setiawan on 12/02/24.
//

import SwiftUI


struct Question {
    let question: String
    let answer: Int
}

struct ContentView: View {
    
    @State private var multiplicationTable = 2
    @State private var selectQuestions = [5, 10, 15, 20]
    @State private var selectQuestion = 10
    
    @State private var questionSet = [Question]()
    @State private var currentQuestionIndex = 0
    
    @State private var showQuestion = false
    @State private var userAnswer = ""
    
    @State private var alertTitle = ""
    @State private var alertMssg = ""
    @State private var showAlert = false
    
    @State private var totalCorrectAnswer = 0
    @State private var gameFinished = false
    
    var body: some View {
        NavigationStack{
            VStack{
                List{
                    Section("Choose the game"){
                        Stepper("Multiplication \(multiplicationTable)", value: $multiplicationTable, in: 2...12)
                        
                        Picker("Pick Difficulty", selection: $selectQuestion){
                            ForEach(selectQuestions, id: \.self){ ask in
                                Text("\(ask) Question")
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .frame(maxHeight: 180)
//                .background(.red)
            
                Button(action: {
                    generateQuestion()
                    withAnimation{
                        showQuestion.toggle()
                    }
                }, label: {
                    Text(showQuestion ? "Exit!" : "Start!")
                        .foregroundStyle(showQuestion ? .red : .black)
                    
                    
                })
                .padding(.bottom, 30)
                VStack{
                    if showQuestion{
                        Text("Question")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .bold()
                            .transition(.asymmetric(insertion: .scale, removal: .opacity))
                        
                        Text("\(currentQuestionIndex + 1 )")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .bold()
                        
                        Text("\(questionSet[currentQuestionIndex].question) ...")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .padding(.vertical, 10)
                        
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        
                        TextField("Answer", text: $userAnswer)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                        
                    }
                    if gameFinished {
                        summaryView
                    }
                    
                    Spacer()
                    
                    
                    
                }
            }
            .navigationTitle("Edutaiment")
            .onSubmit {
                nextQuestion()
            }
            .alert(alertTitle, isPresented: $showAlert){
                Button("OK"){
//                    generateQuestion()
                }
            }message: {
                Text(alertMssg)
            }
            .background(Color(hex: 0xf7f7f7))
        }
    }
    
    func generateQuestion(){
        questionSet = []
        for i in 1...selectQuestion {
            let question = "\(multiplicationTable) x \(i) = "
            let answer = multiplicationTable * i
            questionSet.append(Question(question: question, answer: answer))
        }
        questionSet.shuffle()
        currentQuestionIndex = 0
    }
    
    func nextQuestion() {
        
        let correctAnswer = questionSet[currentQuestionIndex].answer
        let userAnswers = Int(userAnswer) ?? 0
        
        if userAnswers == correctAnswer {
                alert(title: "Correct", message: "Go to the next question")
                totalCorrectAnswer += 1
            } else {
                alert(title: "Wrong", message: "The correct answer is \(correctAnswer)")
            }
        
        if currentQuestionIndex < questionSet.count - 1 {
            currentQuestionIndex += 1
            userAnswer = ""
        } else {
           gameFinished = true
        }
    }
    
    var summaryView: some View {
           VStack {
               Text("Game Over!")
                   .font(.title)
                   .padding()
               
               Text("You got \(totalCorrectAnswer) out of \(questionSet.count) correct!")
                   .padding()
               
               Button("Play Again") {
                   resetGame()
               }
               .padding()
           }
       }
    
    func resetGame() {
        totalCorrectAnswer = 0
        gameFinished = false
        generateQuestion()
        showQuestion = false
    }
    
    
    func alert(title : String, message : String){
        alertTitle = title
        alertMssg = message
        showAlert = true
        
    }
    
}

extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}

#Preview {
    ContentView()
}
