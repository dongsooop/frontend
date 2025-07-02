// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_list_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$marketListViewModelHash() =>
    r'5a09d11a8df6bce013bbdfa827bb56f407e961d3';

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

abstract class _$MarketListViewModel
    extends BuildlessAutoDisposeNotifier<MarketListState> {
  late final MarketType type;

  MarketListState build({
    required MarketType type,
  });
}

/// See also [MarketListViewModel].
@ProviderFor(MarketListViewModel)
const marketListViewModelProvider = MarketListViewModelFamily();

/// See also [MarketListViewModel].
class MarketListViewModelFamily extends Family<MarketListState> {
  /// See also [MarketListViewModel].
  const MarketListViewModelFamily();

  /// See also [MarketListViewModel].
  MarketListViewModelProvider call({
    required MarketType type,
  }) {
    return MarketListViewModelProvider(
      type: type,
    );
  }

  @override
  MarketListViewModelProvider getProviderOverride(
    covariant MarketListViewModelProvider provider,
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
  String? get name => r'marketListViewModelProvider';
}

/// See also [MarketListViewModel].
class MarketListViewModelProvider extends AutoDisposeNotifierProviderImpl<
    MarketListViewModel, MarketListState> {
  /// See also [MarketListViewModel].
  MarketListViewModelProvider({
    required MarketType type,
  }) : this._internal(
          () => MarketListViewModel()..type = type,
          from: marketListViewModelProvider,
          name: r'marketListViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$marketListViewModelHash,
          dependencies: MarketListViewModelFamily._dependencies,
          allTransitiveDependencies:
              MarketListViewModelFamily._allTransitiveDependencies,
          type: type,
        );

  MarketListViewModelProvider._internal(
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
  MarketListState runNotifierBuild(
    covariant MarketListViewModel notifier,
  ) {
    return notifier.build(
      type: type,
    );
  }

  @override
  Override overrideWith(MarketListViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: MarketListViewModelProvider._internal(
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
  AutoDisposeNotifierProviderElement<MarketListViewModel, MarketListState>
      createElement() {
    return _MarketListViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MarketListViewModelProvider && other.type == type;
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
mixin MarketListViewModelRef
    on AutoDisposeNotifierProviderRef<MarketListState> {
  /// The parameter `type` of this provider.
  MarketType get type;
}

class _MarketListViewModelProviderElement
    extends AutoDisposeNotifierProviderElement<MarketListViewModel,
        MarketListState> with MarketListViewModelRef {
  _MarketListViewModelProviderElement(super.provider);

  @override
  MarketType get type => (origin as MarketListViewModelProvider).type;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
