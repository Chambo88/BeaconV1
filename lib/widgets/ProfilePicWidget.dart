import 'package:beacon/models/UserModel.dart';
import 'package:beacon/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';


//Todo need to create two different versions of Prof pic
///One should be cahced the other not, no point in caching prof pics when searching
///users that arn't your friends for example
///Shoul also user CachedImage instead of CachedImageProvider so we can generate a loading wdget
///need to use something other then circleavatar then..
class ProfilePicture extends StatelessWidget {
  final VoidCallback onClicked;
  final FigmaColours figmaColours = FigmaColours();
  final double size;
  final UserModel user;
  String url = '';
  static CacheManager customCacheManager = CacheManager(
      Config(
          'customCacheKey',
          stalePeriod: Duration(days: 2),
          maxNrOfCacheObjects: 120
      )
  );

  ProfilePicture({
    this.onClicked,
    this.size = 24,
    @required this.user,
  });

  @override
  Widget build(BuildContext context) {
    if(user.imageURL != null) {
      url = user.imageURL;
    }
    return GestureDetector(
        onTap: onClicked ?? null,
        child: getImage()
    );
  }


  CircleAvatar getImage() {
    if (url == '') {


      return CircleAvatar(
        radius: size,
        child: Text(
          '${user.firstName[0].toUpperCase()}${user.lastName[0].toUpperCase()}',
          style: TextStyle(
            color: Color(figmaColours.greyMedium),
          ),
        ),
        backgroundColor: Color(figmaColours.greyLight),
      );
    } else {

      return CircleAvatar(
        radius: size,
        backgroundImage: CachedNetworkImageProvider(
            user.imageURL,
          cacheManager: customCacheManager,
        ),
      );
    }
  }
}