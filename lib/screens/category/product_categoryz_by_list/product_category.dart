import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ProductCategory extends Equatable {
  final String name;
  final String image;
  final Color color;
  final IconData icon;

  const ProductCategory({
    required this.name,
    required this.image,
    required this.color,
    required this.icon,
  });

  @override
  List<Object?> get props => [name, image, color, icon];
}