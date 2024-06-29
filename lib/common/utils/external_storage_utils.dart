/// JsonSerializable에서 json을 통해 url을 받는 경우 수정해주는 함수
class ExternalStorageUtils {
  /// value : json을 통해 받은 storage endpoint
  static pathToUrl(String value) {
    const String externalIp = 'here'; // 환경 변수로 분리
    return 'https://$externalIp$value';
  }
}