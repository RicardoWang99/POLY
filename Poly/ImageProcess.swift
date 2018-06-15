//
//  ImageProcess.swift
//  Poly
//
//  Created by 王西平 on 2018/5/27.
//  Copyright © 2018 王西平. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import GPUImage
import AVFoundation





class MyPoint{
    var P = CGPoint(x:0,y:0)
}
class MyLine{
    var P1 = CGPoint(x:0,y:0)
    var P2 = CGPoint(x:0,y:0)
    func _init(p1: CGPoint,p2: CGPoint) {
        P1 = p1
        P2 = p2
        
        if(P1.x > P2.x){
            swap(&P1,&P2)
        }
        else if(P1.x == P2.x && P1.y > P2.y)
        {
            swap(&P1,&P2)
        }
    }
}
class tri
{
    var P1 = CGPoint(x:0,y:0)
    var P2 = CGPoint(x:0,y:0)
    var P3 = CGPoint(x:0,y:0)
    var P0 = CGPoint(x:0,y:0)
    var Id1 = Int(0)
    var Id2 = Int(0)
    var Id3 = Int(0)
    
    var or = CGFloat(0.0)
    
    func get_dis(p1: CGPoint,p2: CGPoint) -> CGFloat{
        return sqrt((p1.x-p2.x)*(p1.x-p2.x)+(p1.y-p2.y)*(p1.y-p2.y))
    }
    func check(P4: CGPoint) -> Bool{
        return (get_dis(p1:P4,p2:P0)<or)
    }
    func check2(P4: CGPoint) -> Bool{
        return (get_dis(p1:P4,p2:P0)<or)
    }
    func _init(p1: CGPoint,p2: CGPoint,p3: CGPoint,id1: Int,id2: Int,id3: Int) {
        P1 = p1
        P2 = p2
        P3 = p3
        Id1 = id1
        Id2 = id2
        Id3 = id3
        let A1 = 2.0*(P2.x-P1.x)
        let B1 = 2.0*(P2.y-P1.y)
        let C1 = (P2.x*P2.x + P2.y*P2.y) - (P1.x*P1.x + P1.y*P1.y)
        
        let A2 = 2.0*(P3.x-P2.x)
        let B2 = 2.0*(P3.y-P2.y)
        let C2 = (P3.x*P3.x + P3.y*P3.y) - (P2.x*P2.x + P2.y*P2.y)
        
        P0.x = ((C1*B2)-(C2*B1))/((A1*B2)-(A2*B1))
        P0.y = ((A1*C2)-(A2*C1))/((A1*B2)-(A2*B1))
        
        or = get_dis(p1:P0,p2:P1)
        
    }
}

class new_tri
{
    var id1 = Int(0)
    var id2 = Int(0)
    var id3 = Int(0)
    
    var P0 = CGPoint(x:0,y:0)
    var P1 = CGPoint(x:0,y:0)
    var P2 = CGPoint(x:0,y:0)
    var P3 = CGPoint(x:0,y:0)
    
    var id12 = Int(0)
    var id23 = Int(0)
    var id13 = Int(0)
    
    var or = CGFloat(0.0)
    
    func get_dis(p1: CGPoint,p2: CGPoint) -> CGFloat{
        return sqrt((p1.x-p2.x)*(p1.x-p2.x)+(p1.y-p2.y)*(p1.y-p2.y))
    }
    func check(P4: CGPoint) -> Bool{
        return (get_dis(p1:P4,p2:P0)<or)
    }
    func check2(P4: CGPoint) -> Bool{
        return (get_dis(p1:P4,p2:P0)<or)
    }
    func _init(Id1: Int,Id2: Int,Id3: Int,Id12: Int,Id23: Int,Id13: Int,p1:CGPoint,p2:CGPoint,p3:CGPoint ) {
        
        var id1 = Id1
        var id2 = Id2
        var id3 = Id3
        
        P1 = p1
        P2 = p2
        P3 = p3
        
        var id12 = Id12
        var id23 = Id23
        var id13 = Id13
        
        let A1 = 2.0*(P2.x-P1.x)
        let B1 = 2.0*(P2.y-P1.y)
        let C1 = (P2.x*P2.x + P2.y*P2.y) - (P1.x*P1.x + P1.y*P1.y)
        
        let A2 = 2.0*(P3.x-P2.x)
        let B2 = 2.0*(P3.y-P2.y)
        let C2 = (P3.x*P3.x + P3.y*P3.y) - (P2.x*P2.x + P2.y*P2.y)
        
        P0.x = ((C1*B2)-(C2*B1))/((A1*B2)-(A2*B1))
        P0.y = ((A1*C2)-(A2*C1))/((A1*B2)-(A2*B1))
        
        or = get_dis(p1:P0,p2:P1)
        
    }
}


class ImageProcess{
    
    var random_points = [MyPoint]()
    var keyPoints = [MyPoint]()
    var points = [CGPoint]()
    var triangles = [tri]()
    var pixelData = [UInt8]()
    var pixelData_2 = [UInt8]()
    var Lines = [[(Int,Int)]]()
    var bitmap : CGContext?
    var dict = [Int : Bool]()
    var tri_dict = [ Int : Bool]()
    var Count = Int(0)
    var firstTime = false
    var context: CGContext?
    var context_2: CGContext?
    
    func convertCIImageToCGImage(ciImage:CIImage) -> CGImage{
        
        
        let ciContext = CIContext.init()
        let cgImage:CGImage = ciContext.createCGImage(ciImage, from: ciImage.extent)!
        return cgImage
    }
    /*
     func getPixels(){
     for i in 0..<640 {
     var pointsTmp = [MyPoint]()
     for j in 0..<480 {
     let now = (i)+(479-j)*640
     let MyP = MyPoint()
     MyP.P = CGPoint(x:CGFloat(i)-320.0 ,y:CGFloat(j)-240.0)
     MyP.r = CGFloat(self.pixelData[now*4])
     MyP.g = CGFloat(self.pixelData[now*4+1])
     MyP.b = CGFloat(self.pixelData[now*4+2])
     MyP.a = CGFloat(self.pixelData[now*4+3])
     pointsTmp.append(MyP)
     }
     self.points.append(pointsTmp)
     }
     return
     }*/
    func deleteKeyPoint(){
        var p = Int(350.0 / Double(self.keyPoints.count) * 1000.0)
        var i = -1
        var c = self.keyPoints.count
        for _ in 0..<c{
            i = i + 1
            
            if (arc4random()%1000 > p){
                self.keyPoints.remove(at: i)
                i = i-1
            }
        }
    }
    func checkKeyPoints(){
        var miaomiao = 0
        self.bitmap!.setFillColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        for i in self.keyPoints{
            miaomiao = miaomiao + 1
            
            var or = Int(0)
            var og = Int(0)
            var ob = Int(0)
            var ox = (CGFloat(i.P.y)-240.0)*4.0/3.0
            var oy = (CGFloat(i.P.x)-320.0)*3.0/4.0
            //print((Int(ox)+320+(Int(oy)+240)*640)*4+0)
            var now = (Int(ox)+320+(0-Int(oy)+240)*640)*4+0
            if(now >= 4*640*480)
            {
                now = 4*640*480-4
            }
            or = Int(self.pixelData_2[now+0])
            og = Int(self.pixelData_2[now+1])
            ob = Int(self.pixelData_2[now+2])
            
            // self.bitmap!.setFillColor(red: CGFloat(or)/255.0, green: CGFloat(og)/255.0, blue: CGFloat(ob)/255.0, alpha: 1.0)
            //self.bitmap!.setFillColor(red: i.r/255.0, green: i.g/255.0, blue: i.b/255.0, alpha: 1.0)
            self.bitmap!.fill(CGRect.init(x: (CGFloat(i.P.y)-240.0)*4.0/3.0, y: (CGFloat(i.P.x)-320.0)*3.0/4.0 , width: 3, height: 3))
        }
        
        
        
        for i in self.random_points{
            miaomiao = miaomiao + 1
            self.bitmap!.setFillColor(red: 1.0, green: 0, blue: 0, alpha: 1.0)
            //self.bitmap!.setFillColor(red: i.r/255.0, green: i.g/255.0, blue: i.b/255.0, alpha: 1.0)
            self.bitmap!.fill(CGRect.init(x: (CGFloat(i.P.y)-240.0)*4.0/3.0, y: (CGFloat(i.P.x)-320.0)*3.0/4.0 , width: 3, height: 3))
        }
        
        print("total point:",miaomiao)
    }
    
    func getPoints(){
        //
        
        //V 1.0
        if(self.firstTime)
        {
            var i = -1
            for P in self.keyPoints{
                i = i + 1
                let ix = Int(P.P.x)
                let iy = Int(P.P.y)
                let tmp = CGFloat(self.pixelData[Int(ix+(iy)*640)*4])
                if ( tmp<25.0 ){
                    if(arc4random()%100 > 75){
                        self.keyPoints.remove(at: i)
                        i = i-1
                        self.dict[Int(ix+(iy)*640)] = false
                    }
                    else
                    {
                        
                    }
                    
                }else{
                    if(arc4random()%100 > 97){
                        self.keyPoints.remove(at: i)
                        i = i-1
                        self.dict[Int(ix+(iy)*640)] = false
                    }
                    else
                    {
                        
                    }
                }
            }
            
            if(self.keyPoints.count > 350)
            { 
                self.deleteKeyPoint();
            }
            
            for P in self.random_points{
                if(arc4random()%1000 > 992){
                    
                    P.P.x = CGFloat(arc4random()%640)
                    P.P.y = CGFloat(arc4random()%480)
                }
                else
                {
                    
                }
            }
            
            for i in 1..<640{
                for j in 1..<480{
                    if( (i%5==0) && (j%5==0) ){
                        
                        let now = (i)+(j)*640
                        
                        if(self.dict[Int(now)] == true)
                        {
                            continue
                        }
                        
                        var tmp = CGFloat(self.pixelData[now*4])
                        
                        if( tmp > 25.0 && arc4random()%1000 > 982 ){
                            self.dict[Int(now)] = true
                            let MyP = MyPoint()
                            MyP.P = CGPoint(x:i,y:j)
                            //MyP.P = CGPoint(x:(CGFloat(j)-240.0)*4.0/3.0 , y:(CGFloat(i)-320.0)*3.0/4.0 )
                            
                            self.keyPoints.append(MyP)
                        }
                    }
                    else{
                        
                    }
                }
            }
            
            
        }
        else{
            self.firstTime = true
            
            self.keyPoints = [MyPoint]()
            self.random_points = [MyPoint]()
            for i in 1..<640{
                for j in 1..<480{
                    if( true ){
                        
                        let now = (i)+(j)*640
                        
                        let tmp = CGFloat(self.pixelData[now*4])
                        
                        if( tmp > 35.0 && arc4random()%10000 > 9810){
                            self.dict[Int(now)] = true
                            let MyP = MyPoint()
                            MyP.P = CGPoint(x:i,y:j)
                            //MyP.P = CGPoint(x:(CGFloat(j)-240.0)*4.0/3.0 , y:(CGFloat(i)-320.0)*3.0/4.0 )
                            
                            self.keyPoints.append(MyP)
                        }
                    }
                    else{
                        
                    }
                }
            }
            
            for _ in 0..<40{
                let MyP = MyPoint()
                MyP.P = CGPoint(x:CGFloat(arc4random()%639 + 1),y:CGFloat(arc4random()%479 + 1))
                self.random_points.append(MyP)
            }
        }
        
        
        
        
        
        // self.checkKeyPoints()
        
    }
    
    func getPointsAndTri(){
        
    }
    
    func addlines(id1:Int, id2:Int){
        var id = Int(id1*10000 + id2)
        //print(id1,id2,self.tri_dict[id])
        if(self.tri_dict[id] == true){
            self.tri_dict[id] = false
        }
        else{
            self.tri_dict[id] = true
        }
        return
    }
    
    func cmp(num1: CGPoint, num2: CGPoint) -> Bool {
        return num1.x < num2.x
    }
    func eq(num1: CGPoint, num2: CGPoint) -> Bool {
        return (abs(num1.x - num2.x)+abs(num1.y-num2.y) < 0.00001)
    }
    var new_triangles = [new_tri]()
    var tmp_points = [Int]()
    var tmp_tri = [Int]()
    func insert(id:Int,id2:Int)
    {
        print(id,id2)
        var T = self.new_triangles[self.tmp_tri[id2]]
        var T2 = new_tri()
        T2._init(Id1: id, Id2: self.tmp_points[id2-1], Id3: self.tmp_points[id2], Id12: -1, Id23:self.tmp_tri[id2] , Id13: -1, p1: self.points[id], p2: self.points[self.tmp_points[id2-1]], p3: self.points[self.tmp_points[id2]])
        self.new_triangles.append(T2)
        self.tmp_points.insert(id, at: id2)
        self.tmp_tri.insert(self.new_triangles.count-1,at:id2)
        
        return
    }
    
    func update (id1:Int,id2:Int)
    {
        var T1 = self.new_triangles[id1]
        var T2 = self.new_triangles[id2]
        
        var Id1 = -1
        

        
    }
    func getTriFaster()
    {
        print("start getTri faster")
        
        self.points = [CGPoint]()
        
        self.new_triangles = [new_tri]()
        
        self.points.append(CGPoint(x:-320.15,y:-240))
        self.points.append(CGPoint(x:-320.10,y:+240))
        self.points.append(CGPoint(x:+320.10,y:-240))
        self.points.append(CGPoint(x:+320.15,y:+240))
        
        for p in self.keyPoints{
            self.points.append(CGPoint(x:(CGFloat(p.P.y)-240.0)*4.0/3.0 , y:(CGFloat(p.P.x)-320.0)*3.0/4.0 ))
        }
 
        for p in self.random_points{
            self.points.append(CGPoint(x:(CGFloat(p.P.y)-240.0)*4.0/3.0 , y:(CGFloat(p.P.x)-320.0)*3.0/4.0 ))
        }
        
        self.points.sort(by: cmp)
        
        var pc = self.points.count
        
        
        self.tmp_points = [Int]()
        self.tmp_tri = [Int]()
        self.tmp_points.append(0)
        self.tmp_points.append(2)
        self.tmp_points.append(1)
        self.tmp_tri.append(0)
        self.tmp_tri.append(0)
        self.tmp_tri.append(0)
        
        var T_tmp = new_tri()
        var T = new_tri()
        T._init(Id1: 0, Id2: 2, Id3: 1, Id12: -1, Id23: -1, Id13: -1, p1: self.points[0], p2: self.points[2], p3: self.points[1])
        self.new_triangles.append(T)
        
        
        
        //pc = Int(10)
        for ct in 0..<pc{
            
            var p = self.points[ct]
            if(ct <= 2)
            {
                
            }
            else if(ct == pc-1 || ct == pc-2)
            {
                
            }
            else
            {
                var L = Int(1),R = Int(tmp_points.count-1) , ans = Int(-1) ,mid = Int(-1)
                while(L<=R)
                {
                    mid = Int((L+R)/2)
                    
                    //print(L,mid,R,ans,ct,tmp_points.count)
                    if(self.points[self.tmp_points[mid]].y >= self.points[ct].y)
                    {
                        ans = mid
                        R = mid-1
                    }
                    else
                    {
                        L = mid + 1
                    }
                    
                    
                }
                
                self.insert(id: ct,id2: ans)
                
                
                print("nwe, ",ct,ans)
                
            }
        }
        self.triangles = [tri]()
        for nt in self.new_triangles{
            var T = tri()
            T._init(p1: nt.P1, p2: nt.P2, p3: nt.P3, id1: nt.id1 , id2: nt.id2 , id3: nt.id3)
            self.triangles.append(T)
        }
        
    }
    
    func getTri()
    {
        /*
         self.points.append(CGPoint(x:-320-5,y:-240-5))
         self.points.append(CGPoint(x:-320-5,y:+720+5))
         self.points.append(CGPoint(x:+960+5,y:-240-5))
         */
        
        print("start getTri")
        
        self.points = [CGPoint]()
        self.tri_dict = [ Int : Bool]()
        self.triangles = [tri]()
        
        self.points.append(CGPoint(x:-320.15,y:-240))
        self.points.append(CGPoint(x:-320.1,y:+240))
        self.points.append(CGPoint(x:+320.1,y:-240))
        self.points.append(CGPoint(x:+320.15,y:+240))
        
        for p in self.keyPoints{
            self.points.append(CGPoint(x:(CGFloat(p.P.y)-240.0)*4.0/3.0 , y:(CGFloat(p.P.x)-320.0)*3.0/4.0 ))
        }
        
        for p in self.random_points{
            self.points.append(CGPoint(x:(CGFloat(p.P.y)-240.0)*4.0/3.0 , y:(CGFloat(p.P.x)-320.0)*3.0/4.0 ))
        }
        
        self.points.sort(by: cmp)
        
        var T = tri();
        T._init(p1: self.points[0], p2: self.points[1], p3: self.points[self.points.count-2], id1: 0, id2: 1, id3: self.points.count-2)
        self.triangles.append(T)
        
        T = tri()
        T._init(p1: self.points[1], p2: self.points[self.points.count-2], p3: self.points[self.points.count-1], id1: 1, id2: self.points.count-2, id3: self.points.count-1)
        self.triangles.append(T)
        
        
        
        var point_count = self.points.count
        print(self.points.count,self.triangles.count)
        
        var tmp_tri = [tri]()
        
        for p in 2..<point_count-2{
            
            self.tri_dict = [ Int : Bool]()
            
            var c = -1
            for ck in 0..<self.triangles.count{
                c = c+1
                var t = self.triangles[c]
                // print("t.ID1:",t.Id1)
                if (self.points[p].x > t.P0.x + t.or){
                    
                    tmp_tri.append(t)
                    
                    self.triangles.remove(at: c)
                    
                    c = c-1
                }
                else if (t.check(P4: self.points[p])){
                    
                    addlines(id1:t.Id1,id2:t.Id2)
                    addlines(id1:t.Id1,id2:t.Id3)
                    addlines(id1:t.Id2,id2:t.Id3)
                    
                    self.triangles.remove(at: c)
                    
                    c = c-1
                }
                else{
                    
                }
            }
            
            for (k,v) in self.tri_dict {
                // print("get_new_tri",k,v)
                if(v == true){
                    var i2 = Int(k%10000)
                    var i1 = Int(k/10000)
                    // print("insert",i1,i2,p)
                    T = tri()
                    T._init(p1: self.points[i1], p2: self.points[i2], p3: self.points[p], id1: i1, id2: i2, id3: p)
                    self.triangles.append(T)
                }
            }
            
            
        }
        
        for t in tmp_tri{
            self.triangles.append(t)
        }
        
        
        
    }
    
    func draw() {
        var tri_count = self.triangles.count
        for t_c in 0..<tri_count{
            //print("out ",t_c)
            
            var or = Int(0)
            var og = Int(0)
            var ob = Int(0)
            var ox = (self.triangles[t_c].P1.x+self.triangles[t_c].P2.x+self.triangles[t_c].P3.x)/3.0
            var oy = (self.triangles[t_c].P1.y+self.triangles[t_c].P2.y+self.triangles[t_c].P3.y)/3.0
            //print((Int(ox)+320+(Int(oy)+240)*640)*4+0)
            var now = (Int(ox)+320+(0-Int(oy)+240)*640)*4+0
            if(now >= 4*640*480)
            {
                now = 4*640*480-4
            }
            if(now < 0)
            {
                now = 0
            }
            //print(now)
            or = Int(self.pixelData_2[now+0])
            og = Int(self.pixelData_2[now+1])
            ob = Int(self.pixelData_2[now+2])
            
            self.bitmap?.setFillColor(red: CGFloat(or)/255.0, green: CGFloat(og)/255.0, blue: CGFloat(ob)/255.0, alpha: 1.0)
            self.bitmap?.move(to: self.triangles[t_c].P1)
            self.bitmap?.addLine(to: self.triangles[t_c].P2)
            self.bitmap?.addLine(to: self.triangles[t_c].P3)
            self.bitmap?.closePath()
            self.bitmap?.fillPath()
            //self.bitmap?.strokePath()
        }
        print("tri_count",tri_count)
        
        if(tri_count == 0)
        {
            self.bitmap?.setFillColor(red: CGFloat(7%255), green: CGFloat(7%255), blue: CGFloat(7%255), alpha: 1.0)
            self.bitmap?.move(to: CGPoint(x:-320,y:-240))
            self.bitmap?.addLine(to: CGPoint(x:320,y:-240))
            self.bitmap?.addLine(to: CGPoint(x:320,y:240))
            
            self.bitmap?.closePath()
            self.bitmap?.fillPath()
            self.bitmap?.strokePath()
            
            self.bitmap?.setFillColor(red: CGFloat(7%255), green: CGFloat(7%255), blue: CGFloat(7%255), alpha: 1.0)
            self.bitmap?.move(to: CGPoint(x:-320,y:-240))
            self.bitmap?.addLine(to: CGPoint(x:-320,y:240))
            self.bitmap?.addLine(to: CGPoint(x:320,y:240))
            
            self.bitmap?.closePath()
            self.bitmap?.fillPath()
            self.bitmap?.strokePath()
        }
        
    }
    
    func fillLines() {
        
        
        self.bitmap?.setFillColor(red: CGFloat(7%255), green: CGFloat(7%255), blue: CGFloat(7%255), alpha: 1.0)
        self.bitmap?.move(to: CGPoint(x:-320,y:-240))
        self.bitmap?.addLine(to: CGPoint(x:320,y:-240))
        self.bitmap?.addLine(to: CGPoint(x:320,y:240))
        
        self.bitmap?.closePath()
        self.bitmap?.fillPath()
        self.bitmap?.strokePath()
        
        self.bitmap?.setFillColor(red: CGFloat(7%255), green: CGFloat(7%255), blue: CGFloat(7%255), alpha: 1.0)
        self.bitmap?.move(to: CGPoint(x:-320,y:-240))
        self.bitmap?.addLine(to: CGPoint(x:-320,y:240))
        self.bitmap?.addLine(to: CGPoint(x:320,y:240))
        
        self.bitmap?.closePath()
        self.bitmap?.fillPath()
        self.bitmap?.strokePath()
        
        var tri_count = self.triangles.count
        for t_c in 0..<tri_count{
            //print("out ",t_c)
            
            var or = Int(0)
            var og = Int(0)
            var ob = Int(0)
            var ox = (self.triangles[t_c].P1.x+self.triangles[t_c].P2.x+self.triangles[t_c].P3.x)/3.0
            var oy = (self.triangles[t_c].P1.y+self.triangles[t_c].P2.y+self.triangles[t_c].P3.y)/3.0
            //print((Int(ox)+320+(Int(oy)+240)*640)*4+0)
            var now = (Int(ox)+320+(0-Int(oy)+240)*640)*4+0
            if(now >= 4*640*480)
            {
                now = 4*640*480-4
            }
            if(now < 0)
            {
                now = 0
            }
            //print(now)
            or = Int(self.pixelData_2[now+0])
            og = Int(self.pixelData_2[now+1])
            ob = Int(self.pixelData_2[now+2])
            
            self.bitmap?.setFillColor(red: CGFloat(or)/255.0, green: CGFloat(og)/255.0, blue: CGFloat(ob)/255.0, alpha: 1.0)
            self.bitmap?.setLineWidth(1.0)
            self.bitmap?.move(to: self.triangles[t_c].P1)
            self.bitmap?.addLine(to: self.triangles[t_c].P2)
            self.bitmap?.addLine(to: self.triangles[t_c].P3)
            self.bitmap?.closePath()
            //self.bitmap?.fillPath()
            //self.bitmap?.fillPath()
            self.bitmap?.strokePath()
        }
        print("tri_count",tri_count)
        
        if(tri_count == 0)
        {
            self.bitmap?.setFillColor(red: CGFloat(7%255), green: CGFloat(7%255), blue: CGFloat(7%255), alpha: 1.0)
            self.bitmap?.move(to: CGPoint(x:-320,y:-240))
            self.bitmap?.addLine(to: CGPoint(x:320,y:-240))
            self.bitmap?.addLine(to: CGPoint(x:320,y:240))
            
            self.bitmap?.closePath()
            self.bitmap?.fillPath()
            self.bitmap?.strokePath()
            
            self.bitmap?.setFillColor(red: CGFloat(7%255), green: CGFloat(7%255), blue: CGFloat(7%255), alpha: 1.0)
            self.bitmap?.move(to: CGPoint(x:-320,y:-240))
            self.bitmap?.addLine(to: CGPoint(x:-320,y:240))
            self.bitmap?.addLine(to: CGPoint(x:320,y:240))
            /*
            self.bitmap?.closePath()
            self.bitmap?.fillPath()
            self.bitmap?.strokePath()
 */
        }
        
    }
    
    
    
    func processPic(img: CIImage, img2: UIImage) -> UIImage {
        
        
        
        let myUIImage = UIImage(ciImage:img)
        let myCIImage = myUIImage.ciImage
        var myCGImage = myUIImage.cgImage
        if myCGImage == nil {
            myCGImage = self.convertCIImageToCGImage(ciImage: myCIImage!)
        }
        
        let myCIImage2 = img2.ciImage
        var myCGImage2 = img2.cgImage
        if myCGImage2 == nil {
            myCGImage2 = self.convertCIImageToCGImage(ciImage: myCIImage2!)
        }
        
        if(self.firstTime == false){
            print("init")
            
            
            let size = myUIImage.size
            //let size = CGSize.init(width: 640.0, height: 480.0)
            //print("width and height :",size.width,size.height)
            let dataSize = size.width * size.height * 4
            self.pixelData = [UInt8](repeating: 0, count: Int(dataSize))
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            self.context = CGContext(data: &self.pixelData,
                                     width: Int(size.width),
                                     height: Int(size.height),
                                     bitsPerComponent: 8,
                                     bytesPerRow: 4 * Int(size.width),
                                     space: colorSpace,
                                     bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
            
            self.pixelData_2 = [UInt8](repeating: 0, count: Int(dataSize))
            self.context_2 = CGContext(data: &self.pixelData_2,
                                      width: Int(size.width),
                                      height: Int(size.height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: 4 * Int(size.width),
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
            
        }
        
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: myUIImage.size.width, height: myUIImage.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        UIGraphicsBeginImageContext(rotatedSize)
        self.bitmap = UIGraphicsGetCurrentContext()!
        self.bitmap!.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        self.bitmap!.rotate(by: (90 * CGFloat(Double.pi / 180)))
        self.bitmap!.scaleBy(x: 1.0, y: -1.0)
        let myRect = CGRect.init(x: -myUIImage.size.width / 2, y: -myUIImage.size.height / 2, width: myUIImage.size.width, height: myUIImage.size.height);
        self.bitmap!.draw(myCGImage!, in: myRect)
        
        
        let size = myUIImage.size
        
        self.context?.draw(myCGImage2!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.context?.rotate(by: (90 * CGFloat(Double.pi / 180)))
        
        self.context_2?.draw(myCGImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.context_2?.rotate(by: (90 * CGFloat(Double.pi / 180)))
        
        
        
        // self.getPixels()
        
        self.getPoints()
        
        self.checkKeyPoints()
        //self.getTri()
        //self.fillLines()
        
        self.getTri()
        //self.getTriFaster()
        
        self.draw()
        //self.fillLines()
        
        
        let final: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        return final
        
    }
}
