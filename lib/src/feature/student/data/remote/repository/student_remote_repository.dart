// Интерфейс
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class StudentRemoteRepository {
  Future<void> addStudent(Map<String, dynamic> data);
  Future<bool> isTodayValidOrderDay(String schoolId);
}

// Реализация
class StudentRepositoryImpl extends StudentRemoteRepository {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

  
  
  static const String STUDENT_COLLECTION = 'Student';
  static const String SCHOOL_COLLECTION = 'School';
  
  @override
  Future<void> addStudent(Map<String, dynamic> data) async {
    try {
      await firestore.collection(STUDENT_COLLECTION).add(data);
    } catch (e) {
      // Обработка исключения
      rethrow;
    }
  }

  @override
  Future<bool> isTodayValidOrderDay(String schoolId) async {
    try {
      DocumentSnapshot documentSnapshot = 
          await firestore.collection(SCHOOL_COLLECTION).doc(schoolId).get();
          
      if (!documentSnapshot.exists) {
        return false;
      }
      
      bool isSchoolActive = documentSnapshot['is active'];
      int weekdayValue = DateTime.now().weekday;
      int openDate = documentSnapshot['open date'].toInt();
      int closeDate = documentSnapshot['close date'].toInt();
      
      if (isSchoolActive) {
        if (openDate <= closeDate) {
          return openDate <= weekdayValue && weekdayValue <= closeDate;
        } else {
          return weekdayValue >= openDate || weekdayValue <= closeDate;
        }
      } else {
        return false;
      }
      
    } catch (e) {
      // Обработка исключения
      rethrow;
    }
  }
}
