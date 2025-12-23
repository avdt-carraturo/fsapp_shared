class Treno {
  final String codice;
  final String nCarrozze;
  final String dataOraPartenza;
  final String dataOraArrivo;
  final List<String> stazioni;
  final String? stazionePartenza;
  final String? stazioneArrivo;

  String get id => "${codice}_$dataOraPartenza";

  Treno({
    required this.codice,
    required this.nCarrozze,
    required this.dataOraPartenza,
    required this.dataOraArrivo,
    required this.stazioni,
    this.stazionePartenza,
    this.stazioneArrivo
  });

  Map<String, dynamic> toJson() => {
        'codice': codice,
        'nCarrozze': nCarrozze,
        'dataOraPartenza': dataOraPartenza,
        'dataOraArrivo': dataOraArrivo,
        'stazioni': stazioni,
        'stazionePartenza': stazionePartenza,
        'stazioneArrivo': stazioneArrivo

      };

  factory Treno.fromJson(String id, Map<String, dynamic> json) {
    return Treno(
      codice: json['codice'],
      dataOraPartenza: json['dataOraPartenza'],
      nCarrozze: json['nCarrozze'],
      dataOraArrivo: json['dataOraArrivo'],
      stazioni: List<String>.from(json['stazioni'] ?? []),
      stazionePartenza: json['stazionePartenza'],
      stazioneArrivo: json['stazioneArrivo']
    );
  }

  factory Treno.fromJsonNoId(Map<String, dynamic> json) {
    return Treno(
      codice: json['codice'],
      dataOraPartenza: json['dataOraPartenza'],
      nCarrozze: json['nCarrozze'],
      dataOraArrivo: json['dataOraArrivo'],
      stazioni: List<String>.from(json['stazioni'] ?? []),
      stazionePartenza: json['stazionePartenza'],
      stazioneArrivo: json['stazioneArrivo']
    );
  }
}
