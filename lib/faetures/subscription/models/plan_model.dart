import 'package:flutter/material.dart';

/// Plan Model
/// Defines the data structure for subscription plans and their categories

/// Represents a single meta need item within a plan category
class PlanMetaNeedItem {
  final String description;

  PlanMetaNeedItem({
    required this.description,
  });
}

/// Represents a category within a subscription plan
class PlanCategory {
  final String name;
  final String? emoji;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final List<PlanMetaNeedItem>? metaNeedItems;

  PlanCategory({
    required this.name,
    this.emoji,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.metaNeedItems,
  });
}

/// Represents a complete subscription plan with all its details
class SubscriptionPlanModel {
  final String id;
  final String name;
  final String price;
  final List<PlanCategory> categories;

  SubscriptionPlanModel({
    required this.id,
    required this.name,
    required this.price,
    required this.categories,
  });
}

