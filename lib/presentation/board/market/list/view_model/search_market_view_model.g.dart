// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_market_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchMarketViewModelHash() =>
    r'86b0e4ab9821747914f404a8d989a3a9ada26ef7';

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

abstract class _$SearchMarketViewModel
    extends BuildlessAutoDisposeNotifier<SearchMarketState> {
  late final MarketType type;

  SearchMarketState build({
    required MarketType type,
  });
}

/// See also [SearchMarketViewModel].
@ProviderFor(SearchMarketViewModel)
const searchMarketViewModelProvider = SearchMarketViewModelFamily();

/// See also [SearchMarketViewModel].
class SearchMarketViewModelFamily extends Family<SearchMarketState> {
  /// See also [SearchMarketViewModel].
  const SearchMarketViewModelFamily();

  /// See also [SearchMarketViewModel].
  SearchMarketViewModelProvider call({
    required MarketType type,
  }) {
    return SearchMarketViewModelProvider(
      type: type,
    );
  }

  @override
  SearchMarketViewModelProvider getProviderOverride(
    covariant SearchMarketViewModelProvider provider,
  ) {
    return call(
      type: provider.type,
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
  String? get name => r'searchMarketViewModelProvider';
}

/// See also [SearchMarketViewModel].
class SearchMarketViewModelProvider extends AutoDisposeNotifierProviderImpl<
    SearchMarketViewModel, SearchMarketState> {
  /// See also [SearchMarketViewModel].
  SearchMarketViewModelProvider({
    required MarketType type,
  }) : this._internal(
          () => SearchMarketViewModel()..type = type,
          from: searchMarketViewModelProvider,
          name: r'searchMarketViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchMarketViewModelHash,
          dependencies: SearchMarketViewModelFamily._dependencies,
          allTransitiveDependencies:
              SearchMarketViewModelFamily._allTransitiveDependencies,
          type: type,
        );

  SearchMarketViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final MarketType type;

  @override
  SearchMarketState runNotifierBuild(
    covariant SearchMarketViewModel notifier,
  ) {
    return notifier.build(
      type: type,
    );
  }

  @override
  Override overrideWith(SearchMarketViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: SearchMarketViewModelProvider._internal(
        () => create()..type = type,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SearchMarketViewModel, SearchMarketState>
      createElement() {
    return _SearchMarketViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchMarketViewModelProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchMarketViewModelRef
    on AutoDisposeNotifierProviderRef<SearchMarketState> {
  /// The parameter `type` of this provider.
  MarketType get type;
}

class _SearchMarketViewModelProviderElement
    extends AutoDisposeNotifierProviderElement<SearchMarketViewModel,
        SearchMarketState> with SearchMarketViewModelRef {
  _SearchMarketViewModelProviderElement(super.provider);

  @override
  MarketType get type => (origin as SearchMarketViewModelProvider).type;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
