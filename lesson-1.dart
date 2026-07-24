
void student_data() {
  String studentName = "Tarek Mohammed";
  int studentAge = 23;
  double studentGpa = 3.1;
  bool isGraduated = true;
  const String studentGender = "Male";
  final studentId = "ST2025";
  const studentUniversity = "Capital University";
  String? studentPhoneNumber;
  String? studentEmail = "tarekmohammedgg@gmail.com";
  print("Student Information");
  print("-------------------");

  print("Id: $studentId");
  print("Name: $studentName");
  print("Gender: $studentGender");
  print("Age: $studentAge");
  print("GPA: $studentGpa");
  if (isGraduated == true) {
    print("I graduated from $studentUniversity");
  } else {
    print("I am still studying at  $studentUniversity");
  }
  print("-------------------");
  print("Contact Info");
  print("-------------------");
  print("Email:$studentEmail");
  print("Phone: $studentPhoneNumber");
}

void main () {
  student_data() ; 
}
