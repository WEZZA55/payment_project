// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/models/user_model/login_model.dart';
import 'package:flutter_application_1/shared/dio/dio_helper.dart';
import 'package:flutter_application_1/shared/dio/end_points.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'Login_state.dart';

class loginCubit extends Cubit<loginState> {
  loginCubit() : super(loginInitial());
  static loginCubit get(context) => BlocProvider.of(context);

  LoginModel model;
  void userlogin({
    @required String phone,
    @required String password,
    @required String typeOfUser,
  }) {
    var pas = utf8.encode(password);
    var hashPassword = sha256.convert(pas);
    typeOfUser = 'user';
    emit(loginloading());
    DioHelper.postData(
      url: LOGINs,
      data: {
        'phone': phone,
        'password': hashPassword.toString(),
        // 'type': 'user',
        'typeOfUser': typeOfUser.toString()
      },
    ).then((value) {
      model = LoginModel.fromJson(value.data);

      emit(loginsuccess(model));
    }).catchError((error) {
      emit(loginerror(error.toString()));
      print(error.toString());
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(loginpaswwordChange());
  }
}
