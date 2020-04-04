import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/models/providerModel.dart';
import 'package:atelier/screens/home/Fashion.dart';
import 'package:atelier/screens/login&signUp/splach.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:progress_dialog/progress_dialog.dart';

class Article {
  int id;
  List images;
  String title;
  String note;
  List<Comment> comments;
  Article({this.images, this.title, this.id, this.note, this.comments});
  factory Article.fromJson(Map<String, dynamic> article) {
    try {
      
      List<Comment> comments = [];
      if(article["comments"]!=null&&article["comments"]!=[])
     {
        for (int i = 0; i < article["comments"].length; i++)
        comments.add(Comment.fromJson(article['comments'][i]));
     }return Article(
          id: article['id'],
          images: article['images'],
          title: article['title'],
          note: article['note'],
          comments: comments
          );
    } catch (e) {
      print(e);
      return Article();
    }
  }
}

class Comment {
  int id;
  ProviderModel user;
  String comment;
  Comment({this.id, this.comment, this.user});
  factory Comment.fromJson(Map<String, dynamic> comment) {
    try {
      return Comment(
          id: comment['id'],
          user: ProviderModel.fromCommentson(comment['user']),
          comment: comment['comment']);
    } catch (e) {
      print(e);
      return Comment();
    }
  }
}

Future<List<Widget>> getAllArticles(
    {int category, BuildContext context}) async {
                    List<FashionCard> articlesCards = [];
  try {

    http.Response response = await http.get(
    
        "https://atelierapps.com/api/v1/article?article_category_id=$category",
    
    headers: {
          "apiToken": "sa3d01${bloc.currentUser().apiToken}",
          "lang": bloc.lang() ?? "ar"
        },
        );
        
    final allArticles = json.decode(response.body);
    if (allArticles['status'] == 200) {
      List articles = allArticles['data'];
      for (int i = 0; i < articles.length; i++) {
        Article article = Article.fromJson(articles[i]);
        FashionCard fashionCard = FashionCard(
          article: article,
        );
        articlesCards.add(fashionCard);
      }
    } else if (allArticles['status'] == 401) {
      await clearUserData();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Splach()));
    } else {
      bloc.sendDoneMessage(allArticles['msg']);
      print(allArticles['msg']);
    }
  } catch (e) {
    print(e);
  }
  return articlesCards;
}
class ArticleCategory{
  int id;
  String name;
  ArticleCategory({this.id,this.name});
 factory ArticleCategory.fromJson(Map<String,dynamic>category){
   try{
     return ArticleCategory(
       id: category['id'],
       name: category['name']
     );
   }
   catch(e){
     return ArticleCategory();
   }
 }
}
Future getAllArticleCategories(
    BuildContext context) async {
            List<ArticleCategory> categoriesOfArticles = [];

  try {

    http.Response response = await http.get(
        "https://atelierapps.com/api/v1/article/categories",
        headers: {
          "apiToken": "sa3d01${bloc.currentUser().apiToken}",
          "lang": bloc.lang() ?? "ar"
        });
    final allCategories = json.decode(response.body);
    if (allCategories['status'] == 200) {
      List categories = allCategories['data'];
      for (int i = 0; i < categories.length; i++) {
        ArticleCategory category = ArticleCategory.fromJson(categories[i]);
        categoriesOfArticles.add(category);
      }
      bloc.getCategories(categoriesOfArticles);
    } else if (allCategories['status'] == 401) {
      await clearUserData();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Splach()));
    } else {
      bloc.sendDoneMessage(allCategories['msg']);
    }
  } catch (e) {
    print(e);
  }
}
Future addComment({String id,BuildContext context,ProgressDialog loading,String comment}) async {
  if(loading!=null)
  loading.show();
  http.Response response = await http.post("https://atelierapps.com/api/v1/article/comment",  headers: {
    "apiToken":"sa3d01${bloc.currentUser().apiToken}",
    // "lang": bloc.lang() ?? "ar"
  },
  body: {
    "article_id":id,
    "comment":comment
  }
  );
  final commentJson = json.decode(response.body);
  if (commentJson["status"] == 200) {
    Comment comment=Comment.fromJson(commentJson['data']);
    bloc.sendDoneMessage(null);
      if(loading!=null)
  await loading.hide();
    return comment;
  } else
  if(commentJson['status']==401)
  {
   await clearUserData();
         if(loading!=null)
  await loading.hide();

   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Splach()));
  }
  else{
          if(loading!=null)
  await loading.hide();

    bloc.sendDoneMessage(commentJson['msg']);
  }
    
}
Future deletComment(int id,BuildContext context) async {
  try {
    final http.Response allRemainedDressesJson = await http.delete(
        "http://atelierapps.com/api/v1/article/comment/$id",
        headers: {"apiToken": "sa3d01${bloc.currentUser().apiToken}"});
        final al=json.decode(allRemainedDressesJson.body);
        
  if(al['status']==401){
    await clearUserData();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Splach()));
  }
  } catch (e) {
    bloc.sendDoneMessage(e.toString());
  }
}
Future<Article> getArticles(
    {Article article, BuildContext context}) async {
      Article art=article;
  try {

    http.Response response = await http.get(
    
        "http://atelierapps.com/api/v1/article/${article.id}",
    
    headers: {
          "apiToken": "sa3d01${bloc.currentUser().apiToken}",
          "lang": bloc.lang() ?? "ar"
        },
        );
        
    final articles = json.decode(response.body);
    if (articles['status'] == 200) {
      art = Article.fromJson(articles['data']);
      }
     else if (articles['status'] == 401) {
      await clearUserData();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Splach()));
    } else {
      bloc.sendDoneMessage(articles['msg']);
      print(articles['msg']);
    }
  } catch (e) {
    print(e);
  }
  return art;
}
