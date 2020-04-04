import 'package:atelier/blocs/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:async';

class UserService {
  int status;
  String msg;
  String activation_code;
  String apiToken;
  int id;
  String name;
  String type;
  int package_id;
  String mobile;
  String email;
  String image;
  String rate;
  String site_url;
  String note;
  String admin_status;
//// construct
  UserService(
      {this.status,
      this.email,
      this.msg,
      this.package_id,
      this.rate,
      this.admin_status,
      this.id,
      this.name,
      this.type,
      this.mobile,
      this.image,
      this.activation_code,
      this.apiToken,
      this.note,
      this.site_url});

  factory UserService.fromJson(Map<String, dynamic> user) {
    try {
      if (user['status'] == 200) {
        Map<String, dynamic> userData = user['data'];
        return UserService(
            status: user['status'],
            activation_code: user['activation_code'].toString(),
            admin_status: user['admin_status'],
            apiToken: user['apiToken'],
            package_id: userData['package_id'],
            id: userData['id'],
            rate: userData["rate"],
            name: userData['name'],
            type: userData['type'],
            mobile: userData['mobile'],
            image: userData['image'],
            email: userData['email'],
            site_url: userData['site_url'],
            note: userData['note']);
      } else
        return UserService(status: user['status'], msg: user['msg']);
    } catch (e) {
      return UserService(status: 501, msg: e.toString());
    }
  }
  List<String> toListData() {
    return [
      "$type" ?? "null",
      "$activation_code" ?? "null",
      "$admin_status" ?? "null",
      "$package_id" ?? "null",
      "$name" ?? "null",
      "$email" ?? "null",
      "$mobile" ?? "null",
      "$image" ?? "null",
      "$site_url" ?? "",
      "$note" ?? "",
      "$apiToken" ?? "null",
      "$id"??"null"
    ];
  }

  factory UserService.fromList(List<String> userData) {
    try {
      if (userData[0] != "null") {
        return UserService(
          type: userData[0],
          activation_code: userData[1],
          admin_status: userData[2],
          package_id:int.tryParse(userData[3]),
          name: userData[4],
          email: userData[5],
          mobile: userData[6],
          image: userData[7],
          site_url: userData[8]=="null"?"":userData[8],
          note:  userData[9]=="null"?"":userData[9],
          apiToken: userData[10],
          id: int.tryParse(userData[11]),
        );
      } else
        return UserService(msg:'logIn');
    } catch (e) {
      return UserService(msg: e.toString());
    }
  }
}

Future loginPost() async {
  http.Response response =
      await http.post("https://atelierapps.com/api/v1/user/login", body: {
    "email": bloc.email(),
    "password": bloc.password(),
    "device_token": bloc.deviceToken(),
    "device_type": bloc.deviceType(),
    "type": bloc.userType()
  }, headers: {
    "lang": bloc.lang()??"ar"
  });
  final loginJson = json.decode(response.body);
  UserService newUser = UserService.fromJson(loginJson);
  if (newUser.status == 200) {
    bloc.sendNewUser(newUser);
    bloc.sendErrorUser(UserService(status: null, msg: null));
    await updateLocalUser(newUser);
  } else{
    
    bloc.sendErrorUser(newUser);
  }
}

Future signUpUser() async {
  http.Response response =
      await http.post("https://atelierapps.com/api/v1/user", body: {
    "name": bloc.name(),
    "email": bloc.email(),
    "password": bloc.password(),
    "mobile": bloc.mobile(),
    "device_token": bloc.deviceToken(),
    "device_type": bloc.deviceType(),
    "type": bloc.userType()
  }, headers: {
    "lang": bloc.lang() ?? "ar"
  });
  final signUpJson = json.decode(response.body);
  UserService newUser = UserService.fromJson(signUpJson);
  if (newUser.status == 200) {
    bloc.sendNewUser(newUser);
    bloc.sendErrorUser(UserService(status: null, msg: null));
    await updateLocalUser(newUser);
  } else
    bloc.sendErrorUser(newUser);
}

Future signUpProvider() async {
  final mimeTypeData =
      lookupMimeType(bloc.houseImage().path, headerBytes: [0xFF, 0xD8])
          .split('/');
  final imageUploadRequest = http.MultipartRequest(
      'POST', Uri.parse("https://atelierapps.com/api/v1/user"))
    ..fields.addAll({
      "name": bloc.name(),
      "email": bloc.email(),
      "password": bloc.password(),
      "site_url": bloc.site() ?? "",
      "mobile": bloc.mobile(),
      "device_token": bloc.deviceToken(),
      "device_type": bloc.deviceType(),
      "type": bloc.userType(),
      "note": bloc.note()
    })
    ..headers['lang'] = bloc.lang() ?? "ar";
  final file = await http.MultipartFile.fromPath(
      'image', bloc.houseImage().path,
      contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
  imageUploadRequest.files.add(file);
  try {
    final streamedResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamedResponse);
    final signUpJson = json.decode(response.body);
    UserService newUser = UserService.fromJson(signUpJson);
    if (newUser.status == 200) {
      bloc.sendNewUser(newUser);
      bloc.sendErrorUser(UserService(status: null, msg: null));
      await updateLocalUser(newUser);
    } else
      bloc.sendErrorUser(newUser);
  } catch (e) {
    print(e);
  }
}

Future resendCode() async {
  http.Response response = await http
      .post("https://atelierapps.com/api/v1/user/resend_code", body: {
    "email": bloc.email(),
  }, headers: {
    "lang": bloc.lang() ?? "ar"
  });
  final resendJson = json.decode(response.body);
  UserService newUser = UserService.fromJson(resendJson);
  if (newUser.status == 200) {
    bloc.sendNewUser(newUser);
    bloc.sendErrorUser(UserService(status: null, msg: null));
    await updateLocalUser(newUser);
  } else
    bloc.sendErrorUser(newUser);
}

Future updatePassword() async {
  http.Response response = await http
      .post("https://atelierapps.com/api/v1/user/update_password", body: {
    "old_pass": bloc.oldPassword(),
    "new_pass": bloc.password()
  }, headers: {
    "apiToken": "sa3d01${bloc.currentUser().apiToken}",
    "lang": bloc.lang() ?? "ar"
  });
  final resendJson = json.decode(response.body);
  UserService newUser = UserService.fromJson(resendJson);
  if (newUser.status == 200) {
    bloc.sendNewUser(newUser);
    bloc.sendErrorUser(UserService(status: null, msg: null));
    await updateLocalUser(newUser);
  } else
    bloc.sendErrorUser(newUser);
}

Future resetPassword() async {
  http.Response response = await http
      .post("https://atelierapps.com/api/v1/user/reset_password", headers: {
    "apiToken": "sa3d01${bloc.currentUser().apiToken}",
    "lang": bloc.lang() ?? "ar"
  }, body: {
    "password": bloc.password(),
  });
  final resendJson = json.decode(response.body);
  UserService newUser = UserService.fromJson(resendJson);
  if (newUser.status == 200) {
    bloc.sendNewUser(newUser);

    bloc.sendErrorUser(UserService(status: null, msg: null));
    await updateLocalUser(newUser);
  } else
    bloc.sendErrorUser(newUser);
}

Future activate() async {
  http.Response response =
      await http.post("https://atelierapps.com/api/v1/user/activate", body: {
    "activation_code": bloc.code(),
  }, headers: {
    "apiToken": "sa3d01${bloc.currentUser().apiToken}",
    "lang": bloc.lang() ?? "ar"
  });
  final resendJson = json.decode(response.body);
  UserService newUser = UserService.fromJson(resendJson);
  if (newUser.status == 200) {
    await updateLocalUser(newUser);
    bloc.sendNewUser(newUser);
    bloc.sendErrorUser(UserService(status: null, msg: null));
  } else
    bloc.sendErrorUser(newUser);
}

Future getProfile() async {
  http.Response response = await http
      .get("https://atelierapps.com/api/v1/user/1", headers: {
    "apiToken": "sa3d01${bloc.currentUser().apiToken}",
    "lang": bloc.lang() ?? "ar"
  });
  final profileJson = json.decode(response.body);
  UserService newUser = UserService.fromJson(profileJson);
  if (newUser.status == 200) {
    bloc.sendNewUser(newUser);

    bloc.sendErrorUser(UserService(status: null, msg: null));
    await updateLocalUser(newUser);
  } else
    bloc.sendErrorUser(newUser);
}

Future updateProviderProfile() async {
  if (bloc.houseImage() != null) {
    final mimeTypeData =
        lookupMimeType(bloc.houseImage().path, headerBytes: [0xFF, 0xD8])
            .split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST', Uri.parse("https://atelierapps.com/api/v1/user/update"))
      ..fields.addAll({
        "name": bloc.name(),
        "email": bloc.email(),
        "site_url": bloc.site() ?? "",
        "mobile": bloc.mobile(),
        "note": bloc.note() ?? ""
      })
      ..headers['apiToken'] = "sa3d01${bloc.currentUser().apiToken}"
      ;
    final file = await http.MultipartFile.fromPath(
        'image', bloc.houseImage().path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    imageUploadRequest.files.add(file);
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      final signUpJson = json.decode(response.body);
      UserService newUser = UserService.fromJson(signUpJson);
      if (newUser.status == 200) {
        bloc.sendNewUser(newUser);

        bloc.sendErrorUser(UserService(status: null, msg: null));
        await updateLocalUser(newUser);
      } else
        bloc.sendErrorUser(newUser);
    } catch (e) {
      print(e);
    }
  } else {
    http.Response response =
        await http.post("https://atelierapps.com/api/v1/user/update", body: {
      "name": bloc.name(),
      "email": bloc.email(),
      "site_url": bloc.site() ?? "",
      "mobile": bloc.mobile(),
      "note": bloc.note()?? ""
    }, headers: {
      "apiToken": "sa3d01${bloc.currentUser().apiToken}",
      "lang": bloc.lang() ?? "ar"
    });
    final providerJson = json.decode(response.body);
    UserService newUser = UserService.fromJson(providerJson);
    if (newUser.status == 200) {
      bloc.sendNewUser(newUser);
      bloc.sendErrorUser(UserService(status: null, msg: null));
      await updateLocalUser(newUser);
    } else
      bloc.sendErrorUser(newUser);
  }
}

Future updateUserProfile() async {
  if (bloc.userImage() != null) {
    final mimeTypeData =
        lookupMimeType(bloc.userImage().path, headerBytes: [0xFF, 0xD8])
            .split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST', Uri.parse("https://atelierapps.com/api/v1/user/update"))
      ..fields.addAll({
        "name": bloc.name(),
        "email": bloc.email(),
        "mobile": bloc.mobile(),
      })
      ..headers['apiToken'] = "sa3d01${bloc.currentUser().apiToken}"
     ;
    final file = await http.MultipartFile.fromPath(
        'image', bloc.userImage().path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    imageUploadRequest.files.add(file);
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      final signUpJson = json.decode(response.body);
      UserService newUser = UserService.fromJson(signUpJson);
      if (newUser.status == 200) {
        bloc.sendNewUser(newUser);

        bloc.sendErrorUser(UserService(status: null, msg: null));
        await updateLocalUser(newUser);
      } else
        bloc.sendErrorUser(newUser);
    } catch (e) {
      print(e);
    }
  } else {
    http.Response response =
        await http.post("https://atelierapps.com/api/v1/user/update", body: {
      "name": bloc.name(),
      "email": bloc.email(),
      "mobile": bloc.mobile(),
    }, headers: {
      "apiToken": "sa3d01${bloc.currentUser().apiToken}",
      "lang": bloc.lang() ?? "ar"
    });
    final providerJson = json.decode(response.body);
    UserService newUser = UserService.fromJson(providerJson);
    if (newUser.status == 200) {
      bloc.sendNewUser(newUser);
      bloc.sendErrorUser(UserService(status: null, msg: null));
      await updateLocalUser(newUser);
    } else
      bloc.sendErrorUser(newUser);
  }
}
