import Alamofire
import Foundation

final class OAuthAuthenticator: Authenticator {
    private let keyChain = KeyChain.shared
    
    func apply(
        _ credential: OAuthCredential,
        to urlRequest: inout URLRequest
    ) {
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
    }
    
    func didRequest(
        _ urlRequest: URLRequest,
        with response: HTTPURLResponse,
        failDueToAuthenticationError error: any Error
    ) -> Bool {
        return response.statusCode == 401
    }
    
    func isRequest(
        _ urlRequest: URLRequest,
        authenticatedWith credential: OAuthCredential
    ) -> Bool {
        let bearerToken = HTTPHeader.authorization(bearerToken: credential.accessToken).value
        return urlRequest.headers["Authorization"] == bearerToken
    }
    
    func refresh(
        _ credential: OAuthCredential,
        for session: Session,
        completion: @escaping (Result<OAuthCredential, any Error>) -> Void
    ) {
        guard !credential.refreshToken.isEmpty else {
            print("🛰 Refresh Token 없음")
            keyChain.delete(type: .accessToken)
            keyChain.delete(type: .refreshToken)
            return
        }
        
        print("🛰 토큰 재발급 시도")
        print("🛰 refresh token: \(credential.refreshToken)")
        let requestDto = TokenRefreshRequestDTO(refreshToken: credential.refreshToken)
        let endpoint = LoginEndpoint.tokenRefresh(body: requestDto)
        let url = endpoint.baseURL.appending(endpoint.path)
        print("🛰 URL: \(url)")
        
        AF.request(
            url,
            method: .patch,
            parameters: requestDto,
            encoder: JSONParameterEncoder()
        ).responseAPI(of: TokenRefreshResponseDTO.self) { result in
            switch result {
            case .success(let tokenData):
                let accessToken = tokenData.accessToken
                let refreshToken = tokenData.refreshToken
                print("🛰 토큰 재발급 성공")
                print("🛰 Access Token: \(accessToken)")
                print("🛰 Refresh Token: \(refreshToken)")
                
                PCKeychainManager.shared.save(.accessToken, value: accessToken)
                PCKeychainManager.shared.save(.refreshToken, value: refreshToken)
                
                // 토큰 만료 시간 파싱
                var expiration = Date(timeIntervalSinceNow: 60 * 60 * 24) // 기본값
                if let claims = tokenData.accessToken.decodeJWT(),
                   let exp = claims["exp"] as? TimeInterval {
                    expiration = Date(timeIntervalSince1970: exp)
                }
                let newCredential = OAuthCredential(
                    accessToken: accessToken,
                    refreshToken: refreshToken,
                    expiration: expiration
                )
                completion(.success(newCredential))
                
            case .failure(let networkError):
                print("🛰 토큰 재발급 실패: \(networkError.errorDescription ?? "알 수 없는 오류")")
                PCKeychainManager.shared.delete(.accessToken)
                PCKeychainManager.shared.delete(.refreshToken)
                completion(.failure(networkError))
            }
        }
    }
}
