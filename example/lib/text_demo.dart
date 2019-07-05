// ignore: implementation_imports
import 'package:extended_text/extended_text.dart';
import 'package:extended_text/src/extended_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logging/logging.dart';

class ReaderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ReaderPage();
  }
}

class _ReaderPage extends State<ReaderPage> {
  Logger logger = Logger("ReaderPage");

  ScrollController _scrollController;
  Offset startOffset;
  int startIndex = -1;
  int endIndex = -1;
  TextSelection startSelection;
  TextSelection endSelection;

  Offset endOffset;

  IndexData startData;

  updateStartOffset(TapDownDetails details) {
    startOffset = details.globalPosition;

    List startInfo = getMeta<ExtendedRenderParagraph, IndexData>(
        startOffset.dx, startOffset.dy);
    startData = (startInfo[0] as IndexData);
    var startRender = (startInfo[1] as ExtendedRenderParagraph);
    startSelection = startRender.selectWordsInRange(
        from: startOffset,
        to: startOffset,
        cause: SelectionChangedCause.tap)[0];
    startIndex = startData.index;
  }

  void updateEndOffset(Offset endOffset, SelectionChangedCause cause) {
    logger.info("cause is $cause,endOffset $endOffset");
    this.endOffset = endOffset;

    List endInfo =
        getMeta<ExtendedRenderParagraph, IndexData>(endOffset.dx, endOffset.dy);
    var endData = (endInfo[0] as IndexData);
    var endRender = (endInfo[1] as ExtendedRenderParagraph);
    if (startData.index > endData.index) {
      setState(() {
        startSelection =
            TextSelection(baseOffset: 0, extentOffset: startSelection.start);
        endIndex = endData.index;
//        switchIndex();
        endSelection = endRender.selectWordsInRange(
            to: Offset(double.maxFinite, double.maxFinite),
            from: endOffset,
            cause: cause)[0];
      });
    } else if (startData.index < endData.index) {
      setState(() {
        startSelection = TextSelection(
            baseOffset: startSelection.start, extentOffset: startData.length);
        endIndex = endData.index;
//        switchIndex();
        endSelection = endRender.selectWordsInRange(
            from: Offset(0, 0), to: endOffset, cause: cause)[0];
      });
    } else {
      setState(() {
        TextSelection selectionEnd = endRender.selectWordsInRange(
            from: endOffset,
            to: endOffset,
            cause: SelectionChangedCause.tap)[0];

        int selectionStart = startSelection.start;
        int selectionStart = startSelection.start;
        if (selectionEnd.start > startSelection.start) {}
        startSelection = TextSelection(
            baseOffset: selectionStart, extentOffset: selectionEnd);
        endIndex = startData.index;
        logger.info("startSelection is $startSelection");
      });
    }
  }

  void initSelection(
      IndexData startData,
      ExtendedRenderParagraph startRender,
      IndexData endData,
      ExtendedRenderParagraph endRender,
      SelectionChangedCause cause) {
    setState(() {
      endIndex = endData.index;
      endSelection = endRender.selectWordsInRange(
          from: Offset(0, 0), to: endOffset, cause: cause)[0];
    });
  }

  resetSelect() {
    startIndex = -1;
    endIndex = -1;
    startSelection = null;
    endSelection = null;
  }

  TextSelection getTextSelection(IndexData data) {
    if (startIndex == data.index) {
      return startSelection;
    } else if (endIndex == data.index) {
      return endSelection;
    } else if ((startIndex < data.index && data.index < endIndex) ||
        (startIndex > data.index && data.index > endIndex)) {
      return TextSelection(baseOffset: 0, extentOffset: data.length);
    } else {
      return null;
    }
  }

  @override
  void initState() {
    _scrollController =
        PrimaryScrollController.of(context) ?? ScrollController();
    super.initState();
  }

  void _handleTapDown(TapDownDetails details) {
    logger.info("_handleTapDown ======= ${details.globalPosition}");
    updateStartOffset(details);
  }

  void _handleSingleTapUp(TapUpDetails details) {
//    logger.info("TapUpDetails ======= ${details.globalPosition}");
//    switch (Theme.of(context).platform) {
//      case TargetPlatform.iOS:
//        _renderParagraph.selectWordEdge(cause: SelectionChangedCause.tap);
//        break;
//      case TargetPlatform.android:
//      case TargetPlatform.fuchsia:
//        _renderParagraph.selectPosition(cause: SelectionChangedCause.tap);
//        break;
//    }
//
//    if (widget.onTap != null) widget.onTap();
  }

  void _handleSingleLongTapStart(LongPressStartDetails details) {
    logger.info("_handleSingleLongTapStart ======= ${details.globalPosition}");
//    switch (Theme.of(context).platform) {
//      case TargetPlatform.iOS:
//        _renderParagraph.selectPositionAt(
//          from: details.globalPosition,
//          cause: SelectionChangedCause.longPress,
//        );
//        break;
//      case TargetPlatform.android:
//      case TargetPlatform.fuchsia:
//        _renderParagraph.selectWord(cause: SelectionChangedCause.longPress);
    Feedback.forLongPress(context);
//        break;
//    }
  }

  void _handleSingleLongTapMoveUpdate(LongPressMoveUpdateDetails details) {
//    switch (Theme.of(context).platform) {
//      case TargetPlatform.iOS:
//        _renderParagraph.selectPositionAt(
//          from: details.globalPosition,
//          cause: SelectionChangedCause.longPress,
//        );
//        break;
//      case TargetPlatform.android:
//      case TargetPlatform.fuchsia:
//        _renderParagraph.selectWordsInRange(
//          from: details.globalPosition - details.offsetFromOrigin,
//          to: details.globalPosition,
//          cause: SelectionChangedCause.longPress,
//        );
//        break;
//    }
    updateEndOffset(details.globalPosition, SelectionChangedCause.longPress);
  }

  void _handleSingleLongTapEnd(LongPressEndDetails details) {
    logger.info("_handleSingleLongTapEnd ======= ${details.globalPosition}");
//    showToolbar();
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    var offset = details.globalPosition;

    List info =
        getMeta<ExtendedRenderParagraph, IndexData>(offset.dx, offset.dy);
    List result = (info[1] as ExtendedRenderParagraph).selectWordsInRange(
      from: startOffset,
      to: details.globalPosition,
      cause: SelectionChangedCause.longPress,
    );
    TextSelection selection = (result[0] as TextSelection);

    logger.info(
        "_handleDoubleTapDown ======= ${details.globalPosition},selection is ${selection.start},${selection.end}");
//    showToolbar();
  }

  void _handleMouseDragSelectionStart(DragStartDetails details) {
    logger.info(
        "_handleMouseDragSelectionStart ======= ${details.globalPosition}");
//    _renderParagraph.selectPositionAt(
//      from: details.globalPosition,
//      cause: SelectionChangedCause.drag,
//    );
  }

  void _handleMouseDragSelectionUpdate(
    DragStartDetails startDetails,
    DragUpdateDetails updateDetails,
  ) {
//    _renderParagraph.selectPositionAt(
//      from: startDetails.globalPosition,
//      to: updateDetails.globalPosition,
//      cause: SelectionChangedCause.drag,
//    );
  }

  void _handleSelectionChanged(TextSelection selection,
      ExtendedRenderParagraph renderObject, SelectionChangedCause cause) {
    logger
        .info("_handleSelectionChanged ${selection.start}====${selection.end}");

//    textEditingValue = textEditingValue?.copyWith(selection: selection);
//    _hideSelectionOverlayIfNeeded();
//    //todo
////    if (widget.selectionControls != null) {
//    _selectionOverlay = ExtendedTextSelectionOverlay(
//        context: context,
//        debugRequiredFor: widget,
//        layerLink: _layerLink,
//        renderObject: renderObject,
//        value: textEditingValue,
//        dragStartBehavior: widget.dragStartBehavior,
//        selectionDelegate: this,
//        selectionControls: _textSelectionControls);
//    final bool longPress = cause == SelectionChangedCause.longPress;
//    if (cause != SelectionChangedCause.keyboard &&
//        (widget.text.toPlainText().isNotEmpty || longPress))
//      _selectionOverlay.showHandles();
//      if (widget.onSelectionChanged != null)
//        widget.onSelectionChanged(selection, cause);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("quickly build special text"),
        ),
//      body: VideoList(),
        body: TextSelectionGestureDetector(
          onTapDown: _handleTapDown,
//          onForcePressStart:
//              forcePressEnabled ? _handleForcePressStarted : null,
          onSingleTapUp: _handleSingleTapUp,
          // onSingleTapCancel: _handleSingleTapCancel,
          onSingleLongTapStart: _handleSingleLongTapStart,
          onSingleLongTapMoveUpdate: _handleSingleLongTapMoveUpdate,
          onSingleLongTapEnd: _handleSingleLongTapEnd,
          onDoubleTapDown: _handleDoubleTapDown,
          onDragSelectionStart: _handleMouseDragSelectionStart,
          onDragSelectionUpdate: _handleMouseDragSelectionUpdate,
          behavior: HitTestBehavior.translucent,

          child: ListView.builder(
            itemCount: 10,
            controller: _scrollController,
            itemBuilder: (context, index) {
              final RenderObject contextObject = context?.findRenderObject();
//              contextObject?
//              ReorderableListView
//              final RenderAbstractViewport viewport =
//                  RenderAbstractViewport.of(contextObject);
              logger.info("======= $contextObject");
              return _getChild(IndexData(index, text.length));
            },
          ),
        ));
  }

  List getMeta<T, IndexData>(double x, double y) {
    var renderBox = context.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset(x, y));

    HitTestResult result = HitTestResult();
    WidgetsBinding.instance.hitTest(result, offset);
    List info = List(2);
    int dataSize = 0;
    for (var i in result.path) {
      print("runTime is ${i.target.runtimeType}");
      if (i.target is T) {
        info[1] = i.target as T;
        dataSize++;
        if (dataSize == 2) {
          return info;
        }
      } else if (i.target is RenderMetaData) {
        var d = i.target as RenderMetaData;
        if (d.metaData is IndexData) {
          info[0] = d.metaData as IndexData;
          dataSize++;
          if (dataSize == 2) {
            return info;
          }
        }
      }
    }
    return null;
  }

  var text =
      "此类跟踪哪些窗口小部件需要重建，并处理适用于窗口小部件树的其他任务，例如管理树的非活动元素列表，并在调试时在热重新加载期间在必要时触发重组命令.主构建所有者通常由WidgetsBinding拥有，并且从操作系统以及构建/布局/绘制管道的其余部分驱动.可以构建其他构建所有者来管理屏幕外小部件树.";

  Widget _getChild(IndexData info) {
    return MetaData(
      metaData: info,
      child: ExtendedRichText(
        text: TextSpan(children: [
          TextSpan(
            text: text,
            style: TextStyle(
              color: Colors.blue,
            ),
          )
        ]),
        selection: getTextSelection(info),
        selectionColor: Color(0x99aa6644),
      ),
    );
  }

  void switchIndex() {
    var temp = startIndex;
    startIndex = endIndex;
    endIndex = temp;
  }
}

class IndexData {
  final int index;
  final int length;
  IndexData(this.index, this.length);
}
