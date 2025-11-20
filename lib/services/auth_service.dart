import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Read client ID
  final String _clientId = dotenv.env['WIKIMEDIA_CLIENT_ID']!;
  final String _redirectUrl = 'com.blogspot.wikikamus:/oauth2/callback';

  // Wikimedia endpoints
  final String _authorizationEndpoint = 'https://meta.wikimedia.org/w/rest.php/oauth2/authorize';
  final String _tokenEndpoint = 'https://meta.wikimedia.org/w/rest.php/oauth2/access_token';

  // Scopes
  final List<String> _scopes = ['editpage', 'read'];

  Future<void> login() async {
    try {
      // Request authorization and exchange for a token
      final AuthorizationTokenResponse? result =
      await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUrl,
          serviceConfiguration: AuthorizationServiceConfiguration(
            authorizationEndpoint: _authorizationEndpoint,
            tokenEndpoint: _tokenEndpoint,
          ),
          scopes: _scopes,
          // preferEphemeralSession: true,
        ),
      );

      // 2. Store the tokens securely
      if (result != null) {
        await _storage.write(key: 'access_token', value: result.accessToken);
        await _storage.write(key: 'refresh_token', value: result.refreshToken);
        await _storage.write(key: 'id_token', value: result.idToken);
        await _storage.write(
            key: 'token_expiry',
            value: result.accessTokenExpirationDateTime!.toIso8601String());
      }
    } catch (e) {
      print('Login Error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    // Add call the token revocation endpoint later
    await _storage.deleteAll();
  }

  Future<bool> isLoggedIn() async {
    final accessToken = await getValidAccessToken();
    return accessToken != null;
  }

  // Checks for expiry and refreshes the token if needed
  Future<String?> getValidAccessToken() async {
    final accessToken = await _storage.read(key: 'access_token');
    final refreshToken = await _storage.read(key: 'refresh_token');
    final tokenExpiry = await _storage.read(key: 'token_expiry');

    if (accessToken == null || refreshToken == null || tokenExpiry == null) {
      return null;
    }

    // Check if the token is expired or close to expiring
    final expiryDate = DateTime.parse(tokenExpiry);
    if (DateTime.now().isAfter(expiryDate.subtract(const Duration(minutes: 5)))) {
      // Token is expired, try to refresh
      try {
        final TokenResponse? result = await _appAuth.token(
          TokenRequest(
            _clientId,
            _redirectUrl,
            refreshToken: refreshToken,
            serviceConfiguration: AuthorizationServiceConfiguration(
              authorizationEndpoint: _authorizationEndpoint,
              tokenEndpoint: _tokenEndpoint,
            ),
            scopes: _scopes,
          ),
        );

        if (result != null) {
          // Store the new tokens
          await _storage.write(key: 'access_token', value: result.accessToken);
          // Note: A new refresh token might not always be issued.
          // Only update it if the response contains a new one.
          if (result.refreshToken != null) {
            await _storage.write(key: 'refresh_token', value: result.refreshToken);
          }
          await _storage.write(
              key: 'token_expiry',
              value: result.accessTokenExpirationDateTime!.toIso8601String());
          return result.accessToken;
        } else {
          // Refresh failed, log the user out
          await logout();
          return null;
        }
      } catch (e) {
        print('Error refreshing token: $e');
        await logout();
        return null;
      }
    }

    return accessToken;
  }
}
