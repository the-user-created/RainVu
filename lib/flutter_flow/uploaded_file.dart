import "dart:convert";
import "dart:typed_data" show Uint8List;

class FFUploadedFile {
  const FFUploadedFile({
    this.name,
    this.bytes,
    this.height,
    this.width,
    this.blurHash,
  });

  factory FFUploadedFile.deserialize(final String val) {
    final serializedData = jsonDecode(val) as Map<String, dynamic>;
    final Map<String, dynamic> data = {
      "name": serializedData["name"] ?? "",
      "bytes": serializedData["bytes"] ?? Uint8List.fromList([]),
      "height": serializedData["height"],
      "width": serializedData["width"],
      "blurHash": serializedData["blurHash"],
    };
    final List<dynamic> byteList =
        data["bytes"] is List ? data["bytes"] as List<dynamic> : [];
    return FFUploadedFile(
      name: data["name"] as String,
      bytes: Uint8List.fromList(byteList.cast<int>()),
      height: data["height"] as double?,
      width: data["width"] as double?,
      blurHash: data["blurHash"] as String?,
    );
  }

  final String? name;
  final Uint8List? bytes;
  final double? height;
  final double? width;
  final String? blurHash;

  @override
  String toString() =>
      "FFUploadedFile(name: $name, bytes: ${bytes?.length ?? 0}, height: $height, width: $width, blurHash: $blurHash,)";

  String serialize() => jsonEncode(
        {
          "name": name,
          "bytes": bytes,
          "height": height,
          "width": width,
          "blurHash": blurHash,
        },
      );

  @override
  int get hashCode => Object.hash(
        name,
        bytes,
        height,
        width,
        blurHash,
      );

  @override
  bool operator ==(final Object other) =>
      other is FFUploadedFile &&
      name == other.name &&
      bytes == other.bytes &&
      height == other.height &&
      width == other.width &&
      blurHash == other.blurHash;
}
