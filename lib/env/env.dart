import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'API_LINK', obfuscate: true)
  static final String apiLink = _Env.apiLink;
}
