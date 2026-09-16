import 'package:dongsoop/data/eclass/model/eclass_token_response.dart';

abstract class EclassTokenDataSource {
  Future<EclassTokenResponse> issueToken({
    required String eclassId,
    required String password,
  });
}
