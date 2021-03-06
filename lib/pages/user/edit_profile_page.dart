///
/// [Author] Alex (https://github.com/AlexVincent525)
/// [Date] 2020/5/22 15:38
///
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:openjmu/constants/constants.dart';

@FFRoute(name: 'openjmu://edit-profile-page', routeName: '编辑资料页')
class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController signatureController = TextEditingController(
    text: currentUser.signature ?? '快来填写你的签名吧~',
  );

  final Widget saveButton = IconButton(
    icon: Icon(Icons.save),
    onPressed: () {},
  );

  /// Avatar backdrop widget.
  /// 头像背景部件
  List<Widget> get avatarBackdrop => <Widget>[
        SizedBox.expand(
          child: Image(
            image: UserAPI.getAvatarProvider(),
            fit: BoxFit.fitWidth,
          ),
        ),
        BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: Color.fromARGB(120, 50, 50, 50),
          ),
        ),
      ];

  /// Avatar picker widget.
  /// 头像选择部件
  Widget get avatarPicker => Center(
        child: ClipOval(
          child: SizedBox.fromSize(
            size: Size.square(116.0.w),
            child: GestureDetector(
              onTap: () {
                navigatorState.pushNamed(Routes.openjmuImageCrop);
              },
              child: Stack(
                children: <Widget>[
                  UserAPI.getAvatar(size: 116.0),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white54,
                          width: 5.0.w,
                        ),
                        color: Colors.black45,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.photo_camera,
                        size: 48.0.w,
                        color: Colors.white60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  /// Section widget.
  /// 区域部件
  Widget sectionWidget({
    @required String title,
    @required Widget child,
  }) {
    return Container(
      margin: EdgeInsets.only(
        top: 30.0.h,
        bottom: 6.0.h,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 30.0.w,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 18.0.sp),
          ),
          SizedBox(height: 10.0.h),
          DefaultTextStyle(
            style: context.themeData.textTheme.bodyText2.copyWith(
              fontSize: 22.sp,
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FixedAppBarWrapper(
        appBar: FixedAppBar(
          title: Text('${currentUser.name}的个人资料'),
          actions: <Widget>[saveButton],
        ),
        body: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 250.w,
              child: ClipRect(
                child: Stack(
                  children: <Widget>[
                    ...avatarBackdrop,
                    avatarPicker,
                  ],
                ),
              ),
            ),
            sectionWidget(
              title: '个性签名',
              child: TextField(
                controller: signatureController,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: currentThemeColor),
                  ),
                  contentPadding: EdgeInsets.only(bottom: 6.0.h),
                  isDense: true,
                ),
                scrollPadding: EdgeInsets.zero,
              ),
            ),
            sectionWidget(
              title: '性别',
              child: Text(
                currentUser.genderText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
