// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_recruit_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchRecruitViewModelHash() =>
    r'1599308b18835f5518e10e68b38fded90f83be1b';

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

abstract class _$SearchRecruitViewModel
    extends BuildlessNotifier<SearchRecruitState> {
  late final List<RecruitType> types;
  late final String departmentName;

  SearchRecruitState build({
    required List<RecruitType> types,
    required String departmentName,
  });
}

/// See also [SearchRecruitViewModel].
@ProviderFor(SearchRecruitViewModel)
const searchRecruitViewModelProvider = SearchRecruitViewModelFamily();

/// See also [SearchRecruitViewModel].
class SearchRecruitViewModelFamily extends Family<SearchRecruitState> {
  /// See also [SearchRecruitViewModel].
  const SearchRecruitViewModelFamily();

  /// See also [SearchRecruitViewModel].
  SearchRecruitViewModelProvider call({
    required List<RecruitType> types,
    required String departmentName,
  }) {
    return SearchRecruitViewModelProvider(
      types: types,
      departmentName: departmentName,
    );
  }

  @override
  SearchRecruitViewModelProvider getProviderOverride(
    covariant SearchRecruitViewModelProvider provider,
  ) {
    return call(
      types: provider.types,
      departmentName: provider.departmentName,
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
  String? get name => r'searchRecruitViewModelProvider';
}

/// See also [SearchRecruitViewModel].
class SearchRecruitViewModelProvider
    extends NotifierProviderImpl<SearchRecruitViewModel, SearchRecruitState> {
  /// See also [SearchRecruitViewModel].
  SearchRecruitViewModelProvider({
    required List<RecruitType> types,
    required String departmentName,
  }) : this._internal(
          () => SearchRecruitViewModel()
            ..types = types
            ..departmentName = departmentName,
          from: searchRecruitViewModelProvider,
          name: r'searchRecruitViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchRecruitViewModelHash,
          dependencies: SearchRecruitViewModelFamily._dependencies,
          allTransitiveDependencies:
              SearchRecruitViewModelFamily._allTransitiveDependencies,
          types: types,
          departmentName: departmentName,
        );

  SearchRecruitViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.types,
    required this.departmentName,
  }) : super.internal();

  final List<RecruitType> types;
  final String departmentName;

  @override
  SearchRecruitState runNotifierBuild(
    covariant SearchRecruitViewModel notifier,
  ) {
    return notifier.build(
      types: types,
      departmentName: departmentName,
    );
  }

  @override
  Override overrideWith(SearchRecruitViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: SearchRecruitViewModelProvider._internal(
        () => create()
          ..types = types
          ..departmentName = departmentName,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        types: types,
        departmentName: departmentName,
      ),
    );
  }

  @override
  NotifierProviderElement<SearchRecruitViewModel, SearchRecruitState>
      createElement() {
    return _SearchRecruitViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchRecruitViewModelProvider &&
        other.types == types &&
        other.departmentName == departmentName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, types.hashCode);
    hash = _SystemHash.combine(hash, departmentName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchRecruitViewModelRef on NotifierProviderRef<SearchRecruitState> {
  /// The parameter `types` of this provider.
  List<RecruitType> get types;

  /// The parameter `departmentName` of this provider.
  String get departmentName;
}

class _SearchRecruitViewModelProviderElement
    extends NotifierProviderElement<SearchRecruitViewModel, SearchRecruitState>
    with SearchRecruitViewModelRef {
  _SearchRecruitViewModelProviderElement(super.provider);

  @override
  List<RecruitType> get types =>
      (origin as SearchRecruitViewModelProvider).types;
  @override
  String get departmentName =>
      (origin as SearchRecruitViewModelProvider).departmentName;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
