//
//  ContentView.swift
//  SwiftUI Pencil Kit
//
//  Created by Amineelhajjaji on 19/5/2021.
//

import SwiftUI
import PencilKit

struct ContentView: View {
    
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct Home: View {
    @State var canvas = PKCanvasView()
    @State var isDraw = true
    @State var color : Color = .black
    @State var type:PKInkingTool.InkType = .pen

    //Default is pen
    var body: some View {
        NavigationView{
            VStack{
                
                HStack{
                    Spacer()
                    Menu {
                       
                            Button(action: {
                                // Changing type
                                isDraw = true
                                self.type = .pencil
                            }) {
                                Label("Pencil", systemImage: "pencil")
                            }
                            
                            Button(action: {
                                // Changing type
                                isDraw = true
                                self.type = .pen
                            }) {
                                Label("Pen", systemImage: "pencil.tip")
                            }
                        
                           Button(action: {
                            // Changing type
                            isDraw = true
                            self.type = .marker
                           }) {
                            Label("Marker", systemImage: "highlighter")
                           }
                    }
                    label: {
                        Label("Tool", systemImage: "pencil.circle")
                            .foregroundColor(.black)

                    }
                }.padding()
                //Drawing View
                DrawingView(canvas: $canvas, isDraw: $isDraw, type:$type)
                    .frame(width: 300, height: 300)
                
                HStack{
                    Button(action: {
                        //Saving Image
                        SaveImage()
                    }, label: {
                        Image(systemName: "square.and.arrow.down.fill")
                            .font(.title)
                            .foregroundColor(.black)

                    })
                    Spacer()
                    Button(action: {
                        //Erase tool
                        self.isDraw.toggle()
                    }, label: {
                        Image(systemName: "pencil.slash")
                            .font(.title)
                            .foregroundColor(.black)
                    })
                }.padding()
            }
            .navigationTitle("Delivred")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
    func SaveImage(){
        //Getting image from canvas
        let image = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
        //Saving to albums
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

struct DrawingView: UIViewRepresentable {
    //To capture drawing for savin into albums
    @Binding var canvas : PKCanvasView
    @Binding var isDraw : Bool
    @Binding var type : PKInkingTool.InkType

    
    let eraser = PKEraserTool(.bitmap)
    
    var ink :PKInkingTool{
        PKInkingTool(type,color: .black)
    }
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        canvas.tool = isDraw ? ink : eraser
        return canvas
    }
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        //Update tool when
        uiView.tool = isDraw ? ink : eraser
    }
    
}
