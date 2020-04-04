import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:atelier/screens/home/atelierUserCenter.dart';
import 'package:atelier/models/productModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';

import 'addDress.dart';

class AllUsedProducts extends StatefulWidget {
  @override
  _AllUsedProductsState createState() => _AllUsedProductsState();
}

class _AllUsedProductsState extends State<AllUsedProducts> {
    loadAllProducts()async{
List<Widget> all=await getAllUsedProducts(context);
if(mounted)
setState(() {
  allUsed=all;
});
  }
    List<Widget>allUsed=[LoadingFullScreen()];
@override
  void initState() {
loadAllProducts();
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
                        AppLocalizations.of(context).tr("myProduct.allUsed"),
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
                            childAspectRatio: 0.8,
                            crossAxisCount: 2,
                            padding: EdgeInsets.only(top: 0),
                            scrollDirection: Axis.vertical,
                            physics: BouncingScrollPhysics(),
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            children: allUsed
                          ),
                        ),
                       Positioned(
                        left: bloc.lang()=="ar"?0:null,
                        right: bloc.lang()=="ar"?null:0,
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
