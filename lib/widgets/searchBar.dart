import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    @required this.controller,
    @required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xffefefef),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding:  EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 0.5,
          ),
          child: Row(
            children: [
              new SizedBox(width: 5,),
              Icon(
                FontAwesomeIcons.search,
                color: Colors.black,
                 size: 20,
              ),
              new SizedBox(width: 5,),
              Expanded(
                child: TextField(
                  onChanged: (c){
                    setState(() {

                    });
                  },
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  cursorWidth: 1.5,
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  style: GoogleFonts.montserrat(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "  Search",
                    hintStyle: GoogleFonts.montserrat(color: Colors.black38,fontWeight: FontWeight.w400),
                    border: InputBorder.none,
                  ),
                ),
              ),
              widget.controller.text.isEmpty?new Container():GestureDetector(
                child: new IconButton(icon: Icon(
                  FontAwesomeIcons.timesCircle,
                  color: Colors.black54,
                  size: 20,
                ),onPressed: (){
                  setState(() {

                  widget.controller.clear();
                  FocusScope.of(context).unfocus();
                  });
              })
              ),
              new SizedBox(width: 5,),

            ],
          ),
        ),
      ),
    );
  }
}