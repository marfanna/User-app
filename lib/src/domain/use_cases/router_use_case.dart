import '../repositories/router_repository.dart';

final class GetUserLoginStatusUseCase {
  GetUserLoginStatusUseCase(this.repository);

  final RouterRepository repository;

  bool call() {
    return repository.isUserLoggedIn();
  }
}
