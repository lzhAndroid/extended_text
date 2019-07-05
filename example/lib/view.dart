import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class VideoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VideoListState();
  }
}

class _VideoListState extends State<VideoList> {
  List<VideoInfo> list;

  @override
  void initState() {
    list = List<VideoInfo>();
    for (int i = 0; i < 10000; i++) {
      list.add(VideoInfo("Video$i"));
    }

    super.initState();
  }

  ListView _listView;

  @override
  Widget build(BuildContext context) {
    _listView = ListView.builder(
      itemBuilder: (context, index) {
        var item = list[index];
        return _getChild(
          item,
        );
      },
      itemCount: list.length,
    );

    var notificationListener = NotificationListener(
      onNotification: (noti) {
        if (noti is ScrollStartNotification) {
          // stop playing
        } else if (noti is ScrollEndNotification) {
          // resume playing
          print("end");
          Future.microtask(() {
            VideoInfo info = getMeta(0, 200);
            print("scrolling to ${info.title}");
          });
        }
      },
      child: _listView,
    );

    return notificationListener;
  }

  T getMeta<T>(double x, double y) {
    var renderBox = context.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset(x, y));

    HitTestResult result = HitTestResult();
    WidgetsBinding.instance.hitTest(result, offset);

    for (var i in result.path) {
      print("runTime is ${i.target.runtimeType}");
      if (i.target is RenderMetaData) {
        var d = i.target as RenderMetaData;
        if (d.metaData is T) {
          return d.metaData as T;
        }
      }
    }
    return null;
  }

  Widget _getChild(VideoInfo info) {
    return MetaData(
      metaData: info,
      child: VideoCard(info: info),
    );
  }
}

class VideoCard extends StatefulWidget {
  final VideoInfo info;

  const VideoCard({Key key, this.info}) : super(key: key);

  @override
  VideoCardState createState() => VideoCardState();
}

class VideoCardState extends State<VideoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("hello world ${widget.info.title}"));
  }
}

//-------------data---------------

class VideoInfo {
  final String title;

  VideoInfo(this.title);
}
