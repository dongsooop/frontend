// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_market_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchMarketViewModelHash() =>
    r'c659609ceaab496efb5daa3c54ffb326f63cf898';

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
    extends BuildlessNotifier<SearchMarketState> {
  late final List<MarketType> types;

  SearchMarketState build({
    required List<MarketType> types,
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
    required List<MarketType> types,
  }) {
    return SearchMarketViewModelProvider(
      types: types,
    );
  }

  @override
  SearchMarketViewModelProvider getProviderOverride(
    covariant SearchMarketViewModelProvider provider,
  ) {
    return call(
      types: provider.types,
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
class SearchMarketViewModelProvider
    extends NotifierProviderImpl<SearchMarketViewModel, SearchMarketState> {
  /// See also [SearchMarketViewModel].
  SearchMarketViewModelProvider({
    required List<MarketType> types,
  }) : this._internal(
          () => SearchMarketViewModel()..types = types,
          from: searchMarketViewModelProvider,
          name: r'searchMarketViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchMarketViewModelHash,
          dependencies: SearchMarketViewModelFamily._dependencies,
          allTransitiveDependencies:
              SearchMarketViewModelFamily._allTransitiveDependencies,
          types: types,
        );

  SearchMarketViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.types,
  }) : super.internal();

  final List<MarketType> types;

  @override
  SearchMarketState runNotifierBuild(
    covariant SearchMarketViewModel notifier,
  ) {
    return notifier.build(
      types: types,
    );
  }

  @override
  Override overrideWith(SearchMarketViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: SearchMarketViewModelProvider._internal(
        () => create()..types = types,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        types: types,
      ),
    );
  }

  @override
  NotifierProviderElement<SearchMarketViewModel, SearchMarketState>
      createElement() {
    return _SearchMarketViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchMarketViewModelProvider && other.types == types;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, types.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchMarketViewModelRef on NotifierProviderRef<SearchMarketState> {
  /// The parameter `types` of this provider.
  List<MarketType> get types;
}

class _SearchMarketViewModelProviderElement
    extends NotifierProviderElement<SearchMarketViewModel, SearchMarketState>
    with SearchMarketViewModelRef {
  _SearchMarketViewModelProviderElement(super.provider);

  @override
  List<MarketType> get types => (origin as SearchMarketViewModelProvider).types;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
