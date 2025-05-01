import Alamofire

final class NetworkService {
    static func request(_ api: API) async -> Result<[Recruit], Error> {
        let url = api.baseURL + "/" + api.path
        let task = AF.request(url, method: api.method, parameters: api.parameters)
            .validate()
            .serializingDecodable([Recruit].self)

        let response = await task.response
        switch response.result {
        case .success(let data): return .success(data)
        case .failure(let error): return .failure(error)
        }
    }
}
