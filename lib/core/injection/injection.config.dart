// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:croduck_client/adapter/persistence/chat_persistence.dart'
    as _i490;
import 'package:croduck_client/application/usecases/get_messages_usecase.dart'
    as _i788;
import 'package:croduck_client/application/usecases/send_message_usecase.dart'
    as _i644;
import 'package:croduck_client/core/injection/third_party_module.dart' as _i711;
import 'package:croduck_client/domain/repositories/chat_repository.dart'
    as _i1063;
import 'package:croduck_client/infrastructure/data/local/chat_local_datasource.dart'
    as _i184;
import 'package:croduck_client/infrastructure/data/remote/chat_remote_datasource.dart'
    as _i74;
import 'package:croduck_client/presentation/bloc/chat_bloc.dart' as _i33;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:sqflite/sqflite.dart' as _i779;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final thirdPartyModule = _$ThirdPartyModule();
    await gh.factoryAsync<_i779.Database>(
      () => thirdPartyModule.database,
      preResolve: true,
    );
    gh.lazySingleton<_i361.Dio>(() => thirdPartyModule.dio);
    gh.factory<_i74.ChatRemoteDataSource>(
      () => _i74.ChatRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.factory<_i184.ChatLocalDataSource>(
      () => _i184.ChatLocalDataSourceImpl(gh<_i779.Database>()),
    );
    gh.factory<_i1063.ChatRepository>(
      () => _i490.ChatPersistence(
        gh<_i74.ChatRemoteDataSource>(),
        gh<_i184.ChatLocalDataSource>(),
      ),
    );
    gh.factory<_i788.GetMessagesUseCase>(
      () => _i788.GetMessagesUseCase(gh<_i1063.ChatRepository>()),
    );
    gh.factory<_i644.SendMessageUseCase>(
      () => _i644.SendMessageUseCase(gh<_i1063.ChatRepository>()),
    );
    gh.factory<_i33.ChatBloc>(
      () => _i33.ChatBloc(
        gh<_i788.GetMessagesUseCase>(),
        gh<_i644.SendMessageUseCase>(),
      ),
    );
    return this;
  }
}

class _$ThirdPartyModule extends _i711.ThirdPartyModule {}
