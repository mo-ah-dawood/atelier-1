import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:atelier/models/productModel.dart';
import 'package:atelier/models/providerModel.dart';
import 'package:atelier/screens/home/addDress.dart';
import 'package:atelier/screens/home/home.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_fade/image_fade.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
            bloc.onDressNameChange(null);
      bloc.onDressPriceChange(null);
      bloc.onDressDescripChange(null); 
                                    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Container(
                  width: bloc.size().width,
                  height: bloc.size().height,
                  child: profile(context)),
             Positioned(
                        left: bloc.lang()=="ar"?20:null,
                        right: bloc.lang()=="ar"?null:20,
                        bottom: 20,
                        child: BumbiIconButton(
                          color: bumbi,
                        
                          child: Container(
                            width: 30,
                            height: 30,
                            child: MaterialButton(
                              highlightColor: bumbiAccent.withOpacity(0.2),
                              highlightElevation: 2,
                              splashColor: bumbiAccent.withOpacity(.3),
                              padding: EdgeInsets.all(0),
                              onPressed: () {    
                                        bloc.onDressNameChange(null);
      bloc.onMobileChange(null); /////////////////////////

      bloc.onDressPriceChange(null);
      bloc.onDressDescripChange(null); 
      bloc.onDressImagesChange(null);

                                                        Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AddDress()));
},
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Image.asset(
                                'assets/images/add_dress.png',
                                width: 40,
                                height: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed: () {
                          },
                        ),
                      )
            ],
          ),
        ),
      ),
    );
  }
}

profile(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      children: <Widget>[
        Container(
          alignment: Alignment.topRight,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(45),
                  bottomLeft: Radius.circular(45))),
          padding: EdgeInsets.only(left: 10, right: 15, top: 10, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 120,
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  constraints: BoxConstraints(
                      maxWidth: bloc.size().width / 3, maxHeight: 130),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child:
                     FadeInImage(
                                    placeholder:AssetImage('assets/images/placeholder.gif'),

                        image:NetworkImage(bloc.currentUser().image),
                      )),
                ),
              ),
              Text(
                bloc.currentUser().name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                bloc.currentUser().email,
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w500, color: hint),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.only(right:bloc.lang()=="ar"? 20:0,left: bloc.lang()=="ar"?0:20, top: 10),
          alignment: bloc.lang()=="ar"?Alignment.topRight:Alignment.topLeft,
          child: Text(
            AppLocalizations.of(context).tr("profile.myProducts"),
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: hint),
          ),
        ),
        FutureBuilder(
          future: getProviderProducts(bloc.currentUser().id,context, mine: true),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return LoadingFullScreen();
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data.length < 1)
              return Container(
                margin: EdgeInsets.only(top: 6),
                width: bloc.size().width - 40,
                child: Wrap(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).tr("myProduct.emptyDress"),
                      style: TextStyle(
                          color: blackAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            else
              return Container(
                margin: EdgeInsets.only(top: 6),
                width: bloc.size().width - 40,
                height: (30 + bloc.size().width / 2) *
                    ((snapshot.data.length / 2).ceil()),
                child: GridView.count(
                  childAspectRatio: .8,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(0),
                  crossAxisCount: 2,
                  scrollDirection: Axis.vertical,
                  children: snapshot.data,
                ),
              );
          },
        ),
        SizedBox(
          height: 10,
        )
      ],
    ),
  );
}
