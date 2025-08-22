// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_detail_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$marketDetailViewModelHash() =>
    r'c64e09f13a24dc7b1b0956700f20549005d48ab9';

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

abstract class _$MarketDetailViewModel
    extends BuildlessAutoDisposeAsyncNotifier<MarketDetailState> {
  late final MarketDetailArgs args;

  FutureOr<MarketDetailState> build(
    MarketDetailArgs args,
  );
}

/// See also [MarketDetailViewModel].
@ProviderFor(MarketDetailViewModel)
const marketDetailViewModelProvider = MarketDetailViewModelFamily();

/// See also [MarketDetailViewModel].
class MarketDetailViewModelFamily
    extends Family<AsyncValue<MarketDetailState>> {
  /// See also [MarketDetailViewModel].
  const MarketDetailViewModelFamily();

  /// See also [MarketDetailViewModel].
  MarketDetailViewModelProvider call(
    MarketDetailArgs args,
  ) {
    return MarketDetailViewModelProvider(
      args,
    );
  }

  @override
  MarketDetailViewModelProvider getProviderOverride(
    covariant MarketDetailViewModelProvider provider,
  ) {
    return call(
      provider.args,
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
  String? get name => r'marketDetailViewModelProvider';
}

/// See also [MarketDetailViewModel].
class MarketDetailViewModelProvider
    extends AutoDisposeAsyncNotifierProviderImpl<MarketDetailViewModel,
        MarketDetailState> {
  /// See also [MarketDetailViewModel].
  MarketDetailViewModelProvider(
    MarketDetailArgs args,
  ) : this._internal(
          () => MarketDetailViewModel()..args = args,
          from: marketDetailViewModelProvider,
          name: r'marketDetailViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$marketDetailViewModelHash,
          dependencies: MarketDetailViewModelFamily._dependencies,
          allTransitiveDependencies:
              MarketDetailViewModelFamily._allTransitiveDependencies,
          args: args,
        );

  MarketDetailViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.args,
  }) : super.internal();

  final MarketDetailArgs args;

  @override
  FutureOr<MarketDetailState> runNotifierBuild(
    covariant MarketDetailViewModel notifier,
  ) {
    return notifier.build(
      args,
    );
  }

  @override
  Override overrideWith(MarketDetailViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: MarketDetailViewModelProvider._internal(
        () => create()..args = args,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        args: args,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MarketDetailViewModel,
      MarketDetailState> createElement() {
    return _MarketDetailViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MarketDetailViewModelProvider && other.args == args;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, args.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MarketDetailViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<MarketDetailState> {
  /// The parameter `args` of this provider.
  MarketDetailArgs get args;
}

class _MarketDetailViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MarketDetailViewModel,
        MarketDetailState> with MarketDetailViewModelRef {
  _MarketDetailViewModelProviderElement(super.provider);

  @override
  MarketDetailArgs get args => (origin as MarketDetailViewModelProvider).args;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
