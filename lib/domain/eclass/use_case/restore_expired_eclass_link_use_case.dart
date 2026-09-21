import 'package:dongsoop/core/exception/eclass_exception.dart';
import 'package:dongsoop/domain/eclass/enum/eclass_link_restore_result.dart';
import 'package:dongsoop/domain/eclass/enum/eclass_link_status.dart';
import 'package:dongsoop/domain/eclass/repository/eclass_credentials_repository.dart';
import 'package:dongsoop/domain/eclass/repository/eclass_link_repository.dart';

class RestoreExpiredEclassLinkUseCase {
  final EclassLinkRepository _linkRepository;
  final EclassCredentialsRepository _credentialsRepository;

  RestoreExpiredEclassLinkUseCase(
    this._linkRepository,
    this._credentialsRepository,
  );

  Future<EclassLinkRestoreResult> execute({
    String? fid,
    String? deviceToken,
  }) async {
    final currentLink = await _linkRepository.getLink(
      fid: fid,
      deviceToken: deviceToken,
    );

    if (!currentLink.linked) {
      return EclassLinkRestoreResult.unlinked;
    }
    if (currentLink.status == EclassLinkStatus.active) {
      return EclassLinkRestoreResult.alreadyActive;
    }
    if (currentLink.status != EclassLinkStatus.expired) {
      throw const EclassMalformedResponseException(
        'Eclass 연동 상태를 확인할 수 없습니다.',
      );
    }

    final credentials = await _credentialsRepository.read();
    if (credentials == null) {
      return EclassLinkRestoreResult.credentialsMissing;
    }

    try {
      final restoredLink = await _linkRepository.link(
        credentials: credentials,
        fid: fid,
        deviceToken: deviceToken,
      );
      if (!restoredLink.linked ||
          restoredLink.status != EclassLinkStatus.active) {
        throw const EclassMalformedResponseException(
          'Eclass 자동 재연동 결과를 확인할 수 없습니다.',
        );
      }
      return EclassLinkRestoreResult.restored;
    } on EclassInvalidCredentialsException {
      try {
        await _credentialsRepository.delete();
        return EclassLinkRestoreResult.invalidCredentials;
      } on EclassCredentialsStorageException {
        return EclassLinkRestoreResult.invalidCredentialsCleanupFailed;
      }
    }
  }
}
