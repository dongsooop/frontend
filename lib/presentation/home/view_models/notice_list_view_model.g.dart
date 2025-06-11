// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_list_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$noticeListViewModelHash() =>
    r'8e53be84d94bc23d8ad7962eb269810ce76550da';

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

abstract class _$NoticeListViewModel
    extends BuildlessAutoDisposeAsyncNotifier<List<NoticeEntity>> {
  late final NoticeListArgs args;

  FutureOr<List<NoticeEntity>> build(
    NoticeListArgs args,
  );
}

/// See also [NoticeListViewModel].
@ProviderFor(NoticeListViewModel)
const noticeListViewModelProvider = NoticeListViewModelFamily();

/// See also [NoticeListViewModel].
class NoticeListViewModelFamily extends Family<AsyncValue<List<NoticeEntity>>> {
  /// See also [NoticeListViewModel].
  const NoticeListViewModelFamily();

  /// See also [NoticeListViewModel].
  NoticeListViewModelProvider call(
    NoticeListArgs args,
  ) {
    return NoticeListViewModelProvider(
      args,
    );
  }

  @override
  NoticeListViewModelProvider getProviderOverride(
    covariant NoticeListViewModelProvider provider,
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
  String? get name => r'noticeListViewModelProvider';
}

/// See also [NoticeListViewModel].
class NoticeListViewModelProvider extends AutoDisposeAsyncNotifierProviderImpl<
    NoticeListViewModel, List<NoticeEntity>> {
  /// See also [NoticeListViewModel].
  NoticeListViewModelProvider(
    NoticeListArgs args,
  ) : this._internal(
          () => NoticeListViewModel()..args = args,
          from: noticeListViewModelProvider,
          name: r'noticeListViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$noticeListViewModelHash,
          dependencies: NoticeListViewModelFamily._dependencies,
          allTransitiveDependencies:
              NoticeListViewModelFamily._allTransitiveDependencies,
          args: args,
        );

  NoticeListViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.args,
  }) : super.internal();

  final NoticeListArgs args;

  @override
  FutureOr<List<NoticeEntity>> runNotifierBuild(
    covariant NoticeListViewModel notifier,
  ) {
    return notifier.build(
      args,
    );
  }

  @override
  Override overrideWith(NoticeListViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: NoticeListViewModelProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<NoticeListViewModel,
      List<NoticeEntity>> createElement() {
    return _NoticeListViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NoticeListViewModelProvider && other.args == args;
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
mixin NoticeListViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<List<NoticeEntity>> {
  /// The parameter `args` of this provider.
  NoticeListArgs get args;
}

class _NoticeListViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<NoticeListViewModel,
        List<NoticeEntity>> with NoticeListViewModelRef {
  _NoticeListViewModelProviderElement(super.provider);

  @override
  NoticeListArgs get args => (origin as NoticeListViewModelProvider).args;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
