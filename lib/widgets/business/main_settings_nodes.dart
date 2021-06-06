//
// Copyright 2021 Free TON Wallet Team
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// 	http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import "dart:ui" show FontWeight, TextAlign;
import "package:flutter/material.dart"
    show
        Border,
        BorderRadius,
        BoxDecoration,
        BoxShadow,
        BuildContext,
        Color,
        Colors,
        Column,
        Container,
        ElevatedButton,
        Expanded,
        ExpansionTile,
        Icon,
        IconButton,
        Icons,
        InkWell,
        InputDecoration,
        ListTile,
        ListView,
        Offset,
        Radius,
        SizedBox,
        State,
        StatefulWidget,
        StatelessWidget,
        Text,
        TextFormField,
        UnderlineInputBorder,
        Widget;
import "package:flutter/src/widgets/basic.dart"
    show
        Column,
        CrossAxisAlignment,
        EdgeInsets,
        Expanded,
        FontWeight,
        MainAxisAlignment,
        Padding,
        Row,
        TextAlign,
        TextStyle;
import 'package:freeton_wallet/viewmodel/app_view_model.dart';
import 'package:freeton_wallet/viewmodel/node_view_model.dart';
import 'package:freeton_wallet/widgets/reusable/change_detector.dart';
import "../layout/my_scaffold.dart" show MyScaffold;

class SettingsNodesWidget extends StatelessWidget {
  final AppViewModel _appViewModel;
  SettingsNodesWidget(
    this._appViewModel,
  );

  @override
  Widget build(BuildContext context) {
    return NodesManagerSettings(this._appViewModel);
  }
}

// class SettingsNodesWidget extends StatefulWidget {
//   final AppViewModel _appViewModel;

//   SettingsNodesWidget(
//     this._appViewModel,
//   );

//   @override
//   _SettingsNodesWidgetState createState() => _SettingsNodesWidgetState();
// }

// class _SettingsNodesWidgetState extends State<SettingsNodesWidget> {
//   // DataSet? _dataSet;

//   _SettingsNodesWidgetState(); // : this._dataSet = null;

//   // DataSet get dataSet {
//   //   assert(this._dataSet != null);
//   //   return this._dataSet!;
//   // }

//   @override
//   void initState() {
//     super.initState();
//     this._safeLoadDataset();
//   }

//   void _safeLoadDataset() async {
//     // final DataSet dataSet =
//     //     await this.widget._encryptedDbService.read(this.widget._encryptionKey);
//     setState(() {
//       // this._dataSet = dataSet;
//     });
//   }

//   void addNode(NodeBundle nodeBundle) {
//     // this.dataSet.addNode(nodeBundle);
//     // this.widget._encryptedDbService.write(this.dataSet);
//     this._safeLoadDataset();
//   }

//   void deleteNode(String nodeUrl) {
//     // this.dataSet.deleteNodeByUrl(nodeUrl);
//     // this.widget._encryptedDbService.write(this.dataSet);
//     this._safeLoadDataset();
//   }

//   void setActiveNode(NodeBundle nodeBundle) {
//     // this.dataSet.setActiveNode(nodeBundle);
//     // this.widget._encryptedDbService.write(this.dataSet);
//     this._safeLoadDataset();
//   }

//   Widget _buildDataSetLoader(BuildContext context) {
//     return Text("Loading");
//   }

//   Widget _buildDataSetWorker(BuildContext context) {
//     return NodesManagerSettings(
//       this.widget._appViewModel,
//       this.addNode,
//       this.deleteNode,
//       this.setActiveNode,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (this._dataSet == null) {
//       return this._buildDataSetLoader(context);
//     } else {
//       return this._buildDataSetWorker(context);
//     }
//   }
// }

class NodesManagerSettings extends StatefulWidget {
  final AppViewModel _appViewModel;

  NodesManagerSettings(
    this._appViewModel,
  );

  @override
  _NodesManagerSettingsState createState() => _NodesManagerSettingsState();
}

class _NodesManagerSettingsState extends State<NodesManagerSettings> {
  _StateSettingsNode _stateNode;
  _NodesManagerSettingsState() : this._stateNode = _StateSettingsNode("", "");

  bool get newNodeDataIsEntered => false;
  // this
  //     .widget
  //     ._appViewModel.nodes
  //     .where((NodeViewModel node) => node.servers == this._stateNode.nodeUrl)
  //     .isEmpty &&
  // this._stateNode.isDataEntered;

  void _addNode() {
    // NodeModel node = NodeModel(
    //   this._stateNode.nodeName,
    //   this._stateNode.nodeUrl,
    //   this._stateNode.nodeColor?.value,
    // );
    // this.widget._addNode(node);
  }

  void _setActiveNode(NodeViewModel node) {
    this.widget._appViewModel.selectNode(node.nodeId);
  }

  void _deleteNode(NodeViewModel node) {
    print(node.name);
  }

  bool _canDelete(NodeViewModel node) =>
      !<String>["Mainnet", "Testnet"].contains(node.name);

  Widget tileWidget(NodeViewModel node, {bool canDelete = true}) {
    return ListTile(
      tileColor: node.color,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                node.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                node.servers.join(", "),
                style: TextStyle(
                  fontSize: 12,
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              IconButton(
                splashRadius: 20,
                icon: Icon(
                  Icons.star,
                  color: this.widget._appViewModel.selectedNode == node
                      ? Colors.blue
                      : Colors.grey,
                ),
                onPressed: () => this._setActiveNode(node),
              ),
              if (this._canDelete(node))
                IconButton(
                  splashRadius: 20,
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () => this._deleteNode(node),
                ),
              if (!this._canDelete(node))
                SizedBox(
                  width: 40,
                ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBarTitle: "Nodes",
      body: Column(
        children: <Widget>[
          Expanded(
            child: ChangeDetector(
              this.widget._appViewModel,
              builder: (_) {
                print("Update nodes");
                print(this.widget._appViewModel.selectedNode.nodeId);
                return ListView(
                    children:
                        ListTile.divideTiles(context: context, tiles: <Widget>[
                  ...this
                      .widget
                      ._appViewModel
                      .nodes
                      .map((NodeViewModel node) => tileWidget(node)),
                ]).toList());
              },
            ),
          ),
          // ExpansionTile(
          //   title: Text(
          //     "Add node",
          //     style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //     ),
          //     textAlign: TextAlign.center,
          //   ),
          //   children: <Widget>[
          //     Padding(
          //       padding: const EdgeInsets.symmetric(
          //         horizontal: 50,
          //       ),
          //       child: TextFormField(
          //         onChanged: (String val) {
          //           setState(() {
          //             this._stateNode.nodeName = val;
          //           });
          //         },
          //         decoration: InputDecoration(
          //           border: UnderlineInputBorder(),
          //           labelText: "Node name",
          //         ),
          //       ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.symmetric(
          //         horizontal: 50,
          //       ),
          //       child: TextFormField(
          //         onChanged: (String val) {
          //           setState(() {
          //             this._stateNode.nodeUrl = val;
          //           });
          //         },
          //         decoration: InputDecoration(
          //           border: UnderlineInputBorder(),
          //           labelText: "Node url",
          //         ),
          //       ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.symmetric(
          //         horizontal: 60,
          //       ),
          //       child: Padding(
          //         padding: const EdgeInsets.symmetric(vertical: 10),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: <Widget>[
          //             ...<Color>[
          //               Colors.redAccent,
          //               Colors.deepPurpleAccent,
          //               Colors.blueAccent,
          //               Colors.cyanAccent,
          //               Colors.lightGreenAccent,
          //               Colors.yellowAccent,
          //               Colors.orangeAccent,
          //               Colors.deepOrangeAccent,
          //             ]
          //                 .map(
          //                   (Color color) => InkWell(
          //                     borderRadius: BorderRadius.all(
          //                       Radius.circular(40),
          //                     ),
          //                     onTap: () {
          //                       setState(() {
          //                         this._stateNode.nodeColor = color;
          //                       });
          //                     },
          //                     child: Container(
          //                       width: 40,
          //                       height: 40,
          //                       decoration: BoxDecoration(
          //                           color: color,
          //                           border: Border.all(color: color),
          //                           boxShadow: <BoxShadow>[
          //                             BoxShadow(
          //                               color: Colors.grey.withOpacity(0.3),
          //                               spreadRadius: 2,
          //                               blurRadius: 2,
          //                               offset: Offset(
          //                                   1, 1), // changes position of shadow
          //                             ),
          //                           ],
          //                           borderRadius:
          //                               BorderRadius.all(Radius.circular(40))),
          //                       child: Icon(
          //                         this._stateNode.nodeColor == color
          //                             ? Icons.check
          //                             : null,
          //                         color: Colors.grey[800],
          //                       ),
          //                     ),
          //                   ),
          //                 )
          //                 .toList()
          //           ],
          //         ),
          //       ),
          //     ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //     vertical: 10,
          //   ),
          //   child: ElevatedButton(
          //     onPressed: this.newNodeDataIsEntered ? this._addNode : null,
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(
          //         horizontal: 20,
          //         vertical: 10,
          //       ),
          //       child: Text("Add"),
          //     ),
          //   ),
          // ),
          //   ],
          // )
        ],
      ),
    );
  }
}

class _StateSettingsNode {
  String nodeName;
  String nodeUrl;
  Color? nodeColor;

  bool get isDataEntered => this.nodeName.isNotEmpty && this.nodeUrl.isNotEmpty;

  _StateSettingsNode(this.nodeName, this.nodeUrl, {this.nodeColor});
}
