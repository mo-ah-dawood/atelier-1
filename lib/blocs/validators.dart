import 'dart:async';

class Validators {
  final emailValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (emailStream, sink) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (emailStream != null) {
      if (!regex.hasMatch(emailStream) || emailStream.isEmpty)
        sink.addError("emailValidate");
      else
        sink.add(emailStream);
    } else
      sink.addError("emailValidate");
  });

  final passwordValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (passwordStream, sink) {
    if (passwordStream != null) {
      if (passwordStream.length >= 6)
        sink.add(passwordStream);
      else
        sink.addError("passwordValidate");
    }
  });
  final oldPasswordValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (oldPasswordStream, sink) {
    if (oldPasswordStream != null) {
      if (oldPasswordStream.length >= 6)
        sink.add(oldPasswordStream);
      else
        sink.addError("passwordValidate");
    }
  });

  final mobileValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (mobileStream, sink) {
    if (mobileStream != null) {
      if (mobileStream.length != 10 ||
          (mobileStream[0]!="0"||mobileStream[1]!="5"))
            sink.addError("mobileValidate");

      else
              sink.add(mobileStream);

    }else
                sink.addError("mobileValidate");

  });

  final dressdescripValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (dressDescripStream, sink) {
    if (dressDescripStream != null)
      sink.add(dressDescripStream);
    else
      sink.addError("empty");
  });

  final dressNameValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (dressNameStream, sink) {
    if (dressNameStream != null && dressNameStream.length > 0)
      sink.add(dressNameStream);
    else
      sink.addError("empty");
  });
  final dressPriceValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (dressPriceStream, sink) {
    if (double.tryParse(dressPriceStream) == null)
      sink.addError("empty");
    else
      sink.add(dressPriceStream);
  });
  final nameValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (nameStream, sink) {
    if (nameStream == null || nameStream.isEmpty)
      sink.addError("empty");
    else
      sink.add(nameStream);
  });
}
