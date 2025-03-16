class IntroServices {
  Future<String> mockLoginApi(String buttonName) async {
    await Future.delayed(Duration(seconds: 2));
    if (buttonName == "Google Login" || buttonName == "Apple Login") {
      return "success";
    } else {
      return "failure";
    }
  }
}
