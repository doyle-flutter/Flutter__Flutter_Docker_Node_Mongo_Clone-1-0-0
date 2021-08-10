import 'package:dockerflutter/providers/todoProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoClonePage extends StatefulWidget {

  @override
  _TodoClonePageState createState() => _TodoClonePageState();
}

class _TodoClonePageState extends State<TodoClonePage> with SingleTickerProviderStateMixin{

  AnimationController? _at;
  Animation<double>? _anim;
  double? _itemHeight;
  TextEditingController? _createTextEditinController;
  TextEditingController? _textEditingController;

  @override
  void initState() {
    this._at = AnimationController(vsync: this, duration: Duration(seconds: 5));
    WidgetsBinding.instance!.addPostFrameCallback((_) => _after(context));
    this._textEditingController = TextEditingController(text: "");
    this._createTextEditinController = TextEditingController(text: "");
    super.initState();
  }

  void _after(BuildContext context){
    this._itemHeight = MediaQuery.of(context).size.height*0.10;
    this._anim = Tween<double>(begin: 0, end: (MediaQuery.of(context).size.height*0.10)*7+140.0).animate(this._at!);
    this._at!.addListener(this._animHandle);
    if(!this.mounted) return;
    setState(() {});
  }

  void _animHandle() {
    if(!this.mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    this._at?.dispose();
    this._textEditingController?.dispose();
    this._createTextEditinController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TodoProvider provider = Provider.of<TodoProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: _wrapper(context: context, datas: provider.datas, provider: provider),
    );
  }

  Widget _wrapper({required List datas, required BuildContext context, required TodoProvider provider}) => SingleChildScrollView(
    physics: NeverScrollableScrollPhysics(),
    child: Container(
      height: MediaQuery.of(context).size.height-kToolbarHeight-MediaQuery.of(context).padding.top,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))
            ),
            padding: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 10.0, right: 10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _createTextEditinController,
                        enabled: datas.isNotEmpty,
                        decoration: InputDecoration(
                          hintText: "Todo..."
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      child: IconButton(
                        color: datas.isEmpty ? Colors.grey : Colors.blue,
                        icon: Icon(Icons.send),
                        onPressed: datas.isEmpty ? null : () async{
                          bool check = await provider.add(data: _createTextEditinController!.text);
                          if(!check) return await showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text("ADD Fail"),
                              actions: [
                                TextButton(
                                  child: Text("Close"),
                                  onPressed: () => Navigator.of(context).pop(),
                                )
                              ],
                            )
                          );
                          this._createTextEditinController!.clear();
                        },
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <String>["Menu1", "Menu2", "Menu3",].map<Widget>(
                      (String s) => Container(
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: BorderSide(color: Colors.grey)),
                          child: Row(
                            children: [
                              Text(s),
                              Icon(Icons.arrow_drop_down)
                            ],
                          ),
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) => BottomSheet(
                              onClosing: () => false,
                              builder: (BuildContext context) => Container(
                                height: double.infinity,
                                alignment: Alignment.center,
                                child: Text(s),
                              )
                            )
                          ),
                        ),
                      )
                    ).toList(),
                  ),
                )
              ],
            )
          ),
          Expanded(
            child: (datas.isEmpty || this._textEditingController == null)
              ? this._load(context)
              : this._item(datas: datas, controller: this._textEditingController!, provider: provider),
          ),
        ],
      ),
    ),
  );

  Widget _load(BuildContext context){
    this._at!.repeat();
    if(this._itemHeight == null) return Container();
    return Stack(
      children: [
        Container(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: List<int>.generate(7, (index) => index).map<Widget>(
                (int i) => Container(
                  height: this._itemHeight,
                  color: Colors.grey[300],
                  margin: EdgeInsets.all(10.0),
                )
              ).toList(),
            ),
          ),
        ),
        Positioned(
          top: this._anim?.value ?? 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white10,
                  Colors.white12,
                  Colors.white24,
                  Colors.white30,
                  Colors.white38,
                  Colors.white,
                ]
              )
            ),
          ),
        ),
      ],
    );
  }

  Widget _item({required List datas, required TextEditingController controller, required TodoProvider provider}){
    this._at!..stop()..reset();
    if(this._itemHeight == null) return Container();
    return Container(
      child: ListView.builder(
        itemCount: datas.length,
        itemBuilder: (BuildContext context, int index) => InkWell(
          onLongPress: () async => await showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text(" Do ? "),
              actions: [
                TextButton(
                  child: Text("Update"),
                  onPressed: () async{
                    Navigator.of(context).pop();
                    controller.text = datas[index]["data"].toString();
                    await showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) => BottomSheet(
                        enableDrag: false,
                        onClosing: () => false,
                        builder: (BuildContext context) => Container(
                          height: double.infinity,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: 60.0,
                                    horizontal: 16.0
                                  ),
                                  child: TextField(
                                    controller: controller
                                  )
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        onPressed: () async{
                                          bool _check = await provider.update(updateData: controller.text, id: datas[index]['_id'].toString());
                                          if(!_check) return await showDialog(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: Text("Update Fail"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(),
                                                  child: Text("Close")
                                                ),
                                              ],
                                            )
                                          );
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Update")
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: Text("Close")
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      )
                    );
                  },
                ),
                TextButton(
                  child: Text("Delete"),
                  onPressed: () async{
                    bool _check = await provider.delete(id: datas[index]['_id'].toString());
                    if(!_check) return await showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text("Update Fail"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("Close")
                          ),
                        ],
                      )
                    );
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("Close"),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            )
          ),
          child: Container(
            height: this._itemHeight,
            alignment: Alignment.center,
            child: Text(datas[index]["data"].toString()),
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        )
      )
    );
  }
}
