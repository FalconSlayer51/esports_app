import 'package:cloud_firestore/cloud_firestore.dart';

class Tournament {
  final String id;
  final String name;
  final String description;
  final String organizerId;
  final String status;
  final List<String> teamsRegistered;
  final DateTime startDate;
  final DateTime endDate;
  final int prizePool;

  Tournament({
    required this.id,
    required this.name,
    required this.description,
    required this.organizerId,
    required this.status,
    required this.teamsRegistered,
    required this.startDate,
    required this.endDate,
    required this.prizePool,
  });

  factory Tournament.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Tournament(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      organizerId: data['organizerId'] ?? '',
      status: data['status'] ?? 'upcoming',
      teamsRegistered: List<String>.from(data['teamsRegistered'] ?? []),
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      prizePool: data['prizePool'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'organizerId': organizerId,
      'status': status,
      'teamsRegistered': teamsRegistered,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'prizePool': prizePool,
    };
  }
}
