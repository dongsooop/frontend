// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$noticeViewModelHash() => r'56d6b6447145dd5614ff3a8ea6efa882166ca31a';

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

abstract class _$NoticeViewModel
    extends BuildlessAutoDisposeAsyncNotifier<List<NoticeEntity>> {
  late final String? departmentType;

  FutureOr<List<NoticeEntity>> build(
    String? departmentType,
  );
}

/// See also [NoticeViewModel].
@ProviderFor(NoticeViewModel)
const noticeViewModelProvider = NoticeViewModelFamily();

/// See also [NoticeViewModel].
class NoticeViewModelFamily extends Family<AsyncValue<List<NoticeEntity>>> {
  /// See also [NoticeViewModel].
  const NoticeViewModelFamily();

  /// See also [NoticeViewModel].
  NoticeViewModelProvider call(
    String? departmentType,
  ) {
    return NoticeViewModelProvider(
      departmentType,
    );
  }

  @override
  NoticeViewModelProvider getProviderOverride(
    covariant NoticeViewModelProvider provider,
  ) {
    return call(
      provider.departmentType,
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
  String? get name => r'noticeViewModelProvider';
}

/// See also [NoticeViewModel].
class NoticeViewModelProvider extends AutoDisposeAsyncNotifierProviderImpl<
    NoticeViewModel, List<NoticeEntity>> {
  /// See also [NoticeViewModel].
  NoticeViewModelProvider(
    String? departmentType,
  ) : this._internal(
          () => NoticeViewModel()..departmentType = departmentType,
          from: noticeViewModelProvider,
          name: r'noticeViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$noticeViewModelHash,
          dependencies: NoticeViewModelFamily._dependencies,
          allTransitiveDependencies:
              NoticeViewModelFamily._allTransitiveDependencies,
          departmentType: departmentType,
        );

  NoticeViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.departmentType,
  }) : super.internal();

  final String? departmentType;

  @override
  FutureOr<List<NoticeEntity>> runNotifierBuild(
    covariant NoticeViewModel notifier,
  ) {
    return notifier.build(
      departmentType,
    );
  }

  @override
  Override overrideWith(NoticeViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: NoticeViewModelProvider._internal(
        () => create()..departmentType = departmentType,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        departmentType: departmentType,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<NoticeViewModel, List<NoticeEntity>>
      createElement() {
    return _NoticeViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NoticeViewModelProvider &&
        other.departmentType == departmentType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, departmentType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NoticeViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<List<NoticeEntity>> {
  /// The parameter `departmentType` of this provider.
  String? get departmentType;
}

class _NoticeViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<NoticeViewModel,
        List<NoticeEntity>> with NoticeViewModelRef {
  _NoticeViewModelProviderElement(super.provider);

  @override
  String? get departmentType =>
      (origin as NoticeViewModelProvider).departmentType;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
