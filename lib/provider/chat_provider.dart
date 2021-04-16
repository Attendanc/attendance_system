import 'package:flutter/widgets.dart';
import 'package:graduation_project/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatProvider extends ChangeNotifier {
  bool _isLoading;
  List<Message> _messages;

  bool get isLoading => _isLoading;
  List<Message> get messages => _messages;

  Future<Map<String, dynamic>> fetchMessages() async {
    final Map<String, dynamic> result = {'success': false, 'error': null};
    List<Message> messagesList = [];

    _isLoading = true;
    notifyListeners();

    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('messages')
          .orderBy('date')
          .get()
          .catchError((error) {
        result['error'] = error;
      });

      snapshot.docs.forEach((value) {
        final mes = Message(
            sender: value.get('sender'),
            date: value.get('date'),
            message: value.get('message'));

        messagesList.add(mes);
      });

      result['success'] = true;
      _messages = messagesList;
    } catch (error) {
      result['error'] = error;
    }
    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<Map<String, dynamic>> addMessage(
      String sender, String date, String message) async {
    final Map<String, dynamic> result = {'success': false, 'error': null};

    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection('messages')
          .add({'sender': sender, 'date': date, 'message': message})
          .then((value) => {result['success'] = true})
          .catchError((_) {
            result['error'] = _;
          });
    } catch (error) {
      result['error'] = error;
    }
    _isLoading = false;
    notifyListeners();
    return result;
  }
}
