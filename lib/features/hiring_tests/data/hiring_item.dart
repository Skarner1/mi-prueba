class HiringItem {
  final int id;
  final String marca;
  final String sucursal;
  final String aspirante;
  final String cedula;

  HiringItem({
    required this.id,
    required this.marca,
    required this.sucursal,
    required this.aspirante,
    required this.cedula,
  });

  factory HiringItem.fromJson(Map<String, dynamic> json) {
    return HiringItem(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      marca: json['marca']?.toString() ?? '',
      sucursal: json['sucursal']?.toString() ?? '',
      aspirante: json['aspirante']?.toString() ?? '',
      cedula: json['cedula']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'marca': marca,
    'sucursal': sucursal,
    'aspirante': aspirante,
    'cedula': cedula,
  };
}