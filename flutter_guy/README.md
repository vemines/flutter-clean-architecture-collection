# flutter_guy

ndkVersion = "27.0.12077973"

flutter_bloc, equatable, get_it, intl, sqflite, floor, dio, retrofit, flutter_hooks, cached_network_image

flutter pub run build_runner build --delete-conflicting-outputs

## Feature

### Domain

`entities` extends Equatable -> `repository` (abstract)

### Data

`models` extends `entities` ->
`repository_impl` extends domain `repository` (return `model` class, not `entities`) ->
`datasource` (remote / local) ->
`usecases` implements UseCase<DataState<List<Entities>>, void> (from core/usecase/usecase.dart)

### Presentation

`bloc` (state extends Equatable -> event => bloc)

## Get_it:

`Factory` return `new instance`, `Singleton` return `same instance`
