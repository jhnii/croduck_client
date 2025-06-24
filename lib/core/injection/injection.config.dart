// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:croduck_client/data/datasources/chat_local_datasource.dart'
    as _i544;
import 'package:croduck_client/data/datasources/chat_remote_datasource.dart'
    as _i455;
import 'package:croduck_client/data/repositories/chat_repository_impl.dart'
    as _i498;
import 'package:croduck_client/domain/repositories/chat_repository.dart'
    as _i1063;
import 'package:croduck_client/domain/usecases/get_messages_usecase.dart'
    as _i379;
import 'package:croduck_client/domain/usecases/send_message_usecase.dart'
    as _i19;
import 'package:croduck_client/presentation/bloc/chat_bloc.dart' as _i33;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:sqflite/sqflite.dart' as _i779;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i544.ChatLocalDataSource>(
      () => _i544.ChatLocalDataSourceImpl(gh<_i779.Database>()),
    );
    gh.factory<_i455.ChatRemoteDataSource>(
      () => _i455.ChatRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.factory<_i1063.ChatRepository>(
      () => _i498.ChatRepositoryImpl(
        gh<_i455.ChatRemoteDataSource>(),
        gh<_i544.ChatLocalDataSource>(),
      ),
    );
    gh.factory<_i379.GetMessagesUseCase>(
      () => _i379.GetMessagesUseCase(gh<_i1063.ChatRepository>()),
    );
    gh.factory<_i19.SendMessageUseCase>(
      () => _i19.SendMessageUseCase(gh<_i1063.ChatRepository>()),
    );
    gh.factory<_i33.ChatBloc>(
      () => _i33.ChatBloc(
        gh<_i379.GetMessagesUseCase>(),
        gh<_i19.SendMessageUseCase>(),
      ),
    );
    return this;
  }
}
