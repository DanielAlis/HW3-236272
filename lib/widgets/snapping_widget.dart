import 'package:flutter/material.dart';
import 'package:hello_me/widgets/snackbar_widget.dart';
import 'package:provider/provider.dart';
import '../providers/user_notifier.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;

class SnappingWidget extends StatefulWidget {
  const SnappingWidget({Key? key}) : super(key: key);

  @override
  State<SnappingWidget> createState() => _SnappingWidgetState();
}

class _SnappingWidgetState extends State<SnappingWidget> {
  bool _toBlur = false;
  SnappingSheetController snappingSheetController = SnappingSheetController();

  @override
  Widget build(BuildContext context) {
    Widget MyOwnGrabbingWidget() {
      return context
          .watch<UserNotifier>()
          .status == Status.Authenticated
          ? Container(
        padding: const EdgeInsets.all(16),
        color: Colors.grey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(child:
            Text(
              'Welcome back, ${context.read<UserNotifier>().getEmail()}',
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,

            ),
            ),
            const Icon(Icons.arrow_drop_up),
          ],
        ),
      ) : const SizedBox.shrink();
    }

    Widget MyOwnSheetContent() {
      return context
          .watch<UserNotifier>()
          .status != Status.Authenticated
          ? const SizedBox.shrink()
          :
      Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              context
                  .watch<UserNotifier>()
                  .userImage,
              const SizedBox(width: 9),
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(
                      '${context.read<UserNotifier>().getEmail()}',
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          XFile? result =
                          await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );
                          if (result == null) {
                            showSnackBar(context, 'No image selected');
                          } else {
                            await context
                                .read<UserNotifier>()
                                .changeAvatar(result.path);
                          }
                        },
                        child: const Text('Change avatar'))
                  ],
                ),
              ),
            ],
          ),
        ),

      );
    }

    return BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: (context
              .watch<UserNotifier>()
              .status == Status.Authenticated && _toBlur) ? 5.0 : 0,
          sigmaY: (context
              .watch<UserNotifier>()
              .status == Status.Authenticated && _toBlur) ? 5.0 : 0,
        ),
        child: SnappingSheet(
          controller: snappingSheetController,
          onSheetMoved: (sheetPosition) {
            if (sheetPosition.pixels > 25.0) {
              setState(() {
                _toBlur = true;
              });
            }
            else {
              setState(() {
                _toBlur = false;
              });
            }
          },
          snappingPositions: const [
            SnappingPosition.factor(
              positionFactor: 0,
              snappingCurve: Curves.easeOutExpo,
              grabbingContentOffset: GrabbingContentOffset.top,
            ),
            SnappingPosition.pixels(
              positionPixels: 130,
              snappingCurve: Curves.elasticOut,
              snappingDuration: Duration(milliseconds: 1750),
            ),
          ],
          grabbingHeight: 50,
          grabbing: GestureDetector(
            onTap: () {
              if (snappingSheetController.isAttached) {
                if (snappingSheetController.currentPosition == 130) {
                  snappingSheetController
                      .snapToPosition(const SnappingPosition.factor(
                    positionFactor: 0,
                    snappingCurve: Curves.easeOutExpo,
                    grabbingContentOffset: GrabbingContentOffset.top,
                  ));
                } else {
                  snappingSheetController
                      .snapToPosition(const SnappingPosition.pixels(
                    positionPixels: 130,
                    snappingCurve: Curves.elasticOut,
                    snappingDuration: Duration(milliseconds: 1500),
                  ));
                }
              }
            },
            child: MyOwnGrabbingWidget(),
          ),
          sheetBelow: SnappingSheetContent(
            draggable: true,
            child: MyOwnSheetContent(),
          ),
        ));
  }
}

