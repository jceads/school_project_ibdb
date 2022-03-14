import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_project_ibdb/core/constants/string_constants.dart';
import 'package:school_project_ibdb/core/custom/custom_btn.dart';
import 'package:school_project_ibdb/core/custom/custom_sized_box.dart';
import 'package:school_project_ibdb/feature/sign_up/sign_up_view.dart';
import '../../../core/enum/padding_values.dart';
import '../../search_view/search_view.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/custom/input_dec_custom.dart';

import '../../../core/custom/login_button_custom.dart';
import '../service/i_user_service.dart';
import '../view_model/login_screen_view_model.dart';

class LoginScreenView extends StatelessWidget {
  LoginScreenView({Key? key}) : super(key: key);
  bool isChecked = false;

  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final FocusNode nodeMail = FocusNode();
  final FocusNode nodePass = FocusNode();
  StringConstants constants = StringConstants();

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => LoginScreenCubit(
        formKey: formKey,
        mailController: mailController,
        passController: passController,
        service: UserLoginService(Dio(BaseOptions(baseUrl: "GONNA CHANGE"))),
      ),
      child: BlocConsumer<LoginScreenCubit, LoginScreenState>(
        listener: (context, state) {
          if (state is LoginSucces) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const SearchView(),
            ));
          } else if (state is LoginValidateState) {
            if (state.isValidate == true) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Text("failed");
                  });
            }
          }
        },
        builder: (context, state) {
          if (state is LoginLoadingState) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else {
            return ScaffoldMethod(
                _width, _height, context, mailController, passController);
          }
        },
      ),
    );
  }

  Scaffold ScaffoldMethod(double _width, double _height, BuildContext context,
      mailController, passController) {
    return Scaffold(
      body: Padding(
        padding: PaddingValues.min.rawValues(context),
        child: SingleChildScrollView(
          physics: (nodeMail.hasFocus || nodePass.hasFocus)
              ? AlwaysScrollableScrollPhysics()
              : NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              customSizedBox(context, 10),
              Text(constants.appName,
                  style: Theme.of(context).textTheme.headline1),
              FormBuild(_height, mailController, context, passController)
            ],
          ),
        ),
      ),
    );
  }

  Form FormBuild(
      double _height, mailController, BuildContext context, passController) {
    return Form(
        key: formKey,
        autovalidateMode: AutovalidateMode
            .onUserInteraction, //TODO: REFACTOR WITH STATE CONTROL
        child: Column(
          children: [
            SizedBox(height: _height * 0.05),
            mailFormField(mailController, context),
            SizedBox(height: _height * 0.05),
            passFormField(passController, context),
            SizedBox(height: _height * 0.05),
            optionsRow(context),
            SizedBox(height: _height * 0.05),
            CustomBtn(constants.signIn, () {
              context.read<LoginScreenCubit>().sendRequest();
            }, context),
            SizedBox(height: _height * 0.05),
            signUpBtn(context)
          ],
        ));
  }

  Row optionsRow(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        checkBox(context),
        Text(constants.stayLogged),
      ]),
      forgotPassBtn(),
    ]);
  }

  TextButton signUpBtn(context) {
    return TextButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SignUpView(),
          ));
        },
        child: Text(constants.signUp));
  }

  ElevatedButton signInBtn(BuildContext context, String mail, String password) {
    //asdasd
    return ElevatedButton(
        onPressed: () {
          context.read<LoginScreenCubit>().sendRequest();
        },
        child: Text(constants.signIn, style: const TextStyle(fontSize: 20)),
        style: LoginBtnCustomStyle(context, ColorConstants.secondaryColor));
  }

  TextButton forgotPassBtn() {
    return TextButton(child: Text(constants.forgetPassword), onPressed: () {});
  }

  Checkbox checkBox(BuildContext context) {
    return Checkbox(
      fillColor:
          MaterialStateProperty.all<Color>(ColorConstants.secondaryColor),
      value: context.read<LoginScreenCubit>().isChecked,
      onChanged: (val) {
        context.read<LoginScreenCubit>().changeChecker(val);
      },
    );
  }

  Widget passFormField(passController, BuildContext context) {
    bool val = context.read<LoginScreenCubit>().isObsecure;
    return TextFormField(
      controller: passController,
      focusNode: nodePass,
      obscureText: val,
      decoration: InputDecCustom(constants.passwordHint,
          iconButton: IconButton(
              icon: Icon(
                  val ? Icons.remove_red_eye : Icons.remove_red_eye_outlined),
              onPressed: () {
                context.read<LoginScreenCubit>().changeObsecure();
              })),
    );
  }

  TextFormField mailFormField(mailController, context) {
    return TextFormField(
        keyboardType: TextInputType.emailAddress,
        cursorColor: ColorConstants.secondaryColor,
        focusNode: nodeMail,
        controller: mailController,
        validator: ((value) => (value ?? "").contains("@") == false
            ? "Please enter valid mail"
            : ((value ?? "").contains(".") == false)
                ? "Please enter valid mail"
                : null),
        decoration: InputDecCustom(constants.eMailHint));
  }
}
