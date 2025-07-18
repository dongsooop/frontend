// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruit_applicant_detail_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recruitApplicantDetailViewModelHash() =>
    r'65e1bb92ec593ba4750642baa34e67e2b4ce4db0';

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

abstract class _$RecruitApplicantDetailViewModel
    extends BuildlessAutoDisposeAsyncNotifier<RecruitApplicantDetailEntity> {
  late final RecruitApplicantDetailArgs args;

  FutureOr<RecruitApplicantDetailEntity> build(
    RecruitApplicantDetailArgs args,
  );
}

/// See also [RecruitApplicantDetailViewModel].
@ProviderFor(RecruitApplicantDetailViewModel)
const recruitApplicantDetailViewModelProvider =
    RecruitApplicantDetailViewModelFamily();

/// See also [RecruitApplicantDetailViewModel].
class RecruitApplicantDetailViewModelFamily
    extends Family<AsyncValue<RecruitApplicantDetailEntity>> {
  /// See also [RecruitApplicantDetailViewModel].
  const RecruitApplicantDetailViewModelFamily();

  /// See also [RecruitApplicantDetailViewModel].
  RecruitApplicantDetailViewModelProvider call(
    RecruitApplicantDetailArgs args,
  ) {
    return RecruitApplicantDetailViewModelProvider(
      args,
    );
  }

  @override
  RecruitApplicantDetailViewModelProvider getProviderOverride(
    covariant RecruitApplicantDetailViewModelProvider provider,
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
  String? get name => r'recruitApplicantDetailViewModelProvider';
}

/// See also [RecruitApplicantDetailViewModel].
class RecruitApplicantDetailViewModelProvider
    extends AutoDisposeAsyncNotifierProviderImpl<
        RecruitApplicantDetailViewModel, RecruitApplicantDetailEntity> {
  /// See also [RecruitApplicantDetailViewModel].
  RecruitApplicantDetailViewModelProvider(
    RecruitApplicantDetailArgs args,
  ) : this._internal(
          () => RecruitApplicantDetailViewModel()..args = args,
          from: recruitApplicantDetailViewModelProvider,
          name: r'recruitApplicantDetailViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recruitApplicantDetailViewModelHash,
          dependencies: RecruitApplicantDetailViewModelFamily._dependencies,
          allTransitiveDependencies:
              RecruitApplicantDetailViewModelFamily._allTransitiveDependencies,
          args: args,
        );

  RecruitApplicantDetailViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.args,
  }) : super.internal();

  final RecruitApplicantDetailArgs args;

  @override
  FutureOr<RecruitApplicantDetailEntity> runNotifierBuild(
    covariant RecruitApplicantDetailViewModel notifier,
  ) {
    return notifier.build(
      args,
    );
  }

  @override
  Override overrideWith(RecruitApplicantDetailViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: RecruitApplicantDetailViewModelProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<RecruitApplicantDetailViewModel,
      RecruitApplicantDetailEntity> createElement() {
    return _RecruitApplicantDetailViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecruitApplicantDetailViewModelProvider &&
        other.args == args;
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
mixin RecruitApplicantDetailViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<RecruitApplicantDetailEntity> {
  /// The parameter `args` of this provider.
  RecruitApplicantDetailArgs get args;
}

class _RecruitApplicantDetailViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<
        RecruitApplicantDetailViewModel,
        RecruitApplicantDetailEntity> with RecruitApplicantDetailViewModelRef {
  _RecruitApplicantDetailViewModelProviderElement(super.provider);

  @override
  RecruitApplicantDetailArgs get args =>
      (origin as RecruitApplicantDetailViewModelProvider).args;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
