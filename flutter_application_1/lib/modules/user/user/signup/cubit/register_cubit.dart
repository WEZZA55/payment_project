// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'package:flutter_application_1/models/user_model/register_model.dart';
import 'package:flutter_application_1/shared/dio/dio_helper.dart';
import 'package:flutter_application_1/shared/dio/end_points.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uuid/uuid.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  static RegisterCubit get(context) => BlocProvider.of(context);

  RegisterModel model;
  void userRegister({
    @required String name,
    @required String phone,
    // @required String password,
    @required String salt,
    @required String typeOfUser,

    // @required String email,
  }) {
    var uuid = Uuid();
    var salt = uuid.v4();
    // var pas = utf8.encode(password);
    // var hashPassword = sha256.convert(pas);
    typeOfUser = 'user';

    emit(Registerloading());

    DioHelper.postData(
      url: REIGSTERs,
      data: {
        // 'password': hashPassword.toString() + salt,
        'phone': phone,
        'name': name,
        'salt': salt,
        'typeOfUser': typeOfUser.toString()
      },
    ).then((value) {
      model = RegisterModel.fromJson(value.data);
      print(model.status);
      print(model.message);

      print(value.data);

      emit(Registersuccess(model));
    }).catchError((error) {
      print(error.toString());
      emit(Registererror(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(RegisterpaswwordChange());
  }
}
