import 'package:clean_arch/core/core.dart';
import 'package:clean_arch/features/number_trivia/number_trivia.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockHttpClient extends Mock implements http.Client {}

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}
