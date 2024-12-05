import 'package:immobilier_apk/scr/config/app/export.dart';

class BottomNavigationButton extends StatelessWidget {
  const BottomNavigationButton({
    Key? key,
    required this.function,
    required this.currentPage,
    required this.page,
    required this.label,
    required this.selectedIcon,
    required this.unselectedIcon,
  }) : super(key: key);
  final VoidCallback function;
  final int currentPage;
  final int page;
  final String label;
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
            Image(
              image: AssetImage(Assets.icons(
                  currentPage == page ? selectedIcon : unselectedIcon)),
              color: currentPage == page
                  ? AppColors.color500
                  : AppColors.textColor,
              height: 18.0,
            ),
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
