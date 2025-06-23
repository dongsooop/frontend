// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruit_detail_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recruitDetailViewModelHash() =>
    r'd0f56b8b3a80b13a1a6171c09f9b86f65dc0fbfc';

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

abstract class _$RecruitDetailViewModel
    extends BuildlessAutoDisposeAsyncNotifier<RecruitDetailState> {
  late final RecruitDetailArgs args;

  FutureOr<RecruitDetailState> build(
    RecruitDetailArgs args,
  );
}

/// See also [RecruitDetailViewModel].
@ProviderFor(RecruitDetailViewModel)
const recruitDetailViewModelProvider = RecruitDetailViewModelFamily();

/// See also [RecruitDetailViewModel].
class RecruitDetailViewModelFamily
    extends Family<AsyncValue<RecruitDetailState>> {
  /// See also [RecruitDetailViewModel].
  const RecruitDetailViewModelFamily();

  /// See also [RecruitDetailViewModel].
  RecruitDetailViewModelProvider call(
    RecruitDetailArgs args,
  ) {
    return RecruitDetailViewModelProvider(
      args,
    );
  }

  @override
  RecruitDetailViewModelProvider getProviderOverride(
    covariant RecruitDetailViewModelProvider provider,
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
  String? get name => r'recruitDetailViewModelProvider';
}

/// See also [RecruitDetailViewModel].
class RecruitDetailViewModelProvider
    extends AutoDisposeAsyncNotifierProviderImpl<RecruitDetailViewModel,
        RecruitDetailState> {
  /// See also [RecruitDetailViewModel].
  RecruitDetailViewModelProvider(
    RecruitDetailArgs args,
  ) : this._internal(
          () => RecruitDetailViewModel()..args = args,
          from: recruitDetailViewModelProvider,
          name: r'recruitDetailViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recruitDetailViewModelHash,
          dependencies: RecruitDetailViewModelFamily._dependencies,
          allTransitiveDependencies:
              RecruitDetailViewModelFamily._allTransitiveDependencies,
          args: args,
        );

  RecruitDetailViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.args,
  }) : super.internal();

  final RecruitDetailArgs args;

  @override
  FutureOr<RecruitDetailState> runNotifierBuild(
    covariant RecruitDetailViewModel notifier,
  ) {
    return notifier.build(
      args,
    );
  }

  @override
  Override overrideWith(RecruitDetailViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: RecruitDetailViewModelProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<RecruitDetailViewModel,
      RecruitDetailState> createElement() {
    return _RecruitDetailViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecruitDetailViewModelProvider && other.args == args;
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
mixin RecruitDetailViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<RecruitDetailState> {
  /// The parameter `args` of this provider.
  RecruitDetailArgs get args;
}

class _RecruitDetailViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<RecruitDetailViewModel,
        RecruitDetailState> with RecruitDetailViewModelRef {
  _RecruitDetailViewModelProviderElement(super.provider);

  @override
  RecruitDetailArgs get args => (origin as RecruitDetailViewModelProvider).args;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
