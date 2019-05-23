//
//  ViewController.swift
//  PromiseKitDemo
//
//  Created by Alex wee on 2019/5/14.
//  Copyright © 2019 Alex wee. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit
class User:NSObject{
    var name : String = ""
    var age  : Int = 0
    var imageUrl : URL?
    
    
    init(dic:[String:Any]) {
        super.init()
        setValuesForKeys(dic)
    }

}

class MyRestAPI {
    func user() -> Promise<User> {
        return firstly {
            URLSession.shared.dataTask(.promise, with: URL(string: "http://maweefeng.github.com/appfeauterd.json")!)
            }.compactMap {
                try JSONSerialization.jsonObject(with: $0.data) as? [String: Any]
            }.map { dict in
                User(dic: dict)
        }
    }
    
    func avatar() -> Promise<UIImage> {
        return user().then { user in
            URLSession.shared.dataTask(.promise, with: user.imageUrl!)
            }.compactMap {
                UIImage(data: $0.data)
        }
    }
}


class ViewController: UIViewController {

    
    private let (promise, seal) = Guarantee<String>.pending()  // use Promise if your flow can fail

  

    let tableView = UITableView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 375, height: 700)))
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //MyRestAPI().avatar()
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //self.getworkflow()
        makeFetch { (str, err) -> String in
            
            return str!
        }
        
        // 声明一个闭包(有两个整形参数，且返回值为整形的闭包)
        var sumClosure:((_ a: Int, _ b: Int) -> Int)
        
        // 实现闭包
        sumClosure = {  (a: Int, b: Int) -> Int in
            return a + b
        }
        
        // 调用
        let sum = sumClosure(10,20)
        print(sum)
        
        
        self.first(message: "111").then({ messege in
            return self.second(message: messege as! String)
        }).isResolved
        
    }

    func animateCell(){
        var fade = Guarantee.value(Bool())
        for cell in tableView.visibleCells {
            fade = fade.then {_ in
                UIView.animate(.promise, duration: 1, animations: {
                    cell.alpha = 0
                })
            }
        }
        fade.done {_ in
            
            
        }
    }
    

    func getworkflow() {
        self.first(message: "111").then({ messege in
            return self.second(message: messege as! String)
        }).then({mess in
            return self.third(message: mess as! String)
        }).catch { (error) in
            print(error)
        }
    }
    
    
    func first(message:String) -> AnyPromise{

        let promise = AnyPromise(__D: __AnyPromise(resolver: { resolve in
            
            resolve(message)
        }))
        
        return promise
        
    }
    func second(message:String) -> AnyPromise{
        
        let promise = AnyPromise(__D: __AnyPromise(resolver: { resolve in
            
            resolve(message)
        }))
        
        
        return promise
        
    }
    func third(message:String) -> AnyPromise{
        
        let promise = AnyPromise(__D: __AnyPromise(resolver: { resolve in
            
            resolve(message)
        }))
        
        
        return promise
        
    }
    func fetch(completion: (String?, Error?) -> Void){

    }
    
    func fetch() -> Promise<String> {

        return Promise { fetch(completion: $0.resolve) }
    }
    
    
    
    func makeFetch(completion:@escaping (String?,Error?)->String){
         //这里面进行一系列网络请求的操作
        
        URLSession.shared.dataTask(with: URL(string: "http://www.baidu.com")!) { (data, response, error) in
            
            if error != nil{
                
                completion("je", nil)
                

            }
            
        }
        
    }
    
    func login() -> Promise<String> {
        
        return Promise<String>{ seal in
            
            seal.fulfill("name")

        }
    }
    
    
    /*
    func fetch() -> Promise<String> {

        return Promise<String>{ seal in
            
            fetch{ (result, error) in
                if let error = error {
                    seal.reject(error)
                }else if let success = result{
                    seal.fulfill(success)
                }else{
                    seal.reject(PMKError.invalidCallingConvention)
                }
            }
        }
    }*/
}


extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = String(indexPath.row)
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        animateCell()
        
        
    }
    
    
    
}
