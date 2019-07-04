// ignore: implementation_imports
import 'package:extended_text/extended_text.dart';
import 'package:extended_text/src/extended_rich_text.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    _scrollController =
        PrimaryScrollController.of(context) ?? ScrollController();
    super.initState();
  }

  void _handleTapDown(TapDownDetails details) {
//    _renderParagraph.handleTapDown(details);
  }

  void _handleForcePressStarted(ForcePressDetails details) {
//    _renderParagraph.selectWordsInRange(
//      from: details.globalPosition,
//      cause: SelectionChangedCause.forcePress,
//    );
//    showToolbar();
  }

  void _handleSingleTapUp(TapUpDetails details) {
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
//        Feedback.forLongPress(context);
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
  }

  void _handleSingleLongTapEnd(LongPressEndDetails details) {
//    showToolbar();
  }

  void _handleDoubleTapDown(TapDownDetails details) {
//    _renderParagraph.selectWord(cause: SelectionChangedCause.doubleTap);
//    showToolbar();
  }

  void _handleMouseDragSelectionStart(DragStartDetails details) {
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
              logger.info(context.size.height);
              return ExtendedRichText(
                  text: TextSpan(children: [
                    TextSpan(text: '  \u2026  '),
                    TextSpan(
                      text:
                          "此类跟踪哪些窗口小部件需要重建，并处理适用于窗口小部件树的其他任务，例如管理树的非活动元素列表，并在调试时在热重新加载期间在必要时触发重组命令.主构建所有者通常由WidgetsBinding拥有，并且从操作系统以及构建/布局/绘制管道的其余部分驱动.可以构建其他构建所有者来管理屏幕外小部件树.",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    )
                  ]),
                  onSelectionChanged: _handleSelectionChanged);
            },
          ),
        ));
  }
}
