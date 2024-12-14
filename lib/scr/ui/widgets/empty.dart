
import 'package:immobilier_apk/scr/config/app/export.dart';

class Empty extends StatelessWidget {
  const Empty({super.key, required this.constraints});
  final constraints;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: EColumn(
          crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Image(
          image: AssetImage(Assets.image("empty.png")),
          width: constraints.maxWidth * .6,
        ),
        12.h,
        EText(
          "Rien trouvé",
          size: 24,
        )
      ],
    ));
  }
}
