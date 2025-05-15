import Alamofire

final class NetworkService {
    static func request<T: Decodable>(_ api: API, responseType: T.Type = T.self) async -> Result<T, Error> {
        let url = api.baseURL + "/" + api.path
        let task = AF.request(url, method: api.method, parameters: api.parameters)
            .validate()
            .serializingDecodable(responseType)

        let response = await task.response
        switch response.result {
        case .success(let data): return .success(data)
        case .failure(let error): return .failure(error)
        }
    }
}
