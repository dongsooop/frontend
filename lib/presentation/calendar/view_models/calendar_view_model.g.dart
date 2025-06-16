// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$calendarViewModelHash() => r'e05b95771010f0b495419abe9bd6bb25d584fad3';

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

abstract class _$CalendarViewModel
    extends BuildlessAutoDisposeAsyncNotifier<List<CalendarListEntity>> {
  late final int memberId;
  late final DateTime currentMonth;

  FutureOr<List<CalendarListEntity>> build(
    int memberId,
    DateTime currentMonth,
  );
}

/// See also [CalendarViewModel].
@ProviderFor(CalendarViewModel)
const calendarViewModelProvider = CalendarViewModelFamily();

/// See also [CalendarViewModel].
class CalendarViewModelFamily
    extends Family<AsyncValue<List<CalendarListEntity>>> {
  /// See also [CalendarViewModel].
  const CalendarViewModelFamily();

  /// See also [CalendarViewModel].
  CalendarViewModelProvider call(
    int memberId,
    DateTime currentMonth,
  ) {
    return CalendarViewModelProvider(
      memberId,
      currentMonth,
    );
  }

  @override
  CalendarViewModelProvider getProviderOverride(
    covariant CalendarViewModelProvider provider,
  ) {
    return call(
      provider.memberId,
      provider.currentMonth,
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
  String? get name => r'calendarViewModelProvider';
}

/// See also [CalendarViewModel].
class CalendarViewModelProvider extends AutoDisposeAsyncNotifierProviderImpl<
    CalendarViewModel, List<CalendarListEntity>> {
  /// See also [CalendarViewModel].
  CalendarViewModelProvider(
    int memberId,
    DateTime currentMonth,
  ) : this._internal(
          () => CalendarViewModel()
            ..memberId = memberId
            ..currentMonth = currentMonth,
          from: calendarViewModelProvider,
          name: r'calendarViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$calendarViewModelHash,
          dependencies: CalendarViewModelFamily._dependencies,
          allTransitiveDependencies:
              CalendarViewModelFamily._allTransitiveDependencies,
          memberId: memberId,
          currentMonth: currentMonth,
        );

  CalendarViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.memberId,
    required this.currentMonth,
  }) : super.internal();

  final int memberId;
  final DateTime currentMonth;

  @override
  FutureOr<List<CalendarListEntity>> runNotifierBuild(
    covariant CalendarViewModel notifier,
  ) {
    return notifier.build(
      memberId,
      currentMonth,
    );
  }

  @override
  Override overrideWith(CalendarViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: CalendarViewModelProvider._internal(
        () => create()
          ..memberId = memberId
          ..currentMonth = currentMonth,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        memberId: memberId,
        currentMonth: currentMonth,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CalendarViewModel,
      List<CalendarListEntity>> createElement() {
    return _CalendarViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CalendarViewModelProvider &&
        other.memberId == memberId &&
        other.currentMonth == currentMonth;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, memberId.hashCode);
    hash = _SystemHash.combine(hash, currentMonth.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CalendarViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<List<CalendarListEntity>> {
  /// The parameter `memberId` of this provider.
  int get memberId;

  /// The parameter `currentMonth` of this provider.
  DateTime get currentMonth;
}

class _CalendarViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CalendarViewModel,
        List<CalendarListEntity>> with CalendarViewModelRef {
  _CalendarViewModelProviderElement(super.provider);

  @override
  int get memberId => (origin as CalendarViewModelProvider).memberId;
  @override
  DateTime get currentMonth =>
      (origin as CalendarViewModelProvider).currentMonth;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
