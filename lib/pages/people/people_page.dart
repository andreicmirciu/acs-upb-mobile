import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PeoplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: S.of(context).navigationPeople,
      body: ListPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Future _data;

  Future getPeople() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("people").getDocuments();
    return qn.documents;
  }

  @override
  void initState() {
    super.initState();
    _data = getPeople();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: _data,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading..."),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data[index].data["photo"]),
                      ),
                      title: Text(snapshot.data[index].data["name"]),
                      subtitle: Text(snapshot.data[index].data["email"]),
                      onTap: () => navigateToDetail(snapshot.data[index]),
                    );
                  });
            }
          }),
    );
  }

  navigateToDetail(DocumentSnapshot person) {
    //Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(person: person, )));
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      // TODO: Fix size for landscape
      builder: (BuildContext buildContext) {
        return DetailPage(
          person: person,
        );
      },
    );
  }
}

class DetailPage extends StatelessWidget {
  final DocumentSnapshot person;

  DetailPage({this.person});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(

      child: Column(
        children: [
          Container(
            decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                border: new Border.all(color: Colors.black, width: 20)),
            child: RichText(
              text: TextSpan(text: person.data["name"]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                        child: person.data["photo"] != null
                            ? CircleAvatar(
                                maxRadius: 50,
                                backgroundImage: CachedNetworkImageProvider(
                                    person.data["photo"]),
                              )
                            : CircleAvatar(
                                radius: 50,
                                child: Icon(
                                  Icons.person,
                                  size: 50,
                                ),
                              ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.email),
                              SizedBox(width: 4),
                              RichText(
                                  text:
                                      TextSpan(text: person.data["email"] ?? '-'))
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.phone),
                              SizedBox(width: 4),
                              RichText(
                                  text:
                                      TextSpan(text: person.data["phone"] ?? '-'))
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.location_on),
                              SizedBox(width: 4),
                              RichText(
                                  text: TextSpan(
                                      text: person.data["office"] ?? '-'))
                            ],
                          ),
                          SizedBox(height: 8),
                          RichText(
                            maxLines: 2,
                            softWrap: true,
                            text: TextSpan(children: [
                              WidgetSpan(
                                  child: Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Icon(Icons.work),
                              )),
                              TextSpan(text: person.data["position"] ?? '-')
                            ]),
                          )
                          /*Row(
                              children: [
                                Icon(Icons.work),
                                SizedBox(width: 4),
                                RichText(
                                  text: TextSpan(
                                    text: person.data["position"] ?? '-'
                                  )
                                )
                              ],
                            ),*/
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
