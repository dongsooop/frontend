import 'package:dongsoop/domain/eclass/enum/eclass_link_status.dart';

class EclassLinkEntity {
  final bool linked;
  final EclassLinkStatus? status;
  final String? moodleFullname;
  final DateTime? lastSyncedAt;

  const EclassLinkEntity({
    required this.linked,
    required this.status,
    required this.moodleFullname,
    required this.lastSyncedAt,
  });
}
