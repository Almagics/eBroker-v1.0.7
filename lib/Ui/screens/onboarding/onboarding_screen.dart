import '../../../data/cubits/system/fetch_system_settings_cubit.dart';
import '../../../data/model/system_settings_model.dart';
import '../../../utils/AppIcon.dart';
import '../../../utils/Extensions/extensions.dart';
import '../../../utils/constant.dart';
import '../../../utils/hive_keys.dart';
import '../../../utils/responsiveSize.dart';
import '../../../utils/ui_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:rive/rive.dart';
import '../../../app/routes.dart';
import '../../../settings.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPageIndex = 0;
  int previousePageIndex = 0;
  double changedOnPageScroll = 0.5;
  double currentSwipe = 0;
  late int totalPages;
  Artboard? artboard;
  Artboard? artA;
  Artboard? artB;
  Artboard? artC;
  // late Artboard _riveArtBoard;
  SMIBool? isReverse;
  SMIBool? startA;
  SMIBool? startB;
  SMIBool? startC;
  StateMachineController? _controller;
  StateMachineController? _onboA;
  StateMachineController? _onboB;
  StateMachineController? _onboC;

  Map<String, dynamic> riveConfig = AppSettings.riveAnimationConfigurations;
  late var introAnimationConfig = riveConfig['introduction_screen'];

  //1
  late var artBoardFirst =
      riveConfig['introduction_screen'][0]['artboard_name'];
  late var stateMachineFirst =
      riveConfig['introduction_screen'][0]['state_machine'];
  late var booleanNameFirst =
      riveConfig['introduction_screen'][0]['boolean_name'];

//2
  late var artBoardSecond =
      riveConfig['introduction_screen'][1]['artboard_name'];
  late var stateMachineSecond =
      riveConfig['introduction_screen'][1]['state_machine'];
  late var booleanNameSecond =
      riveConfig['introduction_screen'][1]['boolean_name'];
//3
  late var artBoardThird =
      riveConfig['introduction_screen'][2]['artboard_name'];
  late var stateMachineThird =
      riveConfig['introduction_screen'][2]['state_machine'];
  late var booleanNameThird =
      riveConfig['introduction_screen'][2]['boolean_name'];

  @override
  void initState() {
    super.initState();
    initRiveAddButtonAnimation();
    // _onboA = SimpleAnimation("Timeline 1");
    // _onbob = SimpleAnimation("Timeline 1");
    // _onboc = SimpleAnimation("Timeline 1");
    // Constant.session.setBoolData(Session.keyIsIntroViewed, true, false);
  }

  void initRiveAddButtonAnimation() {
    ///Open file
    rootBundle
        .load("assets/riveAnimations/${Constant.riveAnimation}")
        .then((value) {
      ///Import that data to this method below
      RiveFile riveFile = RiveFile.import(value);

      ///artboard by name you can check https://rive.app and learn it for more information
      /// Here Add is artboard name from that workspace

      ///here we can change color of any shape, here 'shape' is name in rive.app file

      for (var art in riveFile.artboards) {
        art.fills.first.paint.color = Colors.transparent;
      }
      riveFile.artboards.first.forEachComponent((child) {
        if (child is Shape) {}
      });
      artA = riveFile.artboardByName(artBoardFirst);
      artB = riveFile.artboardByName(artBoardSecond);
      artC = riveFile.artboardByName(artBoardThird);

      ///in rive there is state machine to control states of animation, like. walking,running, and more
      ///click is state machine name
      _onboA = StateMachineController.fromArtboard(artA!, stateMachineFirst);
      _onboB = StateMachineController.fromArtboard(artB!, stateMachineSecond);
      _onboC = StateMachineController.fromArtboard(artC!, stateMachineThird);

      if (_onboA != null) {
        artboard?.addController(_controller!);

        artA?.addController(_onboA!);
        artB?.addController(_onboB!);
        artC?.addController(_onboC!);

        //this SMI means State machine input, we can create conditions in rive , so start is boolean value name from there
        startA = _onboA?.findSMI(booleanNameFirst);
        startB = _onboB?.findSMI(booleanNameSecond);
        startC = _onboC?.findSMI(booleanNameThird);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List slidersList = [
      {
        'artboard': artA,
        'title': UiUtils.getTranslatedLabel(context, "onboarding_1_title"),
        'description':
            UiUtils.getTranslatedLabel(context, "onboarding_1_description"),
        'button': 'next_button.svg'
      },
      {
        'artboard': artB,
        'title': UiUtils.getTranslatedLabel(context, "onboarding_2_title"),
        'description':
            UiUtils.getTranslatedLabel(context, "onboarding_2_description"),
      },
      {
        'artboard': artC,
        'title': UiUtils.getTranslatedLabel(context, "onboarding_3_title"),
        'description':
            UiUtils.getTranslatedLabel(context, "onboarding_3_description"),
      },
    ];

    totalPages = slidersList.length;
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: context.color.backgroundColor,
        body: Stack(
          children: <Widget>[
            Container(
              color: context.color.teritoryColor.withOpacity(0.25),
            ),
            Align(
                alignment: Alignment.center.add(const Alignment(0, -.3)),
                child: SizedBox(
                  height: 300,
                  child: slidersList[currentPageIndex]['artboard'] != null
                      ? Rive(
                          artboard: slidersList[currentPageIndex]['artboard'])
                      : Container(),
                )),
            PositionedDirectional(
                top: kPagingTouchSlop,
                start: 5,
                child: TextButton(
                    onPressed: () async {
                      context
                          .read<FetchSystemSettingsCubit>()
                          .fetchSettings(isAnonymouse: true);
                      Navigator.pushNamed(
                          context, Routes.languageListScreenRoute);
                    },
                    child: StreamBuilder(
                        stream: Hive.box(HiveKeys.languageBox)
                            .watch(key: HiveKeys.currentLanguageKey),
                        builder: (context, AsyncSnapshot<BoxEvent> value) {
                          if (value.data?.value == null) {
                            if (context
                                    .watch<FetchSystemSettingsCubit>()
                                    .getSetting(SystemSetting.defaultLanguage)
                                    .toString() ==
                                "null") {
                              return const Text("");
                            }
                            return Text(context
                                    .watch<FetchSystemSettingsCubit>()
                                    .getSetting(SystemSetting.defaultLanguage)
                                    .toString()
                                    .firstUpperCase())
                                .color(context.color.textColorDark);
                          } else {
                            return Text(value.data!.value!['code']
                                    .toString()
                                    .toString()
                                    .firstUpperCase())
                                .color(context.color.textColorDark);
                          }
                        }))),
            PositionedDirectional(
                top: kPagingTouchSlop,
                end: 5,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, Routes.login);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Icon(
                      Icons.close,
                      color: context.color.teritoryColor,
                    ),
                  ),
                )),
            Positioned(
              bottom: 0,
              child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  currentSwipe = details.localPosition.direction;
                  setState(() {});
                },
                onHorizontalDragEnd: (details) {
                  if (currentSwipe < 0.5) {
                    if (changedOnPageScroll == 1 ||
                        changedOnPageScroll == 0.5) {
                      if (currentPageIndex > 0) {
                        currentPageIndex--;
                        changedOnPageScroll = 0;
                      }
                    }
                    setState(() {});
                  } else {
                    if (currentPageIndex < totalPages) {
                      if (changedOnPageScroll == 0 ||
                          changedOnPageScroll == 0.5) {
                        if (currentPageIndex < slidersList.length - 1) {
                          currentPageIndex++;
                        } else {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              Routes.login, (route) => false);
                        }
                        setState(() {});
                      }
                    }
                  }

                  if (currentPageIndex == 1) {
                    startB?.value = true;
                  } else {
                    startC?.value = true;
                  }

                  changedOnPageScroll = 0.5;
                  setState(() {});
                },
                child: Container(
                  height: 304.rh(context),
                  width: context.screenWidth,
                  decoration: BoxDecoration(
                    color: context.color.primaryColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            slidersList[currentPageIndex]['title'],
                            key: const Key("onboarding_title"),
                          )
                              .size(context.font.extraLarge)
                              .color(context.color.teritoryColor)
                              .bold(weight: FontWeight.w600),
                        ),
                        Text(
                          slidersList[currentPageIndex]['description'],
                          textAlign: TextAlign.center,
                        )
                            .setMaxLines(lines: 3)
                            .size(context.font.larger)
                            .color(context.color.textColorDark),
                        const Spacer(),
                        Row(
                          children: [
                            Row(children: [
                              for (var i = 0; i < slidersList.length; i++) ...[
                                buildIndicator(context,
                                    selected: i == currentPageIndex)
                              ],
                            ]),
                            const Spacer(),
                            GestureDetector(
                              key: const ValueKey("next_screen"),
                              onTap: () {
                                if (currentPageIndex < slidersList.length - 1) {
                                  currentPageIndex++;
                                } else {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      Routes.login, (route) => false);
                                }
                                setState(() {});

                                if (currentPageIndex == 1) {
                                  startB?.value = true;
                                } else {
                                  startC?.value = true;
                                }
                              },
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor: context.color.teritoryColor,
                                child: UiUtils.getSvg(AppIcons.iconArrowLeft),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildIndicator(BuildContext context, {required bool selected}) {
    if (selected) {
      return Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          width: 36,
          height: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: context.color.teritoryColor,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(color: context.color.textLightColor, width: 1.9)),
        ),
      );
    }
  }
}
