import 'package:reso_coder/core/error/failures.dart';
import 'package:reso_coder/core/usecases/usecase.dart';
import 'package:reso_coder/core/utils/input_converter.dart';
import 'package:reso_coder/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:reso_coder/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:reso_coder/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:reso_coder/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );

    registerFallbackValue(NoParams());
  });

  test('initialState should be Empty', () {
    // assert
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() => when(
      () => mockInputConverter.stringToUnsignedInteger(tNumberString),
    ).thenReturn(Right(tNumberParsed));

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(
          () => mockGetConcreteNumberTrivia.call(Params(number: tNumberParsed)),
        ).thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(() => mockInputConverter.stringToUnsignedInteger(tNumberString));
        // assert
        verify(() => mockInputConverter.stringToUnsignedInteger(tNumberString)).called(1);
        verifyNoMoreInteractions(mockInputConverter);
      },
    );

    test('should emit [Error] when the input is invalid', () async {
      // arrange
      when(
        () => mockInputConverter.stringToUnsignedInteger("-1"),
      ).thenReturn(Left(InvalidInputFailure()));

      // assert later
      expectLater(bloc.stream, emitsInOrder([Error(message: INVALID_INPUT_FAILURE_MESSAGE)]));

      // act
      bloc.add(GetTriviaForConcreteNumber("-1"));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(
        () => mockGetConcreteNumberTrivia(Params(number: tNumberParsed)),
      ).thenAnswer((_) async => Right(tNumberTrivia));

      // assert later
      expectLater(bloc.stream, emitsInOrder([Loading(), Loaded(trivia: tNumberTrivia)]));

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(
        () => mockGetConcreteNumberTrivia(Params(number: tNumberParsed)),
      ).thenAnswer((_) async => Left(ServerFailure()));

      // assert later
      expectLater(bloc.stream, emitsInOrder([Loading(), Error(message: SERVER_FAILURE_MESSAGE)]));

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(
          () => mockGetConcreteNumberTrivia(Params(number: tNumberParsed)),
        ).thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        expectLater(bloc.stream, emitsInOrder([Loading(), Error(message: CACHE_FAILURE_MESSAGE)]));

        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test('should get data from the random use case', () async {
      // arrange
      when(() => mockGetRandomNumberTrivia(any())).thenAnswer((_) async => Right(tNumberTrivia));
      // assert later
      expectLater(bloc.stream, emitsInOrder([Loading(), Loaded(trivia: tNumberTrivia)]));
      // act
      bloc.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () async {
      // arrange
      when(() => mockGetRandomNumberTrivia(any())).thenAnswer((_) async => Right(tNumberTrivia));

      // assert later
      expectLater(bloc.stream, emitsInOrder([Loading(), Loaded(trivia: tNumberTrivia)]));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      when(() => mockGetRandomNumberTrivia(any())).thenAnswer((_) async => Left(ServerFailure()));

      // assert later
      expectLater(bloc.stream, emitsInOrder([Loading(), Error(message: SERVER_FAILURE_MESSAGE)]));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        when(() => mockGetRandomNumberTrivia(any())).thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        expectLater(bloc.stream, emitsInOrder([Loading(), Error(message: CACHE_FAILURE_MESSAGE)]));

        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );
  });
}
