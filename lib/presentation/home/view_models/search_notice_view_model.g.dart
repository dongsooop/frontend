// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_notice_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchNoticeViewModelHash() =>
    r'fa2abd56e1043ba60530604523bc6dc208709b67';

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

abstract class _$SearchNoticeViewModel
    extends BuildlessAutoDisposeNotifier<SearchNoticeState> {
  late final NoticeTab tab;
  late final String? departmentName;

  SearchNoticeState build({
    required NoticeTab tab,
    String? departmentName,
  });
}

/// See also [SearchNoticeViewModel].
@ProviderFor(SearchNoticeViewModel)
const searchNoticeViewModelProvider = SearchNoticeViewModelFamily();

/// See also [SearchNoticeViewModel].
class SearchNoticeViewModelFamily extends Family<SearchNoticeState> {
  /// See also [SearchNoticeViewModel].
  const SearchNoticeViewModelFamily();

  /// See also [SearchNoticeViewModel].
  SearchNoticeViewModelProvider call({
    required NoticeTab tab,
    String? departmentName,
  }) {
    return SearchNoticeViewModelProvider(
      tab: tab,
      departmentName: departmentName,
    );
  }

  @override
  SearchNoticeViewModelProvider getProviderOverride(
    covariant SearchNoticeViewModelProvider provider,
  ) {
    return call(
      tab: provider.tab,
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
  String? get name => r'searchNoticeViewModelProvider';
}

/// See also [SearchNoticeViewModel].
class SearchNoticeViewModelProvider extends AutoDisposeNotifierProviderImpl<
    SearchNoticeViewModel, SearchNoticeState> {
  /// See also [SearchNoticeViewModel].
  SearchNoticeViewModelProvider({
    required NoticeTab tab,
    String? departmentName,
  }) : this._internal(
          () => SearchNoticeViewModel()
            ..tab = tab
            ..departmentName = departmentName,
          from: searchNoticeViewModelProvider,
          name: r'searchNoticeViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchNoticeViewModelHash,
          dependencies: SearchNoticeViewModelFamily._dependencies,
          allTransitiveDependencies:
              SearchNoticeViewModelFamily._allTransitiveDependencies,
          tab: tab,
          departmentName: departmentName,
        );

  SearchNoticeViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tab,
    required this.departmentName,
  }) : super.internal();

  final NoticeTab tab;
  final String? departmentName;

  @override
  SearchNoticeState runNotifierBuild(
    covariant SearchNoticeViewModel notifier,
  ) {
    return notifier.build(
      tab: tab,
      departmentName: departmentName,
    );
  }

  @override
  Override overrideWith(SearchNoticeViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: SearchNoticeViewModelProvider._internal(
        () => create()
          ..tab = tab
          ..departmentName = departmentName,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tab: tab,
        departmentName: departmentName,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SearchNoticeViewModel, SearchNoticeState>
      createElement() {
    return _SearchNoticeViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchNoticeViewModelProvider &&
        other.tab == tab &&
        other.departmentName == departmentName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tab.hashCode);
    hash = _SystemHash.combine(hash, departmentName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchNoticeViewModelRef
    on AutoDisposeNotifierProviderRef<SearchNoticeState> {
  /// The parameter `tab` of this provider.
  NoticeTab get tab;

  /// The parameter `departmentName` of this provider.
  String? get departmentName;
}

class _SearchNoticeViewModelProviderElement
    extends AutoDisposeNotifierProviderElement<SearchNoticeViewModel,
        SearchNoticeState> with SearchNoticeViewModelRef {
  _SearchNoticeViewModelProviderElement(super.provider);

  @override
  NoticeTab get tab => (origin as SearchNoticeViewModelProvider).tab;
  @override
  String? get departmentName =>
      (origin as SearchNoticeViewModelProvider).departmentName;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
