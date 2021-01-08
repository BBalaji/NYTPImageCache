//
//  NYTPImageCacheTests.swift
//  NYTPImageCacheTests
//
//  Created by Besta, Balaji (623-Extern) on 08/01/21.
//

import XCTest
@testable import NYTPImageCache

class NYTPImageCacheTests: XCTestCase {

    var httpClient: HttpClient!
        let session = MockURLSession()
        
        override func setUp() {
            super.setUp()
            httpClient = HttpClient(session: session)
        }
        
        override func tearDown() {
            super.tearDown()
        }
        
        func test_get_request_with_URL() {

            guard let url = URL(string: "https://picsum.photos/list") else {
                fatalError("URL can't be empty")
            }
            
            httpClient.get(url: url) { (success, response) in
                // Return data
            }
            
            XCTAssert(session.lastURL == url)
            
        }
        
        func test_get_resume_called() {
            
            let dataTask = MockURLSessionDataTask()
            session.nextDataTask = dataTask
            
            guard let url = URL(string: "https://picsum.photos/list") else {
                fatalError("URL can't be empty")
            }
            
            httpClient.get(url: url) { (success, response) in
                // Return data
            }
            
            XCTAssert(dataTask.resumeWasCalled)
        }
        
        func test_get_should_return_data() {
            let expectedData = "{}".data(using: .utf8)
            
            session.nextData = expectedData
            
            var actualData: Data?
            httpClient.get(url: URL(string: path)!) { (data, error) in
                actualData = data
                guard let data = data else {
                    return
                }
                
                do{

                    let infomodelObjects = try JSONDecoder().decode([ImageModelElement].self, from: data)
                    
                    print(infomodelObjects.count)
                    XCTAssertEqual(infomodelObjects.count, 993)
                    
                    let repo = try XCTUnwrap(infomodelObjects.first)

                        XCTAssertEqual(repo.id, 1)
                        XCTAssertEqual(repo.filename, "0.jpeg")
                        XCTAssertEqual(repo.author, "Alejandro Escamilla")
                    
                }
                catch let jsonErr{
                    print(jsonErr.localizedDescription)
                    
                    
                }
            }
            
            XCTAssertNotNil(actualData)
        }

}
