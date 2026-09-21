import 'package:dongsoop/core/exception/eclass_exception.dart';
import 'package:dongsoop/data/eclass/data_source/eclass_link_data_source.dart';
import 'package:dongsoop/data/eclass/data_source/eclass_token_data_source.dart';
import 'package:dongsoop/data/eclass/mapper/eclass_link_mapper.dart';
import 'package:dongsoop/data/eclass/model/eclass_link_request.dart';
import 'package:dongsoop/data/eclass/model/eclass_link_response.dart';
import 'package:dongsoop/domain/eclass/entity/eclass_credentials.dart';
import 'package:dongsoop/domain/eclass/entity/eclass_link_entity.dart';
import 'package:dongsoop/domain/eclass/repository/eclass_link_repository.dart';

class EclassLinkRepositoryImpl implements EclassLinkRepository {
  final EclassTokenDataSource _tokenDataSource;
  final EclassLinkDataSource _linkDataSource;

  EclassLinkRepositoryImpl(
    this._tokenDataSource,
    this._linkDataSource,
  );

  @override
  Future<EclassLinkEntity> link({
    required EclassCredentials credentials,
    String? fid,
    String? deviceToken,
  }) async {
    final tokenResponse = await _tokenDataSource.issueToken(
      eclassId: credentials.eclassId,
      password: credentials.password,
    );
    final linkResponse = await _linkDataSource.link(
      request: EclassLinkRequest(token: tokenResponse.token),
      fid: fid,
      deviceToken: deviceToken,
    );
    return _toEntity(linkResponse);
  }

  @override
  Future<EclassLinkEntity> getLink({
    String? fid,
    String? deviceToken,
  }) async {
    final response = await _linkDataSource.getLink(
      fid: fid,
      deviceToken: deviceToken,
    );
    return _toEntity(response);
  }

  @override
  Future<void> unlink({
    String? fid,
    String? deviceToken,
  }) {
    return _linkDataSource.unlink(
      fid: fid,
      deviceToken: deviceToken,
    );
  }

  EclassLinkEntity _toEntity(EclassLinkResponse response) {
    try {
      return response.toEntity();
    } on FormatException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        EclassMalformedResponseException(error.message),
        stackTrace,
      );
    }
  }
}
