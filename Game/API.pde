// NOTE: don't look at this. the server is a mess too.
// FIXME: use Result<T> or similar.

import processing.net.*;

final String IP = "localhost"; // IP of the server.

// await a http response ending with "END".
// will hang when no END is provided.
// FIXME: implement timeouts.
String await(Client c) {
  String acc = "";
  
  while (true) {
    if (c.available() > 0) acc += c.readString();
    // custom END marker, because i don't want to implement checking Content-Length.
    // this is a very bad solution and easy to forget when writing server code...
    if (acc.length() > 2 && acc.substring(acc.length()-3).equals("END")) break;
  }
  return acc.substring(0, acc.length()-3);
}

// get a http requests body.
// crashes when the request doesn't have a body.
// use with care :)
String getBody(String httpStr) {
  return httpStr.split("\r\n\r\n")[1];
}

// gets all the players' highscore.
// returns HashMap<Username, Highscore>
HashMap<String, Integer> getRanking() {
  Client c = new Client(this, IP, 8080);

  c.write("GET /ranking HTTP/1.0\r\n");
  c.write("\r\n");

  var resp = await(c);
  var body = getBody(resp); // pray this doesn't crash.
  
  c.stop();
  HashMap<String, Integer> ranking = new HashMap<>();
  for (var line : split(body, "\n")) {
    var data = split(line, ",");
    try {
      ranking.put(data[0], Integer.parseInt(data[1]));
    }
    catch (IndexOutOfBoundsException _e) {
      ranking.put("ERROR: getRankingData could not parse.", 0);
    }
  }
  return ranking;
}

// sends a new score to the server (after a game)
void postScore(String name, int score) {
  Client c = new Client(this, IP, 8080);

  c.write("POST /score HTTP/1.0\r\n");
  c.write("Content-Type: application/json\r\n");
  String content
    = "{ \"score\":"+score
    + ", \"name\":\""+name+"\""
    + " }";
  c.write("Content-Length: " + content.length() + "\r\n");
  c.write("\r\n"+ content + "\r\n");
  c.write("\r\n");

  await(c);
  c.stop();
}

// verify if a name is on the leaderboard / registered.
String verifyName(String name) {
  Client c = new Client(this, IP, 8080);
  c.write("POST /verify HTTP/1.0\r\n");
  c.write("Content-Length: " + name.length() + "\r\n");
  c.write("\r\n"+ name + "\r\n");
  c.write("\r\n");
  String res = await(c);
  c.stop();
  if (res.indexOf("EXISTS") != -1) return null;
  print(res);
  var b = getBody(res);
  return b;
}
