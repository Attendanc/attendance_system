import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/model/message.dart';
import 'package:graduation_project/pages/chat_page/components/message_list_item.dart';
import 'package:graduation_project/pages/chat_page/components/send_button.dart';
import 'package:graduation_project/provider/chat_provider.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  User currentUser;
  String uid;
  String currentDate;
  List<Message> messages;

  @override
  void initState() {
    currentDate = DateTime.now().toIso8601String().toString();

    Provider.of<ChatProvider>(context, listen: false).fetchMessages();
    messages = Provider.of<ChatProvider>(context, listen: false).messages;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentUser = _auth.currentUser;
    uid = currentUser.uid;

    Widget content = Container(
      color: Colors.white,
    );

    Future<void> callback() async {
      if (controller.text.length > 0) {
        Provider.of<ChatProvider>(context, listen: false)
            .addMessage(uid, currentDate, controller.text);
      }

      setState(() async {
        await Provider.of<ChatProvider>(context, listen: false).fetchMessages();
        messages = Provider.of<ChatProvider>(context, listen: false).messages;

        controller.clear();

        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 3000),
            curve: Curves.easeOut);
      });
    }

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 3,
          ),
          Expanded(
              // ignore: missing_required_param
              child: Consumer<ChatProvider>(
            builder: (context, chats, child) {
              if (messages.length > 0) {
                content = ListView.builder(
                  itemCount: messages.length,
                  controller: scrollController,
                  itemBuilder: (context, i) {
                    return MessageItem(
                      sender: uid,
                      text: messages[i].message,
                    );
                  },
                );
              } else if (chats.isLoading) {
                content = Center(
                  child: Container(
                      color: Colors.white, child: CircularProgressIndicator()),
                );
              }
              return RefreshIndicator(
                  onRefresh: chats.fetchMessages, child: content);
            },
          )),
          SizedBox(
            height: 2,
          ),
          Container(
            margin: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "Enter Your Message",
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (value) => callback(),
                )),
                SizedBox(
                  width: 10,
                ),
                SendButton(text: "send", callback: callback),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
