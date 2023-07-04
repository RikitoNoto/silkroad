// Mocks generated by Mockito 5.4.2 from annotations
// in silkroad/test/send/providers/send_providers_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;
import 'dart:convert' as _i3;
import 'dart:io' as _i2;
import 'dart:typed_data' as _i6;

import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i7;
import 'package:silkroad/comm/communication_if.dart' as _i9;
import 'package:silkroad/comm/message.dart' as _i10;
import 'package:silkroad/comm/tcp.dart' as _i8;
import 'package:silkroad/send/repository/send_repository.dart' as _i5;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeInternetAddress_0 extends _i1.SmartFake
    implements _i2.InternetAddress {
  _FakeInternetAddress_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeEncoding_1 extends _i1.SmartFake implements _i3.Encoding {
  _FakeEncoding_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeStreamSubscription_2<T> extends _i1.SmartFake
    implements _i4.StreamSubscription<T> {
  _FakeStreamSubscription_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFuture_3<T> extends _i1.SmartFake implements _i4.Future<T> {
  _FakeFuture_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFile_4 extends _i1.SmartFake implements _i2.File {
  _FakeFile_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUri_5 extends _i1.SmartFake implements Uri {
  _FakeUri_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDirectory_6 extends _i1.SmartFake implements _i2.Directory {
  _FakeDirectory_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDateTime_7 extends _i1.SmartFake implements DateTime {
  _FakeDateTime_7(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeRandomAccessFile_8 extends _i1.SmartFake
    implements _i2.RandomAccessFile {
  _FakeRandomAccessFile_8(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeIOSink_9 extends _i1.SmartFake implements _i2.IOSink {
  _FakeIOSink_9(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFileStat_10 extends _i1.SmartFake implements _i2.FileStat {
  _FakeFileStat_10(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFileSystemEntity_11 extends _i1.SmartFake
    implements _i2.FileSystemEntity {
  _FakeFileSystemEntity_11(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [SendRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockSendRepository extends _i1.Mock implements _i5.SendRepository {
  @override
  _i4.Future<dynamic> send(
    String? connectionPoint,
    Map<String, String>? data,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #send,
          [
            connectionPoint,
            data,
          ],
        ),
        returnValue: _i4.Future<dynamic>.value(),
        returnValueForMissingStub: _i4.Future<dynamic>.value(),
      ) as _i4.Future<dynamic>);
  @override
  void close() => super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [Socket].
///
/// See the documentation for Mockito's code generation for more information.
class MockSocket extends _i1.Mock implements _i2.Socket {
  MockSocket() {
    _i1.throwOnMissingStub(this);
  }

  @override
  int get port => (super.noSuchMethod(
        Invocation.getter(#port),
        returnValue: 0,
      ) as int);
  @override
  int get remotePort => (super.noSuchMethod(
        Invocation.getter(#remotePort),
        returnValue: 0,
      ) as int);
  @override
  _i2.InternetAddress get address => (super.noSuchMethod(
        Invocation.getter(#address),
        returnValue: _FakeInternetAddress_0(
          this,
          Invocation.getter(#address),
        ),
      ) as _i2.InternetAddress);
  @override
  _i2.InternetAddress get remoteAddress => (super.noSuchMethod(
        Invocation.getter(#remoteAddress),
        returnValue: _FakeInternetAddress_0(
          this,
          Invocation.getter(#remoteAddress),
        ),
      ) as _i2.InternetAddress);
  @override
  _i4.Future<dynamic> get done => (super.noSuchMethod(
        Invocation.getter(#done),
        returnValue: _i4.Future<dynamic>.value(),
      ) as _i4.Future<dynamic>);
  @override
  bool get isBroadcast => (super.noSuchMethod(
        Invocation.getter(#isBroadcast),
        returnValue: false,
      ) as bool);
  @override
  _i4.Future<int> get length => (super.noSuchMethod(
        Invocation.getter(#length),
        returnValue: _i4.Future<int>.value(0),
      ) as _i4.Future<int>);
  @override
  _i4.Future<bool> get isEmpty => (super.noSuchMethod(
        Invocation.getter(#isEmpty),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  _i4.Future<_i6.Uint8List> get first => (super.noSuchMethod(
        Invocation.getter(#first),
        returnValue: _i4.Future<_i6.Uint8List>.value(_i6.Uint8List(0)),
      ) as _i4.Future<_i6.Uint8List>);
  @override
  _i4.Future<_i6.Uint8List> get last => (super.noSuchMethod(
        Invocation.getter(#last),
        returnValue: _i4.Future<_i6.Uint8List>.value(_i6.Uint8List(0)),
      ) as _i4.Future<_i6.Uint8List>);
  @override
  _i4.Future<_i6.Uint8List> get single => (super.noSuchMethod(
        Invocation.getter(#single),
        returnValue: _i4.Future<_i6.Uint8List>.value(_i6.Uint8List(0)),
      ) as _i4.Future<_i6.Uint8List>);
  @override
  _i3.Encoding get encoding => (super.noSuchMethod(
        Invocation.getter(#encoding),
        returnValue: _FakeEncoding_1(
          this,
          Invocation.getter(#encoding),
        ),
      ) as _i3.Encoding);
  @override
  set encoding(_i3.Encoding? _encoding) => super.noSuchMethod(
        Invocation.setter(
          #encoding,
          _encoding,
        ),
        returnValueForMissingStub: null,
      );
  @override
  void destroy() => super.noSuchMethod(
        Invocation.method(
          #destroy,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool setOption(
    _i2.SocketOption? option,
    bool? enabled,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setOption,
          [
            option,
            enabled,
          ],
        ),
        returnValue: false,
      ) as bool);
  @override
  _i6.Uint8List getRawOption(_i2.RawSocketOption? option) =>
      (super.noSuchMethod(
        Invocation.method(
          #getRawOption,
          [option],
        ),
        returnValue: _i6.Uint8List(0),
      ) as _i6.Uint8List);
  @override
  void setRawOption(_i2.RawSocketOption? option) => super.noSuchMethod(
        Invocation.method(
          #setRawOption,
          [option],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i4.Future<dynamic> close() => (super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValue: _i4.Future<dynamic>.value(),
      ) as _i4.Future<dynamic>);
  @override
  _i4.Stream<_i6.Uint8List> asBroadcastStream({
    void Function(_i4.StreamSubscription<_i6.Uint8List>)? onListen,
    void Function(_i4.StreamSubscription<_i6.Uint8List>)? onCancel,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #asBroadcastStream,
          [],
          {
            #onListen: onListen,
            #onCancel: onCancel,
          },
        ),
        returnValue: _i4.Stream<_i6.Uint8List>.empty(),
      ) as _i4.Stream<_i6.Uint8List>);
  @override
  _i4.StreamSubscription<_i6.Uint8List> listen(
    void Function(_i6.Uint8List)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #listen,
          [onData],
          {
            #onError: onError,
            #onDone: onDone,
            #cancelOnError: cancelOnError,
          },
        ),
        returnValue: _FakeStreamSubscription_2<_i6.Uint8List>(
          this,
          Invocation.method(
            #listen,
            [onData],
            {
              #onError: onError,
              #onDone: onDone,
              #cancelOnError: cancelOnError,
            },
          ),
        ),
      ) as _i4.StreamSubscription<_i6.Uint8List>);
  @override
  _i4.Stream<_i6.Uint8List> where(bool Function(_i6.Uint8List)? test) =>
      (super.noSuchMethod(
        Invocation.method(
          #where,
          [test],
        ),
        returnValue: _i4.Stream<_i6.Uint8List>.empty(),
      ) as _i4.Stream<_i6.Uint8List>);
  @override
  _i4.Stream<S> map<S>(S Function(_i6.Uint8List)? convert) =>
      (super.noSuchMethod(
        Invocation.method(
          #map,
          [convert],
        ),
        returnValue: _i4.Stream<S>.empty(),
      ) as _i4.Stream<S>);
  @override
  _i4.Stream<E> asyncMap<E>(_i4.FutureOr<E> Function(_i6.Uint8List)? convert) =>
      (super.noSuchMethod(
        Invocation.method(
          #asyncMap,
          [convert],
        ),
        returnValue: _i4.Stream<E>.empty(),
      ) as _i4.Stream<E>);
  @override
  _i4.Stream<E> asyncExpand<E>(
          _i4.Stream<E>? Function(_i6.Uint8List)? convert) =>
      (super.noSuchMethod(
        Invocation.method(
          #asyncExpand,
          [convert],
        ),
        returnValue: _i4.Stream<E>.empty(),
      ) as _i4.Stream<E>);
  @override
  _i4.Stream<_i6.Uint8List> handleError(
    Function? onError, {
    bool Function(dynamic)? test,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #handleError,
          [onError],
          {#test: test},
        ),
        returnValue: _i4.Stream<_i6.Uint8List>.empty(),
      ) as _i4.Stream<_i6.Uint8List>);
  @override
  _i4.Stream<S> expand<S>(Iterable<S> Function(_i6.Uint8List)? convert) =>
      (super.noSuchMethod(
        Invocation.method(
          #expand,
          [convert],
        ),
        returnValue: _i4.Stream<S>.empty(),
      ) as _i4.Stream<S>);
  @override
  _i4.Future<dynamic> pipe(_i4.StreamConsumer<_i6.Uint8List>? streamConsumer) =>
      (super.noSuchMethod(
        Invocation.method(
          #pipe,
          [streamConsumer],
        ),
        returnValue: _i4.Future<dynamic>.value(),
      ) as _i4.Future<dynamic>);
  @override
  _i4.Stream<S> transform<S>(
          _i4.StreamTransformer<_i6.Uint8List, S>? streamTransformer) =>
      (super.noSuchMethod(
        Invocation.method(
          #transform,
          [streamTransformer],
        ),
        returnValue: _i4.Stream<S>.empty(),
      ) as _i4.Stream<S>);
  @override
  _i4.Future<_i6.Uint8List> reduce(
          _i6.Uint8List Function(
            _i6.Uint8List,
            _i6.Uint8List,
          )? combine) =>
      (super.noSuchMethod(
        Invocation.method(
          #reduce,
          [combine],
        ),
        returnValue: _i4.Future<_i6.Uint8List>.value(_i6.Uint8List(0)),
      ) as _i4.Future<_i6.Uint8List>);
  @override
  _i4.Future<S> fold<S>(
    S? initialValue,
    S Function(
      S,
      _i6.Uint8List,
    )? combine,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #fold,
          [
            initialValue,
            combine,
          ],
        ),
        returnValue: _i7.ifNotNull(
              _i7.dummyValueOrNull<S>(
                this,
                Invocation.method(
                  #fold,
                  [
                    initialValue,
                    combine,
                  ],
                ),
              ),
              (S v) => _i4.Future<S>.value(v),
            ) ??
            _FakeFuture_3<S>(
              this,
              Invocation.method(
                #fold,
                [
                  initialValue,
                  combine,
                ],
              ),
            ),
      ) as _i4.Future<S>);
  @override
  _i4.Future<String> join([String? separator = r'']) => (super.noSuchMethod(
        Invocation.method(
          #join,
          [separator],
        ),
        returnValue: _i4.Future<String>.value(''),
      ) as _i4.Future<String>);
  @override
  _i4.Future<bool> contains(Object? needle) => (super.noSuchMethod(
        Invocation.method(
          #contains,
          [needle],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  _i4.Future<void> forEach(void Function(_i6.Uint8List)? action) =>
      (super.noSuchMethod(
        Invocation.method(
          #forEach,
          [action],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<bool> every(bool Function(_i6.Uint8List)? test) =>
      (super.noSuchMethod(
        Invocation.method(
          #every,
          [test],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  _i4.Future<bool> any(bool Function(_i6.Uint8List)? test) =>
      (super.noSuchMethod(
        Invocation.method(
          #any,
          [test],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  _i4.Stream<R> cast<R>() => (super.noSuchMethod(
        Invocation.method(
          #cast,
          [],
        ),
        returnValue: _i4.Stream<R>.empty(),
      ) as _i4.Stream<R>);
  @override
  _i4.Future<List<_i6.Uint8List>> toList() => (super.noSuchMethod(
        Invocation.method(
          #toList,
          [],
        ),
        returnValue: _i4.Future<List<_i6.Uint8List>>.value(<_i6.Uint8List>[]),
      ) as _i4.Future<List<_i6.Uint8List>>);
  @override
  _i4.Future<Set<_i6.Uint8List>> toSet() => (super.noSuchMethod(
        Invocation.method(
          #toSet,
          [],
        ),
        returnValue: _i4.Future<Set<_i6.Uint8List>>.value(<_i6.Uint8List>{}),
      ) as _i4.Future<Set<_i6.Uint8List>>);
  @override
  _i4.Future<E> drain<E>([E? futureValue]) => (super.noSuchMethod(
        Invocation.method(
          #drain,
          [futureValue],
        ),
        returnValue: _i7.ifNotNull(
              _i7.dummyValueOrNull<E>(
                this,
                Invocation.method(
                  #drain,
                  [futureValue],
                ),
              ),
              (E v) => _i4.Future<E>.value(v),
            ) ??
            _FakeFuture_3<E>(
              this,
              Invocation.method(
                #drain,
                [futureValue],
              ),
            ),
      ) as _i4.Future<E>);
  @override
  _i4.Stream<_i6.Uint8List> take(int? count) => (super.noSuchMethod(
        Invocation.method(
          #take,
          [count],
        ),
        returnValue: _i4.Stream<_i6.Uint8List>.empty(),
      ) as _i4.Stream<_i6.Uint8List>);
  @override
  _i4.Stream<_i6.Uint8List> takeWhile(bool Function(_i6.Uint8List)? test) =>
      (super.noSuchMethod(
        Invocation.method(
          #takeWhile,
          [test],
        ),
        returnValue: _i4.Stream<_i6.Uint8List>.empty(),
      ) as _i4.Stream<_i6.Uint8List>);
  @override
  _i4.Stream<_i6.Uint8List> skip(int? count) => (super.noSuchMethod(
        Invocation.method(
          #skip,
          [count],
        ),
        returnValue: _i4.Stream<_i6.Uint8List>.empty(),
      ) as _i4.Stream<_i6.Uint8List>);
  @override
  _i4.Stream<_i6.Uint8List> skipWhile(bool Function(_i6.Uint8List)? test) =>
      (super.noSuchMethod(
        Invocation.method(
          #skipWhile,
          [test],
        ),
        returnValue: _i4.Stream<_i6.Uint8List>.empty(),
      ) as _i4.Stream<_i6.Uint8List>);
  @override
  _i4.Stream<_i6.Uint8List> distinct(
          [bool Function(
            _i6.Uint8List,
            _i6.Uint8List,
          )? equals]) =>
      (super.noSuchMethod(
        Invocation.method(
          #distinct,
          [equals],
        ),
        returnValue: _i4.Stream<_i6.Uint8List>.empty(),
      ) as _i4.Stream<_i6.Uint8List>);
  @override
  _i4.Future<_i6.Uint8List> firstWhere(
    bool Function(_i6.Uint8List)? test, {
    _i6.Uint8List Function()? orElse,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #firstWhere,
          [test],
          {#orElse: orElse},
        ),
        returnValue: _i4.Future<_i6.Uint8List>.value(_i6.Uint8List(0)),
      ) as _i4.Future<_i6.Uint8List>);
  @override
  _i4.Future<_i6.Uint8List> lastWhere(
    bool Function(_i6.Uint8List)? test, {
    _i6.Uint8List Function()? orElse,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #lastWhere,
          [test],
          {#orElse: orElse},
        ),
        returnValue: _i4.Future<_i6.Uint8List>.value(_i6.Uint8List(0)),
      ) as _i4.Future<_i6.Uint8List>);
  @override
  _i4.Future<_i6.Uint8List> singleWhere(
    bool Function(_i6.Uint8List)? test, {
    _i6.Uint8List Function()? orElse,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #singleWhere,
          [test],
          {#orElse: orElse},
        ),
        returnValue: _i4.Future<_i6.Uint8List>.value(_i6.Uint8List(0)),
      ) as _i4.Future<_i6.Uint8List>);
  @override
  _i4.Future<_i6.Uint8List> elementAt(int? index) => (super.noSuchMethod(
        Invocation.method(
          #elementAt,
          [index],
        ),
        returnValue: _i4.Future<_i6.Uint8List>.value(_i6.Uint8List(0)),
      ) as _i4.Future<_i6.Uint8List>);
  @override
  _i4.Stream<_i6.Uint8List> timeout(
    Duration? timeLimit, {
    void Function(_i4.EventSink<_i6.Uint8List>)? onTimeout,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #timeout,
          [timeLimit],
          {#onTimeout: onTimeout},
        ),
        returnValue: _i4.Stream<_i6.Uint8List>.empty(),
      ) as _i4.Stream<_i6.Uint8List>);
  @override
  void add(List<int>? data) => super.noSuchMethod(
        Invocation.method(
          #add,
          [data],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void write(Object? object) => super.noSuchMethod(
        Invocation.method(
          #write,
          [object],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void writeAll(
    Iterable<dynamic>? objects, [
    String? separator = r'',
  ]) =>
      super.noSuchMethod(
        Invocation.method(
          #writeAll,
          [
            objects,
            separator,
          ],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void writeln([Object? object = r'']) => super.noSuchMethod(
        Invocation.method(
          #writeln,
          [object],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void writeCharCode(int? charCode) => super.noSuchMethod(
        Invocation.method(
          #writeCharCode,
          [charCode],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void addError(
    Object? error, [
    StackTrace? stackTrace,
  ]) =>
      super.noSuchMethod(
        Invocation.method(
          #addError,
          [
            error,
            stackTrace,
          ],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i4.Future<dynamic> addStream(_i4.Stream<List<int>>? stream) =>
      (super.noSuchMethod(
        Invocation.method(
          #addStream,
          [stream],
        ),
        returnValue: _i4.Future<dynamic>.value(),
      ) as _i4.Future<dynamic>);
  @override
  _i4.Future<dynamic> flush() => (super.noSuchMethod(
        Invocation.method(
          #flush,
          [],
        ),
        returnValue: _i4.Future<dynamic>.value(),
      ) as _i4.Future<dynamic>);
}

/// A class which mocks [Tcp].
///
/// See the documentation for Mockito's code generation for more information.
class MockTcp extends _i1.Mock implements _i8.Tcp {
  MockTcp() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Socket?> connect(String? to) => (super.noSuchMethod(
        Invocation.method(
          #connect,
          [to],
        ),
        returnValue: _i4.Future<_i2.Socket?>.value(),
      ) as _i4.Future<_i2.Socket?>);
  @override
  _i4.Future<void> listen(
    String? bind, {
    _i9.ConnectionCallback<_i2.Socket>? connectionCallback,
    _i9.ReceiveCallback<_i2.Socket>? receiveCallback,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #listen,
          [bind],
          {
            #connectionCallback: connectionCallback,
            #receiveCallback: receiveCallback,
          },
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<dynamic> close() => (super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValue: _i4.Future<dynamic>.value(),
      ) as _i4.Future<dynamic>);
  @override
  _i4.Future<_i9.Result> send(
    _i2.Socket? connection,
    _i10.Message? data,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #send,
          [
            connection,
            data,
          ],
        ),
        returnValue: _i4.Future<_i9.Result>.value(_i9.Result.success),
      ) as _i4.Future<_i9.Result>);
}

/// A class which mocks [File].
///
/// See the documentation for Mockito's code generation for more information.
class MockFile extends _i1.Mock implements _i2.File {
  MockFile() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.File get absolute => (super.noSuchMethod(
        Invocation.getter(#absolute),
        returnValue: _FakeFile_4(
          this,
          Invocation.getter(#absolute),
        ),
      ) as _i2.File);
  @override
  String get path => (super.noSuchMethod(
        Invocation.getter(#path),
        returnValue: '',
      ) as String);
  @override
  Uri get uri => (super.noSuchMethod(
        Invocation.getter(#uri),
        returnValue: _FakeUri_5(
          this,
          Invocation.getter(#uri),
        ),
      ) as Uri);
  @override
  bool get isAbsolute => (super.noSuchMethod(
        Invocation.getter(#isAbsolute),
        returnValue: false,
      ) as bool);
  @override
  _i2.Directory get parent => (super.noSuchMethod(
        Invocation.getter(#parent),
        returnValue: _FakeDirectory_6(
          this,
          Invocation.getter(#parent),
        ),
      ) as _i2.Directory);
  @override
  _i4.Future<_i2.File> create({
    bool? recursive = false,
    bool? exclusive = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #create,
          [],
          {
            #recursive: recursive,
            #exclusive: exclusive,
          },
        ),
        returnValue: _i4.Future<_i2.File>.value(_FakeFile_4(
          this,
          Invocation.method(
            #create,
            [],
            {
              #recursive: recursive,
              #exclusive: exclusive,
            },
          ),
        )),
      ) as _i4.Future<_i2.File>);
  @override
  void createSync({
    bool? recursive = false,
    bool? exclusive = false,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #createSync,
          [],
          {
            #recursive: recursive,
            #exclusive: exclusive,
          },
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i4.Future<_i2.File> rename(String? newPath) => (super.noSuchMethod(
        Invocation.method(
          #rename,
          [newPath],
        ),
        returnValue: _i4.Future<_i2.File>.value(_FakeFile_4(
          this,
          Invocation.method(
            #rename,
            [newPath],
          ),
        )),
      ) as _i4.Future<_i2.File>);
  @override
  _i2.File renameSync(String? newPath) => (super.noSuchMethod(
        Invocation.method(
          #renameSync,
          [newPath],
        ),
        returnValue: _FakeFile_4(
          this,
          Invocation.method(
            #renameSync,
            [newPath],
          ),
        ),
      ) as _i2.File);
  @override
  _i4.Future<_i2.File> copy(String? newPath) => (super.noSuchMethod(
        Invocation.method(
          #copy,
          [newPath],
        ),
        returnValue: _i4.Future<_i2.File>.value(_FakeFile_4(
          this,
          Invocation.method(
            #copy,
            [newPath],
          ),
        )),
      ) as _i4.Future<_i2.File>);
  @override
  _i2.File copySync(String? newPath) => (super.noSuchMethod(
        Invocation.method(
          #copySync,
          [newPath],
        ),
        returnValue: _FakeFile_4(
          this,
          Invocation.method(
            #copySync,
            [newPath],
          ),
        ),
      ) as _i2.File);
  @override
  _i4.Future<int> length() => (super.noSuchMethod(
        Invocation.method(
          #length,
          [],
        ),
        returnValue: _i4.Future<int>.value(0),
      ) as _i4.Future<int>);
  @override
  int lengthSync() => (super.noSuchMethod(
        Invocation.method(
          #lengthSync,
          [],
        ),
        returnValue: 0,
      ) as int);
  @override
  _i4.Future<DateTime> lastAccessed() => (super.noSuchMethod(
        Invocation.method(
          #lastAccessed,
          [],
        ),
        returnValue: _i4.Future<DateTime>.value(_FakeDateTime_7(
          this,
          Invocation.method(
            #lastAccessed,
            [],
          ),
        )),
      ) as _i4.Future<DateTime>);
  @override
  DateTime lastAccessedSync() => (super.noSuchMethod(
        Invocation.method(
          #lastAccessedSync,
          [],
        ),
        returnValue: _FakeDateTime_7(
          this,
          Invocation.method(
            #lastAccessedSync,
            [],
          ),
        ),
      ) as DateTime);
  @override
  _i4.Future<dynamic> setLastAccessed(DateTime? time) => (super.noSuchMethod(
        Invocation.method(
          #setLastAccessed,
          [time],
        ),
        returnValue: _i4.Future<dynamic>.value(),
      ) as _i4.Future<dynamic>);
  @override
  void setLastAccessedSync(DateTime? time) => super.noSuchMethod(
        Invocation.method(
          #setLastAccessedSync,
          [time],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i4.Future<DateTime> lastModified() => (super.noSuchMethod(
        Invocation.method(
          #lastModified,
          [],
        ),
        returnValue: _i4.Future<DateTime>.value(_FakeDateTime_7(
          this,
          Invocation.method(
            #lastModified,
            [],
          ),
        )),
      ) as _i4.Future<DateTime>);
  @override
  DateTime lastModifiedSync() => (super.noSuchMethod(
        Invocation.method(
          #lastModifiedSync,
          [],
        ),
        returnValue: _FakeDateTime_7(
          this,
          Invocation.method(
            #lastModifiedSync,
            [],
          ),
        ),
      ) as DateTime);
  @override
  _i4.Future<dynamic> setLastModified(DateTime? time) => (super.noSuchMethod(
        Invocation.method(
          #setLastModified,
          [time],
        ),
        returnValue: _i4.Future<dynamic>.value(),
      ) as _i4.Future<dynamic>);
  @override
  void setLastModifiedSync(DateTime? time) => super.noSuchMethod(
        Invocation.method(
          #setLastModifiedSync,
          [time],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i4.Future<_i2.RandomAccessFile> open(
          {_i2.FileMode? mode = _i2.FileMode.read}) =>
      (super.noSuchMethod(
        Invocation.method(
          #open,
          [],
          {#mode: mode},
        ),
        returnValue:
            _i4.Future<_i2.RandomAccessFile>.value(_FakeRandomAccessFile_8(
          this,
          Invocation.method(
            #open,
            [],
            {#mode: mode},
          ),
        )),
      ) as _i4.Future<_i2.RandomAccessFile>);
  @override
  _i2.RandomAccessFile openSync({_i2.FileMode? mode = _i2.FileMode.read}) =>
      (super.noSuchMethod(
        Invocation.method(
          #openSync,
          [],
          {#mode: mode},
        ),
        returnValue: _FakeRandomAccessFile_8(
          this,
          Invocation.method(
            #openSync,
            [],
            {#mode: mode},
          ),
        ),
      ) as _i2.RandomAccessFile);
  @override
  _i4.Stream<List<int>> openRead([
    int? start,
    int? end,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #openRead,
          [
            start,
            end,
          ],
        ),
        returnValue: _i4.Stream<List<int>>.empty(),
      ) as _i4.Stream<List<int>>);
  @override
  _i2.IOSink openWrite({
    _i2.FileMode? mode = _i2.FileMode.write,
    _i3.Encoding? encoding = const _i3.Utf8Codec(),
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #openWrite,
          [],
          {
            #mode: mode,
            #encoding: encoding,
          },
        ),
        returnValue: _FakeIOSink_9(
          this,
          Invocation.method(
            #openWrite,
            [],
            {
              #mode: mode,
              #encoding: encoding,
            },
          ),
        ),
      ) as _i2.IOSink);
  @override
  _i4.Future<_i6.Uint8List> readAsBytes() => (super.noSuchMethod(
        Invocation.method(
          #readAsBytes,
          [],
        ),
        returnValue: _i4.Future<_i6.Uint8List>.value(_i6.Uint8List(0)),
      ) as _i4.Future<_i6.Uint8List>);
  @override
  _i6.Uint8List readAsBytesSync() => (super.noSuchMethod(
        Invocation.method(
          #readAsBytesSync,
          [],
        ),
        returnValue: _i6.Uint8List(0),
      ) as _i6.Uint8List);
  @override
  _i4.Future<String> readAsString(
          {_i3.Encoding? encoding = const _i3.Utf8Codec()}) =>
      (super.noSuchMethod(
        Invocation.method(
          #readAsString,
          [],
          {#encoding: encoding},
        ),
        returnValue: _i4.Future<String>.value(''),
      ) as _i4.Future<String>);
  @override
  String readAsStringSync({_i3.Encoding? encoding = const _i3.Utf8Codec()}) =>
      (super.noSuchMethod(
        Invocation.method(
          #readAsStringSync,
          [],
          {#encoding: encoding},
        ),
        returnValue: '',
      ) as String);
  @override
  _i4.Future<List<String>> readAsLines(
          {_i3.Encoding? encoding = const _i3.Utf8Codec()}) =>
      (super.noSuchMethod(
        Invocation.method(
          #readAsLines,
          [],
          {#encoding: encoding},
        ),
        returnValue: _i4.Future<List<String>>.value(<String>[]),
      ) as _i4.Future<List<String>>);
  @override
  List<String> readAsLinesSync(
          {_i3.Encoding? encoding = const _i3.Utf8Codec()}) =>
      (super.noSuchMethod(
        Invocation.method(
          #readAsLinesSync,
          [],
          {#encoding: encoding},
        ),
        returnValue: <String>[],
      ) as List<String>);
  @override
  _i4.Future<_i2.File> writeAsBytes(
    List<int>? bytes, {
    _i2.FileMode? mode = _i2.FileMode.write,
    bool? flush = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #writeAsBytes,
          [bytes],
          {
            #mode: mode,
            #flush: flush,
          },
        ),
        returnValue: _i4.Future<_i2.File>.value(_FakeFile_4(
          this,
          Invocation.method(
            #writeAsBytes,
            [bytes],
            {
              #mode: mode,
              #flush: flush,
            },
          ),
        )),
      ) as _i4.Future<_i2.File>);
  @override
  void writeAsBytesSync(
    List<int>? bytes, {
    _i2.FileMode? mode = _i2.FileMode.write,
    bool? flush = false,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #writeAsBytesSync,
          [bytes],
          {
            #mode: mode,
            #flush: flush,
          },
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i4.Future<_i2.File> writeAsString(
    String? contents, {
    _i2.FileMode? mode = _i2.FileMode.write,
    _i3.Encoding? encoding = const _i3.Utf8Codec(),
    bool? flush = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #writeAsString,
          [contents],
          {
            #mode: mode,
            #encoding: encoding,
            #flush: flush,
          },
        ),
        returnValue: _i4.Future<_i2.File>.value(_FakeFile_4(
          this,
          Invocation.method(
            #writeAsString,
            [contents],
            {
              #mode: mode,
              #encoding: encoding,
              #flush: flush,
            },
          ),
        )),
      ) as _i4.Future<_i2.File>);
  @override
  void writeAsStringSync(
    String? contents, {
    _i2.FileMode? mode = _i2.FileMode.write,
    _i3.Encoding? encoding = const _i3.Utf8Codec(),
    bool? flush = false,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #writeAsStringSync,
          [contents],
          {
            #mode: mode,
            #encoding: encoding,
            #flush: flush,
          },
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i4.Future<bool> exists() => (super.noSuchMethod(
        Invocation.method(
          #exists,
          [],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  bool existsSync() => (super.noSuchMethod(
        Invocation.method(
          #existsSync,
          [],
        ),
        returnValue: false,
      ) as bool);
  @override
  _i4.Future<String> resolveSymbolicLinks() => (super.noSuchMethod(
        Invocation.method(
          #resolveSymbolicLinks,
          [],
        ),
        returnValue: _i4.Future<String>.value(''),
      ) as _i4.Future<String>);
  @override
  String resolveSymbolicLinksSync() => (super.noSuchMethod(
        Invocation.method(
          #resolveSymbolicLinksSync,
          [],
        ),
        returnValue: '',
      ) as String);
  @override
  _i4.Future<_i2.FileStat> stat() => (super.noSuchMethod(
        Invocation.method(
          #stat,
          [],
        ),
        returnValue: _i4.Future<_i2.FileStat>.value(_FakeFileStat_10(
          this,
          Invocation.method(
            #stat,
            [],
          ),
        )),
      ) as _i4.Future<_i2.FileStat>);
  @override
  _i2.FileStat statSync() => (super.noSuchMethod(
        Invocation.method(
          #statSync,
          [],
        ),
        returnValue: _FakeFileStat_10(
          this,
          Invocation.method(
            #statSync,
            [],
          ),
        ),
      ) as _i2.FileStat);
  @override
  _i4.Future<_i2.FileSystemEntity> delete({bool? recursive = false}) =>
      (super.noSuchMethod(
        Invocation.method(
          #delete,
          [],
          {#recursive: recursive},
        ),
        returnValue:
            _i4.Future<_i2.FileSystemEntity>.value(_FakeFileSystemEntity_11(
          this,
          Invocation.method(
            #delete,
            [],
            {#recursive: recursive},
          ),
        )),
      ) as _i4.Future<_i2.FileSystemEntity>);
  @override
  void deleteSync({bool? recursive = false}) => super.noSuchMethod(
        Invocation.method(
          #deleteSync,
          [],
          {#recursive: recursive},
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i4.Stream<_i2.FileSystemEvent> watch({
    int? events = 15,
    bool? recursive = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #watch,
          [],
          {
            #events: events,
            #recursive: recursive,
          },
        ),
        returnValue: _i4.Stream<_i2.FileSystemEvent>.empty(),
      ) as _i4.Stream<_i2.FileSystemEvent>);
}
