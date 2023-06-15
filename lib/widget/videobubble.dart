import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

class Videobubble extends StatefulWidget {
  bool isCurrentUser;
  String videourl;
  String time;
 Videobubble({super.key,required this.videourl,required this.isCurrentUser,required this.time});

  @override
  State<Videobubble> createState() => _VideobubbleState();
}

class _VideobubbleState extends State<Videobubble> {
  @override
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videourl.toString())
      ..initialize().then((value) => setState(() {}));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
    );
    
  }
  Widget build(BuildContext context) {
    return Padding(
    
      padding: EdgeInsets.fromLTRB(
        widget.isCurrentUser ? 64.0 : 16.0,
        4,
        widget.isCurrentUser ? 16.0 : 64.0,
        4,
      ),
        child: Align(
          alignment: widget.isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
          child:Column(
            crossAxisAlignment: widget.isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                height: MediaQuery.of(context).size.height/2.6,
                width: MediaQuery.of(context).size.width/1.6 ,
                child:CustomVideoPlayer(customVideoPlayerController: _customVideoPlayerController), 
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2.5,color: widget.isCurrentUser ?  Color(0xff35bc90) :Color(0xff21b7f3)),
                ),
              ),
              Text(widget.time.toString())
            ],
          )
    ),
    
        );
    
  }
}