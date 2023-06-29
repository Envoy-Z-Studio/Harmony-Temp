import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/ui/navigator.dart';
import 'package:harmonymusic/ui/screens/playlistnalbum_screen_controller.dart';
import 'package:harmonymusic/ui/widgets/create_playlist_dialog.dart';
import 'package:harmonymusic/ui/widgets/list_widget.dart';
import 'package:harmonymusic/ui/widgets/shimmer_widgets/song_list_shimmer.dart';
import 'package:harmonymusic/ui/widgets/snackbar.dart';
import 'package:harmonymusic/ui/widgets/sort_widget.dart';

import '../../models/playlist.dart';
import '../player/player_controller.dart';
import '../widgets/image_widget.dart';

class PlaylistNAlbumScreen extends StatelessWidget {
  ///PlaylistScreen renders playlist content
  ///
  ///Playlist title,image,songs
  const PlaylistNAlbumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;

    final dynamic content = args != null
        ? (args[0] as bool ? args[1] : args[1] as Playlist)
        : Get.find<PlayListNAlbumScreenController>().contentRenderer;

    final PlayListNAlbumScreenController playListNAlbumScreenController =
        (args == null)
            ? Get.find<PlayListNAlbumScreenController>()
            : Get.put(
                PlayListNAlbumScreenController(content, args[0], args[2]));

    return SizedBox(
      child: Row(
        children: [
          NavigationRail(
            leading: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Theme.of(context).textTheme.titleMedium!.color,
                  ),
                  onPressed: () {
                    Get.nestedKey(ScreenNavigationSetup.id)!
                        .currentState!
                        .pop();
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            selectedIndex: 0, //_selectedIndex,
            minWidth: 60,
            labelType: NavigationRailLabelType.all,
            destinations: <NavigationRailDestination>[
              railDestination("Songs"),
              railDestination(""),
            ],
            // selectedIconTheme: IconThemeData(color: Colors.white)
          ),
          Obx(() => playListNAlbumScreenController.isContentFetched.isFalse
              ? const Expanded(
                  child: Center(
                  child: RefreshProgressIndicator(),
                ))
              : Expanded(
                  child: Container(
                  color: Theme.of(context).canvasColor,
                  padding: const EdgeInsets.only(top: 73, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 120,
                            child: Text(
                              playListNAlbumScreenController
                                  .contentRenderer.title,
                              style: Theme.of(context).textTheme.titleLarge,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          (playListNAlbumScreenController.isAlbum.isFalse &&
                                  !content.isCloudPlaylist &&
                                  content.playlistId != "LIBFAV" &&
                                  content.playlistId != "SongsCache" &&
                                  content.playlistId != "LIBRP")
                              ? IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: Get.find<PlayerController>()
                                          .homeScaffoldkey
                                          .currentState!
                                          .context,
                                      barrierColor:
                                          Colors.transparent.withAlpha(100),
                                      builder: (context) => SizedBox(
                                        height: 140,
                                        child: Column(
                                          children: [
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.edit_rounded),
                                              title:
                                                  const Text("Rename playlist"),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      CreateNRenamePlaylistPopup(
                                                          renamePlaylist: true,
                                                          playlist: content),
                                                );
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.delete_rounded),
                                              title:
                                                  const Text("Remove playlist"),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                Get.nestedKey(
                                                        ScreenNavigationSetup
                                                            .id)!
                                                    .currentState!
                                                    .pop();
                                                playListNAlbumScreenController
                                                    .addNremoveFromLibrary(
                                                        content,
                                                        add: false)
                                                    .then((value) => ScaffoldMessenger
                                                            .of(context)
                                                        .showSnackBar(snackbar(
                                                            context,
                                                            value
                                                                ? "Playlist removed!"
                                                                : "Operation failed",
                                                            size: SanckBarSize
                                                                .MEDIUM)));
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.more_vert_rounded))
                              : const SizedBox.shrink()
                        ],
                      ),
                      (playListNAlbumScreenController.isAlbum.isFalse &&
                              !content.isCloudPlaylist)
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: SizedBox.square(
                                  dimension: 200,
                                  child: Stack(
                                    children: [
                                      playListNAlbumScreenController
                                              .isAlbum.isTrue
                                          ? ImageWidget(
                                            size: 200,
                                              album:
                                                  playListNAlbumScreenController
                                                      .contentRenderer,
                                            )
                                          : ImageWidget(
                                            size: 200,
                                              playlist: content,
                                            ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                            onTap: () {
                                              final add =
                                                  playListNAlbumScreenController
                                                      .isAddedToLibrary.isFalse;
                                              playListNAlbumScreenController
                                                  .addNremoveFromLibrary(
                                                      content,
                                                      add: add)
                                                  .then((value) => ScaffoldMessenger
                                                          .of(context)
                                                      .showSnackBar(snackbar(
                                                          context,
                                                          value
                                                              ? add
                                                                  ? playListNAlbumScreenController
                                                                          .isAlbum
                                                                          .isTrue
                                                                      ? "Album bookmarked !"
                                                                      : "Playlist bookmarked!"
                                                                  : playListNAlbumScreenController
                                                                          .isAlbum
                                                                          .isTrue
                                                                      ? "Album bookmark removed!"
                                                                      : "Playlist bookmark removed!"
                                                              : "Operation failed",
                                                          size: SanckBarSize
                                                              .MEDIUM)));
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .canvasColor
                                                      .withOpacity(.7),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10))),
                                              child: Obx(() => Icon(
                                                  playListNAlbumScreenController
                                                          .isAddedToLibrary
                                                          .isFalse
                                                      ? Icons
                                                          .bookmark_add_rounded
                                                      : Icons
                                                          .bookmark_added_rounded)),
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .canvasColor
                                                    .withOpacity(.7),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            height: 27,
                                            width: 110,
                                            child: InkWell(
                                              onTap: () {
                                                Get.find<PlayerController>()
                                                    .enqueueSongList(
                                                        playListNAlbumScreenController
                                                            .songList
                                                            .toList())
                                                    .whenComplete(() =>
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(snackbar(
                                                                context,
                                                                "Songs enqueued!",
                                                                size: SanckBarSize
                                                                    .MEDIUM)));
                                              },
                                              child: const Center(
                                                  child: Text(
                                                "Enqueue all",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: (playListNAlbumScreenController
                                          .isAlbum.isFalse &&
                                      !content.isCloudPlaylist)
                                  ? 0
                                  : 10.0),
                          child: (playListNAlbumScreenController
                                      .isAlbum.isTrue ||
                                  (playListNAlbumScreenController
                                          .isAlbum.isFalse &&
                                      content.isCloudPlaylist))
                              ? Text(
                                  playListNAlbumScreenController.isAlbum.isTrue
                                      ? playListNAlbumScreenController
                                              .contentRenderer
                                              .artists[0]['name'] ??
                                          ""
                                      : content.description ?? "",
                                  style: Theme.of(context).textTheme.titleSmall,
                                )
                              : Obx(
                                  () => SortWidget(
                                      itemCountTitle:
                                          "${playListNAlbumScreenController.songList.length} songs",
                                      titleLeftPadding: 9,
                                      isDurationOptionRequired: true,
                                      onSort: (a, b, c, d) {
                                        playListNAlbumScreenController.onSort(
                                            a, c, d);
                                      }),
                                )),
                      (playListNAlbumScreenController.isAlbum.isFalse &&
                              !content.isCloudPlaylist)
                          ? const SizedBox.shrink()
                          : const Divider(),
                      (playListNAlbumScreenController.isAlbum.isFalse &&
                              !content.isCloudPlaylist)
                          ? const SizedBox.shrink()
                          : Obx(
                              () => SortWidget(
                                itemCountTitle:
                                    "${playListNAlbumScreenController.songList.length} songs",
                                titleLeftPadding: 9,
                                isDurationOptionRequired: true,
                                onSort: (a, b, c, d) {
                                  playListNAlbumScreenController.onSort(
                                      a, c, d);
                                },
                              ),
                            ),
                      Obx(() => playListNAlbumScreenController
                              .isContentFetched.value
                          ? Obx(() =>
                              playListNAlbumScreenController.songList.isNotEmpty
                                  ? ListWidget(
                                      playListNAlbumScreenController.songList
                                          .toList(),
                                      "Songs",
                                      true,
                                      isPlaylist: true,
                                      playlist: playListNAlbumScreenController
                                              .isAlbum.isFalse
                                          ? content as Playlist
                                          : null,
                                    )
                                  : Expanded(
                                      child: Center(
                                        child: Text("Empty playlist !",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall),
                                      ),
                                    ))
                          : const Expanded(child: SongListShimmer()))
                    ],
                  ),
                )))
        ],
      ),
    );
  }

  NavigationRailDestination railDestination(String label) {
    return NavigationRailDestination(
      icon: const SizedBox.shrink(),
      label: RotatedBox(quarterTurns: -1, child: Text(label)),
    );
  }
}
