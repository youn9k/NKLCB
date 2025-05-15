import Foundation
import Alamofire

final class NetworkLogger: EventMonitor {
    func requestDidResume(_ request: Request) {
        guard let httpRequest = request.request else {
            print("유효하지 않은 요청 \(request.description)")
            return
        }
        let url = httpRequest.description
        let method = httpRequest.httpMethod ?? "unknown method"
        
        print("🛜 [Request]")
        print("URL: \(url)")
        print("Method: \(method)")
        if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
            print("Headers: \(headers)")
        }
        if let body = httpRequest.httpBody,
           let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
            print("Body: \(bodyString)")
        }
    }

    func request<Value>(
        _ request: DataRequest,
        didParseResponse response: DataResponse<Value, AFError>
    ) {
        guard let request = response.request else {
            print("유효하지 않은 요청 \(response.description)")
            return
        }
        let url = request.url?.absoluteString ?? "nil"
        let statusCode = response.response?.statusCode ?? -999

        print("🌐 [Response]")
        print("URL: \(url)")
        print("Status Code: \(statusCode)")

        if let data = response.data,
           let json = String(data: data, encoding: .utf8) {
            print("Body Length:\n\(json.count)")
        }
    }
}
