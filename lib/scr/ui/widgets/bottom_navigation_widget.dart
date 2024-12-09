import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home/home_page.dart';

class MBottomNavigationBar extends StatelessWidget {
  const MBottomNavigationBar({
    required this.ready,
    required this.pageController,
    required this.currentPage,
  });

  final RxBool ready;
  final PageController pageController;
  final RxInt currentPage;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 70,
        width: Get.width,
        decoration: BoxDecoration(
            color: AppColors.background,
            border: const Border(
                top: BorderSide(
                    color: Color.fromARGB(31, 255, 255, 255), width: .6))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomNavigationButton(
              news: HomePage.newQuestionnaires.value,
              function: () {
                pageController.animateToPage(0,
                    duration: 333.milliseconds, curve: Curves.decelerate);
                currentPage.value = 0;
              },
              currentPage: currentPage.value,
              page: 0,
              label: 'Accuiel',
              selectedIcon: 'questionnaires.png',
              unselectedIcon: 'questionnaires.png',
            ),
            BottomNavigationButton(
              news: HomePage.newQuestionsArdoise.value,
              function: () {
                pageController.animateToPage(1,
                    duration: 333.milliseconds, curve: Curves.decelerate);
                currentPage.value = 1;
              },
              currentPage: currentPage.value,
              page: 1,
              label: 'Ardoise',
              selectedIcon: 'ardoise.png',
              unselectedIcon: 'ardoise.png',
            ),
            BottomNavigationButton(
              news: 0,
              function: () {
                pageController.animateToPage(2,
                    duration: 333.milliseconds, curve: Curves.decelerate);
                currentPage.value = 2;
              },
              currentPage: currentPage.value,
              page: 2,
              label: 'Compte',
              selectedIcon: 'account_s.png',
              unselectedIcon: 'account_us.png',
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavigationButton extends StatelessWidget {
  const BottomNavigationButton(
      {Key? key,
      required this.function,
      required this.currentPage,
      required this.page,
      required this.label,
      required this.selectedIcon,
      required this.unselectedIcon,
      required this.news})
      : super(key: key);
  final VoidCallback function;
  final int currentPage;
  final int page;
  final String label;
  final news;
  final selectedIcon;
  final unselectedIcon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        width: Get.width / 5,
        height: 60,
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 12.0, left: 12, right: 12),
                  child: Image(
                    image: AssetImage(Assets.icons(
                        currentPage == page ? selectedIcon : unselectedIcon)),
                    color: currentPage == page
                        ? AppColors.color500
                        : AppColors.textColor,
                    height: 18.0,
                  ),
                ),
                news <= 0
                    ? 0.h
                    : Container(
                        height: 20,
                        width: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.amberAccent, shape: BoxShape.circle),
                        child: EText(
                         news.toString(),
                          color: Colors.black,
                        ),
                      )
              ],
            ),
            3.h,
            EText(label,
                color: currentPage == page
                    ? AppColors.color500
                    : AppColors.textColor,
                font: Fonts.poppins,
                weight: FontWeight.w500,
                size: 18)
          ],
        ),
      ),
    );
  }
}
