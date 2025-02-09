abstract class UseCase<Type, Params> {
  Future<Type> call({Params article});
}
