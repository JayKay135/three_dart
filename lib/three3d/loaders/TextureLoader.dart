part of three_loaders;

class TextureLoader extends Loader {

  TextureLoader(manager) : super(manager);

  @override
  Future<Texture> loadAsync(url, [Function? onProgress]) async {
    var completer = Completer<Texture>();

    load(url, (texture) {
      completer.complete(texture);
    }, onProgress, () {});

    return completer.future;
  }

  @override
  load(url, Function onLoad, [Function? onProgress, Function? onError]) {
    Texture texture;
    texture = Texture();

    var loader = ImageLoader(manager);
    loader.setCrossOrigin(crossOrigin);
    loader.setPath(path);

    var completer = Completer<Texture>();
    loader.flipY = flipY;
    loader.load(url, (image) {
      ImageElement imageElement;

      // Web better way ???
      if (kIsWeb && image is! Image) {
        imageElement = ImageElement(
            url: url is Blob ? "" : url,
            data: image,
            width: image.width!.toDouble(),
            height: image.height!.toDouble());
      } else {
        image = image as Image;
        image = image.convert(format:Format.uint8,numChannels: 4);

        // print(" _pixels : ${_pixels.length} ");
        // print(" ------------------------------------------- ");
        imageElement = ImageElement(
            url: url,
            data: Uint8Array.from(image.getBytes()),
            width: image.width,
            height: image.height);
      }

      // print(" image.width: ${image.width} image.height: ${image.height} isJPEG: ${isJPEG} ");

      texture.image = imageElement;
      texture.needsUpdate = true;

      onLoad(texture);

      completer.complete(texture);
    }, onProgress, onError);

    return completer.future;
  }
}
