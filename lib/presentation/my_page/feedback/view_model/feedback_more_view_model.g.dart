// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_more_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feedbackMoreViewModelHash() =>
    r'fe1a85b6e93c619866a717c44e56ab2be74f475c';

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

abstract class _$FeedbackMoreViewModel
    extends BuildlessAutoDisposeNotifier<FeedbackMoreState> {
  late final FeedbackType type;

  FeedbackMoreState build(
    FeedbackType type,
  );
}

/// See also [FeedbackMoreViewModel].
@ProviderFor(FeedbackMoreViewModel)
const feedbackMoreViewModelProvider = FeedbackMoreViewModelFamily();

/// See also [FeedbackMoreViewModel].
class FeedbackMoreViewModelFamily extends Family<FeedbackMoreState> {
  /// See also [FeedbackMoreViewModel].
  const FeedbackMoreViewModelFamily();

  /// See also [FeedbackMoreViewModel].
  FeedbackMoreViewModelProvider call(
    FeedbackType type,
  ) {
    return FeedbackMoreViewModelProvider(
      type,
    );
  }

  @override
  FeedbackMoreViewModelProvider getProviderOverride(
    covariant FeedbackMoreViewModelProvider provider,
  ) {
    return call(
      provider.type,
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
  String? get name => r'feedbackMoreViewModelProvider';
}

/// See also [FeedbackMoreViewModel].
class FeedbackMoreViewModelProvider extends AutoDisposeNotifierProviderImpl<
    FeedbackMoreViewModel, FeedbackMoreState> {
  /// See also [FeedbackMoreViewModel].
  FeedbackMoreViewModelProvider(
    FeedbackType type,
  ) : this._internal(
          () => FeedbackMoreViewModel()..type = type,
          from: feedbackMoreViewModelProvider,
          name: r'feedbackMoreViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$feedbackMoreViewModelHash,
          dependencies: FeedbackMoreViewModelFamily._dependencies,
          allTransitiveDependencies:
              FeedbackMoreViewModelFamily._allTransitiveDependencies,
          type: type,
        );

  FeedbackMoreViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final FeedbackType type;

  @override
  FeedbackMoreState runNotifierBuild(
    covariant FeedbackMoreViewModel notifier,
  ) {
    return notifier.build(
      type,
    );
  }

  @override
  Override overrideWith(FeedbackMoreViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: FeedbackMoreViewModelProvider._internal(
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
  AutoDisposeNotifierProviderElement<FeedbackMoreViewModel, FeedbackMoreState>
      createElement() {
    return _FeedbackMoreViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FeedbackMoreViewModelProvider && other.type == type;
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
mixin FeedbackMoreViewModelRef
    on AutoDisposeNotifierProviderRef<FeedbackMoreState> {
  /// The parameter `type` of this provider.
  FeedbackType get type;
}

class _FeedbackMoreViewModelProviderElement
    extends AutoDisposeNotifierProviderElement<FeedbackMoreViewModel,
        FeedbackMoreState> with FeedbackMoreViewModelRef {
  _FeedbackMoreViewModelProviderElement(super.provider);

  @override
  FeedbackType get type => (origin as FeedbackMoreViewModelProvider).type;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
