import 'package:cached_network_image/cached_network_image.dart';

void preCacheImages(Iterable<Uri> imageUrls) {
  for (Uri url in imageUrls) {
    String surl = url.toString();

    // we don't use it. This is purely for caching purposes
    CachedNetworkImage(imageUrl: surl);
  }
}

void evictAllFromCache(Iterable<Uri> imageUrls) {
  for (Uri url in imageUrls) {
    String surl = url.toString();
    CachedNetworkImage.evictFromCache(surl);
  }
}