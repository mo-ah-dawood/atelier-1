import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:atelier/models/providerModel.dart';
import 'package:atelier/screens/home/atelierUserCenter.dart';
import 'package:atelier/screens/home/home.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';


class AllProviders extends StatefulWidget {
  @override
  _AllProvidersState createState() => _AllProvidersState();
}

class _AllProvidersState extends State<AllProviders> {
  loadAll()async{
List<Widget> all=await getAllProviders();
if(mounted)
setState(() {
  allProviders=all;
});
  }
  List<Widget> allProviders=[LoadingFullScreen()];
  @override
  void initState() {
loadAll();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: WillPopScope(
        onWillPop: () {
Navigator.of(context).pop();
          return Future.value(false);
        },
        child: Scaffold(
          body: Container(
            width: bloc.size().width,
            height: bloc.size().height,
            padding: EdgeInsets.only(left: 20, right: 20, top: 40),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SmallIconButton(
                        icon: Icons.arrow_back_ios,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        padding: EdgeInsets.all(0),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        AppLocalizations.of(context).tr("myProduct.allProviders"),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: bloc.size().width - 50,
                    height: bloc.size().height - 90,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: bloc.size().width - 50,
                          height: bloc.size().height - 90,
                          child: GridView.count(
                            childAspectRatio: .8,
                            crossAxisCount: 2,
                            padding: EdgeInsets.only(top: 0),
                            scrollDirection: Axis.vertical,
                            physics: BouncingScrollPhysics(),
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            children: allProviders,
                          ),
                        ),
                        
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
