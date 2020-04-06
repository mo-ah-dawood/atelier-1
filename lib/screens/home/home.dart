import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:atelier/models/homeModel.dart';
import 'package:atelier/models/productModel.dart';
import 'package:atelier/screens/login&signUp/payPackage.dart';
import 'package:atelier/screens/login&signUp/waitForAccept.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:atelier/models/providerModel.dart';
import 'package:atelier/screens/home/addDress.dart';
import 'package:image_fade/image_fade.dart';
import 'package:atelier/screens/home/allProviders.dart';
import 'package:atelier/screens/home/allUsedProducts.dart';
import 'package:atelier/screens/home/myProduct.dart';
import 'package:atelier/screens/home/product.dart';
import 'package:atelier/screens/home/providerDress.dart';
import 'package:atelier/screens/home/providerPage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  initState() {
    super.initState();
    _onRefresh();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    // monitor network fetch
    Map<String, List> dataOfHome = await refreshHome(context);
    if (mounted)
      setState(() {
        providers = dataOfHome['providers'];

        special = dataOfHome['special'];
        used = dataOfHome['used'];
      });
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  List<Widget> special = [
    LoadingFullScreen(),
  ];
  List<Widget> used = [LoadingFullScreen()];
  List<Widget> providers = [
    LoadingFullScreen(),
  ];
  ScrollController houses = ScrollController();
  ScrollController old = ScrollController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double safe = MediaQuery.of(context).padding.top;
    bloc.setDeviceSize(Size(size.width, size.height - safe));
    var data = EasyLocalizationProvider.of(context).data;
    String localCode = Localizations.localeOf(context).languageCode.toString();
    return EasyLocalizationProvider(
      data: data,
      child: SafeArea(
          child: Scaffold(
        body: SmartRefresher(
          header: BezierCircleHeader(),
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: () {
            _onRefresh();
          },
          enablePullUp: false,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 210,
                  width: size.width,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: bumbiAccent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).tr("home.houses"),
                              style: TextStyle(
                                  color: bumbi,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                            InkWell(
                              highlightColor: Colors.white,
                              onTap: () {
                                setState(() {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AllProviders()));
                                });
                              },
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: Image.asset(
                                    'assets/images/moreA.png'),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: size.width,
                        height: 170,
                        child: GridView.count(
                          childAspectRatio: 1.2,
                          controller: houses,
                          crossAxisCount: 1,
                          scrollDirection: Axis.horizontal,
                          children: providers,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 410,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: bumbiAccent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).tr("home.special"),
                              style: TextStyle(
                                  color: bumbi,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        
                        // alignment: Alignment.center,
                        // width: bloc.size().width,
                        child: StaggeredGridView.countBuilder(
                            itemCount: special.length,
                            crossAxisCount: 4,
                            staggeredTileBuilder: (int index) =>
                                new StaggeredTile.count(
                                    2, index.isEven ? 2.5 : 1.8),
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 4.0,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) => special[index]),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 210,
                  width: bloc.size().width,
                  child: Column(
                    children: <Widget>[
                      Container(
                                                padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: bumbiAccent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).tr("home.used"),
                              style: TextStyle(
                                  color: bumbi,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                            InkWell(
                              highlightColor: Colors.white,
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AllUsedProducts()));
                              },
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: Image.asset(
                                    'assets/images/moreA.png'),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        // width: size.width,
                        // height: 170,
                        child: GridView.count(
                          controller: old,
                          childAspectRatio: 1.2,
                          crossAxisCount: 1,
                          scrollDirection: Axis.horizontal,
                          children: used,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 0,
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class HouseCard extends StatelessWidget {
  Product product;
  bool fromproviderPage;
  bool mine;
  ProviderModel provider;
  HouseCard({this.provider, this.fromproviderPage, this.mine, this.product});
  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Container(
        margin: EdgeInsets.all(5),
        child: InkWell(
          onTap: () {
            product != null
                ? mine != null
                    ? Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyProduct(
                              product: product,
                            )))
                    : Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => fromproviderPage != null
                            ? ProviderDress(
                                product: product,
                              )
                            : NormalProduct(product: product)))
                : Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ProviderPage(providerModel: provider)));
          },
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: Container(
            child: Stack(
              fit: StackFit.expand,
              alignment: product != null
                  ? Alignment.bottomLeft
                  : Alignment.bottomRight,
              children: <Widget>[
                Container(
                    child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: imageOfCard(product, provider),
                )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Colors.white),
                            child: product != null
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        product.price,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        AppLocalizations.of(context)
                                            .tr("myProduct.moneyType"),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  )
                                : Text(
                                    provider.name ??
                                        AppLocalizations.of(context)
                                            .tr("myProduct.n"),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

imageOfCard(Product product, ProviderModel provider) {
  try {
    return Container(
      constraints: BoxConstraints(minHeight: 10, maxHeight: 500),
      child: FadeInImage(
        image:
            NetworkImage(product != null ? product.images[0] : provider.image),
        placeholder: AssetImage('assets/images/placeholder.gif'),
        fit: BoxFit.fill,
      ),
    );
  } catch (e) {
    return print(e);
  }
}
