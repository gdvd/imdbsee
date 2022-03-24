//
//  imdbseeTests.swift
//  imdbseeTests
//
//  Created by Gilles David on 07/03/2022.
//

import XCTest
@testable import imdbsee

class DownloadManagerTestCase: XCTestCase {
    
    //MARK: - Search Video(Film/Tv)
    
    //MARK: - Request Video(Film/Tv)
    
    //MARK: - Image
    
    func testDownloadImageWhenStatusCodeErrorShouldGetFailure(){
        // Given
        let download = DownloadManager(session: URLSessionFake(data: FakeResponseData.dataImg, response: FakeResponseData.responseKO, error: nil))
        
        // When
        let url = "https://openclassrooms.com"
                
        // Then
        download.downloadImage(url: url) {
            responseNetwork in
            switch responseNetwork {
            case .Success(response: let dataNetwork):
                XCTAssert(false)
            case .Failure(failure: let error):
                switch error {
                case .returnNil:
                    XCTAssert(false)
                case .statusCodeWrong:
                    XCTAssert(true)
                case .returnZero:
                    XCTAssert(false)
                case .decodeError:
                    XCTAssert(false)
                case .messageError(msg: let msg):
                    XCTAssert(false)
                }
            }
        }
    }
        
    func testDownloadImageWhenErrorShouldGetFailure(){
        // Given
        let download = DownloadManager(session: URLSessionFake(data: FakeResponseData.dataImg, response: FakeResponseData.responseOK, error: FakeResponseData.DownloadError.init()))
        
        // When
        let url = "https://openclassrooms.com"
                
        // Then
        download.downloadImage(url: url) {
            responseNetwork in
            switch responseNetwork {
            case .Success(response: let dataNetwork):
                XCTAssert(false)
            case .Failure(failure: let error):
                switch error {
                case .returnNil:
                    XCTAssert(true)
                case .statusCodeWrong:
                    XCTAssert(false)
                case .returnZero:
                    XCTAssert(false)
                case .decodeError:
                    XCTAssert(false)
                case .messageError(msg: let msg):
                    XCTAssert(false)
                }
            }
        }
    }

    func testDownloadImageWhenCorrectShouldGetSuccess(){
        // Given
        let download = DownloadManager(session: URLSessionFake(data: FakeResponseData.dataImg, response: FakeResponseData.responseOK, error: nil))
        
        // When
        let url = "https://openclassrooms.com"
        
        // Data expect
        let data = UIImage(named: "filmByDefault")?.pngData()
        
        // Then
        download.downloadImage(url: url) {
            responseNetwork in
            switch responseNetwork {
            case .Success(response: let dataNetwork):
                XCTAssertEqual(data, dataNetwork)
            case .Failure(failure: _):
                XCTAssert(false)
            }
        }
    }
    
    //MARK: - Youtube
    
    func testDownloadInfoYoutubeWhenDataIncorrectShouldGetFailed() {
        // Given
        let download = DownloadManager(session: URLSessionFake(data: FakeResponseData.downloadIncorrectData, response: FakeResponseData.responseOK, error: nil))
        
        // When
        let url = "https://openclassrooms.com"
        
        // Data expect
        let responseYoutubeTitle = "Inception"
        let responseYoutubeUrl = "https://www.youtube.com/watch?v=Jvurpf91omw"
        
        // Then
        download.downloadInfoYoutube(url: url) { 
            networkresponse in
            switch networkresponse {
            case .Success(response: let response):
                XCTAssertNotEqual(responseYoutubeTitle, response.title)
                XCTAssertNotEqual(responseYoutubeUrl, response.videoUrl)
            case .Failure(failure: let error):
                switch error {
                case .returnZero:
                    XCTAssert(false)
                case .statusCodeWrong:
                    XCTAssert(false)
                case .decodeError:
                    XCTAssert(true)
                case .messageError(_):
                    XCTAssert(false)
                case .returnNil:
                    XCTAssert(false)
                }
            }
        }
    }
    func testDownloadInfoYoutubeWhenResponseErrorShouldGetFailed() {
        // Given
        let download = DownloadManager(session: URLSessionFake(data: FakeResponseData.downloadCorrectDataYoutube, response: FakeResponseData.responseOK, error: FakeResponseData.DownloadError.init()))
        
        // When
        let url = "https://openclassrooms.com"
        
        // Data expect
        let responseYoutubeTitle = "Inception"
        let responseYoutubeUrl = "https://www.youtube.com/watch?v=Jvurpf91omw"
        
        //Then
        download.downloadInfoYoutube(url: url) { 
            networkresponse in
            switch networkresponse {
            case .Success(response: let response):
                XCTAssertNotEqual(responseYoutubeTitle, response.title)
                XCTAssertNotEqual(responseYoutubeUrl, response.videoUrl)
            case .Failure(failure: let error):
                switch error {
                case .returnZero:
                    XCTAssert(false)
                case .statusCodeWrong:
                    XCTAssert(false)
                case .decodeError:
                    XCTAssert(false)
                case .messageError(_):
                    XCTAssert(false)
                case .returnNil:
                    XCTAssert(true)
                }
            }
        }
    }
    func testDownloadInfoYoutubeWhenDataKOShouldGetFailed() {
        // Given
        let download = DownloadManager(session: URLSessionFake(data: FakeResponseData.downloadCorrectDataYoutube, response: FakeResponseData.responseKO, error: nil))
        
        // When
        let url = "https://openclassrooms.com"
        
        // Data expect
        let responseYoutubeTitle = "Inception"
        let responseYoutubeUrl = "https://www.youtube.com/watch?v=Jvurpf91omw"
        
        //Then
        download.downloadInfoYoutube(url: url) { 
            networkresponse in
            switch networkresponse {
            case .Success(response: let response):
                XCTAssertNotEqual(responseYoutubeTitle, response.title)
                XCTAssertNotEqual(responseYoutubeUrl, response.videoUrl)
            case .Failure(failure: let error):
                switch error {
                case .returnZero:
                    XCTAssert(false)
                case .statusCodeWrong:
                    XCTAssert(true)
                case .decodeError:
                    XCTAssert(false)
                case .messageError(_):
                    XCTAssert(false)
                case .returnNil:
                    XCTAssert(false)
                }
            }
        }
    }
    func testDownloadInfoYoutubeWhenDataOkShouldGetSuccess() {
        // Given
        let download = DownloadManager(session: URLSessionFake(data: FakeResponseData.downloadCorrectDataYoutube, response: FakeResponseData.responseOK, error: nil))
        
        // When
        let url = "https://openclassrooms.com"
        
        // Data expect
        let responseYoutubeTitle = "Inception"
        let responseYoutubeUrl = "https://www.youtube.com/watch?v=Jvurpf91omw"
        
        //Then
        download.downloadInfoYoutube(url: url) { 
            networkresponse in
            switch networkresponse {
            case .Success(response: let response):
                XCTAssertEqual(responseYoutubeTitle, response.title)
                XCTAssertEqual(responseYoutubeUrl, response.videoUrl)
            case .Failure(failure: let error):
                switch error {
                case .returnZero:
                    XCTAssert(false)
                case .statusCodeWrong:
                    XCTAssert(false)
                case .decodeError:
                    XCTAssert(false)
                case .messageError(_):
                    XCTAssert(false)
                case .returnNil:
                    XCTAssert(false)
                }
            }
        }
    }

    
    //MARK: - Wikipedia
    func testDownloadInfoWikiWhenIncorrectDataErrorShouldGetFailure() {
        // Given
        let download = DownloadManager(session: URLSessionFake(data: FakeResponseData.downloadIncorrectData, response: FakeResponseData.responseOK, error: nil))
        
        //When
        let url = "https://openclassrooms.com"
        let responseWikiTitle = "Inception"
        
        //Then
        download.downloadInfoWiki(url: url) { 
            networkresponse in
            switch networkresponse {
            case .Success(response: let response):
                XCTAssertNotEqual(responseWikiTitle, response.title)
            case .Failure(failure: let error):
                switch error {
                case .returnZero:
                    XCTAssert(false)
                case .statusCodeWrong:
                    XCTAssert(false)
                case .decodeError:
                    XCTAssert(true)
                case .messageError(_):
                    XCTAssert(false)
                case .returnNil:
                    XCTAssert(true)
                }
            }
        }
    }
    
    func testDownloadInfoWikiWhenResponseErrorShouldGetFailure() {
        // Given
        let download = DownloadManager(session: URLSessionFake(data: FakeResponseData.downloadCorrectDataWiki, response: FakeResponseData.responseOK, error: FakeResponseData.DownloadError.init()))
        
        //When
        let url = "https://openclassrooms.com"
        let responseWikiTitle = "Inception"
        
        //Then
        download.downloadInfoWiki(url: url) { 
            networkresponse in
            switch networkresponse {
            case .Success(response: let response):
                XCTAssertNotEqual(responseWikiTitle, response.title)
            case .Failure(failure: let error):
                switch error {
                case .returnZero:
                    XCTAssert(false)
                case .statusCodeWrong:
                    XCTAssert(false)
                case .decodeError:
                    XCTAssert(false)
                case .messageError(_):
                    XCTAssert(false)
                case .returnNil:
                    XCTAssert(true)
                }
            }
        }
    }
    
    func testDownloadInfoWikiWhenDataKoShouldGetFailure() {
        // Given
        let download = DownloadManager(session: URLSessionFake(data: FakeResponseData.downloadCorrectDataWiki, response: FakeResponseData.responseKO, error: nil))
        
        //When
        let url = "https://openclassrooms.com"
        
        let responseWikiTitle = "Inception"
        
        //Then
        download.downloadInfoWiki(url: url) { 
            networkresponse in
            switch networkresponse {
            case .Success(response: let response):
                XCTAssertNotEqual(responseWikiTitle, response.title)
            case .Failure(failure: let error):
                switch error {
                case .returnZero:
                    XCTAssert(false)
                case .statusCodeWrong:
                    XCTAssert(true)
                case .decodeError:
                    XCTAssert(false)
                case .messageError(_):
                    XCTAssert(false)
                case .returnNil:
                    XCTAssert(false)
                }
            }
        }
    }
    
    func testDownloadInfoWikiWhenDataOkShouldGetSuccess() {
        // Given
        let download = DownloadManager(session: URLSessionFake(data: FakeResponseData.downloadCorrectDataWiki, response: FakeResponseData.responseOK, error: nil))
        
        //When
        let url = "https://openclassrooms.com"
        
        // Data expect
        let responseWikiTitle = "Inception"
        let responseWikiBeginWith = "Inception is a 2010"
        
        //Then
        download.downloadInfoWiki(url: url) { 
            networkresponse in
            switch networkresponse {
            case .Success(response: let response):
                XCTAssertEqual(responseWikiTitle, response.title)
                XCTAssertTrue(response.plotShort!.plainText!.starts(with: responseWikiBeginWith))
            case .Failure(failure: let error):
                switch error {
                case .returnZero:
                    XCTAssert(false)
                case .statusCodeWrong:
                    XCTAssert(false)
                case .decodeError:
                    XCTAssert(false)
                case .messageError(_):
                    XCTAssert(false)
                case .returnNil:
                    XCTAssert(false)
                }
            }
        }
    }
    
}
