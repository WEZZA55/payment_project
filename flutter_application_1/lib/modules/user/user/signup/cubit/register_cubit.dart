// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/models/user_model/register_model.dart';
import 'package:flutter_application_1/modules/user/user/reset%20password/RsetPasswprd.dart';
import 'package:flutter_application_1/shared/dio/dio_helper.dart';
import 'package:flutter_application_1/shared/dio/end_points.dart';
import 'package:flutter_application_1/shared/global.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uuid/uuid.dart';

import '../../../../../models/reset_model/reset_model.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  static RegisterCubit get(context) => BlocProvider.of(context);

  RegisterModel model;
  void userRegister({
    String name,
    String phone,
    String password,
    String salt,
    String typeOfUser,

    // @required String email,
  }) {
    var uuid = Uuid();
    var salt = uuid.v4();
    var pas = utf8.encode(Gloablvar.passwordgenerate);
    var hashPassword = sha256.convert(pas);
    var newSalt = salt.replaceAll("-", "");
    typeOfUser = 'user';

    emit(Registerloading());

    DioHelper.postData(
      url: REIGSTERs,
      data: {
        'password': hashPassword.toString() + newSalt,
        'phone': Gloablvar.phone,
        'name': Gloablvar.name,
        'salt': newSalt,
        'typeOfUser': typeOfUser.toString()
      },
    ).then((value) {
      model = RegisterModel.fromJson(value.data);
      Gloablvar.id = model.data.id;
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

  ResetModel remodel;
  void CheakPassword({
    String client_id,
    String phone,
  }) {
    emit(Registerloading());
    DioHelper.postData(
      url: cheakuser,
      data: {
        //  'client_id': Gloablvar.id,
        'phone': phone,
      },
    ).then((value) {
      remodel = ResetModel.fromJson(value.data);
      Gloablvar.resetpasswordScreen = true;
      Gloablvar.phone = phone;
      // print(remodel.data);
      print(remodel.message);

      print(value.data);
      emit(Checksuccess(remodel));
    }).catchError((error) {
      emit(Checkererror(error.toString()));
      print(error.toString());
    });
  }

  void reset({
    String otp,
    String phone,
  }) {
    emit(Registerloading());
    DioHelper.postData(
      url: cheakreset,
      data: {
        'otp': otp,
        'phone': Gloablvar.phone,
      },
    ).then((value) {
      remodel = ResetModel.fromJson(value.data);

      // print(remodel.data);
      print(remodel.message);

      print(value.data);
      emit(Checksuccess(remodel));
    }).catchError((error) {
      emit(Checkererror(error.toString()));
      print(error.toString());
    });
  }
}
