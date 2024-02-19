class Etudiant {
  late String name;
  Etudiant.FromJson(dynamic jsonData) {
    name = jsonData['nom'];
  }
  Map<String, String> etudiantToJson() {
    Map<String, String> map = {};
    map["name"] = name;
    return map;
  }
}
