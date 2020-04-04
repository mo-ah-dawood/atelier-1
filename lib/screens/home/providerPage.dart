import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:atelier/models/providerModel.dart';
import 'package:atelier/screens/home/atelierUserCenter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_fade/image_fade.dart';
import 'home.dart';

class ProviderPage extends StatefulWidget {
  ProviderModel providerModel;
  ProviderPage({this.providerModel});
  @override
  _ProviderPageState createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: bloc.size().width,
                    height: 350,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Container(
                          width: bloc.size().width,
                          height: 350,
                          child:
                     FadeInImage(
                                    placeholder:AssetImage('assets/images/placeholder.gif'),

                            image:NetworkImage( widget.providerModel.image),
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned(
                          right: 20,
                          top: 40,
                          child: SmallIconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icons.arrow_back_ios,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Container(
                          height: 60,
                          width: bloc.size().width,
                          decoration: BoxDecoration(
                              color: hintAccent,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(35),
                                  topRight: Radius.circular(35))),
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
 Text(
                                      widget.providerModel.name??AppLocalizations.of(context).tr("myProduct.n"),
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ,
                              SizedBox(
                                height: 2,
                              ),
                              RatingBar(
                                initialRating: double.parse(widget.providerModel.rate??"0"),
                                minRating: 1,
                                glow: false,
                                textDirection: TextDirection.ltr,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 18,
                                ignoreGestures: true,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 2.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {},
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              widget.providerModel.mobile != null
                                  ? Text(
                                      widget.providerModel.mobile ??
                                          AppLocalizations.of(context)
                                              .tr("myProduct.empty"),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: hint),
                                    )
                                  : SizedBox(),
                              widget.providerModel.site_url != null
                                  ? Text(
                                      widget.providerModel
                                          .site_url, ////// مفروض الموقع
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: hint),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                          width: bloc.size().width / 1.5,
                          height: 130,
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).tr("myProduct.descrip"),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: hint),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 6),
                          width: bloc.size().width - 40,
                          child: Wrap(
                            children: <Widget>[
                              Text(
                                widget.providerModel.note ??
                                    AppLocalizations.of(context)
                                        .tr("myProduct.empty"), //مفروض الوصف
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: blackAccent),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          AppLocalizations.of(context).tr("myProduct.dresses"),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: hint),
                        ),
                        FutureBuilder(
                          future: getProviderProducts(widget.providerModel.id,context),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting)
                              return LoadingFullScreen();
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.data.length<1)
                              return Container(
                                margin: EdgeInsets.only(top: 6),
                                width: bloc.size().width - 40,
                                child: Wrap(
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of(context)
                                          .tr("myProduct.emptyDress"),
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
                                  childAspectRatio: 0.8,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.all(0),
                                  crossAxisCount: 2,
                                  scrollDirection: Axis.vertical,
                                  children: snapshot.data,
                                ),
                              );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
