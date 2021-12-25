import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:gallery/layout/adaptive.dart';
import 'package:gallery/studies/braineous/model/playgroundRestClient.dart';
import 'package:gallery/studies/braineous/model/project_model.dart';
import 'package:gallery/studies/braineous/project_details.dart';
//import 'package:gallery/studies/rally/finance.dart';
import 'package:gallery/studies/reply/colors.dart';
import 'package:gallery/studies/reply/profile_avatar.dart';
import 'package:provider/provider.dart';
import 'model/project_store.dart';

const _assetsPackage = 'flutter_gallery_assets';
const _iconAssetLocation = 'reply/icons';

class PlayGroundPreviewCard extends StatelessWidget {
  const PlayGroundPreviewCard({
    Key key,
    @required this.project,
  })  : assert(project != null),
        super(key: key);

  final Project project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // TODO(shihaohong): State restoration of mail view page is
    // blocked because OpenContainer does not support restorablePush.
    // See https://github.com/flutter/flutter/issues/69924.
    return OpenContainer(
      //openBuilder: (context, closedContainer) {
      //  return PlayGroundPreviewCard();
      //},
      openColor: theme.cardColor,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      closedElevation: 0,
      closedColor: theme.cardColor,
      closedBuilder: (context, openContainer) {
        return PlayGroundScriptView();
      },
    );
    //MaterialApp materialApp = new MaterialApp(home: new PlayGroundPreviewCard(),);
    //return materialApp;
  }
}

class PlayGroundScriptView extends StatefulWidget{

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: new PlayGroundScriptView(),
                      )
                    ],
                  ),
                  /*Padding(
                    padding: const EdgeInsetsDirectional.only(
                      end: 20,
                    ),
                    child: Text(
                      project.projectId,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: textTheme.bodyText2,
                    ),
                  ),*/
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _PlayGroundPreviewState();
  }
}

class _PlayGroundPreviewState extends State<PlayGroundScriptView> with TickerProviderStateMixin{
  String output = '';
  String exception = '';
  String statusCode = '';
  TextEditingController scripController = TextEditingController();

  @override
  void dispose() {
    scripController.dispose();
    super.dispose();
  }

  void updateOutput(Map<String,dynamic> json){
    setState(() {
      if(json['statusCode'] != null) {
        statusCode = json['statusCode'].toString();
      }
      if(json['output'] != null) {
        output = json['output'] as String;
      }
      if(json['exception'] != null) {
        exception = json['exception'] as String;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextFormField(
          controller: scripController,
          restorationId: 'life_story_field',
          focusNode: new FocusNode(),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: "Hint",
            labelText:"Script/Code",
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 4),
        OutlinedButton(
          onPressed: () {
            String script = scripController.text;
            Future<Map<String,dynamic>> future = PlayGroundRestClient.executeScript(script);
            future.then((json){
              print(json);
              updateOutput(json);
            });
          },
          child: Text("Execute"),
        ),
        const SizedBox(height: 4),
        Text('$statusCode',
          //style: Theme.of(context).textTheme.caption,
        ),
        const SizedBox(height: 4),
        Text('$output',
          //style: Theme.of(context).textTheme.caption,
        ),
        const SizedBox(height: 4),
        Text('$exception',
          //style: Theme.of(context).textTheme.caption,
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
