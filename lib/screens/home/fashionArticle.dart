import 'dart:math';

import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:atelier/models/articleModel.dart';
import 'package:atelier/screens/home/AtelierProviderCenter.dart';
import 'package:atelier/screens/home/providerPage.dart';
import 'package:atelier/screens/home/userFashion.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:image_fade/image_fade.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class FashionArticle extends StatefulWidget {
  Article article;
  FashionArticle({this.article});
  @override
  _FashionArticleState createState() => _FashionArticleState();
}

class _FashionArticleState extends State<FashionArticle> {
  bool more = false;
  ProgressDialog loading;
  TextEditingController _controller = TextEditingController();
  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  initState() {
    super.initState();
    loading = ProgressDialog(context, type: ProgressDialogType.Normal);
    for (int i = 0; i < widget.article.images.length; i++)
      images.add(FullScreenWidget(
        child: FadeInImage(
          placeholder: AssetImage('assets/images/placeholder.gif'),
          image: NetworkImage(widget.article.images[i]),
          height: 350,
          fit: BoxFit.fill,
        ),
      ));
    refreshComments();

    for (int i = 0; i < min(3, bloc.comments.length); i++) {
      if (bloc.comments[i] != null) subComment.add(bloc.comments[i]);
    }
    if (bloc.comments.length > 3)
      setState(() {
        viewMoreButton = true;
      });
  }

  refreshComments() {
    List<Widget> comments = [];
    if (widget.article.comments != null)
      for (int i = 0; i < widget.article.comments.length; i++) {
        comments.add(
          CommentWidget(
            article: widget.article,
            comment: widget.article.comments[i],
          ),
        );
      }
    bloc.changecomments(comments);
  }

  _launchCaller(String mobile) async {
    String url = "tel:$mobile";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      scaffold.currentState.showSnackBar(SnackBar(
        content: Text("حاول مجدداً"),
      ));
    }
  }

  String comment;
  List<Widget> images = [];
  bool viewMoreButton = false;
  List<Widget> subComment = [];
  PageController controller = PageController(
    initialPage: 0,
  );
  @override
  Widget build(BuildContext context) {
    loading.style(
        progressWidget: LoadingFullScreen(),
        message: AppLocalizations.of(context).tr("comments.send"));

    var data = EasyLocalizationProvider.of(context).data;
    Size size = MediaQuery.of(context).size;
    return EasyLocalizationProvider(
      data: data,
      child: WillPopScope(
        onWillPop: () async {
          bloc.changerefreshArticles(true);
          if (bloc.currentUser().type == "user")
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => UserFashion()));
          else
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => AtelierProviderCenter(
                      screen: 2,
                    )));

          return false;
        },
        child: Scaffold(
          key: scaffold,
          body: Container(
            width: size.width,
            height: size.height,
            child: SingleChildScrollView(
              child: Column(
                // start of page
                children: <Widget>[
                  Container(
                    width: size.width,
                    height: bloc.size().height / 2,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Container(
                          // images
                          height: bloc.size().height / 2,
                          child: PageView(
                            controller: controller,
                            scrollDirection: Axis.horizontal,
                            children: images,
                            reverse: true,
                            pageSnapping: true,
                          ),
                        ),
                        Container(
                          //indicator
                          margin: EdgeInsets.only(bottom: 50),
                          child: SmoothPageIndicator(
                            controller: controller,
                            count: images.length,
                            effect: ExpandingDotsEffect(
                                dotHeight: 12,
                                dotWidth: 14,
                                dotColor: Colors.white.withOpacity(.85),
                                radius: 2),
                          ),
                        ),
                        Positioned(
                          //decoration
                          top: (bloc.size().height / 2) - 30,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffF9F9F9),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(45),
                                    topRight: Radius.circular(45))),
                            height: 35,
                            width: size.width,
                          ),
                        ),
                        Positioned(
                          // back button
                          top: 20,
                          child: Container(
                            width: size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SmallIconButton(
                                  icon: Icons.arrow_back_ios,
                                  onPressed: () {
                                    bloc.changerefreshArticles(true);
          if (bloc.currentUser().type == "user")
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => UserFashion()));
          else
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => AtelierProviderCenter(
                      screen: 2,
                    )));
                                  },
                                ),
                                SizedBox()
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ), //images slider

                  //////////////////////////////////////////////////////////////////////////////////////
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    alignment: bloc.lang() == "ar"
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    constraints:
                        BoxConstraints(minHeight: bloc.size().height / 2),
                    child: Stack(
                      overflow: Overflow.visible,
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.article.title ?? "",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Wrap(
                              children: <Widget>[
                                Text(
                                  widget.article.note ?? "",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            ),
                            Container(
                                alignment: Alignment.topRight,
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.only(top: 20),
                                width: bloc.size().width,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(.08),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        topRight: Radius.circular(25))),
                                child: StreamBuilder(
                                  stream: bloc.commentsStream,
                                  builder: (context, ss) => Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context)
                                            .tr("comments.comments"),
                                        style: TextStyle(
                                            fontSize: 14, color: hint),
                                      ),

                                      //////// comments
                                      Column(
                                          children:
                                              more ? ss.data : subComment),

                                      ss.data.length == 0
                                          ? Container(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .tr("comments.empty"),
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ))
                                          : viewMoreButton
                                              ? FlatButton(
                                                  // highlightColor:
                                                  //     bumbiAccent.withOpacity(.5),
                                                  // splashColor: Colors.red[50],
                                                  onPressed: () {
                                                    viewMoreButton
                                                        ? setState(() {
                                                            subComment.clear();
                                                            for (int i = 0;
                                                                i < 3;
                                                                i++) {
                                                              if (ss.data[i] !=
                                                                  null)
                                                                subComment.add(
                                                                    ss.data[i]);
                                                            }
                                                            more = !more;
                                                          })
                                                        : null;
                                                  },
                                                  child: Text(
                                                    more
                                                        ? AppLocalizations.of(
                                                                context)
                                                            .tr("comments.less")
                                                        : AppLocalizations.of(
                                                                context)
                                                            .tr("comments.more"),
                                                  ))
                                              : SizedBox(
                                                  height: 5,
                                                ),

                                      Text(
                                        AppLocalizations.of(context)
                                            .tr("comments.add"),
                                        style: TextStyle(
                                            fontSize: 14, color: hint),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                            color: Colors.white),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        width: bloc.size().width,
                                        child: TextFormField(
                                          controller: _controller,
                                          onChanged: (v) {
                                            setState(() {
                                              comment = v;
                                            });
                                          },
                                          style: TextStyle(fontSize: 14),
                                          maxLines: 4,
                                          minLines: 1,
                                          cursorColor: bumbi,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  AppLocalizations.of(context)
                                                      .tr("comments.addHint"),
                                              hintStyle:
                                                  TextStyle(fontSize: 14)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                          height: 40,
                                          width: bloc.size().width,
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(child: SizedBox()),
                                              BumbiButton(
                                                text:
                                                    AppLocalizations.of(context)
                                                        .tr("comments.comment"),
                                                colored: true,
                                                onPressed: () async {
                                                  if (comment != null &&
                                                      comment.isNotEmpty) {
                                                    Comment newComment =
                                                        await addComment(
                                                            comment: comment,
                                                            id: widget
                                                                .article.id
                                                                .toString(),
                                                            context: context,
                                                            loading: loading);
                                                    setState(() {
                                                      comment = null;
                                                      List<Widget> co = ss.data;
                                                      co.add(CommentWidget(
                                                        comment: newComment,
                                                        article: widget.article,
                                                      ));
                                                      bloc.changecomments(co);
                                                      _controller.clear();
                                                      more = true;
                                                    });
                                                  }
                                                },
                                              )
                                            ],
                                          ))
                                    ],
                                  ),
                                ))
                          ],
                        ),
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

class CommentWidget extends StatefulWidget {
  Comment comment;
  Article article;
  CommentWidget({this.comment, this.article});

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  ProgressDialog del;
  @override
  void initState() {
    del = ProgressDialog(context, type: ProgressDialogType.Normal);
    super.initState();
  }

  refreshComments(Article article) {
    List<Widget> comments = [];
    if (article.comments != null)
      for (int i = 0; i < article.comments.length; i++) {
        comments.add(
          CommentWidget(
            article: article,
            comment: article.comments[i],
          ),
        );
      }
    bloc.changecomments(comments);
  }

  @override
  Widget build(BuildContext context) {
    del.style(
        progressWidget: LoadingFullScreen(),
        message: AppLocalizations.of(context).tr("comments.send"));

    return EasyLocalizationProvider(
      data: EasyLocalizationProvider.of(context).data,
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        trailing: widget.comment.user.id == bloc.currentUser().id
            ? Padding(
                padding: const EdgeInsets.only(top: 10),
                child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                title: Text(AppLocalizations.of(context)
                                    .tr("comments.del")),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () async {
                                        if (del != null) del.show();

                                        await deletComment(
                                            widget.comment.id, context);
                                        Article article = await getArticles(
                                            article: widget.article);
                                        refreshComments(article);
                                        if (del != null) await del.hide();

                                        Navigator.of(context).pop();
                                      },
                                      child: Text(AppLocalizations.of(context)
                                          .tr("comments.yes"))),
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(AppLocalizations.of(context)
                                          .tr("comments.no")))
                                ],
                              ));
                    },
                    child: Icon(
                      Icons.delete_forever,
                      size: 20,
                    )),
              )
            : SizedBox(),
        leading: Container(
          width: 50,
          height: 50,
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: FadeInImage(
                  placeholder: AssetImage('assets/images/placeholder.gif'),
                  image: NetworkImage(widget.comment.user.image))),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ProviderPage(providerModel: widget.comment.user)));
            },
            child: Text(
              widget.comment.user.name ?? "",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        subtitle: Text(
          widget.comment.comment ?? "",
          style: TextStyle(fontSize: 14, color: blackAccent),
        ),
      ),
    );
  }
}
/*
 
                  
*/
