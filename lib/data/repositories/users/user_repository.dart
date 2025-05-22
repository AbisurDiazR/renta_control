// ignore_for_file: await_only_futures

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:renta_control/domain/models/user/user.dart';

class UserRepository {
  final CollectionReference _usersCollection = FirebaseFirestore.instance
      .collection("users");
  final String? _firebaseUrl = dotenv.env['FIREBASE_API'];

  Stream<List<User>> fetchUsers() {
    return _usersCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return User.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> addUser(User user) async {
    final url = Uri.parse('$_firebaseUrl/users');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": user.name,
          "email": user.email,
          "password": user.password,
        }),
      );

      if (response.statusCode == 201) {
        await fetchUsers(); // Refresh the user list
      } else {
        throw Exception('Error al agregar el usuario: ${response.body}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateUser(User user) async {
    final url = Uri.parse('$_firebaseUrl/users/${user.id}');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toMap()),
      );

      if (response.statusCode == 200) {
        await fetchUsers(); // Refresh the user list
      } else {
        throw Exception('Error al actualizar el usuario: ${response.body}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteUser(String id) async {
    final url = Uri.parse('$_firebaseUrl/users/$id');
    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        await fetchUsers(); // Refresh the user list
      } else {
        throw Exception('Error al eliminar el usuario: ${response.body}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
