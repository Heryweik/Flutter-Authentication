
class UserProfile {
  String? uid;
  String? name;
  String? pfpURL;

  // Constructor con parámetros requeridos
  UserProfile({
    required this.uid,
    required this.name,
    this.pfpURL = 'https://hospitalveterinariodonostia.com/wp-content/uploads/2020/10/gatos-854x427.png', // Valor por defecto para la imagen de perfil
  });

  // Método para convertir un Map<String, dynamic> a una instancia de UserProfile
  UserProfile.fromJson(Map<String, dynamic> json) { // dynamic es un tipo de dato que puede ser cualquier tipo de dato
    uid = json['uid'];
    name = json['name'];
    pfpURL = json['pfpURL'];
  }

  // Método para convertir una instancia de UserProfile a un Map<String, dynamic>
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['pfpURL'] = pfpURL;
    data['uid'] = uid;
    return data;
  }
}