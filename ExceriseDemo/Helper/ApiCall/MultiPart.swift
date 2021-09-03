//
//  MultiPart.swift
//  MultiPartSwift

let multiPartFieldName = "fieldName"
let multiPartPathURLs = "pathURL"

class MultiPart: NSObject {
    
    var session: URLSession?
    
    func callPostWebService<T : Decodable>(_ url_String: String, parameters: [String: Any]?, filePathArr arrFilePath: [[String:Any]]?, model : T.Type, isLoader : Bool = true, isAPIToken : Bool = false, completion: @escaping (_ success: Bool, _ object: AnyObject?)->()) {
        
        if isLoader {
            Utility().showLoader()
        }
        
        let boundary = generateBoundaryString()
        
        let request = NSMutableURLRequest(url: URL(string: url_String)!)
        request.httpMethod = "POST"
        
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        if isAPIToken, let apiToken : String = KeychainWrapper.standard.string(forKey: UserDefault.kAPIToken) {
            request.setValue("Bearer " + apiToken, forHTTPHeaderField: "Authorization")
        }
        
        let httpBody: Data? = createBody(withBoundary: boundary, parameters: parameters, paths: arrFilePath)
        session = URLSession.shared
        
        request.setValue("\(httpBody!.count)", forHTTPHeaderField:"Content-Length")
        
        let task = session?.uploadTask(with: request as URLRequest, from: httpBody, completionHandler: {(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void in
            
            Utility().hideLoader()
            
            if error != nil {
                print("error = \(error ?? 0 as! Error)")
                DispatchQueue.main.async(execute: {() -> Void in
                    completion( false , error as AnyObject)
                })
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        print(convertedJsonIntoDict)
                    }
                    
                    let dictResponse = try decoder.decode(GeneralResponseModel.self, from: data )
                    
                    let success = dictResponse.success!
                    
                    if success == "1" {
                        let dictResponsee = try decoder.decode(model, from: data)
                        mainThread {
                            completion(true,dictResponsee as AnyObject)
                        }
                    } else {
                        mainThread {
                            completion(false, nil)
                        }
                    }
                    
                } catch let error as NSError {
                    print("\n\n===========Error===========")
                    print("Error Code: \(error._code)")
                    print("Error Messsage: \(error.localizedDescription)")
                    if let str = String(data: data, encoding: String.Encoding.utf8){
                        print("Print Server data:- " + str)
                    }
                    debugPrint(error)
                    print("===========================\n\n")
                    
                    debugPrint(error)
                    completion(false, error as AnyObject)
                }
            }
        })
        task?.resume()
    }
    
    func createBody(withBoundary boundary: String, parameters: [String: Any]?, paths: [[String:Any]]?) -> Data {
        var httpBody = Data()
        
        // add params (all params are strings)
        if let parameters = parameters {
            for (parameterKey, parameterValue) in parameters {
                httpBody.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                httpBody.append("Content-Disposition: form-data; name=\"\(parameterKey)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                httpBody.append("\(parameterValue)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        
        // add File data
        if let paths = paths {
            
            for pathDic in paths {
                for path: String in pathDic[multiPartPathURLs] as! [String] {
                    let filename: String = URL(fileURLWithPath: path).lastPathComponent
                    do {
                        let data = try Data(contentsOf: URL(fileURLWithPath: path))
                        
                        let mimetype: String = mimeType(forPath: path)
                        httpBody.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                        httpBody.append("Content-Disposition: form-data; name=\"\(pathDic[multiPartFieldName] ?? "")\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
                        httpBody.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
                        httpBody.append(data)
                        httpBody.append("\r\n".data(using: String.Encoding.utf8)!)
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                }
            }
        }
        httpBody.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        return httpBody
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    func mimeType(forPath path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
}
