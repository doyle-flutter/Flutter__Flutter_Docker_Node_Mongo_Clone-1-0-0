import 'package:flutter/material.dart';

class InfoClonePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.favorite),
        onPressed: (){},
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              this._inAppBar(),
              this._menus([{"name":"Menu1", "icon":Icons.person}, {"name":"Menu2", "icon":Icons.send_rounded}, {"name":"Menu3", "icon":Icons.shopping_cart}]),
              this._topCarousel(context),
              this._itemList(context),
              this._itemList(context),
              this._itemList(context)
            ],
          ),
        ),
      ),
    );
  }
  Widget _inAppBar() => AppBar(
    title: Text("InfoAPP"),
    elevation: 0,
    backgroundColor: Colors.black,
  );
  Widget _menus(List<Map<String, dynamic>> menus) => Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: menus.map<Widget>(
        (Map<String, dynamic> m) => Container(
          child: MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: BorderSide(color: Colors.grey)),
            child: Row(
              children: [
                Text(m['name'].toString()),
                SizedBox(width: 5.0,),
                Icon(m['icon'], size: 16.0,)
              ],
            ),
            onPressed: (){},
          ),
        )
      ).toList(),
    ),
  );
  Widget _topCarousel(BuildContext context) => Container(
    height: MediaQuery.of(context).size.height*0.30,
    child: PageView.builder(
      itemBuilder: (BuildContext context, int index) => Container(
        alignment: Alignment.center,
        child: Text(index.toString()),
      )
    ),
  );
  Widget _itemList(BuildContext context) => Container(
    height: MediaQuery.of(context).size.height*0.30,
    margin: EdgeInsets.symmetric(vertical: 10.0),
    child: Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 10.0),
          child: Text("Item", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),)
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: GridView.builder(
              padding: EdgeInsets.only(left: 20.0),
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0
              ),
              itemBuilder: (BuildContext context, int index) => Container(
                color: Colors.blue,
              )
            ),
          ),
        ),
      ],
    ),
  );
}
