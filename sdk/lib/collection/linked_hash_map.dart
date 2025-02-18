// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of dart.collection;

/// A hash-table based implementation of [Map].
///
/// The insertion order of keys is remembered,
/// and keys are iterated in the order they were inserted into the map.
/// Values and entries are iterated in their corresponding key's order.
/// Changing a key's value, when the key is already in the map,
/// does not change the iteration order,
/// but removing the key and adding it again
/// will make it be last in the iteration order.
///
/// The keys of a `LinkedHashMap` must have consistent [Object.==]
/// and [Object.hashCode] implementations. This means that the `==` operator
/// must define a stable equivalence relation on the keys (reflexive,
/// symmetric, transitive, and consistent over time), and that `hashCode`
/// must be the same for objects that are considered equal by `==`.
abstract class LinkedHashMap<K, V> implements Map<K, V> {
  /// Creates an insertion-ordered hash-table based [Map].
  ///
  /// If [equals] is provided, it is used to compare the keys in the table with
  /// new keys. If [equals] is omitted, the key's own [Object.==] is used
  /// instead.
  ///
  /// Similar, if [hashCode] is provided, it is used to produce a hash value
  /// for keys in order to place them in the hash table. If it is omitted, the
  /// key's own [Object.hashCode] is used.
  ///
  /// The used `equals` and `hashCode` method should always be consistent,
  /// so that if `equals(a, b)` then `hashCode(a) == hashCode(b)`. The hash
  /// of an object, or what it compares equal to, should not change while the
  /// object is in the table. If it does change, the result is unpredictable.
  ///
  /// If you supply one of [equals] and [hashCode],
  /// you should generally also supply the other.
  ///
  /// Some [equals] or [hashCode] functions might not work for all objects.
  /// If [isValidKey] is supplied, it's used to check a potential key
  /// which is not necessarily an instance of [K], like the arguments to
  /// [operator []], [remove] and [containsKey], which are typed as `Object?`.
  /// If [isValidKey] returns `false`, for an object, the [equals] and
  /// [hashCode] functions are not called, and no key equal to that object
  /// is assumed to be in the map.
  /// The [isValidKey] function defaults to just testing if the object is an
  /// instance of [K].
  ///
  /// Example:
  /// ```dart template:expression
  /// LikedHashMap<int,int>(equals: (int a, int b) => (b - a) % 5 == 0,
  ///                       hashCode: (int e) => e % 5)
  /// ```
  /// This example map does not need an `isValidKey` function to be passed.
  /// The default function accepts precisely `int` values, which can safely be
  /// passed to both the `equals` and `hashCode` functions.
  ///
  /// If neither `equals`, `hashCode`, nor `isValidKey` is provided,
  /// the default `isValidKey` instead accepts all keys.
  /// The default equality and hashcode operations are assumed to work on all
  /// objects.
  ///
  /// Likewise, if `equals` is [identical], `hashCode` is [identityHashCode]
  /// and `isValidKey` is omitted, the resulting map is identity based,
  /// and the `isValidKey` defaults to accepting all keys.
  /// Such a map can be created directly using [LinkedHashMap.identity].
  external factory LinkedHashMap(
      {bool Function(K, K)? equals,
      int Function(K)? hashCode,
      bool Function(dynamic)? isValidKey});

  /// Creates an insertion-ordered identity-based map.
  ///
  /// Effectively a shorthand for:
  /// ```dart template:expression
  /// LinkedHashMap<K, V>(equals: identical,
  ///                     hashCode: identityHashCode)
  /// ```
  external factory LinkedHashMap.identity();

  /// Creates a [LinkedHashMap] that contains all key value pairs of [other].
  ///
  /// The keys must all be instances of [K] and the values to [V].
  /// The [other] map itself can have any type.
  factory LinkedHashMap.from(Map<dynamic, dynamic> other) {
    LinkedHashMap<K, V> result = LinkedHashMap<K, V>();
    other.forEach((dynamic k, dynamic v) {
      result[k as K] = v as V;
    });
    return result;
  }

  /// Creates a [LinkedHashMap] that contains all key value pairs of [other].
  factory LinkedHashMap.of(Map<K, V> other) =>
      LinkedHashMap<K, V>()..addAll(other);

  /// Creates a [LinkedHashMap] where the keys and values are computed from the
  /// [iterable].
  ///
  /// For each element of the [iterable] this constructor computes a key/value
  /// pair, by applying [key] and [value] respectively.
  ///
  /// The keys of the key/value pairs do not need to be unique. The last
  /// occurrence of a key will simply overwrite any previous value.
  ///
  /// If no values are specified for [key] and [value] the default is the
  /// identity function.
  factory LinkedHashMap.fromIterable(Iterable iterable,
      {K Function(dynamic element)? key, V Function(dynamic element)? value}) {
    LinkedHashMap<K, V> map = LinkedHashMap<K, V>();
    MapBase._fillMapWithMappedIterable(map, iterable, key, value);
    return map;
  }

  /// Creates a [LinkedHashMap] associating the given [keys] to [values].
  ///
  /// This constructor iterates over [keys] and [values] and maps each element of
  /// [keys] to the corresponding element of [values].
  ///
  /// If [keys] contains the same object multiple times, the last occurrence
  /// overwrites the previous value.
  ///
  /// It is an error if the two [Iterable]s don't have the same length.
  factory LinkedHashMap.fromIterables(Iterable<K> keys, Iterable<V> values) {
    LinkedHashMap<K, V> map = LinkedHashMap<K, V>();
    MapBase._fillMapWithIterables(map, keys, values);
    return map;
  }

  /// Creates a [LinkedHashMap] containing the entries of [entries].
  ///
  /// Returns a new `LinkedHashMap<K, V>` where all entries of [entries]
  /// have been added in iteration order.
  ///
  /// If multiple [entries] have the same key,
  /// later occurrences overwrite the earlier ones.
  @Since("2.1")
  factory LinkedHashMap.fromEntries(Iterable<MapEntry<K, V>> entries) =>
      LinkedHashMap<K, V>()..addEntries(entries);
}
