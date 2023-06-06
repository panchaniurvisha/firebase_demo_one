class Utils {
  bool emailValidator(String email) {
    RegExp regExp = RegExp(r'\S+@\S+\.\S+');
    return regExp.hasMatch(email);
  }

  bool passWordValidator(String password) {
    RegExp regExp = RegExp(r"(?=.\d)(?=.[a-z])(?=.[A-Z])(?=.\W)");
    return regExp.hasMatch(password);
  }

  bool phoneValidator(String contact) {
    RegExp regExp = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s./0-9]*$');
    return regExp.hasMatch(contact);
  }
}
