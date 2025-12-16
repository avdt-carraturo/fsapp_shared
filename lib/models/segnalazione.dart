import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/treno.dart';
import '../models/utente.dart';

class Segnalazione {
  final String idNotifica;
  final String tipo;
  final Treno? treno;
  final String carrozza;
  final String dataOraApertura;
  final String? dataOraAggiornamento;
  final String stato;
  final String? note;
  final Utente apertaDa;

  /// URL del file multimediale (foto/video) salvato su Firebase Storage
  final String? mediaUrl;

  Segnalazione({
    required this.idNotifica,
    required this.tipo,
    this.treno,
    required this.carrozza,
    required this.dataOraApertura,
    this.dataOraAggiornamento,
    required this.stato,
    this.note,
    required this.apertaDa,
    this.mediaUrl,
  });

  Map<String, dynamic> toJson() => {
        "idNotifica": idNotifica,
        "tipo": tipo,
        "treno": treno?.toJson(),
        "carrozza": carrozza,
        "dataOraApertura": dataOraApertura,
        "dataOraAggiornamento": dataOraAggiornamento ?? "",
        "stato": stato,
        "note": note,
        "apertaDa": apertaDa.toJson(),
        "mediaUrl": mediaUrl ?? "",
      };

  factory Segnalazione.fromJson(String id, Map<String, dynamic> json) =>
      Segnalazione(
        idNotifica: id,
        tipo: json['tipo'],
        treno: Treno.fromJson(json['treno']?['codice'], json['treno']),
        carrozza: json['carrozza'],
        dataOraApertura: json['dataOraApertura'],
        dataOraAggiornamento: json['dataOraAggiornamento'],
        stato: json['stato'],
        note: json['note'],
        apertaDa: Utente.fromJson(json['apertaDa']?['email'], json['apertaDa']),
        mediaUrl: json['mediaUrl'],
      );
}