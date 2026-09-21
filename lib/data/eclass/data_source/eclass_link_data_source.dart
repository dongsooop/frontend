import 'package:dongsoop/data/eclass/model/eclass_link_request.dart';
import 'package:dongsoop/data/eclass/model/eclass_link_response.dart';

abstract class EclassLinkDataSource {
  Future<EclassLinkResponse> link({
    required EclassLinkRequest request,
    String? fid,
    String? deviceToken,
  });

  Future<EclassLinkResponse> getLink({
    String? fid,
    String? deviceToken,
  });

  Future<void> unlink({
    String? fid,
    String? deviceToken,
  });
}
