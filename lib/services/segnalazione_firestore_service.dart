import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/segnalazione.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';


class SegnalazioneService {
  final db = FirebaseFirestore.instance;

  String generateId() {
    return db.collection("segnalazioni").doc().id;
  }

  Future<void> createSegnalazione(Segnalazione segnalazione) async {
    await db.collection("segnalazioni").doc(segnalazione.idNotifica).set(segnalazione.toJson());
  }

  Future<Segnalazione?> getSegnalazione(String id) async {
    final doc = await db.collection("segnalazioni").doc(id).get();
    if (!doc.exists) return null;
    return Segnalazione.fromJson(doc.id, doc.data()!);
  }

  Future<List<Segnalazione>> getSegnalazioniByUserAndDatePeriod(String email) async {
    final nowString = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());
    final now = DateTime.now();
    final oneMonthAgo = DateTime(now.year, now.month - 1, now.day, now.hour, now.minute);
    final minorLimitCheckString = DateFormat("yyyy-MM-dd HH:mm").format(oneMonthAgo);
    final querySnapshot = await db
        .collection("segnalazioni")
        .where("apertaDa.email", isEqualTo: email)
        //.where("dataOraApertura", isGreaterThanOrEqualTo: minorLimitCheckString)
        //.where("dataOraApertura", isLessThanOrEqualTo: nowString)
        .get();
    if (querySnapshot.docs.isEmpty) return [];
    return querySnapshot.docs
      .map((doc) => Segnalazione.fromJson(doc.id, doc.data()))
      .toList();
}


  Stream<Segnalazione?> getSegnalazioneStream(String id) {
    return db.collection("segnalazioni").doc(id).snapshots().map((snap) {
      if (!snap.exists) return null;
      return Segnalazione.fromJson(snap.id, snap.data()!);
    });
  }

  Future<void> updateSegnalazione(String id, Map<String, dynamic> data) async {
    await db.collection("segnalazioni").doc(id).update(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSegnalazioniStream() {
    return db.collection('segnalazioni').snapshots();
  }


  uture<Uint8List> blurMedia(File file) async {
  final uri = Uri.parse("http://127.0.0.1:8000/blur"); //SERVICE MOCKATO PER IL BLUR DEI FILE

  final request = http.MultipartRequest('POST', uri);

  request.files.add(
    await http.MultipartFile.fromPath(
      'file',                  
      file.path,
      filename: basename(file.path),
    ),
  );

  final response = await request.send();

  if (response.statusCode != 200) {
    throw Exception("Errore blur: ${response.statusCode}");
  }

  return await response.stream.toBytes();
}

}
