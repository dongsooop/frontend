// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_write_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$marketWriteViewModelHash() =>
    r'9523c1104a5d7193160b817fd29852bce8291a14';

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

abstract class _$MarketWriteViewModel
    extends BuildlessAutoDisposeNotifier<MarketFormState> {
  late final bool isEditing;
  late final int? marketId;

  MarketFormState build({
    required bool isEditing,
    int? marketId,
  });
}

/// See also [MarketWriteViewModel].
@ProviderFor(MarketWriteViewModel)
const marketWriteViewModelProvider = MarketWriteViewModelFamily();

/// See also [MarketWriteViewModel].
class MarketWriteViewModelFamily extends Family<MarketFormState> {
  /// See also [MarketWriteViewModel].
  const MarketWriteViewModelFamily();

  /// See also [MarketWriteViewModel].
  MarketWriteViewModelProvider call({
    required bool isEditing,
    int? marketId,
  }) {
    return MarketWriteViewModelProvider(
      isEditing: isEditing,
      marketId: marketId,
    );
  }

  @override
  MarketWriteViewModelProvider getProviderOverride(
    covariant MarketWriteViewModelProvider provider,
  ) {
    return call(
      isEditing: provider.isEditing,
      marketId: provider.marketId,
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
  String? get name => r'marketWriteViewModelProvider';
}

/// See also [MarketWriteViewModel].
class MarketWriteViewModelProvider extends AutoDisposeNotifierProviderImpl<
    MarketWriteViewModel, MarketFormState> {
  /// See also [MarketWriteViewModel].
  MarketWriteViewModelProvider({
    required bool isEditing,
    int? marketId,
  }) : this._internal(
          () => MarketWriteViewModel()
            ..isEditing = isEditing
            ..marketId = marketId,
          from: marketWriteViewModelProvider,
          name: r'marketWriteViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$marketWriteViewModelHash,
          dependencies: MarketWriteViewModelFamily._dependencies,
          allTransitiveDependencies:
              MarketWriteViewModelFamily._allTransitiveDependencies,
          isEditing: isEditing,
          marketId: marketId,
        );

  MarketWriteViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.isEditing,
    required this.marketId,
  }) : super.internal();

  final bool isEditing;
  final int? marketId;

  @override
  MarketFormState runNotifierBuild(
    covariant MarketWriteViewModel notifier,
  ) {
    return notifier.build(
      isEditing: isEditing,
      marketId: marketId,
    );
  }

  @override
  Override overrideWith(MarketWriteViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: MarketWriteViewModelProvider._internal(
        () => create()
          ..isEditing = isEditing
          ..marketId = marketId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        isEditing: isEditing,
        marketId: marketId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<MarketWriteViewModel, MarketFormState>
      createElement() {
    return _MarketWriteViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MarketWriteViewModelProvider &&
        other.isEditing == isEditing &&
        other.marketId == marketId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isEditing.hashCode);
    hash = _SystemHash.combine(hash, marketId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MarketWriteViewModelRef
    on AutoDisposeNotifierProviderRef<MarketFormState> {
  /// The parameter `isEditing` of this provider.
  bool get isEditing;

  /// The parameter `marketId` of this provider.
  int? get marketId;
}

class _MarketWriteViewModelProviderElement
    extends AutoDisposeNotifierProviderElement<MarketWriteViewModel,
        MarketFormState> with MarketWriteViewModelRef {
  _MarketWriteViewModelProviderElement(super.provider);

  @override
  bool get isEditing => (origin as MarketWriteViewModelProvider).isEditing;
  @override
  int? get marketId => (origin as MarketWriteViewModelProvider).marketId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
