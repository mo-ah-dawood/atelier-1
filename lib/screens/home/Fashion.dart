import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:atelier/models/articleModel.dart';
import 'package:atelier/screens/home/fashionArticle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Fashion extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffold;
    PersistentBottomSheetController controller; // <------ Instance variable
  Fashion({this.scaffold,this.controller});
  @override
  _FashionState createState() => _FashionState();
}

class _FashionState extends State<Fashion> {
  @override
  void initState() {
            getArticlesOfCategory();

    super.initState();

  }
dispose(){
  super.dispose();
  bloc.selectFilter(0);
                                                if (bloc.categories() != null)
                                            bloc.changeCloseFilters(true);


  
}
      getArticlesOfCategory()async{
List<Widget> cards=[];
        bloc.updateFasionCards([LoadingFullScreen()]);
cards=await getAllArticles(category:bloc.selectedFilter(),context: context);
 if(mounted)
bloc.updateFasionCards(cards);
_refreshController.refreshCompleted();
  }
    RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<Widget> fashionCard = [
    LoadingFullScreen(),
  ];
  @override
  Widget build(BuildContext context) {
            

    
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: SafeArea(
          child: Scaffold(
              
        key: widget.scaffold,
        body: Container(
            width: bloc.size().width,
            height: bloc.size().height,
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              alignment: Alignment.center,
              width: bloc.size().width,
              child: SmartRefresher(
          onRefresh:()async{
            await getAllArticles(category: bloc.selectedFilter(),context: context);
            _refreshController.refreshCompleted();
       },
              header: BezierCircleHeader(),
              controller: _refreshController,
              enablePullDown: true,
          child: StreamBuilder<List<Widget>>(
            stream: bloc.fashionCardsStream,
            initialData: fashionCard,
            builder:(context,s){
              
              return StaggeredGridView.countBuilder(
                    itemCount:s.data.length??bloc.fashionCards.length,
                    crossAxisCount: 4,
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.count(2, index.isEven ? 2.5 : 1.53),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) => s.data[index]);},
          ),
            ),)
         
         
            ),
        
      )),
    );
  }
}

class FashionCard extends StatelessWidget {
  Article article;
  FashionCard({this.article});
  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: GestureDetector(
        onTap: (){

        },
        child: Container(
          margin: EdgeInsets.all(5),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>FashionArticle(article: article,)));
            },
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: Container(
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                            child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: FadeInImage(
                                                          placeholder:AssetImage('assets/images/placeholder.gif'),

                            image: NetworkImage(
                              article.images[0],
                            ),
                                                          fit: BoxFit.fill,

                          ),
                        )),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: 300,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                blurRadius: 50,
                                spreadRadius: 40,
                                color: Colors.white,
                                offset: Offset(0, 5))
                          ]),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                              child: Wrap(
                                children: <Widget>[
                                  Text(article.title,style:TextStyle(fontSize: 18,fontWeight: FontWeight.w600) ,),
                                ],
                              ),
                            ),
SizedBox(width: 5,),                            Image.asset(
                              'assets/images/readmore.png',
                              width: 16,
                              height: 16,
                            )
                          
                          ],
                        ),
                      )
                    ],
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
