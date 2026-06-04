// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeViewModelHash() => r'486a222dcb8cac813d5abd78f716dbcbf8840898';

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

abstract class _$HomeViewModel
    extends BuildlessAutoDisposeAsyncNotifier<HomeEntity> {
  late final String? departmentCode;

  FutureOr<HomeEntity> build({
    required String? departmentCode,
  });
}

/// See also [HomeViewModel].
@ProviderFor(HomeViewModel)
const homeViewModelProvider = HomeViewModelFamily();

/// See also [HomeViewModel].
class HomeViewModelFamily extends Family<AsyncValue<HomeEntity>> {
  /// See also [HomeViewModel].
  const HomeViewModelFamily();

  /// See also [HomeViewModel].
  HomeViewModelProvider call({
    required String? departmentCode,
  }) {
    return HomeViewModelProvider(
      departmentCode: departmentCode,
    );
  }

  @override
  HomeViewModelProvider getProviderOverride(
    covariant HomeViewModelProvider provider,
  ) {
    return call(
      departmentCode: provider.departmentCode,
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
  String? get name => r'homeViewModelProvider';
}

/// See also [HomeViewModel].
class HomeViewModelProvider
    extends AutoDisposeAsyncNotifierProviderImpl<HomeViewModel, HomeEntity> {
  /// See also [HomeViewModel].
  HomeViewModelProvider({
    required String? departmentCode,
  }) : this._internal(
          () => HomeViewModel()..departmentCode = departmentCode,
          from: homeViewModelProvider,
          name: r'homeViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$homeViewModelHash,
          dependencies: HomeViewModelFamily._dependencies,
          allTransitiveDependencies:
              HomeViewModelFamily._allTransitiveDependencies,
          departmentCode: departmentCode,
        );

  HomeViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.departmentCode,
  }) : super.internal();

  final String? departmentCode;

  @override
  FutureOr<HomeEntity> runNotifierBuild(
    covariant HomeViewModel notifier,
  ) {
    return notifier.build(
      departmentCode: departmentCode,
    );
  }

  @override
  Override overrideWith(HomeViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: HomeViewModelProvider._internal(
        () => create()..departmentCode = departmentCode,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        departmentCode: departmentCode,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<HomeViewModel, HomeEntity>
      createElement() {
    return _HomeViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HomeViewModelProvider &&
        other.departmentCode == departmentCode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, departmentCode.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HomeViewModelRef on AutoDisposeAsyncNotifierProviderRef<HomeEntity> {
  /// The parameter `departmentCode` of this provider.
  String? get departmentCode;
}

class _HomeViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<HomeViewModel, HomeEntity>
    with HomeViewModelRef {
  _HomeViewModelProviderElement(super.provider);

  @override
  String? get departmentCode =>
      (origin as HomeViewModelProvider).departmentCode;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
