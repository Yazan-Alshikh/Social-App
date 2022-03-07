abstract class LoginStatus {}

class LoginInitialStatue extends LoginStatus {}

class LoginSuccessStatue extends LoginStatus {
  final String uId;

  LoginSuccessStatue(this.uId);

}

class LoginLoadingStatue extends LoginStatus {}

class LoginErrorStatue extends LoginStatus {}

class LoginShowPasswordStatue extends LoginStatus {}
