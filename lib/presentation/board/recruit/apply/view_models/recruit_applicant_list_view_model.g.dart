// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruit_applicant_list_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recruitApplicantListViewModelHash() =>
    r'4a1253f66de3a609b7f3a41a82dd3777a6fce734';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$RecruitApplicantListViewModel
    extends BuildlessAutoDisposeAsyncNotifier<
        List<RecruitApplicantListEntity>> {
  late final RecruitType type;
  late final int boardId;

  FutureOr<List<RecruitApplicantListEntity>> build({
    required RecruitType type,
    required int boardId,
  });
}

/// See also [RecruitApplicantListViewModel].
@ProviderFor(RecruitApplicantListViewModel)
const recruitApplicantListViewModelProvider =
    RecruitApplicantListViewModelFamily();

/// See also [RecruitApplicantListViewModel].
class RecruitApplicantListViewModelFamily
    extends Family<AsyncValue<List<RecruitApplicantListEntity>>> {
  /// See also [RecruitApplicantListViewModel].
  const RecruitApplicantListViewModelFamily();

  /// See also [RecruitApplicantListViewModel].
  RecruitApplicantListViewModelProvider call({
    required RecruitType type,
    required int boardId,
  }) {
    return RecruitApplicantListViewModelProvider(
      type: type,
      boardId: boardId,
    );
  }

  @override
  RecruitApplicantListViewModelProvider getProviderOverride(
    covariant RecruitApplicantListViewModelProvider provider,
  ) {
    return call(
      type: provider.type,
      boardId: provider.boardId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recruitApplicantListViewModelProvider';
}

/// See also [RecruitApplicantListViewModel].
class RecruitApplicantListViewModelProvider
    extends AutoDisposeAsyncNotifierProviderImpl<RecruitApplicantListViewModel,
        List<RecruitApplicantListEntity>> {
  /// See also [RecruitApplicantListViewModel].
  RecruitApplicantListViewModelProvider({
    required RecruitType type,
    required int boardId,
  }) : this._internal(
          () => RecruitApplicantListViewModel()
            ..type = type
            ..boardId = boardId,
          from: recruitApplicantListViewModelProvider,
          name: r'recruitApplicantListViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recruitApplicantListViewModelHash,
          dependencies: RecruitApplicantListViewModelFamily._dependencies,
          allTransitiveDependencies:
              RecruitApplicantListViewModelFamily._allTransitiveDependencies,
          type: type,
          boardId: boardId,
        );

  RecruitApplicantListViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
    required this.boardId,
  }) : super.internal();

  final RecruitType type;
  final int boardId;

  @override
  FutureOr<List<RecruitApplicantListEntity>> runNotifierBuild(
    covariant RecruitApplicantListViewModel notifier,
  ) {
    return notifier.build(
      type: type,
      boardId: boardId,
    );
  }

  @override
  Override overrideWith(RecruitApplicantListViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: RecruitApplicantListViewModelProvider._internal(
        () => create()
          ..type = type
          ..boardId = boardId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
        boardId: boardId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<RecruitApplicantListViewModel,
      List<RecruitApplicantListEntity>> createElement() {
    return _RecruitApplicantListViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecruitApplicantListViewModelProvider &&
        other.type == type &&
        other.boardId == boardId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);
    hash = _SystemHash.combine(hash, boardId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecruitApplicantListViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<List<RecruitApplicantListEntity>> {
  /// The parameter `type` of this provider.
  RecruitType get type;

  /// The parameter `boardId` of this provider.
  int get boardId;
}

class _RecruitApplicantListViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<
        RecruitApplicantListViewModel, List<RecruitApplicantListEntity>>
    with RecruitApplicantListViewModelRef {
  _RecruitApplicantListViewModelProviderElement(super.provider);

  @override
  RecruitType get type =>
      (origin as RecruitApplicantListViewModelProvider).type;
  @override
  int get boardId => (origin as RecruitApplicantListViewModelProvider).boardId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
