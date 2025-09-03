import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:myapp/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:myapp/core/network/connection_checker.dart';
import 'package:myapp/core/secrets/app_secrets.dart';
import 'package:myapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:myapp/features/auth/data/respository/auth_repository_impl.dart';
import 'package:myapp/features/auth/domain/repository/auth_repository.dart';
import 'package:myapp/features/auth/domain/usecases/current_user.dart';
import 'package:myapp/features/auth/domain/usecases/user_login.dart';
import 'package:myapp/features/auth/domain/usecases/user_sign_up.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myapp/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:myapp/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:myapp/features/blog/data/respositories/blog_repository_impl.dart';
import 'package:myapp/features/blog/domain/repositories/blog_repository.dart';
import 'package:myapp/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:myapp/features/blog/domain/usecases/upload_blog.dart';
import 'package:myapp/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path_provider/path_provider.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();

  final supabse = await Supabase.initialize(
    url: AppSecrets.supabaseUrl, anonKey: AppSecrets.anonKey
  );

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(() => Hive.box(
    name: 'blogs'
  ));

  serviceLocator.registerLazySingleton(() => supabse.client);

  serviceLocator.registerFactory(() => InternetConnection());

  // core
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );
  serviceLocator.registerFactory<ConnectionChecker>(() => ConnectionCheckerImpl(
    serviceLocator.get(),
  ));
}

void _initAuth() {
  serviceLocator..registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      supabaseClient: serviceLocator()
    ),
  )..registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
      serviceLocator(),
    ),
  )..registerFactory(
    () => UserSignUp(
      serviceLocator()
    ),
  )..registerFactory(
    () => UserLogin(
      serviceLocator()
    )
  )..registerFactory(
    () => CurrentUser(
      serviceLocator()
    )
  )..registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
    )
  );
}

void _initBlog() {
  serviceLocator..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => BlogLocalDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UploadBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllBlogs(
        serviceLocator(),
      )
    )
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),
    );
}