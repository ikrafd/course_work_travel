abstract class UseCase <Type, Params> {
  //Future <Type> call ({Params params});
  Future<Type> execute(Params params);
}