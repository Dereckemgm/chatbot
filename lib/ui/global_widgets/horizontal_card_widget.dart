import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../config/app_theme.dart';

class HorizontalCardWidget extends StatelessWidget {
  final String imageUrl;
  const HorizontalCardWidget({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(9),
      child: SizedBox(
        width: 208,
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    imageUrl,
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'icons/play_icon.svg',
                  ),
                ),
              ],
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Top Trending Islands in 2023',
                    style: MyTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      // IconButton(
                      //   onPressed: null,
                      //   icon: SvgPicture.asset(
                      //     'assets/icons/eye_icon.svg',
                      //   ),
                      // ),
                      const Icon(
                        Icons.remove_red_eye_outlined,
                        color: MyTheme.cursorColor,
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '40,999',
                        style: MyTheme.subtitleMedium,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
