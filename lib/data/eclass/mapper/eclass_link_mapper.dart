import 'package:dongsoop/data/eclass/model/eclass_link_response.dart';
import 'package:dongsoop/domain/eclass/entity/eclass_link_entity.dart';
import 'package:dongsoop/domain/eclass/enum/eclass_link_status.dart';

extension EclassLinkResponseMapper on EclassLinkResponse {
  EclassLinkEntity toEntity() {
    final mappedStatus = mapEclassLinkStatus(status);

    if (linked && mappedStatus == null) {
      throw const FormatException('Linked Eclass response has no status.');
    }
    if (!linked && mappedStatus != null) {
      throw const FormatException('Unlinked Eclass response has a status.');
    }

    final normalizedName = moodleFullname?.trim();
    return EclassLinkEntity(
      linked: linked,
      status: mappedStatus,
      moodleFullname: normalizedName == null || normalizedName.isEmpty
          ? null
          : normalizedName,
      lastSyncedAt: lastSyncedAt,
    );
  }
}

EclassLinkStatus? mapEclassLinkStatus(String? value) {
  switch (value) {
    case null:
      return null;
    case 'ACTIVE':
      return EclassLinkStatus.active;
    case 'EXPIRED':
      return EclassLinkStatus.expired;
    default:
      throw FormatException('Unknown Eclass link status: $value');
  }
}
