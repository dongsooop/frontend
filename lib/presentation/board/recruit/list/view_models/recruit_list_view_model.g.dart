// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruit_list_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recruitListViewModelHash() =>
    r'089dbcb40ff610af1eaf9f9a9491f15e756806a7';

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

abstract class _$RecruitListViewModel
    extends BuildlessAutoDisposeNotifier<RecruitListState> {
  late final RecruitType type;
  late final String departmentCode;

  RecruitListState build({
    required RecruitType type,
    required String departmentCode,
  });
}

/// See also [RecruitListViewModel].
@ProviderFor(RecruitListViewModel)
const recruitListViewModelProvider = RecruitListViewModelFamily();

/// See also [RecruitListViewModel].
class RecruitListViewModelFamily extends Family<RecruitListState> {
  /// See also [RecruitListViewModel].
  const RecruitListViewModelFamily();

  /// See also [RecruitListViewModel].
  RecruitListViewModelProvider call({
    required RecruitType type,
    required String departmentCode,
  }) {
    return RecruitListViewModelProvider(
      type: type,
      departmentCode: departmentCode,
    );
  }

  @override
  RecruitListViewModelProvider getProviderOverride(
    covariant RecruitListViewModelProvider provider,
  ) {
    return call(
      type: provider.type,
      departmentCode: provider.departmentCode,
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
  String? get name => r'recruitListViewModelProvider';
}

/// See also [RecruitListViewModel].
class RecruitListViewModelProvider extends AutoDisposeNotifierProviderImpl<
    RecruitListViewModel, RecruitListState> {
  /// See also [RecruitListViewModel].
  RecruitListViewModelProvider({
    required RecruitType type,
    required String departmentCode,
  }) : this._internal(
          () => RecruitListViewModel()
            ..type = type
            ..departmentCode = departmentCode,
          from: recruitListViewModelProvider,
          name: r'recruitListViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recruitListViewModelHash,
          dependencies: RecruitListViewModelFamily._dependencies,
          allTransitiveDependencies:
              RecruitListViewModelFamily._allTransitiveDependencies,
          type: type,
          departmentCode: departmentCode,
        );

  RecruitListViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
    required this.departmentCode,
  }) : super.internal();

  final RecruitType type;
  final String departmentCode;

  @override
  RecruitListState runNotifierBuild(
    covariant RecruitListViewModel notifier,
  ) {
    return notifier.build(
      type: type,
      departmentCode: departmentCode,
    );
  }

  @override
  Override overrideWith(RecruitListViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: RecruitListViewModelProvider._internal(
        () => create()
          ..type = type
          ..departmentCode = departmentCode,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
        departmentCode: departmentCode,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<RecruitListViewModel, RecruitListState>
      createElement() {
    return _RecruitListViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecruitListViewModelProvider &&
        other.type == type &&
        other.departmentCode == departmentCode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);
    hash = _SystemHash.combine(hash, departmentCode.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecruitListViewModelRef
    on AutoDisposeNotifierProviderRef<RecruitListState> {
  /// The parameter `type` of this provider.
  RecruitType get type;

  /// The parameter `departmentCode` of this provider.
  String get departmentCode;
}

class _RecruitListViewModelProviderElement
    extends AutoDisposeNotifierProviderElement<RecruitListViewModel,
        RecruitListState> with RecruitListViewModelRef {
  _RecruitListViewModelProviderElement(super.provider);

  @override
  RecruitType get type => (origin as RecruitListViewModelProvider).type;
  @override
  String get departmentCode =>
      (origin as RecruitListViewModelProvider).departmentCode;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
