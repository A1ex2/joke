import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class JokeConnected {
  static Future<String> getJoke() async {
    String URL = "official-joke-api.appspot.com";
    String URL_API = "random_joke";

    String joke = "";

    var uri;
    try {
      uri = Uri.https(URL, URL_API);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
      );
      return joke;
    }

    try {
      var responce = await http.get(uri);

      if (responce.statusCode == 200) {
        try {
          Map<String, dynamic> forecastResponse = jsonDecode(responce.body);

          joke = "${forecastResponse["setup"]} \n \n"
              "${forecastResponse["punchline"]}";

          joke = await translate(joke);
        } catch (e) {
          Fluttertoast.showToast(
            msg: "Error ${e.toString()}",
            toastLength: Toast.LENGTH_LONG,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Error occurred while loading data from server",
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
      );
    }

    return joke;
  }

  static Future<String> translate(String joke) async {
    String URL = "translate.google.com";
    String URL_API = "m";

    Map<String, dynamic> queryParameters = {
      "sl": "en",
      "tl": "ru",
      "hl": "ru",
      "q": joke,
    };

    String jokeTranslate = joke;

    var uri;
    try {
      uri = Uri.https(URL, URL_API, queryParameters);

      try {
        var responce = await http.get(uri);

        if (responce.statusCode == 200) {
          try {
            dom.Document html = dom.Document.html(responce.body);

            final dataList = html
                .querySelectorAll('body > div > div.result-container')
                .map((e) => e.innerHtml.trim())
                .toList();

            for (final text in dataList) {
              jokeTranslate = text;
              break;
            }
          } catch (e) {
            Fluttertoast.showToast(
              msg: "Error ${e.toString()}",
              toastLength: Toast.LENGTH_LONG,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: "Error occurred while loading data from server",
            toastLength: Toast.LENGTH_LONG,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Error ${e.toString()}",
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
      );
      return jokeTranslate;
    }

    return jokeTranslate;
  }
}
