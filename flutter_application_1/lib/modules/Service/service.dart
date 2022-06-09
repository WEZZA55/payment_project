// ignore_for_file: missing_required_param, prefer_const_constructors, avoid_print

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/service_model/get_service_model.dart';

import 'package:flutter_application_1/modules/Service/cubit/service_cubit.dart';
import 'package:flutter_application_1/modules/payment/Payment.dart';

import 'package:flutter_application_1/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../shared/global.dart';

class Service_Screen extends StatefulWidget {
  @override
  State<Service_Screen> createState() => _Service_ScreenState();
}

class _Service_ScreenState extends State<Service_Screen> {
  var pricenumber = TextEditingController();

  var text = TextEditingController();

  var number = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  // var itemDropDown;

  DataModel datamodel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          ServiceCubit()..companyData(Gloablvar.itemsOfDropDown),
      child: BlocConsumer<ServiceCubit, ServiceState>(
        listener: (BuildContext context, state) {
          if (state is Servicesuccess) {
            if (state.model.status) {
              var client_id = Gloablvar.id;
              Gloablvar.Paymentid = state.model.data.id;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Payment(),
                ),
              );

              // print(state.model.message);
            } else if (state is Serviceerror) {
              // print(state.model.message);
              Fluttertoast.showToast(
                msg: 'not found servicecode',
                backgroundColor: Colors.red,
                fontSize: 16,
                gravity: ToastGravity.BOTTOM,
              );
            }
          }
        },
        builder: (context, state) {
          var cubit = ServiceCubit.get(context);
          // var succes = cubit.companyData(text);
          // print(succes);
          DataModel Companymodel;
          // print(cubit.itemsOfDropDown);

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) => Homelayout()));
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back)),
              title:
                  Text(cubit.ChosseService[Global.indexOfServices].toString()),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    defaultFormField(
                        controller: number,
                        type: TextInputType.number,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return 'Please Enter code';
                          }
                        },
                        label: cubit.Servicecode[Global.indexOfServices]
                            .toString()),
                    SizedBox(
                      height: 18,
                    ),
                    DropdownButtonFormField(
                      hint: Text('Select Company'),
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      menuMaxHeight: 250,
                      items: Gloablvar.itemsOfDropDown
                          .map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          child: Text(value),
                          value: value,
                        );
                      }).toList(),
                      onChanged: (index) {
                        setState(() {
                          Gloablvar.dropdownitem = index;
                        });
                      },
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    defaultFormField(
                      controller: pricenumber,
                      type: TextInputType.number,
                      validate: (String value) {
                        if (value.isEmpty) {
                          return 'Please Enter price';
                        }
                      },
                      label: 'price',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ConditionalBuilder(
                      fallback: (context) => CircularProgressIndicator(),
                      condition: state is! Serviceloading,
                      builder: (context) => defaultButton(
                        text: 'pay',
                        function: () {
                          if (_formKey.currentState.validate()) {
                            ServiceCubit.get(context).userService(
                              // phone: phoneController.text,
                              // password: passwordController.text
                              service_code: number.text,
                              price: double.parse(pricenumber.text),
                              company_name: Gloablvar.dropdownitem.toString(),
                              client_id: Gloablvar.id,
                            );
                            // print(Gloablvar.feeds);

                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
